Wklej wszystko poniżej linii `---` do Claude (artifact), Cursora albo v0 i dołącz trzy obrazy z repozytorium Kata-workshopAI, katalog `zadanie/c4/out/png/`: `C2-Slide.png`, `D1-KeyFlow.png`, `D3-LegacyDown.png`.
Gotowy plik zapisz jako `zadanie/prezentacja.html` (obok katalogu `c4/`), żeby względne ścieżki do obrazów działały; w podglądzie artifactu zamiast obrazów pokażą się placeholdery.

---

# Zadanie

Jesteś doświadczonym projektantem prezentacji technicznych i front-end developerem. Zbuduj **interaktywną prezentację w jednym pliku HTML** (HTML + CSS + vanilla JS, bez frameworków i bibliotek; jedyna zależność zewnętrzna to jeden font z Google Fonts). Prezentacja jest dla zespołu **White** (Marek, Patryk, Mariusz, Kamil) na warsztacie Architectural Kata, kata „Room with a View”. Pokazujemy ją na rzutniku innym zespołom i moderatorowi, a potem bronimy w peer review.

## Zasady treści (ważne)

- **Jedyne źródło treści to ten prompt.** Nie dodawaj faktów, liczb, technologii, dostawców (np. konkretnej chmury, kolejki czy operatora płatności) ani funkcji, których tu nie ma. Nie zaokrąglaj i nie przeliczaj liczb.
- Jeśli czegoś brakuje do układu slajdu, zostaw widoczny znacznik `[DO UZUPEŁNIENIA]` zamiast wymyślać.
- **Teksty w cudzysłowach „…” przepisz dosłownie.** Slajdy 3–7 to narracja członka zespołu, jego słowami; nie poprawiaj stylu, nie skracaj i nie dopisuj zdań.
- Język slajdów: **polski**. Terminy architektoniczne zostają po angielsku (service-based, event-driven, fault tolerance, outbox, C4, ADR).
- **Nazwy serwisów zawsze po angielsku i zawsze tak samo**: Reservations Service, Housekeeping Service, Stay Service, Legacy Sync Service, Room Offer Service. Nazwy ramek z Event Stormingu zostają jak na tablicy: Rezerwacja, Housekeeping, Servis tech, Visit, Faraway, Synchronizacja, Marketing.
- **W tekstach slajdów nie używaj pauzy (znak „—”).** Zamiast niej dwukropek, przecinek albo „·”.
- Obrazy, które dostajesz w załączniku, służą ci tylko do zrozumienia diagramów. **Nie osadzaj ich w pliku** (bez base64); ładuj je ze ścieżek względnych podanych niżej.

## Cel wystąpienia

- Czas: **rdzeń maksymalnie 4:00** (plan: 3:55), potem slajdy zapasowe na pytania. Cały slot to ok. 5 minut, moderator może przerwać.
- Struktura: problem → co dostaje hotel (pięć tematów, przy każdym element architektury, który to daje) → top 3 charakterystyki → C2 → styl → decyzje i ich cena → awarie → ryzyka i co dalej. Narracja: kontekst → napięcie → wybór → konsekwencje → wizja. **Zaczynamy od problemu i od tego, co zyskuje hotel, nie od technologii.**
- Sala głosuje 👍 / 😐 / 👎. 👍 dostaje zespół, który ma odpowiedzi na oczywiste pytania, wiarygodną technologię i nie zostawia niejasności. Dlatego pokazujemy jawne założenia, uczciwe trade-offy (także to, co przegrało i dlaczego) i co się dzieje przy awarii oraz przy wzroście.
- Diagramy zamiast ścian tekstu. Na slajdzie jest to, co trzeba zobaczyć; resztę mówimy (notatki prelegenta).

## Styl wizualny

- Minimalistyczny, czysty, dużo powietrza, czytelny z końca sali przy słabym rzutniku. Bez gradientów, cieni, ikon dekoracyjnych i zdjęć stockowych.
- Scena 1920×1080 px. Tytuł min. **44 px** (zalecane 56 px, waga 600), tekst min. **26 px** (zalecane 30 px), liczby-bohaterowie 120–160 px (waga 700). Elementy interfejsu (numer slajdu, mówca, podpowiedzi) mogą mieć 18–20 px, treść nigdy.
- **Jedna myśl na slajd, maks. 5 linijek albo 5 elementów treści.** Tytuł slajdu to zdanie z tezą, nie etykieta.
- Paleta (tryb jasny):
  - tło złamana biel `#FAFAF7`, powierzchnie kart `#FFFFFF`, linie `#D8DEE4`;
  - tekst grafit `#1F2328`, tekst pomocniczy `#57606A`;
  - jeden akcent: granat `#1F3A5F` (wybory, nasze decyzje, wyróżnienia, pasek „Jak to robimy”);
  - jeden kolor kosztów i ryzyk: stonowany pomarańcz `#C2410C` (tylko „Cena”, „Otwarte”, ryzyka, ostrzeżenia czasu).
- Tryb ciemny (klawisz `D`): tło `#121417`, karty `#1B1F24`, tekst `#E8E6E1`, pomocniczy `#A8B0B8`, akcent `#9DB9E0`, pomarańcz `#F08A4B`. Diagramy PNG zawsze leżą na jasnej karcie `#FFFFFF` z wewnętrznym marginesem, także w trybie ciemnym.
- Font: **Inter** (400, 600, 700) z Google Fonts, fallback `system-ui, -apple-system, "Segoe UI", sans-serif`. Liczby `font-variant-numeric: tabular-nums`.
- Kolor nigdy nie jest jedynym sygnałem: koszt ma etykietę „Cena”, ryzyko etykietę „Otwarte” albo znak „!”, wyróżniony wiersz ma też obramowanie i podpis.
- Mały pasek sekcji w lewym górnym rogu (breadcrumbs): **Problem · Co dostaje hotel · Architektura · Decyzje · Co dalej**, aktywna sekcja w akcencie. Pomaga, gdy moderator przerwie.

