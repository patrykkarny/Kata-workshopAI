# ADR-001: Styl service-based: pięć serwisów domenowych ze wspólną bazą

Status: Accepted  
Date: 2026-10-17  
Author: Zespół White (Marek, Patryk, Mariusz, Kamil)

## Context

Budujemy system „Room with a View” dla sieci 107 hoteli. Sezon startuje na początku czerwca, obłożenie dochodzi do ok. 90% (C-01). System ma działać w czerwcu albo czekamy rok.

Pojedyncza rezerwacja to mały ruch: ok. 6400 rezerwacji dziennie w 107 hotelach, czyli jedna co 14 sekund, a w najgorszej godzinie ok. 21 na minutę. Platforma od pierwszego dnia obsługuje jednak 107 hoteli naraz i ma przyjmować kolejne, a check-iny i checkouty we wszystkich hotelach wypadają w tych samych godzinach.

Nasze top 3 charakterystyki (Q31):

1. Prostota: prosta architektura, mało serwisów, jedna baza, bez egzotycznej technologii, bo robi to normalny zespół i ma zdążyć przed sezonem.
2. Skalowalność: chodzi o wzrost, a nie o nagłe skoki. Od pierwszego dnia 107 hoteli i ok. 21 tys. pokoi, firma ma dokładać kolejne hotele, a okna check-in i checkout we wszystkich hotelach się pokrywają. Nowy hotel to konfiguracja, a nie zmiana kodu, a serwis, który się dławi, dostaje więcej instancji bez ruszania reszty (ADR-008). Elastyczność zostaje odrzucona, bo szczyt sezonu znamy z góry.
3. Odporność na awarie: w sezonie przy 90% obłożenia hotel nie może stanąć. Nic w rezerwacji, check-inie, checkoucie ani sprzątaniu nie czeka na legacy na żywo, więc jak legacy leży albo plik nie przyjdzie, hotel działa dalej. Jak padnie serwis rezerwacji, housekeeping dalej działa (AC-04).

Integracje są ważne, ale poza top 3: dużo idzie przez cudze systemy (pliki z legacy, smart locki, urządzenia przy wózkach, operator płatności), więc każdą integrację trzymamy w jednym miejscu: legacy w Synchronizacji (ADR-003), zamki w Pobycie (ADR-007).

Ocena stylów w arkuszu V2.0 (skala 1-5) dla naszych trzech charakterystyk:

| Styl | Prostota | Skalowalność | Odporność na awarie | Suma |
|---|---|---|---|---|
| Event-driven | 2 | 4 | 5 | 11 |
| Mikroserwisy | 1 | 5 | 5 | 11 |
| Service-based | 3 | 3 | 4 | 10 |
| Space-based | 1 | 5 | 3 | 9 |
| Warstwowy | 5 | 1 | 1 | 7 |
| Modularny monolit | 5 | 1 | 1 | 7 |
| Service-oriented | 1 | 3 | 3 | 7 |
| Microkernel | 4 | 1 | 1 | 6 |

Z Event Stormingu wyszło osiem kontekstów (BC-01 do BC-08). Dwa kanały mogą chcieć ten sam pokój na tę samą noc, więc blokada pokoju na noc musi być jedną transakcją (hotspot w BC-01).

## Decision

Wybraliśmy styl service-based: pięć dużych serwisów domenowych i jedna wspólna baza.

W ocenie service-based ma 10 punktów, o 1 mniej niż event-driven i mikroserwisy. Wybieramy go mimo to, bo:

- prostota ma u niego 3, a u event-driven 2 i u mikroserwisów 1, a system musi działać w czerwcu;
- blokada pokoju na noc to jedna transakcja, a nie spójność ostateczna;
- przy ok. 21 rezerwacjach na minutę w najgorszej godzinie wystarczy dokładać instancje pojedynczym serwisom (ADR-008).

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

