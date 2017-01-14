program Project2;

{$APPTYPE CONSOLE}

uses SysUtils, USquareTest;

const nmax = 64000000;
      len  = 664579;

var prs: array [1..len] of integer;

function f (const argn: integer; const args: int64; i: integer): integer;
var prsi, prsi2, n, s0, s: int64;
begin
  if isSquare(args) then
    result := argn
  else result := 0;
  prsi := prs[i]; n := argn * prsi;
  while (n < nmax) and (i < len) do begin
    prsi2 := prsi * prsi; i := i + 1;
    s0 := args; s := args;
    while n < nmax do begin
      s0 := s0 * prsi2; s := s + s0;
      result := result + f(n, s, i);
      n := n * prsi;
    end;
    prsi := prs[i]; n := argn * prsi;
  end;
end;

var prstxt: TextFile; i: integer; t: TDateTime;
begin
  t := now;
  assignFile(prstxt, 'prs.txt');
  reset(prstxt);
  i := 1;
  while not eof(prstxt) do begin
    read(prstxt, prs[i]);
    i := i + 1;
  end;
  writeln(f(1, 1, 1));
  closeFile(prstxt);
  writeln('Takes ' + formatDateTime('ss:z', now - t) + 's');
  readln;
end.