## Interakcje

- **Nawigacja**: `→`, `↓`, `Spacja`, `PageDown` dalej; `←`, `↑`, `PageUp` wstecz; `Home` / `End` pierwszy i ostatni slajd rdzenia; kliknięcie w prawą / lewą połowę sceny (poza obrazami i przyciskami); swipe na dotyku (próg ok. 50 px).
- **Build-outs (fragmenty)**: elementy oznaczone niżej jako kroki pojawiają się kolejno przy „dalej”. „Wstecz” chowa ostatni krok. Po powrocie na poprzedni slajd jest on pokazany w pełni zbudowany.
- **Notatki prelegenta** (`S`): otwiera drugie okno (ten sam plik z hashem `#speaker`) z: notatkami bieżącego slajdu (min. 28 px), pod kreską blokiem „Na pytanie / dla CTO” (pole `notesExtra`, jeśli jest), przy slajdach do skrócenia etykietą „można skrócić” i wersją krótką (pole `notesShort`), tytułem następnego slajdu, numerem kroku (np. „krok 2/4”), mówcą bieżącego i następnego slajdu („Za chwilę: [Mówca]”), dużym zegarem, planowanym czasem końca bieżącego slajdu i różnicą względem planu („+0:12 za planem” na pomarańczowo, „−0:05 przed planem”). Okna synchronizują się przez `BroadcastChannel` (fallback: `postMessage` przez `window.opener`); nawigacja działa z obu okien. Jeśli przeglądarka zablokuje okno, `S` pokazuje panel notatek na dole tej samej strony.
- **Zegar i pasek czasu**: cienki pasek (6 px) na dole sceny rośnie od 0:00 do 4:00. Kolor: akcent do 3:30, **pomarańczowy po 3:30**, **czerwony `#B91C1C` po 4:00**. Zegar startuje przy pierwszym przejściu dalej ze slajdu 1 albo klawiszem `T`; `R` zeruje. Obok, małym tekstem: numer slajdu „7 / 13”.
- **Mówca**: w prawym górnym rogu każdego slajdu rdzenia małe imię prowadzącego. Na razie wszędzie wartość `[Mówca]`; zespół uzupełni (Marek, Patryk, Mariusz, Kamil).
- **Slajdy zapasowe** (`Q`): siatka pytań z peer review w czterech kolumnach-grupach. Nawigacja strzałkami, `Enter` albo kliknięcie otwiera slajd z odpowiedzią. Na slajdzie zapasowym: `Q` wraca do siatki, **`Esc` wraca dokładnie do slajdu rdzenia i kroku, z którego przyszliśmy**. Slajdy zapasowe nie występują w zwykłym przejściu.
- **Przegląd** (`O`): siatka miniatur wszystkich slajdów rdzenia (numer, tytuł, sekcja), bieżący wyróżniony; strzałki, `Enter`, `Esc` / `O` zamyka.
- **Tryb ciemny** (`D`): przełącznik; wybór zapamiętany w `localStorage` (dostęp w `try/catch`, prezentacja działa bez niego).
- **Czarny ekran** (`B`): zasłania scenę, żeby sala patrzyła na mówcę; ponowne `B` albo dowolna nawigacja wraca.
- **Pomoc** (`?`): nakładka ze ściągą skrótów.
- **Hash w URL**: `#7` to slajd rdzenia 7, `#q5` to pytanie zapasowe 5; odświeżenie strony wraca w to samo miejsce.
- **Lightbox**: kliknięcie w diagram otwiera go na pełnym ekranie; kółko myszy albo `+` / `-` przybliża, przeciąganie przesuwa, `0` dopasowuje, `Esc` zamyka. Gdy lightbox albo nakładka jest otwarta, strzałki nie zmieniają slajdu.
- Animacje tylko jako przejście opacity/transform **≤ 200 ms**; przy `prefers-reduced-motion: reduce` bez animacji.

## Obrazy

Ścieżki względne (plik HTML leży w `zadanie/`):

- `c4/out/png/C2-Slide.png` (prawie kwadratowy, ok. 1568×1536)
- `c4/out/png/D1-KeyFlow.png` (prawie kwadratowy, ok. 1568×1514)
- `c4/out/png/D3-LegacyDown.png` (poziomy, ok. 1568×1308)

Każdy obraz: `object-fit: contain` na jasnej karcie, opisowy `alt`, mała podpowiedź „kliknij, aby powiększyć”. Jeśli obraz się nie wczyta (`onerror`), pokaż elegancki placeholder w tym samym miejscu i rozmiarze: przerywana ramka, nazwa diagramu (np. „C2: kontenery”) i ścieżka pliku. Nie rysuj nakładek ani podświetleń na współrzędnych obrazu; wyróżnienia robimy w kolumnie obok obrazu.

## Slajdy rdzenia: plan czasu

| # | Slajd | Sekcja | Czas | Koniec |
|---|---|---|---|---|
| 1 | Tytuł i odpowiedź jednym zdaniem | Problem | 0:10 | 0:10 |
| 2 | Czerwiec albo za rok | Problem | 0:20 | 0:30 |
| 3 | 01 · Dostępność | Co dostaje hotel | 0:20 | 0:50 |
| 4 | 02 · Wizualizacja oferty | Co dostaje hotel | 0:15 | 1:05 |
| 5 | 03 · Status pokoju | Co dostaje hotel | 0:20 | 1:25 |
| 6 | 04 · Housekeeping | Co dostaje hotel | 0:20 | 1:45 |
| 7 | 05 · Spójne dane | Co dostaje hotel | 0:20 | 2:05 |
| 8 | Top 3 charakterystyki | Architektura | 0:15 | 2:20 |
| 9 | C2: pięć serwisów | Architektura | 0:25 | 2:45 |
| 10 | Dlaczego service-based | Architektura | 0:15 | 3:00 |
| 11 | Cztery decyzje i ich cena | Decyzje | 0:20 | 3:20 |
| 12 | Coś padnie, hotel działa | Decyzje | 0:20 | 3:40 |
| 13 | Czego nie wiemy, co dalej, pytania | Co dalej | 0:15 | 3:55 |

