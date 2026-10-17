# PRD: Room with a View

Status: Draft  
Updated: 2026-10-17  
Authors: Zespół White (Marek, Patryk, Mariusz, Kamil)

## Problem & Goal

- Sieć ma 107 hoteli, w tym 42 w USA, które robią 2500 rezerwacji dziennie; hotel ma ok. 200 pokoi, razem ok. 21 tys. pokoi. (notatki)
- Dziś rezerwacje są głównie przez telefon i przy wejściu. (notatki)
- Dziś kierowniczka sprzątania rozdziela pracę przez wiadomości. (notatki)
- Gość chce sam wybrać konkretny pokój (np. daleko od windy). (notatki)
- Najważniejszy dla biznesu jest system do sprzątania. (notatki)
- Pokój ma być przygotowany w 15 minut, liczone od „gotowy do sprzątania” do „gotowy dla gościa”. (notatki)

## Actors

| Actor | Needs | Scale | Source |
|---|---|---|---|
| Gość (Guest) | wybiera konkretny pokój albo typ pokoju (FR-01) | ok. 60 rezerwacji na hotel dziennie, ok. 6400 dziennie w 107 hotelach (jedna co 14 s); wymeldowania skupione między 10 a 12, ok. jedno na 2 minuty w hotelu (wyliczenie zespołu) | notatki, Miro: Rezerwacja, Visit, Faraway |
| Recepcjonista (Recepcja) | robi rezerwacje z telefonu i walk-in w naszej aplikacji (FR-04); przy awarii systemu robi check-in ręcznie (FR-18) | _Brak w notatkach._ | grill-me Q6, Q44, Miro: Rezerwacja, Visit, Faraway, Servis tech |
| Manager hotelu | ustala ceny (C-04); decyduje o pokoju zastępczym (FR-10, FR-15); dostaje informację, gdy życzenia nie da się spełnić (FR-09) | _Brak w notatkach._ | notatki, grill-me Q2, Q12, Q15, Miro: Manager |
| Kierowniczka sprzątania | panel z kolejką wszystkich wózków (FR-14) | _Brak w notatkach._ | notatki, grill-me Q38 |
| Housekeeper | ludzie hotelu; lista pokoi do zrobienia na urządzeniu przy wózku (FR-13) | _Brak w notatkach._ | notatki, grill-me Q11, Miro: Housekeeping, Servis tech |
| Handlowiec (Sales) | jego obietnice trafiają do rezerwacji jako życzenia (FR-09) | _Brak w notatkach._ | grill-me Q15, Miro: Rezerwacja |
| Marketing | odpowiada za zdjęcia i opisy pokoi | _Brak w notatkach._ | grill-me Q36, Miro: Marketing |

## Scope

### In scope

- Na pierwszy dzień sezonu: rezerwacje, check-in, pobyt, checkout i housekeeping. (grill-me Q5)
- Housekeeping dla wszystkich pokoi hotelu (FR-17). (grill-me Q55)

### Out of scope

- Marketing, ceny i raporty: zostają w legacy. (grill-me Q5)
- Raporty managera: na tablicy bez ramki, zostają w legacy tak jak dziś; raporty finansowe są opcjonalne. (notatki, Miro: Manager)
- Płatności, anulowania i zwroty: robi legacy (C-05, C-06). (grill-me Q13, Q28)
- Klucze mobilne (smart locki): etap 2; na start karty jak dziś; to wspólna funkcja kilku ramek (Visit, Housekeeping, Servis tech), a nie osobny obszar. (grill-me Q10, notatki)
- Automatyczny dobór pokoju: nie jest potrzebny. (notatki)
- Przygotowanie zdjęć i opisów pokoi: dostajemy gotowe. (notatki)

## Key Flows

1. Rezerwacja: zapytano o dostępność, zebrano wymagania (zamówione ekstra elementy do pokoju na pobyt), sprawdzono dostępność pokoi zgodnie z wymaganiami, zarezerwowano pokój, dostarczenie listy życzeń do pokoju i dostosowanie pokoju do ekstra wymagań, zdjęta dostępność pokoju. (Miro: Rezerwacja)
2. Check-in: checkin, przydzielenie zamka pokoju, pierwsze użycie zamka / wejście klienta, pobyt rozpoczęty. (Miro: Visit)
3. Checkout: checkout, pobyt zakończony, ewentualnie zgłoszone zastrzeżenia do pokoju, anulowanie rezerwacji/pobytu, żądanie zwrotu, naliczona rekompensata, pokój ponownie dostępny. (Miro: Faraway)
4. Sprzątanie: checkout tworzy zlecenie sprzątania (FR-11), przydzielono osobę sprzątającą i wysłano powiadomienie, pokój gotowy do sprzątania, pokój wysprzątany, pokój gotowy dla gościa (klucz mobilny przydzielany i unieważniany w etapie 2). (Miro: Housekeeping, grill-me Q4)
5. Usterka: usterka zgłoszona, usterka usunięta (klucz mobilny w etapie 2). (Miro: Servis tech)

## Functional Requirements

