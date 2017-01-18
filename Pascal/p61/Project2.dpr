program Project2;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type TRec = record
              fig, ton: byte;
             end;
     TArr = array [1..50] of TRec;
     TArrRec = record
                 arr: TArr;
                 len: byte;
               end;
     TGr = array [10..99] of TArrRec;
     TRes = array [1..7] of byte;
     TResRec = record
                 arr: TRes;
                 len: byte;
               end;

var Gr: TGr;
    txt: TextFile;
    r: TRec;
    i, j, k, x, y: byte;
    res: TResRec;

function f (i, figs, fir: byte): boolean;
var j, t: byte;
begin
  result := false;
  if figs = 63 then
    result := i = fir
  else
    for j := 1 to Gr[i].len do begin
      t := Gr[i].arr[j].fig;
      if figs xor t = figs or t then
        result := result or f(Gr[i].arr[j].ton, figs or t, fir)
    end;
  if result then begin
    res.len := res.len + 1;
    res.arr[res.len] := i;
  end;
end;

begin
  r.fig := 0; r.ton := 0;
  for i := 1 to 99 do begin
    Gr[i].len := 0;
    for j := 1 to 50 do
      Gr[i].arr[j] := r;
  end;
  res.len := 0;

  assignFile(txt, 'ns.txt');
  reset(txt);
  r.fig := 1;
  while not eoln(txt) do begin
    read(txt, x, y);
    while x <> 0 do begin
      r.ton := y;
      Gr[x].len := Gr[x].len + 1;
      Gr[x].arr[Gr[x].len] := r;
      read(txt, x, y);
    end;
    r.fig := r.fig * 2;
  end;

  i := 10;
  while (i <= 99) and not f(i, 0, i) do
    i := i + 1;

  for i := 1 to res.len do
    writeln(res.arr[i]);

  readln;
end.
 