Slajdy 2, 4 i 10 są „akordeonowe”: jeśli jesteśmy za planem, mówca skraca je do jednego zdania (pole `notesShort`). Oznacz je w oknie notatek etykietą „można skrócić”.

## Slajdy rdzenia: treść

### 1. Tytuł
- Tytuł (duży): **Room with a View**
- Podtytuł: „Zespół White · Marek, Patryk, Mariusz, Kamil”
- Odpowiedź jednym zdaniem (akcent, 34–40 px): „Pięć serwisów i jedna baza: prosto, żeby zdążyć na czerwiec, rośnie razem z siecią, a hotel działa, nawet gdy coś padnie.”
- Notatki: „Jesteśmy zespołem White. W jednym zdaniu: pięć serwisów i jedna baza. Prosto, rośnie razem z siecią i działa, nawet gdy coś padnie.”

### 2. Czerwiec albo za rok
- Tytuł: „Czerwiec albo za rok”
- Cztery duże liczby w kafelkach, pojawiają się kolejno (4 kroki):
  - **107** hoteli
  - **ok. 21 tys.** pokoi
  - **do 90%** obłożenia w sezonie od czerwca
  - **15 min** na przygotowanie pokoju
- Linijka pod kafelkami (krok 5): „Zapytaliśmy biznes: legacy nie ma API, najważniejsze jest sprzątanie, smart locki wchodzą do MVP.”
- Notatki: „Sieć ma 107 hoteli i około 21 tysięcy pokoi. Sezon startuje w czerwcu, obłożenie dochodzi do 90%, a pokój ma być gotowy w 15 minut. Albo zdążymy, albo czekamy rok. Zapytaliśmy biznes: legacy nie ma API, najważniejsze jest sprzątanie, a smart locki wchodzą do MVP.”
- Wersja krótka: „107 hoteli, 21 tysięcy pokoi, sezon od czerwca: albo zdążymy, albo czekamy rok.”

### Slajdy 3–7: wspólny układ `theme`

Pięć slajdów w tym samym układzie, jeden temat na slajd:

- U góry mała etykieta tematu w akcencie (min. 26 px), np. „01 · Dostępność”.
- Tytuł: pierwsze zdanie narracji (56 px, maks. 2 linijki).
- Pod tytułem 2–3 krótkie linijki (30 px, grafit), widoczne od razu.
- Na dole pasek **„Jak to robimy:”** (krok 1): biała karta z granatową krawędzią z lewej, etykieta „Jak to robimy:” pogrubiona w akcencie, dalej jedna albo dwie linijki tekstu (min. 26 px); nazwy serwisów pogrubione. To most między tym, co hotel zyskuje, a architekturą.
- Linie „Dla CTO” i doprecyzowania nie trafiają na slajd; są w polu `notesExtra` (okno notatek, blok „Na pytanie / dla CTO”).

### 3. 01 · Dostępność
- Etykieta: „01 · Dostępność”
- Tytuł: „Wasz hotel nigdy nie zamyka recepcji. System też nie może.”
- Linijki:
  1. „Gość rezerwuje wtedy, kiedy ma ochotę: o 2 w nocy z telefonu, z lotniska, przez telefon albo stojąc przy ladzie.”
  2. „Za każdym razem trafia do tego samego systemu i widzi te same pokoje.”
  3. „Web, aplikacja mobilna, telefon i walk-in to jedna rezerwacja i jedna prawda o dostępności.”
- Jak to robimy (krok 1): „wszystkie kanały idą przez jedno API w **Reservations Service**. Gdy legacy albo jeden serwis leży, hotel pracuje dalej (fault tolerance).”
- Notatki: „Wasz hotel nigdy nie zamyka recepcji. System też nie może. Gość rezerwuje, kiedy ma ochotę: o 2 w nocy z telefonu, z lotniska albo stojąc przy ladzie, i zawsze widzi te same pokoje. W szczycie sezonu minuta przestoju oznacza apartament, który zarezerwuje się u konkurencji. Dlatego wszystkie kanały idą przez jedno API, a awaria jednego elementu nie zatrzymuje hotelu.”
- Na pytanie / dla CTO:
  - „Dla CTO: system hostowany przez Was, gotowy na sezon: 107 hoteli od pierwszego dnia, test obciążenia na 3x najgorszą godzinę. Awaria jednego elementu nie zatrzymuje hotelu.”
  - „Nie mówimy »bez pojedynczego punktu awarii«: wspólna baza nim jest, świadomie. Łapie ją replika w drugiej strefie z przełączeniem w 1-2 min (ADR-004).”
  - „»Jedna prawda o dostępności« dotyczy puli pokoi, którą legacy blokuje dla nas i której nie sprzedaje. Pokoje spoza puli zostają w legacy, ich dane dochodzą w plikach co 15 min (ADR-002, ADR-003).”

### 4. 02 · Wizualizacja oferty
- Etykieta: „02 · Wizualizacja oferty”
- Tytuł: „Zainwestowaliście fortunę w każdy pokój. Pozwólcie gościom to zobaczyć.”
- Linijki:
  1. „Nikt nie płaci za »deluxe«. Gość płaci za ten pokój: z tarasem, widokiem na zatokę i wanną przy oknie.”
  2. „Każdy pokój ma własną stronę ze zdjęciami i położeniem na planie piętra; widok 3D, jeśli hotel go dostarczy.”
  3. „Każda inwestycja we wnętrza wreszcie pracuje na sprzedaż.”
