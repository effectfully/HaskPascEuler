program Project2;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  UList in 'UList.pas';

const nmax  = 10000000;
      dnmax = nmax div 10;

var diffs: array [0..nmax] of TPRec;
    divs: array [1..dnmax] of integer;

function isqrt (const x: int64): int64;
begin
  isqrt := round(sqrt(x + 0.0));
end;

function gcd (a, b: int64): int64;
var c: int64;
begin
  while b <> 0 do begin
    c := a mod b;
    a := b;
    b := c;
  end;
  gcd := a;
end;

procedure diffsSieve;
var i, i2, di2, j, j2, dj2, j2max: integer; p: TPair;
begin
  for i := 0 to nmax do
    init(diffs[i]);
  i := 1; i2 := 1; di2 := 1;
  while i2 < nmax do begin
    j := i; dj2 := di2; j2 := i2;
    j2max := nmax - i2;
    while j2 < j2max do begin
      p.z1 := i; p.z4 := j;
      nilAppend(diffs[j2 - i2], p);
      j := j + 1; dj2 := dj2 + 2; j2 := j2 + dj2;
    end;
    i := i + 1; di2 := di2 + 2; i2 := i2 + di2;
  end;  
end;

procedure divsSieve;
var i, i2, j: integer;
begin
  divs[1] := 1;
  for i := 2 to dnmax do
    divs[i] := 2;
  for i := 2 to isqrt(dnmax) do begin
    i2 := sqr(i); j := i2 + i;
    divs[i2] := divs[i2] + 1;
    while j <= dnmax do begin
      divs[j] := divs[j] + 2;
      j := j + i;
    end;
  end;
end;

function f (const x1, x4, y1, y4: integer): integer;
var sx11, sx12, sx21, sy11, sy12, sy21, n, nx, ny: int64;
begin
  sx11 := x1 + x4; sx12 := sx11 * sx11; sx21 := x1 * x1 + x4 * x4;
  sy11 := y1 + y4; sy12 := sy11 * sy11; sy21 := y1 * y1 + y4 * y4;
  n := (sy12 * sy21 - sx12 * sx21) div (sy12 - sx12);
  if n >= nmax then
    f := 0
  else begin
    nx := (n - sx21) div 2; ny := (n - sy21) div 2;
    f := divs[nx div isqrt(nx div gcd(nx, ny)) div (sy11 div gcd(sx11, sy11))];
  end;
end;

var i, j, t, s: integer;
    b1, b2: boolean; p1, p2: PElem;
    time: TDateTime;
begin
  time := now;
  diffsSieve();
  divsSieve();
  s := 0;
  for i := 0 to nmax do begin
    b1 := true; p1 := diffs[i].head;
    while b1 and (p1 <> nil) do begin
      b1 := false; b2 := true; p2 := p1^.next;
      while b2 and (p2 <> nil) do begin
        t := f(p1^.x.z1, p1^.x.z4, p2^.x.z1, p2^.x.z4);
        if t <> 0 then begin
          if p1^.x.z1 <> p1^.x.z4 then
            t := t * 2;
          s := s + t; b1 := true;
          p2 := p2^.next;
        end else b2 := false;
      end;
      p1 := p1^.next;
    end;
  end;
  writeln(s);
  writeln(formatDateTime('ss:z', now - time));
  readln;
end.
