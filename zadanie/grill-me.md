# Pytania z grill-me

<!--
Ten plik wypełnia skill grill-me: każda runda pytań dopisuje się na końcu, numeracja pytań jest ciągła.
Nie odpowiadajcie tutaj. Odpowiedzi piszcie w notatki.md, w sekcji "Odpowiedzi na grill-me", z numerem pytania.
-->

## Runda 1 (2026-10-17)

### Pytania do: Room with a View

**Co przeczytałem:** zrzut tablicy `Kata — white.jpg`: pasek aktorów, wiersz Managera i 8 ramek (System, Marketing, Sales/Guest, Check-in, Checkout, zwrot, Housekeeper, usterka). Około 46 zdarzeń, 3 komendy, 0 hotspotów, komentarzy nie widać na zrzucie. Bez legendy, więc przyjmuję standard: żółte = aktorzy, pomarańczowe = zdarzenia, niebieskie = komendy. Najmniejsze karteczki w ramce System czytam z niepewnością.

**Mapa pytań według obszaru tablicy**

| Obszar | Pytania |
|---|---|
| Systemy legacy i nowy, synchronizacja | Q1, Q3, Q23, Q24 |
| Marketing i oferta | Q16, Q22 |
| Rezerwacja i sprzedaż | Q6, Q7, Q15, Q17, Q25 |
| Przed przyjazdem i check-in | Q8, Q9, Q10 |
| Pobyt i usterki | Q2, Q12 |
| Checkout, anulowanie, zwroty | Q13, Q19 |
| Housekeeping | Q4, Q11, Q18 |
| Raporty Managera | Q14 |
| Całość: sezon, skala, tablica | Q5, Q20, Q21 |

---

### Zacznijcie od tych 5

**Q1. Źródło prawdy o zajętości pokoju**
Który system jest źródłem prawdy o tym, że dany pokój jest zajęty w danym dniu? Co się dzieje, gdy po synchronizacji legacy i nowy system pokazują dla tego samego pokoju różny stan?
*Skąd:* ramka System („System legacy zsynchronizowany”, „System modern zsynchronizowany”); zadanie: „leveraging the existing reservations system”

**Q2. Wybrany pokój nie jest gotowy**
Gość wybrał konkretny pokój ze zdjęć, a w dniu przyjazdu ten pokój ma „usterka zgłoszona” albo nie osiągnął „Pokój gotowy dla gościa”. Co mu obiecaliście i kto decyduje, co dalej?
*Skąd:* zadanie, wymaganie 02; ramki usterki i Housekeeper

**Q3. Pre-rezerwacja i jej nadpisanie**
Czym jest „pre-rezerwacja”, kto wydaje „Nadpisz pre-rezerwacje” i co dzieje się z gościem, którego pre-rezerwacja została nadpisana?
*Skąd:* niebieska karteczka w ramce System; to słowo nie pojawia się nigdzie indziej na tablicy

**Q4. Skąd się bierze zlecenie sprzątania**
Które zdarzenie z osi czasu powoduje „Otrzymaliśmy zlecenie sprzątania pokoju”, kto lub co je wysyła i skąd bierze się jego priorytet?
*Skąd:* ramka Housekeeper; zadanie, wymaganie 04: „based on priority and reservation need”

**Q5. Zakres na pierwszy dzień sezonu**
Które zdarzenia z tej tablicy muszą działać w waszym systemie w pierwszym dniu sezonu, a które do tego czasu mogą odbywać się tak jak dziś?
*Skąd:* zadanie: „must be ready quickly or we have to wait until next year!”

---

### A. Czego jeszcze nie zapytaliście

**Q6. Telefon i walk-in**
Kto zakłada rezerwację przy rozmowie telefonicznej i przy walk-in, i gdzie te ścieżki są na osi czasu?
*Skąd:* zadanie, wymaganie 01; Recepcja pojawia się tylko przy checkin, checkout i usterce

**Q7. Rezerwacja bez płatności**
Co się dzieje między „Zarezerwowano pokój” a „Pobyt opłacono”, gdy płatność się nie powiedzie albo nie przyjdzie? Jak długo pokój jest wtedy niedostępny dla innych?
*Skąd:* ramka Sales/Guest