- Jak to robimy (krok 1): „**Room Offer Service** pokazuje zdjęcia, plany pięter i cechy pokoi; tylko do odczytu, zdjęcia z CDN.”
- Notatki: „Zainwestowaliście fortunę w każdy pokój. Pozwólcie gościom to zobaczyć. Gość widzi zdjęcia swojego pokoju i jego miejsce na planie piętra. A gość, który wybrał swój pokój, nie porównuje cen. On już tam jest.”
- Wersja krótka: „Gość wybiera konkretny pokój ze zdjęć i planu piętra.”
- Na pytanie / dla CTO:
  - „Na start zdjęcia i położenie na planie piętra; zdjęcia i opisy dostajemy gotowe. Widok 3D pokazujemy tylko, jeśli hotel go dostarczy (FR-20).”
  - „Gość może też wybrać tylko typ pokoju; wtedy pokój przydzielamy dzień przed przyjazdem (FR-01, FR-02).”

### 5. 03 · Status pokoju
- Etykieta: „03 · Status pokoju”
- Tytuł: „Na reputację pracujecie latami. Wystarczy jeden zapomniany szczegół, żeby ją stracić.”
- Linijki:
  1. „Zawsze wiecie, czy pokój jest zarezerwowany, wolny, do sprzątania czy w serwisie, i kiedy będzie potrzebny następnym razem.”
  2. „Każde życzenie gościa jest przypięte do rezerwacji, a nie do karteczki na recepcji.”
  3. „Wiecie też, że przed przyjazdem Céline Dion trzeba rozłożyć perski dywan z koziej sierści. I wiecie to na czas.”
- Jak to robimy (krok 1): „**Reservations Service** to jedyne źródło prawdy o pokoju na noc i jego statusie. Życzenia gościa są w rezerwacji, housekeeper widzi je na liście zadań.”
- Notatki: „Na reputację pracujecie latami. Wystarczy jeden zapomniany szczegół, żeby ją stracić. W luksusie gość nie wybacza drobiazgów, a te błędy biorą się z jednego miejsca: nikt nie wie, co dzieje się z pokojem teraz. U nas wiecie, w jakim jest stanie i kiedy będzie potrzebny. Wiecie też, że przed przyjazdem Céline Dion trzeba rozłożyć perski dywan z koziej sierści. I wiecie to na czas.”
- Na pytanie / dla CTO:
  - „Życzenia (także obietnice handlowców) zapisujemy w rezerwacji; system sprawdza, czy da się je spełnić, a jak nie, daje znać managerowi hotelu. Housekeeper widzi je przy pokoju na liście zadań (FR-09, FR-13).”
  - „Gdy Reservations Service leży, recepcja i wózki pracują na ostatnim znanym statusie, a zmiany czekają w kolejce (ADR-005).”

### 6. 04 · Housekeeping
- Etykieta: „04 · Housekeeping”
- Tytuł: „Sprzątanie na poziomie, za który gość zapłacił.”
- Linijki:
  1. „Ekipy dostają zadania na urządzenia przy wózkach, ułożone według priorytetu: najpierw pokój, do którego gość przyjeżdża za godzinę.”
  2. „Każdy pokój ma checklistę, której nie da się »odhaczyć na pamięć«.”
  3. „Wyrywkowe zdjęcia po sprzątaniu pozwalają kontrolować jakość bez stania nad nikim.”
- Jak to robimy (krok 1): „**Housekeeping Service** i aplikacja na wózki działająca offline. Priorytet liczymy z tego, kiedy pokój jest znowu potrzebny; checklista i wyrywkowe zdjęcia na urządzeniu.”
- Notatki: „Sprzątanie na poziomie, za który gość zapłacił. Pięć gwiazdek to nie standard, tylko obietnica składana przy każdym pokoju, a system pilnuje, żeby była dotrzymana. Najpierw pokój, do którego gość przyjeżdża za godzinę. Checklisty nie da się odhaczyć na pamięć, a wyrywkowe zdjęcia pozwalają kontrolować jakość bez stania nad nikim.”
- Na pytanie / dla CTO:
  - „Zadania nie da się zamknąć bez przejścia checklisty. Zdjęcia trafiają do magazynu plików; offline zdjęcie czeka w kolejce na urządzeniu.”
  - „Offline działają lista zadań, zmiana statusu pokoju i zgłoszenie usterki. 15 minut na pokój liczymy z czasu na urządzeniu. Housekeeping obejmuje wszystkie pokoje hotelu (ADR-006, FR-12, FR-17, FR-23).”

### 7. 05 · Spójne dane
- Etykieta: „05 · Spójne dane”
- Tytuł: „Jedna obietnica, jedna prawda, w każdym systemie.”
- Linijki:
  1. „Najgorszy moment w hotelu to gość z potwierdzoną rezerwacją, dla którego nie ma pokoju.”
  2. „Pokój obiecany przez handlowca, sprzedany online i przygotowany przez housekeeping to zawsze ten sam pokój.”
  3. „Rozliczenie pobytu i dane gości trafiają do Waszego systemu; kartę przyjmuje operator płatności, my jej nie widzimy.”
- Jak to robimy (krok 1): „pulę pokoi sprzedajemy tylko my. **Legacy Sync Service** wymienia pliki w obie strony co 15 min, raz dziennie pełne porównanie. Płatność: preautoryzacja u operatora płatności.”
- Notatki: „Jedna obietnica, jedna prawda, w każdym systemie. Najgorszy moment w hotelu to gość z potwierdzoną rezerwacją, dla którego nie ma pokoju. Najczęściej winne są dwa systemy, z których każdy mówi co innego. Nowy system współpracuje z Waszym obecnym systemem rezerwacji, a pokój obiecany, sprzedany i przygotowany to zawsze ten sam pokój.”
- Na pytanie / dla CTO:
  - „Dla CTO: integrujemy, a nie przepisujemy. Mniej ryzyka i szybciej na produkcji, a to ma znaczenie przed sezonem.”
  - „»Zawsze ten sam pokój« gwarantuje pula: legacy blokuje ją dla nas i jej nie sprzedaje, o pokoju z puli decyduje tylko Reservations Service. Dane pokoi spoza puli mogą być spóźnione do 15 min; przy porównaniu dla puli wygrywamy my, spoza puli legacy (ADR-002, ADR-003).”
  - „Do legacy idą w pliku nasze rezerwacje z danymi gościa, check-iny, checkouty i numer preautoryzacji; legacy rozlicza pobyt przy wymeldowaniu i robi zwroty (ADR-003).”

