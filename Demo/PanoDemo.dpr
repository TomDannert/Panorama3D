program PanoDemo;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main in 'Main.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