| ID | Requirement | Actor | Source |
|---|---|---|---|
| FR-01 | Gość może wybrać konkretny pokój albo tylko typ pokoju. | Gość | grill-me Q25, notatki |
| FR-02 | Przy rezerwacji typu pokój przydzielamy dzień przed przyjazdem. | System | grill-me Q25 |
| FR-03 | Wszystkie kanały (web, mobile, telefon, walk-in) idą przez jedno API rezerwacji. | Gość, Recepcjonista | notatki |
| FR-04 | Rezerwacje z telefonu i walk-in robi recepcjonista w naszej aplikacji, tą samą ścieżką co gość. | Recepcjonista | grill-me Q6 |
| FR-05 | System decyduje, czy pokój z puli jest zajęty danej nocy; wie też, w jakim stanie jest pokój i kiedy będzie potrzebny. | System | grill-me Q1, notatki |
| FR-06 | Gdy legacy nie odpowiada i płatność czeka w kolejce, blokada pokoju nie wygasa po 10 minutach (A-03), tylko trzyma do odpowiedzi legacy, żeby nie sprzedać pokoju, za który gość już płaci. | System | grill-me Q7 |
| FR-07 | Rezerwacje i płatności system wysyła do legacy od razu. | System | grill-me Q29 |
| FR-08 | Raz dziennie system porównuje dane z legacy. | System | grill-me Q29 |
| FR-09 | Obietnice handlowców zapisujemy jako życzenia w rezerwacji; system sprawdza, czy da się je spełnić, a jak nie, daje znać managerowi. | Handlowiec, Manager hotelu | grill-me Q15 |
| FR-10 | Gdy wybrany pokój nie jest gotowy, przy check-in system proponuje pokój zastępczy; decyduje manager hotelu. | Manager hotelu | grill-me Q2 |
| FR-11 | Checkout tworzy zlecenie sprzątania. | System | grill-me Q4 |
| FR-12 | Priorytet zlecenia sprzątania wynika z tego, kiedy pokój jest znowu potrzebny. | System | grill-me Q4, notatki |
| FR-13 | Na urządzeniu przy wózku housekeeper widzi listę pokoi do zrobienia w kolejności, z życzeniami gościa i usterkami. | Housekeeper | grill-me Q11 |
| FR-14 | Kierowniczka sprzątania ma panel z kolejką wszystkich wózków i może zmienić kolejność. | Kierowniczka sprzątania | grill-me Q38 |
| FR-15 | Usterka blokująca zdejmuje pokój ze sprzedaży; dla gości na ten pokój manager wybiera pokój zastępczy. | Manager hotelu | grill-me Q12 |
| FR-16 | Przy anulowaniu system tylko zwalnia pokój. | System | grill-me Q13 |
| FR-17 | Housekeeping obejmuje wszystkie pokoje hotelu; dla pokoi spoza puli system bierze zameldowania i wymeldowania z legacy co kilka minut. | System | grill-me Q55 |
| FR-18 | Gdy nasz system padnie, recepcja ma odświeżaną co kwadrans listę przyjazdów, wyjazdów i statusów, robi check-in ręcznie i dopisuje go potem. | Recepcjonista | grill-me Q44 |
| FR-19 | Nadpisanie pre-rezerwacji oddaje pokój z powrotem do legacy i nie anuluje niczyjej rezerwacji. | System | grill-me Q3, Miro: Synchronizacja |

## Constraints

| ID | Constraint | Source |
|---|---|---|
| C-01 | Sezon startuje na początku czerwca, obłożenie dochodzi do ok. 90%. | notatki, zadanie: "Peak season is quickly approaching" |
| C-02 | Legacy ma API, ale integracja jest jeszcze w toku. | notatki |
| C-03 | Smart locki mają API. | notatki |
| C-04 | Ceny ustala ręcznie manager hotelu w legacy. | notatki, grill-me Q36 |
| C-05 | Wszystko z rezerwacji dzieje się u nas oprócz płatności; płatność robi legacy przez API. | grill-me Q28 |
| C-06 | Anulowania i zwroty robi legacy. | grill-me Q13 |
| C-07 | Legacy odgórnie blokuje pulę pokoi dla nas i nie może ich sprzedać. | grill-me Q26, Q1 |

## Assumptions

| ID | Assumption | How we validate | Source |
|---|---|---|---|
| A-01 | Legacy umie już dziś blokować pokoje (pre-rezerwacja). | otwarte: Q-03 | notatki |
| A-02 | Hotele poza USA mogą być w innym regionie, ale na start zakładamy jeden region. | otwarte: Q-02 | notatki |
| A-03 | Niezapłacona rezerwacja trzyma pokój przez 10 minut, potem pokój wraca do sprzedaży. | _Brak w notatkach._ | grill-me Q7 |

## Open Questions

| ID | Question | Source |
|---|---|---|
| Q-01 | Kiedy będzie gotowe API legacy i czy zdążymy przed czerwcem? | notatki |
| Q-02 | Gdzie są hotele spoza USA i czy dane gości muszą tam zostać? | notatki |
| Q-03 | Czy blokowanie pokoi w legacy już dziś działa? | notatki |
| Q-04 | Co biznes miał na myśli przez „kupowanie rzeczy dla gości”: życzenia do pokoju czy osobny sklep? | notatki |
| Q-05 | Jak duża ma być pula na hotel i kto ją ustala? | notatki |
