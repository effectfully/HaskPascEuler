program Project2;

{$APPTYPE CONSOLE}

uses
  SysUtils;

function finc (var i: integer): integer; begin i := i + 1; finc := i; end;
function fdec (var i: integer): integer; begin i := i - 1; fdec := i; end;

const n = 10000;
      m = 5;

type TArrRec = record
                 arr: array [1..2000] of integer;
                 len: integer;
               end;
     TResRec = record
                 arr: array [0..m] of integer;
                 p, len: integer;
               end;

var gr: array [1..n] of TArrRec;
    res: TResRec;

procedure printRes;
var i, k: integer;
begin
  k := 0;
  for i := 1 to res.len do begin
    write(res.arr[i], ' ');
    k := k + res.arr[i];
  end;
  writeln('-> ', k);
end;

function f (n: integer): boolean;
var i: integer;
begin
  f := true;
  if (n = res.arr[res.p]) and (finc(res.p) = m) then begin //lazy `and` needed
    printRes(); f := false;
  end else if n > res.arr[res.p] then
    if res.p <> res.len then
      f := false
    else begin
      res.arr[finc(res.len)] := n; res.p := 1; i := 1;
      while f(gr[n].arr[i]) and (finc(i) <= gr[n].len) do;
      res.p := fdec(res.len);
    end;
end;

var prstxt: TextFile; i, j: integer;
begin
  for i := 1 to n do
    gr[i].len := 0;
  res.len := 0;
  res.arr[0] := 0;
  res.p := 0;

  assignFile(prstxt, 'prs.txt');
  reset(prstxt);
  while not eof(prstxt) do begin
    read(prstxt, i, j);
    gr[i].arr[finc(gr[i].len)] := j;
  end;
  closeFile(prstxt);

  for i := 3 to n do
    f(i);

  readln;
end.
