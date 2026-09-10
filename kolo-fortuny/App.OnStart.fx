// ============================================
// KOŁO FORTUNY - App.OnStart
// ============================================

ClearCollect(colKolo,
{Nr:1, Temat:"Jedzenie", Sx:0.30902, Cy:0.95106, Kat:-72},
{Nr:2, Temat:"Popkultura", Sx:0.80902, Cy:0.58779, Kat:-36},
{Nr:3, Temat:"Praca", Sx:1, Cy:0, Kat:0},
{Nr:4, Temat:"Styl życia", Sx:0.80902, Cy:-0.58779, Kat:36},
{Nr:5, Temat:"Otwarte", Sx:0.30902, Cy:-0.95106, Kat:72},
{Nr:6, Temat:"Jedzenie", Sx:-0.30902, Cy:-0.95106, Kat:-72},
{Nr:7, Temat:"Popkultura", Sx:-0.80902, Cy:-0.58779, Kat:-36},
{Nr:8, Temat:"Praca", Sx:-1, Cy:0, Kat:0},
{Nr:9, Temat:"Styl życia", Sx:-0.80902, Cy:0.58779, Kat:36},
{Nr:10, Temat:"Otwarte", Sx:-0.30902, Cy:0.95106, Kat:72}
);

ClearCollect(colZarowki,
{Nr:1, Sx:0, Cy:1},
{Nr:2, Sx:0.30902, Cy:0.95106},
{Nr:3, Sx:0.58779, Cy:0.80902},
{Nr:4, Sx:0.80902, Cy:0.58779},
{Nr:5, Sx:0.95106, Cy:0.30902},
{Nr:6, Sx:1, Cy:0},
{Nr:7, Sx:0.95106, Cy:-0.30902},
{Nr:8, Sx:0.80902, Cy:-0.58779},
{Nr:9, Sx:0.58779, Cy:-0.80902},
{Nr:10, Sx:0.30902, Cy:-0.95106},
{Nr:11, Sx:0, Cy:-1},
{Nr:12, Sx:-0.30902, Cy:-0.95106},
{Nr:13, Sx:-0.58779, Cy:-0.80902},
{Nr:14, Sx:-0.80902, Cy:-0.58779},
{Nr:15, Sx:-0.95106, Cy:-0.30902},
{Nr:16, Sx:-1, Cy:0},
{Nr:17, Sx:-0.95106, Cy:0.30902},
{Nr:18, Sx:-0.80902, Cy:0.58779},
{Nr:19, Sx:-0.58779, Cy:0.80902},
{Nr:20, Sx:-0.30902, Cy:0.95106}
);

ClearCollect(colPytania,
    ForAll(
        'Pytania Koło Fortuny' As r,
        {
            Id: Text(r.ID),
            Temat: r.Title,
            A: r.OpcjaA,
            B: Coalesce(r.OpcjaB, ""),
            Intro: Coalesce(r.Intro, "")
        }
    )
);

ClearCollect(colWidziane, {Id:"", Temat:""});
Clear(colWidziane);

ClearCollect(colOsoby, ForAll('Team Members' As o, {Imie: o.Title}));
ClearCollect(colGracze, {Imie:""}); Clear(colGracze);

Set(gblPytanie, First(colPytania));
Set(gblMaPytanie, false);
Set(gblTemat, "");
Set(gblIdx, 0);
Set(gblKat, 0);
Set(gblKat0, 0);
Set(gblKatCel, 0);
Set(gblKrecenie, false);
Set(gblIle, 0);
Set(gblOsoba, "");
Set(gblNowa, "");
Set(gblPowtorka, 0)