### 8. Top 3 charakterystyki
- Tytuł: „Trzy charakterystyki prowadzą architekturę”
- Trzy kolumny, każda to krok; w każdej nazwa (akcent), „Dlaczego” i „Jak mierzymy”:
  1. **Prostota** · Dlaczego: działa w czerwcu albo czekamy rok; buduje to normalny zespół. · Mierzymy: MVP działa w hotelach pilotażowych przed sezonem.
  2. **Skalowalność: wzrost, nie skoki** · Dlaczego: 107 hoteli od pierwszego dnia, firma dokłada kolejne. · Mierzymy: test obciążenia na 3x najgorszą godzinę; nowy hotel bez zmiany kodu.
  3. **Odporność na awarie** · Dlaczego: przy 90% obłożenia hotel nie może stanąć; nic nie czeka na legacy na żywo. · Mierzymy: wyłączamy Reservations Service na 30 min, a check-in, checkout i sprzątanie działają.
- Pasek na dole (krok 4): „Świadomie odrzucone: elastyczność (automatyczne skalowanie w górę i w dół), bo szczyt sezonu znamy z góry.”
- Notatki: „Stąd trzy charakterystyki. Prostota, bo termin. Skalowalność jako wzrost liczby hoteli, a nie skoki, więc elastyczność świadomie odrzucamy. Odporność na awarie, bo w sezonie hotel nie może stanąć. Każdą umiemy zmierzyć.”

### 9. C2: pięć serwisów
- Tytuł: „C2: pięć serwisów, jedna baza”
- Podtytuł (jedna linijka, tekst pomocniczy): „TypeScript (NestJS, React) · PostgreSQL · statusy pokoju przez kolejkę zdarzeń, reszta przez HTTPS”
- Lewa strona: obraz `C2-Slide.png` na pełną wysokość obszaru treści.
- Prawa strona: pięć kart serwisów. Kroki 1–5 kolejno wyróżniają jedną kartę (pełne krycie + granatowa krawędź z lewej), pozostałe są przygaszone (ok. 40%); po ostatnim kroku wszystkie są pełne. Każda karta: nazwa serwisu, pod nią ramka z tablicy i numery tematów ze slajdów 3–7, potem jedna linijka:
  1. **Reservations Service** (ramka Rezerwacja · tematy 01, 03, 05): jedyne miejsce, które zajmuje pokój na noc, jedną transakcją.
  2. **Housekeeping Service** (Housekeeping + Servis tech · temat 04): sprzątanie i usterki w jednej kolejce; aplikacja na wózki działa offline.
  3. **Stay Service** (Visit + Faraway): check-in, checkout i klucze mobilne.
  4. **Legacy Sync Service** (Synchronizacja · temat 05): jedyny, który wymienia pliki z legacy.
  5. **Room Offer Service** (Marketing · temat 02): zdjęcia, plany pięter i cechy pokoi; tylko do odczytu.
- Notatki: „W środku pięć serwisów, każdy to jedna albo dwie ramki z naszego Event Stormingu. Reservations Service jako jedyny zajmuje pokój na noc. Housekeeping Service ma sprzątanie i usterki w jednej kolejce, Stay Service check-in, checkout i klucze, Legacy Sync Service jako jedyny rozmawia z legacy, a Room Offer Service pokazuje zdjęcia i plany pięter.”

### 10. Dlaczego service-based
- Tytuł: „Service-based: 10 punktów, nie 11. Świadomie.”
- Lewa strona: tabela ocen z arkusza V2.0 (skala 1–5) dla naszego top 3. Oceny jako gwiazdki (np. ★★★☆☆) **i** cyfra obok:

  | Styl | Prostota | Skalowalność | Odporność na awarie | Suma |
  |---|---|---|---|---|
  | Event-driven | 2 | 4 | 5 | 11 |
  | Mikroserwisy | 1 | 5 | 5 | 11 |
  | Service-based | 3 | 3 | 4 | 10 |
  | Space-based | 1 | 5 | 3 | 9 |
  | Warstwowy | 5 | 1 | 1 | 7 |
  | Modularny monolit | 5 | 1 | 1 | 7 |
  | Service-oriented | 1 | 3 | 3 | 7 |
  | Microkernel | 4 | 1 | 1 | 6 |

- Kroki: (1) wiersze Event-driven i Mikroserwisy dostają pomarańczowy obrys i etykietę „więcej punktów”, a wiersz Service-based jest wypełniony granatem z białym tekstem i etykietą „nasz wybór”; (2) po prawej trzy powody, pojawiają się razem:
  - Prostota 3, a nie 2 albo 1: termin to czerwiec.
  - Blokada pokoju na noc to jedna transakcja, nie spójność ostateczna.
  - Przy ok. 21 rezerwacjach na minutę wystarczy dokładać instancje jednemu serwisowi.
- Notatki: „Uczciwie: w arkuszu event-driven i mikroserwisy mają o punkt więcej. Wybraliśmy service-based, bo jest prostszy przy terminie w czerwcu, blokada pokoju to jedna transakcja, a przy naszym ruchu wystarczy dokładać instancje jednemu serwisowi.”
- Wersja krótka: „Event-driven i mikroserwisy mają punkt więcej; wygrała prostota przy terminie w czerwcu.”

