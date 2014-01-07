unit uAnt;

interface

uses
  uAntWorld;

type
  TAnt = class
    X, Y: integer;
    Face: byte;
    Rule: array of boolean;
    constructor Create(const aHHP: Cardinal);

    function GetHHP: Cardinal;
    function GetRule: String;

    procedure CenterIn(const aWorld: TAntWorld);
    function Run(const aWorld: TAntWorld): boolean;
  end;

const
  FACE_RIGHT = 0;
  FACE_UP = 1;
  FACE_LEFT = 2;
  FACE_DOWN = 3;

implementation

{ TAnt }

constructor TAnt.Create(const aHHP: Cardinal);
var
  h: Cardinal;
  i: integer;
  rtmp: array of boolean;
begin
  inherited Create;
  Face:= FACE_DOWN;

  h:= aHHP;
  SetLength(rtmp, 0);
  i:= 0;
  while h > 1 do begin          // 1 = das füllbit
    SetLength(rtmp, i+1);
    rtmp[i]:= (h and 1) > 0;
    inc(i);
    h := h shr 1;
  end;
  SetLength(Rule, Length(rtmp));
  for i:= 0 to high(Rule) do
    Rule[i]:= rtmp[high(Rule) - i];
end;

function TAnt.GetHHP: Cardinal;
var
  i: integer;
begin
  Result:= 1;
  for i:= 0 to High(Rule) do begin
    Result:= (Result shl 1) or Byte(ord(Rule[i]) and 1);
  end;
end;

function TAnt.GetRule: String;
var
  i: integer;
begin
  SetLength(Result, Length(Rule));
  for i:= 0 to High(Rule) do begin
    if Rule[i] then
      Result[i+1]:= 'R'
    else
      Result[i+1]:= 'L';
  end;
end;

procedure TAnt.CenterIn(const aWorld: TAntWorld);
begin
  X:= aWorld.Width div 2;
  Y:= aWorld.Height div 2;
end;

function TAnt.Run(const aWorld: TAntWorld): boolean;
const
  NewFace: array[false..true, 0..3] of byte = (
    (1,2,3,0),
    (3,0,1,2)
  );
var
  curr: byte;
begin
  inc(aWorld.Generation);

  curr:= aWorld.Field[X,Y];
  aWorld.Field[X,Y]:= (curr + 1) mod length(Rule);

  Face:= newFace[Rule[curr], Face];
  case Face of
    FACE_RIGHT: inc(X);
    FACE_UP: inc(Y);
    FACE_LEFT: dec(X);
    FACE_DOWN: dec(Y);
  end;
  Result:= aWorld.WrapCoords(X,Y);
end;

end.
