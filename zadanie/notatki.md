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
- widok 3D pokoju pokazujemy tylko, jeśli hotel go dostarczy; na start zdjęcia i położenie na planie piętra
- legacy ma API, ale integracja jest jeszcze w toku
- zmiana: legacy nie ma API; z legacy wymieniamy pliki w obie strony: legacy przysyła pokoje, które nowy system może rezerwować, a nowy system odsyła, które z nich są zarezerwowane
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
- wniosek: pojedyncza rezerwacja to mały ruch, ale platforma od pierwszego dnia obsługuje 107 hoteli naraz i ma przyjmować kolejne, a check-iny i checkouty we wszystkich hotelach wypadają w tych samych godzinach

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
- Q7: 10 minut to czas, w którym gość płaci u operatora płatności; na legacy nic nie czeka
- Q10: zmiana: smart locki i klucze mobilne wchodzą do MVP; jak telefon gościa jest rozładowany albo zamek nie odpowiada, recepcja daje kartę jak dziś
- Q11: na urządzeniu przy wózku housekeeper widzi listę pokoi do zrobienia w kolejności, z życzeniami gościa i usterkami
- Q12: usterka blokująca zdejmuje pokój ze sprzedaży, dla gości na ten pokój manager wybiera zastępczy
- Q13: anulowania i zwroty robi legacy, my tylko zwalniamy pokój
- Q15: obietnice handlowców zapisujemy jako życzenia w rezerwacji, system sprawdza czy się da i jak nie, daje znać managerowi
- Q18: dostępny to wolny do sprzedaży, gotowy to posprzątany; to dwa różne stany
- Q25: gość może wybrać konkretny pokój albo tylko typ; przy typie pokój przydzielamy dzień przed przyjazdem
- Q25: przy wyborze konkretnego pokoju gość widzi jego zdjęcia i położenie na planie piętra, bo o to chodzi w zadaniu (wymaganie 02)
- Q26: legacy odgórnie blokuje pulę pokoi dla nas i nie może ich sprzedać
- Q28: wszystko z rezerwacji dzieje się u nas oprócz płatności, płatność robi legacy przez API
- Q28: zmiana: przy rezerwacji gość płaci na stronie operatora płatności (preautoryzacja), a pobyt rozlicza legacy przy wymeldowaniu jak dziś; informację o płatności dostaje w pliku
- Q29: zmiana: z legacy wymieniamy pliki w obie strony co 15 minut, a raz dziennie robimy pełne porównanie danych
- Q31: zmiana: top 3 to prostota, skalowalność i odporność na awarie (szczegóły w charakterystykach)
- Q34: to ten sam pokój, ale każdy kontekst trzyma o nim co innego: oferta zdjęcia, dostępność noce i status, housekeeping zadania
- Q36: Marketing odpowiada za zdjęcia i opisy, status pokoju jest u nas, cena u managera w legacy
- Q38: kierowniczka sprzątania dostaje panel z kolejką wszystkich wózków i może zmienić kolejność
- Q44: jak nasz system padnie, recepcja ma odświeżaną co kwadrans listę przyjazdów, wyjazdów i statusów, robi check-in ręcznie i dopisuje potem
- Q55: housekeeping obejmuje wszystkie pokoje hotelu; dla pokoi spoza puli bierzemy zameldowania i wymeldowania z pliku z legacy co 15 minut

