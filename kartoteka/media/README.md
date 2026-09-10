# Media — Kartoteka

Power Apps nie eksportuje zasobów Media przez schowek YAML: do kodu ekranu trafia
sama nazwa odwołania, plik zostaje w środku aplikacji. Dlatego pliki leżą tutaj
osobno.

| Plik | Nazwa zasobu w Studio | Gdzie jest używany |
|---|---|---|
| `giphy (6).gif` | `giphy (6)` | `MovieApp` → kontrolka `movie` → `Image` |
| `cat popcorn.gif` | `cat popcorn` | `EkranOcen` → kontrolka `Kot` → `Image` |

**Nazwy plików mają znaczenie.** Power Apps nadaje zasobowi nazwę na podstawie
nazwy wgranego pliku (bez rozszerzenia). Jeśli wgrasz `giphy (6).gif`, zasób
nazwie się `giphy (6)` i formuła z YAML-a zadziała bez zmian. Wgranie pliku pod
inną nazwą wymaga poprawienia właściwości `Image` w Studio.

## Jak podpiąć

1. W Power Apps Studio: **Wstaw → Multimedia** albo panel **Media** w drzewie zasobów.
2. **Przekaż** oba pliki.
3. Sprawdź kontrolki `movie` i `Kot` — jeśli świecą na czerwono, wybierz zasób z listy.

## Jak wyciągnąć te pliki z istniejącej aplikacji

**Plik → Zapisz jako → Ten komputer** daje plik `.msapp`. Zmień rozszerzenie na
`.zip`, rozpakuj i wejdź do folderu `Assets`. Nazwy plików są tam GUID-ami, więc
rozpoznaj je po podglądzie i rozszerzeniu.
