# ADR-006: Aplikacja na wózki jako aplikacja webowa działająca offline

Status: Accepted  
Date: 2026-10-17  
Author: Zespół White (Marek, Patryk, Mariusz, Kamil)

## Context

Zadanie (wymaganie 04) mówi, że personel sprzątający i techniczny jest kierowany do pokoi według priorytetu przez urządzenia, które daje firma i które są przymocowane do wózków. Wymaganie 06 mówi, że system ma być webowy i hostowany przez firmę.

Co ma robić urządzenie przy wózku:

- Housekeeper widzi listę pokoi do zrobienia w kolejności, z życzeniami gościa i usterkami (FR-13).
- Kierowniczka sprzątania ma panel z kolejką wszystkich wózków i może zmienić kolejność (FR-14).
- Pokój ma być przygotowany w 15 minut, od „gotowy do sprzątania” do „gotowy dla gościa”, mierzone na urządzeniu przy wózku.

Na hotel to ok. 8-10 housekeeperów z urządzeniem przy wózku (A-04). Najważniejszy dla biznesu jest system do sprzątania. API dla urządzeń przy wózkach jest w serwisie Housekeeping (M-02).

Ograniczenia:

- Urządzenia to tablety firmy z przeglądarką. Nie wiemy, czy da się na nich instalować aplikacje.
- Wi-Fi w hotelu się rwie (hotspot w BC-02).
- Przy awarii bazy przełączenie na replikę trwa 1-2 minuty; w tym czasie wózki zapisują offline (Q60, ADR-001, ADR-004).
- Chcemy jeden stack: TypeScript, NestJS na backendzie, React na frontendzie, bo zespół ma znać jedną technologię.
- Prostota jest w top 3: bez egzotycznej technologii. Integracje są ważne, ale poza top 3, a urządzenia przy wózkach to jeden z cudzych systemów.

## Decision

Aplikację na urządzenia przy wózkach robimy jako aplikację webową działającą offline, a nie jako aplikację natywną.

W praktyce:

- Działa w przeglądarce na tabletach, które daje firma (wymaganie 04).
- Jest w tym samym stacku co reszta frontendu: TypeScript i React.
- Offline działa lista zadań, zmiana statusu pokoju i zgłoszenie usterki. Zmiany wysyłają się same po powrocie sieci.
- Jak Wi-Fi się zerwie albo baza przełącza się na replikę, wózki zapisują offline (Q60).
- Jak kierowniczka zmieni kolejność, a wózek jest offline, housekeeper zobaczy nową kolejność po powrocie sieci; bieżący pokój kończy.
- Przy konflikcie o kolejność wygrywa kierowniczka, a o stan pokoju wygrywa housekeeper, który w nim był.
- Każde zadanie ma przypisaną jedną osobę, więc dwa wózki nie robią tego samego pokoju.
- Na niej mierzymy 15 minut na pokój, z czasu zapisanego na urządzeniu, a nie z czasu dotarcia zmiany na serwer.
- Rozmawia z API dla urządzeń przy wózkach w serwisie Housekeeping (M-02).
- W diagramie C4 to kontener `Housekeeping Cart App`.

## Alternatives Considered

- **Aplikacja natywna**: odpadła, bo urządzenia to tablety firmy z przeglądarką i nie wiemy, czy da się na nich instalować aplikacje, a my chcemy jeden stack.
- **Aplikacja webowa działająca tylko online**: odpadła, bo Wi-Fi w hotelu się rwie, a w czasie przełączania bazy na replikę wózki mają zapisywać offline (Q60).

## Consequences

### Positive

- Jeden stack dla całego frontendu, zespół zna jedną technologię.
- Housekeeper pracuje dalej, gdy Wi-Fi się rwie i gdy baza przełącza się na replikę (Q60).

### Negative

- Trzeba napisać i przetestować synchronizację zmian i rozwiązywanie konfliktów.
- Zmiana kolejności od kierowniczki dociera do wózka offline dopiero po powrocie sieci.

## Notes

- Zadanie: `zadanie/zadanie.md` (wymagania 04 i 06).
- Spec: `zadanie/spec/01-prd.md` (FR-13, FR-14, A-04), `zadanie/spec/02-domain.md` (BC-02, M-02), `zadanie/spec/03-characteristics.md` (top 3: prostota; integracje poza top 3).
- Odpowiedzi na grill-me: Q11, Q38, Q60, Q69 w `zadanie/notatki.md`; sekcje Decyzje, hot spoty i Jak mierzymy; sekcja „Doprecyzowania po ADR-ach” (Wózki).
- Diagram C4: `zadanie/c4/workspace.dsl` (kontener `Housekeeping Cart App`).
- Event Storming: `zadanie/event-storming/kata-white.png`; Miro: brak linku.
- Powiązane: ADR-001 (co dzieje się w czasie przełączania bazy), ADR-004 (replika bazy), ADR-005 (zmiany statusu pokoju przez kolejkę zdarzeń).
