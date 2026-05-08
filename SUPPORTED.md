# Tina4HTMLRender — CSS / HTML coverage

A pragmatic, not-exhaustive map of what the FMX HTML renderer honours. If
something isn't listed it's almost certainly a no-op or unimplemented.
Entries marked **partial** behave correctly only in the scenarios called
out in the notes column.

---

## CSS — properties

### Box model

| Property | Status | Notes |
|---|---|---|
| `width`, `height` | ✅ | px and `%` (resolved against parent). Also `auto` (treated as 0 / not-set). |
| `min-width`, `max-width`, `min-height`, `max-height` | ✅ | px |
| `padding`, `padding-{top,right,bottom,left}` | ✅ | shorthand and longhands |
| `margin`, `margin-{top,right,bottom,left}` | ✅ | shorthand and longhands |
| `margin: 0 auto` (h-centre) | ✅ | block-flow context |
| `margin-left: auto` / `margin-right: auto` | ✅ | right- / left-align block |
| `margin: auto` (top + bottom auto) | ✅ | Tina4 extension — vertically centres a block child inside a fixed-height parent. CSS spec only does this in flex/grid; we do it because the parent height is already known at layout time. |
| `border`, `border-{top,right,bottom,left}` | ✅ | shorthand parsing of `width style color` |
| `border-radius`, four-corner longhands | ✅ | uniform + per-corner |
| `border-style: solid` | ✅ | `dashed` / `dotted` honoured on outline only |
| `box-sizing: content-box` (default) / `border-box` | ✅ | |
| `box-shadow` | ✅ | including `inset` |
| `outline`, `outline-{color,width,style,offset}` | ✅ | drawn on top of the border edge; doesn't affect layout. Negative offsets pull inward. |

### Sizing keywords

| Value | Status | Notes |
|---|---|---|
| `width: fit-content` | ✅ | shrink-wraps to widest line / longest child |
| `width: min-content` | ✅ | aliased to fit-content |
| `width: max-content` | ✅ | aliased to fit-content |

### Display

| Value | Status | Notes |
|---|---|---|
| `block` | ✅ | |
| `inline` | ✅ | |
| `inline-block` | ✅ | |
| `inline-table` | ✅ | outer-display:inline + inner-display:table |
| `flow-root` | ✅ | aliased to block — Tina4's blocks already enclose floats |
| `none` | ✅ | element + subtree skipped |
| `table`, `table-row`, `table-cell` | ✅ | including anonymous-row wrapping for orphan cells (CSS 2.1 §17.2.1) |
| `list-item` | ✅ | with bullet/number marker |
| `flex`, `grid` | ❌ | not implemented; on the roadmap |

### Position

| Value | Status | Notes |
|---|---|---|
| `static` (default) | ✅ | normal block flow |
| `sticky` | ✅ | both axes — `top` pins to nearest scroll-ancestor's top edge, `left` to its left edge. Two-pass deep paint ensures sticky elements render on top of their non-sticky siblings even when nested in `<thead>`/`<tbody>`. |
| `relative`, `absolute`, `fixed` | ❌ | parsed but ignored |

### Float

| Value | Status | Notes |
|---|---|---|
| `float: left`, `float: right` | ✅ partial | block-flow context only. Sibling block boxes shift past the float; parent stretches to enclose overhang. **Inline-content line-by-line wrap around floats is not yet implemented** — the whole sibling block shifts uniformly. |
| `clear` | ❌ | use `display: flow-root` or `overflow: auto` on parent to enclose floats |

### Text

| Property | Status | Notes |
|---|---|---|
| `color` | ✅ | named, `#rrggbb`, `#rgb`, `rgb(...)`, `rgba(...)` |
| `font-family` | ✅ | first-listed family wins |
| `font-size` | ✅ | px, em, rem, pt, % |
| `font-weight` | ✅ | bold-or-not (no numeric weights between 100-900) |
| `font-style: italic` | ✅ | |
| `text-align` | ✅ | left / right / center |
| `line-height` | ✅ | unitless multiplier and explicit lengths |
| `text-decoration: underline` | ✅ | |
| `white-space: normal` / `nowrap` / `pre` | ✅ | |
| `text-transform: uppercase` / `lowercase` / `capitalize` | ✅ | |
| `letter-spacing`, `text-indent` | ✅ | |
| `text-overflow: ellipsis` | ✅ | requires `white-space: nowrap` |
| `vertical-align` on `display: table-cell` | ✅ | top / middle / bottom; legacy `<td valign="...">` attribute also honoured |
| `vertical-align` on inline / inline-block | ❌ | parsed but ignored |
| `text-shadow` | ❌ | |

### Background

| Property | Status | Notes |
|---|---|---|
| `background-color` | ✅ | named + hex + rgb/rgba |
| `background-image: url(...)` | ✅ | http(s) and `data:image/...;base64,...` URIs |
| `background-size: cover` / `contain` / `auto` | ✅ | |
| `background-position` | ⚠️ | always centred — `top`/`left`/etc. ignored |
| `background-repeat` | ❌ | always painted once |
| `background` shorthand | ✅ | extracts color + url(...) |
| `linear-gradient` / `radial-gradient` | ❌ | |

### Visibility / overflow

