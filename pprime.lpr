program pprime;

uses DateUtils, sysutils;

type prvocislo = array [1..200] of byte;
type vysledek = record
     exponent : integer;
     zbytek : prvocislo;
end;

function generujPrvocislo(delka : byte) : prvocislo;
var p : prvocislo;
var i, j, zbytek : byte;
var randomNumber : longint;
var lichaCisla : array[1..5] of byte = (1,3,5,7,9);
begin
  {zbytek := delka mod 9;
  for i := 0 to ((delka div 9) - 1) do
  begin
       randomNumber := Random(1000000000);
       p[9*i + 1] := randomNumber mod 10;
       for j:=2 to 9 do
       begin
            p[9*i + j] := (randomNumber div (10*(j-1))) mod 10;
       end;
  end;
  for i := 1 to zbytek do
  begin
       if(i <> zbytek) then p[(delka div 9) * 9 + i] := Random(10)
       else p[(delka div 9) * 9 + i] := lichaCisla[Random(5)+1];
  end;
  generujPrvocislo := p;}
  for i :=1 to delka do
  begin
    if(i <> delka) then p[i] := Random(10)
    else p[delka] := lichaCisla[Random(5)+1];
  end;
  generujPrvocislo := p;
end;

function factor(p : prvocislo; delka : byte) : vysledek;
var i, j : byte;
var predchozi : boolean;
begin
     predchozi := false;
     for i := 1 to delka do
     begin
       if(predchozi) then
       begin
         predchozi := false
       end
       else
       begin
         if(p[i] = 1) then predchozi := true
         else vysledek.
       end;
     end;
end;

{function isPrime(p : prvocislo; spolehlivost : integer) : boolean;
begin

end;}

var pocetCifer, pocetPrvocisel, i : byte;
var p : prvocislo;
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
  for i:=1 to pocetCifer do write(p[i]);
end.

