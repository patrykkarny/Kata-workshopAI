# ADR-003: Integracja z legacy przez dwukierunkową wymianę plików

Status: Accepted  
Date: 2026-10-17  
Author: Zespół White (Marek, Patryk, Mariusz, Kamil)

## Context

Nasz system musi współpracować z istniejącym systemem rezerwacji (legacy). Trzeba ustalić, jak i jak często wymieniamy z nim dane i jak gość płaci.

- Standardowa funkcjonalność rezerwacji, np. płatności, korzysta z istniejącego systemu rezerwacji (zadanie, wymaganie 05). Wszystko z rezerwacji dzieje się u nas oprócz płatności (Q28). Anulowania i zwroty robi legacy (C-06). Nie chcemy trzymać danych kart.
- Wcześniej zakładaliśmy, że legacy ma API, a integracja jest w toku (C-02). Zmiana: legacy nie ma API. Z legacy wymieniamy pliki w obie strony: legacy przysyła pokoje, które nasz system może rezerwować, a nasz system odsyła, które z nich są zarezerwowane (odpowiedź biznesu).
- Nie wiemy jeszcze, jak często legacy może wysyłać i przyjmować pliki i w jakim formacie.
- Sezon startuje na początku czerwca, obłożenie dochodzi do ok. 90% (C-01). W maju pilot w 2-3 hotelach (Q64).
- Housekeeping obejmuje wszystkie pokoje hotelu, także spoza puli (FR-17), więc potrzebuje świeżych wymeldowań z pokoi spoza puli.
- W top 3 charakterystyk są integracje i odporność na awarie. Zmiana formatu plików legacy ma ruszać tylko Synchronizację, nie resztę systemu (AC-01). Nic w rezerwacji, check-inie, checkoucie ani sprzątaniu nie może czekać na legacy na żywo.
- Synchronizacja to jedyne miejsce, które wymienia pliki z legacy (BC-07, M-04). Legacy jest schowane za Synchronizacją, żeby jego model nie wyciekał do reszty systemu.

## Decision

Z legacy wymieniamy pliki w obie strony, zakładamy co 15 minut, a raz dziennie robimy pełne porównanie danych (Q29, FR-08). Pliki wymienia wyłącznie serwis Synchronizacja (M-04). Płatność opisujemy w tym ADR, bo to część tej samej rozmowy z legacy.

Od legacy dostajemy:

- pulę pokoi, które możemy sprzedawać,
- ceny,
- rezerwacje, zameldowania i wymeldowania pokoi spoza puli, bo housekeeping robi wszystkie pokoje (Q55); Synchronizacja przekazuje rezerwacje do Rezerwacji (Q63).

Do legacy wysyłamy:

- które pokoje z puli są zarezerwowane: nasze rezerwacje z danymi gościa,
- check-iny i checkouty,
- numer preautoryzacji, żeby legacy rozliczył pobyt,
- pokoje z puli oddawane do legacy (nadpisanie pre-rezerwacji, ADR-002).

W praktyce:

- Każdy plik ma numer kolejny. Import jest powtarzalny, więc ten sam plik wczytany dwa razy nic nie psuje. Brak pliku daje alert.
- Nic w rezerwacji, check-inie, checkoucie ani sprzątaniu nie czeka na legacy na żywo. Jak legacy leży albo plik nie przyjdzie, hotel działa dalej.
- Jak legacy umie tylko raz dziennie, pula dalej jest bezpieczna, a wymeldowania spoza puli recepcja zgłasza ręcznie.
- Różnice z pełnego porównania rozstrzyga reguła z ADR-002.

Płatność:

