#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repository_root="$(cd "$script_dir/.." && pwd)"
skill_root="$repository_root/skills"
skill_names=(rad-studio-delphi rad-studio-maintainer)

if (($# == 0)); then
  clients=(all)
else
  clients=("$@")
fi

for client in "${clients[@]}"; do
  case "$client" in
    all)
      clients=(codex claude cursor)
      break
      ;;
    codex|claude|cursor)
      ;;
    *)
      echo "Unknown client: $client" >&2
      echo "Use: all, codex, claude, or cursor" >&2
      exit 2
      ;;
  esac
done

for client in "${clients[@]}"; do
  case "$client" in
    codex)
      destination_root="${CODEX_HOME:-$HOME/.codex}/skills"
      ;;
    claude)
      destination_root="$HOME/.claude/skills"
      ;;
    cursor)
      destination_root="$HOME/.cursor/skills"
      ;;
  esac

  mkdir -p "$destination_root"

  for skill_name in "${skill_names[@]}"; do
    source="$skill_root/$skill_name"
    destination="$destination_root/$skill_name"

    if [[ ! -d "$source" ]]; then
      echo "Skill source not found: $source" >&2
      exit 1
    fi

    if [[ -d "$destination" ]] &&
       [[ "$(cd "$destination" && pwd -P)" == "$(cd "$source" && pwd -P)" ]]; then
      echo "Already linked $skill_name for $client at $destination"
      continue
    fi

    mkdir -p "$destination"
    cp -R "$source/." "$destination/"
    echo "Installed $skill_name for $client at $destination"
  done
done

echo "Restart clients that were open before the skills were installed."
