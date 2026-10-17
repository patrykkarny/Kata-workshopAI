# ADR-001: Styl service-based: pięć serwisów domenowych ze wspólną bazą

Status: Accepted  
Date: 2026-10-17  
Author: Zespół White (Marek, Patryk, Mariusz, Kamil)

## Context

Budujemy system „Room with a View” dla sieci 107 hoteli. Sezon startuje na początku czerwca, obłożenie dochodzi do ok. 90% (C-01). System ma działać w czerwcu albo czekamy rok.

Ruch jest mały. Ok. 6400 rezerwacji dziennie w 107 hotelach, czyli jedna co 14 sekund. Skalowanie nie jest naszym problemem, a „peak season” w zadaniu chodzi o termin, nie o ruch.

Nasze top 3 charakterystyki (Q31):

1. Prostota: prosta architektura, mało serwisów, jedna baza, bez egzotycznej technologii, bo robi to normalny zespół i ma zdążyć przed sezonem.
2. Integracje: prawie wszystko idzie przez cudze systemy. Legacy ma API, ale integracja jest jeszcze w toku (C-02). Smart locki mają API (C-03). Do tego urządzenia przy wózkach (FR-13) i cztery kanały przez jedno API (FR-03). Zmiana API legacy ma ruszać tylko Synchronizację (AC-01).
3. Odporność na awarie: w sezonie hotel nie może stanąć. Jak legacy nie odpowiada przez pół godziny, check-in, checkout i sprzątanie działają dalej, a płatności czekają w kolejce (AC-02, AC-03). Jak padnie serwis rezerwacji, housekeeping dalej działa (AC-04).

Z Event Stormingu wyszło osiem kontekstów (BC-01 do BC-08). Dwa kanały mogą chcieć ten sam pokój na tę samą noc, więc blokada pokoju na noc musi być jedną transakcją (hotspot w BC-01).

## Decision

Wybraliśmy styl service-based: pięć dużych serwisów domenowych i jedna wspólna baza.

Ramki z tablicy mapujemy na serwisy tak:

- M-01 Rezerwacje: ramka Rezerwacja razem z dostępnością i statusem pokoju (BC-01), bo zablokowanie pokoju na noc musi być jedną transakcją.
- M-02 Housekeeping: ramki Housekeeping i Servis tech (BC-02, BC-03), bo to ci sami ludzie, jedna kolejka i ten sam priorytet; do tego API dla urządzeń przy wózkach.
- M-03 Pobyt: ramki Visit i Faraway (BC-04, BC-05), bo to początek i koniec tego samego pobytu.
- M-04 Synchronizacja: ramka Synchronizacja i wywołania do Payments (BC-07, BC-08), z kolejką na czas awarii legacy.
- M-05 Oferta: ramka Marketing (BC-06), tylko do odczytu dla reszty.

W praktyce:

- Baza to zarządzany PostgreSQL z osobnym schematem na serwis. Serwisy nie czytają cudzych schematów.
- Baza ma replikę w drugiej strefie i automatyczne przełączenie w 1-2 minuty, do tego backupy (Q60).
- Każdy serwis chodzi minimum na dwóch instancjach. Wdrażamy po kolei, więc wdrożenie nie zatrzymuje rezerwacji ani check-inów (Q61).

## Alternatives Considered

- **Modularny monolit**: tańszy i prostszy, ale jak padnie aplikacja, pada wszystko, a odporność na awarie mamy w top 3.
- **Microkernel**: tańszy i prostszy, ale jak padnie aplikacja, pada wszystko, a odporność na awarie mamy w top 3.
- **Mikroserwisy**: za dużo ruchomych części jak na nasz termin.
- **Event-driven**: za dużo ruchomych części jak na nasz termin, a do tego daje spójność ostateczną tam, gdzie blokada pokoju potrzebuje transakcji.
- **Baza na serwis**: jedna baza jest prostsza, a blokadę pokoju na noc załatwia jedna transakcja w serwisie Rezerwacje.

## Consequences

### Positive

- Błąd w kodzie, wdrożenie albo przeciążenie jednego serwisu nie kładzie pozostałych (Q60).
- Jak padnie serwis Rezerwacje, housekeeping dalej działa (AC-04).
- Wciąż na tyle proste, że zdążymy na czerwiec: pięć serwisów i jedna baza.
- Blokada pokoju na noc to jedna transakcja w jednym serwisie.
- Wdrożenie nowej wersji nie zatrzymuje rezerwacji ani check-inów, bo są minimum dwie instancje i wdrażamy po kolei (Q61).

### Negative

- Oddajemy część prostoty: pięć rzeczy do wdrożenia zamiast jednej.
- Wywołania po sieci między serwisami.
- Baza jest wspólnym punktem awarii. Łapie to replika w drugiej strefie z przełączeniem w 1-2 minuty. W tym czasie wózki zapisują offline, a recepcja ma listę awaryjną (Q60, FR-18).
- Każdy serwis musimy utrzymywać na minimum dwóch instancjach (Q61).

> TODO: Co dzieje się z nowymi rezerwacjami z web, mobile i telefonu w czasie 1-2 minut przełączenia bazy? Notatki opisują tylko wózki i recepcję.

## Notes

- Spec: `zadanie/spec/01-prd.md` (C-01, C-02, C-03, FR-03, FR-13, FR-18), `zadanie/spec/02-domain.md` (BC-01 do BC-08, M-01 do M-05), `zadanie/spec/03-characteristics.md` (top 3, AC-01 do AC-04, trade-off prostota kontra odporność na awarie i prostota kontra spójność).
- Odpowiedzi na grill-me: Q31, Q60, Q61 w `zadanie/notatki.md`.
- Diagram C4: `zadanie/c4/workspace.dsl` (widok C2-Containers).
- Event Storming: `zadanie/event-storming/kata-white.png`; Miro: brak linku.
- Powiązane: ADR-002 (serwis Rezerwacje jako jedyne źródło prawdy o pokoju na noc i statusie pokoju).
- Jak sprawdzamy: test, w którym wyłączamy serwis Rezerwacje na 30 minut, a check-in, checkout i sprzątanie działają.
- Nie optymalizujemy pod skalowanie; wracamy do tematu, jak przekroczymy ok. 100 rezerwacji na minutę (ADR-008).
