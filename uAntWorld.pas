unit uAntWorld;

interface

uses
  Windows, SysUtils, Graphics;

type
  TAntPalette = (plMonochrome, plColor);
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
    procedure SetAntPalette(const aPalette: TAntPalette; const aCount: integer);
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
begin
  inherited Create;
  PixelFormat:= pf8bit;
  SetAntPalette(plColor, 18);

  Width:= aWidth;
  Height:= aHeight;

  Wrap:= true;
  Clear;
end;

procedure TAntWorld.SetAntPalette(const aPalette: TAntPalette; const aCount: integer);
var
  pal: TMaxLogPalette;
  y: integer;

  procedure PushColor(C: TColor);
  begin
    pal.palPalEntry[pal.palNumEntries]:= PalEntry(C);
    inc(pal.palNumEntries);
  end;

  procedure PalMono;
  var
    i: integer;
    k: byte;
  begin
    for i:= aCount-1 downto 0 do begin
      k:= 255 * i div (aCount-1);
      PushColor(RGB(k,k,k));
    end;
  end;

  procedure PalColor;
  begin
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
  end;

begin
  pal.palVersion:= $0300;
  pal.palNumEntries:= 0;

  case aPalette of
    plMonochrome: PalMono;
    plColor: PalColor;
  end;

  Palette:= CreatePalette(PLOGPALETTE(@pal)^);

  SetLength(fPixels, Height);
  for y:= 0 to Height-1 do
    fPixels[y]:= ScanLine[y];
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
