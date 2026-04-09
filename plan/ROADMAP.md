# Tina4Delphi Roadmap

## Vision
Tina4Delphi as a **full-stack, self-contained framework** — both a complement to Tina4 PHP/Python and an independent infrastructure for building backend + frontend applications in Delphi/Free Pascal. Zero third-party dependencies.

## Target Audience
- Delphi app developers (FMX)
- Full-stack Delphi developers (client + server)
- Free Pascal developers (secondary, after core stabilization)
- Cross-platform teams (Win/Mac/Linux/Android/iOS)
- RAD prototypers wanting drag-and-drop web-connected components

## Distribution
- Embarcadero GetIt package manager
- Delphinus / Boss community package managers

---

## Phase 1: Custom HTTP Server Foundation
**Goal:** Replace the Indy-based `TTina4WebServer` stub with a custom sockets-based HTTP server. No third-party dependencies.

### 1.1 — Core TCP Server (`Tina4HttpServer.pas`)
- Custom TCP listener using platform sockets (WinSock / POSIX)
- Multi-threaded connection handling (thread pool)
- HTTP/1.1 request parsing (method, path, headers, body, query params)
- HTTP response builder (status, headers, body, chunked transfer)
- Keep-alive connection support
- HTTPS/TLS via existing `Tina4OpenSSL.pas` wrapper

### 1.2 — Routing Engine (`Tina4Router.pas`)
- Route registration: `GET /path`, `POST /path`, `PUT`, `PATCH`, `DELETE`
- Path parameters: `/users/{id}`, `/posts/{postId}/comments/{commentId}`
- Wildcard routes: `/static/*`
- Route matching with priority ordering
- Request/Response objects with typed access to params, headers, body, query
- Route groups with shared prefixes: `/api/v1/...`

### 1.3 — Middleware Pipeline (`Tina4Middleware.pas`)
- Before/after request middleware chain
- Built-in middleware: CORS, logging, request timing
- Custom middleware support via interface/callback
- Per-route and global middleware assignment

### 1.4 — Static File Serving
- Serve files from a configurable document root
- MIME type detection
- Directory index (index.html)
- Cache headers (ETag, Last-Modified)
- Gzip compression (optional)

---

## Phase 2: Server-Side Templating & API
**Goal:** Connect the existing Twig engine to the server and build JSON API support.

### 2.1 — Server-Side Twig Rendering
- Integrate existing `Tina4Twig.pas` with route handlers
- Template directory configuration
- Layout/extends support for server-rendered pages
- Pass route params and request data into template context
- Auto-reload templates in debug mode

### 2.2 — JSON REST API Support
- Automatic JSON request body parsing
- JSON response helpers
- Content negotiation (Accept header)
- Request validation helpers
- Standardized error response format (status, message, errors)

### 2.3 — WebSocket Server
- Upgrade HTTP connections to WebSocket
- Room/channel pub-sub pattern
- Integrate with existing `TTina4WebSocketClient` for client-side parity
- Binary and text frame support

---

## Phase 3: Database Integration
**Goal:** Provide database helpers without building a full ORM. Support both FireDAC (Delphi) and ZeosLib (FPC).

### 3.1 — Database Abstraction (`Tina4Database.pas`)
- Common interface wrapping FireDAC and ZeosLib
- Connection management (pooling, config)
- Query execution with parameterized statements
- Result set to JSON conversion (leverage existing `GetJSONFromDB`)
- Transaction support

### 3.2 — Migration System
- Version-tracked SQL migrations (up/down)
- File-based migration scripts
- Auto-run pending migrations on server start
- Migration status tracking table

### 3.3 — Query Builder (Lightweight)
- Fluent interface for building SELECT/INSERT/UPDATE/DELETE
- No full ORM — stays close to SQL
- Cross-database compatibility (SQLite, MySQL, PostgreSQL, Firebird)

---

## Phase 4: HTML Render Maturity
**Goal:** Continue expanding the FMX HTML canvas renderer toward browser-level fidelity.

### 4.1 — CSS Expansion
- Flexbox layout (`display: flex`, `flex-direction`, `justify-content`, `align-items`)
- Grid layout basics (`display: grid`, `grid-template-columns/rows`)
- CSS transitions/animations (basic property interpolation)
- More pseudo-classes (`:hover`, `:focus`, `:nth-child`)
- `position: fixed`, `position: sticky`
- `overflow: scroll` with scrollbar rendering

### 4.2 — HTML Elements
- `<form>` elements: `<input>`, `<select>`, `<textarea>`, `<button>` (interactive)
- `<table>` improvements: `colspan`, `rowspan`, proper layout algorithm
- `<video>` / `<audio>` placeholder with platform media controls
- `<canvas>` element (basic 2D drawing API)
- `<svg>` rendering (basic shapes, paths)

### 4.3 — JavaScript Engine (Stretch)
- Lightweight JS interpreter for DOM manipulation
- Event handling (`onclick`, `onsubmit`, etc.)
- Basic DOM API (`getElementById`, `querySelector`)
- This is a stretch goal — evaluate feasibility

---

## Phase 5: Mobile Platform Polish
**Goal:** Production-quality Android and iOS support.

### 5.1 — Android
- Stable OpenSSL/BoringSSL loading (continue recent work)
- Background service support for HTTP server
- Push notification integration (FCM)
- App lifecycle handling (pause/resume server)
- File system path helpers for Android storage

### 5.2 — iOS
- TLS certificate handling
- Background task support
- App Transport Security compatibility
- Keychain integration for credentials

### 5.3 — Cross-Platform Testing
- CI pipeline for multi-platform builds
- Platform-specific test suites
- Automated device testing (ADB for Android)

---

## Phase 6: Component Ecosystem & Polish
**Goal:** Expand the component library and prepare for package manager distribution.

### 6.1 — New Components
- `TTina4Auth` — JWT token generation/validation, basic auth, API key auth
- `TTina4FileUpload` — Multipart upload handling with progress
- `TTina4Cache` — In-memory cache with TTL, optional file-backed persistence
- `TTina4Logger` — Structured logging (file, console, rotating)
- `TTina4Config` — Configuration from files (.ini, .json, .env)

### 6.2 — Free Pascal Compatibility
- Abstract FMX-specific code behind interfaces
- Provide FPC-compatible alternatives (LCL or headless)
- `.lpk` package for Lazarus
- Test suite running on FPC

### 6.3 — Distribution & Documentation
- GetIt package submission
- Delphinus / Boss package manifests
- Comprehensive documentation site
- Tutorial: "Build a REST API with Tina4Delphi"
- Tutorial: "Full-stack app with HTML renderer"
- Video walkthroughs
- Changelog and semantic versioning

---

## Priority Summary

| Phase | Priority | Est. Scope | Dependencies |
|-------|----------|-----------|--------------|
| 1. HTTP Server | Highest | Large | None |
| 2. Templates & API | High | Medium | Phase 1 |
| 3. Database | High | Medium | Phase 1 |
| 4. HTML Render | Medium | Ongoing | Independent |
| 5. Mobile Polish | Medium | Medium | Independent |
| 6. Ecosystem | Lower | Large | Phases 1-3 |

Phases 4 and 5 can progress **in parallel** with Phases 1-3 since they're independent workstreams.

---

## Immediate Next Steps (First Sprint)
1. Design the custom TCP server architecture (`Tina4HttpServer.pas`)
2. Implement basic HTTP request parsing and response building
3. Build the route registration and matching engine
4. Create a minimal working example: custom HTTP server serving a "Hello World" route
5. Add HTTPS support via existing OpenSSL wrapper
6. Deprecate/remove Indy dependency from the runtime package
