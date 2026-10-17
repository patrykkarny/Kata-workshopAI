/*
 * C4 model for the "Room with a View" kata, team White.
 * Source of truth for every decision: zadanie/notatki.md.
 * Style: service-based = five separately deployable domain services + one shared PostgreSQL database,
 * one schema per service. One platform for all hotels in the US region; a new hotel is configuration,
 * not code. Scales out per service (more instances only for the service that needs them), no autoscaling.
 * Every service runs at least two instances with rolling deploys, so a deploy never stops bookings or check-ins.
 * Services call each other over HTTPS; room-status events (room occupied / vacated, guest checked out,
 * room needed by, room ready / defect, arrivals) go through "room-status-events", shown as the arrow
 * label (point-to-point, so no broker box). The outbox is only for these room-status events: each
 * service writes them in its own schema, in the same transaction as its data; a managed cloud queue,
 * independent of our database, delivers them. Receivers drop duplicates by event ID.
 * Legacy has no API: Synchronizacja swaps files with it both ways every 15 min, plus a nightly full
 * comparison. Payment at booking is a pre-authorisation on an external payment operator's hosted page;
 * legacy settles the stay and refunds at checkout. Nothing in booking, check-in, checkout or cleaning
 * waits for legacy.
 * Render: ./zadanie/c4/render.sh   (outputs go to zadanie/c4/out/)
 */
