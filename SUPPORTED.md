# Tina4HTMLRender — CSS / HTML coverage

A pragmatic, not-exhaustive map of what the FMX HTML renderer honours. If
something isn't listed it's almost certainly a no-op or unimplemented.

---

## CSS — properties

### Box model

| Property | Status | Notes |
|---|---|---|
| `width`, `height` | ✅ | px, `%`, `auto` |
| `min-width`, `max-width`, `min-height`, `max-height` | ✅ | px |
| `padding`, `padding-{top,right,bottom,left}` | ✅ | shorthand and longhands |
| `margin`, `margin-{top,right,bottom,left}` | ✅ | shorthand and longhands |
| `margin: 0 auto` (h-centre) | ✅ | block-flow context |
| `margin-left: auto` / `margin-right: auto` | ✅ | right- / left-align block |
| `margin: auto` (top + bottom auto) | ✅ | Tina4 extension — vertically centres a block child inside a fixed-height parent |
| `border`, `border-{top,right,bottom,left}` | ✅ | shorthand parsing of `width style color` |
| `border-radius`, four-corner longhands | ✅ | uniform + per-corner |
| `border-style: solid` | ✅ | `dashed`/`dotted` honoured on outline |
| `box-sizing: content-box` (default) / `border-box` | ✅ | |
| `box-shadow` | ✅ | including `inset` |
| `outline`, `outline-{color,width,style,offset}` | ✅ | drawn on top of border edge; doesn't affect layout |

### Sizing keywords

| Value | Status |
|---|---|
| `width: fit-content` / `min-content` / `max-content` | ✅ |

### Display

| Value | Status | Notes |
|---|---|---|
| `block` | ✅ | |
| `inline` | ✅ | |
| `inline-block` | ✅ | |
| `inline-table` | ✅ | outer-display:inline + inner-display:table |
| `flow-root` | ✅ | aliased to block — Tina4's blocks already enclose floats |
| `none` | ✅ | element + subtree skipped |
| `table`, `table-row`, `table-cell` | ✅ | including anonymous-row wrapping for orphan cells |
| `list-item` | ✅ | with bullet/number marker |
| **`flex`, `inline-flex`** | ✅ | row/column main axis, justify-content (start/end/center/space-between/space-around/space-evenly), align-items (start/end/center/stretch), flex-grow/shrink/basis, gap |
| `grid` | ❌ | not implemented |

### Position

| Value | Status | Notes |
|---|---|---|
| `static` (default) | ✅ | |
| `sticky` | ✅ | both axes — `top` to nearest scroll-ancestor's top, `left` to its left. Two-pass deep paint keeps sticky elements above non-sticky siblings. |
| **`relative`** | ✅ | paint-only shift via top/left/right/bottom; siblings unaffected |
| **`absolute`** | ✅ | out-of-flow; positioned against immediate parent's content area; left+right derives width; top+bottom derives height |
| **`top` / `right` / `bottom` / `left`** | ✅ | longhands |
| **`inset`** shorthand | ✅ | 1/2/3/4-value pattern (like `margin`). `inset: 0` on an `absolute` child stretches it to fill the containing block. Per-side longhands declared after `inset` override the shorthand. |
| **`fixed`** | ✅ | viewport-relative regardless of scroll |

### Float

| Value | Status |
|---|---|
| `float: left`, `float: right` | ✅ partial — sibling block boxes shift past floats; parent encloses overhang. Inline-content line-by-line wrap around floats not yet implemented. |
| **`clear: left`/`right`/`both`** | ✅ |

### Text

