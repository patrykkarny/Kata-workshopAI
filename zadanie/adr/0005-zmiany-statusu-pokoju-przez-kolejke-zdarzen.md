# ADR-005: Zmiany statusu pokoju między serwisami przez kolejkę zdarzeń

Status: Accepted  
Date: 2026-10-17  
Author: Zespół White (Marek, Patryk, Mariusz, Kamil)

## Context

Mamy pięć serwisów (Reservations Service: ramka Rezerwacja; Housekeeping Service: ramki Housekeeping i Servis tech; Stay Service: ramki Visit i Faraway; Legacy Sync Service: ramka Synchronizacja; Room Offer Service: ramka Marketing) ze wspólną bazą. Serwisy gadają ze sobą przez HTTPS.

Status pokoju i to, kiedy pokój będzie znowu potrzebny, zna tylko Reservations Service (M-01, BC-01, FR-05, ADR-002). Housekeeping Service (M-02) potrzebuje tych informacji do pracy:

- Checkout tworzy zlecenie sprzątania (FR-11). Po checkoucie Faraway (BC-05, Stay Service) wysyła do Housekeeping Service zlecenie sprzątania.
- Priorytet zlecenia sprzątania wynika z tego, kiedy pokój jest znowu potrzebny (FR-12).
- Housekeeping obejmuje wszystkie pokoje hotelu (FR-17). Legacy Sync Service przekazuje do Reservations Service rezerwacje z legacy dla pokoi spoza puli, a Reservations Service liczy „pokój potrzebny o” dla wszystkich pokoi i wysyła to do Housekeeping Service (Q63).

Stay Service (M-03) przy check-in i checkout zmienia stan pokoju, a zająć pokój na noc może tylko Reservations Service. Check-in i checkout mają działać, nawet jak Reservations Service leży (AC-03).

W drugą stronę Housekeeping Service (BC-02, BC-03) mówi Reservations Service, że pokój jest gotowy albo ma usterkę. Usterka blokująca zdejmuje pokój ze sprzedaży (FR-15).

Odporność na awarie mamy w top 3. Jak padnie Reservations Service, housekeeping dalej działa (AC-04). Najważniejszy dla biznesu jest system do sprzątania, a pokój ma być przygotowany w 15 minut.

W pierwszej wersji „pokój gotowy” i „usterka” z Housekeeping Service szły do Reservations Service przez HTTPS; zmieniliśmy to w Q62. Potem zmiana: check-in i checkout ze Stay Service też idą do Reservations Service jako zdarzenia, a nie przez HTTPS, bo inaczej check-in nie zadziała, jak Reservations Service leży (AC-03).

## Decision

Zmiany statusu pokoju między serwisami idą przez kolejkę zdarzeń, a nie przez HTTPS. Reszta komunikacji między serwisami zostaje na HTTPS. Kolejka służy tylko do zmian statusu pokoju; to nie jest event-driven dla całego systemu, więc nie przeczy odrzuceniu event-driven w ADR-001.

Przez kolejkę idą:

- check-in i checkout (ze Stay Service do Reservations Service, AC-03),
- „gość wymeldowany” (ze Stay Service do Housekeeping Service, FR-11),
- „pokój potrzebny o” (z Reservations Service do Housekeeping Service, dla wszystkich pokoi hotelu, FR-12, Q63),
- „pokój gotowy” i „usterka” (z Housekeeping Service do Reservations Service, FR-15, Q62).

W praktyce:

- Każdy serwis zapisuje zdarzenie w swoim schemacie razem z danymi (outbox, ADR-004). Dalej zdarzenie idzie przez zarządzaną kolejkę w chmurze, która nie zależy od naszej bazy.
- Zdarzenie może przyjść dwa razy, więc każdy odbiorca sprawdza jego identyfikator i drugi raz go ignoruje.
- Stay Service i Housekeeping Service trzymają u siebie kopię tego, czego potrzebują z Reservations Service (przyjazdy na dziś, status pokoju, „pokój potrzebny o”), aktualizowaną zdarzeniami. Jak Reservations Service leży, pracują na ostatnim znanym stanie.
- Z tej kopii Stay Service robi też listę awaryjną dla recepcji, więc nie czyta cudzego schematu. Listę generuje co 15 minut i zapisuje poza naszymi serwisami: plik w magazynie plików, wysyłany też mailem do recepcji (FR-18, Q66).
- Jak Reservations Service leży, zdarzenia czekają w kolejce, a status na recepcji uzupełnia się po powrocie (Q62).
- Usterka blokująca czeka w kolejce tylko wtedy, gdy Reservations Service leży, a wtedy i tak nikt nie sprzedaje pokoi. Normalnie zdarzenie dochodzi w kilka sekund.
- Blokada pokoju na noc nie idzie przez kolejkę: zostaje jedną transakcją w Reservations Service.
- W diagramie C4 kolejka nazywa się `room-status-events`.

## Alternatives Considered

- **Wszystko przez HTTPS, także zmiany statusu pokoju**: tak mieliśmy w pierwszej wersji. Odpadło, bo housekeeping ma działać dalej, nawet jak Reservations Service leży (Q62, AC-04), a check-in i checkout przez HTTPS nie zadziałają, jak Reservations Service leży (AC-03).
- **Event-driven jako styl całego systemu**: odrzucony przy wyborze stylu (ADR-001), bo to za dużo ruchomych części jak na nasz termin i daje spójność ostateczną tam, gdzie blokada pokoju potrzebuje transakcji.

## Consequences

### Positive

- Check-in, checkout i sprzątanie działają dalej, gdy Reservations Service leży: Stay Service i Housekeeping Service pracują na swojej kopii, a zdarzenia czekają w kolejce (AC-03, AC-04, Q62).
- Lista awaryjna dla recepcji powstaje z kopii w Stay Service, bez czytania cudzego schematu.
- Da się to sprawdzić testem: wyłączamy Reservations Service na 30 minut, a check-in, checkout i sprzątanie działają (AC-03, AC-04).

### Negative

- Dopóki Reservations Service nie wróci, status pokoju na recepcji jest nieaktualny, a Stay Service i Housekeeping Service pracują na ostatnim znanym stanie (Q62).
- Każdy odbiorca musi sprawdzać identyfikator zdarzenia, bo zdarzenie może przyjść dwa razy.
- Kolejka to jeszcze jeden element do wdrożenia i utrzymania, obok pięciu serwisów i bazy.

## Notes

- Spec: `zadanie/spec/01-prd.md` (FR-05, FR-11, FR-12, FR-15, FR-17, FR-18), `zadanie/spec/02-domain.md` (BC-01, BC-02, BC-03, BC-05, M-01, M-02, M-03, mapa kontekstów), `zadanie/spec/03-characteristics.md` (AC-03, AC-04).
- Odpowiedzi na grill-me: Q62, Q63, Q66 w `zadanie/notatki.md`; sekcja Decyzje (komunikacja między serwisami); sekcja „Doprecyzowania po ADR-ach” (Pokój i status, Kolejka).
- Diagram C4: `zadanie/c4/workspace.dsl` (kolejka `room-status-events`).
- Event Storming: `zadanie/event-storming/kata-white.png`; Miro: brak linku.
- Powiązane: ADR-001 (styl service-based, odrzucony event-driven), ADR-002 (Reservations Service jako jedyne źródło prawdy o pokoju na noc i statusie pokoju), ADR-004 (outbox w schemacie serwisu), ADR-006 (aplikacja na wózki działająca offline).
