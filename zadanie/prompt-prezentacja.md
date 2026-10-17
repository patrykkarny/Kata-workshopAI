Wklej wszystko poniżej linii `---` do Claude (artifact), Cursora albo v0 i dołącz cztery obrazy z repozytorium Kata-workshopAI, katalog `zadanie/c4/out/png/`: `C1-SystemContext.png`, `C2-Slide.png`, `D1-KeyFlow.png`, `D3-LegacyDown.png`.
Gotowy plik zapisz jako `zadanie/prezentacja.html` (obok katalogu `c4/`), żeby względne ścieżki do obrazów działały; w podglądzie artifactu zamiast obrazów pokażą się placeholdery.

---

# Zadanie

Jesteś doświadczonym projektantem prezentacji technicznych i front-end developerem. Zbuduj **interaktywną prezentację w jednym pliku HTML** (HTML + CSS + vanilla JS, bez frameworków i bibliotek; jedyna zależność zewnętrzna to jeden font z Google Fonts). Prezentacja jest dla zespołu **White** (Marek, Patryk, Mariusz, Kamil) na warsztacie Architectural Kata, kata „Room with a View”. Pokazujemy ją na rzutniku innym zespołom i moderatorowi, a potem bronimy w peer review.

## Zasady treści (ważne)

- **Jedyne źródło treści to ten prompt.** Nie dodawaj faktów, liczb, technologii, dostawców (np. konkretnej chmury, kolejki czy operatora płatności) ani funkcji, których tu nie ma. Nie zaokrąglaj i nie przeliczaj liczb.
- Jeśli czegoś brakuje do układu slajdu, zostaw widoczny znacznik `[DO UZUPEŁNIENIA]` zamiast wymyślać.
- Język slajdów: **polski**. Terminy architektoniczne zostają po angielsku (service-based, event-driven, fault tolerance, outbox, C4, ADR).
- **Nazwy serwisów zawsze po angielsku i zawsze tak samo**: Reservations Service, Housekeeping Service, Stay Service, Legacy Sync Service, Room Offer Service. Nazwy ramek z Event Stormingu zostają jak na tablicy: Rezerwacja, Housekeeping, Servis tech, Visit, Faraway, Synchronizacja, Marketing.
- Obrazy, które dostajesz w załączniku, służą ci tylko do zrozumienia diagramów. **Nie osadzaj ich w pliku** (bez base64); ładuj je ze ścieżek względnych podanych niżej.

## Cel wystąpienia

- Czas: **rdzeń maksymalnie 4:00** (plan: 3:55), potem slajdy zapasowe na pytania. Cały slot to ok. 5 minut, moderator może przerwać.
- Struktura: problem → C1 → C2 → kluczowe ADR-y i trade-offy → ryzyka i założenia. Narracja: kontekst → napięcie → wybór → konsekwencje → wizja. **Zaczynamy od problemu, nie od technologii.**
- Sala głosuje 👍 / 😐 / 👎. 👍 dostaje zespół, który ma odpowiedzi na oczywiste pytania, wiarygodną technologię i nie zostawia niejasności. Dlatego pokazujemy pytania zadane biznesowi, jawne założenia, uczciwe trade-offy (także to, co przegrało i dlaczego) i co się dzieje przy awarii oraz przy wzroście.
- Diagramy zamiast ścian tekstu. Na slajdzie jest to, co trzeba zobaczyć; resztę mówimy (notatki prelegenta).

## Styl wizualny

- Minimalistyczny, czysty, dużo powietrza, czytelny z końca sali przy słabym rzutniku. Bez gradientów, cieni, ikon dekoracyjnych i zdjęć stockowych.
- Scena 1920×1080 px. Tytuł min. **44 px** (zalecane 56 px, waga 600), tekst min. **26 px** (zalecane 30 px), liczby-bohaterowie 120–160 px (waga 700). Elementy interfejsu (numer slajdu, mówca, podpowiedzi) mogą mieć 18–20 px, treść nigdy.
- **Jedna myśl na slajd, maks. 5 linijek albo 5 elementów treści.** Tytuł slajdu to zdanie z tezą, nie etykieta.
- Paleta (tryb jasny):
  - tło złamana biel `#FAFAF7`, powierzchnie kart `#FFFFFF`, linie `#D8DEE4`;
  - tekst grafit `#1F2328`, tekst pomocniczy `#57606A`;
  - jeden akcent: granat `#1F3A5F` (wybory, nasze decyzje, wyróżnienia);
  - jeden kolor kosztów i ryzyk: stonowany pomarańcz `#C2410C` (tylko „Cena”, „Otwarte”, ryzyka, ostrzeżenia czasu).