workspace "Room with a View" "Specific-room booking, room status and housekeeping for 107 resort hotels." {

    !identifiers hierarchical

    model {
        # ---------- People (actors) ----------
        guest = person "Guest" "Views room photos and descriptions; books a room type or a specific room on web or mobile."
        hotelStaff = person "Hotel Staff" "Front desk (phone and walk-in bookings with a payment link, check-in / out), hotel manager (replacement rooms), housekeeping supervisor (cart queues)." "Internal"
        housekeeper = person "Housekeeping & Maintenance Staff" "Hotel staff on cleaning carts: clean and repair rooms in priority order." "Internal"

        # ---------- Our system ----------
        sys = softwareSystem "Room with a View" "Lets guests pick a specific room, keeps room-nights and room status, directs housekeeping by priority. Service-based, five services." {

            guestApp = container "Guest Web App" "Room photos and descriptions, availability; books a room type or a specific room; sends the guest to the payment operator's page." "TypeScript, React PWA" "WebBrowser"
            backOffice = container "Staff Back-office" "Phone and walk-in bookings on the same path as guests (phone: the guest gets a payment link), check-in / out, room board, cart queue panel." "TypeScript, React SPA" "WebBrowser"
            cartApp = container "Housekeeping Cart App" "Ordered room list with guest wishes and defects; works offline, sends updates when Wi-Fi is back." "Offline web app, IndexedDB" "Device"

            rezerwacje = container "Rezerwacje Service" "Board frame Rezerwacja + room availability and status: the only place that can take a room for a night (one transaction); holds the room 10 min while the guest pre-authorises the payment at the payment operator, confirmed by webhook; never waits for legacy; computes when every hotel room is needed next." "TypeScript, NestJS"
            housekeeping = container "Housekeeping Service" "Board frames Housekeeping + Servis tech: one queue for cleaning and repairs, priority from when the room is needed next; API for cart devices. Keeps its own copy of room status and room needed-by (events from Rezerwacje), so it works on the last known state while Rezerwacje is down." "TypeScript, NestJS"
            pobyt = container "Pobyt Service (Visit + Faraway)" "Board frames Visit + Faraway: check-in, checkout, replacement room, room complaints; keeps its own copy of today's arrivals and room status (events from Rezerwacje) and builds the reception emergency list from it every 15 min (file + e-mail); smart-lock adapter: lock-to-room mapping, issues and revokes mobile keys (guest: check-in to checkout; housekeeper: assigned room, for the task)." "TypeScript, NestJS"
            synchronizacja = container "Synchronizacja Service (legacy ACL)" "Board frame Synchronizacja: the only place that swaps files with legacy, both ways every 15 min. In: room pool we may sell, prices, non-pool bookings, check-ins and check-outs. Out: our pool bookings with guest data, check-ins / outs, payment pre-authorisation number. Numbered files, idempotent import, alert on a missing file; nightly full comparison (pool: we win, non-pool: legacy wins)." "TypeScript, NestJS"
            oferta = container "Oferta Service (Marketing)" "Board frame Marketing: room standard, features, photos, descriptions; read-only for the rest of the system." "TypeScript, NestJS"

            db = container "Shared Database" "Managed PostgreSQL, one schema per service; each service has its own DB user with access to its own schema only; replica in a second zone with automatic failover in 1-2 min; nightly backup + continuous log (point-in-time restore, 7 days)." "PostgreSQL (managed)" "Database"
            files = container "File Storage" "Room photos (delivered ready-made) and the emergency list for reception (arrivals, departures, room status; also e-mailed to reception), readable while our services are down." "Object storage + CDN" "Database"
        }

        # ---------- External systems ----------
        legacy = softwareSystem "Reservations System (legacy)" "Existing system: non-pool reservations, prices, stay settlement and refunds at checkout, cancellations, manager reports. No API, only file exchange. Blocks a room pool that only we sell." "External"
        lockPlatform = softwareSystem "Smart Lock Platform" "Lock vendor API: mobile keys that open doors from a phone. A key stored in the phone opens the lock even while our system is down; key cards at reception are the fallback." "External"
        paymentOperator = softwareSystem "Payment Operator" "External payment operator: hosted payment page, card pre-authorisation at booking. We never see card data." "External"
        idp = softwareSystem "Identity Provider" "Signs in guests and staff (OIDC: OpenID Connect)." "External"

        # ---------- Relationships: people ----------
        guest -> sys.guestApp "Browses, books" "HTTPS"
        hotelStaff -> sys.backOffice "Books, checks in / out" "HTTPS"
        housekeeper -> sys.cartApp "Gets tasks, reports done / defect" "Touch UI"

        # ---------- Relationships: front-ends ----------
        sys.guestApp -> sys.oferta "Reads rooms" "HTTPS"
        sys.guestApp -> sys.rezerwacje "Searches, books" "HTTPS"
        sys.backOffice -> sys.rezerwacje "Books, reads room board" "HTTPS"
        sys.backOffice -> sys.pobyt "Checks in / out" "HTTPS"
        sys.backOffice -> sys.housekeeping "Reorders cart queues" "HTTPS"
        sys.cartApp -> sys.housekeeping "Syncs task updates" "HTTPS"
        sys.housekeeping -> sys.cartApp "Pushes tasks" "WebSocket" "Async,Push"
        sys.rezerwacje -> sys.backOffice "Pushes room status" "WebSocket" "Async,Push"
        sys.guestApp -> paymentOperator "Guest pays (pre-auth)" "HTTPS redirect"
        sys.guestApp -> idp "Signs in" "OIDC"
        sys.backOffice -> idp "Signs in" "OIDC"

        # ---------- Relationships: service to service ----------
        sys.rezerwacje -> sys.housekeeping "Room needed by (all rooms)" "room-status-events" "Async"
        sys.pobyt -> sys.housekeeping "Guest checked out" "room-status-events" "Async"
        sys.pobyt -> sys.rezerwacje "Room occupied / vacated" "room-status-events" "Async"
        sys.rezerwacje -> sys.pobyt "Arrivals, room status (events)" "room-status-events" "Async"
        sys.housekeeping -> sys.rezerwacje "Room ready / defect" "room-status-events" "Async"
        sys.housekeeping -> sys.pobyt "Requests housekeeper key for a task" "HTTPS"
        sys.synchronizacja -> sys.rezerwacje "Imports pool, prices, non-pool stays; reads our bookings" "HTTPS, every 15 min"
        sys.oferta -> sys.files "Stores photos" "S3 API"
        sys.pobyt -> sys.files "Writes emergency list every 15 min" "S3 API"

        # ---------- Relationships: data (each service owns its own schema) ----------
        sys.rezerwacje -> sys.db "Room-nights, status" "SQL, ACID" "Data"
        sys.housekeeping -> sys.db "Tasks" "SQL" "Data"
        sys.pobyt -> sys.db "Stays" "SQL" "Data"
        sys.synchronizacja -> sys.db "File log, import state" "SQL" "Data"
        sys.oferta -> sys.db "Room features" "SQL" "Data"

        # ---------- Relationships: external systems ----------
        sys.pobyt -> lockPlatform "Issues / revokes mobile keys" "Vendor API, HTTPS"
        sys.synchronizacja -> legacy "Swaps files both ways" "SFTP, files every 15 min"
        sys.rezerwacje -> paymentOperator "Opens pre-auth; result by webhook" "HTTPS, webhook"
    }

    views {
        # C1: System Context
        systemContext sys "C1-SystemContext" {
            include *
            autoLayout lr
            title "[C1] System Context diagram for Room with a View"
        }

        # C2: Containers (Identity Provider left out: sign-in only, shown on C1)
        container sys "C2-Containers" {
            include *
            exclude idp
            autoLayout tb
            title "[C2] Container diagram for Room with a View (service-based)"
        }

        # C2 for the slide: no database fan-in, Identity Provider, file storage, WebSocket push-backs, cart-queue panel,
        # the arrivals feed Rezerwacje -> Pobyt (its label lands on top of "Room occupied / vacated"),
        # the guest-app redirect to the payment operator (the pre-auth edge from Rezerwacje already shows it), the housekeeper
        # key request or the staff actors (on C1; back-office and cart app name their users)
        container sys "C2-Slide" {
            include *
            exclude idp sys.files hotelStaff housekeeper
            exclude relationship.tag==Data
            exclude relationship.tag==Push
            exclude "sys.backOffice -> sys.housekeeping"
            exclude "sys.rezerwacje -> sys.pobyt"
            exclude "sys.guestApp -> paymentOperator"
            exclude "sys.housekeeping -> sys.pobyt"
            autoLayout tb
            title "[C2] Kontenery (widok na slajd)"
        }

        # D1: specific-room booking: hold, pre-authorisation at the payment operator, confirm; legacy gets it in the next file
        dynamic sys "D1-KeyFlow" "Booking a specific room" {
            title "[D1] Dynamic diagram: booking a specific room"
            guest -> sys.guestApp "Picks a specific room from photos"
            sys.guestApp -> sys.rezerwacje "POST /bookings (room, nights)"
            sys.rezerwacje -> sys.db "Insert hold per room-night: unique (room, night), 10-min TTL"
            sys.rezerwacje -> paymentOperator "Open pre-authorisation"
            sys.guestApp -> paymentOperator "Redirect: guest enters card on hosted page"
            paymentOperator -> sys.rezerwacje "Pre-authorisation OK (webhook)"
            sys.rezerwacje -> sys.db "Hold to booking, room assigned, needed-by date set"
            sys.rezerwacje -> sys.housekeeping "Room needed by (event)"
            sys.housekeeping -> sys.cartApp "Push reprioritised task list"
            sys.synchronizacja -> sys.rezerwacje "Next 15-min run: reads new bookings"
            sys.synchronizacja -> legacy "Booking + guest data + pre-auth number in next file"
            autoLayout lr
        }

        # D2: checkout closes the loop to a room ready for the next guest
        dynamic sys "D2-Checkout" "Guest checked out to room ready" {
            title "[D2] Dynamic diagram: guest checked out to room ready"
            hotelStaff -> sys.backOffice "Checks guest out"
            sys.backOffice -> sys.pobyt "POST /stays/{id}/checkout"
            sys.pobyt -> sys.rezerwacje "Room vacated (event)"
            sys.pobyt -> lockPlatform "Revoke guest key"
            sys.pobyt -> sys.housekeeping "Guest checked out (event)"
            sys.housekeeping -> sys.cartApp "Push new task (priority: next arrival)"
            sys.cartApp -> sys.housekeeping "Room cleaned (offline queue, idempotent)"
            sys.housekeeping -> sys.rezerwacje "Room ready (event)"
            sys.rezerwacje -> sys.backOffice "Push: room ready for arrival"
            autoLayout tb
        }

        # D3: legacy down or its file missing: booking, check-in, checkout and cleaning carry on; the next file catches up
        dynamic sys "D3-LegacyDown" "Legacy down or file missing" {
            title "[D3] Dynamic diagram: legacy down or file missing"
            1: sys.synchronizacja -> legacy "No file from legacy: alert, nothing else waits"
            2: guest -> sys.guestApp "Books a specific room"
            3: sys.guestApp -> sys.rezerwacje "POST /bookings: hold room-nights"
            4: sys.rezerwacje -> paymentOperator "Pre-authorisation as usual, no legacy"
            5: hotelStaff -> sys.backOffice "Checks guests out; non-pool checkouts entered by hand"
            6: sys.backOffice -> sys.pobyt "POST /stays/{id}/checkout"
            7: sys.pobyt -> sys.housekeeping "Guest checked out: cleaning starts as usual"
            8: sys.synchronizacja -> legacy "Legacy back: next numbered file catches up"
            9: sys.synchronizacja -> sys.rezerwacje "Idempotent import: same file twice changes nothing"
            autoLayout lr
        }

        styles {
            element "Element" {
                color #ffffff
            }
            element "Person" {
                shape person
                background #08427b
                stroke #052e56
            }
            element "Internal" {
                background #6b8fb3
            }
            element "Software System" {
                background #1168bd
                stroke #0b4884
            }
            element "Container" {
                background #438dd5
                stroke #2e6295
            }
            element "Database" {
                shape cylinder
            }
            element "Queue" {
                shape pipe
            }
            element "WebBrowser" {
                shape webbrowser
            }
            element "Device" {
                shape MobileDeviceLandscape
            }
            element "External" {
                background #999999
                stroke #6b6b6b
            }
            relationship "Relationship" {
                color #555555
                thickness 2
                style solid
            }
            relationship "Async" {
                style dashed
            }
        }
    }
}