**Q8. Od płatności do przyjazdu**
Jakie zdarzenia zachodzą między opłaceniem pobytu a dniem przyjazdu i kto je wywołuje?
*Skąd:* pusta przestrzeń między ramką Sales/Guest a ramką Check-in

**Q9. No-show i wczesny przyjazd**
Co się dzieje, gdy gość nie przyjedzie albo przyjedzie, zanim pokój osiągnie „Pokój gotowy dla gościa”?
*Skąd:* ramka Check-in

**Q10. Awaria klucza mobilnego**
Co się dzieje, gdy telefon gościa lub housekeepera jest rozładowany, zamek nie odpowiada albo „Klucz mobilny unieważniony” nie dotrze do zamka?
*Skąd:* karteczki z kluczem i zamkiem; zadanie: „smart room locks”

**Q11. Ekran przy wózku**
Co housekeeper widzi na urządzeniu przy wózku, kiedy wybiera następny pokój, i skąd te informacje pochodzą?
*Skąd:* zadanie, wymaganie 04; ramka Housekeeper

**Q12. Usterka a rezerwacje**
Kto może zgłosić usterkę? Co „usterka zgłoszona” zmienia w statusie pokoju i w rezerwacjach, które już na ten pokój czekają?
*Skąd:* ramka usterki (Housekeeper, Guest, Recepcja); zadanie, wymaganie 03

**Q13. Anulowanie i zwrot**
Kiedy na osi czasu można anulować rezerwację? Kto wykonuje zwrot i w którym systemie?
*Skąd:* „Anulowano rezerwację/pobyt” w ramce Checkout, „Zrócono pieniądze” w osobnej ramce

**Q14. Źródło raportów Managera**
Z jakich zdarzeń powstają „Raport finansowy za dokonane płatności” i „estymata przychodów”, skoro płatności obsługuje istniejący system?
*Skąd:* wiersz Managera; zadanie, wymaganie 05

**Q15. Obietnice sprzedawców**
W którym miejscu osi czasu sprzedawca obiecuje gościowi coś, czego system jeszcze nie potwierdził? Co się dzieje, gdy tej obietnicy nie da się spełnić?
*Skąd:* „Zebrano wymagania”, „Zamówione ekstra elementy do pokoju na pobyt”; zadanie: „scramble to make their promises true”

---

### B. Założenia do podważenia

**Q16. Zmiana oferty po rezerwacji**
Co się dzieje z rezerwacją gościa, gdy Marketing po jej złożeniu zmieni zdjęcia, cechy, standard albo cenę pokoju?
*Skąd:* ramka Marketing

**Q17. Płatność zawsze z góry?**
„Pobyt opłacono” jest na tablicy dwa razy. Czy to to samo zdarzenie i skąd wiecie, że gość zawsze płaci przed pobytem?
*Skąd:* ramka Sales/Guest i ramka ze zwrotem

**Q18. „Dostępny” a „gotowy”**
Co znaczy „dostępny” w „Pokój ponownie dostępny”, a co „gotowy” w „Pokój gotowy dla gościa”? Czy to ten sam stan pokoju?
*Skąd:* ramki Checkout i Housekeeper; zadanie, wymaganie 03

**Q19. Nietypowy checkout**
Ramka Housekeeper zaczyna się po wymeldowaniu. Co się dzieje, gdy gość wymelduje się wcześniej, później albo w ogóle nie wykona „Checkout”?
*Skąd:* komenda „Checkout”; „Pokój gotowy do sprzątania”

**Q20. Najgorszy dzień sezonu**
Ile check-outów i check-inów przypada na jeden hotel w najgorszym dniu sezonu i w jakim oknie czasowym? Skąd to wiecie?
*Skąd:* zadanie: „hundreds”, „less than 20”, „Peak season”

**Q21. Brak hotspotów**
Na tablicy nie ma żadnego hotspotu. W których miejscach zespół się nie zgadzał albo nie znał odpowiedzi?
*Skąd:* brak czerwonych karteczek