Runda 5:
- Q60: baza to zarządzany PostgreSQL z repliką w drugiej strefie i automatycznym przełączeniem w 1-2 minuty; w tym czasie wózki zapisują offline, a recepcja ma listę awaryjną; różnica z monolitem: błąd w kodzie, wdrożenie albo przeciążenie jednego serwisu nie kładzie pozostałych, a awarię samej bazy łapie replika
- Q61: każdy serwis chodzi minimum na dwóch instancjach i wdrażamy po kolei, więc wdrożenie nie zatrzymuje rezerwacji ani check-inów
- Q62: zmiana: „pokój gotowy” i „usterka” z Housekeepingu idą do Rezerwacji przez kolejkę zdarzeń, nie przez HTTPS; jak Rezerwacje leżą, zdarzenia czekają w kolejce, a status na recepcji uzupełnia się po powrocie
- Q63: Synchronizacja przekazuje do Rezerwacji rezerwacje z legacy dla pokoi spoza puli, Rezerwacje liczą „pokój potrzebny o” dla wszystkich pokoi i wysyłają to do Housekeepingu
- Q64: w maju pilot w 2-3 hotelach, od początku czerwca wszystkie hotele
- Q65: jak operator płatności odrzuci kartę, gość od razu to widzi i może podać inną; jak nie zapłaci w 10 minut, blokada się zwalnia, a przy gościach VIP dzwoni recepcja
- Q66: listę awaryjną co 15 minut generuje serwis Pobyt i zapisuje poza naszymi serwisami (plik w magazynie plików, wysyłany też mailem do recepcji); ręczne check-iny recepcja wprowadza potem w aplikacji, a dalej trafiają do legacy normalną drogą
- Q67: przydział pokoju dzień przed przyjazdem robi zadanie w serwisie Rezerwacje; jak nie ma wolnego pokoju danego typu, manager dostaje alert i decyduje o upgradzie
- Q68: FR-02, FR-09 i FR-15 są w serwisie Rezerwacje, FR-18 w serwisie Pobyt
- Q69: zakładamy, że „less than 20” to personel na hotel, z czego ok. 8-10 osób to housekeeperzy z urządzeniem przy wózku

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
- Synchronizacja (supporting): jedyne miejsce, które wymienia pliki z legacy: od legacy pula pokoi, ceny, rezerwacje i pobyty spoza puli; do legacy nasze rezerwacje z puli, check-iny i checkouty, informacja o płatności; plus porównanie danych
- Payments (generic): preautoryzację przy rezerwacji robi zewnętrzny operator płatności, a rozliczenie pobytu i zwroty robi legacy; my nie widzimy danych kart
- raporty managera nie mają ramki, zostają w legacy tak jak dziś
- klucze mobilne są na kilku ramkach (Visit, Housekeeping, Servis tech), więc to wspólna funkcja, a nie osobny obszar; są w MVP

Jak się łączą:
- Rezerwacja to jedyne miejsce, które może zająć pokój na noc, więc Visit i Faraway proszą ją o zmianę stanu pokoju
- Faraway po checkoucie wysyła do Housekeepingu zlecenie sprzątania
- Rezerwacja mówi Housekeepingowi, na kiedy pokój ma być gotowy, z tego liczymy priorytet
- Housekeeping i Servis tech mówią Rezerwacji, że pokój jest gotowy albo ma usterkę
- legacy schowane za Synchronizacją, żeby jego model nie wyciekał do reszty systemu

Jak ramki mapują się na serwisy (serwisy nazywamy po angielsku, ramki zostają jak na tablicy):
- Reservations Service: ramka Rezerwacja razem z dostępnością i statusem pokoju, bo zablokowanie pokoju na noc musi być jedną transakcją
- Housekeeping Service: ramki Housekeeping i Servis tech razem, bo to ci sami ludzie, jedna kolejka i ten sam priorytet; do tego API dla urządzeń przy wózkach
- Stay Service: ramki Visit i Faraway razem, bo to początek i koniec tego samego pobytu; tu jest też adapter smart locków, który wydaje i unieważnia klucze mobilne
- Legacy Sync Service: ramka Synchronizacja, czyli import i eksport plików z legacy
- Room Offer Service: ramka Marketing, tylko do odczytu dla reszty

Które wymagania robi który serwis:
- Reservations Service: FR-01, FR-02, FR-03, FR-04, FR-05, FR-09, FR-15, FR-16, FR-21, FR-22
- Housekeeping Service: FR-11, FR-12, FR-13, FR-14, FR-17, FR-23, FR-24, FR-25
- Stay Service: FR-10, FR-18, FR-26, FR-27, FR-28
- Legacy Sync Service: FR-07, FR-08, FR-19
- Room Offer Service: FR-20 (zdjęcia, plany pięter i cechy pokoi do wyboru)
- FR-29 (zachowanie przy przełączaniu bazy) dotyczy wszystkich serwisów

Hot spoty z tablicy i rozmów:
- Rezerwacja: dwa kanały mogą chcieć ten sam pokój na tę samą noc, dlatego blokada pokoju na noc jest w jednym miejscu
- Synchronizacja: legacy nie ma API, tylko pliki, dlatego pula pokoi jest tylko nasza, a dane spoza puli mogą być spóźnione do 15 minut
- Housekeeping: Wi-Fi w hotelu się rwie, dlatego aplikacja na wózki działa offline
- Rezerwacja: handlowcy obiecują gościom rzeczy, których nie ma w systemie, dlatego obietnice zapisujemy jako życzenia ze sprawdzeniem

