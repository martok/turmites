program Turmites;

uses
  Forms,
  uViewForm in 'uViewForm.pas' {fmTurmites},
  uAntWorld in 'uAntWorld.pas',
  uAnt in 'uAnt.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmTurmites, fmTurmites);
  Application.Run;
end.
