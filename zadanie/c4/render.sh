#!/usr/bin/env bash
# Validate ./workspace.dsl and render every view to ./out/ (paths relative to this script).
#
#   out/mermaid/<view>.mmd        Structurizr Mermaid export (HTML labels, needs securityLevel loose)
#   out/mermaid-plain/<view>.mmd  HTML stripped: paste into Miro / GitHub / mermaid.live
#   out/png/<view>.png            rendered from out/mermaid
#   out/svg/<view>.svg
#   out/LEGEND.md                 key for the rendered views (the Mermaid export has none)
#
# Usage: ./zadanie/c4/render.sh [path/to/workspace.dsl]   (from the repo root; any cwd works)
# Needs: Java 21+ and Node (npx). The Structurizr .war (~210 MB) is downloaded once to
# ~/.cache/structurizr unless a `structurizr` binary is on PATH (brew install structurizr).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="${1:-$ROOT/workspace.dsl}"
OUT="$(dirname "$WORKSPACE")/out"

STRUCTURIZR_VERSION="2026.09.19"
STRUCTURIZR_WAR="${STRUCTURIZR_WAR:-$HOME/.cache/structurizr/structurizr-$STRUCTURIZR_VERSION.war}"
MERMAID_CLI="@mermaid-js/mermaid-cli@11.12.0"

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
die() { printf '\033[1;31mERROR:\033[0m %s\n' "$*" >&2; exit 1; }

structurizr() {
  if type -P structurizr >/dev/null; then
    command structurizr "$@"
  else
    java -jar "$STRUCTURIZR_WAR" "$@"
  fi
}

mmdc() {
  if type -P mmdc >/dev/null; then
    command mmdc "$@"
  else
    npx -y "$MERMAID_CLI" "$@"
  fi
}

ensure_structurizr() {
  type -P structurizr >/dev/null && return
  command -v java >/dev/null 2>&1 || die "Java 21+ is required (or: brew install structurizr)"
  [[ -f "$STRUCTURIZR_WAR" ]] && return
  log "Downloading Structurizr $STRUCTURIZR_VERSION to $STRUCTURIZR_WAR (one-off, ~210 MB)"
  mkdir -p "$(dirname "$STRUCTURIZR_WAR")"
  curl -fL --progress-bar -o "$STRUCTURIZR_WAR.part" \
    "https://download.structurizr.com/structurizr-$STRUCTURIZR_VERSION.war"
  mv "$STRUCTURIZR_WAR.part" "$STRUCTURIZR_WAR"
}

[[ -f "$WORKSPACE" ]] || die "Workspace not found: $WORKSPACE"
command -v npx >/dev/null 2>&1 || die "Node.js (npx) is required for rendering"
ensure_structurizr

log "Validating $WORKSPACE"
if ! validation="$(structurizr validate -workspace "$WORKSPACE" 2>&1)"; then
  grep -E 'ERROR|Exception' <<<"$validation" >&2 || printf '%s\n' "$validation" >&2
  die "DSL validation failed"
fi

rm -rf "$OUT/mermaid" "$OUT/mermaid-plain" "$OUT/png" "$OUT/svg"
mkdir -p "$OUT/mermaid" "$OUT/mermaid-plain" "$OUT/png" "$OUT/svg"

log "Exporting views to Mermaid"
structurizr export -workspace "$WORKSPACE" -format mermaid -output "$OUT/mermaid" >/dev/null 2>&1 \
  || die "Mermaid export failed"
for f in "$OUT"/mermaid/structurizr-*.mmd; do
  mv "$f" "$OUT/mermaid/$(basename "$f" | sed 's/^structurizr-//')"
done

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
CONFIG="$TMP/mermaid-config.json"
echo '{"securityLevel":"loose","flowchart":{"htmlLabels":true}}' > "$CONFIG"

for f in "$OUT"/mermaid/*.mmd; do
  view="$(basename "$f" .mmd)"
  sed -E -e 's#</div><div[^>]*>#<br/>#g' -e 's#</?div[^>]*>##g' -e 's#<br />#<br/>#g' \
    "$f" > "$OUT/mermaid-plain/$view.mmd"
  log "Rendering $view"
  mmdc -q -i "$f" -o "$OUT/png/$view.png" -c "$CONFIG" -s 2 -b white
  mmdc -q -i "$f" -o "$OUT/svg/$view.svg" -c "$CONFIG" -b white
done

cat > "$OUT/LEGEND.md" <<'LEGEND'
# C4 diagram key

| Notation | Meaning |
|---|---|
| Dark blue box | Person (external user) |
| Light blue-grey box | Person (internal staff) |
| Blue box | Our software system (C1) |
| Lighter blue box | Container of our system (C2): front-end, domain service or data store |
| Grey box | External software system (not owned by us) |
| Cylinder | Data store |
| Outline box | System or container boundary |
| Solid arrow | Synchronous request (label = intent, `[technology]`) |
| Dashed arrow | Asynchronous message (event on the `room-status-events` queue, WebSocket push) |
| "(phase 2)" in a name | Not in the first release |

The Mermaid export (PNG/SVG/`.mmd`) draws persons, browsers and devices as plain boxes: read the type from
the `[Person]` / `[Container: ...]` line. The local Structurizr render (`structurizr local`) shows the
real shapes. The `room-status-events` queue is point-to-point, so it is named on the arrow, not drawn as a box.
LEGEND

log "Done: $OUT"
find "$OUT" -type f | sort | sed "s#^$ROOT/##"