- Tryb ciemny (klawisz `D`): tło `#121417`, karty `#1B1F24`, tekst `#E8E6E1`, pomocniczy `#A8B0B8`, akcent `#9DB9E0`, pomarańcz `#F08A4B`. Diagramy PNG zawsze leżą na jasnej karcie `#FFFFFF` z wewnętrznym marginesem, także w trybie ciemnym.
- Font: **Inter** (400, 600, 700) z Google Fonts, fallback `system-ui, -apple-system, "Segoe UI", sans-serif`. Liczby `font-variant-numeric: tabular-nums`.
- Kolor nigdy nie jest jedynym sygnałem: koszt ma etykietę „Cena”, ryzyko etykietę „Otwarte” albo znak „!”, wyróżniony wiersz ma też obramowanie i podpis.
- Mały pasek sekcji w lewym górnym rogu (breadcrumbs): **Problem · Architektura · Decyzje · Co dalej**, aktywna sekcja w akcencie. Pomaga, gdy moderator przerwie.

## Interakcje

- **Nawigacja**: `→`, `↓`, `Spacja`, `PageDown` dalej; `←`, `↑`, `PageUp` wstecz; `Home` / `End` pierwszy i ostatni slajd rdzenia; kliknięcie w prawą / lewą połowę sceny (poza obrazami i przyciskami); swipe na dotyku (próg ok. 50 px).
- **Build-outs (fragmenty)**: elementy oznaczone niżej jako kroki pojawiają się kolejno przy „dalej”. „Wstecz” chowa ostatni krok. Po powrocie na poprzedni slajd jest on pokazany w pełni zbudowany.
- **Notatki prelegenta** (`S`): otwiera drugie okno (ten sam plik z hashem `#speaker`) z: notatkami bieżącego slajdu (min. 28 px), tytułem następnego slajdu, numerem kroku (np. „krok 2/4”), mówcą bieżącego i następnego slajdu („Za chwilę: [Mówca]”), dużym zegarem, planowanym czasem końca bieżącego slajdu i różnicą względem planu („+0:12 za planem” na pomarańczowo, „−0:05 przed planem”). Okna synchronizują się przez `BroadcastChannel` (fallback: `postMessage` przez `window.opener`); nawigacja działa z obu okien. Jeśli przeglądarka zablokuje okno, `S` pokazuje panel notatek na dole tej samej strony.
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

- `c4/out/png/C1-SystemContext.png` (poziomy, ok. 1568×1172)
- `c4/out/png/C2-Slide.png` (prawie kwadratowy, ok. 1568×1536)
- `c4/out/png/D1-KeyFlow.png` (prawie kwadratowy, ok. 1568×1514)
- `c4/out/png/D3-LegacyDown.png` (poziomy, ok. 1568×1308)

Każdy obraz: `object-fit: contain` na jasnej karcie, opisowy `alt`, mała podpowiedź „kliknij, aby powiększyć”. Jeśli obraz się nie wczyta (`onerror`), pokaż elegancki placeholder w tym samym miejscu i rozmiarze: przerywana ramka, nazwa diagramu (np. „C2: kontenery”) i ścieżka pliku. Nie rysuj nakładek ani podświetleń na współrzędnych obrazu; wyróżnienia robimy w kolumnie obok obrazu.

## Slajdy rdzenia: plan czasu

