unit uCrashSimTest;

// Tina4 IME / relayout regression test (standalone, device-deployable).
//
// Mirrors the real Cuttlefish Global Airtime / Transfer screens to reproduce,
// in isolation, the two on-device failures:
//
//   MODE B - RELAYOUT BUSY-LOOP / ANR (main thread pinned at 100% CPU):
//     N stacked renderers, flipped between TWO component sets (GA-like +
//     Transfer-like), each with an autofocus numeric input, a multiline
//     textarea, buttons and a scrollable body. While an input is focused and
//     the keyboard is up, an inline DOM banner (#msg) is updated with
//     varying-line text (like "Please enter a valid mobile number"), focus is
//     rotated across inputs, and the focused input is scrolled into view. The
//     inline reflow + keyboard-frame change + scroll can spin the UI thread.
//
//   MODE A - DISPOSE CRASH (silent process death): full re-render storm across
//     all renderers while an input is IME-bound (the original crash class).
//
// Each operation is wrapped in try/except: a recoverable EAccessViolation
// increments AVcaught (shown in the banner); a fatal crash / hard hang shows
// as process death / a frozen iteration count.

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
    FModeBtn: TButton;
    FFocusTimer: TTimer;     // slow: flip component set, rotate + focus -> kbd up
    FMutateTimer: TTimer;    // fast: inline #msg updates / focus rotate / scroll
    FCountBtn: TButton;
    FRenderCount: Integer;   // how many renderers are live (1 = no cross-render clash)
    FIter: Integer;
    FSurvived: Integer;
    FAvCount: Integer;       // AVs caught by our own per-op try/except
    FUncaught: Integer;      // AVs that escaped to Application.OnException (= the OK dialog)
    FLastErr: string;
    FActiveIdx: Integer;
    FScreenFlip: Integer;    // which component set the active renderer shows
    FMode: Integer;          // 0 = dispose-storm (A), 1 = inline busy-loop (B), 2 = focus-stress (C)
    procedure BuildUI;
    procedure RebuildRenderers;
    procedure CountBtnClick(Sender: TObject);
    function Css: string;
    function ScreenHtml(AScreen: Integer): string;
    function VaryingLinesText: string;
    procedure FocusTick(Sender: TObject);
    procedure MutateTick(Sender: TObject);
    procedure RunBtnClick(Sender: TObject);
    procedure ModeBtnClick(Sender: TObject);
    procedure HideKeyboard;
    procedure UpdateStatus;
    procedure SimLog(const Msg: string);
    procedure Bump(const Where: string);
    procedure HandleAppException(Sender: TObject; E: Exception);
  end;

var
  formCrashTest: TformCrashTest;

implementation

{$R *.fmx}

const
  RENDERER_COUNT = 5;

function TformCrashTest.Css: string;
begin
  Result :=
    'body{margin:0;font-family:sans-serif;background:#f3f4f6}' +
    '.header{color:#fff;padding:14px;font-size:20px;font-weight:700;text-align:center}' +
    '.form-wrap{padding:16px}' +
    '.field{margin-bottom:14px}' +
    '.field-label{display:block;font-weight:600;color:#111827;margin:8px 0 4px 0}' +
    '.field-input{width:100%;padding:12px;border:1px solid #d1d5db;border-radius:8px;font-size:16px;box-sizing:border-box}' +
    '.field-hint{display:block;color:#6b7280;font-size:13px;margin-top:4px}' +
    '.fixed-amount{font-size:22px;font-weight:700;color:#16a34a}' +
    '.submit-btn{color:#fff;background:#1e40af;padding:14px;border-radius:8px;text-align:center;font-weight:600;margin-top:10px}' +
    '.banner{background:#fee2e2;border:1px solid #fca5a5;color:#991b1b;padding:10px 12px;border-radius:8px;margin-bottom:12px;font-size:14px}';
end;

// Two component sets, flipped between. Both expose the SAME ids so the mutate
// loop can address them regardless of which set is showing:
//   #msg  inline banner (varying-line text)   i1 autofocus numeric input
//   i2    second input (numeric)              i3 multiline textarea
// plus buttons and a tall spacer so the body scrolls under the keyboard.
function TformCrashTest.ScreenHtml(AScreen: Integer): string;
var
  Title, BannerBg: string;
