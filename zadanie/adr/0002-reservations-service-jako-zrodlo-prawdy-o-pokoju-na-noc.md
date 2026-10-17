# ADR-002: Reservations Service jako jedyne źródło prawdy o pokoju na noc i statusie pokoju

Status: Accepted  
Date: 2026-10-17  
Author: Zespół White (Marek, Patryk, Mariusz, Kamil)

## Context

O pokojach wiedzą dwa systemy: legacy i nasz. Trzeba ustalić, który decyduje, czy pokój jest zajęty danej nocy i w jakim jest stanie.

- Legacy odgórnie blokuje pulę pokoi dla nas i nie może ich sprzedać (C-07, Q26). Ta blokada w legacy to pre-rezerwacja (Q3). Zakładamy, że legacy umie już dziś blokować pokoje (A-01), ale tego nie wiemy na pewno (Q-03).
- Wszystkie kanały (web, mobile, telefon, walk-in) idą przez jedno API rezerwacji (FR-03). Dwa kanały mogą chcieć ten sam pokój na tę samą noc (hotspot w BC-01).
- Zadanie wymaga, żeby system trzymał status pokoju i to, kiedy pokój będzie potrzebny (wymaganie 03). Priorytet sprzątania wynika z tego, kiedy pokój jest znowu potrzebny (FR-12). Housekeeping obejmuje wszystkie pokoje hotelu, także spoza puli (FR-17).
- „Dostępny” to wolny do sprzedaży, „gotowy” to posprzątany. To dwa różne stany (Q18).
- Legacy nie ma API. Wymieniamy z nim pliki w obie strony (C-02), zakładamy co 15 minut (A-05); płatność przy rezerwacji to preautoryzacja u zewnętrznego operatora płatności (FR-22, ADR-003).

## Decision

Reservations Service (M-01, ramka Rezerwacja, BC-01) jest jedynym źródłem prawdy o pokoju na noc i o statusie pokoju.

- Dla pokoi z puli tylko nasz system decyduje, czy pokój jest zajęty danej nocy. Legacy tych pokoi nie sprzedaje (FR-05, Q1).
- Status pokoju i „pokój potrzebny o” Reservations Service trzyma dla wszystkich pokoi hotelu. Dla pokoi spoza puli Legacy Sync Service (ramka Synchronizacja) przekazuje do Reservations Service rezerwacje z pliku z legacy. Reservations Service wysyła „pokój potrzebny o” do Housekeeping Service (ramki Housekeeping i Servis tech; FR-17, Q63).
- Tylko Reservations Service może zająć pokój na noc i zmienić jego stan. Check-in i checkout ze Stay Service (ramki Visit i Faraway) oraz „pokój gotowy” i „usterka” z Housekeeping Service docierają do Reservations Service jako zdarzenia przez kolejkę (ADR-005).
- Niezapłacona rezerwacja trzyma pokój przez 10 minut, potem pokój wraca do sprzedaży (A-03, FR-21, Q7). 10 minut to czas, w którym gość płaci u operatora płatności; na legacy nic nie czeka (ADR-003).
- Raz dziennie Legacy Sync Service robi pełne porównanie danych z legacy (FR-08, ADR-003). Gdy porównanie znajdzie różnicę, dla pokoi z puli wygrywa nasz system, a dla pokoi spoza puli wygrywa legacy. Listę różnic dostaje rano manager hotelu.
- Pokój z puli niesprzedany na 48 godzin przed nocą oddajemy do legacy w pliku. To nadpisanie pre-rezerwacji: oddaje pokój z powrotem do legacy i nie anuluje niczyjej rezerwacji (FR-19, Q3).
- Jeśli legacy nie umie blokować pokoi (A-01), pulę blokujemy w legacy jedną długą techniczną rezerwacją na każdy pokój z puli.

## Alternatives Considered

- **Prawda o pokoju na noc i statusie w legacy**: legacy nie sprzedaje puli, a sprzątanie potrzebuje jednego statusu.
- **Sposób wymiany danych z legacy** (jak często i czym): to osobna decyzja, alternatywy w ADR-003.

## Consequences

### Positive

- Pokój na noc zapisujemy w jednym miejscu. Razem z pulą to pilnuje, żeby nie było podwójnej rezerwacji.
- Housekeeping Service dostaje jeden status i jeden termin „pokój potrzebny o” dla wszystkich pokoi i z tego liczy priorytet (FR-12, FR-17).

### Negative

- Musimy codziennie porównywać dane z legacy (FR-08).
- Dla pokoi spoza puli status i „pokój potrzebny o” zależą od plików z legacy, więc mogą być spóźnione do 15 minut (FR-17, Q55, ADR-003).
- Jak Reservations Service leży, stan pokoju nie zmienia się nigdzie: Stay Service i Housekeeping Service pracują na ostatnim znanym stanie, a status uzupełnia się po powrocie Reservations Service (ADR-005).

## Notes

- Spec: `zadanie/spec/01-prd.md` (FR-03, FR-05, FR-08, FR-12, FR-17, FR-19, FR-21, FR-22, C-02, C-07, A-01, A-03, A-05, Q-03, Q-05), `zadanie/spec/02-domain.md` (BC-01, BC-07, M-01, context map), `zadanie/spec/03-characteristics.md` (spójność danych w „Considered, Not Driving”).
- Odpowiedzi na grill-me: Q1, Q3, Q7, Q18, Q26, Q55, Q62, Q63 w `zadanie/notatki.md`; sekcja „Doprecyzowania po ADR-ach” (Pokój i status, Legacy (pliki)).
- Diagram C4: `zadanie/c4/workspace.dsl` (kontener Reservations Service, widoki D1-KeyFlow i D3-LegacyDown).
- Event Storming: `zadanie/event-storming/kata-white.png` (ramki Rezerwacja i Synchronizacja); Miro: brak linku.
- Powiązane: ADR-001 (styl service-based, pięć serwisów ze wspólną bazą), ADR-003 (wymiana plików z legacy, pełne porównanie raz dziennie, płatność u operatora), ADR-005 (zdarzenia o zmianie statusu pokoju i kopie danych w Stay Service i Housekeeping Service).
- Otwarte: czy blokowanie pokoi w legacy już dziś działa (Q-03); jak duża ma być pula na hotel i kto ją ustala (Q-05).
