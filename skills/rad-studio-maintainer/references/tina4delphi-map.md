# Tina4Delphi repository map

Use this as a fast navigation map. Re-check the live source before making claims because packages and public interfaces are authoritative.

## Product boundary

- Delphi 10.4+ FireMonkey component framework.
- Core dependencies: FMX, FireDAC, Indy, and Delphi RTL.
- Windows TLS uses bundled OpenSSL 3.x libraries under `lib/win32` and `lib/win64` where applicable.
- iOS/iPadOS WebSocket TLS uses Apple's Network.framework and intentionally does not load OpenSSL.
- `readme.md` is the component/API guide; `SUPPORTED.md` is the explicit HTML/CSS renderer coverage and gap list.

## Package and project entry points

| Path | Role |
|---|---|
| `Tina4DelphiProject.groupproj` | Runtime + design-time package group |
| `Tina4Delphi.dproj` / `.dpk` | Runtime component package and authoritative runtime unit list |
| `Tina4DelphiDesign.dproj` / `.dpk` | Design-time editors; requires the runtime package |
| `Example/Test/Tina4DelphiExampleTests.dproj` | DUnit framework regression suite |
| `Example/HtmlRender.dproj` | Focused renderer example |
| `Example/Tina4DelphiExample.dproj` | Broader component example |
| `Example/Demo.dproj` | Additional FMX demo |

Do not treat `.dproj.local`, `.identcache`, DCUs, BPLs, EXEs, `.res`, or `.dres` as the preferred source of a behavior change.

## Runtime architecture

| Area | Primary units | Responsibility |
|---|---|---|
| Core | `Tina4Core.pas` | request/response types, JSON/database conversion, encoding, dates, shell and utility functions |
| REST/data | `Tina4REST.pas`, `Tina4RESTRequest.pas`, `Tina4JSONAdapter.pas` | REST configuration/execution and JSON ↔ MemTable data flow |
| HTTP/routes | `Tina4WebServer.pas`, `Tina4Route.pas` | Indy HTTP server and endpoint components |
| Sockets | `Tina4SocketServer.pas` | TCP/UDP server component |
| Templates | `Tina4Frond.pas`, `Tina4Twig.pas` | Template parser/evaluator and Twig-compatible surface |
| HTML pages | `Tina4HTMLRender.pas`, `Tina4HTMLPages.pas` | FMX HTML rendering, interaction, DOM helpers, and page navigation |
| WebSockets | `Tina4WebSocketFrames.pas`, `Tina4WebSocketClient.pas` | frame protocol, client state, reconnect, ping/pong, and TLS |
| TLS | `Tina4OpenSSL.pas` | OpenSSL wrappers plus Apple Network.framework bridge |
| Interposers/mobile | `Tina4InterposerClasses.pas`, `Tina4AndroidIME.pas` | FMX behavior adaptations and Android keyboard integration |

`Tina4WebSocketBroker.pas` and `Tina4WebSocketServer.pas` exist in the repository but are not currently listed in the runtime package; verify intent before adding or exposing them.

## Renderer anatomy

`Tina4HTMLRender.pas` is intentionally large because it owns an end-to-end rendering pipeline:

1. `THTMLParser` builds `THTMLTag` nodes.
2. `TCSSStyleSheet`/`TCSSRule` parse and match styles.
3. `TComputedStyle` captures resolved layout/paint inputs.
4. `TLayoutEngine` produces `TLayoutBox` objects and text fragments.
5. `TTina4HTMLRender` paints, manages scrolling/images/native form controls, hit tests links/clicks, and exposes DOM-style operations.

When fixing visual behavior, locate the first wrong stage. Do not compensate in paint for a cascade or layout defect. `SUPPORTED.md` records unsupported primitives such as grid and selected selectors; do not promise browser parity.

## Design-time architecture

- `Tina4RESTRequestEditor.pas` registers component editors for REST request/JSON adapter workflows.
- `Tina4RESTEditor.pas` registers the custom-header property editor.
- `Tina4URLHeaderEditor.pas` + `.dfm` provide the editor form.
- Design-time code belongs only in `Tina4DelphiDesign`; never introduce `DesignIde` into the runtime package.

## Tests and examples

| Test unit | Primary coverage |
|---|---|
| `TestTina4Core.pas` | utility, conversion, request/response behavior |
| `TestTina4Components.pas` | component notification/data behavior and dense HTML/CSS/layout regression coverage |
| `TestTina4Frond.pas` | template parser/evaluator behavior |
| `TestTina4Twig.pas` | Twig-facing syntax, filters, expressions, scopes, and formatting |
| `TestTina4WebSocket.pas` | deterministic WebSocket behavior plus explicit network/TLS integration fixtures |

Use a minimal regression fixture close to the defect. Network tests must remain distinguishable from deterministic unit tests. UI changes need an example/reproduction in addition to pure layout assertions when visual evidence matters.

## Maintainer invariants

- Component references that may be freed elsewhere must use `FreeNotification` and clear themselves in `Notification`.
- Public/published properties affect form streaming and are compatibility surface.
- Runtime package changes must remain installable without design-time dependencies.
- Renderer feature changes require tests and an honest `SUPPORTED.md` update.
- Thread termination and callback lifetime matter in WebSocket/server code; never hide shutdown races.
- Platform conditionals must preserve a compiling path on every supported target.
- `readme.md`, package unit lists, tests, and examples should move with public features.
