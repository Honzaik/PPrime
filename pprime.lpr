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
    quot: cisloT;
    rem: cisloT;
  end;
type
  vysledekDeleniDvema = record
    vysl: cisloT;
    zbytek: byte;
  end;


  procedure vypisCislo(c: cisloT; writeDelka: boolean; msg: string);
  var
    i: integer;
  begin
    if (writeDelka) then
      writeln('delka : ', c.delka);
    if (length(msg) > 0) then
      Write(msg, ': ');
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
    lichaCisla: array[1..4] of byte = (1, 3, 7, 9);
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
citelnyFormat := true;
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
citelnyFormat := false;
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

  function secti(c1, c2: cisloT; jeCitelnyFormat: boolean): cisloT;
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
    if (jeCitelnyFormat) then
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
    if (jeCitelnyFormat) then
      vysledek := otocCislo(vysledek);
    vynuluj(vysledek);
    secti := vysledek;
  end;

  function vynasob(c1, c2: cisloT; jeCitelnyFormat: boolean): cisloT;
  var
    vysl: cisloT;
  var
    i, j, c, temp: integer;
  begin
    vysl.delka := 0;
    vynuluj(vysl);
    if ((c1.delka < 2) and (c1.cislo[1] = 0)) then
    begin
      vynasob := vysl;
      exit;
    end;
    if (jeCitelnyFormat) then
    begin
      c1 := otocCislo(c1);
      c2 := otocCislo(c2);
    end;
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
    if (jeCitelnyFormat) then
      vynasob := otocCislo(vysl)
    else
      vynasob := vysl;
  end;

  function vynasobDeseti(c1: cisloT; kolikrat: integer): cisloT;
    {dolni jsou nejmensi <=> citelnyFormat = false}
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

  function odecti(c1, c2: cisloT; jeCitelnyFormat: boolean): cisloT;
  var
    vysledek, temp: cisloT;
  var
    delka, i, porov, zb: integer;
  begin
    vysledek.delka := 0;
    vynuluj(vysledek);
    zb := 0;
    if (jeCitelnyFormat) then
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
    if (jeCitelnyFormat) then
      odecti := otocCislo(vysledek)
    else
      odecti := vysledek;
  end;

  function vydel(c1, c2: cisloT; jeCitelnyFormat: boolean): vysledekDeleni;
  var
    vysl: vysledekDeleni;
  var
    vynasobeneDeseti, temp: cisloT;
  var
    t, n, i: integer;
  var
    longTemp, longTemp2: longint;
  begin
    vysl.quot.delka := 0;
    vysl.rem.delka := 0;
    vynuluj(vysl.quot);
    vynuluj(vysl.rem);
    vynasobeneDeseti.delka := 0;
    vynuluj(vynasobeneDeseti);
    if (jeCitelnyFormat) then
    begin
      c1 := otocCislo(c1);  //prevede na tvar kde na 1. indexu je nejmensi
      c2 := otocCislo(c2);
    end;
    vynuluj(c1);
    vynuluj(c2);
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
        longTemp := vysl.quot.cislo[i - t] * (c2.cislo[c2.delka] *
          10 + c2.cislo[c2.delka - 1]);
      end;
      vynasobeneDeseti := vynasobDeseti(c2, i - t - 1);
      temp.delka := 1;
      temp.cislo[1] := vysl.quot.cislo[i - t];
      temp := vynasob(temp, vynasobeneDeseti, False);
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
    if (jeCitelnyFormat) then //prevede na tvar kde na 1. indexu je nejvetsi
    begin
      vysl.rem := otocCislo(vysl.rem);
      vysl.quot := otocCislo(vysl.quot);
    end;
    vydel := vysl;
  end;

  function modulo(c1, c2: cisloT; jeCitelnyFormat: boolean): cisloT;
  var
    vynasobeneDeseti, temp: cisloT;
  var
    t, n, i: integer;
  var
    longTemp, longTemp2: longint;
  var
    q: byte;
  begin
    if (jeCitelnyFormat) then
    begin
      c1 := otocCislo(c1);  //prevede na tvar kde na 1. indexu je nejmensi
      c2 := otocCislo(c2);
    end;
    n := c1.delka - 1;
    t := c2.delka - 1;
    vynasobeneDeseti := vynasobDeseti(c2, n - t);
    while (porovnani2(c1, vynasobeneDeseti) <> 2) do
    begin
      c1 := odecti(c1, vynasobeneDeseti, False);
    end;
    for i := n downto c2.delka do
    begin
      if (c1.cislo[i + 1] = c2.cislo[c2.delka]) then
        q := 9
      else
      begin
        q :=
          (c1.cislo[i + 1] * 100 + c1.cislo[i] * 10 + c1.cislo[i - 1]) div
          (c2.cislo[c2.delka] * 10 + c2.cislo[t]);
      end;
      longTemp := q * (c2.cislo[c2.delka] * 10 + c2.cislo[t]);
      longTemp2 := c1.cislo[i + 1] * 100 + c1.cislo[i] * 10 + c1.cislo[i - 1];
      while (longTemp > longTemp2) do
      begin
        q := q - 1;
        longTemp := q * (c2.cislo[c2.delka] * 10 + c2.cislo[c2.delka - 1]);
      end;
      vynasobeneDeseti := vynasobDeseti(c2, i - t - 1);
      temp.delka := 1;
      temp.cislo[1] := q;
      temp := vynasob(temp, vynasobeneDeseti, False);
      c1 := odecti(c1, temp, False);
      if (c1.isNegative = True) then
        c1 := odecti(vynasobeneDeseti, c1, False);
    end;
    if (jeCitelnyFormat) then
      c1 := otocCislo(c1);
    modulo := c1;
  end;


  function vydelDvema(p: cisloT): vysledekDeleniDvema;
  var
    i, j: integer;
  var
    akt: byte;
  var
    vysledek: vysledekDeleniDvema;
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

  function factor(p: cisloT): vysledekFaktorizace;
  var
    vyslD: vysledekDeleniDvema;
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

  function square(c1: cisloT; jeCitelnyFormat: boolean): cisloT;
  var
    vysl: cisloT;
  var
    i, j, temp, c: integer;
  begin
    vysl.delka := 0;
    vynuluj(vysl);
    if (jeCitelnyFormat) then
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
    if (jeCitelnyFormat) then
      vysl := otocCislo(vysl);
    square := vysl;
  end;

  function modular_pow(base, exponent, modulus: cisloT;
    jeCitelnyFormat: boolean): cisloT;
  var
    vysledek, dva: cisloT;
  var
    tempDeleni: vysledekDeleni;
  begin
    if (jeCitelnyFormat) then
    begin
      base := otocCislo(base);
      exponent := otocCislo(exponent);
      modulus := otocCislo(modulus);
    end;
    if ((modulus.delka = 1) and (modulus.cislo[1] = 1)) then
    begin
      vysledek.delka := 0;
      vynuluj(vysledek);
      modular_pow := vysledek;
      exit;
    end;
    vysledek.delka := 1;
    vysledek.cislo[1] := 1;
    dva.delka := 1;
    dva.cislo[1] := 2;
    vynuluj(dva);
    vynuluj(vysledek);
    base := modulo(base, modulus, False);
    while exponent.delka > 0 do
    begin
      tempDeleni := vydel(exponent, dva, False);
      if (tempDeleni.rem.delka = 1) then
      begin
        vysledek := modulo(vynasob(vysledek, base, False), modulus, False);
      end;
      base := modulo(square(base, False), modulus, False);
      exponent := tempDeleni.quot;
    end;
    modular_pow := vysledek;
  end;

  function stringToCislo(s: string): cisloT;
  var
    i: integer;
  var
    Value: byte;
  var
    vysl: cisloT;
  begin
    vysl.delka := length(s);
    for i := length(s) downto 1 do
    begin
      Val(s[i], Value);
      vysl.cislo[i] := Value;
    end;
    stringToCislo := vysl;
  end;

  function isPrime(p: cisloT; k: byte): boolean;
  var
    nahodne, pMensi, x, otoceneP, otoceneMensi: cisloT;
  var
    i, j: integer;
  var
    pokracuj: boolean;
  var
    faktory: vysledekFaktorizace;
  begin
    otoceneP := otocCislo(p); //necitelne
    vynuluj(otoceneP);
    pMensi := p;
    vynuluj(pMensi);
    pMensi.cislo[pMensi.delka] := pMensi.cislo[pMensi.delka] - 1;
    otoceneMensi := otocCislo(pMensi);
    vynuluj(otoceneMensi);
    faktory.zbytek.delka := 0;
    vynuluj(faktory.zbytek);
    faktory.exponent := 0;
    faktory := factor(p);
    for i := 1 to k do
    begin
      pokracuj := False;
      nahodne := generujNahodneCislo(pMensi);
      vynuluj(nahodne);
      x := modular_pow(nahodne, faktory.zbytek, p, True);
      if (((x.delka = 1) and (x.cislo[1] = 1)) or (porovnani2(otoceneMensi, x) = 0)) then
      begin
        Continue;
      end;
      for j := 1 to (faktory.exponent - 1) do
      begin
        x := modulo(square(x, False), otoceneP, False);
        if ((x.delka = 1) and (x.cislo[1] = 1)) then
        begin
          exit(False);
        end;
        if ((porovnani2(otoceneMensi, x) = 0)) then
        begin
          pokracuj := True;
          break;
        end;
      end;
      if (not pokracuj) then
      begin
        exit(False);
      end;
    end;
    writeln;
    vypisCislo(p, True, 'je prvocislo ');
    isPrime := True;
  end;

