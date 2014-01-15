unit uViewForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Spin, uAntWorld, uAnt, Math;

type
  TfmTurmites = class(TForm)
    tmrSim: TTimer;
    tmrRandomizeRule: TTimer;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    btnRandom: TButton;
    seColors: TSpinEdit;
    cbAutoRnd: TCheckBox;
    Label2: TLabel;
    btnEnter: TButton;
    GroupBox2: TGroupBox;
    sePerImage: TSpinEdit;
    Label1: TLabel;
    Label3: TLabel;
    btnSaveCurr: TButton;
    GroupBox3: TGroupBox;
    cbUnscaled: TCheckBox;
    cbMonochrome: TCheckBox;
    lbLastRules: TListBox;
    cbPause: TCheckBox;
    lbGenPerS: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure tmrSimTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnRandomClick(Sender: TObject);
    procedure btnSaveCurrClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnEnterClick(Sender: TObject);
    procedure cbAutoRndClick(Sender: TObject);
    procedure tmrRandomizeRuleTimer(Sender: TObject);
    procedure cbUnscaledClick(Sender: TObject);
    procedure lbLastRulesClick(Sender: TObject);
    procedure cbPauseClick(Sender: TObject);
  private
    { Private-Deklarationen }
    fWorld: TAntWorld;
    fAnt: TAnt;
    genpers: double;
    lastgentime: Cardinal;
    procedure BeginComp(hhp: Cardinal);
  public
    { Public-Deklarationen }
  end;

var
  fmTurmites: TfmTurmites;

implementation

uses
  gifimage;

{$R *.dfm}

procedure TfmTurmites.FormCreate(Sender: TObject);
begin
  DoubleBuffered:= true;
  Randomize;
  btnRandom.Click;
  genpers:= 0.0;
end;

procedure TfmTurmites.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fAnt);
  FreeAndNil(fWorld);
end;

procedure TfmTurmites.FormPaint(Sender: TObject);
begin
  if cbUnscaled.Checked then begin
    Canvas.Draw(0,0,fWorld);
  end else begin
    Canvas.StretchDraw(Rect(0,0,fWorld.Width * 2, fWorld.Height * 2),fWorld);
  end;
end;

procedure TfmTurmites.tmrSimTimer(Sender: TObject);
var
  i, m: integer;
  t: Cardinal;
  pg: Int64;
begin
  m:= StrToIntDef(sePerImage.Text, 1);
  pg:= fWorld.Generation;
  for i:= 1 to m do begin
    if not fAnt.Run(fWorld) then begin
      tmrSim.Enabled:= false;
      break;
    end;
  end;
  Label1.Caption:= IntToStr(fWorld.Generation);
  Refresh;
  if m < 100 then
    Sleep(2)
  else
  if m < 10000 then
    Sleep(0);
  t:= GetTickCount;
  genpers:= 0.5 * (genpers + (fWorld.Generation-pg)/((t-lastgentime+1)/1000));
  lastgentime:= t;
  lbGenPerS.Caption:= Format('%8.2f M/s', [genpers/1E6]);
end;

procedure TfmTurmites.BeginComp(hhp: Cardinal);
var
  colors: integer;
  s: string;
begin
  FreeAndNil(fWorld);
  FreeAndNil(fAnt);
  cbPause.Enabled:= False;
  cbPause.Checked:= True;
  try
    fAnt:= TAnt.Create(hhp);
  except
    fAnt:= nil;
    raise;
  end;

  fWorld:= TAntWorld.Create(513, 513);
  fWorld.Wrap:= false;
  fAnt.CenterIn(fWorld);
  colors:= length(fAnt.GetRule);
  if cbMonochrome.Checked then
    fWorld.SetAntPalette(plMonochrome, colors)
  else
    fWorld.SetAntPalette(plColor, colors);
  Caption:= format('HHP: %u  Rule: %s  on %dx%dx%d', [fAnt.GetHHP, fAnt.GetRule, fWorld.Width, fWorld.Height, Colors]);
  s:= IntToStr(int64(fAnt.GetHHP));
  if lbLastRules.Items.IndexOf(s) >= 0 then
    lbLastRules.Items.Delete(lbLastRules.Items.IndexOf(s));
  lbLastRules.Items.Insert(0, s);

  lastgentime:= GetTickCount;

  cbPause.Checked:= False;
  cbPause.Enabled:= True;
end;

procedure TfmTurmites.btnRandomClick(Sender: TObject);
var
  hhp: Cardinal;
begin
  hhp:= (1 shl seColors.Value);
  hhp:= hhp or Cardinal(Random(1 shl seColors.Value));
  BeginComp(hhp);
end;

procedure TfmTurmites.btnEnterClick(Sender: TObject);
var
  def: string;
begin
  if Assigned(fAnt) then
    def:= IntToStr(fAnt.GetHHP)
  else
    def:= '5';
  BeginComp(StrToInt(InputBox('Load HHP', 'Enter HHP', def)));
end;

procedure TfmTurmites.btnSaveCurrClick(Sender: TObject);
var
  gif: TGIFImage;
begin
  gif:= TGIFImage.Create;
  try
    gif.Assign(fWorld);
    gif.SaveToFile(format('%s\%.5u.gif', [ExtractFilePath(ParamStr(0)), fAnt.GetHHP]));
  finally
    FreeAndNil(gif);
  end;
end;

procedure TfmTurmites.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of                
    VK_F1: btnRandom.Click;
    VK_F2: btnSaveCurr.Click;       
    VK_F3: btnEnter.Click;
  end;
end;

procedure TfmTurmites.cbAutoRndClick(Sender: TObject);
begin
  tmrRandomizeRule.Enabled:= cbAutoRnd.Checked;
end;

procedure TfmTurmites.tmrRandomizeRuleTimer(Sender: TObject);
begin
  btnRandom.Click;
end;

procedure TfmTurmites.cbUnscaledClick(Sender: TObject);
begin
  Refresh;
end;

procedure TfmTurmites.lbLastRulesClick(Sender: TObject);
begin
  if lbLastRules.ItemIndex >= 0 then
    BeginComp(StrToInt64(lbLastRules.Items[lbLastRules.ItemIndex]));
end;

procedure TfmTurmites.cbPauseClick(Sender: TObject);
begin
  tmrSim.Enabled:= not cbPause.Checked;
end;

end.
