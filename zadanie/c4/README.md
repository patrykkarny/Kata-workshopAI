# Model C4: Room with a View

Jedno źródło prawdy: `workspace.dsl` (Structurizr DSL). Obrazków nie rysujemy ręcznie, generujemy je z modelu. Nazwy serwisów i decyzje bierzemy z `zadanie/notatki.md`.

## Widoki

| Widok | Co pokazuje |
|---|---|
| `C1-SystemContext` | system, gość, personel hotelu, housekeeping i systemy zewnętrzne (legacy przez pliki co 15 min, operator płatności, smart locki, Identity Provider) |
| `C2-Containers` | pełny widok kontenerów: 3 aplikacje, 5 serwisów, wspólna baza PostgreSQL, magazyn plików (zdjęcia i lista awaryjna recepcji) |
| `C2-Slide` | uproszczony C2 na slajd: bez strzałek do bazy, bez Identity Provider, magazynu plików, pushy WebSocket, zdarzeń z przyjazdami Rezerwacje → Pobyt, przekierowania z aplikacji gościa do operatora płatności, prośby o klucz dla housekeepera i aktorów z personelu (są na C1) |
| `D1-KeyFlow` | rezerwacja konkretnego pokoju: blokada na noc (10 min), preautoryzacja u operatora płatności, potwierdzenie webhookiem, priorytety sprzątania, rezerwacja trafia do legacy w następnym pliku |
| `D2-Checkout` | checkout aż do pokoju gotowego dla następnego gościa, z unieważnieniem klucza mobilnego |
| `D3-LegacyDown` | legacy leży albo nie przyszedł plik: rezerwacja, checkout i sprzątanie działają dalej, Synchronizacja alarmuje, checkouty spoza puli recepcja wpisuje ręcznie, następny plik nadrabia zaległości |

Serwisy i ramki z tablicy: Rezerwacje (Rezerwacja + dostępność i status pokoju), Housekeeping (Housekeeping + Servis tech), Pobyt (Visit + Faraway, adapter smart locków), Synchronizacja (wymiana plików z legacy), Oferta (Marketing).

## Renderowanie

Z głównego katalogu repozytorium:

```
./zadanie/c4/render.sh
```

Skrypt waliduje DSL i zapisuje widoki do `zadanie/c4/out/`: `png/`, `svg/`, `mermaid/` i `mermaid-plain/` (do wklejenia w Miro albo na mermaid.live). Potrzebna Java 21+ i Node (npx). Za pierwszym razem pobiera Structurizr (ok. 210 MB) do `~/.cache/structurizr`.

## Widok interaktywny

Prawdziwe kształty C4 i ręczne przesuwanie elementów:

```
java -Dserver.port=8099 -jar ~/.cache/structurizr/structurizr-2026.09.19.war local "$PWD/zadanie/c4"
```

Potem http://localhost:8099. Structurizr zapisuje układ w `workspace.json` i `.structurizr/`, oba są w `.gitignore`.

## Legenda

Klucz do oznaczeń (kolory, linie przerywane) jest w `out/LEGEND.md`, generowany przy każdym renderze.
