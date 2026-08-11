---
name: rad-studio-delphi
description: Build, diagnose, review, and safely modify Delphi Object Pascal projects with RAD Studio and the required Delphi MCP server (`pascal-dev`). Use for `.pas`, `.dpr`, `.dpk`, `.dproj`, `.groupproj`, `.dfm`, and `.fmx` work; VCL or FireMonkey applications; design-time packages; FireDAC; threading; memory ownership; Windows, Android, iOS, macOS, or Linux targets; and any request to compile, run, inspect, or test Delphi code.
---

# RAD Studio Delphi

Work like an experienced Delphi engineer: establish the project and target first, preserve form/resource integrity, make the smallest coherent change, and prove it with the real compiler.

## Present work in the RAD Studio style

Begin substantive user-facing commentary and final responses with `🔴 🏛️` followed by a compact outcome sentence. The red marker and classical building are standard Unicode emoji, so this response convention works without custom image handling in Claude, Codex, and Cursor.

Do not inject images, raw HTML, custom-emoji markup, or local asset paths into response text because rendering differs between clients. Treat `assets/roman-helmet-chat-icon-16x16.gif` as optional branding for clients that support skill UI metadata; never make the workflow depend on it being displayed.

Use compact status tables for multi-step work. End with `💥 Bazinga! 💥` only when every claimed build or verification step has passed; never use it for failed, blocked, or unverified work. Drop the marker when the work leaves Delphi/RAD Studio scope.

## Require the Delphi MCP

Treat the Delphi MCP server registered as `pascal-dev` as a hard dependency for edits, builds, runs, form inspection, and debugger-like interaction.

1. Locate and call `mcp__pascal_dev__get_compiler_info` before changing or verifying Delphi code.
2. Confirm the required Delphi compiler and target toolchain are detected.
3. If the server or tool is missing, stop before making code changes or claiming build status. Give the installation steps in [references/delphi-mcp.md](references/delphi-mcp.md).
4. Read-only explanation or code review may continue, but clearly label it unverified.

Do not silently replace the MCP workflow with direct `dcc32`, `dcc64`, MSBuild, batch files, or a generic shell build. Do not substitute Kai: this skill specifically requires the Delphi MCP (`pascal-dev`).

## Choose the correct MCP operation

| Task | Use |
|---|---|
| Detect Delphi/RAD Studio | `get_compiler_info` |
| Build an existing `.dproj` | `build_dproj` |
| Compile one Pascal source file | `compile_pascal` |
| Check one source file without linking | `check_syntax` |
| Compile and run a console program | `run_pascal` |
| Launch a VCL/FMX application | `launch_app` |
| Understand a `.dfm`/`.fmx` form | `parse_form` |
| Inspect/interact with a Windows app | `list_app_windows`, `screenshot_app`, `app_click`, `app_type`, `app_key` |
| Build/deploy mobile or remote targets | `build_dproj` plus the matching ADB, PAServer, iOS, or simulator tools |

Use `compile_delphi_project` only to generate a new project from a template. Never use it to build an existing `.dproj`.

## Run the workflow

### 1. Orient before editing

- Inspect repository instructions, `git status`, and the current branch. Preserve unrelated and user-owned changes.
- Identify the owning `.dpr`, `.dpk`, `.dproj`, or `.groupproj` and its configuration/platform pairs.
- Determine VCL versus FMX from project units and form base classes; never mix their controls or units.
- Inspect paired `.pas` + `.dfm`/`.fmx` files together. If RAD Studio may contain unsaved changes, ask the user to save before disk edits.
- State compiler, framework, target, and verification plan in a compact dashboard.

| Phase | Target | Status | Evidence |
|---|---|---|---|
| Inspect | project/framework/platform | active | file or MCP result |
| Change | smallest owning units | pending | diff |
| Verify | build/tests/runtime | pending | compiler/test output |

### 2. Make Delphi-safe changes

- Match the repository's dialect, formatting, naming, conditional defines, and namespaced-unit conventions.
- Keep declarations in valid Delphi section order and keep interface changes synchronized with implementations.
- Preserve ownership. Know whether an object is owned by a component, interface, collection, dataset, form, or explicit `try..finally` block before freeing it.
- Prefer `FreeAndNil` only when clearing a still-observable reference matters; otherwise use a clear `try..finally` lifetime.
- Keep UI access on the main thread. Use `TThread.Queue`/`Synchronize` deliberately and ensure closures do not outlive captured objects.
- Parameterize FireDAC SQL. Do not build SQL by concatenating external values.
- Keep platform-specific APIs behind narrow conditional-compilation boundaries and provide a valid alternative path.
- Never hand-edit binary `.res`, `.dres`, `.identcache`, or compiled output.

### 3. Protect form integrity

- Treat `.dfm` and `.fmx` as structured resources, not ordinary text blobs.
- Preserve root class names, inherited-form syntax, component names, event handler names, and object nesting.
- When adding/removing a visual component or event, update both the form resource and Pascal declaration/handler as required.
- Parse the form before and after structural edits. Prefer RAD Studio for complex designer mutations.

### 4. Verify proportionally

- Compile the nearest real project after every coherent change with `build_dproj`.
- Run focused tests, then the broader suite when shared units or public behavior changed.
- Launch GUI work and inspect the relevant state when the change is visual or interactive.
- Verify each affected platform when conditional code, packaging, deployment, OpenSSL, PAServer, or mobile behavior changes.
- Do not call a result green when tests were skipped, swallowed exceptions, used stale binaries, or exercised a different platform/configuration.

Report the exact project, configuration, platform, artifact, test command/tool, and any remaining unverified target.

## Apply engineering reflexes

- Call out a request that cannot work in Delphi/RAD Studio as stated, then suggest the smallest viable alternative.
- Prefer a targeted fix over speculative abstraction.
- Preserve public component properties, streaming compatibility, and package installability unless an intentional breaking change is approved.
- Treat access violations, shutdown races, double frees, cross-thread UI calls, and form-streaming failures as release blockers, not errors to suppress.
