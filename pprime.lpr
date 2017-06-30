program pprime;

uses DateUtils, sysutils;

type dlouheCislo = array [1..200] of byte;
type cisloT = record
     cislo : dlouheCislo;
     delka : byte;
end;
type vysledekFaktorizace = record
     exponent : integer;
     zbytek : cisloT;
end;
type vysledekDeleni = record
     vysl : cisloT;
     zbytek : byte;
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

function vydelDvema(p : cisloT) : vysledekDeleni;
var i, j, akt : byte;
var vysledek : vysledekDeleni;
begin
     for i := 1 to 200 do vysledek.vysl.cislo[i] := 0;
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

var pocetCifer, pocetPrvocisel, i : byte;
var p : cisloT;
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
  for i:=1 to pocetCifer do write(p.cislo[i]);

  writeln;

  d := vydelDvema(p);
  writeln(d.vysl.delka, ' ', d.zbytek);
  for i:=1 to d.vysl.delka do write(d.vysl.cislo[i]);

  writeln;

  faktory := factor(p);
  writeln(faktory.exponent, ' ', faktory.zbytek.delka);
  for i:=1 to faktory.zbytek.delka do write(faktory.zbytek.cislo[i]);

end.