- Przy rezerwacji gość płaci na stronie zewnętrznego operatora płatności (preautoryzacja). Danych kart nie widzimy, przyjmuje je operator.
- W web i mobile gość przechodzi z naszej aplikacji na stronę operatora i wraca z potwierdzeniem; przy rezerwacji telefonicznej recepcja wysyła gościowi link do płatności SMS-em albo mailem.
- Pobyt rozlicza legacy przy wymeldowaniu, jak dziś; zwroty też robi legacy (C-06). Numer preautoryzacji legacy dostaje w pliku.
- Gość ma 10 minut na zapłatę u operatora (A-03, ADR-002). Jak operator odrzuci kartę, gość od razu to widzi i może podać inną. Jak nie zapłaci w 10 minut, blokada się zwalnia, a przy gościach VIP dzwoni recepcja (Q65).
- Zostajemy przy legacy tam, gdzie się da (wymaganie 05). Czy biznes zgadza się na preautoryzację u operatora z rozliczeniem w legacy przy wymeldowaniu, jest jeszcze otwarte.

## Alternatives Considered

- **Wymiana danych z legacy tylko raz dziennie** (nasza wcześniejsza odpowiedź, Q29): housekeeping potrzebuje świeżych wymeldowań z pokoi spoza puli.
- **Czekanie na API legacy**: legacy nie ma API, więc innej drogi niż pliki nie ma.
- **Płatność przez legacy na żywo**: legacy nie ma API do płatności na żywo.
- **Płatności i dane kart u nas**: nie chcemy trzymać danych kart.

## Consequences

### Positive

- Nic nie czeka na legacy na żywo, więc jak legacy leży albo plik nie przyjdzie, rezerwacje, check-in, checkout i sprzątanie działają dalej (odporność na awarie w top 3).
- Pula jest tylko nasza, więc opóźnienie plików nie grozi podwójną rezerwacją.
- Zmiana formatu pliku legacy zmienia kod tylko w Synchronizacji; reszta systemu nie zna modelu legacy (AC-01).
- Ten sam plik wczytany dwa razy nic nie psuje, a brak pliku widać od razu dzięki alertowi.
- Nie widzimy danych kart; przyjmuje je operator płatności.
- Gość od razu widzi odrzuconą kartę i może podać inną (Q65).

### Negative

- Dane o pokojach spoza puli mogą być spóźnione do 15 minut (trade-off integracje kontra aktualność).
- Jak legacy umie wymieniać pliki tylko raz dziennie, recepcja zgłasza wymeldowania spoza puli ręcznie.
- Dochodzi jeszcze jeden zewnętrzny system: operator płatności. Zgoda biznesu na ten sposób płatności jest jeszcze otwarta.

## Notes

- Spec: `zadanie/spec/01-prd.md` (FR-08, FR-17, FR-19, C-01, C-06, A-03), `zadanie/spec/02-domain.md` (BC-07, BC-08, M-04, context map), `zadanie/spec/03-characteristics.md` (top 3: integracje i odporność na awarie, AC-01). Spec jeszcze opisuje API legacy i płatności przez legacy (C-02, C-05, FR-06, FR-07, FR-21, AC-02, Q-01); do aktualizacji po tej zmianie.
- Zadanie: `zadanie/zadanie.md`, wymaganie 05.
- Odpowiedzi na grill-me: Q7, Q28, Q29, Q55, Q63, Q64, Q65 w `zadanie/notatki.md`; sekcje Decyzje, Trade-offy i „Doprecyzowania po ADR-ach” (Legacy (pliki)).
- Jak mierzymy: zmiana formatu pliku legacy zmienia kod tylko w Synchronizacji; testy na przykładowych plikach z legacy przy każdym buildzie.
- Diagram C4: `zadanie/c4/workspace.dsl` (Synchronizacja Service, Payment Operator, widoki D1-KeyFlow i D3-LegacyDown).
- Event Storming: `zadanie/event-storming/kata-white.png` (ramki Synchronizacja i Payments); Miro: brak linku.
- Powiązane: ADR-001 (styl service-based, Synchronizacja jako jeden z pięciu serwisów), ADR-002 (Rezerwacje jako źródło prawdy o pokoju na noc; reguła rozstrzygania różnic z porównania, oddawanie pokoi z puli, A-01).
- Otwarte: jak często legacy może wysyłać i przyjmować pliki i w jakim formacie; czy biznes zgadza się na preautoryzację u zewnętrznego operatora płatności przy rezerwacji, z rozliczeniem w legacy przy wymeldowaniu.