| # | Slajd | Sekcja | Czas | Koniec |
|---|---|---|---|---|
| 1 | Tytuł i odpowiedź jednym zdaniem | Problem | 0:10 | 0:10 |
| 2 | Czerwiec albo za rok | Problem | 0:20 | 0:30 |
| 3 | Zapytaliśmy biznes | Problem | 0:15 | 0:45 |
| 4 | Ruch jest mały | Problem | 0:15 | 1:00 |
| 5 | Top 3 charakterystyki | Problem | 0:25 | 1:25 |
| 6 | C1: kontekst | Architektura | 0:15 | 1:40 |
| 7 | C2: pięć serwisów | Architektura | 0:30 | 2:10 |
| 8 | Dlaczego service-based | Architektura | 0:25 | 2:35 |
| 9 | Cztery decyzje i ich cena | Decyzje | 0:30 | 3:05 |
| 10 | Coś padnie, hotel działa | Decyzje | 0:20 | 3:25 |
| 11 | Założenia i otwarte sprawy | Co dalej | 0:15 | 3:40 |
| 12 | Co dalej | Co dalej | 0:10 | 3:50 |
| 13 | Zamknięcie | Co dalej | 0:05 | 3:55 |

Slajdy 4, 6 i 12 są „akordeonowe”: jeśli jesteśmy za planem, mówca skraca je do jednego zdania. Oznacz je w oknie notatek etykietą „można skrócić”.

## Slajdy rdzenia: treść

### 1. Tytuł
- Tytuł (duży): **Room with a View**
- Podtytuł: „Zespół White · Marek, Patryk, Mariusz, Kamil”
- Odpowiedź jednym zdaniem (akcent, 34–40 px): „Pięć serwisów i jedna baza: prosto, żeby zdążyć na czerwiec, gotowe na kolejne hotele i odporne na awarie.”
- Notatki: „Jesteśmy zespołem White. Nasza odpowiedź w jednym zdaniu: pięć serwisów domenowych i jedna baza. Za chwilę pokażemy, dlaczego właśnie tak.”

### 2. Czerwiec albo za rok
- Tytuł: „Czerwiec albo za rok”
- Cztery duże liczby w kafelkach, pojawiają się kolejno (4 kroki):
  - **107** hoteli
  - **ok. 21 tys.** pokoi
  - **do 90%** obłożenia w sezonie od czerwca
  - **15 min** na przygotowanie pokoju
- Linijka pod kafelkami (krok 5): „Gość chce sam wybrać konkretny pokój (np. daleko od windy), a dziś sprzątanie rozdziela się przez wiadomości.”
- Notatki: „Sieć ma 107 hoteli, razem około 21 tysięcy pokoi. Sezon startuje na początku czerwca, obłożenie dochodzi do 90%, więc albo zdążymy, albo czekamy rok. Gość chce sam wybrać pokój, a dziś kierowniczka rozdziela sprzątanie przez wiadomości.”

### 3. Zapytaliśmy biznes
- Tytuł: „Zapytaliśmy biznes. Trzy odpowiedzi zmieniły projekt.”
- Trzy wiersze w dwóch kolumnach „Usłyszeliśmy” (cytat, grafit) → „Więc” (akcent); każdy wiersz to krok:
  1. „Legacy nie ma API” → wymieniamy z nim pliki w obie strony co 15 min
  2. „Najważniejszy jest system do sprzątania” → housekeeping od pierwszego dnia dla wszystkich pokoi hotelu
  3. „Smart locki mają API, firma w nie inwestuje” → klucze mobilne w MVP
- Notatki: „Zapytaliśmy biznes i trzy odpowiedzi zmieniły nasz projekt. Legacy nie ma API, więc rozmawiamy z nim plikami. Sprzątanie jest najważniejsze, więc housekeeping wchodzi od pierwszego dnia dla wszystkich pokoi, a w smart locki firma inwestuje, więc klucze mobilne są w MVP.”

### 4. Ruch jest mały
- Tytuł: „Ruch jest mały. Trudna jest skala sieci.”
- Lewa strona: liczba-bohater **1 rezerwacja / 14 s**, pod nią „ok. 6400 dziennie w 107 hotelach”.
- Prawa strona (krok 2): trzy poziome paski na wspólnej skali 0–100 rezerwacji na minutę, w CSS:
  - **ok. 21 / min**: najgorsza godzina (20% dziennych rezerwacji w jednej godzinie)
  - **ok. 65 / min**: test obciążenia przed sezonem (3x najgorsza godzina)
  - **100 / min**: próg, przy którym dokładamy instancje (pasek tylko z obrysem, przerywany)
