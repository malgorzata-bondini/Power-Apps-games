"""Zamienia arkusz z adresami plakatów na kolekcję Power Fx do wklejenia.

Wejście:  plakaty.xlsx, kolumny "FilmId" i "Plakat" (wynik pobierz_plakaty.py).
Wyjście:  colPlakaty.txt — gotowy blok ClearCollect do App.OnStart.

Ten skrypt nie rusza sieci. Jego jedyne zadanie to przepisanie arkusza
na składnię Power Fx i zadbanie o cudzysłowy w tytułach.

Użycie:
    python zbuduj_colplakaty.py [--zrodlo plakaty.xlsx] [--wynik colPlakaty.txt]
"""

from __future__ import annotations

import argparse

import openpyxl


def escape(t: str) -> str:
    """W Power Fx cudzysłów wewnątrz tekstu podwaja się."""
    return t.replace('"', '""')


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--zrodlo", default="plakaty.xlsx")
    ap.add_argument("--wynik", default="colPlakaty.txt")
    a = ap.parse_args()

    ws = openpyxl.load_workbook(a.zrodlo).active
    naglowki = [str(c.value).strip() if c.value else "" for c in ws[1]]
    i_id, i_url = naglowki.index("FilmId"), naglowki.index("Plakat")

    wiersze = []
    pominiete = 0
    for w in ws.iter_rows(min_row=2, values_only=True):
        film_id, url = w[i_id], w[i_url]
        if not film_id:
            continue
        if not url:                                 # bez adresu nie ma czego wpisywać
            pominiete += 1
            continue
        wiersze.append(
            f'    {{FilmId: "{escape(str(film_id))}", Url: "{escape(str(url))}"}}'
        )

    blok = "ClearCollect(colPlakaty,\n" + ",\n".join(wiersze) + "\n);\n"
    with open(a.wynik, "w", encoding="utf-8") as f:
        f.write(blok)

    print(f"Zapisano {a.wynik}: {len(wiersze)} plakatów.")
    if pominiete:
        print(f"Pominięto {pominiete} wierszy bez adresu.")
    print("\nWklej zawartość pliku do App.OnStart w miejsce starego ClearCollect(colPlakaty, ...),")
    print("potem prawy klik na App → Run OnStart.")


if __name__ == "__main__":
    main()
