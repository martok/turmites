unit uAnt;

interface

{$OPTIMIZATION ON}

uses
  SysUtils, uAntWorld;

type
  EAntException = class(Exception);

  TAnt = class
    X, Y: integer;
    Face: Integer;
    Rule: array of boolean;
    RuleLength: integer;
    constructor Create(const aHHP: Cardinal);

    procedure SetHHP(const aHHP: Cardinal);
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
begin
  inherited Create;
  Face:= FACE_DOWN;

  SetHHP(aHHP);
end;

procedure TAnt.SetHHP(const aHHP: Cardinal);
var
  h: Cardinal;
  i: integer;
  rtmp: array of boolean;
begin
  if (aHHP < 4) then
    raise EAntException.CreateFmt('%u is not a valid HHP number (>4)', [aHHP]);
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
  RuleLength:= Length(Rule);
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
  curr, next, f: Integer;
begin
  inc(aWorld.Generation);

  curr:= aWorld.Field[X,Y];

  // next:= (curr+1) mod RuleLength, but faster
  next:= curr+1;
  if next = RuleLength then
    next:= 0;

  aWorld.Field[X,Y]:= next;

  f:= newFace[Rule[curr], Face];
  case f of
    FACE_RIGHT: inc(X);
    FACE_UP: inc(Y);
    FACE_LEFT: dec(X);
    FACE_DOWN: dec(Y);
  end;
  Face:= f;

  Result:= aWorld.WrapCoords(X,Y);
end;

end.