## Charakterystyki architektury

<!-- Co system musi dobrze robić i dlaczego (dostępność, skalowalność, bezpieczeństwo, ...). Które 3 są najważniejsze. -->

Top 3:
1. Prostota (simplicity): chodzi o prostą architekturę, nie o łatwość obsługi; system ma działać w czerwcu albo czekamy rok i robi go normalny zespół, więc mało serwisów, jedna baza, bez egzotycznej technologii; mierzymy tym, że MVP chodzi w hotelach pilotażowych przed sezonem
2. Skalowalność (scalability): chodzi o wzrost, a nie o nagłe skoki; dowód: 107 hoteli i ok. 2500 rezerwacji dziennie na 42 hotele od biznesu, obłożenie do 90% w sezonie; platforma od pierwszego dnia obsługuje 107 hoteli i ok. 21 tys. pokoi, firma ma dokładać kolejne hotele, a check-iny i checkouty we wszystkich hotelach wypadają w tych samych godzinach; nowy hotel to konfiguracja, a nie zmiana kodu, a serwis, który się dławi, dostaje więcej instancji bez ruszania reszty
3. Odporność na awarie (fault tolerance): w sezonie przy 90% obłożenia hotel nie może stanąć; nic w rezerwacji, check-inie, checkoucie ani sprzątaniu nie czeka na legacy na żywo, więc jak legacy leży albo plik nie przyjdzie, hotel działa dalej; jak padnie serwis rezerwacji, housekeeping dalej działa

Ważne, ale poza top 3:
- spójność danych: podwójnej rezerwacji pilnuje pula i to, że pokój na noc zapisujemy w jednym miejscu, nie wybór stylu
- bezpieczeństwo: danych kart nie widzimy, przyjmuje je operator płatności; klucz mobilny to fizyczny dostęp do pokoju, więc klucz gościa działa tylko w czasie pobytu, housekeeper dostaje klucz tylko do swojego pokoju na czas zadania, a checkout unieważnia klucz od razu
- integracje: dużo idzie przez cudze systemy (pliki z legacy, smart locki, urządzenia przy wózkach, operator płatności), więc każdą trzymamy w jednym miejscu: legacy w Synchronizacji, zamki w Pobycie; zmiana formatu plików legacy rusza tylko Synchronizację
- łatwość obsługi: ważna, ale to sprawa interfejsu, nie architektury
- ewolucyjność: handlowcy cały czas coś obiecują, więc nowe rzeczy dokładamy w serwisie, którego dotyczą, albo jako adapter w Synchronizacji

Odrzucone:
- skalowalność i elastyczność: jedna rezerwacja co 14 sekund to mało, a „peak season” w zadaniu chodzi o termin, nie o ruch
- zmiana: skalowalność wraca do top 3 jako wzrost liczby hoteli; odrzucona zostaje tylko elastyczność (automatyczne skalowanie w górę i w dół), bo ruch nie ma nagłych skoków, a szczyt sezonu znamy z góry

Trade-offy:
- prostota kontra odporność na awarie: oddajemy część prostoty (pięć serwisów zamiast jednej aplikacji), żeby awaria jednego obszaru nie zatrzymała hotelu
- prostota kontra spójność: zostajemy przy jednej bazie zamiast bazy na serwis, bo to prostsze i blokada pokoju to jedna transakcja; płacimy tym, że baza jest wspólnym punktem awarii, więc replika
- prostota kontra skalowalność: pięć serwisów, które skalujemy osobno, zamiast jednej aplikacji; nie idziemy w mikroserwisy, bo przy naszym ruchu dokładanie instancji serwisu wystarczy
- integracje kontra aktualność: legacy ma tylko pliki, więc dane o pokojach spoza puli mogą być spóźnione do 15 minut; dla puli to nie problem, bo sprzedajemy ją tylko my
- bezpieczeństwo kontra termin: smart locki wchodzą do MVP, bo firma w nie inwestuje, więc przed sezonem musimy zrobić testy bezpieczeństwa; płacimy czasem w maju

