program pprime;

uses DateUtils, sysutils;

const MAX_DELKA = 400;
      MAX_DELKA_PRVOCISLA = 200;

type dlouheCislo = array [1..MAX_DELKA] of byte;
type cisloT = record
     cislo : dlouheCislo;
     delka : integer;
end;
type vysledekFaktorizace = record
     exponent : integer;
     zbytek : cisloT;
end;
type vysledekDeleni = record
     vysl : cisloT;
     zbytek : byte;
end;


procedure vypisCislo(c : cisloT);
var i : integer;
begin
     writeln;
     writeln('delka : ', c.delka);
     for i := 1 to c.delka do write(c.cislo[i]);
     writeln;
     writeln;
end;

function generujPrvocislo(delka : byte) : cisloT;
var p : cisloT;
var i : byte;
var lichaCisla : array[1..5] of byte = (1,3,5,7,9);
begin
  p.cislo[1] := Random(9) + 1;
  for i := 2 to delka do
  begin
    if(i <> delka) then p.cislo[i] := Random(10)
    else p.cislo[delka] := lichaCisla[Random(5)+1];
  end;
  p.delka := delka;
  generujPrvocislo := p;
end;
{
1 : c1>c2
0 : c1=c2
2 : c1<c2
}
function porovnani(c1, c2 : cisloT) : byte;
var i : integer;
begin
     if(c1.delka > c2.delka) then porovnani := 1
     else
     begin
          if(c1.delka < c2.delka) then porovnani := 2
          else //stejna delka
          begin
               i := 1;
               while((c1.cislo[i] = c2.cislo[i]) and (i <= MAX_DELKA)) do inc(i);
               if(i = MAX_DELKA+1) then porovnani := 0
               else
               begin
                    if(c1.cislo[i] > c2.cislo[i]) then porovnani := 1
                    else porovnani := 2;
               end;
          end;
     end;
end;

procedure vynuluj(var c : cisloT);
var i : integer;
begin
  for i := 1 to MAX_DELKA do
  begin
    if(i > c.delka) then c.cislo[i] := 0;
  end;
end;
function generujNahodneCislo(horniHranice : cisloT) : cisloT;
var i : byte;
var nahodneCislo : cisloT;
begin
  repeat
    nahodneCislo.delka := Random(horniHranice.delka) + 1;
    nahodneCislo.cislo[1] := Random(9) + 1;
    for i := 2 to nahodneCislo.delka do
    begin
         nahodneCislo.cislo[i] := Random(10);
    end;
  until ((porovnani(horniHranice, nahodneCislo) = 1) and ((nahodneCislo.delka > 1) or (nahodneCislo.cislo[1] > 1))); //2<=n<hodniHranice
  generujNahodneCislo := nahodneCislo;
end;

function otocCislo(c : cisloT) : cisloT;
var zac, kon, temp : integer;

begin
     zac := 1;
     kon := c.delka;
     while(zac < kon) do
     begin
       temp := c.cislo[zac];
       c.cislo[zac] := c.cislo[kon];
       c.cislo[kon] := temp;
       inc(zac);
       kon := kon - 1;
     end;
     otocCislo := c;
end;

function secti(c1, c2 : cisloT; otoc : boolean) : cisloT;
var vysledek : cisloT;
var delka, i : integer;
var zb : byte;
begin
     zb := 0;
     if(porovnani(c1,c2) = 1) then delka := c1.delka
     else delka := c2.delka;
     if(otoc) then
     begin
        c1 := otocCislo(c1);
        c2 := otocCislo(c2);
     end;
     for i := 1 to delka do
     begin
         vysledek.cislo[i] := c1.cislo[i] + c2.cislo[i] + zb;
         zb := vysledek.cislo[i] div 10;
         if(zb > 0) then vysledek.cislo[i] := vysledek.cislo[i] mod 10;
     end;
     if(zb > 0) then
     begin
          vysledek.delka := delka+1;
          vysledek.cislo[vysledek.delka] := zb;
     end
     else vysledek.delka := delka;
     if(otoc) then vysledek := otocCislo(vysledek);
     vynuluj(vysledek);
     secti := vysledek;
end;

function vynasob(c1, c2 : cisloT) : cisloT;
var mensi, vetsi, mezi1, mezi2 : cisloT;
var i, j : integer;
var zb : byte;
begin
     if(porovnani(c1, c2) = 1) then
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
         mezi2.delka := i-1;
         zb := 0;
         for j := 1 to vetsi.delka do
         begin
              inc(mezi2.delka);
              mezi2.cislo[mezi2.delka] := mensi.cislo[i] * vetsi.cislo[j] + zb;
              zb := mezi2.cislo[mezi2.delka] div 10;
              if(zb > 0) then mezi2.cislo[mezi2.delka] := mezi2.cislo[mezi2.delka] mod 10;
         end;
         if(zb > 0) then
         begin
              inc(mezi2.delka);
              mezi2.cislo[mezi2.delka] := zb;
         end;

         mezi1 := secti(mezi1, mezi2, false);
     end;
     vynasob := otocCislo(mezi1);
end;

