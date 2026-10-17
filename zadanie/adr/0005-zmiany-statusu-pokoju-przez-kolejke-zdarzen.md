# ADR-005: Zmiany statusu pokoju między serwisami przez kolejkę zdarzeń

Status: Accepted  
Date: 2026-10-17  
Author: Zespół White (Marek, Patryk, Mariusz, Kamil)

## Context

Mamy pięć serwisów (Rezerwacje, Housekeeping, Pobyt, Synchronizacja, Oferta) ze wspólną bazą. Serwisy gadają ze sobą przez HTTPS.

Status pokoju i to, kiedy pokój będzie znowu potrzebny, zna tylko serwis Rezerwacje (M-01, BC-01, FR-05). Housekeeping (M-02) potrzebuje tych informacji do pracy:

- Checkout tworzy zlecenie sprzątania (FR-11). Po checkoucie Faraway (BC-05, serwis Pobyt) wysyła do Housekeepingu zlecenie sprzątania.
- Priorytet zlecenia sprzątania wynika z tego, kiedy pokój jest znowu potrzebny (FR-12).
- Housekeeping obejmuje wszystkie pokoje hotelu (FR-17). Synchronizacja przekazuje do Rezerwacji rezerwacje z legacy dla pokoi spoza puli, a Rezerwacje liczą „pokój potrzebny o” dla wszystkich pokoi i wysyłają to do Housekeepingu (Q63).

W drugą stronę Housekeeping i Servis tech (BC-02, BC-03) mówią Rezerwacji, że pokój jest gotowy albo ma usterkę. Usterka blokująca zdejmuje pokój ze sprzedaży (FR-15).

Odporność na awarie mamy w top 3. Jak padnie serwis rezerwacji, housekeeping dalej działa (AC-04). Najważniejszy dla biznesu jest system do sprzątania, a pokój ma być przygotowany w 15 minut.

W pierwszej wersji „pokój gotowy” i „usterka” z Housekeepingu szły do Rezerwacji przez HTTPS. Zmieniliśmy to w Q62.

## Decision

Zmiany statusu pokoju między serwisami idą przez prostą kolejkę zdarzeń, a nie przez HTTPS. Reszta komunikacji między serwisami zostaje na HTTPS.

W praktyce:

- Przez kolejkę idą: „gość wymeldowany” (z Pobytu do Housekeepingu, FR-11), „pokój potrzebny o” (z Rezerwacji do Housekeepingu, dla wszystkich pokoi hotelu, FR-12, Q63), „pokój gotowy” i „usterka” (z Housekeepingu do Rezerwacji, Q62).
- Jak Rezerwacje leżą, zdarzenia czekają w kolejce, a status na recepcji uzupełnia się po powrocie (Q62).
- Housekeeping działa dalej, nawet jak serwis Rezerwacje leży (AC-04).
- Blokada pokoju na noc nie idzie przez kolejkę: zostaje jedną transakcją w serwisie Rezerwacje.
- W diagramie C4 kolejka nazywa się `room-status-events`.

> TODO: Na czym stoi kolejka zdarzeń? W notatkach jest tylko „prosta kolejka zdarzeń”.

## Alternatives Considered

- **Wszystko przez HTTPS, także zmiany statusu pokoju**: tak mieliśmy w pierwszej wersji. Odpadło, bo housekeeping ma działać dalej, nawet jak serwis Rezerwacje leży; z kolejką zdarzenia czekają, aż Rezerwacje wrócą (Q62, AC-04).
- **Event-driven jako styl całego systemu**: odrzucony przy wyborze stylu (ADR-001), bo to za dużo ruchomych części jak na nasz termin i daje spójność ostateczną tam, gdzie blokada pokoju potrzebuje transakcji.

## Consequences

### Positive

- Housekeeping działa dalej, gdy serwis Rezerwacje leży; „pokój gotowy” i „usterka” czekają w kolejce (Q62, AC-04).
- Da się to sprawdzić testem: wyłączamy serwis Rezerwacje na 30 minut, a sprzątanie działa (AC-04).

### Negative

- Dopóki Rezerwacje nie wrócą, status pokoju na recepcji jest nieaktualny; uzupełnia się dopiero po powrocie (Q62).
- Kolejka to jeszcze jeden element do wdrożenia i utrzymania, obok pięciu serwisów i bazy.

## Notes

- Spec: `zadanie/spec/01-prd.md` (FR-05, FR-11, FR-12, FR-15, FR-17), `zadanie/spec/02-domain.md` (BC-01, BC-02, BC-03, BC-05, M-01, M-02, M-03, mapa kontekstów), `zadanie/spec/03-characteristics.md` (AC-04).
- Odpowiedzi na grill-me: Q62, Q63 w `zadanie/notatki.md`; sekcja Decyzje (komunikacja między serwisami).
- Diagram C4: `zadanie/c4/workspace.dsl` (kolejka `room-status-events`).
- Event Storming: `zadanie/event-storming/kata-white.png`; Miro: brak linku.
- Powiązane: ADR-001 (styl service-based, odrzucony event-driven), ADR-002 (serwis Rezerwacje jako jedyne źródło prawdy o pokoju na noc i statusie pokoju), ADR-006 (aplikacja na wózki działająca offline).
- Jak sprawdzamy: test, w którym wyłączamy serwis Rezerwacje na 30 minut, a sprzątanie działa.
