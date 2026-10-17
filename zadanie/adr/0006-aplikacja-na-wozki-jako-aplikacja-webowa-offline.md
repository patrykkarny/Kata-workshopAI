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

- Wi-Fi w hotelu się rwie (hotspot w BC-02).
- Przy awarii bazy przełączenie na replikę trwa 1-2 minuty; w tym czasie wózki zapisują offline (Q60).
- Chcemy jeden stack: TypeScript, NestJS na backendzie, React na frontendzie, bo zespół ma znać jedną technologię.
- Prostota jest w top 3: bez egzotycznej technologii. Integracje są w top 3, a urządzenia przy wózkach to jeden z cudzych systemów.

## Decision

Aplikację na urządzenia przy wózkach robimy jako aplikację webową działającą offline, a nie jako aplikację natywną.

W praktyce:

- Działa na urządzeniach, które daje firma (wymaganie 04).
- Jest w tym samym stacku co reszta frontendu: TypeScript i React.
- Jak Wi-Fi się zerwie albo baza przełącza się na replikę, wózki zapisują offline (Q60).
- Rozmawia z API dla urządzeń przy wózkach w serwisie Housekeeping (M-02).
- Na niej mierzymy 15 minut na pokój.
- W diagramie C4 to kontener `Housekeeping Cart App`.

> TODO: Co dokładnie działa offline: lista pokoi z życzeniami i usterkami, oznaczanie pokoju jako posprzątanego, zgłaszanie usterki?

> TODO: Jak i kiedy aplikacja wysyła do serwisu Housekeeping to, co zapisała offline?

## Alternatives Considered

- **Aplikacja natywna**: odpadła, bo urządzenia daje firma, a my chcemy jeden stack.
- **Aplikacja webowa działająca tylko online**: odpadła, bo Wi-Fi w hotelu się rwie, a w czasie przełączania bazy na replikę wózki mają zapisywać offline (Q60).

## Consequences

### Positive

- Jeden stack dla całego frontendu, zespół zna jedną technologię.
- Housekeeper pracuje dalej, gdy Wi-Fi się rwie i gdy baza przełącza się na replikę (Q60).

### Negative

> TODO: Za co płacicie tą decyzją? Jaki koszt i jakie ryzyko przyjmujecie, wybierając aplikację webową działającą offline zamiast natywnej i zamiast aplikacji tylko online?

## Notes

- Zadanie: `zadanie/zadanie.md` (wymagania 04 i 06).
- Spec: `zadanie/spec/01-prd.md` (FR-13, FR-14, A-04), `zadanie/spec/02-domain.md` (BC-02, M-02), `zadanie/spec/03-characteristics.md` (top 3: prostota, integracje).
- Odpowiedzi na grill-me: Q11, Q38, Q60, Q69 w `zadanie/notatki.md`; sekcje Decyzje, hot spoty i Jak mierzymy.
- Diagram C4: `zadanie/c4/workspace.dsl` (kontener `Housekeeping Cart App`).
- Event Storming: `zadanie/event-storming/kata-white.png`; Miro: brak linku.
- Powiązane: ADR-001 (styl service-based, replika bazy i wózki offline w czasie przełączenia), ADR-005 (zmiany statusu pokoju przez kolejkę zdarzeń).