begin
  // FAITHFUL model of the Cuttlefish Transfer / Global Airtime screens that
  // crash — including the three structures the OLD harness lacked and that the
  // real "Search m2 then focus amount" flow drives:
  //   errBanner : EMPTY + display:none (like gaErrorBanner). The re-show path
  //               re-clears it every visit — used to relayout for nothing and
  //               re-fire i1's autofocus (the double-keyboard flash).
  //   i1        : autofocus account/mobile input (lookupNo / destMobile).
  //   nameRow   : display:none row REVEALED by a Search (destNameRow). The
  //               reveal is a STRUCTURAL relayout that rebuilds every TEdit.
  //   i2        : amount input, focused AFTER that reveal (txAmount).
  //   balLbl    : balance label updated on a BACKGROUND cadence (closingBalance
  //               / the async getBalance), i.e. a relayout that lands while i2
  //               is focused.
  if AScreen = 0 then begin Title := 'Global Airtime'; BannerBg := '#2563eb'; end
  else                begin Title := 'Transfer';       BannerBg := '#16a34a'; end;
  Result :=
    '<html><head><style>' + Css + '</style></head><body>' +
    '<div class="header" style="background:' + BannerBg + '">' + Title + '</div>' +
    '<div class="form-wrap">' +
    // gaErrorBanner-style: full style + display:none, NO #text child.
    '<div id="errBanner" style="display:none;background:#fee2e2;border:1px solid ' +
      '#fca5a5;color:#991b1b;padding:10px 12px;border-radius:8px;margin-bottom:12px"></div>' +
    '<div class="field"><span class="field-label">Account / Mobile</span>' +
    '<input class="field-input" type="text" id="i1" placeholder="M-000123" autofocus/></div>' +
    // destNameRow: hidden until Search reveals it.
    '<div id="nameRow" class="field" style="display:none">' +
    '<span class="field-label">Account Name</span>' +
    '<div class="fixed-amount" id="nameLbl">.</div></div>' +
    '<div class="field"><span class="field-label">Amount (Rands)</span>' +
    '<input class="field-input" type="text" inputmode="numeric" id="i2" placeholder="0.00"/></div>' +
    '<span class="field-label">Closing balance</span>' +
    '<div class="fixed-amount" id="balLbl">R 0.00</div>' +
    '<div class="field"><span class="field-label">Reference</span>' +
    '<textarea class="field-input" id="i3" rows="2" placeholder="multi-line"></textarea></div>' +
    '<div class="submit-btn">Search</div>' +
    '<div class="submit-btn" style="background:#94a3b8">Cancel</div>' +
    '<div style="height:340px"></div>' +
    '</div></body></html>';
end;

function TformCrashTest.VaryingLinesText: string;
var
  Words, I, J, W: Integer;
begin
  // 1..7 lines worth of words so the banner height changes a lot each update.
  Words := (1 + Random(7)) * (2 + Random(7));
  Result := '';
  for I := 1 to Words do
  begin
    W := 2 + Random(9);
    for J := 1 to W do
      Result := Result + Char(Ord('a') + Random(26));
    Result := Result + ' ';
  end;
  if Random(3) = 0 then
    Result := 'Please enter a valid mobile number ' + IntToStr(FIter) + '. ' + Result;
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

procedure TformCrashTest.Bump(const Where: string);
begin
  Inc(FAvCount);
  FLastErr := Where;
  SimLog('AV: ' + Where);
end;

// Catches the AVs that escape our per-op try/except and would otherwise pop the
// FMX "Access violation ... OK" dialog. These come from async / FMX-callback
// paths (paint, focus change, OnChangeTracking, IME) referencing a control
// freed in another renderer. We log + swallow them so the harness can run
// unattended AND so the uncaught rate is visible in the banner.
procedure TformCrashTest.HandleAppException(Sender: TObject; E: Exception);
begin
  Inc(FUncaught);
  FLastErr := 'UNCAUGHT ' + E.ClassName + ': ' + E.Message;
  SimLog('UNCAUGHT(' + IntToStr(FUncaught) + '): ' + E.ClassName + ': ' + E.Message);
  try UpdateStatus; except end;
end;

procedure TformCrashTest.UpdateStatus;
var
  S: string;
begin
  if not Assigned(FStatus) then Exit;
  case FMode of
    0: S := 'MODE A dispose-storm';
    2: S := 'MODE C focus-stress';
  else S := 'MODE B inline-loop';
  end;
  S := S + Format('  iter=%d survived=%d AVcaught=%d UNCAUGHT=%d',
    [FIter, FSurvived, FAvCount, FUncaught]);
  if FLastErr <> '' then S := S + sLineBreak + 'last: ' + FLastErr;
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

