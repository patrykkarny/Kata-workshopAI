# ADR-001: Styl service-based: pięć serwisów domenowych ze wspólną bazą

Status: Accepted  
Date: 2026-10-17  
Author: Zespół White (Marek, Patryk, Mariusz, Kamil)

## Context

Budujemy system „Room with a View” dla sieci 107 hoteli. Sezon startuje na początku czerwca, obłożenie dochodzi do ok. 90% (C-01). System ma działać w czerwcu albo czekamy rok.

Ruch jest mały. Ok. 6400 rezerwacji dziennie w 107 hotelach, czyli jedna co 14 sekund. Skalowanie nie jest naszym problemem, a „peak season” w zadaniu chodzi o termin, nie o ruch (ADR-008).

Nasze top 3 charakterystyki (Q31):

1. Prostota: prosta architektura, mało serwisów, jedna baza, bez egzotycznej technologii, bo robi to normalny zespół i ma zdążyć przed sezonem.
2. Integracje: prawie wszystko idzie przez cudze systemy. Legacy nie ma API, wymieniamy z nim pliki (ADR-003). Smart locki mają API (C-03). Do tego urządzenia przy wózkach (FR-13) i cztery kanały przez jedno API (FR-03). Zmiana formatu plików legacy ma ruszać tylko Synchronizację (AC-01).
3. Odporność na awarie: w sezonie przy 90% obłożenia hotel nie może stanąć. Nic w rezerwacji, check-inie, checkoucie ani sprzątaniu nie czeka na legacy na żywo, więc jak legacy leży albo plik nie przyjdzie, hotel działa dalej. Jak padnie serwis rezerwacji, housekeeping dalej działa (AC-04).

Z Event Stormingu wyszło osiem kontekstów (BC-01 do BC-08). Dwa kanały mogą chcieć ten sam pokój na tę samą noc, więc blokada pokoju na noc musi być jedną transakcją (hotspot w BC-01).

## Decision

Wybraliśmy styl service-based: pięć dużych serwisów domenowych i jedna wspólna baza.

Ramki z tablicy mapujemy na serwisy tak:

- M-01 Rezerwacje: ramka Rezerwacja razem z dostępnością i statusem pokoju (BC-01), bo zablokowanie pokoju na noc musi być jedną transakcją.
- M-02 Housekeeping: ramki Housekeeping i Servis tech (BC-02, BC-03), bo to ci sami ludzie, jedna kolejka i ten sam priorytet; do tego API dla urządzeń przy wózkach.
- M-03 Pobyt: ramki Visit i Faraway (BC-04, BC-05), bo to początek i koniec tego samego pobytu; tu jest też adapter smart locków, który wydaje i unieważnia klucze mobilne (ADR-007).
- M-04 Synchronizacja: ramka Synchronizacja (BC-07), czyli import i eksport plików z legacy.
- M-05 Oferta: ramka Marketing (BC-06), tylko do odczytu dla reszty.

Payments (BC-08) nie ma swojego serwisu: preautoryzację przy rezerwacji robi zewnętrzny operator płatności, a rozliczenie pobytu i zwroty robi legacy (ADR-003).

W praktyce:

- Wspólna baza to zarządzany PostgreSQL z osobnym schematem na serwis. Dostęp do schematów, replikę, przełączenie i backupy opisuje ADR-004.
- Serwisy gadają ze sobą przez HTTPS, a zmiany statusu pokoju idą przez kolejkę zdarzeń (ADR-005).
- Każdy serwis chodzi minimum na dwóch instancjach. Wdrażamy po kolei, więc wdrożenie nie zatrzymuje rezerwacji ani check-inów (Q61).

## Alternatives Considered

- **Modularny monolit**: tańszy i prostszy, ale jak padnie aplikacja, pada wszystko, a odporność na awarie mamy w top 3.
- **Microkernel**: tańszy i prostszy, ale jak padnie aplikacja, pada wszystko, a odporność na awarie mamy w top 3.
- **Mikroserwisy**: za dużo ruchomych części jak na nasz termin.
- **Event-driven**: za dużo ruchomych części jak na nasz termin, a do tego daje spójność ostateczną tam, gdzie blokada pokoju potrzebuje transakcji. Kolejka zdarzeń z ADR-005 służy tylko do zmian statusu pokoju, nie jest stylem całego systemu.
- **Baza na serwis**: rozpisane w ADR-004.

## Consequences

### Positive

- Błąd w kodzie, wdrożenie albo przeciążenie jednego serwisu nie kładzie pozostałych (Q60).
- Jak padnie serwis Rezerwacje, check-in, checkout i sprzątanie działają dalej, bo zmiany statusu pokoju idą przez kolejkę zdarzeń (AC-03, AC-04, ADR-005).
- Wciąż na tyle proste, że zdążymy na czerwiec: pięć serwisów i jedna baza.
- Blokada pokoju na noc to jedna transakcja w jednym serwisie.
- Wdrożenie nowej wersji nie zatrzymuje rezerwacji ani check-inów, bo są minimum dwie instancje i wdrażamy po kolei (Q61).
- Każdy serwis skalujemy osobno: jak jeden się dławi, dokładamy instancje tylko jemu (ADR-008).

### Negative

- Oddajemy część prostoty: pięć rzeczy do wdrożenia zamiast jednej.
- Wywołania po sieci między serwisami.
- Baza jest wspólnym punktem awarii; łapie to replika z przełączeniem w 1-2 minuty (ADR-004). W czasie przełączania web, mobile i telefon dostają „spróbuj za chwilę”, zdjęcia pokoi dalej działają z CDN, wózki zapisują offline (ADR-006), a recepcja ma listę awaryjną (Q60, FR-18, ADR-005).
- Każdy serwis musimy utrzymywać na minimum dwóch instancjach (Q61).

## Notes

- Spec: `zadanie/spec/01-prd.md` (C-01, C-03, FR-03, FR-13, FR-18), `zadanie/spec/02-domain.md` (BC-01 do BC-08, M-01 do M-05), `zadanie/spec/03-characteristics.md` (top 3, AC-01, AC-03, AC-04, trade-off prostota kontra odporność na awarie i prostota kontra spójność).
- Odpowiedzi na grill-me: Q31, Q60, Q61 w `zadanie/notatki.md`; sekcja „Doprecyzowania po ADR-ach” (Pokój i status, Skalowanie).
- Diagram C4: `zadanie/c4/workspace.dsl` (widok C2-Containers).
- Event Storming: `zadanie/event-storming/kata-white.png`; Miro: brak linku.
- Powiązane: ADR-002 (serwis Rezerwacje jako jedyne źródło prawdy o pokoju na noc i statusie pokoju), ADR-003 (wymiana plików z legacy i płatność), ADR-004 (wspólna baza: schematy, dostęp, replika, backupy, alternatywa „baza na serwis”), ADR-005 (kolejka zdarzeń, lista awaryjna, test z wyłączeniem serwisu Rezerwacje), ADR-006 (wózki offline), ADR-007 (smart locki w MVP), ADR-008 (skalowanie).
- Jak sprawdzamy odporność na awarie: test z wyłączeniem serwisu Rezerwacje na 30 minut, opisany w ADR-005.
- Nie optymalizujemy pod skalowanie; wracamy do tematu, jak przekroczymy ok. 100 rezerwacji na minutę (próg i sposób pomiaru w ADR-008).
