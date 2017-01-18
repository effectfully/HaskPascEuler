program Project2;

{$APPTYPE CONSOLE}

uses
  SysUtils;

const l2 = 750000;

type TRec = record
              sum, x, y, z: integer;
            end;

function getRec (const sum, k, m, n: integer): TRec;
var a, b: integer;
begin
  result.sum := sum + 1;
  a := sqr(m); b := sqr(n);
  result.x := k * (a - b);
  result.y := k * (a + b);
  result.z := k * 2 * m * n;
end;

function compRecs (const r1, r2: TRec): boolean;
begin
  if r1.x = r2.x then begin
    if r1.y = r2.y then
      result := r1.z = r2.z
    else if r1.y = r2.z then
      result := r1.z = r2.y
  end else if r1.x = r2.y then begin
    if r1.y = r2.x then
      result := r1.z = r2.z
    else if r1.y = r2.z then
      result := r1.z = r2.x
  end else if r1.x = r2.z then begin
    if r1.y = r2.x then
      result := r1.z = r2.y
    else if r1.z = r2.x then
      result := r1.y = r2.y
  end else result := false;    
end;

var arr: array  [1..l2 * 2] of TRec;
    i, m, n, k: integer; r: TRec;
begin
  for i := 1 to l2 do begin
    arr[i].sum := 0;
    arr[i].x := 0;
    arr[i].y := 0;
    arr[i].z := 0;
  end;
  for m := 2 to trunc(sqrt(l2)) do
    for n := 1 to m - 1 do begin
      k := 1;
      i := k * m * (m + n);
      while i <= l2 do begin
        if arr[i].sum <= 1 then begin
          r := getRec(arr[i].sum, k, m, n);
          if not compRecs(arr[i], r) then
            arr[i] := r;
        end;
        k := k + 1;
        i := k * m * (m + n);
      end;
    end;

  k := 0;
  for i := 1 to l2 do
    if arr[i].sum = 1 then
      k := k + 1;
  writeln(k);
  readln;
end.
