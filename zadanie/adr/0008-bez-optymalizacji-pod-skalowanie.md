# ADR-008: Nie optymalizujemy pod skalowanie i elastyczność

Status: Accepted  
Date: 2026-10-17  
Author: Zespół White (Marek, Patryk, Mariusz, Kamil)

## Context

W pierwszej wersji charakterystyk mieliśmy skalowalność i elastyczność („skalowalność” i „deskalowanie” jako charakterystyka 1, grill-me Q30). Przy wyborze top 3 zmieniliśmy zdanie: top 3 to prostota, integracje i odporność na awarie (grill-me Q31), a skalowalność i elastyczność trafiły do „Odrzucone”.

Liczby, na których to opieramy:

- biznes: 107 hoteli, w tym 42 w USA, które robią 2500 rezerwacji dziennie; hotel ma ok. 200 pokoi; obłożenie w sezonie dochodzi do ok. 90% (C-01)
- nasze wyliczenia: 107 hoteli x 200 pokoi to ok. 21 tys. pokoi; ok. 60 rezerwacji na hotel dziennie, na 107 hoteli ok. 6400 dziennie, czyli średnio jedna rezerwacja co 14 sekund
- wymeldowania skupiają się między 10 a 12, to ok. jedno na 2 minuty w hotelu
- zadanie: gości „hundreds”, personelu hotelu „less than 20”
- wniosek: ruch jest mały, skalowanie nie jest naszym problemem

„Peak season” w zadaniu („Peak season is quickly approaching, so the system must be ready quickly or we have to wait until next year!”) chodzi o termin, nie o ruch.

## Decision

Nie optymalizujemy architektury pod skalowanie i elastyczność, bo ruch jest mały. Wracamy do tematu, jak przekroczymy ok. 100 rezerwacji na minutę.

- Skalowalność i elastyczność nie są charakterystykami, które kształtują architekturę; kształtuje ją top 3: prostota, integracje i odporność na awarie.
- Próg powrotu do tematu: ok. 100 rezerwacji na minutę.

## Alternatives Considered

- **Projektowanie pod skalowalność i elastyczność (nasza pierwsza wersja charakterystyk)**: odpadło, bo jedna rezerwacja co 14 sekund to mało, a „peak season” w zadaniu chodzi o termin, nie o ruch.

## Consequences

### Positive

- Architektura nie jest kształtowana pod ruch, którego według naszych wyliczeń nie ma; uwagę dostaje top 3 (prostota, integracje, odporność na awarie).

> TODO: Co konkretnie zyskujecie, rezygnując ze skalowalności i elastyczności (mniej pracy, prostszy model wdrożenia, termin)?

### Negative

- Jak ruch urośnie powyżej ok. 100 rezerwacji na minutę, musimy wrócić do tematu skalowania.

> TODO: Co się dzieje w okresie między przekroczeniem progu a wprowadzeniem zmian, i kto po stronie biznesu akceptuje to ryzyko?

## Notes

- Źródła: notatki (Nasze wyliczenia, Charakterystyki: Odrzucone, Decyzje), grill-me Q30, Q31; zadanie (01 Users, 03 Additional context).
- Spec: C-01; 03-characteristics.md, sekcja „Considered, Not Driving”: Skalowalność i elastyczność (Scalability, Elasticity); PRD, tabela Actors (skala gościa).
- Charakterystyki: prostota, integracje, odporność na awarie (top 3); skalowalność i elastyczność (odrzucone).
- Powiązane: ADR-001 (styl service-based; ten sam próg ok. 100 rezerwacji na minutę w Notes).

> TODO: Ile operacji na minutę daje najgorsza godzina (pytanie Q30 z grill-me nadal bez odpowiedzi)?
> TODO: Jak i gdzie mierzymy próg ok. 100 rezerwacji na minutę (średnia czy szczyt, na hotel czy na całą platformę) i kto pilnuje, że go przekroczyliśmy?
