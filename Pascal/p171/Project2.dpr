program Project2;

{$APPTYPE CONSOLE}

uses
  SysUtils;

const n = 20;
      m = 81 * n;
      d = 100;

var resarr: array [1..n] of integer;
    reslen: byte; sum: integer;
    sqs: array [1..10] of integer;
    mem: array [0..m, 0..n] of integer;

procedure p;
var i: integer;
begin
  for i := 1 to reslen do
    write(resarr[i], ' ');
  writeln;  
end;

function g: integer;
var i, k: integer;
begin
  i := reslen; k := 1; result := 0;
  while (i > 0) and (result < d) do begin
    result := result + k * resarr[i];
    k := k * 10; i := i - 1;
  end;
  result := result mod d;
end;

function f (x: integer; k: byte): integer;
var i: integer;
begin
  result := 0;
  if mem[x, k] <> 0 then begin
    reslen := reslen + 1;
    resarr[reslen] := mem[x, k];
    result := g;
  end else begin
    if x = 0 then
      result := g
    else if k <> 0 then begin
      i := 1; reslen := reslen + 1;
      while x >= sqs[i] do begin
        resarr[reslen] := i;
        result := result + f(x - sqs[i], k - 1);
        i := i + 1;
      end;
      reslen := reslen - 1;
    end;
    mem[x, k] := result;
  end;

end;

var i, j: integer;
begin
  reslen := 0;

  for i := 1 to 9 do
    sqs[i] := sqr(i);
  sqs[10] := m;

  for i := 0 to m do
    for j := 0 to n do
      mem[i, j] := 0;

  writeln(f(5, 20));

  reslen := 7;
  for i := 1 to 7 do
    resarr[i] := i;
  writeln(g);

  readln;
end.
