program Project2;

{$APPTYPE CONSOLE}

uses
  SysUtils;

const n = 12200;
      m = 111;

type TPair = record
               x, y: integer;
             end;

     TArrRec = record
                 arr: array [0..m] of TPair;
                 len: integer;
               end;
var numbs: array [2..n] of TArrRec;
    res: array [1..n] of integer;

procedure init;
var r: TPair; i, j, k: integer;
begin
  for i := 2 to n do begin
    numbs[i].len := 0;
    numbs[i].arr[0].x := -1;
  end;
  for i := 1 to n do
    res[i] := 0;
  for i := 2 to n do begin
    j := sqr(i); k := i;
    while j <= n do begin
      r.x := i; r.y := k;
      numbs[j].len := numbs[j].len + 1;
      numbs[j].arr[numbs[j].len] := r;
      j := j + i; k := k + 1;
    end;
  end;
end;

procedure ps;
var t, c, s: integer;

  procedure p(x, y: integer);
  var i: integer;
  begin
    c := c + 1;
    if res[t - s - y + c] = 0 then
      res[t - s - y + c] := t;
    i := numbs[y].len;
    while numbs[y].arr[i].x >= x do begin
      s := s + numbs[y].arr[i].x;
      p(numbs[y].arr[i].x, numbs[y].arr[i].y);
      s := s - numbs[y].arr[i].x; i := i - 1;
    end;
    c := c - 1;
  end;

begin
  c := 0; s := 0;
  for t := 2 to n do
    p(0, t);
end;

procedure print;
var i, j, s: integer;
begin
  i := 2; s := 0;
  while i <= 12000 do begin
    j := i - 1;
    while (j >= 2) and (res[i] <> res[j]) do
      j := j - 1;
    if j < 2 then
      s := s + res[i];
    i := i + 1;
  end;
  writeln(s);
end;

var t: TDateTime;
begin
  t := now;
  init();
  ps();
  writeln(FormatDateTime('ss:z', now - t));
  print();
  writeln(FormatDateTime('ss:z', now - t));
  readln;
end.
