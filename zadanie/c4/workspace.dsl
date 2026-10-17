/*
 * C4 model for the "Room with a View" kata, team White.
 * Source of truth for every decision: zadanie/notatki.md.
 * Style: service-based = five separately deployable domain services + one shared PostgreSQL database,
 * one schema per service. No scaling-out for load: one platform for the US region; every service runs
 * at least two instances with rolling deploys, so a deploy never stops bookings or check-ins.
 * Services call each other over HTTPS; room-status events (guest checked out, room needed by,
 * room ready / defect) go through one lightweight queue, "room-status-events", shown as the arrow
 * label (point-to-point, so no broker box).
 * Render: ./zadanie/c4/render.sh   (outputs go to zadanie/c4/out/)
 */
workspace "Room with a View" "Specific-room booking, room status and housekeeping for 107 resort hotels." {

    !identifiers hierarchical

    model {
        # ---------- People (actors) ----------
        guest = person "Guest" "Views room photos and descriptions; books a room type or a specific room on web or mobile."
        hotelStaff = person "Hotel Staff" "Front desk (phone and walk-in bookings, check-in / out), hotel manager (replacement rooms), housekeeping supervisor (cart queues)." "Internal"
        housekeeper = person "Housekeeping & Maintenance Staff" "Hotel staff on cleaning carts: clean and repair rooms in priority order." "Internal"

        # ---------- Our system ----------
        sys = softwareSystem "Room with a View" "Lets guests pick a specific room, keeps room-nights and room status, directs housekeeping by priority. Service-based, five services." {

            guestApp = container "Guest Web App" "Room photos and descriptions, availability; books a room type or a specific room." "TypeScript, React PWA" "WebBrowser"
            backOffice = container "Staff Back-office" "Phone and walk-in bookings on the same path as guests, check-in / out, room board, cart queue panel." "TypeScript, React SPA" "WebBrowser"
            cartApp = container "Housekeeping Cart App" "Ordered room list with guest wishes and defects; works offline, sends updates when Wi-Fi is back." "Offline web app, IndexedDB" "Device"

            rezerwacje = container "Rezerwacje Service" "Board frame Rezerwacja + room availability and status: the only place that can take a room for a night (one transaction); 10-min hold for unpaid bookings; computes when every hotel room is needed next." "TypeScript, NestJS"
            housekeeping = container "Housekeeping Service" "Board frames Housekeeping + Servis tech: one queue for cleaning and repairs, priority from when the room is needed next; API for cart devices." "TypeScript, NestJS"
            pobyt = container "Pobyt Service (Visit + Faraway)" "Board frames Visit + Faraway: check-in, checkout, replacement room, room complaints; emergency list for reception every 15 min (file + e-mail); smart-lock adapter in phase 2." "TypeScript, NestJS"
            synchronizacja = container "Synchronizacja Service (legacy ACL)" "Board frame Synchronizacja + calls to Payments: the only caller of the legacy system; outbox queue while legacy is down, nightly data reconciliation." "TypeScript, NestJS"
            oferta = container "Oferta Service (Marketing)" "Board frame Marketing: room standard, features, photos, descriptions, lock ID; read-only for the rest of the system." "TypeScript, NestJS"

            db = container "Shared Database" "Managed PostgreSQL, one schema per service, services never read another service's schema; replica in a second zone with automatic failover in 1-2 min, backups." "PostgreSQL (managed)" "Database"
            files = container "File Storage" "Room photos (delivered ready-made) and the emergency list for reception (arrivals, departures, room status; also e-mailed to reception), readable while our services are down." "Object storage + CDN" "Database"
        }

        # ---------- External systems ----------
        legacy = softwareSystem "Reservations System (legacy)" "Existing system of record: reservations, guest data, prices, Payments (payments, refunds, cancellations), manager reports. Blocks a room pool for us." "External"
        lockPlatform = softwareSystem "Smart Lock Platform (phase 2)" "Lock vendor API: mobile keys that open doors from a phone." "External,Phase2"
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
        sys.guestApp -> idp "Signs in" "OIDC"
        sys.backOffice -> idp "Signs in" "OIDC"

        # ---------- Relationships: service to service ----------
        sys.rezerwacje -> sys.synchronizacja "Confirms booking + payment" "HTTPS"
        sys.rezerwacje -> sys.housekeeping "Room needed by (all rooms)" "room-status-events" "Async"
        sys.pobyt -> sys.housekeeping "Guest checked out" "room-status-events" "Async"
        sys.pobyt -> sys.rezerwacje "Room occupied / vacated" "HTTPS"
        sys.pobyt -> sys.synchronizacja "Check-in / out, refunds" "HTTPS"
        sys.housekeeping -> sys.rezerwacje "Room ready / defect" "room-status-events" "Async"
        sys.synchronizacja -> sys.rezerwacje "Legacy bookings, stays (non-pool rooms)" "HTTPS"
        sys.oferta -> sys.files "Stores photos" "S3 API"
        sys.pobyt -> sys.files "Writes emergency list every 15 min" "S3 API"

        # ---------- Relationships: data (each service owns its own schema) ----------
        sys.rezerwacje -> sys.db "Room-nights, status" "SQL, ACID" "Data"
        sys.housekeeping -> sys.db "Tasks" "SQL" "Data"
        sys.pobyt -> sys.db "Stays" "SQL" "Data"
        sys.synchronizacja -> sys.db "Outbox" "SQL" "Data"
        sys.oferta -> sys.db "Room features" "SQL" "Data"

        # ---------- Relationships: external systems ----------
        sys.synchronizacja -> legacy "Reservations, Payments, nightly reconciliation" "HTTPS API; plan B: files every 15 min"
        sys.pobyt -> lockPlatform "Mobile keys (phase 2)" "Vendor API, HTTPS"
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

        # C2 for the slide: no database fan-in, Identity Provider, file storage, WebSocket push-backs or cart-queue panel
        container sys "C2-Slide" {
            include *
            exclude idp sys.files
            exclude relationship.tag==Data
            exclude relationship.tag==Push
            exclude "sys.backOffice -> sys.housekeeping"
            autoLayout tb
            title "[C2] Kontenery (widok na slajd)"
        }

        # D1: specific-room booking (every channel holds the room-night before writing to the legacy system)
        dynamic sys "D1-KeyFlow" "Booking a specific room" {
            title "[D1] Dynamic diagram: booking a specific room"
            guest -> sys.guestApp "Picks a specific room from photos"
            sys.guestApp -> sys.rezerwacje "POST /bookings (room, nights)"
            sys.rezerwacje -> sys.db "Insert hold per room-night: unique (room, night), 10-min TTL"
            sys.rezerwacje -> sys.synchronizacja "Confirm hold: reservation + payment"
            sys.synchronizacja -> legacy "Create reservation + payment (Payments)"
            sys.rezerwacje -> sys.db "Hold to booking; room needed-by date set"
            sys.rezerwacje -> sys.housekeeping "Room needed by (event)"
            sys.housekeeping -> sys.db "Recalculate task priorities"
            sys.housekeeping -> sys.cartApp "Push reprioritised task list"
            autoLayout lr
        }

        # D2: checkout closes the loop to a room ready for the next guest
        dynamic sys "D2-Checkout" "Guest checked out to room ready" {
            title "[D2] Dynamic diagram: guest checked out to room ready"
            hotelStaff -> sys.backOffice "Checks guest out"
            sys.backOffice -> sys.pobyt "POST /stays/{id}/checkout"
            sys.pobyt -> sys.rezerwacje "Room vacated"
            sys.pobyt -> sys.housekeeping "Guest checked out (event)"
            sys.housekeeping -> sys.cartApp "Push new task (priority: next arrival)"
            sys.cartApp -> sys.housekeeping "Room cleaned (offline queue, idempotent)"
            sys.housekeeping -> sys.rezerwacje "Room ready (event)"
            sys.rezerwacje -> sys.backOffice "Push: room ready for arrival"
            autoLayout tb
        }

        # D3: legacy down for 30 min: booking is held, payment waits in the outbox, checkout and cleaning carry on
        dynamic sys "D3-LegacyDown" "Legacy system down" {
            title "[D3] Dynamic diagram: legacy system down"
            1: guest -> sys.guestApp "Books a specific room"
            2: sys.guestApp -> sys.rezerwacje "POST /bookings"
            3: sys.rezerwacje -> sys.db "Hold room-nights (awaiting legacy)"
            4: sys.rezerwacje -> sys.synchronizacja "Confirm hold: reservation + payment"
            5: sys.synchronizacja -> sys.db "Legacy timeout: store in outbox"
            6: hotelStaff -> sys.backOffice "Checks another guest out"
            7: sys.backOffice -> sys.pobyt "POST /stays/{id}/checkout"
            8: sys.pobyt -> sys.synchronizacja "Checkout report: queued in outbox"
            9: sys.pobyt -> sys.housekeeping "Guest checked out: cleaning starts as usual"
            10: sys.synchronizacja -> legacy "Legacy back: replay outbox"
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
            element "Phase2" {
                border dashed
                opacity 60
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