Jak mierzymy:
- skalowalność: test obciążenia na 3x najgorszą godzinę (ok. 65 rezerwacji na minutę plus checkouty ze wszystkich hoteli w oknie 10-12) przed sezonem; dodanie nowego hotelu bez zmiany kodu
- integracje: zmiana formatu pliku legacy zmienia kod tylko w Synchronizacji; testy na przykładowych plikach z legacy przy każdym buildzie
- odporność na awarie: test, w którym wyłączamy serwis Rezerwacje na 30 minut, a check-in, checkout i sprzątanie działają
- housekeeping: 15 minut od „gotowy do sprzątania” do „gotowy dla gościa”, mierzone na urządzeniu przy wózku

15 minut na pokój liczymy od „gotowy do sprzątania” do „gotowy dla gościa”.

## Decyzje

<!-- "Wybraliśmy X zamiast Y, bo ...". Każdą decyzję zapiszecie potem przez adr-builder. -->

- Styl: service-based, czyli kilka dużych serwisów domenowych (Reservations, Housekeeping, Stay, Legacy Sync, Room Offer) ze wspólną bazą, bo awaria jednego obszaru nie może zatrzymać hotelu, a to wciąż na tyle proste, że zdążymy na czerwiec
- Odrzuciliśmy modularny monolit i microkernel, bo są tańsze i prostsze, ale jak padnie aplikacja, pada wszystko, a odporność na awarie mamy w top 3
- Odrzuciliśmy mikroserwisy i event-driven, bo to za dużo ruchomych części jak na nasz termin, a event-driven dodatkowo daje spójność ostateczną tam, gdzie blokada pokoju potrzebuje transakcji
- Cena service-based: pięć rzeczy do wdrożenia zamiast jednej i wywołania po sieci między serwisami
- Serwisy gadają ze sobą przez HTTPS, a zmiany statusu pokoju (gość wymeldowany, pokój potrzebny o, pokój gotowy) idą przez prostą kolejkę zdarzeń, bo housekeeping ma działać dalej, nawet jak serwis rezerwacji leży
- Oferta na pierwszy dzień tylko pokazuje zdjęcia, plany pięter i cechy pokoi, bo bez tego gość nie wybierze konkretnego pokoju; ceny i kampanie marketingu zostają w legacy (Q5)
- Zakres pierwszego dnia to rezerwacje, check-in, checkout, housekeeping i pokazywanie zdjęć pokoi przez Ofertę; reszta marketingu zostaje w legacy
- Jeden stack: TypeScript (NestJS na backendzie, React na frontendzie) i PostgreSQL, a logowanie przez zewnętrznego dostawcę tożsamości, bo zespół ma znać jedną technologię i nie budujemy własnego logowania
- Pokój na noc i jego status trzymamy u siebie, a nie w legacy, bo legacy nie sprzedaje puli, a sprzątanie potrzebuje jednego statusu; cena: musimy codziennie porównywać dane z legacy
- Z legacy wymieniamy pliki w obie strony co 15 minut, a nie raz dziennie, bo housekeeping potrzebuje świeżych wymeldowań z pokoi spoza puli; API nie ma, więc innej drogi nie ma
- Płatność przy rezerwacji: preautoryzacja na stronie zewnętrznego operatora płatności, a rozliczenie pobytu i zwroty w legacy jak dziś, bo legacy nie ma API do płatności na żywo, a nie chcemy trzymać danych kart; zostajemy przy legacy tam, gdzie się da (wymaganie 05)
- Jedna baza PostgreSQL z osobnym schematem na serwis, a nie baza na serwis, bo to prostsze i blokadę pokoju na noc załatwia jedna transakcja w serwisie Rezerwacje; serwisy nie czytają cudzych schematów; cena: baza to wspólny punkt awarii, więc replika i backupy
- Housekeeping wchodzi na pierwszy dzień dla wszystkich pokoi hotelu, a nie później, bo biznes mówi, że to najważniejsze
- Aplikacja na wózki jako aplikacja webowa działająca offline, a nie natywna, bo urządzenia daje firma, chcemy jeden stack, a Wi-Fi w hotelu się rwie
- Smart locki w MVP jako adapter w Stay Service, a nie później, bo firma mocno inwestuje w zamki otwierane telefonem, a dostawca ma gotowe API; cena: więcej pracy przed czerwcem i obowiązkowe testy bezpieczeństwa w maju
- Jedna platforma dla wszystkich hoteli w regionie USA, a nie instancja na hotel, bo 107 wdrożeń to za dużo; ten sam zestaw serwisów można postawić w drugim regionie
- Nie optymalizujemy pod skalowanie, bo ruch jest mały; wracamy do tematu, jak przekroczymy ok. 100 rezerwacji na minutę
- zmiana: skalujemy w poziomie per serwis (dokładamy instancje temu serwisowi, który tego potrzebuje), nowy hotel dodajemy konfiguracją, a nie wdrożeniem; nie robimy elastyczności, bo szczyt sezonu znamy z góry i wystarczy go zaplanować