- Wniosek na dole (krok 3): „Wyzwanie to 107 hoteli naraz, kolejne w drodze, i check-iny oraz checkouty wszędzie w tych samych godzinach.”
- Notatki: „Policzyliśmy ruch: około 6400 rezerwacji dziennie, czyli jedna co 14 sekund. Nawet w najgorszej godzinie to około 21 na minutę, daleko od progu 100. Trudność nie leży w ruchu, tylko w tym, że 107 hoteli działa naraz, a check-iny i checkouty wypadają wszędzie w tych samych godzinach.”

### 5. Top 3 charakterystyki
- Tytuł: „Trzy charakterystyki prowadzą architekturę”
- Trzy kolumny, każda to krok; w każdej nazwa (akcent), „Dlaczego” i „Jak mierzymy”:
  1. **Prostota** · Dlaczego: działa w czerwcu albo czekamy rok; buduje to normalny zespół. · Mierzymy: MVP działa w hotelach pilotażowych przed sezonem.
  2. **Skalowalność: wzrost, nie skoki** · Dlaczego: 107 hoteli od pierwszego dnia, firma dokłada kolejne. · Mierzymy: test obciążenia na 3x najgorszą godzinę; nowy hotel bez zmiany kodu.
  3. **Odporność na awarie** · Dlaczego: przy 90% obłożenia hotel nie może stanąć; nic nie czeka na legacy na żywo. · Mierzymy: wyłączamy Reservations Service na 30 min, a check-in, checkout i sprzątanie działają.
- Pasek na dole (krok 4): „Świadomie odrzucone: elastyczność (automatyczne skalowanie w górę i w dół), bo szczyt sezonu znamy z góry.”
- Notatki: „Stąd trzy charakterystyki. Prostota, bo termin. Skalowalność rozumiana jako wzrost liczby hoteli, a nie nagłe skoki, dlatego elastyczność świadomie odrzucamy. Odporność na awarie, bo hotel w sezonie nie może stanąć. Każdą umiemy zmierzyć.”

### 6. C1: kontekst
- Tytuł: „C1: kto i z czym rozmawia”
- Lewa strona: obraz `C1-SystemContext.png` (ok. 60% szerokości).
- Prawa strona: cztery podpisy, każdy to krok:
  1. Gość i personel hotelu: recepcja, manager, kierowniczka sprzątania, housekeeperzy przy wózkach.
  2. Legacy zostaje systemem cen, rozliczenia pobytu, zwrotów i raportów. Bez API: pliki w obie strony co 15 min.
  3. Operator płatności: gość robi preautoryzację na jego stronie. Danych kart nie widzimy.
  4. Smart locki w MVP: klucz mobilny w telefonie, karty w recepcji jako zapas.
- Notatki: „Po jednej stronie gość i personel hotelu, po drugiej systemy zewnętrzne. Legacy zostaje systemem cen i rozliczeń, operator płatności przyjmuje karty, a smart locki dają klucz w telefonie.”

### 7. C2: pięć serwisów
- Tytuł: „C2: pięć serwisów, jedna baza”
- Podtytuł (jedna linijka, tekst pomocniczy): „TypeScript (NestJS, React) · PostgreSQL · statusy pokoju przez kolejkę zdarzeń, reszta przez HTTPS”
- Lewa strona: obraz `C2-Slide.png` na pełną wysokość obszaru treści.
- Prawa strona: pięć kart serwisów. Kroki 1–5 kolejno wyróżniają jedną kartę (pełne krycie + granatowa krawędź z lewej), pozostałe są przygaszone (ok. 40%); po ostatnim kroku wszystkie są pełne. Każda karta: nazwa serwisu, pod nią małym tekstem ramka z tablicy, potem jedna linijka:
  1. **Reservations Service** (ramka Rezerwacja): jedyne miejsce, które zajmuje pokój na noc, jedną transakcją.
  2. **Housekeeping Service** (Housekeeping + Servis tech): sprzątanie i usterki w jednej kolejce; aplikacja na wózki działa offline.
  3. **Stay Service** (Visit + Faraway): check-in, checkout i klucze mobilne.
  4. **Legacy Sync Service** (Synchronizacja): jedyny, który wymienia pliki z legacy.
  5. **Room Offer Service** (Marketing): zdjęcia, plany pięter i cechy pokoi; tylko do odczytu.
