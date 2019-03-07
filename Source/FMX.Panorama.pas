unit FMX.Panorama;

{ *****************************************************************************
Copyright (C) 2019 by Thomas Dannert
Author: Thomas Dannert <thomas@dannert.com>
Website: www.dannert.com
{ *****************************************************************************
Panorama3D for Delphi Firemonkey is free software: you can redistribute it
and/or modify it under the terms of the GNU Lesser General Public License
version 3as published by the Free Software Foundation and appearing in the
included file.
Panorama3D for Delphi Firemonkey is distributed in the hope that it will be
useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
Lesser General Public License for more details.
You should have received a copy of the GNU Lesser General Public License
along with Dropbox Client Library. If not, see <http://www.gnu.org/licenses.
****************************************************************************** }

interface

uses
  System.Classes, System.Actions, System.Types, System.UITypes, System.UIConsts,
  System.Generics.Collections, System.Generics.Defaults, FMX.Controls, FMX.Types, FMX.Objects,
  FMX.Ani, FMX.Graphics, FMX.StdActns, FMX.Viewport3D, FMX.Controls3D, FMX.Objects3D,
  FMX.MaterialSources, FMX.InertialMovement, FMX.Types3D, System.Math.Vectors, FMX.Layers3D;

type
  TCustomPanorama3D = class;

  { **************************************************************************** }
  { TPanoControlSettings }
  { **************************************************************************** }

  TPanoPlacement = (TopLeft, TopCenter, TopRight, CenterLeft, CenterRight, BottomLeft, BottomCenter, BottomRight);

  TPanoControlSettings = class(TPersistent)
  private
    FPanorama  : TCustomPanorama3D;
    FDefault   : TPanoPlacement;
    FPlacement : TPanoPlacement;
    FOffsetX   : Integer;
    FOffsetY   : Integer;
    FSize      : Integer;
    FVisible   : Boolean;
    FOnChange  : TNotifyEvent;
    procedure SetPlacement(const AValue : TPanoPlacement);
    procedure SetOffsetX(const AValue : Integer);
    procedure SetOffsetY(const AValue : Integer);
    procedure SetSize(const AValue : Integer);
    procedure SetVisible(const AValue : Boolean);
    function IsPlacementStored : Boolean;
  public
    constructor Create(APanorama : TCustomPanorama3D; ADefaultPlacement : TPanoPlacement);
    procedure Assign(Source : TPersistent); override;
    procedure Changed; virtual;
    property OnChange : TNotifyEvent read FOnChange write FOnChange;
  published
    property Placement : TPanoPlacement read FPlacement write SetPlacement stored IsPlacementStored;
    property OffsetX : Integer read FOffsetX write SetOffsetX default 32;
    property OffsetY : Integer read FOffsetY write SetOffsetY default 32;
    property Size : Integer read FSize write SetSize default 32;
    property Visible : Boolean read FVisible write SetVisible default True;
  end;

  { **************************************************************************** }
  { TCustomPanorama3D }
  { **************************************************************************** }

  TCustomPanorama3D = class(TControl)
  private
    FAutoAnimate      : Boolean;
    FFill             : TBrush;
    FDown             : Boolean;
    FDownX            : Single;
    FDownY            : Single;
    FStartY           : Single;
    FLastDistance     : Integer;
    FMove             : Boolean;
    FMouseEvents      : Boolean;
    FUpdate           : Boolean;
    FViewPort         : TViewport3D;
    FCamera           : TCamera;
    FSkyBox           : TSphere;
    FSkyMat           : TTextureMaterialSource;
    FBitmap           : TBitmap;
    FRadarCtrl        : TControl;
    FRadar            : TPanoControlSettings;
    FControllerCtrl   : TControl;
    FController       : TPanoControlSettings;
    FCenterDummy      : TDummy;
    FRotateAnimation  : TFloatAnimation;
    FAniCalculations  : TAniCalculations;
    FOnChange         : TNotifyEvent;
    function GetPlaying : Boolean;
    procedure SetPlaying(const AValue : Boolean);
    function GetCameraX : Single;
    procedure SetCameraX(const AValue : Single);
    function GetCameraY : Single;
    procedure SetCameraY(const AValue : Single);
    function GetCameraZ : Single;
    procedure SetCameraZ(const AValue : Single);
    function GetZoom : Single;
    procedure SetZoom(const AValue : Single);
    procedure SetBitmap(const AValue : TBitmap);
    procedure SetFill(const AValue : TBrush);
    procedure SetRadar(const AValue : TPanoControlSettings);
    procedure SetController(const AValue : TPanoControlSettings);
    procedure DoViewportMouseLeave(Sender : TObject);
    procedure DoViewportMouseDown(Sender : TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure DoViewportMouseMove(Sender : TObject; Shift: TShiftState; X, Y: Single);
    procedure DoViewportMouseUp(Sender : TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure DoViewportMouseWheel(Sender : TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
    procedure DoViewportGesture(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure DoBitmapChanged(Sender : TObject);
    procedure DoFillChanged(Sender : TObject);
    //Animations and mouse events
    procedure DoUpdateAniCalculations(const AAniCalculations: TAniCalculations);
    procedure UpdateAniCalculations;
    function GetNormalizedAngle : Single;
    function GetControlRect(ASettings : TPanoControlSettings) : TRectF;
    procedure DoSettingsChanged(Sender : TObject);
  protected
    procedure DoRealign; override;
    procedure Loaded; override;
    procedure Resize; override;
    procedure StartScrolling;
    procedure StopScrolling;
    procedure ScrollingChanged;
    procedure AniMouseDown(const Touch: Boolean; const X, Y: Single); virtual;
    procedure AniMouseMove(const Touch: Boolean; const X, Y: Single); virtual;
    procedure AniMouseUp(const Touch: Boolean; const X, Y: Single); virtual;
    procedure KeyDown(var Key: Word; var KeyChar: System.WideChar; Shift: TShiftState); override;
    procedure Changed; virtual;
    function GetViewWidth : Single;
    function GetViewHeight : Single;
    function GetDefaultSize: TSizeF; override;
    procedure Paint; override;
    property Bitmap : TBitmap read FBitmap write SetBitmap;
    property Camera : TCamera read FCamera;
    property CenterDummy : TDummy read FCenterDummy;
    property Viewport : TViewport3D read FViewport;
    property OnChange : TNotifyEvent read FOnChange write FOnChange;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure Play;
    procedure Stop;
    procedure MoveLeft;
    procedure MoveRight;
    procedure MoveUp;
    procedure MoveDown;
    property Radar : TPanoControlSettings read FRadar write SetRadar;
    property Controller : TPanoControlSettings read FController write SetController;
    property Playing : Boolean read GetPlaying write SetPlaying;
    property ViewWidth : Single read GetViewWidth;
    property ViewHeight : Single read GetViewHeight;
    property AutoAnimate : Boolean read FAutoAnimate write FAutoAnimate default True;
    property Fill : TBrush read FFill write SetFill;
    property CameraX : Single read GetCameraX write SetCameraX stored False;
    property CameraY : Single read GetCameraY write SetCameraY stored False;
    property CameraZ : Single read GetCameraZ write SetCameraZ stored False;
    property Zoom : Single read GetZoom write SetZoom stored False;
  end;

  TPanorama3D = class(TCustomPanorama3D)
  published
    property OnChange;
    property AutoAnimate;
    property Align;
    property Bitmap;
    property Fill;
    property Controller;
    property Radar;
    property CanFocus default True;
    property Cursor default crDefault;
    property DragMode default TDragMode.dmManual;
    property EnableDragHighlight default True;
    property HitTest;
    property Enabled;
    property Height;
    property Padding;
    property Opacity;
    property Margins;
    property PopupMenu;
    property Position;
    property Scale;
    property Size;
    property TabStop;
    property TabOrder;
    property TouchTargetExpansion;
    property Visible;
    property Width;
    property OnDragEnter;
    property OnDragLeave;
    property OnDragOver;
    property OnDragDrop;
    property OnDragEnd;
    property OnKeyDown;
    property OnKeyUp;
    property OnCanFocus;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnPainting;
    property OnPaint;
    property OnResize;
  end;

implementation

uses System.Math, System.SysUtils;

type
  TPanoRadar = class(TControl)
  private
    FPanorama : TCustomPanorama3D;
  public
    constructor Create(APanorama : TCustomPanorama3D); virtual;
    destructor Destroy; override;
    procedure Paint; override;
    property Panorama : TCustomPanorama3D read FPanorama;
  end;

constructor TPanoRadar.Create(APanorama : TCustomPanorama3D);
begin
  inherited Create(APanorama);
  FPanorama := APanorama;
end;

destructor TPanoRadar.Destroy;
begin
  inherited Destroy;
end;

procedure TPanoRadar.Paint;
const
  InnerRadius = 4;
var
  R : TRectF;
  C : TPointF;
  S : Single;
  P : TPathData;
  StartAngle, EndAngle, Radius, Thickness : Single;
begin
  R := LocalRect;
  C := R.CenterPoint;
  S := R.Width / 2;
  Canvas.Fill.Kind := TBrushKind.Solid;
  Canvas.Fill.Color := MakeColor(TAlphaColors.Black, 0.5);
  Canvas.FillEllipse(R, AbsoluteOpacity);
  R := RectF(C.X - InnerRadius, C.Y - InnerRadius, C.X + InnerRadius, C.Y + InnerRadius);
  Canvas.Fill.Color := TAlphaColors.White;
  Canvas.FillEllipse(R, AbsoluteOpacity);
  S := (LocalRect.Width / 2) - 3;
  R := RectF(C.X - S, C.Y - S, C.X + S, C.Y + S);
  Canvas.Stroke.Kind := TBrushKind.Solid;
  Canvas.Stroke.Dash := TStrokeDash.Solid;
  Canvas.Stroke.Thickness := 2;
  Canvas.Stroke.Color := TAlphaColors.White;
  Canvas.DrawEllipse(R, AbsoluteOpacity);

  P := TPathData.Create;
  try
    StartAngle := FPanorama.CameraY - (FPanorama.ViewWidth / 2) - 90;
    if StartAngle < 0 then StartAngle := StartAngle + 360;
    EndAngle   := FPanorama.ViewWidth;
    Radius     := (LocalRect.Width / 2) - 6;
    Thickness  := Radius - 6;
    P.AddArc(C, PointF(Radius, Radius), StartAngle, EndAngle);
    P.AddArc(C, PointF(Radius - Thickness, Radius - Thickness), StartAngle + EndAngle, -EndAngle);
    P.ClosePath;
    Canvas.Fill.Color := TAlphaColors.White;
    Canvas.FillPath(P, AbsoluteOpacity);
  finally
    FreeAndNil(P);
  end

end;

const
  ARROW_LEFT  : String = 'M63.007,8.985 C63.007,8.011 62.574,7.145 61.924,6.496 L61.924,6.496 L56.511,1.083 C55.862,0.433 54.887,0.000 54.021,0.000 L54.021,0.000 C53.155,0.000 ' + '52.181,0.433 51.531,1.083 L51.531,1.083 L1.083,51.531 C0.433,52.181 0.000,53.155 0.000,54.021 L0.000,54.021 ' + 'C0.000,54.887 0.433,55.862 1.083,56.511 L1.083,56.511 L51.531,106.960 C52.181,107.609 53.155,108.042 54.021,108.042 L54.021,108.042 C54.887,108.042 ' + '55.862,107.609 56.511,106.960 L56.511,106.960 L61.924,101.547 C62.574,100.897 ' + '63.007,99.923 63.007,99.057 L63.007,99.057 ' + 'C63.007,98.191 62.574,97.217 61.924,96.567 L61.924,96.567 L19.378,54.021 L61.924,11.475 C62.574,10.826 63.007,9.852 63.007,8.985 L63.007,8.985 Z';
  ARROW_RIGHT : String = 'M63.007,54.021 C63.007,53.155 62.574,52.181 61.924,51.531 L61.924,51.531 L11.475,1.083 C10.826,0.433 9.852,0.000 8.985,0.000 L8.985,0.000 C8.119,0.000 ' + '7.145,0.433 6.496,1.083 L6.496,1.083 L1.083,6.496 C0.433,7.145 0.000,8.119 0.000,8.985 L0.000,8.985 C0.000,9.852 0.433,10.826 1.083,11.475 L1.083,11.475 L43.628,54.021 L1.083,96.567 C0.433,97.217 0.000,98.191 0.000,99.057 L0.000,99.057 C0.000,100.031 ' + '0.433,100.897 1.083,101.547 L1.083,101.547 L6.496,106.960 C7.145,107.609 8.119,108.042 ' + '8.985,108.042 L8.985,108.042 C9.852,108.042 ' + '10.826,107.609 11.475,106.960 L11.475,106.960 L61.924,56.511 C62.574,55.862 63.007,54.887 63.007,54.021 L63.007,54.021 Z';
  ARROW_UP    : String = 'M108.042,54.021 C108.042,53.155 107.609,52.181 106.960,51.531 L106.960,51.531 L56.511,1.083 C55.862,0.433 54.887,0.000 54.021,0.000 L54.021,0.000 ' + 'C53.155,0.000 52.181,0.433 51.531,1.083 L51.531,1.083 L1.083,51.531 C0.433,52.181 0.000,53.155 0.000,54.021 ' + 'L0.000,54.021 C0.000,54.887 0.433,55.862 1.083,56.511 L1.083,56.511 L6.496,61.924 C7.145,62.574 8.119,63.007 8.985,63.007 L8.985,63.007 C9.852,63.007 ' + '10.826,62.574 11.475,61.924 L11.475,61.924 L54.021,19.378 L96.567,61.924 C97.217,62.574 ' + '98.191,63.007 99.057,63.007 L99.057,63.007 ' + 'C100.031,63.007 100.897,62.574 101.547,61.924 L101.547,61.924 L106.960,56.511 C107.609,55.862 108.042,54.887 108.042,54.021 L108.042,54.021 Z';
  ARROW_DOWN  : String = 'M108.042,8.985 C108.042,8.119 107.609,7.145 106.960,6.496 L106.960,6.496 L101.547,1.083 C100.897,0.433 99.923,0.000 99.057,0.000 L99.057,0.000 ' + 'C98.191,0.000 97.217,0.433 96.567,1.083 L96.567,1.083 L54.021,43.628 L11.475,1.083 C10.826,0.433 9.852,0.000 ' + '8.985,0.000 L8.985,0.000 C8.011,0.000 7.145,0.433 6.496,1.083 L6.496,1.083 L1.083,6.496 C0.433,7.145 0.000,8.119 0.000,8.985 L0.000,8.985 C0.000,9.852 ' + '0.433,10.826 1.083,11.475 L1.083,11.475 L51.531,61.924 C52.181,62.574 53.155,63.007 ' + '54.021,63.007 L54.021,63.007 C54.887,63.007 55.862,62.574 ' + '56.511,61.924 L56.511,61.924 L106.960,11.475 C107.609,10.826 108.042,9.852 108.042,8.985 L108.042,8.985 Z';
  BUTTON_PAUSE: String = 'M76.214,114.321 C76.214,116.270 74.699,117.786 72.750,117.786 L72.750,117.786 L45.036,117.786 C43.087,117.786 41.571,116.270 41.571,114.321 ' + 'L41.571,114.321 L41.571,51.964 C41.571,50.016 43.087,48.500 45.036,48.500 L45.036,48.500 L72.750,48.500 C74.699,48.500 76.214,50.016 76.214,51.964 L76.214,51.964 L76.214,114.321 Z M124.714,114.321 ' + 'C124.714,116.270 123.199,117.786 121.250,117.786 L121.250,117.786 L93.536,117.786 C91.587,117.786 90.071,116.270 90.071,114.321 L90.071,114.321 L90.071,51.964 C90.071,50.016 91.587,48.500 ' + '93.536,48.500 L93.536,48.500 L121.250,48.500 C123.199,48.500 124.714,50.016 124.714,51.964 L124.714,51.964 L124.714,114.321 Z M166.286,83.143 C166.286,37.241 129.045,0.000 83.143,0.000 ' + 'L83.143,0.000 C37.241,0.000 0.000,37.241 0.000,83.143 L0.000,83.143 C0.000,129.045 37.241,166.286 83.143,166.286 L83.143,166.286 C129.045,166.286 166.286,129.045 166.286,83.143 L166.286,83.143 Z';
  BUTTON_PLAY : String = 'M83.000,0.000 C37.177,0.000 0.000,37.177 0.000,83.000 L0.000,83.000 C0.000,128.823 37.177,166.000 83.000,166.000 L83.000,166.000 C128.823,166.000 ' + '166.000,128.823 166.000,83.000 L166.000,83.000 C166.000,37.177 128.823,0.000 83.000,0.000 L83.000,0.000 Z M124.500,88.944 L65.708,123.527 C64.628,124.176 63.439,124.500 62.250,124.500 ' + 'L62.250,124.500 C61.061,124.500 59.872,124.176 58.792,123.635 L58.792,123.635 C56.630,122.339 55.333,120.069 55.333,117.583 L55.333,117.583 L55.333,48.417 C55.333,45.931 56.630,43.661 58.792,42.365 ' + 'L58.792,42.365 C60.953,41.176 63.655,41.176 65.708,42.473 L65.708,42.473 L124.500,77.056 C126.661,78.245 127.958,80.514 127.958,83.000 L127.958,83.000 C127.958,85.486 126.661,87.755 ' + '124.500,88.944 L124.500,88.944 Z';

type
  TPanoController = class(TControl)
  private
    FPanorama : TCustomPanorama3D;
    FArrow    : Integer;
    FIsHot    : Boolean;
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Single); override;
    procedure DoMouseLeave; override;
    procedure DoMouseEnter; override;
    function ArrowRect(const AArrow : Integer) : TRectF;
    function FindArrow(X, Y : Single; var AArrow : Integer) : Boolean;
  public
    constructor Create(APanorama : TCustomPanorama3D); virtual;
    destructor Destroy; override;
    procedure Paint; override;
    property Panorama : TCustomPanorama3D read FPanorama;
  end;

constructor TPanoController.Create(APanorama : TCustomPanorama3D);
begin
  inherited Create(APanorama);
  FPanorama := APanorama;
  TabStop := False;
  CanFocus := False;
  AutoCapture := True;
end;

destructor TPanoController.Destroy;
begin
  inherited Destroy;
end;

procedure TPanoController.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Single);
var
  Arrow : Integer;
begin
  inherited;
  if Button = TMouseButton.mbLeft then
  begin
    if FindArrow(X, Y, Arrow) then
    begin
      case Arrow of
        0: FPanorama.MoveUp;
        1: FPanorama.MoveDown;
        2: FPanorama.MoveLeft;
        3: FPanorama.MoveRight;
      else
        FPanorama.Playing := not FPanorama.Playing;
      end;
    end;
    Repaint;
  end;
end;

function TPanoController.ArrowRect(const AArrow : Integer) : TRectF;
var
  C : TPointF;
  S : Single;
  V : Single;
  P : TPointF;
  R : TRectF;
begin
  R := LocalRect;
  C := R.CenterPoint;
  S := R.Width / 2;
  V := S * 0.25;
  P := C;
  case AArrow of
    0: P := C - PointF(0, S * 0.7); //Up
    1: P := C + PointF(0, S * 0.7); //Down
    2: P := C - PointF(S * 0.7, 0); //Left
    3: P := C + PointF(S * 0.7, 0); //Right
  else //Middle Button
    V := S * 0.35;
    P := C;
  end;
  Result := RectF(P.X - V, P.Y - V, P.X + V, P.Y + V);
end;

function TPanoController.FindArrow(X, Y : Single; var AArrow : Integer) : Boolean;
var
  I : Integer;
  R : TRectF;
begin
  Result := False;
  for I := 0 to 4 do
  begin
    R := ArrowRect(I);
    R.Inflate(5, 5); //Make a little bit larger for touch
    if R.Contains(PointF(X, Y)) then
    begin
      AArrow := I;
      Result := True;
      Break;
    end;
  end;
end;

procedure TPanoController.DoMouseLeave;
begin
  inherited;
  FIsHot := False;
  Repaint;
end;

procedure TPanoController.DoMouseEnter;
begin
  inherited;
  FIsHot := True;
  Repaint;
end;


procedure TPanoController.Paint;
var
  R : TRectF;
  Path : TPathData;
begin
  R := LocalRect;
  Canvas.Fill.Kind := TBrushKind.Solid;
  if FIsHot then
  begin
    Canvas.Fill.Color := MakeColor(TAlphaColors.White, 0.8);
  end
  else begin
    Canvas.Fill.Color := MakeColor(TAlphaColors.White, 0.5);
  end;
  Canvas.FillEllipse(R, AbsoluteOpacity);
  Path := TPathData.Create;
  try
    //Draw Arrow Up
    Path.Data := ARROW_UP;
    R := ArrowRect(0);
    Path.FitToRect(R);
    Canvas.Fill.Color := TAlphaColors.Black;
    Canvas.FillPath(Path, AbsoluteOpacity);
    //Draw Arrow Down
    Path.Data := ARROW_DOWN;
    R := ArrowRect(1);
    Path.FitToRect(R);
    Canvas.FillPath(Path, AbsoluteOpacity);
    //Draw Arrow Left
    Path.Data := ARROW_LEFT;
    R := ArrowRect(2);
    Path.FitToRect(R);
    Canvas.FillPath(Path, AbsoluteOpacity);
    //Draw Arrow Right
    Path.Data := ARROW_RIGHT;
    R := ArrowRect(3);
    Path.FitToRect(R);
    Canvas.FillPath(Path, AbsoluteOpacity);
    //Draw Play
    if FPanorama.Playing then
    begin
      Path.Data := BUTTON_PAUSE;
    end
    else begin
      Path.Data := BUTTON_PLAY;
    end;
    R := ArrowRect(4);
    Path.FitToRect(R);
    Canvas.FillPath(Path, AbsoluteOpacity);
  finally
    FreeAndNil(Path);
  end

end;

{ **************************************************************************** }
{ TPanScrollCalculations }
{ **************************************************************************** }

type
  TPanScrollCalculations = class (TAniCalculations)
  private
    [Weak] FViewer: TCustomPanorama3D;
  protected
    procedure DoChanged; override;
    procedure DoStart; override;
    procedure DoStop; override;
  public
    constructor Create(AOwner: TPersistent); override;
    property Viewer: TCustomPanorama3D read FViewer;
  end;

constructor TPanScrollCalculations.Create(AOwner: TPersistent);
begin
  if not (AOwner is TCustomPanorama3D) then
  begin
    raise EArgumentException.Create('ArgumentInvalid');
  end;
  inherited Create(AOwner);
  FViewer := TCustomPanorama3D(AOwner);
end;

procedure TPanScrollCalculations.DoChanged;
begin
  inherited;
  if Assigned(FViewer) and (not (csDestroying in FViewer.ComponentState)) then FViewer.ScrollingChanged;
end;

procedure TPanScrollCalculations.DoStart;
begin
  inherited;
  if Assigned(FViewer) and (not (csDestroying in FViewer.ComponentState)) then FViewer.StartScrolling;
end;

procedure TPanScrollCalculations.DoStop;
begin
  inherited;
  if Assigned(FViewer) and (not (csDestroying in FViewer.ComponentState)) then FViewer.StopScrolling;
end;

{ **************************************************************************** }
{ TCustomPanorama3D }
{ **************************************************************************** }

constructor TCustomPanorama3D.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  SetAcceptsControls(True);
  AutoCapture := True;
  Cursor := crDefault;
  HitTest := True;
  CanFocus := True;
  FStartY := 0;
  FAutoAnimate := True;
  FFill := TBrush.Create(TBrushKind.Solid, TAlphaColors.Black);
  FFill.OnChanged := DoFillChanged;
  FBitmap := TBitmap.Create;
  FBitmap.OnChange := DoBitmapChanged;
  FRotateAnimation  := nil;
  FLastDistance     := 0;
  FViewport := TViewport3D.Create(Self);
  FViewport.Parent := Self;
  FViewPort.Stored := False;
  FViewPort.Locked := True;
  FViewPort.Visible := False;
  FViewPort.HitTest := True;
  FViewport.Color := TAlphaColors.Null;
  FViewPort.UsingDesignCamera := False;
  FViewport.Touch.InteractiveGestures := [TInteractiveGesture.Zoom];
  FViewPort.OnMouseDown  := DoViewportMouseDown;
  FViewPort.OnMouseMove  := DoViewportMouseMove;
  FViewPort.OnMouseUp    := DoViewportMouseUp;
  FViewPort.OnMouseLeave := DoViewportMouseLeave;
  FViewPort.OnMouseWheel := DoViewportMouseWheel;
  FViewport.OnGesture    := DoViewportGesture;

  FSkyBox := TSphere.Create(FViewport);
  FSkyBox.Parent := FViewport;
  FSkyBox.TwoSide := True;
  FSkyBox.SubDivisionsAxes := 32;
  FSkyBox.SubdivisionsHeight := 24;
  FSkyBox.Width := 1000;
  FSkyBox.Height := 1000;
  FSkyBox.Depth := 1000;
  FSkyBox.ZWrite := True;
  FSkyBox.Locked := True;
  FSkyBox.HitTest := False;
  FSkyBox.Stored := False;
  FSkyBox.Projection := TProjection.Camera;

  FSkyMat := TTextureMaterialSource.Create(FSkyBox);
  FSkyMat.Parent := FSkyBox;
  FSkyMat.Stored := False;
  FSkyBox.MaterialSource := FSkyMat;

  FCenterDummy := TDummy.Create(nil);
  FCenterDummy.Parent := FViewPort;
  FCenterDummy.Stored := False;
  FCenterDummy.Locked := True;
  FCenterDummy.Projection := TProjection.Camera;

  FCamera := TCamera.Create(nil);
  FCamera.Locked := True;
  FCamera.Stored := False;
  FCamera.Parent := FCenterDummy;
  FCamera.Target := FCenterDummy;
  FCamera.Position.Z := -100;
  FCamera.AngleOfView := 50;
  FCamera.Projection := TProjection.Camera;
  FCamera.ZWrite := True;
  FViewPort.Camera := FCamera;

  FRadar := TPanoControlSettings.Create(Self, TPanoPlacement.TopRight);
  FRadar.OnChange := DoSettingsChanged;
  FRadarCtrl := TPanoRadar.Create(Self);
  FRadarCtrl.Parent := Self;
  FRadarCtrl.Locked := True;
  FRadarCtrl.Stored := False;

  FController := TPanoControlSettings.Create(Self, TPanoPlacement.BottomRight);
  FController.OnChange := DoSettingsChanged;
  FControllerCtrl := TPanoController.Create(Self);
  FControllerCtrl.Parent := Self;
  FControllerCtrl.Locked := True;
  FControllerCtrl.Stored := False;

  UpdateAniCalculations;
end;

destructor TCustomPanorama3D.Destroy;
begin
  FreeAndNil(FRotateAnimation);
  FreeAndNil(FCamera);
  FreeAndNil(FCenterDummy);
  FreeAndNil(FSkyMat);
  FreeAndNil(FSkyBox);
  FreeAndNil(FViewport);
  FreeAndNil(FBitmap);
  FreeAndNil(FFill);
  FreeAndNil(FRadar);
  FreeAndNil(FController);
  inherited Destroy;
end;

procedure TCustomPanorama3D.SetRadar(const AValue : TPanoControlSettings);
begin
  FRadar.Assign(AValue);
end;

procedure TCustomPanorama3D.SetController(const AValue : TPanoControlSettings);
begin
  FController.Assign(AValue);
end;

procedure TCustomPanorama3D.DoSettingsChanged(Sender: TObject);
begin
  Realign;
end;

procedure TCustomPanorama3D.SetFill(const AValue: TBrush);
begin
  FFill.Assign(AValue);
end;

procedure TCustomPanorama3D.DoFillChanged(Sender: TObject);
begin
  Repaint;
end;

function TCustomPanorama3D.GetDefaultSize: TSizeF;
begin
  Result.cx := 200;
  Result.cy := 200;
end;

function TCustomPanorama3D.GetZoom : Single;
begin
  Result := (FCamera.AngleOfView - 25) * 2;
end;

procedure TCustomPanorama3D.SetZoom(const AValue: Single);
begin
  if AValue <> GetZoom then
  begin
    FCamera.AngleOfView := 25 + (AValue * 0.5);
    Changed;
  end;
end;

function TCustomPanorama3D.GetCameraX : Single;
begin
  Result := FCenterDummy.RotationAngle.X;
end;

procedure TCustomPanorama3D.SetCameraX(const AValue: Single);
var
  Y : Single;
begin
  if AValue <> GetCameraX then
  begin
    Y := GetCameraY;
    FCenterDummy.ResetRotationAngle;
    FCenterDummy.RotationAngle.Z := 0;
    FCenterDummy.RotationAngle.Y := Y;
    FCenterDummy.RotationAngle.X := AValue;
    FCenterDummy.RotationAngle.Z := GetNormalizedAngle;
    Changed;
  end;
end;

function TCustomPanorama3D.GetCameraY : Single;
begin
  Result := FCenterDummy.RotationAngle.Y;
end;

procedure TCustomPanorama3D.SetCameraY(const AValue: Single);
var
  X : Single;
  Y : Single;
begin
  Y := DegNormalize(AValue + FStartY);
  if Y <> GetCameraY then
  begin
    X := GetCameraX;
    FCenterDummy.ResetRotationAngle;
    FCenterDummy.RotationAngle.Z := 0;
    FCenterDummy.RotationAngle.Y := Y;
    FCenterDummy.RotationAngle.X := X;
    FCenterDummy.RotationAngle.Z := GetNormalizedAngle;
    Changed;
  end;
end;

function TCustomPanorama3D.GetCameraZ : Single;
begin
  Result := FCenterDummy.RotationAngle.Z;
end;

procedure TCustomPanorama3D.SetCameraZ(const AValue: Single);
begin
  if AValue <> GetCameraZ then
  begin
    FCenterDummy.RotationAngle.Z := AValue;
    Changed;
  end;
end;

function TCustomPanorama3D.GetPlaying : Boolean;
begin
  Result := Assigned(FRotateAnimation) and FRotateAnimation.Running;
end;

procedure TCustomPanorama3D.SetPlaying(const AValue: Boolean);
begin
  if AValue <> GetPlaying then
  begin
    if AValue then
      Play
    else
      Stop;
  end;
end;

procedure TCustomPanorama3D.Play;
begin
  if Assigned(FRotateAnimation) and FRotateAnimation.Running then Exit;
  if not Assigned(FRotateAnimation) then
  begin
    FRotateAnimation := TFloatAnimation.Create(Self);
    FRotateAnimation.Parent := Self;
    FRotateAnimation.Stored := False;
    FRotateAnimation.Loop := True;
    FRotateAnimation.Duration := 20;
    FRotateAnimation.AutoReverse := False;
    FRotateAnimation.PropertyName := 'CameraY';
    FRotateAnimation.StartValue := 0;
    FRotateAnimation.StopValue := 360;
  end;
  FStartY := CameraY;
  FRotateAnimation.Start;
end;

procedure TCustomPanorama3D.Stop;
begin
  if Assigned(FRotateAnimation) then
  begin
    FRotateAnimation.StopAtCurrent;
    FStartY := 0;
  end;
end;

procedure TCustomPanorama3D.DoUpdateAniCalculations(const AAniCalculations: TAniCalculations);
begin
  AAniCalculations.TouchTracking := [ttVertical, ttHorizontal];
  AAniCalculations.Animation := True;
  AAniCalculations.BoundsAnimation := False;
  AAniCalculations.AutoShowing := False;
end;

procedure TCustomPanorama3D.UpdateAniCalculations;
begin
  if not (csDestroying in ComponentState) then
  begin
    if FAniCalculations = nil then
    begin
      FAniCalculations := TPanScrollCalculations.Create(Self);
    end;
    FAniCalculations.BeginUpdate;
    try
      DoUpdateAniCalculations(FAniCalculations);
    finally
      FAniCalculations.EndUpdate;
    end;
  end;
end;

procedure TCustomPanorama3D.StartScrolling;
begin
  if Assigned(FViewport.Scene) then
  begin
    FViewport.Scene.ChangeScrollingState(FViewport, True);
  end;
end;

procedure TCustomPanorama3D.StopScrolling;
begin
  if Assigned(FViewport.Scene) then
  begin
    FViewport.Scene.ChangeScrollingState(nil, False);
  end;
end;

procedure TCustomPanorama3D.AniMouseDown(const Touch: Boolean; const X, Y: Single);
begin
  if not Assigned(FAniCalculations) then Exit;
  FAniCalculations.Averaging := Touch;
  FAniCalculations.MouseDown(X, Y);
end;

procedure TCustomPanorama3D.AniMouseMove(const Touch: Boolean; const X, Y: Single);
begin
  if not Assigned(FAniCalculations) then Exit;
  FAniCalculations.MouseMove(X, Y);
  if FAniCalculations.Moved then TPanScrollCalculations(FAniCalculations).Shown := True;
end;

procedure TCustomPanorama3D.AniMouseUp(const Touch: Boolean; const X, Y: Single);
begin
  if not Assigned(FAniCalculations) then Exit;
  FAniCalculations.MouseUp(X, Y);
  if (FAniCalculations.LowVelocity) or (not FAniCalculations.Animation) then TPanScrollCalculations(FAniCalculations).Shown := False;
end;

procedure TCustomPanorama3D.KeyDown(var Key: Word; var KeyChar: System.WideChar; Shift: TShiftState);
begin
  inherited;
  case Key of
    vkUp:    MoveUp;
    vkDown:  MoveDown;
    vkLeft:  MoveLeft;
    vkRight: MoveRight;
    vkSpace: Playing := not Playing;
  end;
end;

//with this routine we stabilizes the z axis so that the camera does not tip over

function TCustomPanorama3D.GetNormalizedAngle : Single;
var
  CP, P1, P2 : TPoint3D;
  A : Single;

  function AngleOfPoints(AP1, AP2 : TPointF) : Single;
  var
    xDiff : Single;
    yDiff : Single;
  begin
    xDiff := AP2.X - AP1.X;
    yDiff := AP2.Y - AP1.Y;
    Result := System.Math.ArcTan2(yDiff, xDiff) * (360 / PI);
    if Result < 0 then Result := 360 + Result;
  end;

begin
  CP := FCamera.AbsoluteToLocal3D(FCenterDummy.LocalToAbsolute3D(Point3D(0, 0, 0)));
  P1 := FCamera.LocalToAbsolute3D(Point3D(CP.X - 500, CP.Y, CP.Z));
  P2 := FCamera.LocalToAbsolute3D(Point3D(CP.X + 500, CP.Y, CP.Z));
  A := AngleOfPoints(PointF(P1.X, P1.Y), PointF(P2.X, P2.Y));
  Result := DegNormalize(CenterDummy.RotationAngle.Z - A);
  if Round(Result * 100) = 36000 then Result := 0;
end;

procedure TCustomPanorama3D.DoViewportMouseWheel(Sender : TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
var
  Z : Single;
begin
  if WheelDelta > 0 then
  begin
    Z := Max(Zoom - 5, 0);
  end
  else begin
    Z := Min(Zoom + 5, 100);
  end;
  Zoom := Z;
end;

procedure TCustomPanorama3D.DoViewportMouseDown(Sender : TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
var
  RayPos, RayDir : TVector3D;
  PT : TPointD;
begin
  if not Assigned(FAniCalculations) then Exit;
  if TabStop and CanFocus then SetFocus;
  Stop;
  if Button = TMouseButton.mbRight then
  begin
    Self.StopPropertyAnimation('Zoom');
    if (Zoom > 75) then
    begin
      TAnimator.AnimateFloat(Self, 'Zoom', 50);
    end
    else if (Zoom > 25) then
    begin
      TAnimator.AnimateFloat(Self, 'Zoom', 0);
    end
    else begin
      TAnimator.AnimateFloat(Self, 'Zoom', 100);
    end;
  end
  else if Button = TMouseButton.mbLeft then
  begin
    FMouseEvents := True;
    FDown := True;
    FMove := (Button = TMouseButton.mbRight);
    FViewport.Cursor := crSize;
    FCamera.Context.Pick(X, Y, TProjection.Screen, RayPos, RayDir);
    FDownX := X;
    FDownY := Y;
    PT.X := FDownX;
    PT.Y := FDownY;
    FAniCalculations.ViewportPosition.SetLocation(PT);
    AniMouseDown(ssTouch in Shift, X, Y);
  end;
end;

function TCustomPanorama3D.GetViewWidth : Single;
var
  P1, P2 : TPoint3D;
  RayPos, RayDir : TVector3D;
begin
  Result := 1;
  if (csLoading in ComponentState) or (csDestroying in ComponentState) then Exit;
  FCamera.Context.Pick(0, 0, TProjection.Camera, RayPos, RayDir);
  P1 := RayPos + RayDir * RayPos.Length;
  P1 := FCenterDummy.AbsoluteToLocal3D(P1);
  FCamera.Context.Pick(FViewport.Width, 0, TProjection.Camera, RayPos, RayDir);
  P2 := RayPos + RayDir * RayPos.Length;
  P2 := FCenterDummy.AbsoluteToLocal3D(P2);
  Result := P2.X - P1.X;
end;

function TCustomPanorama3D.GetViewHeight : Single;
var
  P1, P2 : TPoint3D;
  RayPos, RayDir : TVector3D;
begin
  Result := 1;
  if (csLoading in ComponentState) or (csDestroying in ComponentState) then Exit;
  FCamera.Context.Pick(0, 0, TProjection.Camera, RayPos, RayDir);
  P1 := RayPos + RayDir * RayPos.Length;
  P1 := FCenterDummy.AbsoluteToLocal3D(P1);
  FCamera.Context.Pick(0, FViewport.Height, TProjection.Camera, RayPos, RayDir);
  P2 := RayPos + RayDir * RayPos.Length;
  P2 := FCenterDummy.AbsoluteToLocal3D(P2);
  Result := P2.Y - P1.Y;
end;

procedure TCustomPanorama3D.DoViewPortMouseMove(Sender : TObject; Shift: TShiftState; X, Y: Single);
var
  P : TPoint3D;
  RayPos, RayDir : TVector3D;
begin
  FCamera.Context.Pick(X, Y, TProjection.Camera, RayPos, RayDir);
  P := RayPos + RayDir * RayPos.Length;
  P := FCenterDummy.AbsoluteToLocal3D(P);
  if not Assigned(FAniCalculations) then Exit;
  FMouseEvents := True;
  if FAniCalculations.Down then
  begin
    AniMouseMove(ssTouch in Shift, X, Y);
  end;
end;

procedure TCustomPanorama3D.DoViewportGesture(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
var
  NewDistance : Integer;
  Z : Single;
begin
  if EventInfo.GestureID = igiZoom then
  begin
    if TInteractiveGestureFlag.gfBegin in EventInfo.Flags then
    begin
      FLastDistance := 0;
    end;
    if (not(TInteractiveGestureFlag.gfBegin in EventInfo.Flags)) and (not(TInteractiveGestureFlag.gfEnd in EventInfo.Flags)) then
    begin
      NewDistance := EventInfo.Distance - FLastDistance;
      if NewDistance > 0 then
      begin
        Z := Max(Zoom - 2, 0);
      end
      else begin
        Z := Min(Zoom + 2, 100);
      end;
      Zoom := Z;
      FLastDistance := EventInfo.Distance;
    end;
  end;
end;

procedure TCustomPanorama3D.ScrollingChanged;
var
  X, Y, Z : Single;
begin
  FUpdate := True;
  try
    Y := DegNormalize(CameraY + (FAniCalculations.ViewportPosition.X - FDownX) * 0.1);
    X := DegNormalize(CameraX - (FAniCalculations.ViewportPosition.Y - FDownY) * 0.1);
    FCenterDummy.ResetRotationAngle;
    FCenterDummy.RotationAngle.Z := 0;
    FCenterDummy.RotationAngle.Y := Y;
    FCenterDummy.RotationAngle.X := X;
    Z := GetNormalizedAngle;
    FCenterDummy.RotationAngle.Z := Z;
    FDownX := FAniCalculations.ViewportPosition.X;
    FDownY := FAniCalculations.ViewportPosition.Y;
    Changed;
  finally
    FUpdate := False;
  end;
end;

procedure TCustomPanorama3D.Resize;
begin
  inherited;
  Changed;
end;

procedure TCustomPanorama3D.Changed;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TCustomPanorama3D.DoViewportMouseUp(Sender : TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  if not Assigned(FAniCalculations) then Exit;
  if FAniCalculations.Down then
  begin
    FMouseEvents := True;
    if (Button = TMouseButton.mbLeft) then
    begin
      AniMouseUp(ssTouch in Shift, X, Y);
    end;
    FDown := False;
  end;
  FViewport.Cursor := crDefault;
end;

procedure TCustomPanorama3D.DoViewportMouseLeave(Sender: TObject);
begin
  if not Assigned(FAniCalculations) then Exit;
  if FMouseEvents and FAniCalculations.Down then
  begin
    FAniCalculations.MouseLeave;
    if (FAniCalculations.LowVelocity) or (not FAniCalculations.Animation) then
    begin
      TPanScrollCalculations(FAniCalculations).Shown := False;
    end;
  end;
end;

procedure TCustomPanorama3D.Loaded;
begin
  inherited;
  Realign;
end;

procedure TCustomPanorama3D.Paint;
begin
  Canvas.FillRect(LocalRect, 0, 0, [], 1, FFill);
end;

function TCustomPanorama3D.GetControlRect(ASettings : TPanoControlSettings) : TRectF;
var
  P : TPointF;
begin
  case ASettings.Placement of
    TopLeft:      Result.TopLeft := PointF(ASettings.OffsetX, ASettings.OffsetY);
    TopCenter:    Result.TopLeft := PointF((Width / 2) - (ASettings.Size / 2), ASettings.OffsetY);
    TopRight:     Result.TopLeft := PointF(Width - ASettings.OffsetX - ASettings.Size, ASettings.OffsetY);
    CenterLeft:   Result.TopLeft := PointF(ASettings.OffsetX, (Height / 2) - (ASettings.Size / 2));
    CenterRight:  Result.TopLeft := PointF(Width - ASettings.OffsetX - ASettings.Size, (Height / 2) - (ASettings.Size / 2));
    BottomLeft:   Result.TopLeft := PointF(ASettings.OffsetX, Height - ASettings.Size - ASettings.OffsetY);
    BottomCenter: Result.TopLeft := PointF((Width / 2) - (ASettings.Size / 2), Height - ASettings.Size - ASettings.OffsetY);
    BottomRight:  Result.TopLeft := PointF(Width - ASettings.OffsetX - ASettings.Size, Height - ASettings.Size - ASettings.OffsetY);
  else
    Result.TopLeft := PointF(0, 0);
  end;
  Result.BottomRight := Result.TopLeft + PointF(ASettings.Size, ASettings.Size);
end;

procedure TCustomPanorama3D.DoRealign;
var
  R : TRectF;
begin
  inherited;
  if FDisableAlign or (csDestroying in ComponentState) then Exit;
  FDisableAlign := True;
  try
    FViewPort.SetBounds(0, 0, Width, Height);
    if not FRadar.Visible then
    begin
      FRadarCtrl.Visible := False;
    end
    else begin
      R := GetControlRect(FRadar);
      FRadarCtrl.SetBounds(R.Left, R.Top, R.Width, R.Height);
      FRadarCtrl.Visible := True;
    end;
    if not FController.Visible then
    begin
      FControllerCtrl.Visible := False;
    end
    else begin
      R := GetControlRect(FController);
      FControllerCtrl.SetBounds(R.Left, R.Top, R.Width, R.Height);
      FControllerCtrl.Visible := True;
    end;
  finally
    FDisableAlign := False;
  end;
end;

procedure TCustomPanorama3D.MoveLeft;
begin
  Stop;
  StopPropertyAnimation('CameraY');
  TAnimator.AnimateFloat(Self, 'CameraY', CameraY - 90, 1, TAnimationType.InOut, TInterpolationType.Cubic);
end;

procedure TCustomPanorama3D.MoveRight;
begin
  Stop;
  StopPropertyAnimation('CameraY');
  TAnimator.AnimateFloat(Self, 'CameraY', CameraY + 90, 1, TAnimationType.InOut, TInterpolationType.Cubic);
end;

procedure TCustomPanorama3D.MoveUp;
begin
  Stop;
  StopPropertyAnimation('CameraX');
  TAnimator.AnimateFloat(Self, 'CameraX', CameraX + 45, 1, TAnimationType.InOut, TInterpolationType.Cubic);
end;

procedure TCustomPanorama3D.MoveDown;
begin
  Stop;
  StopPropertyAnimation('CameraX');
  TAnimator.AnimateFloat(Self, 'CameraX', CameraX - 45, 1, TAnimationType.InOut, TInterpolationType.Cubic);
end;

procedure TCustomPanorama3D.SetBitmap(const AValue: TBitmap);
begin
  FBitmap.Assign(AValue);
end;

procedure TCustomPanorama3D.DoBitmapChanged(Sender: TObject);
begin
  FCenterDummy.ResetRotationAngle;
  FCenterDummy.RotationAngle.Z := 0;
  FCenterDummy.RotationAngle.Y := 270;
  FCenterDummy.RotationAngle.X := 0;
  FCenterDummy.RotationAngle.Z := GetNormalizedAngle;
  FCamera.Position.Z := -100;
  FCamera.Position.Y := 0;
  FCamera.Position.X := 0;
  FSkyMat.Texture.Assign(FBitmap);
  FSkyMat.Texture.FlipHorizontal;
  FViewPort.Visible := not FBitmap.IsEmpty;
  if not FBitmap.IsEmpty and not (csDesigning in ComponentState) and FAutoAnimate then
  begin
    Play;
  end;
  Repaint;
end;

{ **************************************************************************** }
{ TPanoControlSettings }
{ **************************************************************************** }

constructor TPanoControlSettings.Create(APanorama : TCustomPanorama3D; ADefaultPlacement : TPanoPlacement);
begin
  inherited Create;
  FPanorama  := APanorama;
  FDefault   := ADefaultPlacement;
  FPlacement := FDefault;
  FOffsetX   := 32;
  FOffsetY   := 32;
  FSize      := 72;
  FVisible   := True;
end;

procedure TPanoControlSettings.Assign(Source : TPersistent);
begin
  if Source is TPanoControlSettings then
  begin
    FDefault   := TPanoControlSettings(Source).FDefault;
    FPlacement := TPanoControlSettings(Source).FPlacement;
    FOffsetX   := TPanoControlSettings(Source).FOffsetX;
    FOffsetY   := TPanoControlSettings(Source).FOffsetY;
    FSize      := TPanoControlSettings(Source).FSize;
    FVisible   := TPanoControlSettings(Source).FVisible;
  end
  else begin
    inherited;
  end;
end;

procedure TPanoControlSettings.Changed;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TPanoControlSettings.SetPlacement(const AValue : TPanoPlacement);
begin
  if AValue <> FPlacement then
  begin
    FPlacement := AValue;
    Changed;
  end;
end;

procedure TPanoControlSettings.SetOffsetX(const AValue : Integer);
begin
  if AValue <> FOffsetX then
  begin
    FOffsetX := Max(0, AValue);
    Changed;
  end;
end;

procedure TPanoControlSettings.SetOffsetY(const AValue : Integer);
begin
  if AValue <> FOffsetY then
  begin
    FOffsetY := Max(0, AValue);
    Changed;
  end;
end;

procedure TPanoControlSettings.SetSize(const AValue : Integer);
begin
  if AValue <> FSize then
  begin
    FSize := Max(48, AValue);
    Changed;
  end;
end;

procedure TPanoControlSettings.SetVisible(const AValue : Boolean);
begin
  if AValue <> FVisible then
  begin
    FVisible := AValue;
    Changed;
  end;
end;

function TPanoControlSettings.IsPlacementStored : Boolean;
begin
  Result := (FPlacement <> FDefault);
end;


end.