### 11. Cztery decyzje i ich cena
- Tytuł: „Cztery decyzje i ich cena”
- Siatka 2×2 kart, każda to krok. Karta: w prawym górnym rogu etykieta ADR, potem „Wybraliśmy” (akcent, pogrubione), „zamiast …” (tekst pomocniczy), „Cena: …” (pomarańcz, z etykietą „Cena”):
  1. **ADR-004** · Wybraliśmy: jedna baza PostgreSQL, osobny schemat na serwis · zamiast bazy na serwis · Cena: wspólny punkt awarii, więc replika w drugiej strefie i przełączenie w 1-2 min.
  2. **ADR-003** · Wybraliśmy: pliki z legacy w obie strony co 15 min · zamiast API, którego nie ma · Cena: dane pokoi spoza puli spóźnione do 15 min.
  3. **ADR-005** · Wybraliśmy: zmiany statusu pokoju przez kolejkę zdarzeń z outboxem · zamiast wywołań HTTPS · Cena: gdy Reservations Service leży, recepcja widzi ostatni znany status.
  4. **ADR-007** · Wybraliśmy: smart locki w MVP, adapter w Stay Service · zamiast startu po sezonie · Cena: test penetracyjny i test unieważniania kluczy w maju; bez nich start na kartach.
- Notatki: „Cztery decyzje i ich cena. Jedna baza, płacimy wspólnym punktem awarii, więc replika. Pliki co 15 minut, płacimy opóźnieniem dla pokoi spoza puli. Statusy pokoju przez kolejkę, żeby sprzątanie działało, gdy rezerwacje leżą. Smart locki w MVP, płacimy testami bezpieczeństwa w maju.”

### 12. Coś padnie, hotel działa
- Tytuł: „Coś padnie. Hotel działa dalej.”
- Lewa strona: cztery wiersze „Co pada” (pogrubione) → „Co się dzieje”; każdy wiersz to krok:
  1. **Legacy albo plik z legacy** → alert; rezerwacja, płatność, checkout i sprzątanie działają; następny plik nadrabia.
  2. **Reservations Service** → Stay i Housekeeping pracują na swojej kopii; zdarzenia czekają w kolejce.
  3. **Baza (przełączenie 1-2 min)** → kanały: „spróbuj za chwilę”; zdjęcia z CDN; wózki zapisują offline.
  4. **Cały system** → recepcja ma listę awaryjną co 15 min (plik i mail); klucz w telefonie dalej otwiera drzwi.
- Prawa strona: miniatura `D3-LegacyDown.png` z podpisem „D3: legacy leży albo nie przyszedł plik”, klikalna (lightbox).
- Notatki: „Co, jak coś padnie? Legacy leży: alert, a hotel pracuje dalej. Reservations Service leży: pobyt i sprzątanie działają na ostatnim znanym stanie. Baza się przełącza: do dwóch minut, wózki zapisują offline. Leży wszystko: recepcja ma listę awaryjną, a klucz w telefonie dalej otwiera drzwi.”

### 13. Czego nie wiemy, co dalej, pytania
- Tytuł: „Czego jeszcze nie wiemy i co dalej”
- Lewa strona (krok 1): trzy wiersze, każdy z etykietą na początku: „Założenie” (granatowa) albo „Otwarte” (pomarańczowa, ze znakiem „!”); wiersze pojawiają się razem:
  1. **Założenie**: pliki z legacy co 15 min. Jak raz dziennie: pula dalej bezpieczna, wymeldowania spoza puli wpisuje recepcja.
  2. **Założenie**: legacy umie dziś blokować pokoje. Jak nie: jedna długa techniczna rezerwacja na każdy pokój z puli.
  3. **Otwarte**: zgoda biznesu na preautoryzację u operatora płatności; wielkość puli na hotel i kto ją ustala.
- Prawa strona (krok 2): pionowa oś czasu z dwoma etapami:
  1. **Maj, przed sezonem**: pilot w 2-3 hotelach; test obciążenia, testy kluczy mobilnych, ćwiczenie przełączenia bazy.
  2. **Czerwiec**: wszystkie hotele.
- Na dole, wyśrodkowane (krok 3, akcent, duże): „Pytania?”
- Notatki: „Mówimy wprost, czego nie wiemy: jak często i w jakim formacie legacy wymienia pliki, czy umie blokować pokoje i czy biznes zgodzi się na preautoryzację. Na każde założenie mamy plan B. W maju pilot w 2-3 hotelach z testami, w czerwcu wszystkie hotele. Prosto, rośnie razem z siecią i działa, nawet gdy coś padnie. Dziękujemy, czekamy na pytania.”
- Na pytanie / dla CTO:
  - „Założenie: na start jeden region (USA). Otwarte: gdzie są hotele spoza USA i czy dane gości muszą tam zostać.”
  - „Potem: nowy hotel to konfiguracja; powyżej 100 rezerwacji na minutę instancje dla serwisu, który się dławi; drugi region to ten sam zestaw serwisów.”

## Slajdy zapasowe (klawisz `Q`)

Układ slajdu: pytanie jako tytuł (maks. 2 linijki), 2–3 krótkie punkty odpowiedzi, etykiety źródeł (np. „ADR-001”) na dole; przy q8 i q12 miniatura diagramu po prawej (lightbox). Na dole małym tekstem: „Esc: wróć do prezentacji · Q: lista pytań”. W siatce kafelek pokazuje skrócone pytanie i numer.

**Styl i skala**

- **q1. Dlaczego nie event-driven, skoro ma 11 punktów?**
  - Prostota 2 przy terminie w czerwcu: za dużo ruchomych części.
  - Daje spójność ostateczną tam, gdzie blokada pokoju na noc potrzebuje jednej transakcji.
  - Kolejkę mamy, ale tylko do zmian statusu pokoju, nie jako styl całego systemu.
  - Źródła: ADR-001, ADR-005
- **q2. Dlaczego nie mikroserwisy, skoro też mają 11?**
  - Prostota 1: za dużo ruchomych części jak na czerwiec.
  - Najgorsza godzina to ok. 21 rezerwacji na minutę; próg do dokładania instancji to 100.
  - Dokładanie instancji jednemu serwisowi wystarcza zamiast drobniejszego podziału.
  - Źródła: ADR-001, ADR-008
- **q3. Dlaczego nie modularny monolit, warstwy albo microkernel?**
  - Są prostsze i tańsze (prostota 5 i 4).
  - Ale skalowalność i odporność na awarie mają po 1: jak padnie aplikacja, pada wszystko.
  - Odporność na awarie mamy w top 3: rezerwacje, check-in i sprzątanie nie mogą paść razem.
  - Źródła: ADR-001
