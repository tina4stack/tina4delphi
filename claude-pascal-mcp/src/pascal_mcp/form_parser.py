"""Parser for Delphi/Lazarus form files (.dfm, .fmx, .lfm).

DFM/FMX/LFM files use a text-based format describing the component tree:

    object Form1: TForm1
      Caption = 'My Form'
      ClientWidth = 400
      object Button1: TButton
        Left = 10
        Top = 20
        Caption = 'Click Me'
        OnClick = Button1Click
      end
    end

This module parses these files into a structured component tree and
provides multiple output formats (tree view, summary, JSON-like).
"""

from __future__ import annotations

import os
import re
from dataclasses import dataclass, field
from pathlib import Path


@dataclass
class FormComponent:
    """A component in a DFM/FMX/LFM form."""
    name: str
    class_name: str
    properties: dict[str, str] = field(default_factory=dict)
    children: list[FormComponent] = field(default_factory=list)
    events: dict[str, str] = field(default_factory=dict)


def parse_form_file(file_path: str) -> FormComponent | None:
    """Parse a DFM/FMX/LFM file and return the root component.

    Args:
        file_path: Path to the form file.

    Returns:
        The root FormComponent, or None if parsing fails.
    """
    try:
        content = Path(file_path).read_text(encoding="utf-8", errors="replace")
    except (OSError, IOError) as e:
        raise ValueError(f"Cannot read form file: {e}")

    return parse_form_content(content)


def parse_form_content(content: str) -> FormComponent | None:
    """Parse DFM/FMX/LFM content string and return the root component.

    Args:
        content: The text content of a form file.

    Returns:
        The root FormComponent, or None if parsing fails.
    """
    lines = content.splitlines()
    if not lines:
        return None

    root, _ = _parse_object(lines, 0)
    return root


def _parse_object(lines: list[str], index: int) -> tuple[FormComponent | None, int]:
    """Parse an object block starting at the given line index.

    Returns:
        Tuple of (FormComponent, next_line_index).
    """
    if index >= len(lines):
        return None, index

    line = lines[index].strip()

    # Match: object Name: TClassName
    # or:    inherited Name: TClassName
    # or:    inline Name: TClassName
    match = re.match(
        r"(?:object|inherited|inline)\s+(\w+)\s*:\s*(\w+)",
        line,
        re.IGNORECASE,
    )
    if not match:
        return None, index + 1

    name = match.group(1)
    class_name = match.group(2)
    component = FormComponent(name=name, class_name=class_name)

    index += 1
    while index < len(lines):
        line = lines[index].strip()

        # End of this object
        if line == "end":
            return component, index + 1

        # Nested object
        if re.match(r"(?:object|inherited|inline)\s+\w+\s*:\s*\w+", line, re.IGNORECASE):
            child, index = _parse_object(lines, index)
            if child:
                component.children.append(child)
            continue

        # Property assignment: Key = Value
        prop_match = re.match(r"(\S+(?:\.\S+)*)\s*=\s*(.*)", line)
        if prop_match:
            key = prop_match.group(1)
            value = prop_match.group(2)

            # Handle multi-line values (parenthesized lists, hex data, strings)
            value, index = _read_full_value(lines, index, value)

            # Classify as event or property
            if key.startswith("On") and not "." in key:
                component.events[key] = value
            else:
                component.properties[key] = value
            continue

        index += 1

    return component, index


def _read_full_value(lines: list[str], current_index: int, initial_value: str) -> tuple[str, int]:
    """Read a potentially multi-line property value.

    Handles:
    - Parenthesized lists: ( item1 item2 )
    - Angle-bracket collections: < item ... >
    - Hex data blocks: { hex... }
    - Continuation strings: 'part1' + 'part2'
    """
    value = initial_value.strip()
    index = current_index + 1

    # Parenthesized list: starts with ( ends with )
    if value == "(":
        parts = []
        while index < len(lines):
            line = lines[index].strip()
            if line.endswith(")"):
                part = line[:-1].strip()
                if part:
                    parts.append(part)
                value = "(" + ", ".join(parts) + ")"
                return value, index + 1
            parts.append(line)
            index += 1
        return value, index

    # Angle-bracket collection: starts with < ends with >
    if value == "<":
        depth = 1
        parts = [value]
        while index < len(lines) and depth > 0:
            line = lines[index].strip()
            depth += line.count("<") - line.count(">")
            parts.append(line)
            index += 1
        value = " ".join(parts)
        return value, index

    # Hex data block: starts with { ends with }
    if value.startswith("{"):
        if value.endswith("}"):
            value = "{...binary data...}"
            return value, index
        # Multi-line hex
        while index < len(lines):
            line = lines[index].strip()
            if line.endswith("}"):
                value = "{...binary data...}"
                return value, index + 1
            index += 1
        value = "{...binary data...}"
        return value, index

    # String continuation: lines ending with +
    while value.endswith("+") and index < len(lines):
        value = value[:-1].strip()
        next_line = lines[index].strip()
        value = value + " " + next_line
        index += 1

    # Multi-line string: line that is just a string literal continuing previous
    while index < len(lines):
        next_line = lines[index].strip()
        if next_line.startswith("'") and not re.match(r"\S+\s*=", next_line):
            # Check if this looks like a string continuation
            if value.endswith("'") and next_line.startswith("'"):
                value = value + " + " + next_line
                index += 1
                continue
        break

    return value, index