- Notatki: „W środku pięć serwisów, każdy to jedna albo dwie ramki z naszego Event Stormingu. Reservations Service jako jedyny zajmuje pokój na noc. Housekeeping ma sprzątanie i usterki w jednej kolejce, Stay Service check-in, checkout i klucze, Legacy Sync Service jako jedyny rozmawia z legacy, a Room Offer Service pokazuje zdjęcia i plany pięter.”

### 8. Dlaczego service-based
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

- Kroki: (1) tabela; (2) wiersze Event-driven i Mikroserwisy dostają pomarańczowy obrys i etykietę „więcej punktów”; (3) wiersz Service-based wypełniony granatem z białym tekstem i etykietą „nasz wybór”; (4) po prawej trzy powody, pojawiają się razem:
  - Prostota 3, a nie 2 albo 1: termin to czerwiec.
  - Blokada pokoju na noc to jedna transakcja, nie spójność ostateczna.
  - Przy ok. 21 rezerwacjach na minutę wystarczy dokładać instancje jednemu serwisowi.
- Notatki: „Uczciwie: w arkuszu event-driven i mikroserwisy mają o punkt więcej. Wybraliśmy service-based, bo jest prostszy przy terminie w czerwcu, blokada pokoju to jedna transakcja, a przy naszym ruchu wystarczy dokładać instancje jednemu serwisowi. Monolit jest jeszcze prostszy, ale jak padnie, pada cały hotel.”

### 9. Cztery decyzje i ich cena
- Tytuł: „Cztery decyzje i ich cena”
- Siatka 2×2 kart, każda to krok. Karta: w prawym górnym rogu etykieta ADR, potem „Wybraliśmy” (akcent, pogrubione), „zamiast …” (tekst pomocniczy), „Cena: …” (pomarańcz, z etykietą „Cena”):
  1. **ADR-004** · Wybraliśmy: jedna baza PostgreSQL, osobny schemat na serwis · zamiast bazy na serwis · Cena: wspólny punkt awarii, więc replika w drugiej strefie i przełączenie w 1-2 min.
  2. **ADR-003** · Wybraliśmy: pliki z legacy w obie strony co 15 min · zamiast API, którego nie ma · Cena: dane pokoi spoza puli spóźnione do 15 min.
  3. **ADR-005** · Wybraliśmy: zmiany statusu pokoju przez kolejkę zdarzeń z outboxem · zamiast wywołań HTTPS · Cena: gdy Reservations Service leży, recepcja widzi ostatni znany status.
  4. **ADR-007** · Wybraliśmy: smart locki w MVP, adapter w Stay Service · zamiast startu po sezonie · Cena: test penetracyjny i test unieważniania kluczy w maju; bez nich start na kartach.
- Notatki: „Cztery decyzje i ich cena. Jedna baza zamiast pięciu, płacimy wspólnym punktem awarii, więc replika. Pliki co 15 minut, bo API nie ma, płacimy opóźnieniem dla pokoi spoza puli. Statusy pokoju przez kolejkę, żeby sprzątanie działało, gdy rezerwacje leżą. Smart locki w MVP, płacimy testami bezpieczeństwa w maju.”

### 10. Coś padnie, hotel działa
- Tytuł: „Coś padnie. Hotel działa dalej.”
- Lewa strona: cztery wiersze „Co pada” (pogrubione) → „Co się dzieje”; każdy wiersz to krok:
  1. **Legacy albo plik z legacy** → alert; rezerwacja, płatność, checkout i sprzątanie działają; następny plik nadrabia.
  2. **Reservations Service** → Stay i Housekeeping pracują na swojej kopii; zdarzenia czekają w kolejce.
  3. **Baza (przełączenie 1-2 min)** → kanały: „spróbuj za chwilę”; zdjęcia z CDN; wózki zapisują offline.
  4. **Cały system** → recepcja ma listę awaryjną co 15 min (plik i mail); klucz w telefonie dalej otwiera drzwi.
