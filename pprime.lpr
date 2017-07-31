program pprime;

uses
  DateUtils,
  SysUtils;

const
  MAX_DELKA = 400;
  MAX_DELKA_PRVOCISLA = 200;

type
  dlouheCislo = array [1..MAX_DELKA] of byte;
type
  cisloT = record
    cislo: dlouheCislo;
    delka: integer;
    isNegative: boolean;
  end;
type
  vysledekFaktorizace = record
    exponent: integer;
    zbytek: cisloT;
  end;
type
  vysledekDeleni = record
    vysl: cisloT;
    zbytek: byte;
  end;
type
  vysledekDeleni2 = record
    quot: cisloT;
    rem: cisloT;
  end;


  procedure vypisCislo(c: cisloT);
  var
    i: integer;
  begin
    writeln;
    writeln('delka : ', c.delka);
    for i := 1 to c.delka do
    begin
      if (c.cislo[i] > 9) then
        Write(' ');
      Write(c.cislo[i]);
      if (c.cislo[i] > 9) then
        Write(' ');
    end;
    writeln;
    writeln;
  end;

  function generujPrvocislo(delka: byte): cisloT;
  var
    p: cisloT;
  var
    i: byte;
  var
    lichaCisla: array[1..5] of byte = (1, 3, 5, 7, 9);
  begin
    p.cislo[1] := Random(9) + 1;
    for i := 2 to delka do
    begin
      if (i <> delka) then
        p.cislo[i] := Random(10)
      else
        p.cislo[delka] := lichaCisla[Random(5) + 1];
    end;
    p.delka := delka;
    generujPrvocislo := p;
  end;

{
1 : c1>c2
0 : c1=c2
2 : c1<c2
musí byt ve formatu ze na cislo[1] je nejvyssi cifra a jde to dolů
}
  function porovnani(c1, c2: cisloT): byte;
  var
    i: integer;
  begin
    if (c1.delka > c2.delka) then
      porovnani := 1
    else
    begin
      if (c1.delka < c2.delka) then
        porovnani := 2
      else //stejna delka
      begin
        i := 1;
        while ((c1.cislo[i] = c2.cislo[i]) and (i <= MAX_DELKA)) do
          Inc(i);
        if (i = MAX_DELKA + 1) then
          porovnani := 0
        else
        begin
          if (c1.cislo[i] > c2.cislo[i]) then
            porovnani := 1
          else
            porovnani := 2;
        end;
      end;
    end;
  end;

