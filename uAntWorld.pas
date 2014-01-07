unit uAntWorld;

interface

uses
  Windows, SysUtils, Graphics;

type
  TAntWorld = class(TBitmap)
  private
    fWrap: boolean;
    fPixels: array of PByteArray;
    function GetField(X, Y: integer): byte;
    procedure SetField(X, Y: integer; const Value: byte);
  public      
    Generation: int64;
    constructor Create(const aWidth, aHeight: integer); reintroduce;
    property Wrap: boolean read fWrap write fWrap;
    property Field[X, Y: integer]: byte read GetField write SetField;
    function WrapCoords(var X,Y: integer): boolean;
    procedure Clear;                  
  end;

implementation

{ TAntWorld }

function PalEntry(C: TColor): TPaletteEntry;
begin
  Result.peRed:= GetRValue(C);
  Result.peGreen:= GetGValue(C);
  Result.peBlue:= GetBValue(C);
  Result.peFlags:= 0;
end;

procedure TAntWorld.Clear;
var
  x,y: integer;
begin
  SetLength(fPixels, Height);
  for y:= 0 to Height-1 do begin
    fPixels[y]:= ScanLine[y];
    for x:= 0 to Width-1 do
      Field[x,y]:= 0;
  end;
  Generation:= 0;
end;

constructor TAntWorld.Create(const aWidth, aHeight: integer);
var
  pal: TMaxLogPalette;

  procedure PushColor(C: TColor);
  begin
    pal.palPalEntry[pal.palNumEntries]:= PalEntry(C);
    inc(pal.palNumEntries);
  end;
begin
  inherited Create;
  PixelFormat:= pf8bit;

  pal.palVersion:= $0300;
  pal.palNumEntries:= 0;
                        
  PushColor(clWhite);
  PushColor(clBlack);
  PushColor(clLime);
  PushColor(clBlue);
  PushColor(clMaroon);
  PushColor(clTeal);
  PushColor(clGray);
  PushColor(clNavy);
  PushColor(clFuchsia);
  PushColor(clGreen);
  PushColor(clOlive);
  PushColor(clPurple);
  PushColor(clSilver);
  PushColor(clRed);
  PushColor(clYellow);
  PushColor(clAqua);
  PushColor(clLtGray);
  PushColor(clDkGray);

  Palette:= CreatePalette(PLOGPALETTE(@pal)^);

  Width:= aWidth;
  Height:= aHeight;

  Wrap:= true;
  Clear;
end;

function TAntWorld.GetField(X, Y: integer): byte;
begin
  if WrapCoords(X, Y) then
    Result:= fpixels[Y]^[X]
  else
    Result:= 0;
end;

procedure TAntWorld.SetField(X, Y: integer; const Value: byte);
begin
  if WrapCoords(X, Y) then
    fpixels[Y]^[X]:= Value;
end;

function TAntWorld.WrapCoords(var X, Y: integer): boolean;
begin
  if fWrap then begin
    Result:= true;
    X:= (X + Width) mod Width;
    Y:= (Y + Height) mod Height;
  end else begin
    Result:= (X>=0) and (Y>=0) and (X<Width) and (Y<Height);
  end;
end;     



end.