**Q22. Kto wiąże zamek z pokojem**
„Przydzielono ID zamka” stoi w ramce Marketing. Kto naprawdę wiąże zamek z pokojem i kto zmienia to powiązanie po wymianie zamka?
*Skąd:* ramka Marketing

---

### C. Porównanie wariantów

**Q23. Legacy i modern: warianty czy kroki?**
Czy „System legacy zsynchronizowany” i „System modern zsynchronizowany” to dwa warianty, czy dwa kroki jednego procesu? W którą stronę, jak często i kiedy płyną dane w każdym z nich?
*Skąd:* ramka System

**Q24. Dwa raporty check-in/out**
Jak długo raport legacy („Zaczytano Raport check in / check out legacy”) i nowy („Wystawiono Raport check in / check out”) mają istnieć obok siebie? Co musiałoby się wydarzyć, żebyście zrezygnowali z jednego?
*Skąd:* ramka System

**Q25. Typ pokoju a konkretny pokój**
Gdzie na waszej osi czasu rozchodzą się, a gdzie łączą ścieżki rezerwacji typu pokoju i konkretnego pokoju? Czym różni się w nich „Zdjęto dostępność pokoju”?
*Skąd:* zadanie, wymaganie 02; ramka Sales/Guest

## Runda 2 (2026-10-17)

### Pytania do: Room with a View, decyzje z waszych odpowiedzi

**Co przeczytałem:** `notatki.md` (odpowiedzi biznesu, odpowiedzi na Q1-Q6, charakterystyki; sekcje Decyzje i Nadal otwarte są puste) oraz tablicę z rundy 1. Q7-Q25 są jeszcze bez odpowiedzi, więc ich nie powtarzam.

**Decyzje, przed którymi stoicie (według waszych notatek)**

| Decyzja | Skąd wynika | Pytania |
|---|---|---|
| Gdzie żyją rezerwacje i który system ma ostatnie słowo | Q1, Q3, „External system ma api, temat w toku” | Q26, Q28, Q29, Q41 |
| Zakres na pierwszy dzień sezonu | Q5, „Najważniejszy system do sprzątania” | Q27, Q28 |
| Top 3 charakterystyki | sekcja Charakterystyki (7 pozycji) | Q30, Q31, Q32, Q33 |
| Bounded contexty i core | „wyciągnij bounded contexty ze screena” | Q27, Q34, Q35, Q36 |
| Jak powstaje i kto ustala kolejność sprzątania | Q4, „Przygotowanie pokoju do 15 minut” | Q37, Q38, Q39 |
| Zamiana pokoju przy check-in | Q2, „najdalej od windy” | Q40 |

---

### Zacznijcie od tych 5

**Q26. Nadpisana pre-rezerwacja**
Gdy nowy system nadpisuje pre-rezerwację w legacy i tym samym anuluje tam rezerwację, kto i kiedy dowiaduje się o tym anulowaniu, i który system ma ostatnie słowo, jeśli recepcjonista właśnie przyjmuje tę rezerwację w legacy?
*Skąd:* Q1: „System modern zsynchronizowany”; Q3: „nadpisanie pre-rezerwacji powoduje anulowanie rezerwacji w systemie legacy”

**Q27. Housekeeping a zakres i core**
Biznes mówi „Najważniejszy system do sprzątania”, a wasza lista na pierwszy dzień sezonu wymienia rezerwację, check-in, pobyt i checkout. Gdzie w tym zakresie jest housekeeping i co to mówi o tym, który kontekst jest core?
*Skąd:* odpowiedzi biznesu; Q5

**Q28. Rezerwacja w dniu startu**
Które zdarzenia z ramki Sales/Guest dzieją się w waszym systemie, a które w istniejącym systemie rezerwacji, i co dzieje się w dniu startu, jeśli API istniejącego systemu nie będzie gotowe?
*Skąd:* Q5: „muszą działać wszystkie zdarzenia związane z rezerwacją”; wymaganie 05; „External system ma api, temat w toku”