- **Event-driven (11)**: prostota 2, za dużo ruchomych części jak na nasz termin, a do tego daje spójność ostateczną tam, gdzie blokada pokoju potrzebuje transakcji. Kolejka zdarzeń z ADR-005 służy tylko do zmian statusu pokoju, nie jest stylem całego systemu.
- **Mikroserwisy (11)**: prostota 1, za dużo ruchomych części jak na nasz termin; przy naszym ruchu dokładanie instancji serwisu wystarczy (trade-off prostota kontra skalowalność).
- **Space-based (9)**: niższa suma i prostota 1.
- **Service-oriented (7)**: niższa suma i prostota 1.
- **Warstwowy (7)** i **modularny monolit (7)**: tańsze i prostsze, ale skalowalność i odporność na awarie mają po 1: jak padnie aplikacja, pada wszystko.
- **Microkernel (6)**: tańszy i prostszy, ale skalowalność i odporność na awarie ma po 1: jak padnie aplikacja, pada wszystko.
- **Baza na serwis**: rozpisane w ADR-004.

## Consequences

### Positive

- Błąd w kodzie, wdrożenie albo przeciążenie jednego serwisu nie kładzie pozostałych (Q60).
- Jak padnie serwis Rezerwacje, check-in, checkout i sprzątanie działają dalej, bo zmiany statusu pokoju idą przez kolejkę zdarzeń (AC-03, AC-04, ADR-005).
- Wciąż na tyle proste, że zdążymy na czerwiec: pięć serwisów i jedna baza.
- Blokada pokoju na noc to jedna transakcja w jednym serwisie.
- Wdrożenie nowej wersji nie zatrzymuje rezerwacji ani check-inów, bo są minimum dwie instancje i wdrażamy po kolei (Q61).
- Każdy serwis skalujemy osobno: jak jeden się dławi, dokładamy instancje tylko jemu (ADR-008).
- Nowy hotel to konfiguracja, a nie zmiana kodu (ADR-008).

### Negative

- Oddajemy część prostoty: pięć rzeczy do wdrożenia zamiast jednej.
- Event-driven i mikroserwisy mają w ocenie o 1 punkt więcej; skalowalność service-based to 3, a nie 5.
- Wywołania po sieci między serwisami.
- Baza jest wspólnym punktem awarii; łapie to replika z przełączeniem w 1-2 minuty (ADR-004). W czasie przełączania web, mobile i telefon dostają „spróbuj za chwilę”, zdjęcia pokoi dalej działają z CDN, wózki zapisują offline (ADR-006), a recepcja ma listę awaryjną (Q60, FR-18, ADR-005).
- Każdy serwis musimy utrzymywać na minimum dwóch instancjach (Q61).

## Notes

- Spec: `zadanie/spec/01-prd.md` (C-01, C-03, FR-03, FR-13, FR-18), `zadanie/spec/02-domain.md` (BC-01 do BC-08, M-01 do M-05), `zadanie/spec/03-characteristics.md` (AC-01, AC-03, AC-04, trade-off prostota kontra odporność na awarie i prostota kontra spójność). Spec jeszcze ma w top 3 integracje zamiast skalowalności; do aktualizacji po zmianie Q31.
- Odpowiedzi na grill-me: Q31, Q60, Q61 w `zadanie/notatki.md`; sekcje Charakterystyki i Trade-offy; sekcja „Doprecyzowania po ADR-ach” (Pokój i status, Skalowanie).
- Diagram C4: `zadanie/c4/workspace.dsl` (widok C2-Containers).
- Event Storming: `zadanie/event-storming/kata-white.png`; Miro: brak linku.
- Powiązane: ADR-002 (serwis Rezerwacje jako jedyne źródło prawdy o pokoju na noc i statusie pokoju), ADR-003 (wymiana plików z legacy i płatność), ADR-004 (wspólna baza: schematy, dostęp, replika, backupy, alternatywa „baza na serwis”), ADR-005 (kolejka zdarzeń, lista awaryjna, test z wyłączeniem serwisu Rezerwacje), ADR-006 (wózki offline), ADR-007 (smart locki w MVP), ADR-008 (skalowanie).
- Jak sprawdzamy odporność na awarie: test z wyłączeniem serwisu Rezerwacje na 30 minut, opisany w ADR-005.
- Skalowanie w poziomie per serwis, bez elastyczności, z progiem ok. 100 rezerwacji na minutę jako sygnałem do dokładania instancji: ADR-008.
