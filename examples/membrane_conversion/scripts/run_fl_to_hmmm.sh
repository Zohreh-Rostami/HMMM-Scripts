#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
EXAMPLE_DIR=$(cd "$SCRIPT_DIR/.." && pwd)
REPO_ROOT=$(cd "$EXAMPLE_DIR/../.." && pwd)
WORKDIR="$EXAMPLE_DIR/work/fl-to-hmmm"
VMD_BIN=${VMD_BIN:-vmd}

command -v "$VMD_BIN" >/dev/null 2>&1 || {
  echo "Error: VMD executable '$VMD_BIN' was not found in PATH." >&2
  echo "Set VMD_BIN=/path/to/vmd or add VMD to PATH." >&2
  exit 1
}

rm -rf "$WORKDIR"
mkdir -p "$WORKDIR"

cp "$REPO_ROOT/workflows/fl-to-hmmm/fl-to-hmmm-script.tcl" "$WORKDIR/"
cp "$EXAMPLE_DIR/input/full_length/sample_full.psf" "$WORKDIR/"
cp "$EXAMPLE_DIR/input/full_length/sample_full.pdb" "$WORKDIR/"
cp -R -L "$REPO_ROOT/workflows/fl-to-hmmm/toppar" "$WORKDIR/toppar"

(
  cd "$WORKDIR"
  printf "sample_full.psf\nsample_full.pdb\n" \
    | "$VMD_BIN" -dispdev text -e fl-to-hmmm-script.tcl > fl-to-hmmm.log 2>&1
)

for output in "$WORKDIR/hmmm-sample_full.psf" "$WORKDIR/hmmm-sample_full.pdb"; do
  if [[ ! -s "$output" ]]; then
    echo "Error: expected output was not created: $output" >&2
    echo "See log: $WORKDIR/fl-to-hmmm.log" >&2
    exit 1
  fi
done

echo "FL-to-HMMM example finished."
echo "Outputs: $WORKDIR/hmmm-sample_full.psf and $WORKDIR/hmmm-sample_full.pdb"
echo "Log: $WORKDIR/fl-to-hmmm.log"
