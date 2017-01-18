program Project2;

{$APPTYPE CONSOLE}

uses
  SysUtils;

var facs: array ['0'..'9'] of integer;
    memem: array [1..61] of integer;

procedure init;
var c: char; j, k: integer;
begin
  j := 0; k := 1;
  for c := '0' to '9' do begin
    facs[c] := k;
    j := j + 1;
    k := k * j;
  end;
end;

function next (const n: integer): integer;
var i: integer; s: string;
begin
  result := 0; s := intToStr(n);
  for i := 1 to length(s) do
    result := result + facs[s[i]];
end;

function contAndAdd (const n, k: integer): boolean;
var i: integer;
begin
  memem[k + 1] := n; i := 1;
  while memem[i] <> n do
    i := i + 1;
  contAndAdd := i <= k;
end;

var i, j, k, t: integer;
begin
  init();

  t := 0;
  for i := 1 to 1000000 do begin
    k := 0; j := i;
    while not contAndAdd(j, k) do begin
      k := k + 1;
      j := next(j);
    end;
    if k = 60 then
      t := t + 1;
    if i mod 10000 = 0 then
      writeln(i);
  end;

  writeln(t);
  readln;
end.
