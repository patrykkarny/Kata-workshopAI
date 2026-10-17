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
