unit USquareTest;

interface

function isSquare (const n: int64): boolean;

implementation

var i: integer; mods: array [0..255] of boolean;

function isSquare (const n: int64): boolean;
var t: int64;
begin
  if mods[n and 255] then begin
    t := round(sqrt(n+0.0));
    isSquare := t * t = n;
  end else isSquare := false;
end;

initialization

for i := 0 to 255 do  begin
  mods[i] := false;
  mods[sqr(i) and 255] := true;
end;

end.
