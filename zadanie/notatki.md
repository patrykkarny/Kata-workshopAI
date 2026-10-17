# Notatki zespołu

Zespół: White
Uczestnicy: Marek, Patryk, Mariusz, Kamil

<!--
Tu piszecie WY. Krótko, punktami, pełnymi myślami ("płatność potwierdzana przed wysłaniem do kuchni, bo ...").
Sekcje są tylko podpowiedzią: jeśli coś nie pasuje, wpiszcie to gdziekolwiek, spec-builder i tak to rozłoży.
Nie kasujcie starych notatek. Gdy zmieniacie zdanie, dopiszcie nową notatkę ("zmiana: ...").
-->

## Nasze pytania i odpowiedzi

<!-- Pytania, które zadaliście sobie albo "biznesowi", i odpowiedzi. Brak odpowiedzi też zapiszcie. -->

Co powiedział biznes:
- 107 hoteli, w tym 42 w USA, które robią 2500 rezerwacji dziennie; hotel ma ok. 200 pokoi
- sezon startuje na początku czerwca, obłożenie dochodzi do ok. 90%
- dziś rezerwacje są głównie przez telefon i przy wejściu
- gość chce sam wybrać konkretny pokój (np. daleko od windy), automatyczny dobór nie jest potrzebny
- zdjęcia i opisy pokoi dostajemy gotowe
- legacy ma API, ale integracja jest jeszcze w toku
- sprzątanie to ludzie hotelu, dziś kierowniczka rozdziela pracę przez wiadomości
- najważniejszy dla biznesu jest system do sprzątania
- pokój ma być przygotowany w 15 minut
- smart locki mają API
- ceny ustala ręcznie manager hotelu
- raporty finansowe są opcjonalne

Nasze wyliczenia:
- 107 hoteli x 200 pokoi to ok. 21 tys. pokoi
- ok. 60 rezerwacji na hotel dziennie, na 107 hoteli ok. 6400 dziennie, czyli średnio jedna rezerwacja co 14 sekund
- wymeldowania skupiają się między 10 a 12, to ok. jedno na 2 minuty w hotelu
- wniosek: ruch jest mały, skalowanie nie jest naszym problemem

Bez odpowiedzi biznesu (zakładamy):
- legacy umie już dziś blokować pokoje (pre-rezerwacja)
- hotele poza USA mogą być w innym regionie, ale na start zakładamy jeden region

## Odpowiedzi na grill-me

<!-- Odpowiadajcie numerem pytania z grill-me.md, np. "Q7: timeout 10 minut, potem anulujemy zamówienie". -->

- Q1: o tym, czy pokój z puli jest zajęty danej nocy, decyduje nasz system; legacy tych pokoi nie sprzedaje
- Q2: jak wybrany pokój nie jest gotowy, przy check-in proponujemy zastępczy, decyduje manager hotelu
- Q3: pre-rezerwacja to blokada pokoju w legacy dla naszej puli; jej nadpisanie oddaje pokój z powrotem do legacy, nie anuluje niczyjej rezerwacji
- Q4: checkout tworzy zlecenie sprzątania, priorytet bierzemy z tego, kiedy pokój jest znowu potrzebny
- Q5: na pierwszy dzień sezonu: rezerwacje, check-in, pobyt, checkout i housekeeping; marketing, ceny i raporty zostają w legacy
- Q6: rezerwacje z telefonu i walk-in robi recepcjonista w naszej aplikacji, tą samą ścieżką co gość
- Q7: zakładamy, że niezapłacona rezerwacja trzyma pokój przez 10 minut, potem pokój wraca do sprzedaży
- Q7: jak legacy leży i płatność czeka w kolejce, blokada pokoju nie wygasa po 10 minutach, tylko trzyma do odpowiedzi legacy, bo inaczej sprzedalibyśmy pokój, za który gość już płaci
- Q10: klucze mobilne dopiero w etapie 2, na start karty jak dziś
- Q11: na urządzeniu przy wózku housekeeper widzi listę pokoi do zrobienia w kolejności, z życzeniami gościa i usterkami
- Q12: usterka blokująca zdejmuje pokój ze sprzedaży, dla gości na ten pokój manager wybiera zastępczy
- Q13: anulowania i zwroty robi legacy, my tylko zwalniamy pokój
- Q15: obietnice handlowców zapisujemy jako życzenia w rezerwacji, system sprawdza czy się da i jak nie, daje znać managerowi
- Q18: dostępny to wolny do sprzedaży, gotowy to posprzątany; to dwa różne stany
- Q25: gość może wybrać konkretny pokój albo tylko typ; przy typie pokój przydzielamy dzień przed przyjazdem
- Q26: legacy odgórnie blokuje pulę pokoi dla nas i nie może ich sprzedać
- Q28: wszystko z rezerwacji dzieje się u nas oprócz płatności, płatność robi legacy przez API
- Q29: zmiana: rezerwacje i płatności wysyłamy do legacy od razu, a raz dziennie robimy tylko porównanie danych; sama synchronizacja raz dziennie nie potwierdziłaby płatności
- Q31: zmiana: top 3 to prostota, integracje i odporność na awarie (szczegóły w charakterystykach)
- Q34: to ten sam pokój, ale każdy kontekst trzyma o nim co innego: oferta zdjęcia, dostępność noce i status, housekeeping zadania
- Q36: Marketing odpowiada za zdjęcia i opisy, status pokoju jest u nas, cena u managera w legacy
- Q38: kierowniczka sprzątania dostaje panel z kolejką wszystkich wózków i może zmienić kolejność
- Q44: jak nasz system padnie, recepcja ma odświeżaną co kwadrans listę przyjazdów, wyjazdów i statusów, robi check-in ręcznie i dopisuje potem
- Q55: housekeeping obejmuje wszystkie pokoje hotelu; dla pokoi spoza puli bierzemy zameldowania i wymeldowania z legacy co kilka minut