procedure TformCrashTest.RebuildRenderers;
var
  I: Integer;
  R: TTina4HTMLRender;
begin
  if Assigned(FFocusTimer) then FFocusTimer.Enabled := False;
  if Assigned(FMutateTimer) then FMutateTimer.Enabled := False;
  HideKeyboard;
  try
    if (Root <> nil) and (Root is TCustomForm) then
      TCustomForm(Root).Focused := nil;
  except
  end;
  for I := 0 to High(FRenders) do
    if Assigned(FRenders[I]) then
      try FRenders[I].DisposeOf; except end;
  SetLength(FRenders, FRenderCount);
  for I := 0 to FRenderCount - 1 do
  begin
    R := TTina4HTMLRender.Create(Self);
    R.Parent := FHost;
    R.Align := TAlignLayout.Client;
    R.CacheEnabled := False;
    R.Opacity := 0.999;
    R.HTML.Text := ScreenHtml(I mod 2);
    FRenders[I] := R;
  end;
  FActiveIdx := -1;
  if Assigned(FRunBtn) then FRunBtn.Text := 'RUN';
end;

procedure TformCrashTest.CountBtnClick(Sender: TObject);
begin
  case FRenderCount of
    1: FRenderCount := 2;
    2: FRenderCount := 5;
  else
    FRenderCount := 1;
  end;
  FCountBtn.Text := 'RENDERERS: ' + IntToStr(FRenderCount);
  RebuildRenderers;
  FIter := 0; FSurvived := 0; FAvCount := 0; FLastErr := '';
  UpdateStatus;
end;

procedure TformCrashTest.BuildUI;
begin
  Randomize;
  Application.OnException := HandleAppException;  // intercept the OK-dialog AVs
  FMode := 1;                                     // default MODE B (inline-loop)
  FActiveIdx := -1;
  FRenderCount := 5;

  FHost := TLayout.Create(Self);
  FHost.Parent := Self;
  FHost.Align := TAlignLayout.Client;

  RebuildRenderers;

  FStatus := TLabel.Create(Self);
  FStatus.Parent := Self;
  FStatus.Align := TAlignLayout.Top;
  FStatus.Height := 84;
  FStatus.StyledSettings := [];
  FStatus.TextSettings.Font.Size := 13;
  FStatus.TextSettings.FontColor := claWhite;
  FStatus.TextSettings.HorzAlign := TTextAlign.Center;
  FStatus.Text := 'CRASH TEST ready - tap RUN';

  FRunBtn := TButton.Create(Self);
  FRunBtn.Parent := Self;
  FRunBtn.Align := TAlignLayout.Top;
  FRunBtn.Height := 64;
  FRunBtn.Text := 'RUN';
  FRunBtn.OnClick := RunBtnClick;

  FModeBtn := TButton.Create(Self);
  FModeBtn.Parent := Self;
  FModeBtn.Align := TAlignLayout.Top;
  FModeBtn.Height := 52;
  FModeBtn.Text := 'MODE: B (inline-loop)';
  FModeBtn.OnClick := ModeBtnClick;

  FCountBtn := TButton.Create(Self);
  FCountBtn.Parent := Self;
  FCountBtn.Align := TAlignLayout.Top;
  FCountBtn.Height := 48;
  FCountBtn.Text := 'RENDERERS: 5';
  FCountBtn.OnClick := CountBtnClick;

  FFocusTimer := TTimer.Create(Self);
  FFocusTimer.Interval := 700;
  FFocusTimer.Enabled := False;
  FFocusTimer.OnTimer := FocusTick;

  FMutateTimer := TTimer.Create(Self);
  FMutateTimer.Interval := 70;
  FMutateTimer.Enabled := False;
  FMutateTimer.OnTimer := MutateTick;

  SimLog('=== CRASH TEST started, renderers=' + IntToStr(RENDERER_COUNT) + ' ===');
end;

// Slow: flip to the next renderer, stamp it with the OTHER component set
// (so we navigate between two screens), bring it to front, and let its
// autofocus input pop the keyboard.
procedure TformCrashTest.FocusTick(Sender: TObject);
var
  R: TTina4HTMLRender;