{
1 : c1>c2
0 : c1=c2
2 : c1<c2
musí byt ve formatu ze na cislo[1] je nejmensi cifra
}
  function porovnani2(c1, c2: cisloT): byte;
  var
    i: integer;
  begin
    if (c1.delka > c2.delka) then
      porovnani2 := 1
    else
    begin
      if (c1.delka < c2.delka) then
        porovnani2 := 2
      else //stejna delka
      begin
        i := c1.delka;
        while ((c1.cislo[i] = c2.cislo[i]) and (i > 0)) do
          i := i - 1;
        if (i = 0) then
          porovnani2 := 0
        else
        begin
          if (c1.cislo[i] > c2.cislo[i]) then
            porovnani2 := 1
          else
            porovnani2 := 2;
        end;
      end;
    end;
  end;

  procedure vynuluj(var c: cisloT);
  var
    i: integer;
  begin
    for i := 1 to MAX_DELKA do
    begin
      if (i > c.delka) then
        c.cislo[i] := 0;
    end;
  end;

  function generujNahodneCislo(horniHranice: cisloT): cisloT;
  var
    i: byte;
  var
    nahodneCislo: cisloT;
  begin
    repeat
      nahodneCislo.delka := Random(horniHranice.delka) + 1;
      nahodneCislo.cislo[1] := Random(9) + 1;
      for i := 2 to nahodneCislo.delka do
      begin
        nahodneCislo.cislo[i] := Random(10);
      end;
    until ((porovnani(horniHranice, nahodneCislo) = 1) and
        ((nahodneCislo.delka > 1) or (nahodneCislo.cislo[1] > 1))); //2<=n<hodniHranice
    generujNahodneCislo := nahodneCislo;
  end;

  function otocCislo(c: cisloT): cisloT;
  var
    zac, kon, temp: integer;

  begin
    zac := 1;
    kon := c.delka;
    while (zac < kon) do
    begin
      temp := c.cislo[zac];
      c.cislo[zac] := c.cislo[kon];
      c.cislo[kon] := temp;
      Inc(zac);
      kon := kon - 1;
    end;
    otocCislo := c;
  end;

  function secti(c1, c2: cisloT; otoc: boolean): cisloT;
  var
    vysledek: cisloT;
  var
    delka, i: integer;
  var
    zb: byte;
  begin
    zb := 0;
    if (porovnani(c1, c2) = 1) then
      delka := c1.delka
    else
      delka := c2.delka;
    if (otoc) then
    begin
      c1 := otocCislo(c1);
      c2 := otocCislo(c2);
    end;
    for i := 1 to delka do
    begin
      vysledek.cislo[i] := c1.cislo[i] + c2.cislo[i] + zb;
      zb := vysledek.cislo[i] div 10;
      if (zb > 0) then
        vysledek.cislo[i] := vysledek.cislo[i] mod 10;
    end;
    if (zb > 0) then
    begin
      vysledek.delka := delka + 1;
      vysledek.cislo[vysledek.delka] := zb;
    end
    else
      vysledek.delka := delka;
    if (otoc) then
      vysledek := otocCislo(vysledek);
    vynuluj(vysledek);
    secti := vysledek;
  end;

  function vynasob(c1, c2: cisloT): cisloT;
  var
    mensi, vetsi, mezi1, mezi2: cisloT;
  var
    i, j: integer;
  var
    zb: byte;
  begin
    if (porovnani(c1, c2) = 1) then
    begin
      vetsi := c1;
      mensi := c2;
    end
    else
    begin
      vetsi := c2;
      mensi := c1;
    end;
    vetsi := otocCislo(vetsi);
    mensi := otocCislo(mensi);
    mezi1.delka := 0;
    vynuluj(mezi1);
    for i := 1 to mensi.delka do
    begin
      mezi2.delka := 0;
      vynuluj(mezi2);
      mezi2.delka := i - 1;
      zb := 0;
      for j := 1 to vetsi.delka do
      begin
        Inc(mezi2.delka);
        mezi2.cislo[mezi2.delka] := mensi.cislo[i] * vetsi.cislo[j] + zb;
        zb := mezi2.cislo[mezi2.delka] div 10;
        if (zb > 0) then
          mezi2.cislo[mezi2.delka] := mezi2.cislo[mezi2.delka] mod 10;
      end;
      if (zb > 0) then
      begin
        Inc(mezi2.delka);
        mezi2.cislo[mezi2.delka] := zb;
      end;

      mezi1 := secti(mezi1, mezi2, False);
    end;
    vynasob := otocCislo(mezi1);
  end;

  function vynasob2(c1, c2: cisloT; otoc: boolean): cisloT;
  var
    vysl: cisloT;
  var
    i, j, c, temp, posledniNenul: integer;
  begin
    vysl.delka := 0;
    vynuluj(vysl);
    if ((c1.delka < 2) and (c1.cislo[1] = 0)) then
    begin
      vynasob2 := vysl;
      exit;
    end;
    if (otoc) then
    begin
      c1 := otocCislo(c1);
      c2 := otocCislo(c2);
    end;
    posledniNenul := 0;
    for i := 0 to (c2.delka - 1) do
    begin
      c := 0;
      for j := 0 to (c1.delka - 1) do
      begin
        temp := vysl.cislo[i + j + 1] + (c1.cislo[j + 1] * c2.cislo[i + 1]) + c;
        vysl.cislo[i + j + 1] := temp mod 10;
        c := temp div 10;
      end;
      vysl.cislo[i + c1.delka + 1] := c;
      if (vysl.cislo[i + c1.delka + 1] > 0) then
        vysl.delka := i + c1.delka + 1
      else
        vysl.delka := i + c1.delka;
    end;
    if (otoc) then
      vynasob2 := otocCislo(vysl)
    else
      vynasob2 := vysl;
  end;

  function vynasobDeseti(c1: cisloT; kolikrat: integer): cisloT; {dolni jsou nejmensi}
  var
    i: integer;
  begin
    if (kolikrat <= 0) then
    begin
      vynasobDeseti := c1;
      exit;
    end;
    if (c1.delka + kolikrat > MAX_DELKA) then
    begin
      writeln('CHYBA delka');
      halt(1);
    end;
    for i := c1.delka downto 1 do
    begin
      c1.cislo[i + kolikrat] := c1.cislo[i];
      c1.cislo[i] := 0;
    end;
    c1.delka := c1.delka + kolikrat;
    vynasobDeseti := c1;
  end;

  function betterMod(i, modulus: integer): integer;
  begin
    if (i < 0) then
      betterMod := (i mod modulus) + modulus
    else
      betterMod := i mod modulus;
  end;

  function odecti(c1, c2: cisloT; otoc: boolean): cisloT;
  var
    vysledek, temp: cisloT;
  var
    delka, i, porov, zb: integer;
  begin
    vysledek.delka := 0;
    vynuluj(vysledek);
    zb := 0;
    if (otoc) then
    begin
      c1 := otocCislo(c1);
      c2 := otocCislo(c2);
    end;
    porov := porovnani2(c1, c2);
    if (porov = 0) then
    begin
      vysledek.delka := 0;
      odecti := vysledek;
      exit;
    end
    else if (porov = 2) then //c1 < c2, prohodime a vysledek je zaporny
    begin
      temp := c1;
      c1 := c2;
      c2 := temp; //now c1 > c2;
      vysledek.isNegative := True;
    end;
    delka := c1.delka;
    zb := 0;
    for i := 1 to delka do
    begin
      if (c1.cislo[i] < (c2.cislo[i] + zb)) then
      begin
        vysledek.cislo[i] := (c1.cislo[i] + 10) - (c2.cislo[i] + zb);
        zb := 1;
      end
      else
      begin
        vysledek.cislo[i] := c1.cislo[i] - (c2.cislo[i] + zb);
        zb := 0;
      end;
      if (vysledek.cislo[i] <> 0) then
        vysledek.delka := i;
    end;
    if (otoc) then
      odecti := otocCislo(vysledek)
    else
      odecti := vysledek;
  end;

  function vydel2(c1, c2: cisloT): vysledekDeleni2;
  var
    vysl: vysledekDeleni2;
  var
    vynasobeneDeseti, temp, temp2: cisloT;
  var
    t, n, i: integer;
  var
    longTemp, longTemp2: longint;
  begin
    vysl.quot.delka := 0;
    vysl.rem.delka := 0;
    vynuluj(vysl.quot);
    vynuluj(vysl.rem);
    c1 := otocCislo(c1);  //prevede na tvar kde na 1. indexu je nejmensi
    c2 := otocCislo(c2);
    n := c1.delka - 1;
    t := c2.delka - 1;
    vynasobeneDeseti := vynasobDeseti(c2, n - t);
    while (porovnani2(c1, vynasobeneDeseti) <> 2) do
    begin
      vysl.quot.cislo[n - t + 1] := vysl.quot.cislo[n - t + 1] + 1;
      c1 := odecti(c1, vynasobeneDeseti, False);
    end;
    for i := n downto c2.delka do
    begin
      if (c1.cislo[i + 1] = c2.cislo[c2.delka]) then
        vysl.quot.cislo[i - t] := 9
      else
      begin
        //vysl.quot.cislo[i-t] := (c1.cislo[i+1]*10 + c1.cislo[i]) div c2.cislo[c2.delka]; //normalizace - rychlejsi
        vysl.quot.cislo[i - t] :=
          (c1.cislo[i + 1] * 100 + c1.cislo[i] * 10 + c1.cislo[i - 1]) div
          (c2.cislo[c2.delka] * 10 + c2.cislo[t]);
      end;
      longTemp := vysl.quot.cislo[i - t] * (c2.cislo[c2.delka] * 10 + c2.cislo[t]);
      longTemp2 := c1.cislo[i + 1] * 100 + c1.cislo[i] * 10 + c1.cislo[i - 1];
      while (longTemp > longTemp2) do
      begin
        vysl.quot.cislo[i - t] := vysl.quot.cislo[i - t] - 1;
        longTemp := vysl.quot.cislo[i - t] * (c2.cislo[c2.delka] * 10 +
          c2.cislo[c2.delka - 1]);
      end;
      vynasobeneDeseti := vynasobDeseti(c2, i - t - 1);
      temp.delka := 1;
      temp.cislo[1] := vysl.quot.cislo[i - t];
      temp := vynasob2(temp, vynasobeneDeseti, False);
      c1 := odecti(c1, temp, False);
      if (c1.isNegative = True) then
      begin
        c1 := odecti(vynasobeneDeseti, c1, False);
        vysl.quot.cislo[i - t] := vysl.quot.cislo[i - t] - 1;
      end;
    end;
    for i := n - t + 1 downto 1 do
    begin
      if (vysl.quot.cislo[i] <> 0) then
      begin
        vysl.quot.delka := i;
        break;
      end;
    end;
    vysl.rem := c1;
    vydel2 := vysl;
  end;


  function vydelDvema(p: cisloT): vysledekDeleni;
  var
    i, j: integer;
  var
    akt: byte;
  var
    vysledek: vysledekDeleni;
  begin
    for i := 1 to MAX_DELKA_PRVOCISLA do
      vysledek.vysl.cislo[i] := 0;
    vysledek.zbytek := 0;
    j := 1;
    for i := 1 to p.delka do
    begin
      akt := vysledek.zbytek * 10 + p.cislo[i];
      if ((akt div 2) = 0) then
      begin
        vysledek.zbytek := akt;
        if (i > 1) then
        begin
          vysledek.vysl.cislo[j] := 0;
          Inc(j);
        end;
      end
      else
      begin
        vysledek.zbytek := akt mod 2;
        vysledek.vysl.cislo[j] := akt div 2;
        Inc(j);
      end;
    end;
    vysledek.vysl.delka := j - 1;
    vydelDvema := vysledek;
  end;

  function modulo(divident, divisor: cisloT): cisloT;
  var
    jedna, dva, endValue, bitsToSet, divident2, q, difference: cisloT;
  begin
    divident2 := divident;

    q.delka := 0;
    vynuluj(q);

    dva.delka := 0;
    vynuluj(dva);
    dva.delka := 1;
    dva.cislo[1] := 2;

    jedna.delka := 0;
    vynuluj(jedna);
    jedna.delka := 1;
    jedna.cislo[1] := 1;

    bitsToSet.delka := 0;
    vynuluj(bitsToSet);
    while (porovnani(divident, divisor) <> 2) do
    begin
      difference := divisor;
      bitsToSet := jedna;
      endValue := vydelDvema(divident).vysl;
      while (porovnani(endValue, difference) <> 2) do
      begin
        difference := vynasob(difference, dva);
        bitsToSet := vynasob(bitsToSet, dva);
      end;
      q := secti(q, bitsToSet, True);
      divident := odecti(divident, difference, True);
    end;
    modulo := odecti(divident2, vynasob(q, divisor), True);
  end;

  function factor(p: cisloT): vysledekFaktorizace;
  var
    vyslD: vysledekDeleni;
  var
    vyslF: vysledekFaktorizace;
  begin
    p.cislo[p.delka] := p.cislo[p.delka] - 1;
    vyslF.exponent := 0;
    vyslF.zbytek := p;
    vyslD := vydelDvema(p);
    while ((vyslD.zbytek = 0) and ((vyslD.vysl.delka <> 1) or
        (vyslD.vysl.cislo[1] <> 0))) do
    begin
      Inc(vyslF.exponent);
      vyslF.zbytek := vyslD.vysl;
      vyslD := vydelDvema(vyslD.vysl);
    end;
    factor := vyslF;
  end;

  function square(c1: cisloT): cisloT;
  var
    vysl: cisloT;
  var
    i, j, temp, c: integer;
  begin
    vysl.delka := 0;
    vynuluj(vysl);
    c1 := otocCislo(c1);
    for i := 0 to (c1.delka - 1) do
    begin
      temp := vysl.cislo[2 * i + 1] + (c1.cislo[i + 1] * c1.cislo[i + 1]);
      vysl.cislo[(2 * i) + 1] := temp mod 10;
      c := temp div 10;
      for j := (i + 1) to (c1.delka - 1) do
      begin
        temp := vysl.cislo[(i + j) + 1] + (2 * c1.cislo[j + 1] * c1.cislo[i + 1]) + c;
        vysl.cislo[(i + j) + 1] := temp mod 10;
        c := temp div 10;
      end;
      vysl.cislo[i + c1.delka + 1] := c;
    end;
    if (vysl.cislo[c1.delka * 2] > 0) then
      vysl.delka := c1.delka * 2
    else
      vysl.delka := c1.delka * 2 - 1;
    square := otocCislo(vysl);
  end;

  function modular_pow(base, exponent, modulus: cisloT): cisloT;
  var
    vysledek: cisloT;
  var
    temp: vysledekDeleni;
  begin
    if ((modulus.delka = 1) and (modulus.cislo[1] = 1)) then
    begin
      vysledek.delka := 0;
      vynuluj(vysledek);
      modular_pow := vysledek;
      exit;
    end;
    vysledek.delka := 1;
    vysledek.cislo[1] := 1;
    vynuluj(vysledek);
    base := modulo(base, modulus);
    while exponent.delka > 0 do
    begin
      temp := vydelDvema(exponent);
      if (temp.zbytek = 1) then
      begin
        vysledek := modulo(vynasob2(vysledek, base, False), modulus);
      end;
      exponent := temp.vysl;
      base := modulo(square(base), modulus);
    end;
    modular_pow := vysledek;
  end;

