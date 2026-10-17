/*
 * C4 model for the "Room with a View" kata, team White.
 * Source of truth for every decision: zadanie/notatki.md; details and rationale live in zadanie/adr/.
 * Style: service-based = five separately deployable domain services + one shared PostgreSQL database,
 * one schema per service. Services are named in English; each description names the event-storming
 * board frames it covers. One platform for all hotels in the US region; a new hotel is configuration,
 * not code. Scales out per service (more instances only for the service that needs them), no autoscaling.
 * Every service runs at least two instances with rolling deploys, so a deploy never stops bookings or check-ins.
 * Services call each other over HTTPS; room-status events (room occupied / vacated, guest checked out,
 * room needed by, room ready / defect, arrivals) go through "room-status-events", shown as the arrow
 * label (point-to-point, so no broker box). The outbox is only for these room-status events: each
 * service writes them in its own schema, in the same transaction as its data; a managed cloud queue,
 * independent of our database, delivers them. Receivers drop duplicates by event ID.
 * Legacy has no API: Legacy Sync Service swaps files with it both ways every 15 min, plus a nightly full
 * comparison. Payment at booking is a pre-authorisation on an external payment operator's hosted page;
 * legacy settles the stay and refunds at checkout. Nothing in booking, check-in, checkout or cleaning
 * waits for legacy.
 * Render: ./zadanie/c4/render.sh   (outputs go to zadanie/c4/out/)
 */