function odecti(c1, c2 : cisloT; otoc : boolean) : cisloT;
var vysledek : cisloT;
var delka, i : integer;
var zb, porov : byte;
begin
     vysledek.delka := 0;
     vynuluj(vysledek);
     zb := 0;
     porov := porovnani(c1,c2);
     if(porov = 1) then delka := c1.delka
     else
     begin
          if(porov = 0) then vysledek.delka := 0
          else vysledek.delka := -1;
          odecti := vysledek;
          exit;
     end;
     if(otoc) then
     begin
        c1 := otocCislo(c1);
        c2 := otocCislo(c2);
     end;
     zb := 0;
     for i := 1 to delka do
     begin
         if(c1.cislo[i] < (c2.cislo[i] + zb)) then
         begin
              vysledek.cislo[i] := (c1.cislo[i]+10) - (c2.cislo[i]+zb);
              zb := 1;
         end
         else
         begin
             vysledek.cislo[i] := c1.cislo[i] - (c2.cislo[i]+zb);
             zb := 0;
         end;
         if(vysledek.cislo[i] <> 0) then vysledek.delka := i;
     end;
     if(otoc) then odecti := otocCislo(vysledek)
     else odecti := vysledek;
end;

function modulus(c1, c2 : cisloT) : cisloT;
var pred : cisloT;
begin
  {ne velice pomalé
     if(porovnani(c1,c2) = 2) then modulus := c1//c1<c2
     else
     begin
          while(c1.delka > 0) do
          begin
               pred := c1;
               c1 := odecti(c1, c2, true);
          end;
          if(c1.delka = 0) then
          begin
               vynuluj(c1);
               modulus := c1;
          end
          else modulus := pred;
     end;
     }
end;

function vydelDvema(p : cisloT) : vysledekDeleni;
var i, j : integer;
var akt : byte;
var vysledek : vysledekDeleni;
begin
     for i := 1 to MAX_DELKA_PRVOCISLA do vysledek.vysl.cislo[i] := 0;
     vysledek.zbytek := 0;
     j := 1;
     for i := 1 to p.delka do
     begin
         akt := vysledek.zbytek*10 + p.cislo[i];
         if((akt div 2) = 0) then
         begin
              vysledek.zbytek := akt;
              if(i > 1) then
              begin
                   vysledek.vysl.cislo[j] := 0;
                   inc(j);
              end;
         end
         else
         begin
           vysledek.zbytek := akt mod 2;
           vysledek.vysl.cislo[j] := akt div 2;
           inc(j);
         end;
     end;
     vysledek.vysl.delka := j-1;
     vydelDvema := vysledek;
end;

procedure remAndQ(divident, divisor : cisloT; var multiplier, difference : cisloT);
var jedna, dva, endValue, bitsToSet : cisloT;
var number : longint;
begin
  multiplier.delka := 0;
  vynuluj(multiplier);

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
  number := 0;
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
       multiplier := secti(multiplier, bitsToSet, true);
       divident := odecti(divident, difference, true);
  end;
end;

function factor(p : cisloT) : vysledekFaktorizace;
var vyslD : vysledekDeleni;
var vyslF : vysledekFaktorizace;
begin
     p.cislo[p.delka] := p.cislo[p.delka] - 1;
     vyslF.exponent := 0;
     vyslF.zbytek := p;
     vyslD := vydelDvema(p);
     while((vyslD.zbytek = 0) and ((vyslD.vysl.delka <> 1) or (vyslD.vysl.cislo[1] <> 0))) do
     begin
          inc(vyslF.exponent);
          vyslF.zbytek := vyslD.vysl;
          vyslD := vydelDvema(vyslD.vysl);
     end;
     factor := vyslF;
end;

var pocetCifer, pocetPrvocisel, i : integer;
var p, nahodne, pMensi, soucet, nasobek, multi, diff, jedna : cisloT;
var d : vysledekDeleni;
var faktory : vysledekFaktorizace;
var
  FromTime, ToTime: TDateTime;
  DiffMinutes: Integer;
begin
  Randomize;
  write('Kolik cifer: ');
  readln(pocetCifer);
  write('Kolik ruznych prvocisel: ');
  readln(pocetPrvocisel);
  p := generujPrvocislo(pocetCifer);
  vynuluj(p);
  vypisCislo(p);
  {
  writeln;
  d := vydelDvema(p);
  writeln(d.vysl.delka, ' ', d.zbytek);
  for i:=1 to d.vysl.delka do write(d.vysl.cislo[i]);

  writeln;

  faktory := factor(p);
  writeln(faktory.exponent, ' ', faktory.zbytek.delka);
  for i:=1 to faktory.zbytek.delka do write(faktory.zbytek.cislo[i]);
  }
  pMensi := p;
  pMensi.cislo[pMensi.delka] := pMensi.cislo[pMensi.delka] - 1;
  vynuluj(pMensi);
  nahodne := generujNahodneCislo(pMensi);
  vynuluj(nahodne);
  vypisCislo(nahodne);
  {
  soucet := secti(p, pMensi);
  vypisCislo(soucet);
  }
  {
  nasobek := vynasob(p, nahodne);
  vypisCislo(nasobek);
  }
  //nasobek := odecti(nahodne, p, true);
  //vypisCislo(nasobek);
  //nasobek := modulus(p, nahodne);
  remAndQ(p, nahodne, multi, diff);
  //multi := odecti(p, nahodne, true);
  writeln;
  writeln('multi');
  vypisCislo(multi);
  writeln;
  writeln('diff');
  vypisCislo(diff);
end.