**Q29. Spójność przy dwóch systemach**
Jak długo po zmianie w jednym systemie drugi może pokazywać stary stan pokoju, zanim powstanie podwójna rezerwacja, i ile takich przypadków w sezonie biznes jest w stanie zaakceptować?
*Skąd:* charakterystyka „data consistency: żeby nie było podwójnych rezerwacji”; ramka System (synchronizacja legacy i modern)

**Q30. Która liczba hoteli i jaki szczyt**
Notatki mówią „107 hotele” i „2500 rezerwacji dziennie na 42 hotele”. Który zbiór hoteli obejmuje pierwszy sezon, ile operacji na minutę daje to w najgorszej godzinie i jak ta liczba przekłada się na „skalowalność” i „deskalowanie”?
*Skąd:* odpowiedzi biznesu; charakterystyka 1

---

### Top 3 charakterystyki

**Q31. Wybór trzech**
Notatki wymieniają siedem charakterystyk w trzech grupach. Które trzy są waszym top 3 i z której z pozostałych świadomie rezygnujecie, gdy będzie kolidować z top 3?
*Skąd:* sekcja Charakterystyki; szablon: „Które 3 są najważniejsze”

**Q32. Termin w charakterystykach**
W którym miejscu waszej listy charakterystyk odbija się zdanie „must be ready quickly or we have to wait until next year” i jak wpływa ono na wybór top 3?
*Skąd:* zadanie, Additional context

**Q33. Prostota dla kogo**
„Simplicity: prosty w obsłudze”: dla gościa, recepcjonisty, managera hotelu czy housekeepera z urządzeniem przy wózku, i czy dla każdego z nich oznacza to to samo?
*Skąd:* Other characteristics 3

---

### Bounded contexty i core

**Q34. Zmiana znaczenia „pokoju”**
W ramce Marketing pokój ma cechy i zdjęcia, w Sales ma dostępność, w Housekeeper jest „gotowy” albo „do sprzątania”. Czy to ten sam „pokój”, a jeśli nie, na której granicy zmienia znaczenie?
*Skąd:* notatka „wyciągnij bounded contexty ze screena”; ramki Marketing, Sales/Guest, Housekeeper

**Q35. Co zmienia się razem**
Gdy biznes zmieni jedną regułę, które ramki z tablicy musiałyby zmienić się razem, a które pozostałyby nietknięte?
*Skąd:* 8 ramek na tablicy

**Q36. Właściciel danych o pokoju**
Kto jest właścicielem danych o pokoju: Marketing (cechy, zdjęcia, „Przydzielono ID zamka”), manager hotelu (ceny) czy dostawca gotowych danych, i kto może je zmienić w trakcie sezonu?
*Skąd:* „Dodawanie zdjęcia, dostajemy to gotowe dane”; „manager hotelu wprowadza” ceny; ramka Marketing

---

### Kolejność sprzątania

**Q37. Za mało rąk w kwadransie**
Co się dzieje, gdy w tym samym kwadransie zwalnia się więcej pokoi z bliskim przyjazdem, niż housekeeperzy zdążą przygotować w „do 15 minut”?
*Skąd:* Q4: „priorytet wyznacza które pokoje będą zarezerwowane w pierwszej kolejności”; „Przygotowanie pokoju do 15 minut”

**Q38. Pani zarządzająca a urządzenie**
Jaką rolę ma osoba, która dziś zarządza sprzątaniem przez wiadomości, gdy pojawią się urządzenia na wózkach, i kto może zmienić kolejność wyznaczoną przez system?
*Skąd:* „Cleaning zatrudniony w hotelu, aktualnie pani zarządzająca przez wiadomości”; wymaganie 04

**Q39. Sprzątanie i usterki w jednej kolejce?**
Czy „usterka zgłoszona” i zlecenie sprzątania po checkout konkurują o tych samych ludzi i ten sam priorytet, i kto rozstrzyga, gdy oba dotyczą pokoju z bliskim przyjazdem?
*Skąd:* Q4; ramka usterki; wymaganie 04 („cleaning and maintenance staff”)

---

### Zamiana pokoju i kanały

