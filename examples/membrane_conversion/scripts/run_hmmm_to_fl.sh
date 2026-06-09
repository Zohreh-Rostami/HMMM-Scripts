#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
EXAMPLE_DIR=$(cd "$SCRIPT_DIR/.." && pwd)
REPO_ROOT=$(cd "$EXAMPLE_DIR/../.." && pwd)
WORKDIR="$EXAMPLE_DIR/work/hmmm_to_fl"
VMD_BIN=${VMD_BIN:-vmd}
NAMD_BIN=${NAMD_BIN:-namd}

command -v "$VMD_BIN" >/dev/null 2>&1 || {
  echo "Error: VMD executable '$VMD_BIN' was not found in PATH." >&2
  echo "Set VMD_BIN=/path/to/vmd or add VMD to PATH." >&2
  exit 1
}

if [[ ! -x "$NAMD_BIN" ]] && ! command -v "$NAMD_BIN" >/dev/null 2>&1; then
  echo "Error: NAMD executable '$NAMD_BIN' was not found." >&2
  echo "Set NAMD_BIN=/path/to/namd or add NAMD to PATH." >&2
  exit 1
fi
export NAMD_BIN

rm -rf "$WORKDIR"
mkdir -p "$WORKDIR"

cp "$REPO_ROOT/workflows/hmmm-to-fl/"*.tcl "$WORKDIR/"
cp "$REPO_ROOT/workflows/hmmm-to-fl/minimize_template.conf" "$WORKDIR/"
cp "$EXAMPLE_DIR/input/hmmm/sample_hmmm.psf" "$WORKDIR/"
cp "$EXAMPLE_DIR/input/hmmm/sample_hmmm.pdb" "$WORKDIR/"
cp -R -L "$REPO_ROOT/workflows/hmmm-to-fl/toppar" "$WORKDIR/toppar"

(
  cd "$WORKDIR"
  printf "sample_hmmm.psf\nsample_hmmm.pdb\n" \
    | "$VMD_BIN" -dispdev text -e organic_solvent_removal.tcl > organic_solvent_removal.log 2>&1

  "$VMD_BIN" -dispdev text -e lipid_elongation.tcl > lipid_elongation.log 2>&1
  "$VMD_BIN" -dispdev text -e ring_piercing_solver.tcl > ring_piercing_solver.log 2>&1
)

for output in "$WORKDIR/PROT_FLMEMB.psf" "$WORKDIR/PROT_FLMEMB.pdb"; do
  if [[ ! -s "$output" ]]; then
    echo "Error: expected output was not created: $output" >&2
    echo "See logs in: $WORKDIR" >&2
    exit 1
  fi
done

echo "HMMM-to-FL example finished."
echo "Outputs: $WORKDIR/PROT_FLMEMB.psf and $WORKDIR/PROT_FLMEMB.pdb"
echo "Logs: $WORKDIR/organic_solvent_removal.log, $WORKDIR/lipid_elongation.log, $WORKDIR/ring_piercing_solver.log"
