program Project2;

{$APPTYPE CONSOLE}

uses
  SysUtils;

var n, sum, i, k, t: integer;
begin
  sum := 0;
  for n := 1 to 1000000000 do
    if n mod 10 <> 0 then begin
      k := 0; t := n;
      while t <> 0 do begin
        k := k * 10 + t mod 10;
        t := t div 10;
      end;
      t := k + n; k := t mod 10;
      while odd(k) do begin
        t := t div 10;
        k := t mod 10;
      end;
      sum := sum + byte(t = 0);
    end else if n mod 1000000 = 0 then
      writeln(n);
  writeln(sum);
  readln;
end.
