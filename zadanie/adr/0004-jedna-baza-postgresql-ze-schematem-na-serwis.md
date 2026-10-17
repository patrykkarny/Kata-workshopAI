# ADR-004: Jedna baza PostgreSQL ze schematem na serwis i repliką

Status: Accepted  
Date: 2026-10-17  
Author: Zespół White (Marek, Patryk, Mariusz, Kamil)

## Context

Mamy pięć serwisów domenowych (Reservations Service: ramka Rezerwacja; Housekeeping Service: ramki Housekeeping i Servis tech; Stay Service: ramki Visit i Faraway; Legacy Sync Service: ramka Synchronizacja; Room Offer Service: ramka Marketing) w stylu service-based ze wspólną bazą (ADR-001). Trzeba ustalić, jak serwisy dzielą bazę i co się dzieje, gdy baza padnie.

- Pierwsza z top 3 charakterystyk to prostota: system ma działać w czerwcu albo czekamy rok (C-01), więc mało serwisów, jedna baza, bez egzotycznej technologii. Mamy jeden stack: TypeScript i PostgreSQL.
- Dwa kanały mogą chcieć ten sam pokój na tę samą noc (hotspot w BC-01). Reservations Service (M-01) trzyma dostępność i status pokoju, bo zablokowanie pokoju na noc musi być jedną transakcją (FR-05).
- Spójność danych jest ważna, ale poza top 3: podwójnej rezerwacji pilnuje pula i to, że pokój na noc zapisujemy w jednym miejscu.
- W top 3 jest też odporność na awarie: w sezonie przy 90% obłożenia hotel nie może stanąć (C-01).

## Decision

Mamy jedną bazę PostgreSQL z osobnym schematem na serwis, a nie bazę na serwis.

- Każdy serwis ma swój schemat i własnego użytkownika bazy z dostępem tylko do swojego schematu, więc nie może czytać cudzych danych.
- Blokadę pokoju na noc załatwia jedna transakcja w Reservations Service (M-01).
- Baza to zarządzany PostgreSQL z repliką w drugiej strefie i automatycznym przełączeniem w 1-2 minuty (Q60).
- Przełączenie na replikę ćwiczymy raz przed sezonem, a potem raz na kwartał.
- Backup co noc plus ciągły zapis zmian: odtworzenie do dowolnej chwili z ostatnich 7 dni, odtworzenie trwa poniżej godziny.
- Outbox każdego serwisu leży w jego schemacie, razem z danymi. Sama kolejka zdarzeń to zarządzana kolejka w chmurze, która nie zależy od naszej bazy (ADR-005).

## Alternatives Considered

- **Baza na serwis**: wspólna baza to jedna baza z jedną repliką i jednym backupem zamiast pięciu, czyli prościej i taniej, a blokadę pokoju na noc załatwia jedna transakcja w Reservations Service (trade-off prostota kontra spójność).

## Consequences

### Positive

- Utrzymujemy jedną bazę z jedną repliką i jednym backupem zamiast pięciu: prościej i taniej, co pomaga zdążyć na czerwiec (prostota w top 3).
- Blokada pokoju na noc to jedna transakcja w Reservations Service.
- Awarię samej bazy łapie replika z automatycznym przełączeniem w 1-2 minuty (Q60).

### Negative

- Baza jest wspólnym punktem awarii dla wszystkich serwisów; płacimy za to repliką w drugiej strefie i backupami.
- Przełączenie na replikę trwa 1-2 minuty; co w tym czasie widzą kanały, recepcja i wózki, opisuje ADR-001 (FR-29).

## Notes

- Spec: `zadanie/spec/01-prd.md` (FR-05, FR-29, C-01), `zadanie/spec/02-domain.md` (BC-01, M-01 do M-05), `zadanie/spec/03-characteristics.md` (top 3: prostota i odporność na awarie, spójność danych w „Considered, Not Driving”, trade-off prostota kontra spójność).
- Odpowiedzi na grill-me: Q60 w `zadanie/notatki.md`; decyzja o jednej bazie i o jednym stacku w sekcji Decyzje; sekcja „Doprecyzowania po ADR-ach” (Baza, Kolejka).
- Diagram C4: `zadanie/c4/workspace.dsl` (kontener Shared Database).
- Event Storming: `zadanie/event-storming/kata-white.png`; Miro: brak linku.
- Powiązane: ADR-001 (styl service-based ze wspólną bazą; zachowanie systemu w czasie przełączania bazy), ADR-002 (Reservations Service jako jedyne miejsce, które zajmuje pokój na noc), ADR-005 (outbox i kolejka zdarzeń).
