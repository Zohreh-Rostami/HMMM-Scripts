#!/usr/bin/env python3
"""Validate example conversion outputs by atom and residue counts."""

import argparse
import json
from collections import Counter
from pathlib import Path
from typing import Any, Dict, List, Tuple


EXAMPLE_DIR = Path(__file__).resolve().parents[1]
EXPECTED_FILE = EXAMPLE_DIR / "expected" / "summary.json"


def psf_atom_count(path: Path) -> int:
    with path.open("r", encoding="utf-8", errors="replace") as handle:
        for line in handle:
            if "!NATOM" in line:
                return int(line.split()[0])
    raise ValueError(f"Could not find !NATOM record in {path}")


def pdb_summary(path: Path) -> Tuple[int, Counter]:
    atoms = 0
    residues = Counter()

    with path.open("r", encoding="utf-8", errors="replace") as handle:
        for line in handle:
            if line.startswith(("ATOM", "HETATM")):
                atoms += 1
                residues[line[17:21].strip()] += 1

    return atoms, residues


def load_expected(mode: str) -> Dict[str, Any]:
    with EXPECTED_FILE.open("r", encoding="utf-8") as handle:
        expected = json.load(handle)
    return expected[mode]


def output_paths(mode: str, workdir: Path) -> Tuple[Path, Path]:
    if mode == "fl_to_hmmm":
        return workdir / "hmmm-sample_full.psf", workdir / "hmmm-sample_full.pdb"
    if mode == "hmmm_to_fl":
        return workdir / "PROT_FLMEMB.psf", workdir / "PROT_FLMEMB.pdb"
    raise ValueError(f"Unsupported mode: {mode}")


def validate(mode: str, workdir: Path) -> None:
    expected = load_expected(mode)
    psf_path, pdb_path = output_paths(mode, workdir)

    missing = [str(path) for path in (psf_path, pdb_path) if not path.exists()]
    if missing:
        raise SystemExit("Missing expected output file(s): " + ", ".join(missing))

    psf_atoms = psf_atom_count(psf_path)
    pdb_atoms, residues = pdb_summary(pdb_path)

    failures = []  # type: List[str]

    if psf_atoms != expected["psf_atoms"]:
        failures.append(f"PSF atom count: expected {expected['psf_atoms']}, got {psf_atoms}")

    if pdb_atoms != expected["pdb_atoms"]:
        failures.append(f"PDB atom count: expected {expected['pdb_atoms']}, got {pdb_atoms}")

    expected_residues = expected["residue_atom_counts"]
    observed_residues = dict(sorted(residues.items()))
    if observed_residues != expected_residues:
        failures.append("Residue atom counts differ from expected summary")

    for residue in expected.get("required_residues", []):
        if residues[residue] == 0:
            failures.append(f"Required residue {residue} was not found")

    for residue in expected.get("absent_residues", []):
        if residues[residue] != 0:
            failures.append(f"Residue {residue} should be absent but has {residues[residue]} atoms")

    if failures:
        print("Validation failed:")
        for failure in failures:
            print(f"  - {failure}")
        print("\nObserved residue atom counts:")
        print(json.dumps(observed_residues, indent=2))
        raise SystemExit(1)

    print(f"{mode}: validation passed")
    print(f"  PSF atoms: {psf_atoms}")
    print(f"  PDB atoms: {pdb_atoms}")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("mode", choices=["fl_to_hmmm", "hmmm_to_fl"])
    parser.add_argument("workdir", type=Path, help="Directory containing conversion outputs")
    args = parser.parse_args()

    validate(args.mode, args.workdir.resolve())


if __name__ == "__main__":
    main()
