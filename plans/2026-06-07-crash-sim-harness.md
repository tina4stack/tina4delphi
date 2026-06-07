# Tina4 IME-Crash Simulation Harness
**Date:** 2026-06-07
**Status:** Complete

## Outcome (verified on Sunmi V305223A20361)
- Harness = repurposed `Example/HtmlRender` (`uHtmlRender.pas`), package
  `com.embarcadero.HtmlRender`, side-by-side with Cuttlefish. 5 stacked
  TTina4HTMLRender, RUN STRESS / SINGLE STEP buttons, `crashsim.log` per iter.
- **Pre-fix Tina4 (9fead82): crashed at iteration 107** (process gone mid-storm).
- **Fixed Tina4 (a6d62a1): survived 105 then 125+ iterations, stayed alive.**
- True crash simulator: dies on the bug, survives on the fix. Repo restored to
  fixed state after the pre-fix run.
- Build note: `build_dproj` Build/Rebuild compiles the .so but does NOT package
  the APK (45-day-stale APK trap). Use `_pkg_htmlrender.bat` (`/t:Build;Deploy`)
  to repackage, then `adb install -r`.

## Refactor: standalone project (per user request)
Moved the crash sim out of the keyboard-demo into its own deployable project so
the demo is untouched:
- `CrashSimTest.dpr` / `uCrashSimTest.pas` / `uCrashSimTest.fmx` (blank form,
  UI built in code) / `CrashSimTest.dproj` + `.deployproj` + `.res` (cloned
  from HtmlRender). Package `com.embarcadero.CrashSimTest` (side-by-side).
- Now CATCHES + counts access violations: each cycle is wrapped in try/except,
  recoverable EAccessViolation increments AVcaught and shows in the banner; a
  fatal native crash shows as process death / a gap in `crashsimtest.log`.
- Verified on device (fixed Tina4): banner `attempted=64 survived=63 AVcaught=0`,
  stays alive. (Pre-fix reproduction already proven by the inline harness:
  hard crash at iter 107.)
- Clone gotchas (fixed): a new `.dproj` needs a matching `.deployproj` (else the
  `Deploy` target is absent) AND `<SanitizedProjectName>` must be updated — the
  Android manifest's `%package%` is filled from SanitizedProjectName, not
  MSBuildProjectName, so leaving it as `HtmlRender` makes the APK masquerade as
  the wrong package. Also the form `.fmx` must use INTEGER ClientWidth/Height
  (not 18-decimal floats) and the unit needs `{$R *.fmx}`.
- Keyboard demo (`HtmlRender`) rebuilt + reinstalled; both apps coexist.

## Goal
A small standalone FMX Android app that reproduces, in isolation, the Sunmi V2s
silent-crash class we just fixed: an HTML `<input>`'s native TEdit being torn out
from under the Android IME during a multi-renderer relayout storm while the
keyboard is binding. Deploy to the Sunmi and observe it survives on the fixed
Tina4 (and would die on pre-fix Tina4).

## Current State
- `Example/HtmlRender.dpr` + `uHtmlRender.pas` (`TForm3`) + `uHtmlRender.fmx`:
  single `TTina4HTMLRender1` keyboard demo. Already builds + deploys for Android
  (package `com.embarcadero.HtmlRender`, FMX.Skia, minSdk 23). Separate package
  from Cuttlefish, so it installs side-by-side on the device.

## Changes
1. `uHtmlRender.pas` — repurpose `FormCreate` (mobile branch) to build the
   crash-sim instead of the keyboard demo:
   - Create 5 stacked `TTina4HTMLRender` (the existing one + 4 more) parented to
     `Layout1` (mimics Cuttlefish's overlay-over-POS-grid storm).
   - Status `TLabel` (iterations survived + ALIVE), RUN/STOP `TButton`,
     SINGLE-STEP `TButton` — all created in code (not in the .fmx).
   - Stress driver: `FStressTimer` (700ms) focuses an `autofocus` input on the
     active renderer (keyboard binds), then `FStormTimer` (130ms) re-renders ALL
     renderers (the storm) mid-bind — the exact focus->blur->relayout race.
   - Each iteration appended to `crashsim.log` in the app documents dir, so adb
     can pull how far it got before any crash.
   - Keep the published component set + existing event handlers intact (the .fmx
     references them); only add private fields/methods.

## Risks
- Keep the published section matching the .fmx exactly (Button1/2,
  Tina4HTMLRender1, Tina4HTMLPages1, Tina4JSONAdapter1, Layout1) or the form
  won't load.
- Autofocus is skipped while the keyboard is already up — cycle timing must let
  the keyboard settle, or use FocusElement directly.

## Verification
- [ ] Compiles for Android
- [ ] Installs + launches on Sunmi V305223A20361
- [ ] RUN STRESS survives many iterations on fixed Tina4 (no process death)
- [ ] crashsim.log shows monotonic iteration count, app stays alive
