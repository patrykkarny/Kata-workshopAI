# ADR-002: Serwis Rezerwacje jako jedyne źródło prawdy o pokoju na noc i statusie pokoju

Status: Accepted  
Date: 2026-10-17  
Author: Zespół White (Marek, Patryk, Mariusz, Kamil)

## Context

O pokojach wiedzą dwa systemy: legacy i nasz. Trzeba ustalić, który decyduje, czy pokój jest zajęty danej nocy i w jakim jest stanie.

- Legacy odgórnie blokuje pulę pokoi dla nas i nie może ich sprzedać (C-07, Q26). Ta blokada w legacy to pre-rezerwacja (Q3). Zakładamy, że legacy umie już dziś blokować pokoje (A-01).
- Wszystkie kanały (web, mobile, telefon, walk-in) idą przez jedno API rezerwacji (FR-03). Dwa kanały mogą chcieć ten sam pokój na tę samą noc (hotspot w BC-01).
- Zadanie wymaga, żeby system trzymał status pokoju i to, kiedy pokój będzie potrzebny (wymaganie 03). Priorytet sprzątania wynika z tego, kiedy pokój jest znowu potrzebny (FR-12). Housekeeping obejmuje wszystkie pokoje hotelu, także spoza puli (FR-17).
- „Dostępny” to wolny do sprzedaży, „gotowy” to posprzątany. To dwa różne stany (Q18).
- Wszystko z rezerwacji dzieje się u nas oprócz płatności. Płatność robi legacy przez API (C-05). API legacy jest jeszcze w toku (C-02), a legacy może nie odpowiadać.

## Decision

Serwis Rezerwacje (M-01, BC-01) jest jedynym źródłem prawdy o pokoju na noc i o statusie pokoju.

- Dla pokoi z puli tylko nasz system decyduje, czy pokój jest zajęty danej nocy. Legacy tych pokoi nie sprzedaje (FR-05, Q1).
- Status pokoju i „pokój potrzebny o” Rezerwacje trzymają dla wszystkich pokoi hotelu. Dla pokoi spoza puli Synchronizacja przekazuje do Rezerwacji rezerwacje z legacy. Rezerwacje wysyłają „pokój potrzebny o” do Housekeepingu (Q63).
- Tylko Rezerwacje mogą zająć pokój na noc. Pobyt (Visit, Faraway) prosi Rezerwacje o zmianę stanu pokoju. Housekeeping i Servis tech mówią Rezerwacjom, że pokój jest gotowy albo ma usterkę (Q62).
- Niezapłacona rezerwacja trzyma pokój przez 10 minut, potem pokój wraca do sprzedaży (A-03, Q7).
- Gdy legacy leży i płatność czeka w kolejce, blokada nie wygasa po 10 minutach. Trzyma do odpowiedzi legacy, bo inaczej sprzedalibyśmy pokój, za który gość już płaci (FR-06, Q7). Gdy płatność z kolejki zostanie odrzucona, blokada się zwalnia (FR-21).
- Rezerwacje i płatności wysyłamy do legacy od razu (FR-07). Raz dziennie porównujemy dane z legacy (FR-08).
- Nadpisanie pre-rezerwacji oddaje pokój z powrotem do legacy i nie anuluje niczyjej rezerwacji (FR-19, Q3).

## Alternatives Considered

- **Prawda o pokoju na noc i statusie w legacy**: legacy nie sprzedaje puli, a sprzątanie potrzebuje jednego statusu.
- **Synchronizacja z legacy tylko raz dziennie**: sama synchronizacja raz dziennie nie potwierdziłaby płatności (Q29, zmiana).

## Consequences

### Positive

- Pokój na noc zapisujemy w jednym miejscu. Razem z pulą to pilnuje, żeby nie było podwójnej rezerwacji.
- Housekeeping dostaje jeden status i jeden termin „pokój potrzebny o” dla wszystkich pokoi i z tego liczy priorytet (FR-12, FR-17).
- Nie sprzedamy pokoju, za który gość już płaci, nawet gdy legacy leży (FR-06).

### Negative

- Musimy codziennie porównywać dane z legacy (FR-08).
- Gdy legacy leży, pokój z płatnością w kolejce jest zablokowany dłużej niż 10 minut, do odpowiedzi legacy (FR-06).
- Dla pokoi spoza puli status i „pokój potrzebny o” zależą od danych z legacy, które bierzemy co kilka minut (FR-17); w planie B z plikami opóźnienie do 15 minut.
- Jak Rezerwacje leżą, zdarzenia „pokój gotowy” i „usterka” czekają w kolejce, a status na recepcji uzupełnia się dopiero po powrocie (Q62).

> TODO: Co robimy, gdy codzienne porównanie pokaże różnicę między naszym systemem a legacy? Kto ją rozwiązuje i który system wygrywa dla pokoi spoza puli?

## Notes

- Spec: `zadanie/spec/01-prd.md` (FR-03, FR-05, FR-06, FR-07, FR-08, FR-12, FR-17, FR-19, FR-21, C-02, C-05, C-07, A-01, A-03), `zadanie/spec/02-domain.md` (BC-01, BC-07, M-01, context map), `zadanie/spec/03-characteristics.md` (spójność danych w „Considered, Not Driving”).
- Odpowiedzi na grill-me: Q1, Q3, Q7, Q18, Q26, Q29, Q62, Q63 w `zadanie/notatki.md`.
- Diagram C4: `zadanie/c4/workspace.dsl` (Rezerwacje Service, widoki D1-KeyFlow i D3-LegacyDown).
- Event Storming: `zadanie/event-storming/kata-white.png` (ramki Rezerwacja i Synchronizacja); Miro: brak linku.
- Powiązane: ADR-001 (styl service-based, pięć serwisów ze wspólną bazą).
- Otwarte: czy blokowanie pokoi w legacy już dziś działa (Q-03); jak duża ma być pula na hotel i kto ją ustala (Q-05); kiedy będzie gotowe API legacy (Q-01).