| Property | Status | Notes |
|---|---|---|
| `visibility: visible` / `hidden` | ✅ | |
| `opacity` | ✅ | applied to background + border |
| `overflow`, `overflow-x`, `overflow-y` | ✅ | `visible` / `hidden` / `auto` / `scroll` |
| `cursor` | ✅ | mapped to FMX cursor types |

### Tables

| Feature | Status | Notes |
|---|---|---|
| Per-cell `width` / `style="width:..."` / `width="..."` HTML attr | ✅ | first cell-per-column wins; percentages resolve against table content width |
| `<colgroup>` / `<col style="width:...">` / `<col width="..." span="N">` | ✅ | highest priority — applied before per-cell widths |
| Anonymous row wrapping for orphan cells | ✅ | `display:table` parent with direct `display:table-cell` children |
| `colspan`, `rowspan` | ⚠️ | `colspan` honoured for cell width-across; `rowspan` ignored |
| `border-collapse: collapse` | ✅ | always collapsed (default) |
| `border-collapse: separate` | ❌ | always-collapsed |
| `<th>` defaults | ✅ | bold + center text |

### Lists

| Property | Status | Notes |
|---|---|---|
| `list-style-type` | ✅ | disc / circle / square / decimal / lower-alpha / upper-alpha / lower-roman / upper-roman / none |

### CSS variables

| Feature | Status | Notes |
|---|---|---|
| Custom properties (`--name: value`) | ✅ | defined on `:root` are global; element-scoped vars work too |
| `var(--name, fallback)` | ✅ | |

### Selectors

| Form | Status | Notes |
|---|---|---|
| Tag (`div`) | ✅ | |
| Class (`.foo`) | ✅ | |
| ID (`#bar`) | ✅ | |
| Compound (`div.foo#bar`) | ✅ | |
| Descendant (`div p`) | ✅ | |
| Comma list (`h1, h2, h3`) | ✅ | |
| Pseudo-classes (`:hover`, `:focus`, `:not()`, `:nth-child()`) | ❌ | parsed without crashing — rules with unsupported selectors simply never match (verified — does NOT drop sibling rules). |
| Universal (`*`) | ✅ | combined with `:root` for global custom properties |
| `@media`, `@keyframes`, other at-rules | ⚠️ | parsed but skipped (don't break the stylesheet) |
| `!important` | ⚠️ | stripped before parsing — cascade priority isn't tracked |

---

## HTML — elements

| Element | Status |
|---|---|
| `<html>`, `<body>`, `<head>` (skipped), `<style>`, `<title>` (skipped), `<meta>` (skipped) | ✅ |
| `<div>`, `<p>`, `<span>`, `<a>`, `<br>`, `<hr>`, `<img>` | ✅ |
| `<h1>`–`<h6>`, `<b>`, `<i>`, `<u>`, `<strong>`, `<em>`, `<s>`, `<sub>`, `<sup>` | ✅ |
| `<ul>`, `<ol>`, `<li>` | ✅ |
| `<table>`, `<tr>`, `<td>`, `<th>`, `<thead>`, `<tbody>`, `<tfoot>`, `<colgroup>`, `<col>` | ✅ |
| `<blockquote>`, `<pre>`, `<code>` | ✅ |
| `<input>`, `<button>`, `<textarea>`, `<select>`, `<option>` | ✅ — native FMX controls |
| `<form>` (with submit handling), file uploads | ✅ |
| `<canvas>`, `<svg>`, `<video>`, `<audio>` | ❌ |

---

## Events

| Hook | Notes |
|---|---|
| `onclick="Object:Method(args)"` | RTTI dispatch to public/published methods on objects registered via `RegisterObject`. Args are passed as strings. |
| `OnElementClick` event | Fallback when RTTI dispatch doesn't catch |
| `OnUnresolvedClick` event | **Diagnostic hook** — fires when a click can't be dispatched, with a human-readable `Reason` ("method not found", "private visibility", "wrong arg count", etc.). Recommended for development builds — use it to log silent failures. |
| `OnFormControlClick` / `OnFormControlChange` / `OnFormSubmit` | Native form events |
| `OnLinkClick` | `<a href="...">` click; set `Handled := True` to skip default |
| `OnScroll` | Viewport scroll position |

---

## Mobile-specific

* HTML input attributes (`type`, `inputmode`, `enterkeyhint`, `autocapitalize`, `maxlength`) map to Android/iOS soft keyboards.
* Return-key traversal (`enterkeyhint="next" / "go" / "send" / "search"`) follows tab order and triggers form submit on the last field.
* Scroll-into-view auto-lifts the focused input above the on-screen keyboard.

---

## Known gaps (high-impact roadmap)

1. **Flexbox** — `display: flex; justify-content; align-items` would replace most pixel-math layouts.
2. **Position absolute/fixed** — for tooltips, badges, overlay placement.
3. **Inline-content text wrap around floats** — currently siblings shift uniformly.
4. **Multiple `background-image` layers** (comma-separated) — only the first is rendered.
5. **CSS transforms** (translate, rotate, scale).
6. **Pseudo-classes** (`:hover`, `:focus`, `:not()`, `:nth-child()`) match-time, not just parse-time.

---

## See also

* `readme.md` — top-level docs and tutorials
* `Tina4HTMLRender.pas` — implementation
* `Example/Test/TestTina4Components.pas` — 450+ DUnit tests pinning specific behaviours