var
  pocetCifer, pocetPrvocisel, i: integer;
var
  p, nahodne, pMensi, x, n1, n2: cisloT;
var
  d2: vysledekDeleni2;
var
  faktory: vysledekFaktorizace;
var
  FromTime, ToTime: TDateTime;
  DiffMinutes: integer;
begin
  Randomize;
  Write('Kolik cifer: ');
  readln(pocetCifer);
  Write('Kolik ruznych prvocisel: ');
  readln(pocetPrvocisel);
  p := generujPrvocislo(pocetCifer);
  vynuluj(p);
  //vypisCislo(p);

  pMensi := p;
  pMensi.cislo[pMensi.delka] := pMensi.cislo[pMensi.delka] - 1;
  vynuluj(pMensi);

  faktory := factor(p);
  //writeln('2^', faktory.exponent);
  //vypisCislo(faktory.zbytek);
  //writeln('nahodne');
  nahodne := generujNahodneCislo(pMensi);
  vynuluj(nahodne);
  //vypisCislo(nahodne);

  //x := modular_pow(nahodne, faktory.zbytek, p);
  n1.delka := 3;
  n1.cislo[1] := 2;
  n1.cislo[2] := 4;
  n1.cislo[3] := 3;

  n2.delka := 1;
  n2.cislo[1] := 9;
  //p := n1;
  //nahodne := n2;
  FromTime := Now;
  d2 := vydel2(p, nahodne);
  ToTime := Now;
  DiffMinutes := MilliSecondsBetween(ToTime, FromTime);
  writeln(DiffMinutes, ' ms');
  //x := odecti(p, nahodne, true);
  //writeln('prev delka: ', d2.quot.delka);
  //d2.quot.delka := 30;
  writeln;
  writeln;
  vypisCislo(p);
  vypisCislo(nahodne);
  //vypisCislo(x);

  vypisCislo(otocCislo(d2.quot));
  vypisCislo(otocCislo(d2.rem));

end.
