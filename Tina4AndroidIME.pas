unit Tina4AndroidIME;

{
  Android-specific IME helpers for Tina4HtmlRender.

  Isolated from the main renderer unit so that the JNI imports
  (Androidapi.JNI.GraphicsContentViewText, Androidapi.JNIBridge,
  Androidapi.Helpers) don't shadow System.Classes.TThreadProcedure
  in the renderer's compilation context — which broke every
  TThread.ForceQueue call site when the JNI imports were inline.
}

interface

uses
  System.SysUtils;

type
  TIMELogProc = reference to procedure (const Msg: string);

{$IFDEF ANDROID}
/// <summary>
/// Show the Android soft keyboard via direct JNI to
/// InputMethodManager.showSoftInput.
///
/// CRITICAL HISTORY (2026-06-06): this used to pass SHOW_FORCED on the
/// activity's DECOR VIEW (the whole window root). That was catastrophic
/// on the Sunmi V2s (MediaTek MT6761): SHOW_FORCED makes Android show
/// the IME at a forced ~half-screen geometry FIRST (e.g. 360x446), then
/// reconcile it to the normal size (360x223). That's TWO full-window
/// surface reconfigurations per keyboard show. Multiplied across the
/// dozens of keyboard shows in a POS session, the surface churn crashes
/// the closed-source MTK hardware composer (hwcomposer.mt6761.so,
/// AsyncBliterHandler::processVirMirror) with SIGABRT, which takes down
/// system_server and reboots the device. Customer-confirmed: "never
/// crashed before we started playing with keyboard issues."
///
/// Fix: use SHOW_IMPLICIT (the standard, non-deprecated, gentle flag —
/// shows the IME at its natural size with no forced geometry) and
/// target the currently-focused child view (what a real tap does
/// internally), falling back to the decor view only if nothing has
/// focus. One surface reconfiguration, no flip, no churn.
/// Idempotent when the keyboard is already up.
/// </summary>
procedure ForceShowSoftKeyboard(const LogProc: TIMELogProc = nil);
{$ENDIF}

implementation

{$IFDEF ANDROID}

uses
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.App,
  Androidapi.JNIBridge,
  Androidapi.Helpers;

procedure Trace(const LogProc: TIMELogProc; const Msg: string);
begin
  if Assigned(LogProc) then
    try LogProc(Msg) except end;
end;

procedure ForceShowSoftKeyboard(const LogProc: TIMELogProc);
var
  Activity: JActivity;
  Win: JWindow;
  DecorView: JView;
  TargetView: JView;
  ImmObj: JObject;
  Imm: JInputMethodManager;
begin
  Activity := TAndroidHelper.Activity;
  if not Assigned(Activity) then
  begin
    Trace(LogProc, 'ShowKbd: no activity');
    Exit;
  end;
  Win := Activity.getWindow;
  if not Assigned(Win) then
  begin
    Trace(LogProc, 'ShowKbd: no window');
    Exit;
  end;
  DecorView := Win.getDecorView;
  if not Assigned(DecorView) then
  begin
    Trace(LogProc, 'ShowKbd: no decor view');
    Exit;
  end;
  ImmObj := TAndroidHelper.Context.getSystemService(
    TJContext.JavaClass.INPUT_METHOD_SERVICE);
  if not Assigned(ImmObj) then
  begin
    Trace(LogProc, 'ShowKbd: no IMM service');
    Exit;
  end;
  Imm := TJInputMethodManager.Wrap(
    (ImmObj as ILocalObject).GetObjectID);
  if not Assigned(Imm) then
  begin
    Trace(LogProc, 'ShowKbd: IMM wrap failed');
    Exit;
  end;

  // Target the currently-focused child view if there is one — this is
  // exactly what a normal user tap resolves to, so the IME shows at its
  // natural size for that control. Fall back to the decor view only if
  // nothing has focus yet.
  TargetView := DecorView.findFocus;
  if not Assigned(TargetView) then
    TargetView := DecorView;

  // SHOW_IMPLICIT, NOT SHOW_FORCED. SHOW_FORCED caused the half-screen
  // forced-geometry IME that then resized to normal — a double surface
  // reconfiguration per show that crashed the MTK composer. SHOW_IMPLICIT
  // shows the IME once, at its natural size, the way the OS intends.
  Trace(LogProc, 'ShowKbd: imm.showSoftInput(focused, SHOW_IMPLICIT)');
  Imm.showSoftInput(TargetView,
    TJInputMethodManager.JavaClass.SHOW_IMPLICIT);
end;

{$ENDIF}

end.