Doprecyzowania po ADR-ach:

Pokój i status, gdy coś leży
- zmiana: check-in i checkout z Pobytu też idą do Rezerwacji jako zdarzenia przez kolejkę, a nie przez HTTPS, bo inaczej check-in nie zadziała, jak Rezerwacje leżą (AC-03)
- Pobyt i Housekeeping trzymają u siebie kopię tego, czego potrzebują z Rezerwacji (przyjazdy na dziś, status pokoju, „pokój potrzebny o”), aktualizowaną zdarzeniami; jak Rezerwacje leżą, pracują na ostatnim znanym stanie
- z tej kopii Pobyt robi też listę awaryjną dla recepcji, więc nie czyta cudzego schematu
- usterka blokująca czeka w kolejce tylko wtedy, gdy Rezerwacje leżą, a wtedy i tak nikt nie sprzedaje pokoi; normalnie zdarzenie dochodzi w kilka sekund
- w czasie przełączania bazy (1-2 minuty) web, mobile i telefon dostają „spróbuj za chwilę”, zdjęcia pokoi dalej działają z CDN, a wózki zapisują offline

Kolejka
- każdy serwis zapisuje zdarzenie w swoim schemacie razem z danymi (outbox), a dalej idzie przez zarządzaną kolejkę w chmurze, która nie zależy od naszej bazy
- zdarzenie może przyjść dwa razy, więc każdy odbiorca sprawdza jego identyfikator i drugi raz go ignoruje
- kolejka służy tylko do zmian statusu pokoju (check-in, checkout, pokój potrzebny o, pokój gotowy, usterka); to nie jest event-driven dla całego systemu, więc nie przeczy odrzuceniu event-driven w stylu

Legacy (pliki)
- legacy przysyła pulę pokoi, które możemy sprzedawać, a nasz system odsyła, które z nich są zarezerwowane; pula jest tylko nasza, więc opóźnienie plików nie grozi podwójną rezerwacją
- od legacy bierzemy też ceny oraz rezerwacje, zameldowania i wymeldowania pokoi spoza puli, bo housekeeping robi wszystkie pokoje
- do legacy wysyłamy nasze rezerwacje z danymi gościa, check-iny, checkouty i numer preautoryzacji, żeby legacy rozliczył pobyt
- zakładamy wymianę co 15 minut; jak legacy umie tylko raz dziennie, pula dalej jest bezpieczna, a wymeldowania spoza puli recepcja zgłasza ręcznie
- każdy plik ma numer kolejny; import jest powtarzalny, więc ten sam plik wczytany dwa razy nic nie psuje; brak pliku daje alert
- raz dziennie pełne porównanie: dla pokoi z puli wygrywa nasz system, dla pokoi spoza puli wygrywa legacy; listę różnic dostaje rano manager hotelu
- jak legacy nie umie blokować pokoi (A-01), pulę blokujemy w legacy jedną długą techniczną rezerwacją na każdy pokój z puli
- pokój z puli niesprzedany na 48 h przed nocą oddajemy do legacy w pliku (nadpisanie pre-rezerwacji)
- gość w web i mobile przechodzi z naszej aplikacji na stronę operatora płatności i wraca z potwierdzeniem; przy rezerwacji telefonicznej recepcja wysyła gościowi link do płatności SMS-em albo mailem

Baza
- wspólna baza daje to, że utrzymujemy jedną bazę z jedną repliką i jednym backupem zamiast pięciu, czyli prościej i taniej
- każdy serwis ma własnego użytkownika bazy z dostępem tylko do swojego schematu, więc nie może czytać cudzych danych
- backup co noc plus ciągły zapis zmian, odtworzenie do dowolnej chwili z ostatnich 7 dni, odtworzenie trwa poniżej godziny
- przełączenie na replikę ćwiczymy raz przed sezonem i potem raz na kwartał