**Q40. Zastępczy pokój dla gościa z życzeniem**
Gość wybrał pokój „najdalej od windy”. Skąd manager w momencie check-in wie, który zastępczy pokój spełnia to samo życzenie, i czy gość dowiaduje się o zmianie dopiero przy recepcji?
*Skąd:* Q2: „oferujemy zastępczy pokój, manager hotelu decyduje”; „Wymagania klienta: najdalej od windy”

**Q41. Rezerwacja przez recepcjonistę**
W którym systemie recepcjonista zakłada rezerwację telefoniczną i walk-in, i w jaki sposób taka rezerwacja wpływa na kolejność sprzątania?
*Skąd:* Q6; „Aktualnie telefonicznie, albo przy wejście”; Q4

## Runda 3 (2026-10-17)

### Pytania do: Room with a View, pogłębienie odpowiedzi Q26-Q38

**Co przeczytałem:** wasze odpowiedzi na Q26-Q38 z czatu (w `notatki.md` jeszcze ich nie ma) oraz zaktualizowane charakterystyki w `notatki.md` (top 3: fault tolerance, security, simplicity). Bez odpowiedzi zostają Q27, Q32, Q35, Q38 i Q7-Q25.

| Obszar | Pytania |
|---|---|
| Pula pokoi i synchronizacja raz dziennie | Q42, Q43, Q45, Q46, Q47 |
| Płatności i recepcja | Q48, Q49 |
| Charakterystyki i skala | Q44, Q50, Q51, Q52 |
| Pokój i właściciel danych | Q53, Q54 |
| Priorytet sprzątania | Q55, Q56 |

---

### Zacznijcie od tych 5

**Q42. Pre-rezerwacja a pula**
Skoro legacy nie może bookować pokoi z puli nowego systemu, jaką rezerwację w legacy anuluje „Nadpisz pre-rezerwacje”?
*Skąd:* Q3: „nadpisanie pre-rezerwacji powoduje anulowanie rezerwacji w systemie legacy”; Q26: „Stary system nie może bookować pokoi które przeznaczył na pule nowego systemu”

**Q43. Dzień przed synchronizacją**
Kto w ciągu dnia korzysta z danych legacy o pokojach z puli (recepcja, „Zaczytano Raport check in / check out legacy”, housekeeping) i co widzi do czasu synchronizacji na koniec dnia?
*Skąd:* Q29: „Synchronizacja jest raz dziennie na koniec dnia”; ramka System

**Q44. Awaria nowego systemu w ciągu dnia**
Gdy nowy system jest niedostępny w ciągu dnia, kto przyjmuje rezerwacje i check-iny na pokoje z puli i skąd wie, co zarezerwowano od ostatniej synchronizacji?
*Skąd:* top 3: „fault tolerance”; Q26, Q29

**Q45. Kto ustala pulę**
Kto i jak często ustala, które pokoje trafiają do puli nowego systemu, i co widzi gość, który chce konkretny pokój spoza puli?
*Skąd:* Q26: „System legacy odgórnie blokuje pokoje dla nowego systemu”; „Wymagania klienta: najdalej od windy”

**Q46. Pula przed czerwcem**
Czy odgórna blokada puli działa dziś w legacy, a jeśli nie, kto i do kiedy musi ją przygotować przed startem sezonu?
*Skąd:* Q26; Q5; zadanie: „must be ready quickly”

---

### Pula pokoi i synchronizacja

**Q47. Niewykorzystana pula**
Kiedy pokój z puli, którego nikt nie zarezerwował w nowym systemie, wraca do sprzedaży w legacy, i kto o tym decyduje?
*Skąd:* Q26

### Płatności i recepcja

**Q48. Gdzie gość płaci**
W którym systemie dzieją się „Zarejestrowano płatność” i „Pobyt opłacono”, skoro wszystkie zdarzenia rezerwacji są w waszym systemie, a płatności według zadania obsługuje istniejący system?
*Skąd:* Q28: „Wszystkie dzieją się w naszym systemie”; wymaganie 05; ramka Sales/Guest