workspace "Room with a View" "Specific-room booking, room status and housekeeping for 107 resort hotels." {

    !identifiers hierarchical

    model {
        # ---------- People (actors) ----------
        guest = person "Guest" "Views room photos; books a room type or a specific room on web or mobile."
        hotelStaff = person "Hotel Staff" "Front desk (bookings, check-in / out), hotel manager, housekeeping supervisor (cart queues)." "Internal"
        housekeeper = person "Housekeeping & Maintenance Staff" "Clean and repair rooms in priority order from cart devices." "Internal"

        # ---------- Our system ----------
        sys = softwareSystem "Room with a View" "Guests pick a specific room; keeps room-nights and room status; directs housekeeping by priority." {

            guestApp = container "Guest Web App" "Room photos and floor plans; books a room type or a specific room." "TypeScript, React PWA" "WebBrowser"
            backOffice = container "Staff Back-office" "Phone and walk-in bookings, check-in / out, room board, cart queue panel." "TypeScript, React SPA" "WebBrowser"
            cartApp = container "Housekeeping Cart App" "Offline cart app: ordered room list with guest wishes and defects; syncs when Wi-Fi returns." "Offline web app, IndexedDB" "Device"

            reservations = container "Reservations Service" "Board frame: Rezerwacja + room status. Source of truth for room-nights; 10-min hold until pre-auth." "TypeScript, NestJS"
            housekeeping = container "Housekeeping Service" "Board frames: Housekeeping + Servis tech. One cleaning and repair queue, prioritised by room needed-by." "TypeScript, NestJS"
            stay = container "Stay Service" "Board frames: Visit + Faraway. Check-in, checkout, emergency list; smart-lock adapter, mobile keys in MVP." "TypeScript, NestJS"
            legacySync = container "Legacy Sync Service" "Board frame: Synchronizacja. Only link to legacy: files both ways every 15 min, nightly comparison." "TypeScript, NestJS"
            roomOffer = container "Room Offer Service" "Board frame: Marketing. Room photos, floor plans and features; read-only for the rest." "TypeScript, NestJS"

            db = container "Shared Database" "Managed PostgreSQL, one schema per service; replica in a second zone, failover in 1-2 min." "PostgreSQL (managed)" "Database"
            files = container "File Storage" "Room photos via CDN and the reception emergency list, readable while our services are down." "Object storage + CDN" "Database"
        }

        # ---------- External systems ----------
        legacy = softwareSystem "Reservations System (legacy)" "Prices, non-pool stays, settlement, refunds, reports. No API, files only; blocks a pool only we sell." "External"
        lockPlatform = softwareSystem "Smart Lock Platform" "Mobile keys via vendor API; a key in the phone works even while we are down." "External"
        paymentOperator = softwareSystem "Payment Operator" "Hosted payment page; card pre-authorisation at booking. We never see card data." "External"
        idp = softwareSystem "Identity Provider" "Signs in guests and staff (OIDC)." "External"

        # ---------- Relationships: people ----------
        guest -> sys.guestApp "Browses, books" "HTTPS"
        hotelStaff -> sys.backOffice "Books, checks in / out" "HTTPS"
        housekeeper -> sys.cartApp "Gets tasks, reports done / defect" "Touch UI"

        # ---------- Relationships: front-ends ----------
        sys.guestApp -> sys.roomOffer "Reads rooms" "HTTPS"
        sys.guestApp -> sys.reservations "Searches, books" "HTTPS"
        sys.backOffice -> sys.reservations "Books, reads room board" "HTTPS"
        sys.backOffice -> sys.stay "Checks in / out" "HTTPS"
        sys.backOffice -> sys.housekeeping "Reorders cart queues" "HTTPS"
        sys.cartApp -> sys.housekeeping "Syncs task updates" "HTTPS"
        sys.housekeeping -> sys.cartApp "Pushes tasks" "WebSocket" "Async,Push"
        sys.reservations -> sys.backOffice "Pushes room status" "WebSocket" "Async,Push"
        sys.guestApp -> paymentOperator "Guest pays (pre-auth)" "HTTPS redirect"
        sys.guestApp -> idp "Signs in" "OIDC"
        sys.backOffice -> idp "Signs in" "OIDC"

        # ---------- Relationships: legacy (declared before the service events: edge order steers the C2-Slide layout) ----------
        sys.legacySync -> legacy "Swaps files both ways" "SFTP, every 15 min"

        # ---------- Relationships: service to service ----------
        sys.stay -> sys.housekeeping "Guest checked out" "room-status-events" "Async"
        sys.reservations -> sys.housekeeping "Room needed by" "room-status-events" "Async"
        sys.stay -> sys.reservations "Room occupied / vacated" "room-status-events" "Async"
        sys.reservations -> sys.stay "Arrivals, room status" "room-status-events" "Async"
        sys.housekeeping -> sys.reservations "Room ready / defect" "room-status-events" "Async"
        sys.housekeeping -> sys.stay "Requests housekeeper key" "HTTPS"
        sys.legacySync -> sys.reservations "Pool, non-pool stays in; our bookings out" "HTTPS, every 15 min"
        sys.roomOffer -> sys.files "Stores photos" "S3 API"
        sys.stay -> sys.files "Writes emergency list" "S3 API, every 15 min"

        # ---------- Relationships: data (each service owns its own schema) ----------
        sys.reservations -> sys.db "Room-nights, status" "SQL, ACID" "Data"
        sys.housekeeping -> sys.db "Tasks" "SQL" "Data"
        sys.stay -> sys.db "Stays" "SQL" "Data"
        sys.legacySync -> sys.db "File log, import state" "SQL" "Data"
        sys.roomOffer -> sys.db "Room features" "SQL" "Data"

        # ---------- Relationships: external systems ----------
        sys.stay -> lockPlatform "Issues / revokes mobile keys" "Vendor API, HTTPS"
        sys.reservations -> paymentOperator "Opens pre-auth; result by webhook" "HTTPS, webhook"
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
        # the arrivals feed Reservations -> Stay (its label lands on top of "Room occupied / vacated"),
        # the guest-app redirect to the payment operator (the pre-auth edge from Reservations already shows it), the housekeeper
        # key request or the staff actors (on C1; back-office and cart app name their users)
        container sys "C2-Slide" {
            include *
            exclude idp sys.files hotelStaff housekeeper
            exclude relationship.tag==Data
            exclude relationship.tag==Push
            exclude "sys.backOffice -> sys.housekeeping"
            exclude "sys.reservations -> sys.stay"
            exclude "sys.guestApp -> paymentOperator"
            exclude "sys.housekeeping -> sys.stay"
            autoLayout tb
            title "[C2] Containers (slide view)"
        }

        # D1: specific-room booking: hold, pre-authorisation at the payment operator, confirm; legacy gets it in the next file
        dynamic sys "D1-KeyFlow" "Booking a specific room" {
            title "[D1] Dynamic diagram: booking a specific room"
            guest -> sys.guestApp "Picks a specific room"
            sys.guestApp -> sys.reservations "POST /bookings (room, nights)"
            sys.reservations -> sys.db "10-min hold, unique per room-night"
            sys.reservations -> paymentOperator "Open pre-authorisation"
            sys.guestApp -> paymentOperator "Redirect: guest enters card on hosted page"
            paymentOperator -> sys.reservations "Pre-authorisation OK (webhook)"
            sys.reservations -> sys.db "Hold to booking, needed-by date set"
            sys.reservations -> sys.housekeeping "Room needed by (event)"
            sys.housekeeping -> sys.cartApp "Push reprioritised task list"
            sys.legacySync -> sys.reservations "Next 15-min run: reads new bookings"
            sys.legacySync -> legacy "Booking, guest data, pre-auth number in next file"
            autoLayout lr
        }

        # D2: checkout closes the loop to a room ready for the next guest
        dynamic sys "D2-Checkout" "Guest checked out to room ready" {
            title "[D2] Dynamic diagram: guest checked out to room ready"
            hotelStaff -> sys.backOffice "Checks guest out"
            sys.backOffice -> sys.stay "POST /stays/{id}/checkout"
            sys.stay -> sys.reservations "Room vacated (event)"
            sys.stay -> lockPlatform "Revoke guest key"
            sys.stay -> sys.housekeeping "Guest checked out (event)"
            sys.housekeeping -> sys.cartApp "Push new task (priority: next arrival)"
            sys.cartApp -> sys.housekeeping "Room cleaned (offline queue, idempotent)"
            sys.housekeeping -> sys.reservations "Room ready (event)"
            sys.reservations -> sys.backOffice "Push: room ready for arrival"
            autoLayout tb
        }

        # D3: legacy down or its file missing: booking, check-in, checkout and cleaning carry on; the next file catches up
        dynamic sys "D3-LegacyDown" "Legacy down or file missing" {
            title "[D3] Dynamic diagram: legacy down or file missing"
            1: sys.legacySync -> legacy "No file from legacy: alert, nothing else waits"
            2: guest -> sys.guestApp "Books a specific room"
            3: sys.guestApp -> sys.reservations "POST /bookings: hold room-nights"
            4: sys.reservations -> paymentOperator "Pre-authorisation as usual"
            5: hotelStaff -> sys.backOffice "Checks guests out; non-pool checkouts by hand"
            6: sys.backOffice -> sys.stay "POST /stays/{id}/checkout"
            7: sys.stay -> sys.housekeeping "Guest checked out: cleaning as usual"
            8: sys.legacySync -> legacy "Legacy back: next numbered file catches up"
            9: sys.legacySync -> sys.reservations "Idempotent import: same file twice is harmless"
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