- Prawa strona: miniatura `D3-LegacyDown.png` z podpisem „D3: legacy leży albo nie przyszedł plik”, klikalna (lightbox).
- Notatki: „Co, jak coś padnie? Legacy leży: dostajemy alert, a hotel pracuje dalej. Reservations Service leży: pobyt i sprzątanie działają na ostatnim znanym stanie. Baza się przełącza: do dwóch minut, wózki zapisują offline. Leży wszystko: recepcja ma listę awaryjną, a klucz w telefonie dalej otwiera drzwi.”

### 11. Założenia i otwarte sprawy
- Tytuł: „Założenia i otwarte sprawy”
- Pięć wierszy, każdy z etykietą na początku: „Założenie” (granatowa) albo „Otwarte” (pomarańczowa, ze znakiem „!”); wiersze pojawiają się razem:
  1. **Założenie**: pliki z legacy co 15 min. Format i częstotliwość nieznane; jak raz dziennie: pula dalej bezpieczna, wymeldowania spoza puli wpisuje recepcja.
  2. **Założenie**: legacy umie dziś blokować pokoje. Jak nie: jedna długa techniczna rezerwacja na każdy pokój z puli.
  3. **Otwarte**: czy biznes zgadza się na preautoryzację u operatora płatności i rozliczenie w legacy przy wymeldowaniu.
  4. **Otwarte**: jak duża ma być pula na hotel i kto ją ustala.
  5. **Założenie**: na start jeden region (USA). Otwarte: gdzie są hotele spoza USA i czy dane gości muszą tam zostać.
- Notatki: „Mówimy wprost, czego nie wiemy. Część pytań do biznesu wciąż jest otwarta, ale dla każdego założenia mamy plan na wypadek, gdyby okazało się fałszywe.”

### 12. Co dalej
- Tytuł: „Co dalej”
- Pozioma oś czasu z trzema etapami, każdy to krok:
  1. **Maj, przed sezonem**: pilot w 2-3 hotelach; test obciążenia, testy kluczy mobilnych, ćwiczenie przełączenia bazy.
  2. **Czerwiec**: wszystkie hotele.
  3. **Potem**: nowy hotel to konfiguracja; powyżej 100 rezerwacji na minutę instancje dla serwisu, który się dławi; drugi region to ten sam zestaw serwisów.
- Notatki: „W maju pilot w 2-3 hotelach razem z testem obciążenia i testami kluczy, w czerwcu wszystkie hotele. Potem nowy hotel to konfiguracja, a jak przekroczymy 100 rezerwacji na minutę, dokładamy instancje temu serwisowi, który się dławi.”

### 13. Zamknięcie
- Trzy linijki, duże, wyśrodkowane, pojawiają się razem:
  - „Prosto, żeby zdążyć na czerwiec.”
  - „Rośnie razem z siecią: nowy hotel to konfiguracja.”
  - „Hotel działa, nawet gdy coś padnie.”
- Pod spodem (akcent): „Pytania?”
- Notatki: „Prosto, żeby zdążyć. Rośnie razem z siecią. Hotel działa, nawet gdy coś padnie. Dziękujemy, czekamy na pytania.”

## Slajdy zapasowe (klawisz `Q`)

Układ slajdu: pytanie jako tytuł (maks. 2 linijki), 2–3 krótkie punkty odpowiedzi, etykiety źródeł (np. „ADR-001”) na dole; przy q7 i q10 miniatura diagramu po prawej (lightbox). Na dole małym tekstem: „Esc: wróć do prezentacji · Q: lista pytań”. W siatce kafelek pokazuje skrócone pytanie i numer.

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

- **q5. Wspólna baza to pojedynczy punkt awarii?**
  - Tak, świadomie: jedna baza, jedna replika, jeden backup zamiast pięciu, a blokada pokoju to jedna transakcja.
  - Replika w drugiej strefie, automatyczne przełączenie w 1-2 min; ćwiczymy je przed sezonem i co kwartał.
  - Backup co noc plus ciągły zapis zmian: odtworzenie do dowolnej chwili z 7 dni, w mniej niż godzinę.
  - Źródła: ADR-004
