# Domain: Room with a View

Status: Draft  
Updated: 2026-10-17  
Authors: Zespół White (Marek, Patryk, Mariusz, Kamil)  
Miro: brak linku; zrzut tablicy: `event-storming/kata-white.png`

## Bounded Contexts

### BC-01 Rezerwacja (core)

- Responsibility: zapytanie o dostępność, wymagania i życzenia gościa, rezerwacja typu albo konkretnego pokoju, zdjęcie dostępności; wszystkie kanały (web, mobile, telefon, walk-in) przez jedno API (FR-03); jedyne miejsce, które wie, czy pokój jest wolny danej nocy, w jakim jest stanie i kiedy będzie potrzebny (FR-05); jedyne miejsce, które może zająć pokój na noc; liczy „pokój potrzebny o” dla wszystkich pokoi (także spoza puli) i wysyła to do Housekeepingu.
- Key events: Zapytano o dostępność, Zebrano wymagania, Zamówione ekstra elementy do pokoju na pobyt, Sprawdzono dostępność pokoi zgodnie z wymaganiami, Zarezerwowano pokój, Dostarczenie listy życzeń do pokoju, Dostosowano pokój do ekstra wymagań, Zdjęta dostępność pokoju.
- Commands & policies: FR-02, FR-09, FR-16; aktorzy na ramce: Sales, Guest, Recepcja.
- Language: „dostępny”: wolny do sprzedaży (inny stan niż „gotowy”); „pokój”: noce i status; „życzenie”: także obietnica handlowca zapisana w rezerwacji.
- Owns data: dostępność pokoju na noc, status pokoju, kiedy pokój będzie potrzebny.
- Hotspots: dwa kanały mogą chcieć ten sam pokój na tę samą noc, dlatego blokada pokoju na noc jest w jednym miejscu; handlowcy obiecują gościom rzeczy, których nie ma w systemie, dlatego obietnice zapisujemy jako życzenia ze sprawdzeniem (FR-09).
- Source: Miro: Rezerwacja, notatki, grill-me Q1, Q15, Q18, Q34, Q36, Q63

### BC-02 Housekeeping (core)

- Responsibility: zlecenia sprzątania, przydział osoby, pokój gotowy do sprzątania, wysprzątany, gotowy dla gościa.
- Key events: Otrzymaliśmy zlecenie sprzątania pokoju, Przydzielono osobę sprzątającą / wysłano powiadomienie, Klucz mobilny przydzielony, Pokój gotowy do sprzątania, Pokój wysprzątano, Klucz mobilny unieważniony, Pokój gotowy dla gościa.
- Commands & policies: FR-12, FR-14; aktor na ramce: Housekeeper.
- Language: „gotowy”: posprzątany (inny stan niż „dostępny”); „pokój”: zadania.
- Owns data: zadania (zlecenia sprzątania).
- Hotspots: Wi-Fi w hotelu się rwie, dlatego aplikacja na wózki działa offline.
- Source: Miro: Housekeeping, notatki, grill-me Q18, Q34

### BC-03 Servis tech (core)

- Responsibility: zgłoszenie i usunięcie usterki.
- Key events: usterka zgłoszona, Klucz mobilny przydzielony, usterka usunięta, Klucz mobilny unieważniony.
- Commands & policies: FR-15; aktorzy na ramce: Housekeeper, Guest, Recepcja.
- Language: _Brak w notatkach._
- Owns data: _Brak w notatkach._
- Hotspots: _Brak w notatkach._
- Source: Miro: Servis tech, notatki

### BC-04 Visit (supporting)

- Responsibility: check-in, przydzielenie zamka, pierwsze wejście, pobyt rozpoczęty.
- Key events: Przydzielenie zamka pokoju, Pierwsze użycie zamka / wejście klienta, Pobyt rozpoczęto.
- Commands & policies: komenda: checkin; FR-10; aktorzy na ramce: Guest, Recepcja.
- Language: _Brak w notatkach._
- Owns data: _Brak w notatkach._
- Hotspots: _Brak w notatkach._
- Source: Miro: Visit, notatki

### BC-05 Faraway (supporting)

