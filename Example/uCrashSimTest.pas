unit uCrashSimTest;

// Tina4 IME-crash regression test (standalone, device-deployable).
//
// Reproduces the Sunmi V2s silent crash class: an HTML <input>'s native TEdit
// torn out from under the Android IME during a multi-renderer relayout storm
// while the keyboard is binding. Each cycle:
//   1. autofocus an input on one of N stacked TTina4HTMLRender (IME binds,
//      keyboard slides up -> window resize fans a relayout across every render)
//   2. 130ms later, re-render ALL renderers (the storm) mid-bind.
// Pre-fix Tina4 dies (process gone) or raises EAccessViolation within ~100
// iterations; the fixed framework runs indefinitely. Caught Delphi exceptions
// (EAccessViolation etc.) are counted + shown; a hard native death shows up as
// a gap in crashsimtest.log (the process simply vanishes).
//
// The whole UI is built in code on a blank form, so this project needs no
// design-time components.

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.IOUtils,
  System.UIConsts,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.StdCtrls, FMX.Layouts,
  FMX.Controls.Presentation, FMX.VirtualKeyboard, FMX.Platform,
  Tina4HtmlRender;

type
  TformCrashTest = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    FRenders: TArray<TTina4HTMLRender>;
    FHost: TLayout;
    FStatus: TLabel;
    FRunBtn: TButton;
    FStepBtn: TButton;
    FStressTimer: TTimer;
    FStormTimer: TTimer;
    FIter: Integer;
    FSurvived: Integer;
    FAvCount: Integer;       // caught EAccessViolation / Exception count
    FLastErr: string;
    FActiveIdx: Integer;
    procedure BuildUI;
    function PageHtml(AIndex: Integer; AAutofocus: Boolean): string;
    procedure DoOneCycle;
    procedure StressTick(Sender: TObject);
    procedure StormTick(Sender: TObject);
    procedure RunBtnClick(Sender: TObject);
    procedure StepBtnClick(Sender: TObject);
    procedure HideKeyboard;
    procedure UpdateStatus;
    procedure SimLog(const Msg: string);
  end;

var
  formCrashTest: TformCrashTest;

implementation

{$R *.fmx}

const
  RENDERER_COUNT = 5;

function TformCrashTest.PageHtml(AIndex: Integer; AAutofocus: Boolean): string;
var
  Af, Tag: string;
begin
  if AAutofocus then
  begin
    Af := ' autofocus';
    Tag := ' [FOCUS]';
  end
  else
  begin
    Af := '';
    Tag := ' [storm]';
  end;
  Result :=
    '<div style="padding:10px;font-family:sans-serif;background:#eef3ff">' +
    '<div id="hdr" style="font-weight:700;color:#1e3a8a">R' + IntToStr(AIndex) +
      ' iter ' + IntToStr(FIter) + Tag + '</div>' +
    '<input id="a" name="a"' + Af +
      ' style="width:92%;padding:11px;font-size:16px;margin:6px 0;border:1px solid #94a3b8;border-radius:6px">' +
    '<input id="b" name="b"' +
      ' style="width:92%;padding:11px;font-size:16px;margin:6px 0;border:1px solid #94a3b8;border-radius:6px">' +
    '<div style="height:240px"></div>' +
    '</div>';
end;

procedure TformCrashTest.SimLog(const Msg: string);
var
  Path: string;
begin
  try
    {$IF defined(ANDROID) or defined(IOS)}
    Path := TPath.Combine(TPath.GetDocumentsPath, 'crashsimtest.log');
    {$ELSE}
    Path := TPath.Combine(ExtractFilePath(ParamStr(0)), 'crashsimtest.log');
    {$ENDIF}
    TFile.AppendAllText(Path,
      FormatDateTime('hh:nn:ss.zzz', Now) + ': ' + Msg + sLineBreak);
  except
  end;
end;

procedure TformCrashTest.UpdateStatus;
var
  S: string;
begin
  if not Assigned(FStatus) then Exit;
  S := Format('attempted=%d  survived=%d  AVcaught=%d', [FIter, FSurvived, FAvCount]);
  if FLastErr <> '' then
    S := S + sLineBreak + 'last: ' + FLastErr;
  FStatus.Text := S;
end;

procedure TformCrashTest.HideKeyboard;
var
  Svc: IFMXVirtualKeyboardService;
begin
  try
    if TPlatformServices.Current.SupportsPlatformService(
         IFMXVirtualKeyboardService, IInterface(Svc)) and (Svc <> nil) then
      Svc.HideVirtualKeyboard;
  except
  end;
