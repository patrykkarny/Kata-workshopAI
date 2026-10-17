# Prezentacja: Room with a View (zespół White)

Ok. 4 minuty. Wszystko poniżej bierzemy z `notatki.md`. Diagramy generujemy z `c4/workspace.dsl` (`./zadanie/c4/render.sh`).

## Jednym zdaniem

Proponujemy **service-based: pięć serwisów domenowych i jedna baza**, bo system musi być na tyle prosty, żeby działał w czerwcu, musi rosnąć razem z siecią hoteli i nie może zatrzymać hotelu, kiedy coś padnie.

## 1. Problem i liczby (ok. 40 s)

- 107 hoteli po ok. 200 pokoi, czyli ok. 21 tys. pokoi; 42 hotele w USA robią 2500 rezerwacji dziennie
- dziś rezerwacje idą głównie przez telefon i przy wejściu, a gość chce sam wybrać konkretny pokój, np. daleko od windy
- sezon startuje na początku czerwca, obłożenie dochodzi do ok. 90%
- dla biznesu najważniejsze jest sprzątanie: pokój ma być gotowy w 15 minut (od „gotowy do sprzątania” do „gotowy dla gościa”)
- policzyliśmy ruch: ok. 6400 rezerwacji dziennie, średnio jedna co 14 sekund; wymeldowania między 10 a 12 to ok. jedno na 2 minuty w hotelu
- wniosek: pojedyncza rezerwacja to mały ruch, ale od pierwszego dnia mamy 107 hoteli naraz i kolejne w drodze, więc skalujemy w poziomie per serwis, bez automatycznego skalowania

## 2. Top 3 charakterystyki (ok. 40 s)

1. **Prostota**: chodzi o prostą architekturę, nie o łatwość obsługi; działa w czerwcu albo czekamy rok, więc mało serwisów, jedna baza, bez egzotycznej technologii
2. **Skalowalność**: wzrost, nie skoki; firma dokłada hotele, a check-iny i checkouty wszędzie wypadają w tych samych godzinach; nowy hotel to konfiguracja, nie kod; sprawdzamy testem obciążenia na 3x najgorszą godzinę
3. **Odporność na awarie**: przy 90% obłożenia hotel nie może stanąć; nic w rezerwacji, check-inie, checkoucie ani sprzątaniu nie czeka na legacy na żywo, a jak padnie serwis rezerwacji, sprzątanie działa dalej

- świadomie odrzuciliśmy elastyczność, czyli automatyczne skalowanie: szczyt sezonu znamy z góry
- integracje są ważne, ale poza top 3: każdą trzymamy w jednym miejscu

## 3. C1: kontekst (ok. 20 s)

![C1](c4/out/png/C1-SystemContext.png)

- trzy grupy ludzi: gość, personel hotelu (recepcja, manager, kierowniczka sprzątania), housekeeping i serwis techniczny
- legacy zostaje systemem cen, rozliczeń i raportów; nie ma API, więc wymieniamy z nim pliki co 15 minut; odgórnie blokuje dla nas pulę pokoi
- przy rezerwacji gość płaci na stronie operatora płatności (preautoryzacja), danych kart nie widzimy
- smart locki są w MVP: klucz mobilny w telefonie gościa i housekeepera

## 4. C2: kontenery (ok. 50 s)

![C2 na slajd](c4/out/png/C2-Slide.png)

Serwisy nazywamy po angielsku, a w nawiasie są ramki z naszej tablicy:

- **Reservations Service** (Rezerwacja + dostępność i status pokoju): jedyne miejsce, które może zająć pokój na noc, bo to musi być jedna transakcja
- **Housekeeping Service** (Housekeeping + Servis tech): to ci sami ludzie, jedna kolejka i ten sam priorytet; do tego API dla urządzeń przy wózkach
- **Stay Service** (Visit + Faraway): początek i koniec tego samego pobytu; tu jest też adapter smart locków, który wydaje i unieważnia klucze mobilne
- **Legacy Sync Service** (Synchronizacja): jedyny serwis, który wymienia pliki z legacy
- **Room Offer Service** (Marketing): zdjęcia, plany pięter i cechy pokoi, tylko do odczytu dla reszty
- wszystkie kanały (web, mobile, telefon, walk-in) idą przez jedno API Reservations Service; recepcjonista rezerwuje tą samą ścieżką co gość
- przerywane strzałki to zmiany statusu pokoju przez kolejkę zdarzeń: check-in, checkout i sprzątanie działają dalej, nawet jak Reservations Service leży
- aplikacja na wózki to aplikacja webowa działająca offline, bo Wi-Fi w hotelu się rwie

