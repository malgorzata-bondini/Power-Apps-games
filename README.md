# 🎰 Power Apps games

Dwie aplikacje canvas dla Power Apps. Obie stoją na tym samym pomyśle — **nie zastanawiaj się, wylosuj** — i obie trzymają dane na listach SharePoint.

| Aplikacja | Do czego | Kod |
|---|---|---|
| 🎞️ **Kartoteka** | Losuje film ze 130 polskich klasyków, pokazuje kartę z plakatem i zbiera oceny oraz recenzje. | [`kartoteka/`](kartoteka/) |
| 🎡 **Koło Fortuny** | Koło losuje kategorię, z niej leci pytanie „A czy B", a do pytania — osoba, która odpowiada. | [`kolo-fortuny/`](kolo-fortuny/) |

---

## 🎞️ Kartoteka

![Kartoteka — ekran główny z wylosowanym filmem](docs/kartoteka.png)

*Bo od trzydziestu minut scrollujesz Netflixa i dalej nic.*

Ustawiasz nastrój, klikasz **Losuj**, tytuły migają jak w automacie i wypada TEN jeden. Karta pokazuje rok, reżysera, czas trwania, sławny cytat albo scenę, którą się pamięta, i plakat. Losowanie nie powtarza tytułu, dopóki nie przejdzie całej puli.

Do tego warstwa społeczna, której nie ma wersja streamlitowa: **gwiazdki i recenzje**. Kliknięcie w gwiazdki prowadzi do cudzych recenzji, jeśli film ma już oceny, albo od razu do formularza, jeśli nikt go jeszcze nie ocenił.

**Trzy ekrany:** `MovieApp` (losowanie), `EkranOcen` (formularz oceny), `EkranRecenzji` (galeria recenzji).
**Lista SharePoint:** `Recenzje`.

---

## 🎡 Koło Fortuny

![Koło Fortuny — koło i wylosowane pytanie](docs/kolo-fortuny.png)

*Na spotkanie zespołu, kiedy nikt nie chce zaczynać.*

Kręcisz kołem, koło zwalnia i staje na kategorii, a z tej kategorii wypada pytanie typu „kawa czy herbata", „biuro czy home office", „pizza z ananasem czy bez". Jeśli wybrałaś uczestników, losuje się też osoba, która ma odpowiedzieć — i ta sama nie wypadnie trzy razy pod rząd.

Koło jest zbudowane **w całości z CSS**: `conic-gradient` na segmenty, `transform: rotate()` na obrót, dwadzieścia pozycjonowanych kółek na żarówki. Nie ma tu ani jednego SVG, bo `HtmlViewer` wycina je bez śladu.

**Trzy ekrany:** `Wybory` (koło i pytanie), `WyborOsob` (wybór uczestników), `DodajPytanie` (dorzucanie własnych pytań).
**Listy SharePoint:** `Pytania Koło Fortuny`, `Team Members`.

---

## Co jest w każdym folderze

```
<aplikacja>/
├── README.md            opis ekranów, kolekcji, schematu list i decyzji projektowych
├── App.OnStart.fx       treść właściwości OnStart obiektu App
├── screens/*.pa.yaml    po jednym pliku na ekran, format Source Code
├── sharepoint/*.xlsx    arkusze do zaimportowania jako listy
├── media/               grafiki i dźwięki + tabela, gdzie się je podpina
└── tools/               (tylko Kartoteka) skrypty budujące listę plakatów z TMDB
```

## Jak wgrać to do Power Apps

Studio nie importuje całej aplikacji z plików tekstowych, ale **przyjmuje pojedyncze ekrany przez schowek**:

1. Podepnij listy SharePoint (**Data → Add data**) — bez tego formuły odwołujące się do nich zaświecą na czerwono.
2. Wklej `App.OnStart.fx` do właściwości `OnStart` obiektu `App`, potem **prawy klik na `App` → Run OnStart**.
3. Dla każdego ekranu: **New screen → Blank**, zmień nazwę na tę z pliku, kliknij w tło ekranu i **Ctrl+V**.
4. Wgraj pliki z `media/` przez panel **Media** i sprawdź kontrolki, które ich używają.

### Trzy pułapki, które kosztowały najwięcej czasu

1. **W pasku formuły nie wpisuje się `=`.** W plikach YAML każda właściwość ma prefiks `=`, bo tak wymaga format. Wklejenie go do Studia daje `expected operator`.
2. **W YAML-u nie może być spacji po dwukropku wewnątrz rekordu.** `{Imie: x}` w jednoliniowej właściwości parser czyta jako zagnieżdżoną mapę i wywala `YamlInvalidSyntax`. Piszemy `{Imie:x}` albo przenosimy formułę do bloku `|-`.
3. **Właściwość `HtmlText` musi być jedną linią** wewnątrz bloku `|-`. Rozbicie na wiele linii nie zgłasza błędu — kontrolka po prostu renderuje pustkę.

### Wersje kontrolek

Pliki odwołują się do konkretnych wersji: `HtmlViewer@2.1.0`, `Classic/Button@2.2.0`, `Classic/TextInput@2.3.2`, `Classic/ComboBox@2.4.0`, `Classic/DropDown@2.3.1`, `Classic/Icon@2.5.0`, `Label@2.5.1`, `Image@2.2.3`, `Timer@2.1.0`, `Audio@2.3.1`, `Rating@2.1.0`, `Gallery@2.15.0`. Galeria potrzebuje jeszcze wiersza `Variant` — `Vertical` albo `VariableHeight`. Nieznana wersja lub wariant kończy się błędem `PA2109` przy wklejaniu.

### Czego HtmlViewer nie renderuje

Kontrolka przepuszcza `div`, `border-radius`, `box-shadow`, `conic-gradient`, `transform`, `position:absolute`, `flex`, a nawet `@keyframes` w bloku `<style>`. **Wycina za to `<svg>`** — cała zawartość znika bez błędu i bez śladu. Stąd koło z gradientów zamiast z wektorów. Fajerwerki po wylosowaniu pytania to obejście: osobna kontrolka `Image` z SVG zakodowanym jako `data:` URI, bo tam trafia jako obrazek, nie jako kod strony.

---

## Dane przykładowe

Wszystkie nazwiska w arkuszach są **zmyślone** — Pierogowska, Kompotowski, Zapiekanko. To repozytorium nie zawiera danych prawdziwych osób. Podmień je na swoje dopiero u siebie na SharePoincie.

## O obrazkach w tym README

Podglądy w `docs/` to **makiety wyrenderowane w przeglądarce z tego samego CSS-u, którego używają aplikacje** — kolory, czcionki, geometria koła i układ karty są jeden do jednego. Nie są to zrzuty z działającego Studia, więc plakat filmu jest zastąpiony placeholderem, a koło stoi w pozycji spoczynkowej.

---

*Streamlitowa wersja Kartoteki mieszka osobno, w [movie-app](https://github.com/malgorzata-bondini/movie-app).*
