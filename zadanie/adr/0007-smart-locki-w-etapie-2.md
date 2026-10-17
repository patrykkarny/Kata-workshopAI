# ADR-007: Smart locki w etapie 2

Status: Accepted  
Date: 2026-10-17  
Author: Zespół White (Marek, Patryk, Mariusz, Kamil)

## Context

Firma mocno inwestuje w smart locki otwierane telefonem (zadanie, Additional context), a smart locki mają API (C-03). System musi działać od początku czerwca, w maju pilot w 2-3 hotelach (C-01, grill-me Q64); inaczej czekamy rok. Dlatego prostota jest pierwsza w naszym top 3: mało serwisów i MVP chodzące w hotelach pilotażowych przed sezonem.

Klucz w telefonie to fizyczny dostęp do pokoju, więc bezpieczeństwo musi być dopięte. Bezpieczeństwo mamy jako ważne, ale poza top 3: housekeeper dostaje klucz tylko do swojego pokoju na czas sprzątania.

Klucze mobilne pojawiają się na kilku ramkach tablicy: Visit (BC-04: przydzielenie zamka, pierwsze wejście), Housekeeping (BC-02: klucz mobilny przydzielony i unieważniony) i Servis tech (BC-03: to samo przy usterce). To wspólna funkcja, a nie osobny obszar.

Trade-off, który tu rozstrzygamy: bezpieczeństwo kontra termin.

## Decision

Smart locki (klucze mobilne) wchodzą w etapie 2, a nie w MVP. Na start są karty jak dziś (grill-me Q10).

- Na pierwszy dzień sezonu nie budujemy kluczy mobilnych; check-in, sprzątanie i usterki działają z kartami jak dziś.
- W etapie 2 smart locki wchodzą jako adapter w serwisie Pobyt (M-03).
- Klucz mobilny to wspólna funkcja dla Visit, Housekeeping i Servis tech, a nie osobny obszar ani osobny serwis.
- Housekeeper dostaje klucz tylko do pokoju, do którego jest przydzielony, i tylko na czas zadania.

## Alternatives Considered

- **Smart locki w MVP**: nie zdążymy na czerwiec (C-01), a klucz w telefonie to fizyczny dostęp do pokoju i musi być dopięty.

> TODO: Czy rozważaliście inne miejsce na adapter smart locków niż serwis Pobyt (np. Synchronizację, gdzie według charakterystyki ewolucyjności dokładamy adaptery)? Jeśli tak, dlaczego odpadło?

## Consequences

### Positive

- Mniej zakresu na czerwiec, więc łatwiej zdążyć z MVP przed sezonem (prostota, C-01).
- Bezpieczeństwo kluczy mobilnych nie jest robione w pośpiechu; dostęp do pokoju zostaje na kartach jak dziś.
- Klucz mobilny to jedna wspólna funkcja dla Visit, Housekeeping i Servis tech, w jednym miejscu (adapter w serwisie Pobyt), a nie osobny obszar.

### Negative

- W pierwszym sezonie ani gość, ani housekeeper nie ma klucza w telefonie; zostają karty jak dziś.

> TODO: Co jeszcze kosztuje was ta decyzja (np. wobec biznesu, który mocno inwestuje w smart locki), i kto po stronie biznesu się na to zgadza?

## Notes

- Źródła: notatki (Decyzje, Trade-offy: bezpieczeństwo kontra termin, Charakterystyki: bezpieczeństwo, Domena: klucze mobilne na ramkach Visit, Housekeeping, Servis tech), grill-me Q10, Q64.
- Spec: C-01, C-03, M-03, BC-02, BC-03, BC-04; PRD Out of scope (klucze mobilne w etapie 2), Key Flows 2, 4 i 5.
- Charakterystyki: prostota (top 1), integracje (top 2, wymienia smart locki), bezpieczeństwo (poza top 3).
- Zrzut tablicy: `zadanie/event-storming/kata-white.png`.
- Powiązane: ADR-001 (serwis Pobyt, M-03).

> TODO: Kiedy jest etap 2 (po sezonie, w trakcie sezonu)?
> TODO: Co się dzieje, gdy telefon gościa lub housekeepera jest rozładowany, zamek nie odpowiada albo unieważnienie klucza nie dotrze do zamka (pytanie Q10 z grill-me nadal bez odpowiedzi poza „etap 2”)?