**Q49. Recepcjonista i pula**
W którym systemie pracuje recepcjonista i czy może zarezerwować pokój z puli dla gościa przy telefonie lub przy ladzie?
*Skąd:* Q6: „Rezerwację przy rozmowie telefonicznej zakłada recepcjonista”; Q26

### Charakterystyki i skala

**Q50. Co oddajecie poza top 3**
Skalowalność i data consistency są poza top 3. Co konkretnie akceptujecie w sezonie przy około 90% obłożenia, gdy jedna z nich zawiedzie, i kto po stronie biznesu się na to zgadza?
*Skąd:* Q31; charakterystyki explicit 2 i 3; „obłożenie rośnie w okolice 90%”

**Q51. Po czym poznacie prostotę**
Po czym poznacie, że system jest prosty dla housekeepera przy wózku, a po czym, że jest prosty dla gościa wybierającego pokój ze zdjęć?
*Skąd:* Q33: „dla każdego”

**Q52. Skala dla „wszystkich”**
Jeśli pierwszy sezon obejmuje wszystkie 107 hoteli po około 200 pokoi, a „2500 rezerwacji dziennie” dotyczy 42 hoteli, ile rezerwacji i check-outów daje to w najgorszym dniu i najgorszej godzinie?
*Skąd:* Q30: „wszystkie”; odpowiedzi biznesu

### Pokój i właściciel danych

**Q53. Kto zapisuje stan pokoju**
Skoro to ten sam pokój, a jego właścicielem jest Marketing, kto zapisuje „Pokój wysprzątano”, „Zdjęto dostępność pokoju” i „usterka zgłoszona”, i czy Marketing musi o tych zmianach wiedzieć albo je zatwierdzać?
*Skąd:* Q34: „ten sam pokój”; Q36: „marketing”; ramki Housekeeper, Sales/Guest, usterka

**Q54. Właściciel ceny**
Kto jest właścicielem ceny pokoju w nowym systemie: Marketing („Ustalono nowe ceny per typ”) czy manager hotelu?
*Skąd:* Q36: „marketing”; „Ceny są dynamicznie ... manager hotelu wprowadza”; ramka Marketing

### Priorytet sprzątania

**Q55. Zakres housekeepingu**
Czy housekeeping w nowym systemie obejmuje wszystkie pokoje hotelu, czy tylko pokoje z puli, i skąd bierze priorytet dla pokoi zarezerwowanych w legacy w ciągu dnia?
*Skąd:* Q37: „pokoje są sprzątane wg priorytetu”; Q4; Q26, Q29

**Q56. Zmiana priorytetu w trakcie**
Co dzieje się z kolejnością na urządzeniu przy wózku, gdy priorytet zmieni się w trakcie sprzątania, i kto o tej zmianie decyduje?
*Skąd:* Q37; wymaganie 04

## Runda 4 (2026-10-17)

### Pytania do: Room with a View, wybór decyzji i architektury

**Q57. Najdroższa do odwrócenia**
Które z rzeczy, które już ustaliliście w odpowiedziach (pula pokoi blokowana w legacy, synchronizacja raz dziennie, wszystkie zdarzenia rezerwacji w nowym systemie, checkout uruchamia sprzątanie wg priorytetu, Marketing właścicielem danych pokoju, top 3 charakterystyk), byłoby najdroższe do zmiany po starcie sezonu, i co było dla niej odrzuconą alternatywą?
*Skąd:* Q26, Q28, Q29, Q31, Q36, Q37; sekcja Decyzje jest pusta

**Q58. Co działa, gdy coś innego leży**
Które ramki z tablicy muszą dalej działać, gdy inna ramka przestanie działać, i jak to się ma do waszego top 3 (fault tolerance, security, simplicity)?
*Skąd:* Q31; 8 ramek na tablicy

**Q59. Co blokuje wybór architektury**
Których odpowiedzi brakuje wam, żeby wybrać styl architektury, i które z otwartych pytań muszą paść przed tą decyzją?
*Skąd:* sekcja Domena zawiera tylko „wyciągnij bounded contexty ze screena”; w notatkach nie ma jeszcze nic o stylu architektury
