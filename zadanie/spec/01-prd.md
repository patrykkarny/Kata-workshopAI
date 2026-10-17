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
- Pokój ma być przygotowany w 15 minut, liczone od „gotowy do sprzątania” do „gotowy dla gościa”, mierzone na urządzeniu przy wózku z czasu zapisanego na urządzeniu, a nie z czasu dotarcia zmiany na serwer. (notatki)

## Actors

| Actor | Needs | Scale | Source |
|---|---|---|---|
| Gość (Guest) | wybiera konkretny pokój albo typ pokoju (FR-01); przy wyborze konkretnego pokoju widzi jego zdjęcia i położenie na planie piętra (FR-20); płaci preautoryzacją u operatora płatności (FR-22, FR-21); dostaje klucz mobilny na czas pobytu (FR-26) | ok. 60 rezerwacji na hotel dziennie, ok. 6400 dziennie w 107 hotelach (jedna co 14 s); najgorsza godzina: jak 20% dziennych rezerwacji przyjdzie w jednej godzinie, ok. 1300 na godzinę (ok. 21 na minutę); wymeldowania skupione między 10 a 12, ok. jedno na 2 minuty w hotelu (wyliczenie zespołu) | notatki, Miro: Rezerwacja, Visit, Faraway |
| Recepcjonista (Recepcja) | robi rezerwacje z telefonu i walk-in w naszej aplikacji (FR-04); przy rezerwacji telefonicznej wysyła gościowi link do płatności (FR-22); dzwoni do gości VIP (FR-21); daje kartę, gdy klucz mobilny nie działa (FR-26); przy awarii systemu robi check-in ręcznie (FR-18) | _Brak w notatkach._ | grill-me Q6, Q10, Q44, Q65, Q66, notatki, Miro: Rezerwacja, Visit, Faraway, Servis tech |
| Manager hotelu | ustala ceny (C-04); decyduje o pokoju zastępczym (FR-10, FR-15); dostaje informację, gdy życzenia nie da się spełnić (FR-09); dostaje alert i decyduje o upgradzie, gdy przy przydziale nie ma wolnego pokoju danego typu (FR-02); dostaje rano listę różnic z porównania z legacy (FR-08) | _Brak w notatkach._ | notatki, grill-me Q2, Q12, Q15, Q67, Miro: Manager |
| Kierowniczka sprzątania | panel z kolejką wszystkich wózków (FR-14); przy konflikcie o kolejność wygrywa jej zmiana (FR-24); wydaje karty serwisowe (FR-27) | _Brak w notatkach._ | notatki, grill-me Q38 |
| Housekeeper | ludzie hotelu; lista pokoi do zrobienia na urządzeniu przy wózku (FR-13), także offline (FR-23); jedno zadanie ma jedną osobę (FR-25); klucz mobilny na czas zadania (FR-27) | ok. 8-10 osób na hotel z urządzeniem przy wózku (A-04) | notatki, grill-me Q11, Q69, Miro: Housekeeping, Servis tech |
| Handlowiec (Sales) | jego obietnice trafiają do rezerwacji jako życzenia (FR-09) | _Brak w notatkach._ | grill-me Q15, Miro: Rezerwacja |
| Marketing | odpowiada za zdjęcia i opisy pokoi | _Brak w notatkach._ | grill-me Q36, Miro: Marketing |

## Scope

### In scope

- Na pierwszy dzień sezonu: rezerwacje, check-in, pobyt, checkout i housekeeping oraz pokazywanie zdjęć pokoi przez Ofertę. (grill-me Q5, notatki)
- Housekeeping dla wszystkich pokoi hotelu (FR-17). (grill-me Q55)
- W maju pilot w 2-3 hotelach, od początku czerwca wszystkie hotele. (grill-me Q64)
- Smart locki i klucze mobilne w MVP; karty zostają jako zapas. Klucze mobilne to wspólna funkcja kilku ramek (Visit, Housekeeping, Servis tech), a nie osobny obszar. (grill-me Q10, notatki)
- W pilocie w maju sprawdzamy klucze mobilne w 2-3 hotelach, zanim wejdą wszędzie; bez testu penetracyjnego i testu unieważniania kluczy przed startem sezonu klucze mobilne nie wchodzą na produkcję, a hotele startują na kartach. (notatki)

