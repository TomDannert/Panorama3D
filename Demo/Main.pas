unit Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Panorama,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TfrmMain = class(TForm)
    Pano: TPanorama3D;
    ToolBar1: TToolBar;
    BtnOpen: TButton;
    OpenDialog: TOpenDialog;
    procedure PanoChange(Sender: TObject);
    procedure BtnOpenClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

procedure TfrmMain.BtnOpenClick(Sender: TObject);
begin
  OpenDialog.Filter := TBitmapCodecManager.GetFilterString;
  if OpenDialog.Execute then
  try
    Pano.Bitmap.LoadFromFile(OpenDialog.Filename);
  except
    on E: Exception do
    begin
      ShowMessage(E.Message);
    end;
  end;
end;

procedure TfrmMain.PanoChange(Sender: TObject);
begin
//  Caption := 'X: ' + FormatFloat('0.00', Pano.CameraX) + ' Y:' + FormatFloat('0.00', Pano.CameraY) + ' Z:' + FormatFloat('0.00', Pano.Zoom);
end;

end.