## 5. Kluczowe decyzje i ich cena (ok. 60 s)

**Styl: service-based**

- w arkuszu stylów dla naszego top 3 event-driven i mikroserwisy mają po 11 punktów, service-based 10; mówimy to wprost
- mimo to service-based: oba są słabsze w prostocie, a termin to czerwiec; event-driven daje spójność ostateczną tam, gdzie blokada pokoju potrzebuje transakcji; a przy ok. 21 rezerwacjach na minutę w najgorszej godzinie wystarczy dokładać instancje jednemu serwisowi
- modularny monolit i microkernel są tańsze i prostsze, ale jak padnie aplikacja, pada wszystko, a skalować da się tylko całość
- cena: pięć rzeczy do wdrożenia zamiast jednej i wywołania po sieci między serwisami

**Jedna baza PostgreSQL, osobny schemat na serwis**

- prostsze niż baza na serwis, a blokadę pokoju na noc załatwia jedna transakcja w Reservations Service
- serwisy nie czytają cudzych schematów
- cena: baza to wspólny punkt awarii, więc replika w drugiej strefie z przełączeniem w 1-2 minuty i backupy

**Legacy przez pliki, schowane za Legacy Sync Service**

- pliki w obie strony co 15 minut: od legacy pula, ceny i pobyty spoza puli, do legacy nasze rezerwacje, check-iny, checkouty i numer preautoryzacji; raz dziennie pełne porównanie
- płatność przy rezerwacji to preautoryzacja u operatora płatności, a pobyt i zwroty rozlicza legacy przy wymeldowaniu jak dziś
- cena: dane o pokojach spoza puli mogą być spóźnione do 15 minut; dla puli to nie problem, bo sprzedajemy ją tylko my

**Smart locki w MVP, adapter w Stay Service**

- firma inwestuje w zamki otwierane telefonem; klucz w telefonie otwiera zamek, nawet jak nasz system leży, a karty w recepcji zostają jako zapas
- cena: więcej pracy przed czerwcem i obowiązkowe testy bezpieczeństwa w maju

## 6. Ryzyka i otwarte sprawy (ok. 30 s)

- jak często i w jakim formacie legacy wymienia pliki; jak tylko raz dziennie, pula dalej jest bezpieczna
- czy biznes zgadza się na preautoryzację u operatora płatności
- czy blokowanie pokoi w legacy działa już dziś; jak nie, techniczna rezerwacja na pokój
- jak duża ma być pula na hotel i kto ją ustala
- gdzie są hotele spoza USA i czy dane gości muszą tam zostać; na start jeden region USA
- co biznes miał na myśli przez „kupowanie rzeczy dla gości”: życzenia do pokoju czy osobny sklep

## Peer review: pytania i odpowiedzi

**Dlaczego nie event-driven albo mikroserwisy, skoro mają więcej punktów?**
- to jeden punkt różnicy, a oba są słabsze w prostocie, która decyduje, czy zdążymy na czerwiec
- event-driven daje spójność ostateczną, a zajęcie pokoju na noc potrzebuje transakcji
- mikroserwisy skalują się najlepiej, ale przy ok. 21 rezerwacjach na minutę w najgorszej godzinie wystarczy dokładać instancje jednemu serwisowi

**Dlaczego nie modularny monolit albo microkernel?**
- są tańsze i prostsze, ale jak padnie aplikacja, staje rezerwacja, check-in i sprzątanie naraz, a skalować da się tylko całość
- odporność na awarie mamy w top 3, więc płacimy pięcioma wdrożeniami zamiast jednego

**Skoro jedna rezerwacja co 14 sekund, po co skalowalność w top 3?**
- chodzi o wzrost, nie o skoki: 107 hoteli od pierwszego dnia, a firma dokłada kolejne
- check-iny i checkouty we wszystkich hotelach wypadają w tych samych godzinach
- skalujemy w poziomie per serwis, nowy hotel dodajemy konfiguracją; elastyczność odrzuciliśmy, bo szczyt sezonu znamy z góry
- jak przekroczymy ok. 100 rezerwacji na minutę, dokładamy instancje temu serwisowi, który się dławi