- **q6. Co, gdy padnie Reservations Service?**
  - Stay i Housekeeping pracują na swojej kopii: przyjazdy na dziś, status pokoju, „pokój potrzebny o”.
  - Check-in, checkout, „pokój gotowy” i usterki czekają w kolejce; status uzupełnia się po powrocie.
  - Sprawdzamy to testem: Reservations Service wyłączony na 30 min. Każdy serwis działa na min. dwóch instancjach.
  - Źródła: ADR-005, ADR-001
- **q7. Co, gdy legacy leży albo nie przyjdzie plik?** (miniatura `D3-LegacyDown.png`)
  - Nic nie czeka na legacy na żywo: rezerwacja, płatność, checkout i sprzątanie działają.
  - Brak pliku daje alert; pliki są numerowane, import jest powtarzalny, następny plik nadrabia zaległości.
  - Wymeldowania spoza puli recepcja wpisuje ręcznie; raz dziennie pełne porównanie (pula: wygrywamy my, spoza puli: legacy).
  - Źródła: ADR-003, ADR-002
- **q8. Co, gdy padnie cały system?**
  - Recepcja ma listę przyjazdów, wyjazdów i statusów odświeżaną co 15 min, zapisaną poza naszymi serwisami (plik i mail).
  - Check-in robi ręcznie, potem wpisuje go w aplikacji; dalej trafia do legacy normalną drogą.
  - Klucz zapisany w telefonie dalej otwiera drzwi; karty zostają jako zapas.
  - Źródła: ADR-005, ADR-007

**Legacy i płatności**

- **q9. Jak płatności, skoro legacy nie ma API?**
  - Preautoryzacja na stronie zewnętrznego operatora płatności; danych kart nie widzimy. Przy telefonie recepcja wysyła link SMS-em albo mailem.
  - Gość ma 10 min: odrzuconą kartę widzi od razu i podaje inną; po 10 min blokada się zwalnia (przy VIP dzwoni recepcja).
  - Numer preautoryzacji idzie do legacy w pliku; legacy rozlicza pobyt przy wymeldowaniu i robi zwroty. Zgoda biznesu jeszcze otwarta.
  - Źródła: ADR-003
- **q10. Pliki co 15 min. Czy nie będzie podwójnej rezerwacji?** (miniatura `D1-KeyFlow.png`)
  - Nie: legacy blokuje dla nas pulę pokoi i jej nie sprzedaje; o pokoju z puli decyduje tylko Reservations Service.
  - Pokój na noc zapisujemy w jednym miejscu, jedną transakcją, więc dwa kanały nie wezmą tego samego pokoju.
  - Spóźnione mogą być tylko dane spoza puli, których nie sprzedajemy. Pokój z puli niesprzedany na 48 h przed nocą oddajemy legacy.
  - Źródła: ADR-002, ADR-003
- **q11. Housekeeping tylko dla pokoi z puli?**
  - Nie: od pierwszego dnia dla wszystkich pokoi hotelu, bo to dla biznesu najważniejsze.
  - Rezerwacje i wymeldowania spoza puli przychodzą w pliku z legacy co 15 min; Reservations Service liczy „pokój potrzebny o” dla wszystkich pokoi.
  - Cena: dla pokoi spoza puli opóźnienie do 15 min; jak legacy wysyła raz dziennie, wymeldowania wpisuje recepcja.
  - Źródła: ADR-002, ADR-003

**Hotel na co dzień**

- **q12. Co, gdy wózek traci Wi-Fi?**
  - Aplikacja webowa offline na tabletach firmy: lista zadań, zmiana statusu pokoju i zgłoszenie usterki działają bez sieci.
  - Zmiany wysyłają się same po powrocie sieci; o kolejność wygrywa kierowniczka, o stan pokoju housekeeper, który w nim był.
  - 15 min na pokój liczymy z czasu na urządzeniu; każde zadanie ma jedną osobę.
  - Źródła: ADR-006
- **q13. Klucz mobilny to fizyczny dostęp. Jak go chronicie?**
  - Klucz gościa działa od check-inu do checkoutu; checkout unieważnia go od razu.
  - Housekeeper dostaje klucz tylko do przydzielonego pokoju i tylko na czas zadania.
  - Każdy klucz ma wpisany czas ważności i sam wygasa. Przed sezonem test penetracyjny i test unieważniania; bez nich start na kartach.
  - Źródła: ADR-007