var
  pocetCifer, pocetPrvocisel, pocetVygenerovanych : integer;
var
  p : cisloT;
var generuj : boolean;
begin
  Randomize;
  Write('Kolik cifer: ');
  readln(pocetCifer);
  Write('Kolik ruznych prvocisel: ');
  readln(pocetPrvocisel);
  generuj := true;
  pocetVygenerovanych := 0;
  while generuj do
  begin
       inc(pocetVygenerovanych);
       p := generujPrvocislo(pocetCifer);
       vynuluj(p);
       write(pocetVygenerovanych, ' ');
       if(isPrime(p, 2) = true) then generuj := false;
  end;




  //writeln('2^', faktory.exponent);

  //p := stringToCislo('380945753938809950151287337354146772520603275837293698990528362172443175624566631917411093955959497847751482624457225761');
  //faktory.zbytek := stringToCislo('11904554810587810942227729292317086641268852369915428093454011317888849238267707247419096686123734307742233832014288305');
  {n1 := stringToCislo('186008668915434545972308270192454478769825818279928563960218926842013269347932925740923385720683348558472403625223254');
  n2.delka := 1;
  n2.cislo[1] := 2;
  d2 := vydel2(n1, n2, true);
  vypisCislo(d2.quot, true, 'quot ');
  vypisCislo(d2.rem, true, 'rem :');
  n1.delka := 1;
  n1.cislo[1] := 2;
  n2.delka := 3;
  n2.cislo[1] := 7;
  n2.cislo[2] := 7;
  n2.cislo[3] := 4;
  d2 := vydel2(n2,n1, false);
  vypisCislo(otocCislo(d2.quot));
  vypisCislo(otocCislo(d2.rem)); }

end.
