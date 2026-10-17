# Model C4: Room with a View

Jedno źródło prawdy: `workspace.dsl` (Structurizr DSL). Obrazków nie rysujemy ręcznie, generujemy je z modelu. Nazwy serwisów i decyzje bierzemy z `zadanie/notatki.md`.

## Widoki

| Widok | Co pokazuje |
|---|---|
| `C1-SystemContext` | system, gość, personel hotelu, housekeeping i systemy zewnętrzne (legacy z Payments, smart locki w etapie 2, Identity Provider) |
| `C2-Containers` | pełny widok kontenerów: 3 aplikacje, 5 serwisów, wspólna baza PostgreSQL, magazyn plików (zdjęcia i lista awaryjna recepcji) |
| `C2-Slide` | uproszczony C2 na slajd: bez strzałek do bazy, bez Identity Provider, magazynu zdjęć i pushy WebSocket |
| `D1-KeyFlow` | rezerwacja konkretnego pokoju: blokada na noc (10 min), potwierdzenie i płatność w legacy, priorytety sprzątania |
| `D2-Checkout` | checkout aż do pokoju gotowego dla następnego gościa |
| `D3-LegacyDown` | legacy nie odpowiada: rezerwacja czeka w outboxie, checkout i sprzątanie działają dalej |

Serwisy i ramki z tablicy: Rezerwacje (Rezerwacja + dostępność i status pokoju), Housekeeping (Housekeeping + Servis tech), Pobyt (Visit + Faraway), Synchronizacja (legacy, w tym Payments), Oferta (Marketing).

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

Klucz do oznaczeń (kolory, linie przerywane, „phase 2”) jest w `out/LEGEND.md`, generowany przy każdym renderze.