### Out of scope

- Marketing (poza pokazywaniem zdjęć pokoi przez Ofertę), ceny i raporty: zostają w legacy. (grill-me Q5, notatki)
- Raporty managera: na tablicy bez ramki, zostają w legacy tak jak dziś; raporty finansowe są opcjonalne. (notatki, Miro: Manager)
- Rozliczenie pobytu, anulowania i zwroty: robi legacy (C-05, C-06); preautoryzację przy rezerwacji robi zewnętrzny operator płatności (FR-22). (grill-me Q13, Q28, notatki)
- Automatyczny dobór pokoju: nie jest potrzebny. (notatki)
- Przygotowanie zdjęć i opisów pokoi: dostajemy gotowe. (notatki)

## Key Flows

1. Rezerwacja: zapytano o dostępność, zebrano wymagania (zamówione ekstra elementy do pokoju na pobyt), sprawdzono dostępność pokoi zgodnie z wymaganiami, zarezerwowano pokój, dostarczenie listy życzeń do pokoju i dostosowanie pokoju do ekstra wymagań, zdjęta dostępność pokoju. (Miro: Rezerwacja)
2. Check-in: checkin, przydzielenie zamka pokoju, pierwsze użycie zamka / wejście klienta, pobyt rozpoczęty. (Miro: Visit)
3. Checkout: checkout, pobyt zakończony, ewentualnie zgłoszone zastrzeżenia do pokoju, anulowanie rezerwacji/pobytu, żądanie zwrotu, naliczona rekompensata, pokój ponownie dostępny. (Miro: Faraway)
4. Sprzątanie: checkout tworzy zlecenie sprzątania (FR-11), przydzielono osobę sprzątającą i wysłano powiadomienie, klucz mobilny przydzielony (FR-27), pokój gotowy do sprzątania, pokój wysprzątany, klucz mobilny unieważniony, pokój gotowy dla gościa. (Miro: Housekeeping, grill-me Q4)
5. Usterka: usterka zgłoszona, klucz mobilny przydzielony, usterka usunięta, klucz mobilny unieważniony. (Miro: Servis tech)

## Functional Requirements