- **q4. Jedna rezerwacja co 14 s. Po co skalowalność w top 3?**
  - Chodzi o wzrost, nie o skoki: 107 hoteli i ok. 21 tys. pokoi od pierwszego dnia, firma dokłada kolejne.
  - Check-iny i checkouty we wszystkich hotelach wypadają w tych samych godzinach.
  - Nowy hotel to konfiguracja; próg 100 rezerwacji na minutę (średnia z 15 min) pilnuje dashboard i alert, odpowiada tech lead.
  - Źródła: ADR-008

**Awarie**

- **q5. Czy naprawdę nie ma pojedynczego punktu awarii?**
  - Jest jeden, świadomie: wspólna baza. Łapie ją replika w drugiej strefie z automatycznym przełączeniem w 1-2 min (szczegóły: q6).
  - Każdy serwis chodzi na min. dwóch instancjach i wdrażamy po kolei; błąd, wdrożenie albo przeciążenie jednego serwisu nie kładzie pozostałych.
  - Nic nie czeka na legacy na żywo; kolejka zdarzeń nie zależy od naszej bazy; klucz w telefonie otwiera drzwi bez naszego systemu.
  - Źródła: ADR-001, ADR-004, ADR-005, ADR-007
- **q6. Wspólna baza to pojedynczy punkt awarii?**
  - Tak, świadomie: jedna baza, jedna replika, jeden backup zamiast pięciu, a blokada pokoju to jedna transakcja.
  - Replika w drugiej strefie, automatyczne przełączenie w 1-2 min; ćwiczymy je przed sezonem i co kwartał.
  - Backup co noc plus ciągły zapis zmian: odtworzenie do dowolnej chwili z 7 dni, w mniej niż godzinę.
  - Źródła: ADR-004
- **q7. Co, gdy padnie Reservations Service?**
  - Stay i Housekeeping pracują na swojej kopii: przyjazdy na dziś, status pokoju, „pokój potrzebny o”.
  - Check-in, checkout, „pokój gotowy” i usterki czekają w kolejce; status uzupełnia się po powrocie.
  - Sprawdzamy to testem: Reservations Service wyłączony na 30 min. Każdy serwis działa na min. dwóch instancjach.
  - Źródła: ADR-005, ADR-001
- **q8. Co, gdy legacy leży albo nie przyjdzie plik?** (miniatura `D3-LegacyDown.png`)
  - Nic nie czeka na legacy na żywo: rezerwacja, płatność, checkout i sprzątanie działają.
  - Brak pliku daje alert; pliki są numerowane, import jest powtarzalny, następny plik nadrabia zaległości.
  - Wymeldowania spoza puli recepcja wpisuje ręcznie; raz dziennie pełne porównanie (pula: wygrywamy my, spoza puli: legacy).
  - Źródła: ADR-003, ADR-002
- **q9. Co, gdy padnie cały system?**
  - Recepcja ma listę przyjazdów, wyjazdów i statusów odświeżaną co 15 min, zapisaną poza naszymi serwisami (plik i mail).
  - Check-in robi ręcznie, potem wpisuje go w aplikacji; dalej trafia do legacy normalną drogą.
  - Klucz zapisany w telefonie dalej otwiera drzwi; karty zostają jako zapas.
  - Źródła: ADR-005, ADR-007

**Legacy i płatności**

- **q10. Jak płatności, skoro legacy nie ma API?**
  - Preautoryzacja na stronie zewnętrznego operatora płatności; danych kart nie widzimy. Przy telefonie recepcja wysyła link SMS-em albo mailem.
  - Gość ma 10 min: odrzuconą kartę widzi od razu i podaje inną; po 10 min blokada się zwalnia (przy VIP dzwoni recepcja).
  - Numer preautoryzacji idzie do legacy w pliku; legacy rozlicza pobyt przy wymeldowaniu i robi zwroty. Zgoda biznesu jeszcze otwarta.
  - Źródła: ADR-003
- **q11. Gdzie są dane gości i płatności?**
  - Karty przyjmuje operator płatności (preautoryzacja); my ich nie widzimy i nie trzymamy.
  - Nasze rezerwacje z danymi gościa, check-iny, checkouty i numer preautoryzacji idą do legacy w pliku; legacy rozlicza pobyt i robi zwroty.
  - Na start jeden region (USA). Otwarte: gdzie są hotele spoza USA i czy dane gości muszą tam zostać.
  - Źródła: ADR-003, PRD C-05, FR-22, A-02
- **q12. Pliki co 15 min. Czy nie będzie podwójnej rezerwacji?** (miniatura `D1-KeyFlow.png`)
  - Nie: legacy blokuje dla nas pulę pokoi i jej nie sprzedaje; o pokoju z puli decyduje tylko Reservations Service.
  - Pokój na noc zapisujemy w jednym miejscu, jedną transakcją, więc dwa kanały nie wezmą tego samego pokoju.
  - Spóźnione mogą być tylko dane spoza puli, których nie sprzedajemy. Pokój z puli niesprzedany na 48 h przed nocą oddajemy legacy.
  - Źródła: ADR-002, ADR-003
- **q13. Housekeeping tylko dla pokoi z puli?**
  - Nie: od pierwszego dnia dla wszystkich pokoi hotelu, bo to dla biznesu najważniejsze.
  - Rezerwacje i wymeldowania spoza puli przychodzą w pliku z legacy co 15 min; Reservations Service liczy „pokój potrzebny o” dla wszystkich pokoi.
  - Cena: dla pokoi spoza puli opóźnienie do 15 min; jak legacy wysyła raz dziennie, wymeldowania wpisuje recepcja.
  - Źródła: ADR-002, ADR-003

**Hotel na co dzień**

