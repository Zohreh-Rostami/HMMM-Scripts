#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

"$SCRIPT_DIR/run_fl_to_hmmm.sh"
"$SCRIPT_DIR/run_hmmm_to_fl.sh"