- Responsibility: checkout, zastrzeżenia do pokoju, anulowanie, zwrot, rekompensata, pokój znowu dostępny.
- Key events: Pobyt zakończono, Zgłoszono zastrzeżenia do pokoju, Anulowano rezerwację/pobyt, Zażądano zwrotu pieniędzy za anulowany pobyt, Naliczono rekompensatę, Pokój ponownie dostępny.
- Commands & policies: komenda: Checkout; FR-11; aktorzy na ramce: Guest, Recepcja.
- Language: _Brak w notatkach._
- Owns data: _Brak w notatkach._
- Hotspots: _Brak w notatkach._
- Source: Miro: Faraway, notatki

### BC-06 Marketing (supporting)

- Responsibility: standard, cechy, zdjęcia i udostępnienie oferty; zdjęcia i opisy dostajemy gotowe; powiązanie zamka z pokojem ustawia hotel w konfiguracji Pobytu, a nie Marketing.
- Key events: Ustalono nowe ceny per typ, Dodano cechy, Dodano zdjęcia, Ustalono standard, Zdefiniowano ceny w okres czasu, Przydzielono ID zamka, Udostępniono ofertę.
- Commands & policies: aktor na ramce: Marketing.
- Language: „pokój”: zdjęcia (oferta).
- Owns data: zdjęcia i opisy pokoi.
- Hotspots: _Brak w notatkach._
- Source: Miro: Marketing, notatki, grill-me Q34, Q36

### BC-07 Synchronizacja (supporting)

- Responsibility: jedyne miejsce, które wymienia pliki z legacy: od legacy pula pokoi, ceny, rezerwacje i pobyty spoza puli; do legacy nasze rezerwacje z puli, check-iny i checkouty, informacja o płatności; plus porównanie danych; legacy schowane za Synchronizacją, żeby jego model nie wyciekał do reszty systemu; przekazuje do Rezerwacji rezerwacje z legacy dla pokoi spoza puli.
- Key events: Wystawiono Raport check in / check out, Zaczytano Raport check in / check out legacy, System legacy zsynchronizowany, System modern zsynchronizowany.
- Commands & policies: komenda: Nadpisz pre-rezerwacje; FR-07, FR-08, FR-17, FR-19; aktor na ramce: System.
- Language: „pre-rezerwacja”: blokada pokoju w legacy dla naszej puli.
- Owns data: _Brak w notatkach._
- Hotspots: legacy nie ma API, tylko pliki (C-02), dlatego pula pokoi jest tylko nasza, a dane spoza puli mogą być spóźnione do 15 minut.
- Source: Miro: Synchronizacja, notatki, grill-me Q3, Q63

### BC-08 Payments (generic)

- Responsibility: preautoryzację przy rezerwacji robi zewnętrzny operator płatności, a rozliczenie pobytu i zwroty robi legacy; my nie widzimy danych kart.
- Key events: Pobyt opłacono, Zarejestrowano płatność, Zwrócono pieniądze.
- Commands & policies: FR-22; aktor na ramce: Guest.
- Language: _Brak w notatkach._
- Owns data: _Brak w notatkach._
- Hotspots: _Brak w notatkach._
- Source: Miro: Payments, notatki

## Context Map

