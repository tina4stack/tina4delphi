---
name: rad-studio-maintainer
description: Maintain the Tina4Delphi framework repository with repository-specific knowledge and required Delphi MCP (`pascal-dev`) verification. Use for Tina4Delphi PR review, issue diagnosis, component/API work, FMX HTML/CSS rendering, Frond/Twig templates, REST/FireDAC, WebSocket/TLS, package installation, tests, examples, releases, cross-platform builds, or any maintenance request in a repository containing Tina4Delphi units and projects.
---

# RAD Studio Maintainer

Maintain Tina4Delphi as a framework, not as a loose collection of Pascal files. Protect consumers, component streaming, platform parity, renderer behavior, and package installability.

## Present work in the RAD Studio style

Begin substantive user-facing commentary and final responses with `🔴 🛡️` followed by a compact outcome sentence. The red marker and shield are standard Unicode emoji, so this response convention works without custom image handling in Claude, Codex, and Cursor.

Do not inject images, raw HTML, custom-emoji markup, or local asset paths into response text because rendering differs between clients. Treat `assets/roman-helmet-chat-icon-16x16.gif` as optional branding for clients that support skill UI metadata; never make the workflow depend on it being displayed.

Use short dashboard updates in the practical Tina4 skill style:

| Track | Scope | Status | Evidence |
|---|---|---|---|
| Repository | branch + dirty files | active | git state |
| Change | owning subsystem | pending | diff/tests |
| Verification | project/platform | pending | MCP output |

End with `💥 Bazinga! 💥` only when every claimed build, test, and verification step has passed. Never use it for failed, blocked, or unverified work.

## Require the Delphi MCP

Before editing, building, running, parsing forms, or claiming verification:

1. Locate and call `mcp__pascal_dev__get_compiler_info`.
2. Confirm a supported RAD Studio compiler is detected.
3. If `pascal-dev` is unavailable, stop active maintenance work and give the installation steps in [references/delphi-mcp.md](references/delphi-mcp.md).

Read-only triage may continue as explicitly unverified. Do not fall back to direct MSBuild, batch scripts, or Kai; this skill requires the Delphi MCP.

Use `build_dproj` for existing projects. Never use `compile_delphi_project` to build the repository's `.dproj` files.

## Load Tina4Delphi context

Read [references/tina4delphi-map.md](references/tina4delphi-map.md) before planning repository changes. Then confirm relevant facts against the current source; the map is navigation, while `.dpk`, `.dproj`, public unit interfaces, tests, `readme.md`, and `SUPPORTED.md` are authoritative.

## Run the maintenance workflow

### 1. Establish repository truth

- Read repository instructions.
- Inspect current branch, remotes, `git status`, and untracked files. Never overwrite or fold in unrelated user changes.
- Read the issue/PR diff and the owning unit's public interface before judging the implementation.
- Identify affected runtime package units, design-time units, tests, examples, docs, resources, and platforms.
- Check whether generated/compiled artifacts are being confused with source.

### 2. Challenge the plan

- State the user-visible or maintainer-visible value.
- Call out requests that fight Delphi ownership, FMX behavior, package streaming, platform constraints, or the project's stated support map.
- Prefer a coherent focused change. Avoid speculative frameworks, duplicated parsers, parallel abstractions, and silent compatibility breaks.
- For public API changes, account for existing `.fmx`/`.dfm` streaming and downstream projects.

### 3. Edit the owning subsystem

- Follow existing Object Pascal style and conditional-compilation patterns.
- Add runtime units to `Tina4Delphi.dpk`; add editors/design-time units only to `Tina4DelphiDesign.dpk`.
- Register new components on the `Tina4Delphi` palette and keep design-time dependencies out of the runtime package.
- Implement component reference cleanup through `Notification`/`FreeNotification` where ownership can change externally.
- Keep FireDAC data flow parameterized and compatible with component lifetimes.
- Treat networking threads, shutdown order, OpenSSL/Network.framework boundaries, and reconnect state as high-risk code.

### 4. Apply subsystem-specific proof

#### HTML renderer and pages

- Trace behavior through parse → cascade/computed style → layout → paint → hit testing/native controls.
- Check `SUPPORTED.md` before promising browser behavior; update it when coverage changes.
- Add a focused DUnit regression in `Example/Test/TestTina4Components.pas` for parser/layout behavior.
- Use a minimal HTML reproduction and launch/inspect an example when pixels or interaction matter.
- Verify DOM mutation, scroll state, form controls, images, and pseudo-state only when the change touches them.

#### Frond and Twig

- Keep `TTina4Frond` as the implementation source and `TTina4Twig` as the compatibility surface unless the current source says otherwise.
- Add focused fixtures in `TestTina4Frond.pas` or `TestTina4Twig.pas` for parsing, scope, filters, expressions, and escaping behavior.

#### REST, JSON, routing, and databases

- Verify component notifications, MemTable ownership, async completion, request body/parameter behavior, and error propagation.
- Never satisfy a test by swallowing an exception or replacing a real contract with a mock-only path.

#### WebSocket, server, and TLS

- Separate deterministic frame/state tests from opt-in network integration tests.
- Verify close/reconnect races and thread termination. Treat access violations or hanging shutdown as blockers.
- Respect the platform TLS split: OpenSSL where used, Apple's Network.framework on iOS/iPadOS.

### 5. Build and test with evidence

- Build the nearest affected real `.dproj` using `build_dproj` with an explicit configuration and platform.
- Build the runtime package when shared runtime units change; build the design package when editors/registration change.
- Run `Example/Test/Tina4DelphiExampleTests.dproj` for framework changes, first focused and then complete when practical.
- Build or launch the affected example for UI/runtime regressions.
- Exercise every affected conditional platform or identify it as unverified. Do not extrapolate a Win32 pass to Android/iOS/macOS/Linux.
- Confirm artifacts are fresh; stale DCUs/BPLs/executables are not evidence.

### 6. Review or merge responsibly

- Review behavior, ownership, thread safety, API compatibility, form streaming, package composition, and tests—not formatting alone.
- Merge only when required checks and MCP-backed builds are green and the worktree/branch target is unambiguous.
- Do not merge code that hides access violations, leaves background threads alive, skips required tests, or changes generated resources without an explainable source change.

Finish with a dashboard listing exact project/configuration/platform results, tests run, files changed, and remaining risks.
