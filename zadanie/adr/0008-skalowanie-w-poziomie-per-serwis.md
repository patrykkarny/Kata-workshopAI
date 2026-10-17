# ADR-008: Skalowanie w poziomie per serwis, bez elastyczności

Status: Accepted  
Date: 2026-10-17  
Author: Zespół White (Marek, Patryk, Mariusz, Kamil)

## Context

W pierwszej wersji charakterystyk mieliśmy skalowalność i elastyczność („skalowalność” i „deskalowanie” jako charakterystyka 1, grill-me Q30). Potem skalowalność wypadła z top 3, bo ruch jest mały (Q31). Zmiana: top 3 to prostota, skalowalność i odporność na awarie (Q31). Skalowalność wraca jako wzrost liczby hoteli, a nie nagłe skoki ruchu; odrzucona zostaje tylko elastyczność.

Liczby, na których to opieramy:

- biznes: 107 hoteli, w tym 42 w USA, które robią 2500 rezerwacji dziennie; hotel ma ok. 200 pokoi; obłożenie w sezonie dochodzi do ok. 90% (C-01)
- nasze wyliczenia: 107 hoteli x 200 pokoi to ok. 21 tys. pokoi; ok. 60 rezerwacji na hotel dziennie, na 107 hoteli ok. 6400 dziennie, czyli średnio jedna rezerwacja co 14 sekund
- najgorsza godzina: jak 20% dziennych rezerwacji przyjdzie w jednej godzinie, to ok. 1300 na godzinę, czyli ok. 21 na minutę
- wymeldowania skupiają się między 10 a 12, to ok. jedno na 2 minuty w hotelu
- zadanie: gości „hundreds”, personelu hotelu „less than 20” (A-04)
- wniosek: pojedyncza rezerwacja to mały ruch, ale platforma od pierwszego dnia obsługuje 107 hoteli naraz i ma przyjmować kolejne, a check-iny i checkouty we wszystkich hotelach wypadają w tych samych godzinach

„Peak season” w zadaniu („Peak season is quickly approaching, so the system must be ready quickly or we have to wait until next year!”) chodzi o termin. Szczyt sezonu znamy z góry, a ruch nie ma nagłych skoków.

Mamy jedną platformę dla wszystkich hoteli w regionie USA, a nie instancję na hotel, bo 107 wdrożeń to za dużo; ten sam zestaw serwisów można postawić w drugim regionie. Na start zakładamy jeden region (A-02).

## Decision

Skalujemy w poziomie per serwis: dokładamy instancje temu serwisowi, który tego potrzebuje. Nowy hotel dodajemy konfiguracją, a nie wdrożeniem. Nie robimy elastyczności: bez automatycznego skalowania w górę i w dół, bo szczyt sezonu znamy z góry i wystarczy go zaplanować.

- Sygnałem do dokładania instancji jest próg ok. 100 rezerwacji na minutę dla całej platformy w regionie, liczony jako średnia z 15 minut. Drugi region ma swój próg.
- Pilnuje tego dashboard i alert; odpowiada tech lead.
- Jak przekroczymy próg, najpierw dokładamy instancje tylko temu serwisowi, który się dławi, co service-based umożliwia (ADR-001), a w tym czasie planujemy dalsze zmiany.
- Ryzyko okresu między przekroczeniem progu a dalszymi zmianami akceptuje po stronie biznesu dyrektor operacyjny.
- Poza sezonem nie skalujemy w dół, bo przy tym ruchu oszczędność jest mała.
- Przed sezonem robimy test obciążenia na 3x najgorszą godzinę: ok. 65 rezerwacji na minutę plus checkouty ze wszystkich hoteli w oknie 10-12.
- Sprawdzamy też, że nowy hotel dodajemy bez zmiany kodu.

## Alternatives Considered

- **Elastyczność (automatyczne skalowanie w górę i w dół)**: ruch nie ma nagłych skoków, a szczyt sezonu znamy z góry i wystarczy go zaplanować; poza sezonem oszczędność byłaby mała.
- **Mikroserwisy dla drobniejszego skalowania**: za dużo złożoności; przy naszym ruchu dokładanie instancji serwisu wystarczy (trade-off prostota kontra skalowalność, ADR-001).
- **Bez projektowania pod skalowanie (nasza poprzednia wersja, przed zmianą Q31)**: pojedyncza rezerwacja to mały ruch, ale platforma od pierwszego dnia obsługuje 107 hoteli naraz, ma przyjmować kolejne, a check-iny i checkouty we wszystkich hotelach wypadają w tych samych godzinach.

## Consequences

### Positive

- Nowy hotel to konfiguracja, bez zmiany kodu i bez wdrożenia.
- Serwis, który się dławi, dostaje więcej instancji bez ruszania reszty.
- Prostsza i tańsza infrastruktura, a zespół skupiony na terminie.
- Najgorsza godzina (ok. 21 rezerwacji na minutę) jest dużo poniżej progu.

### Negative

- Bez automatycznego skalowania instancje dokładamy sami, więc próg musi ktoś pilnować (dashboard, alert, tech lead).
- Po przekroczeniu progu, do czasu dalszych zmian, mamy tylko dokładanie instancji serwisowi, który się dławi; to ryzyko akceptuje dyrektor operacyjny.
- Poza sezonem nie skalujemy w dół, więc rezygnujemy z oszczędności, która przy tym ruchu jest mała.

## Notes

- Źródła: notatki (Nasze wyliczenia, Charakterystyki: top 3 i Odrzucone, Trade-offy: prostota kontra skalowalność, Jak mierzymy: skalowalność, Decyzje), grill-me Q30, Q31; sekcja „Doprecyzowania po ADR-ach” (Skalowanie); zadanie (01 Users, 03 Additional context).
- Spec: `zadanie/spec/01-prd.md` (C-01, A-02, A-04; tabela Actors: skala gościa), `zadanie/spec/03-characteristics.md` (top 3: skalowalność; elastyczność odrzucona w „Considered, Not Driving”; trade-off prostota kontra skalowalność).
- Charakterystyki: prostota, skalowalność, odporność na awarie (top 3); elastyczność (odrzucona).
- Powiązane: ADR-001 (styl service-based, ocena stylów, minimum dwie instancje na serwis).