begin
  if FRenderCount < 1 then Exit;
  FActiveIdx := (FActiveIdx + 1) mod FRenderCount;
  FScreenFlip := 1 - FScreenFlip;
  R := FRenders[FActiveIdx];
  SimLog(Format('flip R%d -> screen %d (iter=%d)', [FActiveIdx, FScreenFlip, FIter]));
  try R.BringToFront; except end;
  try
    R.HTML.Text := ScreenHtml(FScreenFlip);   // re-stamp = navigate, autofocus i1
  except
    on E: Exception do Bump('flip: ' + E.ClassName);
  end;
  UpdateStatus;
end;

// Fast: hammer inline updates / focus / scroll on the active renderer.
procedure TformCrashTest.MutateTick(Sender: TObject);
var
  R: TTina4HTMLRender;
  I: Integer;
begin
  if (FActiveIdx < 0) or (FActiveIdx >= FRenderCount) then Exit;
  R := FRenders[FActiveIdx];
  case FMode of
  1: begin
    // EXACT Cuttlefish "Search M-000002 then focus the amount" flow — the
    // sequence the isolated old harness never did, and which SIGSEGVs in the
    // real app. Each op isolated so the AV log names the faulting step.
    case FIter mod 8 of
      0: // RE-SHOW (re-enter screen): clear input, hide name row, clear+hide the
         // already-empty/hidden error banner. With the framework no-op guards
         // these must NOT relayout -> i1's autofocus must NOT re-fire (no
         // double-keyboard). Without the guards, this relayouts and re-fires.
         begin
           try R.SetElementValue('i1', '');            except on E: Exception do Bump('reshow clr i1: ' + E.Message); end;
           try R.SetElementVisible('nameRow', False);  except on E: Exception do Bump('reshow hide nameRow: ' + E.Message); end;
           try R.SetElementText('errBanner', '');      except on E: Exception do Bump('reshow clr err: ' + E.Message); end;
           try R.SetElementVisible('errBanner', False);except on E: Exception do Bump('reshow hide err: ' + E.Message); end;
         end;
      1: // type the account into i1
         try R.SetElementValue('i1', 'M-00000' + IntToStr(1 + Random(9))); except on E: Exception do Bump('search type: ' + E.Message); end;
      2: // SEARCH RESULT: set name + REVEAL the hidden row. The reveal is a
         // STRUCTURAL relayout that rebuilds every TEdit (destNameRow).
         begin
           try R.SetElementText('nameLbl', 'M-000002 test ' + IntToStr(FIter)); except on E: Exception do Bump('search name: ' + E.Message); end;
           try R.SetElementVisible('nameRow', True);   except on E: Exception do Bump('search reveal: ' + E.Message); end;
         end;
      3: // FOCUS THE AMOUNT immediately after the reveal — the crash point.
         try R.FocusElement('i2');                     except on E: Exception do Bump('FOCUS AMOUNT after reveal: ' + E.Message); end;
      4: // ASYNC balance lands WHILE the amount is focused (getBalance ->
         // SetElementText(closingBalance) -> relayout under a focused TEdit).
         try R.SetElementText('balLbl', 'R ' + IntToStr(Random(99999)) + '.00'); except on E: Exception do Bump('async balance: ' + E.Message); end;
      5: // type the amount
         try R.SetElementValue('i2', IntToStr(1 + Random(5000)) + '.00'); except on E: Exception do Bump('type amount: ' + E.Message); end;
      6: // FAILED-lookup: show error banner surgically (gaErrorBanner path)
         begin
           try R.SetElementText('errBanner', 'Account not found ' + IntToStr(FIter)); except on E: Exception do Bump('err text: ' + E.Message); end;
           try R.SetElementVisible('errBanner', True);  except on E: Exception do Bump('err show: ' + E.Message); end;
         end;
      7: // clear amount, back to start
         try R.SetElementValue('i2', '');              except on E: Exception do Bump('clear amount: ' + E.Message); end;
    end;
    Inc(FSurvived);
  end;
  0: begin
    try
      for I := 0 to FRenderCount - 1 do
        FRenders[I].HTML.Text := ScreenHtml((I + FIter) mod 2);
      Inc(FSurvived);
    except
      on E: Exception do Bump('storm: ' + E.Message);
    end;
  end;
  2: begin
    // FOCUS STRESS [C] — reproduce the MT6761 compositor stall (ANR), the
    // freeze the resilient AV handling can't catch. Mirrors the Electricity
    // "Process with no amount" path that froze the app: focus a field (keyboard
    // up), show an inline error (relayout WHILE focused), then move focus to
    // another field (keyboard transition DURING that relayout), then reset.
    // Fired faster than the keyboard animation so the transitions overlap —
    // the exact condition that drives the compositor into a sync-point wait
    // timeout. Best run with RENDERERS: 1 (single screen, like one overlay).
    case FIter mod 4 of
      0: try R.FocusElement('i1');                          // focus meter (kbd up)
         except on E: Exception do Bump('fs focus i1: ' + E.Message); end;
      1: try R.SetElementValue('i1', 'M-' + IntToStr(10000 + FIter)); // type a meter
         except on E: Exception do Bump('fs type i1: ' + E.Message); end;
      2: begin
           // THE TRIGGER — mirror tapping "Process" with no amount:
           //  (a) the tap blurs the input -> keyboard STARTS DISMISSING.
           try if (Root <> nil) and (Root is TCustomForm) then
                 TCustomForm(Root).Focused := nil;
           except end;
           HideKeyboard;
           //  (b) ShowElecError: inline banner shown -> relayout rebuilds inputs.
           try R.SetElementText('errBanner', 'Please enter an amount ' + IntToStr(FIter));
           except on E: Exception do Bump('fs err text: ' + E.Message); end;
           try R.SetElementVisible('errBanner', True);
           except on E: Exception do Bump('fs err show: ' + E.Message); end;
           //  (c) focus the amount -> keyboard RE-SHOWS, during that relayout and
           //      mid-dismiss. The keyboard down-then-up across a relayout is what
           //      stalls the MT6761 compositor (the Electricity freeze).
           try R.FocusElement('i2');
           except on E: Exception do Bump('fs focus-on-error: ' + E.Message); end;
         end;
      3: try R.SetElementVisible('errBanner', False);       // reset
         except on E: Exception do Bump('fs err hide: ' + E.Message); end;
    end;
    Inc(FSurvived);
  end;
  end;
  Inc(FIter);
  // Heartbeat — every 4 ticks in focus-stress (finer, so the external watcher
  // can pinpoint a UI stall), every 12 otherwise. If this 'iter N' line stops
  // advancing while the process is still alive, the main thread has frozen
  // (ANR / MTK surface stall) — which the harness itself cannot catch.
  var HbEvery: Integer := 12;
  if FMode = 2 then HbEvery := 4;
  if (FIter mod HbEvery) = 0 then
  begin
    UpdateStatus;
    SimLog(Format('iter %d survived=%d AVcaught=%d uncaught=%d screen=%d',
      [FIter, FSurvived, FAvCount, FUncaught, FScreenFlip]));
  end;