| Property | Status | Notes |
|---|---|---|
| `color` | ✅ | named, `#rrggbb`, `#rgb`, `rgb(...)`, `rgba(...)` |
| `font-family` | ✅ | first-listed family wins |
| `font-size` | ✅ | px, em, rem, pt, % |
| `font-weight` | ✅ | bold/normal + numeric (≥500 → bold) |
| `font-style: italic` | ✅ | |
| `text-align` | ✅ | left / right / center |
| `line-height` | ✅ | unitless multiplier and explicit lengths |
| `text-decoration: underline` / `line-through` | ✅ | |
| `white-space: normal` / `nowrap` / `pre` | ✅ | |
| `text-transform: uppercase` / `lowercase` / `capitalize` | ✅ | |
| `letter-spacing`, `text-indent` | ✅ | |
| `text-overflow: ellipsis` | ✅ | requires `white-space: nowrap` |
| `vertical-align` on `display: table-cell` | ✅ | top / middle / bottom; legacy `<td valign>` honoured |
| `vertical-align` on inline / inline-block | ❌ | parsed but ignored |
| **`text-shadow`** | ✅ | offset + colour painted as tinted underlay; blur captured but not rendered |

### Background

| Property | Status | Notes |
|---|---|---|
| `background-color` | ✅ | named + hex + rgb/rgba |
| `background-image: url(...)` | ✅ | http(s) and `data:image/...;base64,...` URIs |
| `background-size: cover` / `contain` / `auto` | ✅ | |
| **`background-position`** | ✅ | keywords (top/right/bottom/left/center) + percentages + lengths. Honoured by cover (shifts crop), contain (shifts dest), repeat (shifts tile origin). |
| **`background-repeat`** | ✅ | repeat / repeat-x / repeat-y / no-repeat |
| `background` shorthand | ✅ | extracts color + url(...) + linear-gradient |
| **`linear-gradient(angle, c1, c2)`** | ✅ | painted as Linear-Gradient brush; multi-stop falls back to first+last |
| `radial-gradient` | ❌ | |

### Transforms

| Property | Status | Notes |
|---|---|---|
| **`transform: translate(x,y)`** / `translateX` / `translateY` | ✅ | |
| **`transform: rotate(deg)`** | ✅ | rotates around box centre |
| **`transform: scale(n)`** / `scale(x,y)` / `scaleX` / `scaleY` | ✅ | |
| Multiple chained transforms | ✅ | accumulate per-axis |
| `transform-origin` override | ❌ | always centre (50% 50%) |
| `matrix()` / `matrix3d()` / 3D transforms | ❌ | |

### Visibility / overflow

| Property | Status | Notes |
|---|---|---|
| `visibility: visible` / `hidden` | ✅ | |
| `opacity` | ✅ | applied to background + border |
| `overflow`, `overflow-x`, `overflow-y` | ✅ | `visible` / `hidden` / `auto` / `scroll` |
| `cursor` | ✅ | mapped to FMX cursor types |

### Tables

| Feature | Status |
|---|---|
| Per-cell `width` (style / attr / CSS rule) | ✅ |
| `<colgroup>` / `<col style="width:...">` / `<col span="N">` | ✅ |
| Anonymous row wrapping for orphan cells | ✅ |
| `colspan` | ✅ |
| `rowspan` | ❌ |
| `border-collapse: collapse` | ✅ (always) |
| `border-collapse: separate` | ❌ |

### Lists

| Property | Status |
|---|---|
| `list-style-type` | ✅ |

### CSS variables

| Feature | Status |
|---|---|
| Custom properties (`--name`) on `:root` and elements | ✅ |
| `var(--name, fallback)` | ✅ |

### Selectors

