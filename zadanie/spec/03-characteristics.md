# Architecture Characteristics: Room with a View

Status: Draft  
Updated: 2026-10-17  
Authors: Zespół White (Marek, Patryk, Mariusz, Kamil)

## Top 3

| # | Characteristic | Why it drives the architecture | Evidence | Source |
|---|---|---|---|---|
| 1 | Prostota (simplicity) | chodzi o prostą architekturę, nie o łatwość obsługi; system ma działać w czerwcu albo czekamy rok i robi go normalny zespół, więc mało serwisów, jedna baza, bez egzotycznej technologii; mierzymy tym, że MVP chodzi w hotelach pilotażowych przed sezonem | C-01 | notatki, grill-me Q31 |
| 2 | Integracje (Interoperability) | prawie wszystko idzie przez cudze systemy: legacy, smart locki, urządzenia przy wózkach, cztery kanały; zmiana API legacy ma ruszać tylko Synchronizację, nie resztę systemu | C-02, C-03, FR-03, FR-13 | notatki, grill-me Q31 |
| 3 | Odporność na awarie (fault tolerance; Robustness) | w sezonie przy 90% obłożenia hotel nie może stanąć; jak legacy nie odpowiada przez pół godziny, check-in, checkout i sprzątanie działają dalej, a płatności czekają w kolejce; jak padnie serwis rezerwacji, housekeeping dalej działa | C-01, FR-06 | notatki, grill-me Q31 |

## Per Module

| ID | Module | Characteristic | Why | Evidence | How we measure | Source |
|---|---|---|---|---|---|---|
| AC-01 | M-04 Synchronizacja | Integracje (Interoperability) | zmiana API legacy ma ruszać tylko Synchronizację, nie resztę systemu | C-02 | zmiana API legacy zmienia kod tylko w Synchronizacji; testy kontraktowe z API legacy przy każdym buildzie | notatki |
| AC-02 | M-04 Synchronizacja | Odporność na awarie (Robustness) | jak legacy nie odpowiada, płatności czekają w kolejce | FR-06 | legacy nie odpowiada przez pół godziny | notatki |
| AC-03 | M-03 Pobyt | Odporność na awarie (Robustness) | jak legacy nie odpowiada, check-in i checkout działają dalej | _Brak w notatkach._ | legacy nie odpowiada przez pół godziny; test, w którym wyłączamy serwis Rezerwacje na 30 minut, a check-in i checkout działają | notatki |
| AC-04 | M-02 Housekeeping | Odporność na awarie (Robustness) | jak legacy nie odpowiada, sprzątanie działa dalej; jak padnie serwis rezerwacji, housekeeping dalej działa, a zdarzenia „pokój gotowy” i „usterka” czekają w kolejce | _Brak w notatkach._ | legacy nie odpowiada przez pół godziny; test, w którym wyłączamy serwis Rezerwacje na 30 minut, a sprzątanie działa | notatki, grill-me Q62 |

## Considered, Not Driving

| Characteristic | Why not driving | Source |
|---|---|---|
| Spójność danych (Data consistency) | ważna, ale poza top 3: podwójnej rezerwacji pilnuje pula i to, że pokój na noc zapisujemy w jednym miejscu, nie wybór stylu | notatki |
| Bezpieczeństwo (Security) | ważne, ale poza top 3: dane kart zostają w legacy, klucze mobilne dopiero w etapie 2, housekeeper dostaje klucz tylko do swojego pokoju na czas sprzątania | notatki |
| Łatwość obsługi (Usability) | ważna, ale to sprawa interfejsu, nie architektury | notatki |
| Ewolucyjność (Extensibility) | ważna, ale poza top 3: handlowcy cały czas coś obiecują, więc nowe rzeczy dokładamy w serwisie, którego dotyczą, albo jako adapter w Synchronizacji | notatki |
| Skalowalność i elastyczność (Scalability, Elasticity) | odrzucone: jedna rezerwacja co 14 sekund to mało, ruch jest mały, a „peak season” w zadaniu chodzi o termin, nie o ruch | notatki |

## Trade-offs

- Prostota (simplicity) vs odporność na awarie (fault tolerance): oddajemy część prostoty (pięć serwisów zamiast jednej aplikacji), żeby awaria jednego obszaru nie zatrzymała hotelu. (notatki)
- Prostota (simplicity) vs spójność (Data consistency): zostajemy przy jednej bazie zamiast bazy na serwis, bo to prostsze i blokada pokoju to jedna transakcja; płacimy tym, że baza jest wspólnym punktem awarii, więc replika. (notatki)
- Integracje (Interoperability) vs termin (Time to market): nie czekamy na idealne API legacy, mamy plan B z plikami, za cenę opóźnienia do 15 minut w trybie awaryjnym. (notatki)
- Bezpieczeństwo (Security) vs termin (Time to market): smart locki przesuwamy do etapu 2, na start karty jak dziś. (notatki)

## Open Questions

_Brak w notatkach._
