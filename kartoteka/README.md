# Kartoteka (Power Apps)

Ta sama kartoteka co w [wersji streamlitowej](https://github.com/malgorzata-bondini/movie-app), przeniesiona na canvas app: losowanie filmu z puli, karta z plakatem, a do tego to, czego Streamlit nie miał — **oceny i recenzje zapisywane na SharePoincie**.

![Kartoteka — ekran główny](../docs/kartoteka.png)

## Ekrany

| Ekran | Rola |
|---|---|
| `MovieApp` | Ekran główny: filtry nastrojów, przycisk **Losuj**, karta filmu, gwiazdki ze średnią oceną. |
| `EkranOcen` | Formularz oceny: wybór tytułu, gwiazdki, treść recenzji, zapis do listy. |
| `EkranRecenzji` | Galeria cudzych recenzji dla wylosowanego filmu. |

Przejścia: gwiazdki na `MovieApp` prowadzą do `EkranRecenzji`, jeśli film ma już recenzje, a do `EkranOcen`, jeśli nie ma żadnej.

## Lista SharePoint

Jedna lista, **`Recenzje`**, pięć kolumn:

| Kolumna | Typ | Zawartość |
|---|---|---|
| `Title` | Jeden wiersz tekstu | Tytuł filmu, czytelny dla człowieka |
| `FilmId` | Jeden wiersz tekstu | Klucz w formacie `Tytuł\|Rok`, np. `Dzień świra\|2002` |
| `Ocena` | Liczba | 1–5 |
| `Recenzja` | Wiele wierszy tekstu | Może być pusta — karta pokazuje wtedy „Bez słowa komentarza” |
| `Autor` | Jeden wiersz tekstu | `User().FullName` osoby oceniającej |

Plik [`sharepoint/Recenzje.xlsx`](sharepoint/Recenzje.xlsx) ma te nagłówki i 20 przykładowych wierszy do rozruchu. Import: **Nowa lista → Z programu Excel**. Kolumny `ID` w pliku nie ma, bo SharePoint nadaje ją sam.

**Dlaczego `FilmId`, a nie sam tytuł.** W bazie są dwa różne *Znachory* (1937 i 1982) i dwa *Wesela* (1972 i 2004). Sam tytuł skleiłby ich oceny w jedną kupę.

## Skąd biorą się plakaty

**Nie z API w czasie działania aplikacji.** Adresy plakatów zostały pobrane **raz, skryptem offline** odpytującym TMDB, i wpisane na sztywno do kolekcji `colPlakaty` w `App.OnStart` — 130 rekordów `{FilmId, Url}`.

W aplikacji plakat trafia po prostu do atrybutu `src` obrazka wewnątrz `HtmlViewer`:

```
LookUp(colPlakaty As p, p.FilmId = gblPick.FilmId, p.Url)
```

Obrazek pobiera potem przeglądarka bezpośrednio z `image.tmdb.org`. Konsekwencje takiego rozwiązania:

- **żadnego konektora ani klucza API** w aplikacji — nie ma czego konfigurować ani co wyciec;
- **zero opóźnienia i zero limitów** — nie ma zapytania, które mogłoby się nie powieść;
- ale też **nic się samo nie zaktualizuje** — nowy film w bazie oznacza ponowne uruchomienie skryptu, a gdyby TMDB kiedyś przestawiło ścieżki plików, plakaty przestałyby się ładować.

### Skrypty, które tę listę budują

W [`tools/`](tools/) leżą dwa skrypty, każdy z jednym zadaniem. Uruchamiasz je tylko wtedy, gdy dopiszesz filmy do bazy.

**1. [`pobierz_plakaty.py`](tools/pobierz_plakaty.py)** — jedyne miejsce, które rozmawia z TMDB. Czyta `filmy.xlsx` (kolumny `Tytuł`, `Rok`), odpytuje wyszukiwarkę TMDB i zapisuje `plakaty.xlsx`:

| Tytuł | Rok | FilmId | Plakat |
|---|---|---|---|
| Piętro wyżej | 1937 | `Piętro wyżej\|1937` | `https://image.tmdb.org/t/p/w300/tfqRi3gf…jpg` |

```bash
export TMDB_API_KEY="twoj_klucz"
python tools/pobierz_plakaty.py --zrodlo filmy.xlsx --wynik plakaty.xlsx
```

Klucz czytany jest ze zmiennej środowiskowej, **nigdy z kodu** — dzięki temu nie da się go przypadkiem wypchnąć do repozytorium. Zakładasz go za darmo na [themoviedb.org/settings/api](https://www.themoviedb.org/settings/api).

Każdy tytuł jest szukany dwa razy: najpierw z rokiem produkcji, potem bez. Polskie filmy przedwojenne bywają w TMDB z rozjechaną datą i bez tej drugiej próby wypadałyby z listy. Filmy, dla których nic się nie znalazło, skrypt wypisuje na końcu — możesz uzupełnić je ręcznie w arkuszu albo zostawić puste, bo karta radzi sobie bez plakatu.

**2. [`zbuduj_colplakaty.py`](tools/zbuduj_colplakaty.py)** — nie rusza sieci. Przepisuje `plakaty.xlsx` na składnię Power Fx:

```bash
python tools/zbuduj_colplakaty.py --zrodlo plakaty.xlsx --wynik colPlakaty.txt
```

Na wyjściu dostajesz gotowy blok:

```
ClearCollect(colPlakaty,
    {FilmId: "Piętro wyżej|1937", Url: "https://image.tmdb.org/t/p/w300/tfqRi3gf…jpg"},
    ...
);
```

Wklejasz go do `App.OnStart` w miejsce starego `ClearCollect(colPlakaty, ...)` i robisz **Run OnStart**. Skrypt podwaja cudzysłowy w tytułach, bo tak Power Fx oznacza cudzysłów wewnątrz tekstu — bez tego jeden film z cytatem w tytule wywaliłby całe `OnStart`.

**Wymagania:** `pip install openpyxl`. Reszta to biblioteka standardowa Pythona.

## Kolekcje w `App.OnStart`

| Kolekcja / zmienna | Do czego służy |
|---|---|
| `colFilms` | 130 filmów: metadane, cytat albo scena, klucze filtrów `DekadaKey` i `DlugoscKey` |
| `colPlakaty` | Mapa `FilmId` → adres plakatu |
| `colPool` | Aktualna pula po nałożeniu filtra nastroju |
| `colSeen` | Co już wypadło — losowanie nie powtarza, dopóki nie wyczerpie puli |
| `colFilmyAZ` | Posortowana lista `Tytuł (Rok)` dla ComboBoxa na ekranie oceny |
| `colRecenzje` | Kopia listy SharePoint, żeby liczenie średniej nie biło co chwilę po źródle |
| `gblPick`, `gblFlickFilm`, `gblSpinLeft` | Wylosowany film, film migający w trakcie animacji, licznik klatek |

## Dwie sztuczki warte zapamiętania

**Animacja losowania** to `Timer` z `Duration: 180` i `Repeat`. Przy każdym tyknięciu podmienia `gblFlickFilm` na losowy tytuł z puli i zmniejsza `gblSpinLeft`. Karta pokazuje `gblFlickFilm`, dopóki licznik jest większy od zera, potem przełącza się na właściwy wynik. Tytuł w trakcie migania jest wyszarzony, więc widać, że to jeszcze nie werdykt.

**Wyszukiwanie w ComboBoxie po początku tytułu.** Domyślnie ComboBox szuka metodą „zawiera”, więc wpisanie `ana` podpowiadało *Kanał*. Filtrowanie po `StartsWith` w `Items`, z odwołaniem kontrolki do własnej właściwości `SearchText`, daje podpowiedzi od pierwszej litery tytułu:

```
If(IsBlank(ListaFilmów.SearchText), colFilmyAZ,
   Filter(colFilmyAZ, StartsWith(Etykieta, ListaFilmów.SearchText)))
```

## Zasoby multimedialne

Ekrany odwołują się do dwóch plików wgranych w Studiu przez **Media**: `giphy (6)` (animacja przy losowaniu) i `cat popcorn` (kot na ekranie oceny). Same pliki i instrukcja podpięcia leżą w [`media/`](media/) — Power Apps nie eksportuje ich przez schowek YAML, więc do kodu trafia sama nazwa odwołania. Po wklejeniu ekranów te właściwości świecą na czerwono, dopóki nie wgrasz plików.

## Dane przykładowe

Nazwiska w [`sharepoint/Recenzje.xlsx`](sharepoint/Recenzje.xlsx) są **zmyślone** — to nie są prawdziwe osoby. Podmień je na swoje dopiero u siebie na SharePoincie.