## Domena: bounded contexty i moduły

<!-- Jakie konteksty wyszły z Event Stormingu, który jest core, co należy do którego modułu. -->

Z tablicy (zrzut: event-storming/kata-white.png), nazwy jak na ramkach:
- Rezerwacja (core): zapytanie o dostępność, wymagania i życzenia gościa, rezerwacja typu albo konkretnego pokoju, zdjęcie dostępności; wszystkie kanały (web, mobile, telefon, walk-in) przez jedno API
- w Rezerwacji siedzi też dostępność i status pokoju: jedyne miejsce, które wie, czy pokój jest wolny danej nocy, w jakim jest stanie i kiedy będzie potrzebny
- Housekeeping (core): zlecenia sprzątania, przydział osoby, pokój gotowy do sprzątania, wysprzątany, gotowy dla gościa
- Servis tech (core): zgłoszenie i usunięcie usterki
- Visit (supporting): check-in, przydzielenie zamka, pierwsze wejście, pobyt rozpoczęty
- Faraway (supporting): checkout, zastrzeżenia do pokoju, anulowanie, zwrot, rekompensata, pokój znowu dostępny
- Marketing (supporting): standard, cechy, zdjęcia, ID zamka i udostępnienie oferty; zdjęcia i opisy dostajemy gotowe
- Synchronizacja (supporting): jedyne miejsce, które rozmawia z legacy: pre-rezerwacje i pula, rezerwacje, płatności, ceny, raporty check-in i checkout, porównanie danych
- Payments (generic): płatności, rejestracja płatności i zwroty robi legacy, my tylko wysyłamy żądanie przez Synchronizację
- raporty managera nie mają ramki, zostają w legacy tak jak dziś
- klucze mobilne są na kilku ramkach (Visit, Housekeeping, Servis tech), więc to wspólna funkcja, a nie osobny obszar; wchodzą w etapie 2

Jak się łączą:
- Rezerwacja to jedyne miejsce, które może zająć pokój na noc, więc Visit i Faraway proszą ją o zmianę stanu pokoju
- Faraway po checkoucie wysyła do Housekeepingu zlecenie sprzątania
- Rezerwacja mówi Housekeepingowi, na kiedy pokój ma być gotowy, z tego liczymy priorytet
- Housekeeping i Servis tech mówią Rezerwacji, że pokój jest gotowy albo ma usterkę
- legacy schowane za Synchronizacją, żeby jego model nie wyciekał do reszty systemu

Jak ramki mapują się na serwisy:
- serwis Rezerwacje: ramka Rezerwacja razem z dostępnością i statusem pokoju, bo zablokowanie pokoju na noc musi być jedną transakcją
- serwis Housekeeping: ramki Housekeeping i Servis tech razem, bo to ci sami ludzie, jedna kolejka i ten sam priorytet; do tego API dla urządzeń przy wózkach
- serwis Pobyt: ramki Visit i Faraway razem, bo to początek i koniec tego samego pobytu; w etapie 2 też klucze mobilne
- serwis Synchronizacja: ramka Synchronizacja i wywołania do Payments, z kolejką na czas awarii legacy
- serwis Oferta: ramka Marketing, tylko do odczytu dla reszty

## Charakterystyki architektury

<!-- Co system musi dobrze robić i dlaczego (dostępność, skalowalność, bezpieczeństwo, ...). Które 3 są najważniejsze. -->