def format_tree(component: FormComponent, indent: int = 0, max_depth: int = 20) -> str:
    """Format a component tree as an indented text tree.

    Args:
        component: The root component to format.
        indent: Current indentation level.
        max_depth: Maximum nesting depth to display.

    Returns:
        A string representation of the component tree.
    """
    if indent > max_depth:
        return "  " * indent + "...(truncated)\n"

    prefix = "  " * indent
    lines = [f"{prefix}{component.name}: {component.class_name}"]

    # Show key layout/visual properties
    important_props = [
        "Caption", "Text", "Left", "Top", "Width", "Height",
        "ClientWidth", "ClientHeight", "Align",
        "Position.X", "Position.Y",
        "Size.Width", "Size.Height",
        "Visible", "Enabled", "TabOrder",
    ]

    for prop in important_props:
        if prop in component.properties:
            lines.append(f"{prefix}  {prop} = {component.properties[prop]}")

    # Show events
    if component.events:
        event_list = ", ".join(f"{k}={v}" for k, v in component.events.items())
        lines.append(f"{prefix}  Events: {event_list}")

    # Recurse into children
    for child in component.children:
        lines.append(format_tree(child, indent + 1, max_depth))

    return "\n".join(lines)


def format_summary(component: FormComponent) -> str:
    """Format a high-level summary of the form.

    Shows form type, dimensions, component count by type,
    and event handler list.
    """
    lines = [f"Form: {component.name} ({component.class_name})"]

    # Form dimensions
    for prop in ("ClientWidth", "ClientHeight", "Width", "Height", "Caption", "Text"):
        if prop in component.properties:
            lines.append(f"  {prop}: {component.properties[prop]}")

    # Count components by type
    type_counts: dict[str, int] = {}
    event_handlers: list[str] = []
    _collect_stats(component, type_counts, event_handlers)

    lines.append(f"\nComponents ({sum(type_counts.values())} total):")
    for cls, count in sorted(type_counts.items(), key=lambda x: -x[1]):
        lines.append(f"  {cls}: {count}")

    if event_handlers:
        lines.append(f"\nEvent Handlers ({len(event_handlers)}):")
        for handler in sorted(event_handlers):
            lines.append(f"  {handler}")

    return "\n".join(lines)


def _collect_stats(
    component: FormComponent,
    type_counts: dict[str, int],
    event_handlers: list[str],
) -> None:
    """Recursively collect component type counts and event handlers."""
    # Collect events from this component
    for event_name, handler_name in component.events.items():
        event_handlers.append(f"{component.name}.{event_name} -> {handler_name}")

    # Count and recurse into children
    for child in component.children:
        type_counts[child.class_name] = type_counts.get(child.class_name, 0) + 1
        _collect_stats(child, type_counts, event_handlers)


def format_component_list(component: FormComponent) -> str:
    """Format a flat list of all components with their key properties.

    Useful for quickly seeing what's on a form.
    """
    lines: list[str] = []
    _flatten_components(component, lines, "")
    return "\n".join(lines)


def _flatten_components(
    component: FormComponent,
    lines: list[str],
    parent_path: str,
) -> None:
    """Recursively flatten component tree into a list."""
    path = f"{parent_path}.{component.name}" if parent_path else component.name

    # Build a brief description
    desc_parts = [f"{path}: {component.class_name}"]

    # Add position info
    pos_parts = []
    for prop in ("Left", "Top", "Position.X", "Position.Y"):
        if prop in component.properties:
            pos_parts.append(f"{prop}={component.properties[prop]}")
    if pos_parts:
        desc_parts.append(f"  pos({', '.join(pos_parts)})")

    # Add size info
    size_parts = []
    for prop in ("Width", "Height", "Size.Width", "Size.Height", "ClientWidth", "ClientHeight"):
        if prop in component.properties:
            size_parts.append(f"{prop}={component.properties[prop]}")
    if size_parts:
        desc_parts.append(f"  size({', '.join(size_parts)})")

    # Add caption/text
    for prop in ("Caption", "Text"):
        if prop in component.properties:
            desc_parts.append(f"  {prop}={component.properties[prop]}")

    lines.append(" ".join(desc_parts))

    for child in component.children:
        _flatten_components(child, lines, path)