| ID | Requirement | Actor | Source |
|---|---|---|---|
| FR-01 | Gość może wybrać konkretny pokój albo tylko typ pokoju. | Gość | grill-me Q25, notatki |
| FR-02 | Przy rezerwacji typu pokój przydzielamy dzień przed przyjazdem; jak nie ma wolnego pokoju danego typu, manager hotelu dostaje alert i decyduje o upgradzie. | System, Manager hotelu | grill-me Q25, Q67 |
| FR-03 | Wszystkie kanały (web, mobile, telefon, walk-in) idą przez jedno API rezerwacji. | Gość, Recepcjonista | notatki |
| FR-04 | Rezerwacje z telefonu i walk-in robi recepcjonista w naszej aplikacji, tą samą ścieżką co gość. | Recepcjonista | grill-me Q6 |
| FR-05 | System decyduje, czy pokój z puli jest zajęty danej nocy; wie też, w jakim stanie jest pokój i kiedy będzie potrzebny. | System | grill-me Q1, notatki |
| FR-06 | Gdy legacy nie odpowiada i płatność czeka w kolejce, blokada pokoju nie wygasa po 10 minutach (A-03), tylko trzyma do odpowiedzi legacy, żeby nie sprzedać pokoju, za który gość już płaci. (usunięte) | System | grill-me Q7 |
| FR-07 | System wymienia pliki z legacy w obie strony co 15 minut: od legacy pula pokoi, które możemy sprzedawać, ceny oraz rezerwacje, zameldowania i wymeldowania pokoi spoza puli; do legacy nasze rezerwacje z puli z danymi gościa, check-iny, checkouty i numer preautoryzacji, żeby legacy rozliczył pobyt. Każdy plik ma numer kolejny, import jest powtarzalny (ten sam plik wczytany dwa razy nic nie psuje), a brak pliku daje alert. | System | grill-me Q29, notatki |
| FR-08 | Raz dziennie system robi pełne porównanie danych z legacy: dla pokoi z puli wygrywa nasz system, dla pokoi spoza puli wygrywa legacy; listę różnic dostaje rano manager hotelu. | System, Manager hotelu | grill-me Q29, notatki |
| FR-09 | Obietnice handlowców zapisujemy jako życzenia w rezerwacji; system sprawdza, czy da się je spełnić, a jak nie, daje znać managerowi. | Handlowiec, Manager hotelu | grill-me Q15 |
| FR-10 | Gdy wybrany pokój nie jest gotowy, przy check-in system proponuje pokój zastępczy; decyduje manager hotelu. | Manager hotelu | grill-me Q2 |
| FR-11 | Checkout tworzy zlecenie sprzątania. | System | grill-me Q4 |
| FR-12 | Priorytet zlecenia sprzątania wynika z tego, kiedy pokój jest znowu potrzebny. | System | grill-me Q4, notatki |
| FR-13 | Na urządzeniu przy wózku housekeeper widzi listę pokoi do zrobienia w kolejności, z życzeniami gościa i usterkami. | Housekeeper | grill-me Q11 |
| FR-14 | Kierowniczka sprzątania ma panel z kolejką wszystkich wózków i może zmienić kolejność. | Kierowniczka sprzątania | grill-me Q38 |
| FR-15 | Usterka blokująca zdejmuje pokój ze sprzedaży; dla gości na ten pokój manager wybiera pokój zastępczy. | Manager hotelu | grill-me Q12 |
| FR-16 | Przy anulowaniu system tylko zwalnia pokój. | System | grill-me Q13 |
| FR-17 | Housekeeping obejmuje wszystkie pokoje hotelu; dla pokoi spoza puli system bierze zameldowania i wymeldowania z pliku z legacy co 15 minut. | System | grill-me Q55 |
| FR-18 | Gdy nasz system padnie, recepcja ma odświeżaną co kwadrans listę przyjazdów, wyjazdów i statusów, zapisaną poza naszymi serwisami (plik w magazynie plików, wysyłany też mailem do recepcji); robi check-in ręcznie, potem wprowadza go w aplikacji, a dalej trafia on do legacy normalną drogą. | Recepcjonista | grill-me Q44, Q66 |
| FR-19 | Pokój z puli niesprzedany na 48 h przed nocą system oddaje do legacy w pliku (nadpisanie pre-rezerwacji); nadpisanie nie anuluje niczyjej rezerwacji. | System | grill-me Q3, notatki, Miro: Synchronizacja |
| FR-20 | Przy wyborze konkretnego pokoju gość widzi jego zdjęcia i położenie na planie piętra. | Gość | grill-me Q25, zadanie: "choose a specific room to stay in by viewing pictures of each room and its location in the hotel" |
| FR-21 | Gdy operator płatności odrzuci kartę, gość od razu to widzi i może podać inną; jak nie zapłaci w 10 minut, blokada pokoju się zwalnia, a przy gościach VIP dzwoni recepcja. | System, Gość, Recepcjonista | grill-me Q65 |
| FR-22 | Przy rezerwacji gość płaci preautoryzacją na stronie zewnętrznego operatora płatności: w web i mobile przechodzi z naszej aplikacji na stronę operatora i wraca z potwierdzeniem, a przy rezerwacji telefonicznej recepcja wysyła mu link do płatności SMS-em albo mailem. | Gość, Recepcjonista | grill-me Q28, notatki |
| FR-23 | Na urządzeniu przy wózku offline działają lista zadań, zmiana statusu pokoju i zgłoszenie usterki; zmiany wysyłają się same po powrocie sieci. | Housekeeper | notatki |
| FR-24 | Gdy kierowniczka sprzątania zmieni kolejność, a wózek jest offline, housekeeper widzi nową kolejność po powrocie sieci, a bieżący pokój kończy; przy konflikcie o kolejność wygrywa kierowniczka, o stan pokoju wygrywa housekeeper, który w nim był. | Housekeeper, Kierowniczka sprzątania | notatki |
| FR-25 | Każde zadanie ma przypisaną jedną osobę, więc dwa wózki nie robią tego samego pokoju. | System | notatki |
| FR-26 | Klucz mobilny gościa system wydaje przy check-inie i unieważnia przy checkoucie; zamek działa z kluczem zapisanym w telefonie, więc wejście do pokoju nie zależy od tego, czy nasz system działa; jak telefon gościa jest rozładowany albo zamek nie odpowiada, recepcja daje kartę. | Gość, Recepcjonista | grill-me Q10, notatki |
| FR-27 | Klucz mobilny dla housekeepera system wydaje przy przydziale zadania i unieważnia po zakończeniu zadania; jak housekeeperowi padnie telefon, bierze kartę serwisową od kierowniczki sprzątania, wydawaną i oddawaną na zmianę. | Housekeeper, Kierowniczka sprzątania | notatki |
| FR-28 | Każdy klucz mobilny ma wpisany czas ważności (koniec pobytu albo koniec zadania), więc sam wygasa, nawet jak unieważnienie nie dotrze do zamka. | System | notatki |
| FR-29 | W czasie przełączania bazy (1-2 minuty) web, mobile i telefon dostają komunikat „spróbuj za chwilę”, zdjęcia pokoi dalej działają z CDN, a wózki zapisują offline. | System | notatki |