Top 3:
1. Prostota (simplicity): chodzi o prostą architekturę, nie o łatwość obsługi; system ma działać w czerwcu albo czekamy rok i robi go normalny zespół, więc mało serwisów, jedna baza, bez egzotycznej technologii; mierzymy tym, że MVP chodzi w hotelach pilotażowych przed sezonem
2. Integracje (interoperability): prawie wszystko idzie przez cudze systemy: legacy, smart locki, urządzenia przy wózkach, cztery kanały; zmiana API legacy ma ruszać tylko Synchronizację, nie resztę systemu
3. Odporność na awarie (fault tolerance): w sezonie przy 90% obłożenia hotel nie może stanąć; jak legacy nie odpowiada przez pół godziny, check-in, checkout i sprzątanie działają dalej, a płatności czekają w kolejce; jak padnie serwis rezerwacji, housekeeping dalej działa

Ważne, ale poza top 3:
- spójność danych: podwójnej rezerwacji pilnuje pula i to, że pokój na noc zapisujemy w jednym miejscu, nie wybór stylu
- bezpieczeństwo: dane kart zostają w legacy, klucze mobilne dopiero w etapie 2, housekeeper dostaje klucz tylko do swojego pokoju na czas sprzątania
- łatwość obsługi: ważna, ale to sprawa interfejsu, nie architektury
- ewolucyjność: handlowcy cały czas coś obiecują, więc nowe rzeczy dokładamy w serwisie, którego dotyczą, albo jako adapter w Synchronizacji

Odrzucone:
- skalowalność i elastyczność: jedna rezerwacja co 14 sekund to mało, a „peak season” w zadaniu chodzi o termin, nie o ruch

15 minut na pokój liczymy od „gotowy do sprzątania” do „gotowy dla gościa”.

## Decyzje

<!-- "Wybraliśmy X zamiast Y, bo ...". Każdą decyzję zapiszecie potem przez adr-builder. -->

- Styl: service-based, czyli kilka dużych serwisów domenowych (Rezerwacje, Housekeeping, Pobyt, Synchronizacja, Oferta) ze wspólną bazą, bo awaria jednego obszaru nie może zatrzymać hotelu, a to wciąż na tyle proste, że zdążymy na czerwiec
- Odrzuciliśmy modularny monolit i microkernel, bo są tańsze i prostsze, ale jak padnie aplikacja, pada wszystko, a odporność na awarie mamy w top 3
- Odrzuciliśmy mikroserwisy i event-driven, bo to za dużo ruchomych części jak na nasz termin, a event-driven dodatkowo daje spójność ostateczną tam, gdzie blokada pokoju potrzebuje transakcji
- Cena service-based: pięć rzeczy do wdrożenia zamiast jednej i wywołania po sieci między serwisami
- Pokój na noc i jego status trzymamy u siebie, a nie w legacy, bo legacy nie sprzedaje puli, a sprzątanie potrzebuje jednego statusu; cena: musimy codziennie porównywać dane z legacy
- Z legacy gadamy przez API od razu, a nie synchronizacją raz dziennie, bo inaczej nie potwierdzimy płatności; jak API legacy nie zdąży na czerwiec, plan B to wymiana plików co 15 minut
- Płatności zostają w legacy, a nie u nas, bo tak mówi wymaganie 05 i nie chcemy trzymać danych kart
- Jedna baza PostgreSQL z osobnym schematem na serwis, a nie baza na serwis, bo to prostsze i blokadę pokoju na noc załatwia jedna transakcja w serwisie Rezerwacje; serwisy nie czytają cudzych schematów; cena: baza to wspólny punkt awarii, więc replika i backupy
- Housekeeping wchodzi na pierwszy dzień dla wszystkich pokoi hotelu, a nie później, bo biznes mówi, że to najważniejsze
- Aplikacja na wózki jako aplikacja webowa działająca offline, a nie natywna, bo urządzenia daje firma, chcemy jeden stack, a Wi-Fi w hotelu się rwie
- Smart locki w etapie 2 jako adapter w serwisie Pobyt, a nie w MVP, bo nie zdążymy, a klucz w telefonie to fizyczny dostęp do pokoju i musi być dopięty
- Jedna platforma dla wszystkich hoteli w regionie USA, a nie instancja na hotel, bo 107 wdrożeń to za dużo; ten sam zestaw serwisów można postawić w drugim regionie
- Nie optymalizujemy pod skalowanie, bo ruch jest mały; wracamy do tematu, jak przekroczymy ok. 100 rezerwacji na minutę

## Nadal otwarte

<!-- Czego wciąż nie wiecie. -->

- kiedy będzie gotowe API legacy i czy zdążymy przed czerwcem
- gdzie są hotele spoza USA i czy dane gości muszą tam zostać
- czy blokowanie pokoi w legacy już dziś działa
- co biznes miał na myśli przez „kupowanie rzeczy dla gości”: życzenia do pokoju czy osobny sklep
- jak duża ma być pula na hotel i kto ją ustala
