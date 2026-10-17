# C4 diagram key

| Notation | Meaning |
|---|---|
| Dark blue box | Person (external user) |
| Light blue-grey box | Person (internal staff) |
| Blue box | Our software system (C1) |
| Lighter blue box | Container of our system (C2): front-end, domain service or data store |
| Grey box | External software system (not owned by us) |
| Cylinder | Data store |
| Outline box | System or container boundary |
| Solid arrow | Synchronous request (label = intent, `[technology]`) |
| Dashed arrow | Asynchronous message (event on the `room-status-events` queue, WebSocket push) |

The Mermaid export (PNG/SVG/`.mmd`) draws persons, browsers and devices as plain boxes: read the type from
the `[Person]` / `[Container: ...]` line. The local Structurizr render (`structurizr local`) shows the
real shapes. The `room-status-events` queue is point-to-point, so it is named on the arrow, not drawn as a box.