Wózki
- urządzenia to tablety firmy z przeglądarką, nie wiemy, czy da się na nich instalować aplikacje, dlatego aplikacja webowa
- cena offline: trzeba napisać i przetestować synchronizację zmian i rozwiązywanie konfliktów
- offline działa lista zadań, zmiana statusu pokoju i zgłoszenie usterki; zmiany wysyłają się same po powrocie sieci
- jak kierowniczka zmieni kolejność, a wózek jest offline, housekeeper zobaczy nową kolejność po powrocie sieci; bieżący pokój kończy
- przy konflikcie o kolejność wygrywa kierowniczka, o stan pokoju wygrywa housekeeper, który w nim był
- 15 minut liczymy z czasu zapisanego na urządzeniu, a nie z czasu dotarcia zmiany na serwer
- każde zadanie ma przypisaną jedną osobę, więc dwa wózki nie robią tego samego pokoju
- każdy pokój ma checklistę sprzątania na urządzeniu przy wózku; zadania nie da się zamknąć bez przejścia checklisty, bo w luksusie gość nie wybacza drobiazgów
- po sprzątaniu urządzenie prosi wyrywkowo o zdjęcie pokoju; zdjęcia trafiają do magazynu plików, a kierowniczka sprawdza jakość bez stania nad ludźmi; offline zdjęcie czeka w kolejce na urządzeniu

Smart locki
- klucz dla housekeepera wydaje Pobyt na prośbę Housekeepingu przy przydziale zadania i unieważnia po zakończeniu zadania
- powiązanie zamka z pokojem ustawia hotel w konfiguracji Pobytu, a nie Marketing, bo to dane techniczne
- adapter zamków jest w Pobycie, a nie w Synchronizacji, bo Synchronizacja jest tylko od legacy, a klucze żyją razem z check-in i checkout
- przed startem sezonu robimy test penetracyjny i test unieważniania kluczy; bez nich klucze mobilne nie wchodzą na produkcję, a hotele startują na kartach
- klucz gościa wydajemy przy check-inie i unieważniamy przy checkoucie; zamek dostawcy działa z kluczem zapisanym w telefonie, więc wejście do pokoju nie zależy od tego, czy nasz system działa
- jak telefon gościa jest rozładowany albo zamek nie odpowiada, recepcja daje kartę, karty zostają jako zapas
- w pilocie w maju sprawdzamy klucze mobilne w 2-3 hotelach, zanim wejdą wszędzie
- każdy klucz ma wpisany czas ważności (koniec pobytu albo koniec zadania), więc nawet jak unieważnienie nie dotrze do zamka, klucz sam wygasa
- jak housekeeperowi padnie telefon, bierze kartę serwisową od kierowniczki sprzątania, która jest wydawana i oddawana na zmianę

Skalowanie
- zmiana: skalowalność jest w top 3 jako wzrost liczby hoteli; poniższe progi zostają jako sygnał, kiedy dokładać instancje
- próg 100 rezerwacji na minutę liczymy dla całej platformy w regionie, jako średnią z 15 minut; pilnuje tego dashboard i alert, a odpowiada tech lead
- najgorsza godzina: jak 20% dziennych rezerwacji przyjdzie w jednej godzinie, to ok. 1300 na godzinę, czyli ok. 21 na minutę, dużo poniżej progu
- zysk: prostsza i tańsza infrastruktura i zespół skupiony na terminie
- jak przekroczymy próg, najpierw dokładamy instancje tylko temu serwisowi, który się dławi, co service-based umożliwia, a w tym czasie planujemy dalsze zmiany
- poza sezonem nie skalujemy w dół, bo przy tym ruchu oszczędność jest mała
- drugi region ma swój próg
- ryzyko okresu między przekroczeniem progu a dalszymi zmianami akceptuje dyrektor operacyjny po stronie biznesu

## Nadal otwarte

<!-- Czego wciąż nie wiecie. -->

- jak często legacy może wysyłać i przyjmować pliki i w jakim formacie
- czy biznes zgadza się na preautoryzację u zewnętrznego operatora płatności przy rezerwacji, z rozliczeniem w legacy przy wymeldowaniu
- gdzie są hotele spoza USA i czy dane gości muszą tam zostać
- czy blokowanie pokoi w legacy już dziś działa
- co biznes miał na myśli przez „kupowanie rzeczy dla gości”: życzenia do pokoju czy osobny sklep
- jak duża ma być pula na hotel i kto ją ustala
