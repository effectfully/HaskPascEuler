unit UList;

interface

type TPair = record
               z1, z4: integer;
             end;
     TElem = TPair;
     PElem = ^RElem;
     RElem = record
               x: TElem;
               next: PElem;
             end;
     TPRec = record
               head, tail: PElem;
             end;

procedure init (var r: TPRec);
procedure nilAppend (var r: TPRec; const val: TElem);

implementation

procedure init (var r: TPRec);
begin
  r.head := nil;
  r.tail := nil;
end;

procedure nilAppend (var r: TPRec; const val: TElem);
var p: ^PElem;
begin
  if r.head = nil then
    p := @r.head
  else p := @r.tail^.next;
  new(p^);
  r.tail := p^;
  r.tail^.x := val;
  r.tail^.next := nil;
end;

end.