- **q14. Co, gdy zamek albo telefon nie działa?**
  - Gość z rozładowanym telefonem albo przy zamku, który nie odpowiada: recepcja daje kartę jak dziś.
  - Housekeeper bierze kartę serwisową od kierowniczki sprzątania, wydawaną i oddawaną na zmianę.
  - Klucze mobilne sprawdzamy najpierw w pilocie w 2-3 hotelach w maju.
  - Źródła: ADR-007
- **q15. Handlowcy obiecują rzeczy spoza systemu. Co z tym?**
  - Obietnice zapisujemy jako życzenia w rezerwacji.
  - System sprawdza, czy da się je spełnić; jak nie, daje znać managerowi hotelu.
  - Nowe rzeczy dokładamy w serwisie, którego dotyczą, albo jako adapter w Legacy Sync Service.
  - Źródła: PRD FR-09, charakterystyki (ewolucyjność)

## Wymagania techniczne

- Jeden plik `prezentacja.html`, działa offline z `file://` (bez fontu Google spada na fallback). Bez zapytań sieciowych poza Google Fonts.
- Scena 16:9 o stałym rozmiarze 1920×1080, skalowana `transform: scale()` do okna z zachowaniem proporcji (letterbox, pasy w kolorze tła), wyśrodkowana; przelicza się przy `resize`.
- **Cała treść w danych**: jedna tablica `SLIDES` (rdzeń) i jedna `BACKUP` (pytania) na górze skryptu. Każdy slajd ma pola: `id`, `section`, `layout`, `title`, treść zależną od układu, `steps` (liczba kroków albo lista fragmentów), `notes`, `speaker` (domyślnie `"[Mówca]"`), `seconds` (plan czasu), `canShorten` (dla slajdów 4, 6, 12). Każde pytanie ma: `id`, `group`, `question`, `answer` (lista), `refs`, opcjonalnie `image`. Zmiana treści nie może wymagać ruszania układu ani CSS.
- Kilka prostych układów renderowanych z danych (np. `title`, `heroNumbers`, `askedBusiness`, `trafficBars`, `threeColumns`, `diagramWithCaptions`, `diagramWithServices`, `styleTable`, `decisionCards`, `failureRows`, `assumptions`, `timeline`, `closing`, `qa`).
- Dostępność (WCAG 2.1 AA): kontrast tekstu min. 4.5:1 w obu trybach, widoczny fokus (obrys 3 px w akcencie), `lang="pl"`, `aria-live="polite"` z komunikatem „Slajd 7 z 13: tytuł”, przyciski i kafelki dostępne z klawiatury z `aria-label`, opisowe `alt` diagramów, nakładki z `role="dialog"` i pułapką fokusu, `Esc` zawsze zamyka nakładkę.
- `prefers-reduced-motion` respektowane; brak animacji dłuższych niż 200 ms.
- Kod czytelny, z krótkimi komentarzami przy sekcjach (dane, render, nawigacja, notatki, zegar, nakładki).

## Sprawdź przed oddaniem

- Wszystkie skróty działają: strzałki, Spacja, PageUp/PageDown, Home/End, klik, swipe, `S`, `T`, `R`, `Q`, `Esc`, `O`, `D`, `B`, `?`, lightbox (`+`, `-`, `0`).
- `Esc` ze slajdu zapasowego wraca do tego samego slajdu rdzenia i kroku.
- Pasek czasu zmienia kolor po 3:30 i po 4:00 (do testu możesz dodać ukryty mnożnik czasu w kodzie, domyślnie wyłączony).
- Suma `seconds` slajdów rdzenia to 235 s.
- Każdy slajd mieści się na scenie przy 1280×720 i 1920×1080, bez przewijania i bez tekstu mniejszego niż 26 px w treści.
- Placeholdery pokazują się, gdy obrazów nie ma; nazwy serwisów wszędzie po angielsku i identyczne.
- Brak błędów w konsoli; brak treści spoza tego promptu (luki oznaczone `[DO UZUPEŁNIENIA]`).

Odpowiedz pełnym plikiem HTML, a pod nim krótką ściągą skrótów klawiszowych.
