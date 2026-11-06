#!/usr/bin/env bash
# Render gallery pieces with pscat, lint each one, and record how long it took.
#
#   scripts/render.sh                         # every gallery/*.ps
#   scripts/render.sh gallery/great_wave.ps   # just these
#   DPI=144 scripts/render.sh                 # higher resolution (default 72)
#   scripts/render.sh -D Seed=4 gallery/great_wave.ps
#                                             # predefine /Seed 4 (pieces opt in
#                                             # with `/Name where { pop } {...} ifelse`)
#   scripts/render.sh --sweep-seed 1:9 gallery/great_wave.ps
#                                             # pscat's seed sweep: frames plus a
#                                             # contact sheet, <name>-sweep.png
#                                             # (frames <name>-frame-NNN.png)
#
# Output goes to $KW_RENDERS (default renders/, git-ignored) as <name>.png, and
# timings are appended to timings.tsv there. Point KW_RENDERS at roomy storage,
# e.g. KW_RENDERS=/Volumes/YOTUO/dev-cache/kanagawa_wave/renders.
# The page size comes from the piece's %%BoundingBox (default 612x792).
# Lint is strict: a stack or gsave leak fails the run. Exits nonzero on any error.
set -euo pipefail

main() {
root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"   # pieces load (lib/...) relative to the repo root

dpi="${DPI:-72}"
out="${KW_RENDERS:-renders}"
mkdir -p "$out"

if ! command -v pscat >/dev/null 2>&1; then
  echo "render: pscat not found on PATH; see README.md" >&2
  exit 2
fi
want="$(cat .pscat-version)"
have="$(pscat --version | awk '{print $2}')"
[ "$have" = "$want" ] || echo "render: warning: pscat $have, but .pscat-version pins $want" >&2

# a repo lib/ file named like a built-in would shadow pscat's own
for f in lib/*.ps; do
  case "$(basename "$f")" in
    kw_*) ;;
    *) echo "render: $f: repo libraries must be named lib/kw_*.ps" >&2; exit 2 ;;
  esac
done

defs=() sweep=() files=()
while [ $# -gt 0 ]; do
  case "$1" in
    -D) defs+=("$2"); shift 2 ;;
    --sweep-seed) sweep=(--sweep-seed "$2"); shift 2 ;;
    -*) echo "render: unknown option $1" >&2; exit 2 ;;
    *) files+=("$1"); shift ;;
  esac
done
[ ${#files[@]} -gt 0 ] || files=(gallery/*.ps)

tmp="$(mktemp -d "${TMPDIR:-/tmp}/kw-render.XXXXXX")"
trap 'rm -rf "$tmp"' EXIT

status=0
for piece in "${files[@]}"; do
  name="$(basename "$piece" .ps)"
  page="$(awk '/^%%BoundingBox:/ { print $4-$2 "x" $5-$3; exit }' "$piece")"
  page="${page:-612x792}"
  # -D values go in a prelude that then runs the piece; without them the piece
  # runs directly, so error reports give its own line numbers (pscat reports
  # the top-level file's line: PSCatLabs/pscat#1043)
  prelude="$piece"
  if [ ${#defs[@]} -gt 0 ]; then
    prelude="$tmp/$name.ps"
    {
      echo "%!PS-Adobe-3.0"
      for d in "${defs[@]}"; do echo "/${d%%=*} ${d#*=} def"; done
      echo "($piece) run"
    } > "$prelude"
  fi
  if [ ${#sweep[@]} -gt 0 ]; then
    # frames land as <name>-frame-NNN.png
    target="$out/$name-sweep.png"
    args=("${sweep[@]}" --png "$out/$name-frame.png" --contact-sheet "$target")
  else
    target="$out/$name.png"
    args=(--lint-strict --png "$target")
  fi
  start=$(date +%s)
  if pscat --page "$page" --dpi "$dpi" "${args[@]}" "$prelude"; then
    secs=$(( $(date +%s) - start ))
    printf '%s\t%s\t%s\t%ss\t%s\n' "$(date -u +%FT%TZ)" "$name" "$dpi" "$secs" "${defs[*]-}" >> "$out/timings.tsv"
    echo "render: $name ${secs}s -> $target"
  else
    echo "render: $name FAILED" >&2
    status=1
  fi
done
exit $status
}

main "$@"
