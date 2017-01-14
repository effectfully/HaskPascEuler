program Project2;

{$APPTYPE CONSOLE}

uses
  SysUtils;

const n = 10000000;
      sqrtn = 3163;

function ilog (const x, b: real): integer;
begin
  ilog := trunc(ln(x) / ln(b));
end;

var txtprs: TextFile;
    primes: array [1..n] of integer; //too many, actually
    lenprs: integer;
    pows: array [2..sqrtn, 1..23] of integer;

function pow1 (const x, p: integer): integer;
begin
  if x > sqrtn then
    result := x
  else result := pows[x, p];
end;

procedure init;
var i, j, k, t: integer;
begin
  assignFile(txtprs, 'prs.txt');
  reset(txtprs);
  i := 1; read(txtprs, k);
  while k <= n do begin
    primes[i] := k;
    i := i + 1; read(txtprs, k);
  end;

  lenprs := i - 1;
  i := 1; t := primes[i];
  while t <= sqrtn do begin
    j := 1; k := t;
    while k <= n do begin
      pows[t, j] := k;
      j := j + 1; k := k * t;
    end;
    i := i + 1; t := primes[i];
  end;
end;

function f (const x, y: integer): integer;
var i, j, t: integer;
begin
  i := 1; result := 0;
  j := ilog(n / pow1(x, i), y);
  while j <> 0 do begin
    t := pow1(x, i) * pow1(y, j);
    if t > result then
      result := t;
    i := i + 1;
    j := ilog(n / pow1(x, i), y);
  end;
end;

var i, j, ti, tk: integer; k: int64; time: TDateTime;
begin
  time := now;
  init();

  i := 1; k := 0; ti := primes[i];
  while ti <= sqrtn do begin
    j := i + 1; tk := f(ti, primes[j]);
    while tk <> 0 do begin
      k := k + tk;
      j := j + 1; tk := f(ti, primes[j]);
    end;
    i := i + 1; ti := primes[i];
  end;

  writeln(k);
  writeln(formatDateTime('ss:z', now - time));
  readln;
end.
