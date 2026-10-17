# ADR-003: Integracja z legacy przez API od razu, z kolejką i porównaniem raz dziennie

Status: Accepted  
Date: 2026-10-17  
Author: Zespół White (Marek, Patryk, Mariusz, Kamil)

## Context

Nasz system musi współpracować z istniejącym systemem rezerwacji (legacy). Trzeba ustalić, jak i jak często wymieniamy z nim rezerwacje i płatności.

- Standardowa funkcjonalność rezerwacji, np. płatności, korzysta z istniejącego systemu rezerwacji (zadanie, wymaganie 05). Wszystko z rezerwacji dzieje się u nas oprócz płatności; płatność robi legacy przez API (C-05). Anulowania i zwroty też robi legacy (C-06). Nie chcemy trzymać danych kart.
- Legacy ma API, ale integracja jest jeszcze w toku (C-02). Nie wiemy, kiedy API będzie gotowe i czy zdążymy przed czerwcem (Q-01).
- Sezon startuje na początku czerwca, obłożenie dochodzi do ok. 90% (C-01). System ma działać w czerwcu albo czekamy rok.
- Wcześniej zakładaliśmy synchronizację z legacy raz dziennie (Q29 przed zmianą). Sama synchronizacja raz dziennie nie potwierdziłaby jednak płatności (Q29, zmiana).
- W top 3 charakterystyk są integracje i odporność na awarie. Zmiana API legacy ma ruszać tylko Synchronizację, nie resztę systemu (AC-01). Jak legacy nie odpowiada przez pół godziny, check-in, checkout i sprzątanie działają dalej, a płatności czekają w kolejce (AC-02).
- Synchronizacja to jedyne miejsce, które rozmawia z legacy (BC-07, M-04). Legacy jest schowane za Synchronizacją, żeby jego model nie wyciekał do reszty systemu.

## Decision

Rezerwacje i płatności wysyłamy do legacy od razu przez API, a raz dziennie robimy tylko porównanie danych z legacy (FR-07, FR-08). Z legacy rozmawia wyłącznie serwis Synchronizacja (M-04).

- Synchronizacja jest jedynym serwisem, który woła legacy: pre-rezerwacje i pula, rezerwacje, płatności (Payments, BC-08), ceny, raporty check-in i checkout, porównanie danych.
- Płatności zostają w legacy, my tylko wysyłamy żądanie przez Synchronizację (C-05, wymaganie 05). Nie trzymamy danych kart.
- Gdy legacy nie odpowiada, żądania czekają w kolejce w Synchronizacji i idą do legacy po jego powrocie (na diagramie C4: outbox, scenariusz D3-LegacyDown). Check-in, checkout i sprzątanie działają w tym czasie dalej.
- Gdy płatność czeka w kolejce, blokada pokoju nie wygasa po 10 minutach (A-03), tylko trzyma do odpowiedzi legacy, bo inaczej sprzedalibyśmy pokój, za który gość już płaci (FR-06).
- Gdy płatność z kolejki zostanie odrzucona, blokada pokoju się zwalnia, gość dostaje maila i SMS z linkiem do ponownej płatności, a przy gościach VIP dzwoni recepcja (FR-21, Q65).
- Plan B: jeśli API legacy nie zdąży na czerwiec, wymieniamy dane z legacy plikami co 15 minut.

> TODO: Jak w planie B (pliki co 15 minut) potwierdzamy płatność, skoro synchronizacja raz dziennie odpadła właśnie dlatego, że nie potwierdzała płatności?

> TODO: Kto i kiedy decyduje o przejściu na plan B?

## Alternatives Considered

- **Tylko synchronizacja z legacy raz dziennie** (nasza wcześniejsza decyzja, Q29): sama synchronizacja raz dziennie nie potwierdziłaby płatności.
- **Czekanie na idealne API legacy**: nie zdążylibyśmy na termin (C-01); zamiast czekać mamy plan B z plikami co 15 minut.

## Consequences

### Positive

- Płatność potwierdzamy od razu, a nie dopiero przy synchronizacji raz dziennie (FR-07).
- Zmiana API legacy zmienia kod tylko w Synchronizacji; reszta systemu nie zna modelu legacy (AC-01).
- Gdy legacy nie odpowiada, check-in, checkout i sprzątanie działają dalej, a płatności czekają w kolejce (AC-02).
- Nie trzymamy danych kart; płatności, anulowania i zwroty zostają w legacy (C-05, C-06).
- Nie czekamy na idealne API legacy, bo mamy plan B z plikami.

### Negative

- Zależymy od API legacy, którego integracja jest jeszcze w toku (C-02, Q-01).
- W planie B z plikami płacimy opóźnieniem do 15 minut w trybie awaryjnym.

## Notes

- Spec: `zadanie/spec/01-prd.md` (FR-06, FR-07, FR-08, FR-21, C-01, C-02, C-05, C-06, A-03, Q-01), `zadanie/spec/02-domain.md` (BC-07, BC-08, M-04, context map), `zadanie/spec/03-characteristics.md` (top 3: integracje i odporność na awarie, AC-01, AC-02, trade-off integracje kontra termin).
- Zadanie: `zadanie/zadanie.md`, wymaganie 05.
- Odpowiedzi na grill-me: Q7, Q28, Q29, Q65 w `zadanie/notatki.md`.
- Diagram C4: `zadanie/c4/workspace.dsl` (Synchronizacja Service, widok D3-LegacyDown).
- Jak mierzymy: zmiana API legacy zmienia kod tylko w Synchronizacji; testy kontraktowe z API legacy przy każdym buildzie.
- Event Storming: `zadanie/event-storming/kata-white.png` (ramki Synchronizacja i Payments); Miro: brak linku.
- Powiązane: ADR-001 (styl service-based, Synchronizacja jako jeden z pięciu serwisów), ADR-002 (Rezerwacje jako źródło prawdy o pokoju na noc; tam też FR-06, FR-07, FR-08), ADR-004 (wspólna baza; na diagramie C4 kolejka Synchronizacji to outbox w tej bazie).
- Otwarte: kiedy będzie gotowe API legacy i czy zdążymy przed czerwcem (Q-01).