**Wspólna baza to punkt awarii?**
- tak, świadomie: replika w drugiej strefie i backupy; każdy serwis ma swój schemat i nie czyta cudzych
- w czasie przełączania (1-2 minuty) web, mobile i telefon dostają „spróbuj za chwilę”, zdjęcia pokoi idą z CDN, a wózki zapisują offline

**Co jak padnie Reservations Service?**
- Stay Service i Housekeeping Service trzymają u siebie kopię tego, czego potrzebują (przyjazdy na dziś, status pokoju, „pokój potrzebny o”), i pracują na ostatnim znanym stanie
- check-in, checkout, „pokój gotowy” i usterki czekają w kolejce zdarzeń i dochodzą, jak Reservations Service wróci
- sprawdzamy to testem: wyłączamy Reservations Service na 30 minut, a check-in, checkout i sprzątanie działają

**Co jak legacy leży?**
- nic u nas nie czeka na legacy na żywo: rezerwacja, płatność, check-in, checkout i sprzątanie działają dalej
- Legacy Sync Service alarmuje, że nie przyszedł plik, a następny plik nadrabia zaległości; ten sam plik wczytany dwa razy nic nie psuje
- wymeldowania z pokoi spoza puli recepcja może w tym czasie wpisać ręcznie

**Jak płatności bez API?**
- gość płaci na stronie zewnętrznego operatora płatności (preautoryzacja), my danych kart nie widzimy; przy rezerwacji telefonicznej recepcja wysyła link SMS-em albo mailem
- numer preautoryzacji idzie do legacy w pliku, a legacy rozlicza pobyt i zwroty przy wymeldowaniu jak dziś
- jak operator odrzuci kartę, gość od razu podaje inną; jak nie zapłaci w 10 minut, pokój wraca do sprzedaży, a do gości VIP dzwoni recepcja

**Czy pliki co 15 minut nie dają podwójnych rezerwacji?**
- nie: pulę sprzedajemy tylko my, legacy jej nie sprzedaje
- o pokoju z puli na daną noc decyduje jedna transakcja w Reservations Service
- spóźnione mogą być tylko dane o pokojach spoza puli, a tych nie sprzedajemy

**Co jak padnie cały nasz system?**
- recepcja ma odświeżaną co kwadrans listę przyjazdów, wyjazdów i statusów (robi ją Stay Service, plik w magazynie plików i mail), robi check-in ręcznie i wprowadza go potem w aplikacji
- klucz zapisany w telefonie dalej otwiera drzwi

**Co jak wózek traci Wi-Fi?**
- aplikacja działa offline i wysyła zmiany, kiedy łączność wraca

**Housekeeping tylko dla pokoi z puli?**
- nie, dla wszystkich pokoi hotelu od pierwszego dnia; dla pokoi spoza puli bierzemy zameldowania i wymeldowania z pliku z legacy co 15 minut

**Wybrany pokój nie jest gotowy albo ma usterkę?**
- jak pokój nie jest gotowy, przy check-inie proponujemy zastępczy, a decyduje manager hotelu
- usterka blokująca zdejmuje pokój ze sprzedaży, a gościom na ten pokój manager wybiera zastępczy

**Gdzie bezpieczeństwo?**
- danych kart nie widzimy, przyjmuje je operator płatności
- klucz gościa działa tylko w czasie pobytu, housekeeper dostaje klucz tylko do przydzielonego pokoju na czas zadania; checkout unieważnia klucz od razu, a każdy klucz i tak sam wygasa
- przed sezonem test penetracyjny i test unieważniania kluczy; bez nich hotele startują na kartach

**Co jak zamek albo telefon nie działa?**
- recepcja daje gościowi kartę jak dziś, karty zostają jako zapas
- housekeeper bierze kartę serwisową od kierowniczki sprzątania

**Co z obietnicami handlowców?**
- zapisujemy je jako życzenia w rezerwacji; system sprawdza, czy się da, a jak nie, daje znać managerowi