- **q14. Co, gdy wózek traci Wi-Fi?**
  - Aplikacja webowa offline na tabletach firmy: lista zadań, zmiana statusu pokoju i zgłoszenie usterki działają bez sieci.
  - Zmiany wysyłają się same po powrocie sieci; o kolejność wygrywa kierowniczka, o stan pokoju housekeeper, który w nim był.
  - 15 min na pokój liczymy z czasu na urządzeniu; każde zadanie ma jedną osobę.
  - Źródła: ADR-006
- **q15. Skąd widok 3D?**
  - Na start gość widzi zdjęcia pokoju i jego położenie na planie piętra; zdjęcia i opisy dostajemy gotowe.
  - Widok 3D pokazujemy tylko, jeśli hotel go dostarczy; sami go nie budujemy.
  - Pokazuje to Room Offer Service, tylko do odczytu; zdjęcia idą z CDN, więc działają też przy przełączaniu bazy.
  - Źródła: PRD FR-20, FR-29, ADR-001
- **q16. Klucz mobilny to fizyczny dostęp. Jak go chronicie?**
  - Klucz gościa działa od check-inu do checkoutu; checkout unieważnia go od razu.
  - Housekeeper dostaje klucz tylko do przydzielonego pokoju i tylko na czas zadania.
  - Każdy klucz ma wpisany czas ważności i sam wygasa. Przed sezonem test penetracyjny i test unieważniania; bez nich start na kartach.
  - Źródła: ADR-007
- **q17. Co, gdy zamek albo telefon nie działa?**
  - Gość z rozładowanym telefonem albo przy zamku, który nie odpowiada: recepcja daje kartę jak dziś.
  - Housekeeper bierze kartę serwisową od kierowniczki sprzątania, wydawaną i oddawaną na zmianę.
  - Klucze mobilne sprawdzamy najpierw w pilocie w 2-3 hotelach w maju.
  - Źródła: ADR-007
- **q18. Handlowcy obiecują rzeczy spoza systemu. Co z tym?**
  - Obietnice zapisujemy jako życzenia w rezerwacji.
  - System sprawdza, czy da się je spełnić; jak nie, daje znać managerowi hotelu.
  - Nowe rzeczy dokładamy w serwisie, którego dotyczą, albo jako adapter w Legacy Sync Service.
  - Źródła: PRD FR-09, charakterystyki (ewolucyjność)

## Wymagania techniczne

- Jeden plik `prezentacja.html`, działa offline z `file://` (bez fontu Google spada na fallback). Bez zapytań sieciowych poza Google Fonts.
- Scena 16:9 o stałym rozmiarze 1920×1080, skalowana `transform: scale()` do okna z zachowaniem proporcji (letterbox, pasy w kolorze tła), wyśrodkowana; przelicza się przy `resize`.
- **Cała treść w danych**: jedna tablica `SLIDES` (rdzeń) i jedna `BACKUP` (pytania) na górze skryptu. Każdy slajd ma pola: `id`, `section`, `layout`, `title`, treść zależną od układu, `steps` (liczba kroków albo lista fragmentów), `notes`, `notesExtra` (opcjonalna lista, blok „Na pytanie / dla CTO”), `notesShort` (wersja krótka), `speaker` (domyślnie `"[Mówca]"`), `seconds` (plan czasu), `canShorten` (dla slajdów 2, 4, 10). Slajdy układu `theme` mają dodatkowo `label`, `lines` (2–3) i `how` (tekst paska „Jak to robimy”). Każde pytanie ma: `id`, `group`, `question`, `answer` (lista), `refs`, opcjonalnie `image`. Zmiana treści nie może wymagać ruszania układu ani CSS.
- Kilka prostych układów renderowanych z danych (np. `title`, `heroNumbers`, `theme`, `threeColumns`, `diagramWithServices`, `styleTable`, `decisionCards`, `failureRows`, `risksNext`, `qa`).
- Dostępność (WCAG 2.1 AA): kontrast tekstu min. 4.5:1 w obu trybach, widoczny fokus (obrys 3 px w akcencie), `lang="pl"`, `aria-live="polite"` z komunikatem „Slajd 7 z 13: tytuł”, przyciski i kafelki dostępne z klawiatury z `aria-label`, opisowe `alt` diagramów, nakładki z `role="dialog"` i pułapką fokusu, `Esc` zawsze zamyka nakładkę.
- `prefers-reduced-motion` respektowane; brak animacji dłuższych niż 200 ms.
- Kod czytelny, z krótkimi komentarzami przy sekcjach (dane, render, nawigacja, notatki, zegar, nakładki).

## Sprawdź przed oddaniem

- Wszystkie skróty działają: strzałki, Spacja, PageUp/PageDown, Home/End, klik, swipe, `S`, `T`, `R`, `Q`, `Esc`, `O`, `D`, `B`, `?`, lightbox (`+`, `-`, `0`).
- `Esc` ze slajdu zapasowego wraca do tego samego slajdu rdzenia i kroku; `#q18` otwiera ostatnie pytanie.
- Pasek czasu zmienia kolor po 3:30 i po 4:00 (do testu możesz dodać ukryty mnożnik czasu w kodzie, domyślnie wyłączony).
- Suma `seconds` slajdów rdzenia to 235 s; slajdy 2, 4 i 10 mają etykietę „można skrócić” i wersję krótką.
- Slajdy 3–7 mają teksty dosłownie z promptu i pasek „Jak to robimy:”; linie „Dla CTO” są tylko w notatkach.
- Każdy slajd mieści się na scenie przy 1280×720 i 1920×1080, bez przewijania i bez tekstu mniejszego niż 26 px w treści.
- Placeholdery pokazują się, gdy obrazów nie ma; nazwy serwisów wszędzie po angielsku i identyczne; w tekstach slajdów nie ma znaku „—”.
- Brak błędów w konsoli; brak treści spoza tego promptu (luki oznaczone `[DO UZUPEŁNIENIA]`).

Odpowiedz pełnym plikiem HTML, a pod nim krótką ściągą skrótów klawiszowych.
