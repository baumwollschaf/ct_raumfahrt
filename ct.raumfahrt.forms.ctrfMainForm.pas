unit ct.raumfahrt.forms.ctrfMainForm;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Edit,
  FMX.Controls.Presentation,
  FMX.Layouts,
  FMX.Objects,
  FMX.TabControl,
  System.Net.URLClient,
  System.Net.HttpClient,
  System.Net.HttpClientComponent,
  FMX.Memo.Types,
  FMX.ScrollBox,
  FMX.Memo,
  FMX.Effects,
  FMX.ExtCtrls;

type
  TctrfMainForm = class(TForm)
    Layout1: TLayout;
    Label1: TLabel;
    edPic1: TEdit;
    Button1: TButton;
    Layout2: TLayout;
    edPic2: TEdit;
    Button2: TButton;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    GridPanelLayout1: TGridPanelLayout;
    Layout3: TLayout;
    Image1: TImage;
    Label3: TLabel;
    Layout4: TLayout;
    Image2: TImage;
    Label4: TLabel;
    Client: TNetHTTPClient;
    Request: TNetHTTPRequest;
    Panel1: TPanel;
    GridPanelLayout2: TGridPanelLayout;
    Layout5: TLayout;
    Layout6: TLayout;
    Label5: TLabel;
    Label6: TLabel;
    tbFlicker: TTrackBar;
    tbTransparency: TTrackBar;
    Timer1: TTimer;
    Layout7: TLayout;
    Image3: TImage;
    Image4: TImage;
    Panel2: TPanel;
    Button3: TButton;
    Memo1: TMemo;
    ImageNumbers: TImage;
    Label2: TLabel;
    ShadowEffect1: TShadowEffect;
    procedure Button1Click(Sender: TObject);
    procedure ForamClose(Sender: TObject; var Action: TCloseAction);
    procedure RequestRequestCompleted(const Sender: TObject; const AResponse: IHTTPResponse);
    procedure tbFlickerChange(Sender: TObject);
    procedure tbTransparencyChange(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Image3MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Ü(Sender: TObject);
    procedure DropTarget1Dropped(Sender: TObject; const Data: TDragObject; const Point: TPointF);
    procedure DropTarget2DragOver(Sender: TObject; const Data: TDragObject; const Point: TPointF;
      var Operation: TDragOperation);
  private
    FPic1: Boolean;
    FOpacity: Single;
    FCount: Integer;
    function CreateLabel(ALeft, ATop: Single): TLabel;
    procedure SetUp;
  public
    { Public-Deklarationen }
  end;

var
  ctrfMainForm: TctrfMainForm;

implementation

{$R *.fmx}

procedure TctrfMainForm.Button1Click(Sender: TObject);
begin
  with (Sender as TButton) do
  begin
    Request.Cancel;
    case Tag of
      0:
        begin
          FPic1 := True;
          Request.Get(edPic1.Text);
        end;
      1:
        begin
          FPic1 := False;
          Request.Get(edPic2.Text);
        end;
    end;
  end;
end;

procedure TctrfMainForm.Button3Click(Sender: TObject);
begin
  FCount := 0;
  ImageNumbers.DeleteChildren;
end;

function TctrfMainForm.CreateLabel(ALeft, ATop: Single): TLabel;
begin
  Result := TLabel.Create(ImageNumbers);
  var
    se: TShadowEffect := TShadowEffect.Create(Result);
  se.Parent := Result;
  Result.Anchors := [];
  Result.Parent := ImageNumbers;
  Result.Text := FCount.ToString;
  Result.Font.Size := 14;
  Result.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style];
  Result.FontColor := TAlphaColors.Lime;
  Result.Position.X := ALeft + 10;
  Result.Position.Y := ATop + 0;
end;

procedure TctrfMainForm.DropTarget1Dropped(Sender: TObject; const Data: TDragObject; const Point: TPointF);
begin
  case TImage(Sender).Tag of
    1:
      begin
        Image1.Bitmap.LoadFromFile(Data.Files[0]);
      end;
    2:
      begin
        Image2.Bitmap.LoadFromFile(Data.Files[0]);
      end;
  end;
end;

procedure TctrfMainForm.DropTarget2DragOver(Sender: TObject; const Data: TDragObject; const Point: TPointF;
  var Operation: TDragOperation);
begin
  Operation := TDragOperation.None;
  if (Length(Data.Files) = 1) and ((ExtractFileExt(Data.Files[0]).ToLower = '.png') or
    (ExtractFileExt(Data.Files[0]).ToLower = '.jpg') or (ExtractFileExt(Data.Files[0]).ToLower = '.bmp')) then
    Operation := TDragOperation.Move;
end;

procedure TctrfMainForm.ForamClose(Sender: TObject; var Action: TCloseAction);
begin
  Request.Cancel;
end;

procedure TctrfMainForm.FormCreate(Sender: TObject);
begin
  TabControl1.ActiveTab := TabItem1;
  FCount := 0;
end;

procedure TctrfMainForm.Image3MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  inc(FCount);
  CreateLabel(X, Y);
end;

procedure TctrfMainForm.Ü(Sender: TObject);
begin
  Button3Click(nil);
end;

procedure TctrfMainForm.RequestRequestCompleted(const Sender: TObject; const AResponse: IHTTPResponse);
begin
  if AResponse = nil then
    Exit;
  case FPic1 of
    True:
      begin
        Image1.Bitmap.LoadFromStream(AResponse.ContentStream);
      end;
    False:
      begin
        Image2.Bitmap.LoadFromStream(AResponse.ContentStream);
      end;
  end;
end;

procedure TctrfMainForm.SetUp;
begin
  Timer1.Enabled := False;
  if TabControl1.ActiveTab = TabItem2 then
  begin
    Image3.Bitmap.Assign(Image1.Bitmap);
    Image4.Bitmap.Assign(Image2.Bitmap);
    Image4.BringToFront;
    ImageNumbers.BringToFront; // most top
    tbFlickerChange(nil);
    tbTransparencyChange(nil);
    Timer1.Enabled := True;
  end;

end;

procedure TctrfMainForm.TabControl1Change(Sender: TObject);
begin
  SetUp;
end;

procedure TctrfMainForm.tbFlickerChange(Sender: TObject);
begin
  Timer1.Interval := Trunc(tbFlicker.Value * 10);
end;

procedure TctrfMainForm.tbTransparencyChange(Sender: TObject);
begin
  FOpacity := tbTransparency.Value;
  Image4.Opacity := FOpacity;
end;

procedure TctrfMainForm.Timer1Timer(Sender: TObject);
begin
  if Image4.Opacity <= 0 then
  begin
    Image4.Opacity := FOpacity;
  end
  else
  begin
    Image4.Opacity := 0;
  end;
end;

end.