end;

procedure TformCrashTest.BuildUI;
var
  I: Integer;
  R: TTina4HTMLRender;
begin
  // Host fills the form; renderers stack inside it.
  FHost := TLayout.Create(Self);
  FHost.Parent := Self;
  FHost.Align := TAlignLayout.Client;

  SetLength(FRenders, RENDERER_COUNT);
  for I := 0 to RENDERER_COUNT - 1 do
  begin
    R := TTina4HTMLRender.Create(Self);
    R.Parent := FHost;
    R.Align := TAlignLayout.Client;
    R.CacheEnabled := False;
    R.Opacity := 0.999;
    R.HTML.Text := PageHtml(I, False);
    FRenders[I] := R;
  end;

  FStatus := TLabel.Create(Self);
  FStatus.Parent := Self;
  FStatus.Align := TAlignLayout.Top;
  FStatus.Height := 80;
  FStatus.StyledSettings := [];
  FStatus.TextSettings.Font.Size := 14;
  FStatus.TextSettings.FontColor := claWhite;
  FStatus.TextSettings.HorzAlign := TTextAlign.Center;
  FStatus.Text := 'CRASH TEST ready - tap RUN';

  FRunBtn := TButton.Create(Self);
  FRunBtn.Parent := Self;
  FRunBtn.Align := TAlignLayout.Bottom;
  FRunBtn.Height := 64;
  FRunBtn.Text := 'RUN STRESS';
  FRunBtn.OnClick := RunBtnClick;

  FStepBtn := TButton.Create(Self);
  FStepBtn.Parent := Self;
  FStepBtn.Align := TAlignLayout.Bottom;
  FStepBtn.Height := 56;
  FStepBtn.Text := 'SINGLE STEP';
  FStepBtn.OnClick := StepBtnClick;

  FStressTimer := TTimer.Create(Self);
  FStressTimer.Interval := 750;
  FStressTimer.Enabled := False;
  FStressTimer.OnTimer := StressTick;

  FStormTimer := TTimer.Create(Self);
  FStormTimer.Interval := 130;
  FStormTimer.Enabled := False;
  FStormTimer.OnTimer := StormTick;

  SimLog('=== CRASH TEST started, renderers=' + IntToStr(RENDERER_COUNT) + ' ===');
end;

procedure TformCrashTest.DoOneCycle;
begin
  FActiveIdx := FIter mod RENDERER_COUNT;
  SimLog(Format('iter %d: focus R%d', [FIter, FActiveIdx]));
  try
    FRenders[FActiveIdx].HTML.Text := PageHtml(FActiveIdx, True);
  except
    on E: Exception do
    begin
      Inc(FAvCount);
      FLastErr := E.ClassName + ': ' + E.Message;
      SimLog(Format('iter %d: focus EXCEPTION %s', [FIter, FLastErr]));
    end;
  end;
  Inc(FIter);
  UpdateStatus;
  FStormTimer.Enabled := False;
  FStormTimer.Enabled := True;
end;

procedure TformCrashTest.StormTick(Sender: TObject);
var
  I: Integer;
begin
  FStormTimer.Enabled := False;
  // The storm: re-render every renderer while the IME is mid-bind on the
  // active one. Caught here so a recoverable AV is counted rather than killing
  // the run; an unrecoverable native crash just ends the process.
  try
    for I := 0 to RENDERER_COUNT - 1 do
      FRenders[I].HTML.Text := PageHtml(I, False);
    Inc(FSurvived);
    SimLog(Format('iter %d: storm survived (survived=%d)', [FIter - 1, FSurvived]));
  except
    on E: Exception do
    begin
      Inc(FAvCount);
      FLastErr := E.ClassName + ': ' + E.Message;
      SimLog(Format('iter %d: storm EXCEPTION %s', [FIter - 1, FLastErr]));
    end;
  end;
  HideKeyboard;
  UpdateStatus;
end;

procedure TformCrashTest.StressTick(Sender: TObject);
begin
  DoOneCycle;
end;

procedure TformCrashTest.StepBtnClick(Sender: TObject);
begin
  DoOneCycle;
end;

procedure TformCrashTest.RunBtnClick(Sender: TObject);
begin
  FStressTimer.Enabled := not FStressTimer.Enabled;
  if FStressTimer.Enabled then
    FRunBtn.Text := 'STOP'
  else
    FRunBtn.Text := 'RUN STRESS';
end;

procedure TformCrashTest.FormCreate(Sender: TObject);
begin
  BuildUI;
end;

end.
