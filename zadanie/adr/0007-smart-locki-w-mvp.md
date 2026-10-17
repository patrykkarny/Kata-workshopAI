# ADR-007: Smart locki w MVP jako adapter w Stay Service

Status: Accepted  
Date: 2026-10-17  
Author: Zespół White (Marek, Patryk, Mariusz, Kamil)

## Context

Firma mocno inwestuje w smart locki otwierane telefonem (zadanie, Additional context), a dostawca zamków ma gotowe API (C-03). System musi działać od początku czerwca, w maju pilot w 2-3 hotelach (C-01, grill-me Q64); inaczej czekamy rok. Prostota jest pierwsza w naszym top 3. Integracje są ważne, ale poza top 3: każdą integrację trzymamy w jednym miejscu, a smart locki to jeden z cudzych systemów.

Klucz mobilny to fizyczny dostęp do pokoju. Bezpieczeństwo mamy jako ważne, ale poza top 3: klucz gościa działa tylko w czasie pobytu, housekeeper dostaje klucz tylko do swojego pokoju na czas zadania, a checkout unieważnia klucz od razu.

Klucze mobilne pojawiają się na kilku ramkach tablicy: Visit (BC-04: przydzielenie zamka, pierwsze wejście), Housekeeping (BC-02: klucz mobilny przydzielony i unieważniony) i Servis tech (BC-03: to samo przy usterce). To wspólna funkcja, a nie osobny obszar. Na tablicy ID zamka jest w ramce Marketing (BC-06).

Trade-off, który tu rozstrzygamy: bezpieczeństwo kontra termin.

## Decision

Smart locki i klucze mobilne wchodzą do MVP jako adapter w Stay Service (M-03, ramki Visit i Faraway; grill-me Q10, zmiana).

- Klucz gościa adapter wydaje przy check-inie i unieważnia przy checkoucie (FR-26).
- Klucz dla housekeepera wydaje Stay Service na prośbę Housekeeping Service (ramki Housekeeping i Servis tech) przy przydziale zadania i unieważnia po zakończeniu zadania. Housekeeper dostaje klucz tylko do pokoju, do którego jest przydzielony, i tylko na czas zadania (FR-27).
- Klucz mobilny to wspólna funkcja dla Visit, Housekeeping i Servis tech, a nie osobny obszar ani osobny serwis.
- Powiązanie zamka z pokojem ustawia hotel w konfiguracji Stay Service.
- Zamek dostawcy działa z kluczem zapisanym w telefonie, więc wejście do pokoju nie zależy od tego, czy nasz system działa (FR-26).
- Każdy klucz ma wpisany czas ważności (koniec pobytu albo koniec zadania), więc nawet jak unieważnienie nie dotrze do zamka, klucz sam wygasa (FR-28).
- Jak telefon gościa jest rozładowany albo zamek nie odpowiada, recepcja daje kartę jak dziś (FR-26). Karty zostają jako zapas.
- Jak housekeeperowi padnie telefon, bierze kartę serwisową od kierowniczki sprzątania, wydawaną i oddawaną na zmianę (FR-27).
- Przed startem sezonu robimy test penetracyjny i test unieważniania kluczy. Bez nich klucze mobilne nie wchodzą na produkcję, a hotele startują na kartach.
- W pilocie w maju sprawdzamy klucze mobilne w 2-3 hotelach, zanim wejdą wszędzie (Q64).

## Alternatives Considered

- **Smart locki później, po sezonie** (nasza wcześniejsza decyzja, Q10): firma mocno inwestuje w zamki otwierane telefonem, a dostawca ma gotowe API.
- **Adapter zamków w Legacy Sync Service** (ramka Synchronizacja): Legacy Sync Service jest tylko od legacy, a klucze żyją razem z check-in i checkout w Stay Service.
- **Powiązanie zamka z pokojem w Marketingu** (na tablicy ID zamka jest w ramce Marketing): to dane techniczne, więc ustawia je hotel w konfiguracji Stay Service.

## Consequences

### Positive

- Klucze mobilne, w które firma inwestuje, działają od pierwszego sezonu.
- Wejście do pokoju działa także wtedy, gdy nasz system leży, bo klucz jest zapisany w telefonie.
- Klucz mobilny to jedna wspólna funkcja dla Visit, Housekeeping i Servis tech, w jednym miejscu (adapter w Stay Service), a nie osobny obszar.

### Negative

- Więcej pracy przed czerwcem (prostota, C-01).
- Obowiązkowe testy bezpieczeństwa w maju; płacimy czasem w maju. Jak ich nie przejdziemy, hotele startują na kartach.
- Karty zostają jako zapas, więc recepcja dalej je wydaje.

## Notes

- Źródła: notatki (Decyzje, Trade-offy: bezpieczeństwo kontra termin, Charakterystyki: bezpieczeństwo, Domena: klucze mobilne na ramkach Visit, Housekeeping, Servis tech; ID zamka w ramce Marketing), grill-me Q10, Q64; sekcja „Doprecyzowania po ADR-ach” (Smart locki).
- Spec: `zadanie/spec/01-prd.md` (C-01, C-03, FR-26, FR-27, FR-28; In scope: smart locki i klucze mobilne w MVP, pilot i testy przed sezonem; Key Flows 2, 4 i 5), `zadanie/spec/02-domain.md` (BC-02, BC-03, BC-04, BC-06, M-03, context map: smart locki do BC-04 i BC-05), `zadanie/spec/03-characteristics.md` (bezpieczeństwo i integracje w „Considered, Not Driving”, trade-off bezpieczeństwo kontra termin).
- Charakterystyki: prostota (top 1), integracje (poza top 3, wymienia smart locki), bezpieczeństwo (poza top 3).
- Zrzut tablicy: `zadanie/event-storming/kata-white.png`.
- Powiązane: ADR-001 (Stay Service, M-03), ADR-003 (Legacy Sync Service jako jedyne miejsce wymiany plików z legacy).
