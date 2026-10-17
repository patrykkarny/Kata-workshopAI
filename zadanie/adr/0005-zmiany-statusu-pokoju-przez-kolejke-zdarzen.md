# ADR-005: Zmiany statusu pokoju między serwisami przez kolejkę zdarzeń

Status: Accepted  
Date: 2026-10-17  
Author: Zespół White (Marek, Patryk, Mariusz, Kamil)

## Context

Mamy pięć serwisów (Rezerwacje, Housekeeping, Pobyt, Synchronizacja, Oferta) ze wspólną bazą. Serwisy gadają ze sobą przez HTTPS.

Status pokoju i to, kiedy pokój będzie znowu potrzebny, zna tylko serwis Rezerwacje (M-01, BC-01, FR-05, ADR-002). Housekeeping (M-02) potrzebuje tych informacji do pracy:

- Checkout tworzy zlecenie sprzątania (FR-11). Po checkoucie Faraway (BC-05, serwis Pobyt) wysyła do Housekeepingu zlecenie sprzątania.
- Priorytet zlecenia sprzątania wynika z tego, kiedy pokój jest znowu potrzebny (FR-12).
- Housekeeping obejmuje wszystkie pokoje hotelu (FR-17). Synchronizacja przekazuje do Rezerwacji rezerwacje z legacy dla pokoi spoza puli, a Rezerwacje liczą „pokój potrzebny o” dla wszystkich pokoi i wysyłają to do Housekeepingu (Q63).

Pobyt (M-03) przy check-in i checkout zmienia stan pokoju, a zająć pokój na noc mogą tylko Rezerwacje. Check-in i checkout mają działać, nawet jak Rezerwacje leżą (AC-03).

W drugą stronę Housekeeping i Servis tech (BC-02, BC-03) mówią Rezerwacji, że pokój jest gotowy albo ma usterkę. Usterka blokująca zdejmuje pokój ze sprzedaży (FR-15).

Odporność na awarie mamy w top 3. Jak padnie serwis rezerwacji, housekeeping dalej działa (AC-04). Najważniejszy dla biznesu jest system do sprzątania, a pokój ma być przygotowany w 15 minut.

W pierwszej wersji „pokój gotowy” i „usterka” z Housekeepingu szły do Rezerwacji przez HTTPS; zmieniliśmy to w Q62. Potem zmiana: check-in i checkout z Pobytu też idą do Rezerwacji jako zdarzenia, a nie przez HTTPS, bo inaczej check-in nie zadziała, jak Rezerwacje leżą (AC-03).

## Decision

Zmiany statusu pokoju między serwisami idą przez kolejkę zdarzeń, a nie przez HTTPS. Reszta komunikacji między serwisami zostaje na HTTPS. Kolejka służy tylko do zmian statusu pokoju; to nie jest event-driven dla całego systemu, więc nie przeczy odrzuceniu event-driven w ADR-001.

Przez kolejkę idą:

- check-in i checkout (z Pobytu do Rezerwacji, AC-03),
- „gość wymeldowany” (z Pobytu do Housekeepingu, FR-11),
- „pokój potrzebny o” (z Rezerwacji do Housekeepingu, dla wszystkich pokoi hotelu, FR-12, Q63),
- „pokój gotowy” i „usterka” (z Housekeepingu do Rezerwacji, Q62).

W praktyce:

- Każdy serwis zapisuje zdarzenie w swoim schemacie razem z danymi (outbox, ADR-004). Dalej zdarzenie idzie przez zarządzaną kolejkę w chmurze, która nie zależy od naszej bazy.
- Zdarzenie może przyjść dwa razy, więc każdy odbiorca sprawdza jego identyfikator i drugi raz go ignoruje.
- Pobyt i Housekeeping trzymają u siebie kopię tego, czego potrzebują z Rezerwacji (przyjazdy na dziś, status pokoju, „pokój potrzebny o”), aktualizowaną zdarzeniami. Jak Rezerwacje leżą, pracują na ostatnim znanym stanie.
- Z tej kopii Pobyt robi też listę awaryjną dla recepcji, więc nie czyta cudzego schematu. Listę generuje co 15 minut i zapisuje poza naszymi serwisami: plik w magazynie plików, wysyłany też mailem do recepcji (FR-18, Q66).
- Jak Rezerwacje leżą, zdarzenia czekają w kolejce, a status na recepcji uzupełnia się po powrocie (Q62).
- Usterka blokująca czeka w kolejce tylko wtedy, gdy Rezerwacje leżą, a wtedy i tak nikt nie sprzedaje pokoi. Normalnie zdarzenie dochodzi w kilka sekund.
- Blokada pokoju na noc nie idzie przez kolejkę: zostaje jedną transakcją w serwisie Rezerwacje.
- W diagramie C4 kolejka nazywa się `room-status-events`.

## Alternatives Considered

- **Wszystko przez HTTPS, także zmiany statusu pokoju**: tak mieliśmy w pierwszej wersji. Odpadło, bo housekeeping ma działać dalej, nawet jak serwis Rezerwacje leży (Q62, AC-04), a check-in i checkout przez HTTPS nie zadziałają, jak Rezerwacje leżą (AC-03).
- **Event-driven jako styl całego systemu**: odrzucony przy wyborze stylu (ADR-001), bo to za dużo ruchomych części jak na nasz termin i daje spójność ostateczną tam, gdzie blokada pokoju potrzebuje transakcji.

## Consequences

### Positive

- Check-in, checkout i sprzątanie działają dalej, gdy serwis Rezerwacje leży: Pobyt i Housekeeping pracują na swojej kopii, a zdarzenia czekają w kolejce (AC-03, AC-04, Q62).
- Lista awaryjna dla recepcji powstaje z kopii w Pobycie, bez czytania cudzego schematu.
- Da się to sprawdzić testem: wyłączamy serwis Rezerwacje na 30 minut, a check-in, checkout i sprzątanie działają (AC-03, AC-04).

### Negative

- Dopóki Rezerwacje nie wrócą, status pokoju na recepcji jest nieaktualny, a Pobyt i Housekeeping pracują na ostatnim znanym stanie (Q62).
- Każdy odbiorca musi sprawdzać identyfikator zdarzenia, bo zdarzenie może przyjść dwa razy.
- Kolejka to jeszcze jeden element do wdrożenia i utrzymania, obok pięciu serwisów i bazy.

## Notes

- Spec: `zadanie/spec/01-prd.md` (FR-05, FR-11, FR-12, FR-15, FR-17, FR-18), `zadanie/spec/02-domain.md` (BC-01, BC-02, BC-03, BC-05, M-01, M-02, M-03, mapa kontekstów), `zadanie/spec/03-characteristics.md` (AC-03, AC-04).
- Odpowiedzi na grill-me: Q62, Q63, Q66 w `zadanie/notatki.md`; sekcja Decyzje (komunikacja między serwisami); sekcja „Doprecyzowania po ADR-ach” (Pokój i status, Kolejka).
- Diagram C4: `zadanie/c4/workspace.dsl` (kolejka `room-status-events`).
- Event Storming: `zadanie/event-storming/kata-white.png`; Miro: brak linku.
- Powiązane: ADR-001 (styl service-based, odrzucony event-driven), ADR-002 (serwis Rezerwacje jako jedyne źródło prawdy o pokoju na noc i statusie pokoju), ADR-004 (outbox w schemacie serwisu), ADR-006 (aplikacja na wózki działająca offline).