## Constraints

| ID | Constraint | Source |
|---|---|---|
| C-01 | Sezon startuje na początku czerwca, obłożenie dochodzi do ok. 90%. | notatki, zadanie: "Peak season is quickly approaching" |
| C-02 | Legacy nie ma API; z legacy wymieniamy pliki w obie strony: legacy przysyła pokoje, które nowy system może rezerwować, a nowy system odsyła, które z nich są zarezerwowane. | notatki |
| C-03 | Smart locki mają API. | notatki |
| C-04 | Ceny ustala ręcznie manager hotelu w legacy. | notatki, grill-me Q36 |
| C-05 | Wszystko z rezerwacji dzieje się u nas oprócz płatności; pobyt rozlicza legacy przy wymeldowaniu jak dziś, a informację o płatności dostaje w pliku. | grill-me Q28 |
| C-06 | Anulowania i zwroty robi legacy. | grill-me Q13 |
| C-07 | Legacy odgórnie blokuje pulę pokoi dla nas i nie może ich sprzedać. | grill-me Q26, Q1 |
| C-08 | Urządzenia przy wózkach to tablety firmy z przeglądarką; nie wiadomo, czy da się na nich instalować aplikacje. | notatki |

## Assumptions

| ID | Assumption | How we validate | Source |
|---|---|---|---|
| A-01 | Legacy umie już dziś blokować pokoje (pre-rezerwacja); jak nie umie, pulę blokujemy w legacy jedną długą techniczną rezerwacją na każdy pokój z puli. | otwarte: Q-03 | notatki |
| A-02 | Hotele poza USA mogą być w innym regionie, ale na start zakładamy jeden region. | otwarte: Q-02 | notatki |
| A-03 | Niezapłacona rezerwacja trzyma pokój przez 10 minut (czas, w którym gość płaci u operatora płatności), potem pokój wraca do sprzedaży; na legacy nic nie czeka. | _Brak w notatkach._ | grill-me Q7 |
| A-04 | „Less than 20” to personel na hotel, z czego ok. 8-10 osób to housekeeperzy z urządzeniem przy wózku. | _Brak w notatkach._ | grill-me Q69, zadanie: "Hotel staff: less than 20" |
| A-05 | Wymiana plików z legacy co 15 minut; jak legacy umie tylko raz dziennie, pula dalej jest bezpieczna, a wymeldowania spoza puli recepcja zgłasza ręcznie. | otwarte: Q-06 | notatki |

## Open Questions

| ID | Question | Source |
|---|---|---|
| Q-01 | Kiedy będzie gotowe API legacy i czy zdążymy przed czerwcem? (usunięte) | notatki |
| Q-02 | Gdzie są hotele spoza USA i czy dane gości muszą tam zostać? | notatki |
| Q-03 | Czy blokowanie pokoi w legacy już dziś działa? | notatki |
| Q-04 | Co biznes miał na myśli przez „kupowanie rzeczy dla gości”: życzenia do pokoju czy osobny sklep? | notatki |
| Q-05 | Jak duża ma być pula na hotel i kto ją ustala? | notatki |
| Q-06 | Jak często legacy może wysyłać i przyjmować pliki i w jakim formacie? | notatki |
| Q-07 | Czy biznes zgadza się na preautoryzację u zewnętrznego operatora płatności przy rezerwacji, z rozliczeniem w legacy przy wymeldowaniu? | notatki |
