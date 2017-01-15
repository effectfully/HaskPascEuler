program Project2;

{$APPTYPE CONSOLE}

uses
  SysUtils;

const n = 60; m = 40;

type  TPair = record
               x, y: integer;
             end;
      TPairsArr = array [0..n, 0..m + 1] of TPair;

var pairs: TPairsArr;
    mem: array [0..n, 0..m + 1, 0..n, 0..m] of int64;

procedure init;
var i, j, ii, jj: integer;
begin
  for i := 0 to n do
    for j := 0 to m + 1 do begin
      pairs[i, j].x := i;
      pairs[i, j].y := j;
      for ii := 0 to n do
        for jj := 0 to m do
          mem[i, j, ii, jj] := -1;
    end;
end;

function minus (const x, y: TPair): TPair;
begin
  result.x := x.x - y.x;
  result.y := x.y - y.y;
end;

function cmp (const x, y: TPair): boolean;
begin
  result := (x.x > y.x) or (x.x = y.x) and (x.y >= y.y);
end;

function f (x: TPair; ii, jj: integer): int64;
var i, j: integer; p: TPair;
begin
  result := 0; i := ii; j := jj;
  p := minus(x, pairs[i, j]);
  while cmp(p, pairs[i, j]) do begin
    if p.y >= 0 then begin
      if mem[p.x, p.y, i, j] = -1 then
        mem[p.x, p.y, i, j] := f(p, i, j);
      result := result + 1 + mem[p.x, p.y, i, j];
    end else begin
      i := i + 1; j := -1;
    end;
    j := j + 1; p := minus(x, pairs[i, j]);
  end;
end;

var p: TPair; t: TDateTime;
begin
  t := now;
  init();
  p.x := n; p.y := m;
  writeln(f(p, 0, 1) + 1);
  writeln(FormatDateTime('ss:z', now - t));
  readln;
end.