end;

procedure TformCrashTest.RunBtnClick(Sender: TObject);
begin
  if FFocusTimer.Enabled then
  begin
    FFocusTimer.Enabled := False;
    FMutateTimer.Enabled := False;
    HideKeyboard;
    FRunBtn.Text := 'RUN';
  end
  else
  begin
    FActiveIdx := -1;
    if FMode = 2 then
    begin
      // Focus-stress: hammer the focus/keyboard/relayout pattern on renderer 0,
      // no flipping. Mirror Cuttlefish's overlay stack: keep all N renderers
      // PARENTED but hide all but the active one (like ShowOnlyRender). They
      // still receive the global VK message and the compositor still has to
      // manage N stacked surfaces during the keyboard animation — the load that
      // single-renderer mode lacked.
      if FRenderCount > 0 then FActiveIdx := 0;
      for var I := 0 to FRenderCount - 1 do
        if Assigned(FRenders[I]) then
          try FRenders[I].Visible := (I = 0); except end;
      FMutateTimer.Enabled := True;
    end
    else
    begin
      FFocusTimer.Enabled := True;
      FMutateTimer.Enabled := True;
      FocusTick(nil);
    end;
    FRunBtn.Text := 'STOP';
  end;
end;

procedure TformCrashTest.ModeBtnClick(Sender: TObject);
begin
  FMode := (FMode + 1) mod 3;
  case FMode of
    0: FModeBtn.Text := 'MODE: A (dispose storm)';
    1: FModeBtn.Text := 'MODE: B (inline-loop)';
    2: FModeBtn.Text := 'MODE: C (focus-stress)';
  end;
  UpdateStatus;
end;

procedure TformCrashTest.FormCreate(Sender: TObject);
begin
  BuildUI;
end;

end.
