# Media — Koło Fortuny

Power Apps nie eksportuje zasobów Media przez schowek YAML: do kodu ekranu trafia
sama nazwa odwołania, plik zostaje w środku aplikacji. Dlatego plik leży tutaj
osobno.

| Plik | Nazwa zasobu w Studio | Gdzie jest używany |
|---|---|---|
| `Spin1.mp3` | `Spin1` | `Wybory` → kontrolka `SpinSound` → `Media` |

Dźwięk startuje i zatrzymuje się razem z kołem: `Start: =gblKrecenie`,
`Reset: =!gblKrecenie`. Kontrolka jest niewidoczna i ma rozmiar 1×1 px.

**Nazwa pliku ma znaczenie.** Power Apps nadaje zasobowi nazwę na podstawie nazwy
wgranego pliku (bez rozszerzenia). Wgranie `Spin1.mp3` daje zasób `Spin1` i
formuła z YAML-a zadziała bez zmian.

## Jak podpiąć

1. W Power Apps Studio: **Wstaw → Multimedia** albo panel **Media** w drzewie zasobów.
2. **Przekaż** plik.
3. Sprawdź kontrolkę `SpinSound` — jeśli `Media` świeci na czerwono, wybierz zasób z listy.

## Jak wyciągnąć ten plik z istniejącej aplikacji

**Plik → Zapisz jako → Ten komputer** daje plik `.msapp`. Zmień rozszerzenie na
`.zip`, rozpakuj i wejdź do folderu `Assets`. Nazwy plików są tam GUID-ami —
dźwięk poznasz po rozszerzeniu.