| Upstream | Downstream | Relationship | What flows | Source |
|---|---|---|---|---|
| BC-01 Rezerwacja | BC-04 Visit | Rezerwacja jako jedyna zajmuje pokój na noc; Visit prosi ją o zmianę: check-in idzie do Rezerwacji jako zdarzenie przez kolejkę, a nie przez HTTPS | zmiana stanu pokoju (check-in) | notatki |
| BC-01 Rezerwacja | BC-05 Faraway | Rezerwacja jako jedyna zajmuje pokój na noc; Faraway prosi ją o zmianę: checkout idzie do Rezerwacji jako zdarzenie przez kolejkę, a nie przez HTTPS | zmiana stanu pokoju (checkout) | notatki |
| BC-05 Faraway | BC-02 Housekeeping | po checkoucie Faraway wysyła zlecenie | zlecenie sprzątania | notatki |
| BC-01 Rezerwacja | BC-02 Housekeeping | Rezerwacja mówi, na kiedy pokój ma być gotowy, dla wszystkich pokoi (także spoza puli); z tego liczymy priorytet | termin gotowości pokoju („pokój potrzebny o”) | notatki, grill-me Q63 |
| BC-01 Rezerwacja | Pobyt (BC-04, BC-05) i Housekeeping (BC-02, BC-03) | odbiorcy trzymają u siebie kopię tego, czego potrzebują, aktualizowaną zdarzeniami; jak Rezerwacje leżą, pracują na ostatnim znanym stanie | przyjazdy na dziś, status pokoju, „pokój potrzebny o” | notatki |
| BC-02 Housekeeping | BC-01 Rezerwacja | Housekeeping mówi, że pokój jest gotowy; przez kolejkę zdarzeń, a nie przez HTTPS: jak Rezerwacje leżą, zdarzenia czekają w kolejce, a status na recepcji uzupełnia się po powrocie | pokój gotowy | notatki, grill-me Q62 |
| BC-03 Servis tech | BC-01 Rezerwacja | Servis tech mówi, że pokój jest gotowy albo ma usterkę; przez kolejkę zdarzeń, a nie przez HTTPS: jak Rezerwacje leżą, zdarzenia czekają w kolejce, a status na recepcji uzupełnia się po powrocie; normalnie zdarzenie dochodzi w kilka sekund | pokój gotowy, usterka | notatki, grill-me Q62 |
| BC-07 Synchronizacja | BC-01 Rezerwacja | Synchronizacja przekazuje rezerwacje z legacy, żeby Rezerwacja liczyła „pokój potrzebny o” także dla pokoi spoza puli | rezerwacje z legacy dla pokoi spoza puli | grill-me Q63 |
| Pobyt (BC-04, BC-05) | BC-02 Housekeeping | Housekeeping prosi Pobyt o klucz dla housekeepera przy przydziale zadania; Pobyt unieważnia go po zakończeniu zadania | klucz mobilny housekeepera | notatki |
| Legacy (system zewnętrzny) | BC-07 Synchronizacja | wymiana plików w obie strony co 15 minut, raz dziennie pełne porównanie; legacy schowane za Synchronizacją, żeby jego model nie wyciekał | od legacy: pula pokoi, ceny, rezerwacje i pobyty spoza puli; do legacy: nasze rezerwacje z puli, check-iny i checkouty, informacja o płatności | notatki, grill-me Q29 |
| BC-08 Payments (operator płatności) | nasza aplikacja (web, mobile) | gość przechodzi z naszej aplikacji na stronę operatora płatności i wraca z potwierdzeniem | potwierdzenie preautoryzacji | notatki |
| Smart locki (system zewnętrzny) | Pobyt (BC-04, BC-05) | adapter smart locków w Pobycie | wydanie i unieważnienie kluczy mobilnych | notatki |
| BC-06 Marketing | reszta systemu | tylko do odczytu dla reszty | oferta (zdjęcia, opisy, cechy) | notatki |

## Modules

| ID | Module | BC | Responsibility | FRs | Source |
|---|---|---|---|---|---|
| M-01 | Rezerwacje | BC-01 | ramka Rezerwacja razem z dostępnością i statusem pokoju, bo zablokowanie pokoju na noc musi być jedną transakcją; zadanie przydziału pokoju dzień przed przyjazdem | FR-01, FR-02, FR-03, FR-04, FR-05, FR-06, FR-09, FR-15, FR-16 | notatki, grill-me Q67, Q68 |
| M-02 | Housekeeping | BC-02, BC-03 | ramki Housekeeping i Servis tech razem, bo to ci sami ludzie, jedna kolejka i ten sam priorytet; API dla urządzeń przy wózkach | FR-11, FR-12, FR-13, FR-14, FR-17 | notatki |
| M-03 | Pobyt | BC-04, BC-05 | ramki Visit i Faraway razem, bo to początek i koniec tego samego pobytu; adapter smart locków, który wydaje i unieważnia klucze mobilne; konfiguracja powiązania zamka z pokojem; generuje co 15 minut listę awaryjną dla recepcji z kopii danych z Rezerwacji, więc nie czyta cudzego schematu | FR-10, FR-18 | notatki, grill-me Q66, Q68 |
| M-04 | Synchronizacja | BC-07 | ramka Synchronizacja, czyli import i eksport plików z legacy | FR-07, FR-08, FR-19 | notatki |
| M-05 | Oferta | BC-06 | ramka Marketing, tylko do odczytu dla reszty; pokazywanie zdjęć, planów pięter i cech pokoi do wyboru | _Brak w notatkach._ | notatki |

## Open Questions

_Brak w notatkach._
