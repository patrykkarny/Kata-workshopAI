# Architecture Characteristics: Room with a View

Status: Draft  
Updated: 2026-10-17  
Authors: Zespół White (Marek, Patryk, Mariusz, Kamil)

## Top 3

| # | Characteristic | Why it drives the architecture | Evidence | Source |
|---|---|---|---|---|
| 1 | Prostota (simplicity) | chodzi o prostą architekturę, nie o łatwość obsługi; system ma działać w czerwcu albo czekamy rok i robi go normalny zespół, więc mało serwisów, jedna baza, bez egzotycznej technologii; mierzymy tym, że MVP chodzi w hotelach pilotażowych przed sezonem | C-01 | notatki, grill-me Q31 |
| 2 | Skalowalność (Scalability) | chodzi o wzrost, a nie o nagłe skoki; platforma od pierwszego dnia obsługuje 107 hoteli i ok. 21 tys. pokoi, firma ma dokładać kolejne hotele, a check-iny i checkouty we wszystkich hotelach wypadają w tych samych godzinach; nowy hotel to konfiguracja, a nie zmiana kodu, a serwis, który się dławi, dostaje więcej instancji bez ruszania reszty; mierzymy testem obciążenia na 3x najgorszą godzinę (ok. 65 rezerwacji na minutę plus checkouty ze wszystkich hoteli w oknie 10-12) przed sezonem i dodaniem nowego hotelu bez zmiany kodu | _Brak w notatkach._ | notatki, grill-me Q31 |
| 3 | Odporność na awarie (fault tolerance; Robustness) | w sezonie przy 90% obłożenia hotel nie może stanąć; nic w rezerwacji, check-inie, checkoucie ani sprzątaniu nie czeka na legacy na żywo, więc jak legacy leży albo plik nie przyjdzie, hotel działa dalej; jak padnie serwis rezerwacji, housekeeping dalej działa | C-01 | notatki, grill-me Q31 |

## Per Module

| ID | Module | Characteristic | Why | Evidence | How we measure | Source |
|---|---|---|---|---|---|---|
| AC-01 | M-04 Synchronizacja | Integracje (Interoperability) | zmiana formatu plików legacy ma ruszać tylko Synchronizację, nie resztę systemu | C-02 | zmiana formatu pliku legacy zmienia kod tylko w Synchronizacji; testy na przykładowych plikach z legacy przy każdym buildzie | notatki |
| AC-02 | M-04 Synchronizacja | Odporność na awarie (Robustness) | jak legacy nie odpowiada, płatności czekają w kolejce (usunięte) | FR-06 | legacy nie odpowiada przez pół godziny | notatki |
| AC-03 | M-03 Pobyt | Odporność na awarie (Robustness) | nic w check-inie ani checkoucie nie czeka na legacy na żywo, więc jak legacy leży albo plik nie przyjdzie, check-in i checkout działają dalej; check-in i checkout idą do Rezerwacji przez kolejkę, żeby działały, jak Rezerwacje leżą | _Brak w notatkach._ | test, w którym wyłączamy serwis Rezerwacje na 30 minut, a check-in i checkout działają | notatki |
| AC-04 | M-02 Housekeeping | Odporność na awarie (Robustness) | nic w sprzątaniu nie czeka na legacy na żywo; jak padnie serwis rezerwacji, housekeeping dalej działa, a zdarzenia „pokój gotowy” i „usterka” czekają w kolejce | _Brak w notatkach._ | test, w którym wyłączamy serwis Rezerwacje na 30 minut, a sprzątanie działa | notatki, grill-me Q62 |

## Considered, Not Driving

| Characteristic | Why not driving | Source |
|---|---|---|
| Spójność danych (Data consistency) | ważna, ale poza top 3: podwójnej rezerwacji pilnuje pula i to, że pokój na noc zapisujemy w jednym miejscu, nie wybór stylu | notatki |
| Integracje (Interoperability) | ważne, ale poza top 3: dużo idzie przez cudze systemy (pliki z legacy, smart locki, urządzenia przy wózkach, operator płatności), więc każdą trzymamy w jednym miejscu: legacy w Synchronizacji, zamki w Pobycie | notatki, grill-me Q31 |
| Bezpieczeństwo (Security) | ważne, ale poza top 3: danych kart nie widzimy, przyjmuje je operator płatności; klucz mobilny to fizyczny dostęp do pokoju, więc klucz gościa działa tylko w czasie pobytu, housekeeper dostaje klucz tylko do swojego pokoju na czas zadania, a checkout unieważnia klucz od razu | notatki |
| Łatwość obsługi (Usability) | ważna, ale to sprawa interfejsu, nie architektury | notatki |
| Ewolucyjność (Extensibility) | ważna, ale poza top 3: handlowcy cały czas coś obiecują, więc nowe rzeczy dokładamy w serwisie, którego dotyczą, albo jako adapter w Synchronizacji | notatki |
| Elastyczność (Elasticity) | odrzucona: automatyczne skalowanie w górę i w dół nie jest potrzebne, bo ruch nie ma nagłych skoków, a szczyt sezonu znamy z góry; poza sezonem nie skalujemy w dół, bo przy tym ruchu oszczędność jest mała | notatki |

## Trade-offs

- Prostota (simplicity) vs odporność na awarie (fault tolerance): oddajemy część prostoty (pięć serwisów zamiast jednej aplikacji), żeby awaria jednego obszaru nie zatrzymała hotelu. (notatki)
- Prostota (simplicity) vs spójność (Data consistency): zostajemy przy jednej bazie zamiast bazy na serwis, bo to prostsze i blokada pokoju to jedna transakcja; płacimy tym, że baza jest wspólnym punktem awarii, więc replika. (notatki)
- Prostota (simplicity) vs skalowalność (Scalability): pięć serwisów, które skalujemy osobno, zamiast jednej aplikacji; nie idziemy w mikroserwisy, bo przy naszym ruchu dokładanie instancji serwisu wystarczy. (notatki)
- Integracje (Interoperability) vs aktualność danych: legacy ma tylko pliki, więc dane o pokojach spoza puli mogą być spóźnione do 15 minut; dla puli to nie problem, bo sprzedajemy ją tylko my. (notatki)
- Bezpieczeństwo (Security) vs termin (Time to market): smart locki wchodzą do MVP, bo firma w nie inwestuje, więc przed sezonem musimy zrobić testy bezpieczeństwa; płacimy czasem w maju. (notatki)

## Open Questions

_Brak w notatkach._
