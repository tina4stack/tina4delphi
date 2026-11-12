unit uMain;

interface

uses
  System.Classes,
  FMX.Controls,
  FMX.Forms,
  FMX.Types,
  Tina4HTMLRender;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    FRenderer: TTina4HTMLRender;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

const
  DEMO_HTML =
    '<style>' +
    '* { box-sizing: border-box; }' +
    '.page { background: linear-gradient(135deg, #111827, #1f2937); padding: 34px; color: #f9fafb; font-family: sans-serif; min-height: 620px; }' +
    '.topbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 28px; }' +
    '.brand { display: flex; align-items: center; gap: 12px; font-size: 18px; font-weight: 700; }' +
    '.dot { color: #ef4444; font-size: 18px; text-shadow: 0 0 12px rgba(239,68,68,0.75); }' +
    '.badge { background: rgba(255,255,255,0.10); border: 1px solid rgba(255,255,255,0.22); border-radius: 18px; padding: 8px 14px; color: #d1fae5; font-size: 12px; }' +
    '.hero { background: #ffffff; color: #111827; border-radius: 22px; padding: 32px; box-shadow: 0 18px 46px rgba(0,0,0,0.32); }' +
    '.eyebrow { color: #b3261e; font-size: 12px; font-weight: 700; margin-bottom: 10px; }' +
    'h1 { margin: 0 0 12px 0; font-size: 42px; color: #111827; }' +
    '.lead { margin: 0 0 26px 0; color: #4b5563; font-size: 17px; line-height: 1.5; }' +
    '.stats { display: flex; gap: 14px; margin-bottom: 24px; }' +
    '.stat { flex: 1; background: #f3f4f6; border-radius: 14px; padding: 16px; border: 1px solid #e5e7eb; }' +
    '.label { color: #6b7280; font-size: 11px; margin-bottom: 6px; }' +
    '.value { color: #111827; font-size: 18px; font-weight: 700; }' +
    '.ok { color: #047857; }' +
    '.features { display: flex; gap: 9px; flex-wrap: wrap; margin-bottom: 28px; }' +
    '.chip { background: #fee2e2; color: #991b1b; border-radius: 16px; padding: 8px 12px; font-size: 12px; }' +
    '.footer { display: flex; justify-content: space-between; align-items: center; border-top: 1px solid #e5e7eb; padding-top: 20px; }' +
    '.proof { color: #6b7280; font-size: 13px; }' +
    '.bazinga { background: #b3261e; color: #ffffff; border-radius: 12px; padding: 12px 18px; font-weight: 700; box-shadow: 0 8px 18px rgba(179,38,30,0.28); }' +
    '</style>' +
    '<div class="page">' +
      '<div class="topbar">' +
        '<div class="brand"><span class="dot">&#9679;</span><span>RAD Studio skill in action</span></div>' +
        '<div class="badge">TINA4DELPHI / FMX</div>' +
      '</div>' +
      '<div class="hero">' +
        '<div class="eyebrow">NATIVE HTML, DELPHI CONTROL</div>' +
        '<h1>TTina4HTMLRender</h1>' +
        '<p class="lead">This interface is HTML and CSS painted inside a FireMonkey control. No browser process. No WebView. Just Delphi owning every pixel.</p>' +
        '<div class="stats">' +
          '<div class="stat"><div class="label">COMPILER</div><div class="value">RAD Studio 37</div></div>' +
          '<div class="stat"><div class="label">TOOLCHAIN</div><div class="value">pascal-dev</div></div>' +
          '<div class="stat"><div class="label">BUILD</div><div class="value ok">Win64 passed</div></div>' +
        '</div>' +
        '<div class="features">' +
          '<div class="chip">Flex layout</div>' +
          '<div class="chip">CSS gradients</div>' +
          '<div class="chip">Rounded corners</div>' +
          '<div class="chip">Box shadows</div>' +
          '<div class="chip">Native scrolling</div>' +
        '</div>' +
        '<div class="footer">' +
          '<div class="proof">Rendered from <strong>HTML.Text</strong> at form creation.</div>' +
          '<div class="bazinga">BAZINGA!</div>' +
        '</div>' +
      '</div>' +
    '</div>';

procedure TForm1.FormCreate(Sender: TObject);
begin
  FRenderer := TTina4HTMLRender.Create(Self);
  FRenderer.Parent := Self;
  FRenderer.Align := TAlignLayout.Client;
  FRenderer.CacheEnabled := False;
  FRenderer.ScrollBarOverlay := True;
  FRenderer.HTML.Text := DEMO_HTML;
end;

end.
