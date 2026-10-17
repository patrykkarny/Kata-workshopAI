# ADR-004: Jedna baza PostgreSQL ze schematem na serwis i repliką

Status: Accepted  
Date: 2026-10-17  
Author: Zespół White (Marek, Patryk, Mariusz, Kamil)

## Context

Mamy pięć serwisów domenowych (Rezerwacje, Housekeeping, Pobyt, Synchronizacja, Oferta) w stylu service-based ze wspólną bazą. Trzeba ustalić, jak serwisy dzielą bazę i co się dzieje, gdy baza padnie.

- Pierwsza z top 3 charakterystyk to prostota: system ma działać w czerwcu albo czekamy rok (C-01), więc mało serwisów, jedna baza, bez egzotycznej technologii. Mamy jeden stack: TypeScript i PostgreSQL.
- Dwa kanały mogą chcieć ten sam pokój na tę samą noc (hotspot w BC-01). Serwis Rezerwacje (M-01) trzyma dostępność i status pokoju, bo zablokowanie pokoju na noc musi być jedną transakcją (FR-05).
- Spójność danych jest ważna, ale poza top 3: podwójnej rezerwacji pilnuje pula i to, że pokój na noc zapisujemy w jednym miejscu.
- W top 3 jest też odporność na awarie: w sezonie przy 90% obłożenia hotel nie może stanąć (C-01).
- Wi-Fi w hotelu się rwie, dlatego aplikacja na wózki działa offline (hotspot w BC-02).

## Decision

Mamy jedną bazę PostgreSQL z osobnym schematem na serwis, a nie bazę na serwis.

- Każdy serwis ma swój schemat. Serwisy nie czytają cudzych schematów.
- Blokadę pokoju na noc załatwia jedna transakcja w serwisie Rezerwacje (M-01).
- Baza to zarządzany PostgreSQL z repliką w drugiej strefie i automatycznym przełączeniem w 1-2 minuty, do tego backupy (Q60).
- W czasie przełączenia wózki zapisują offline, a recepcja ma listę awaryjną (Q60, FR-18). Listę co 15 minut generuje serwis Pobyt i zapisuje poza naszymi serwisami: plik w magazynie plików, wysyłany też mailem do recepcji (Q66).

> TODO: Jak pilnujemy, że serwisy nie czytają cudzych schematów?

> TODO: Jak sprawdzimy, że przełączenie na replikę mieści się w 1-2 minutach?

## Alternatives Considered

- **Baza na serwis**: jedna baza jest prostsza, a blokadę pokoju na noc załatwia jedna transakcja w serwisie Rezerwacje (trade-off prostota kontra spójność).

## Consequences

### Positive

- Jest prościej niż z bazą na serwis, co pomaga zdążyć na czerwiec (prostota w top 3).
- Blokada pokoju na noc to jedna transakcja w serwisie Rezerwacje.
- Awarię samej bazy łapie replika z automatycznym przełączeniem w 1-2 minuty (Q60).

### Negative

- Baza jest wspólnym punktem awarii dla wszystkich serwisów; płacimy za to repliką w drugiej strefie i backupami.
- Przełączenie na replikę trwa 1-2 minuty; w tym czasie wózki zapisują offline, a recepcja pracuje z listy awaryjnej (Q60).

## Notes

- Spec: `zadanie/spec/01-prd.md` (FR-05, FR-18, C-01), `zadanie/spec/02-domain.md` (BC-01, BC-02, M-01 do M-05), `zadanie/spec/03-characteristics.md` (top 3: prostota i odporność na awarie, spójność danych w „Considered, Not Driving”, trade-off prostota kontra spójność).
- Odpowiedzi na grill-me: Q60, Q66 w `zadanie/notatki.md`; decyzja o jednej bazie i o jednym stacku w sekcji Decyzje.
- Diagram C4: `zadanie/c4/workspace.dsl` (kontenery Shared Database i File Storage).
- Event Storming: `zadanie/event-storming/kata-white.png`; Miro: brak linku.
- Powiązane: ADR-001 (styl service-based ze wspólną bazą; tam też alternatywa „baza na serwis”), ADR-002 (Rezerwacje jako jedyne miejsce, które zajmuje pokój na noc), ADR-003 (kolejka Synchronizacji na czas awarii legacy; na diagramie C4 to outbox w tej bazie).