| Form | Status |
|---|---|
| Tag (`div`) | ✅ |
| Class (`.foo`) | ✅ |
| ID (`#bar`) | ✅ |
| Compound (`div.foo#bar`) | ✅ |
| Descendant (`div p`) | ✅ |
| Comma list (`h1, h2, h3`) | ✅ |
| **`:hover`, `:active`, `:focus`** | ✅ runtime — flags maintained on the tag, MouseMove/MouseDown update the chain |
| **`[attr]` (presence)** | ✅ |
| **`[attr="value"]` (exact)** | ✅ |
| `[attr~=]`, `[attr^=]`, `[attr$=]`, `[attr*=]` | ❌ |
| `:not()`, `:nth-child()` | ❌ — parsed without crashing; rules silently no-match (verified) |
| Universal (`*`) | ✅ |
| `+` adjacent / `~` general sibling combinators | ❌ |
| `@media`, `@keyframes`, other at-rules | ⚠️ parsed but skipped (don't break the stylesheet) |
| `!important` | ⚠️ stripped before parsing — cascade priority isn't tracked |

---

## HTML — elements

| Element | Status |
|---|---|
| `<html>`, `<body>`, `<head>`, `<style>`, `<title>`, `<meta>` | ✅ |
| `<div>`, `<p>`, `<span>`, `<a>`, `<br>`, `<hr>`, `<img>` | ✅ |
| `<h1>`–`<h6>`, `<b>`, `<i>`, `<u>`, `<strong>`, `<em>`, `<s>`, `<sub>`, `<sup>` | ✅ |
| `<ul>`, `<ol>`, `<li>` | ✅ |
| `<table>`, `<tr>`, `<td>`, `<th>`, `<thead>`, `<tbody>`, `<tfoot>`, `<colgroup>`, `<col>` | ✅ |
| `<blockquote>`, `<pre>`, `<code>` | ✅ |
| `<input>`, `<button>`, `<textarea>`, `<select>`, `<option>` | ✅ — native FMX controls |
| `<form>` (with submit handling), file uploads | ✅ |
| `<canvas>`, `<svg>`, `<video>`, `<audio>` | ❌ |

---

## Events / Diagnostics

| Hook | Notes |
|---|---|
| `onclick="Object:Method(args)"` | RTTI dispatch to public/published methods on objects registered via `RegisterObject` |
| `OnElementClick` event | Fallback when RTTI dispatch doesn't catch |
| **`OnUnresolvedClick`** event | **Diagnostic** — fires when a click can't be dispatched, with a Reason ("method not found", "private visibility", "wrong arg count", etc.) |
| **`OnCssParseError`** event | **Diagnostic** — fires when a CSS rule produces zero parsable declarations |
| `OnFormControlClick` / `OnFormControlChange` / `OnFormSubmit` | Native form events |
| `OnLinkClick` | `<a href="...">` click; set `Handled := True` to skip default |
| `OnScroll` | Viewport scroll position |
| **`DebugBoxOverlay`** property | Toggle to paint margin (orange) / padding (green) / content (blue) frames over every laid-out box |

---

## Mobile-specific

* HTML input attributes (`type`, `inputmode`, `enterkeyhint`, `autocapitalize`, `maxlength`) map to Android/iOS soft keyboards.
* Return-key traversal (`enterkeyhint="next" / "go" / "send" / "search"`) follows tab order and triggers form submit on the last field.
* Scroll-into-view auto-lifts the focused input above the on-screen keyboard.
* Pan-to-scroll with momentum (inertia). Tunable feel: `ScrollDragFactor` (held-drag speed, default 1.0 = 1:1 finger tracking — raise to scroll faster per swipe), `ScrollFlingFactor` (flick launch "acceleration", default 1.0), `ScrollDeceleration` (momentum friction, default 0.92). `ScrollBarsVisible` / `ScrollBarOverlay` control scrollbar appearance — set overlay-style on mobile.

---

## Roadmap / known gaps

1. **Inline-content text wrap around floats** — currently siblings shift uniformly; line-by-line wrap is the bigger float feature still out.
2. **`+` / `~` sibling combinators** — needs proper tokenizing instead of split-by-space.
3. **`@media` query evaluation** — currently parsed-and-skipped. Min/max-width queries against the renderer width would unlock responsive design.
4. **`!important`** — strip-and-discard; cascade ordering ignores it.
5. **Multiple `background-image` layers** (comma-separated) — only first rendered.
6. **`grid`** — biggest remaining layout primitive.
7. **`:nth-child()`, `:not()`** runtime matching.
8. **Incremental relayout** — full reparse on every mutation; expensive on large trees.

---

## See also

* `readme.md` — top-level docs and tutorials
* `Tina4HTMLRender.pas` — implementation
* `Example/Test/TestTina4Components.pas` — 480+ DUnit tests pinning specific behaviours
