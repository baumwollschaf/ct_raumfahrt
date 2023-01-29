program ctRF;

uses
  System.StartUpCopy,
  FMX.Forms,
  ct.raumfahrt.forms.ctrfMainForm in 'ct.raumfahrt.forms.ctrfMainForm.pas' {ctrfMainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TctrfMainForm, ctrfMainForm);
  Application.Run;
end.
