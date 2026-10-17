# Domain: Room with a View

Status: Draft  
Updated: 2026-10-17  
Authors: Zespół White (Marek, Patryk, Mariusz, Kamil)  
Miro: brak linku; zrzut tablicy: `event-storming/kata-white.png`

## Bounded Contexts

### BC-01 Rezerwacja (core)

- Responsibility: zapytanie o dostępność, wymagania i życzenia gościa, rezerwacja typu albo konkretnego pokoju, zdjęcie dostępności; wszystkie kanały (web, mobile, telefon, walk-in) przez jedno API (FR-03); jedyne miejsce, które wie, czy pokój jest wolny danej nocy, w jakim jest stanie i kiedy będzie potrzebny (FR-05); jedyne miejsce, które może zająć pokój na noc.
- Key events: Zapytano o dostępność, Zebrano wymagania, Zamówione ekstra elementy do pokoju na pobyt, Sprawdzono dostępność pokoi zgodnie z wymaganiami, Zarezerwowano pokój, Dostarczenie listy życzeń do pokoju, Dostosowano pokój do ekstra wymagań, Zdjęta dostępność pokoju.
- Commands & policies: FR-02, FR-06, FR-09, FR-16; aktorzy na ramce: Sales, Guest, Recepcja.
- Language: „dostępny”: wolny do sprzedaży (inny stan niż „gotowy”); „pokój”: noce i status; „życzenie”: także obietnica handlowca zapisana w rezerwacji.
- Owns data: dostępność pokoju na noc, status pokoju, kiedy pokój będzie potrzebny.
- Hotspots: _Brak w notatkach._
- Source: Miro: Rezerwacja, notatki, grill-me Q1, Q15, Q18, Q34, Q36

### BC-02 Housekeeping (core)

- Responsibility: zlecenia sprzątania, przydział osoby, pokój gotowy do sprzątania, wysprzątany, gotowy dla gościa.
- Key events: Otrzymaliśmy zlecenie sprzątania pokoju, Przydzielono osobę sprzątającą / wysłano powiadomienie, Klucz mobilny przydzielony, Pokój gotowy do sprzątania, Pokój wysprzątano, Klucz mobilny unieważniony, Pokój gotowy dla gościa.
- Commands & policies: FR-12, FR-14; aktor na ramce: Housekeeper.
- Language: „gotowy”: posprzątany (inny stan niż „dostępny”); „pokój”: zadania.
- Owns data: zadania (zlecenia sprzątania).
- Hotspots: _Brak w notatkach._
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

- Responsibility: standard, cechy, zdjęcia, ID zamka i udostępnienie oferty; zdjęcia i opisy dostajemy gotowe.
- Key events: Ustalono nowe ceny per typ, Dodano cechy, Dodano zdjęcia, Ustalono standard, Zdefiniowano ceny w okres czasu, Przydzielono ID zamka, Udostępniono ofertę.
- Commands & policies: aktor na ramce: Marketing.
- Language: „pokój”: zdjęcia (oferta).
- Owns data: zdjęcia i opisy pokoi.
- Hotspots: _Brak w notatkach._
- Source: Miro: Marketing, notatki, grill-me Q34, Q36

### BC-07 Synchronizacja (supporting)

- Responsibility: jedyne miejsce, które rozmawia z legacy: pre-rezerwacje i pula, rezerwacje, płatności, ceny, raporty check-in i checkout, porównanie danych; legacy schowane za Synchronizacją, żeby jego model nie wyciekał do reszty systemu.
- Key events: Wystawiono Raport check in / check out, Zaczytano Raport check in / check out legacy, System legacy zsynchronizowany, System modern zsynchronizowany.
- Commands & policies: komenda: Nadpisz pre-rezerwacje; FR-07, FR-08, FR-17, FR-19; aktor na ramce: System.
- Language: „pre-rezerwacja”: blokada pokoju w legacy dla naszej puli.
- Owns data: _Brak w notatkach._
- Hotspots: _Brak w notatkach._
- Source: Miro: Synchronizacja, notatki, grill-me Q3

### BC-08 Payments (generic)

- Responsibility: płatności; rejestrację płatności i zwroty robi legacy, my tylko wysyłamy żądanie przez Synchronizację.
- Key events: Pobyt opłacono, Zarejestrowano płatność, Zwrócono pieniądze.
- Commands & policies: aktor na ramce: Guest.
- Language: _Brak w notatkach._
- Owns data: _Brak w notatkach._
- Hotspots: _Brak w notatkach._
- Source: Miro: Payments, notatki

## Context Map

| Upstream | Downstream | Relationship | What flows | Source |
|---|---|---|---|---|
| BC-01 Rezerwacja | BC-04 Visit | Rezerwacja jako jedyna zajmuje pokój na noc; Visit prosi ją o zmianę | zmiana stanu pokoju | notatki |
| BC-01 Rezerwacja | BC-05 Faraway | Rezerwacja jako jedyna zajmuje pokój na noc; Faraway prosi ją o zmianę | zmiana stanu pokoju | notatki |
| BC-05 Faraway | BC-02 Housekeeping | po checkoucie Faraway wysyła zlecenie | zlecenie sprzątania | notatki |
| BC-01 Rezerwacja | BC-02 Housekeeping | Rezerwacja mówi, na kiedy pokój ma być gotowy; z tego liczymy priorytet | termin gotowości pokoju | notatki |
| BC-02 Housekeeping | BC-01 Rezerwacja | Housekeeping mówi, że pokój jest gotowy | pokój gotowy | notatki |
| BC-03 Servis tech | BC-01 Rezerwacja | Servis tech mówi, że pokój jest gotowy albo ma usterkę | pokój gotowy, usterka | notatki |
| Legacy (system zewnętrzny) | BC-07 Synchronizacja | legacy schowane za Synchronizacją, żeby jego model nie wyciekał | pre-rezerwacje i pula, rezerwacje, płatności, ceny, raporty check-in i checkout, porównanie danych | notatki |
| BC-08 Payments | BC-07 Synchronizacja | Synchronizacja wysyła żądania do Payments (legacy) | żądanie płatności, zwrotu | notatki |
| BC-06 Marketing | reszta systemu | tylko do odczytu dla reszty | oferta (zdjęcia, opisy, cechy) | notatki |

## Modules

| ID | Module | BC | Responsibility | FRs | Source |
|---|---|---|---|---|---|
| M-01 | Rezerwacje | BC-01 | ramka Rezerwacja razem z dostępnością i statusem pokoju, bo zablokowanie pokoju na noc musi być jedną transakcją | _Brak w notatkach._ | notatki |
| M-02 | Housekeeping | BC-02, BC-03 | ramki Housekeeping i Servis tech razem, bo to ci sami ludzie, jedna kolejka i ten sam priorytet; API dla urządzeń przy wózkach | _Brak w notatkach._ | notatki |
| M-03 | Pobyt | BC-04, BC-05 | ramki Visit i Faraway razem, bo to początek i koniec tego samego pobytu; w etapie 2 klucze mobilne | _Brak w notatkach._ | notatki |
| M-04 | Synchronizacja | BC-07, BC-08 | ramka Synchronizacja i wywołania do Payments, z kolejką na czas awarii legacy | _Brak w notatkach._ | notatki |
| M-05 | Oferta | BC-06 | ramka Marketing, tylko do odczytu dla reszty | _Brak w notatkach._ | notatki |

## Open Questions

_Brak w notatkach._
