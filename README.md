# Highly Mobile Membrane-Mimetic (HMMM) Conversion

This repository contains VMD/Tcl workflows for converting membrane systems
between full-length (FL) lipid representations and Highly Mobile
Membrane-Mimetic (HMMM) representations.

The repository includes:

- `fl-to-hmmm/`: converts a full-length membrane to HMMM.
- `hmmm_to_fl/`: converts an HMMM membrane back to full-length.
- `membrane_conversion_example/`: a runnable test system with sample PSF/PDB
  inputs, helper scripts, and validation checks.

## Requirements

- VMD with `psfgen`.
- Python 3 for validating the runnable example.
- For HMMM-to-FL: NAMD available as `namd2`.
- For HMMM-to-FL: the VMD ring-piercing plugin used by
  `ring_piercing_solver.tcl`.

If VMD is not available as `vmd`, set `VMD_BIN` when running the example:

```bash
VMD_BIN=/path/to/vmd bash membrane_conversion_example/scripts/run_fl_to_hmmm.sh
```

## Quick Start

Run the included example from the repository root:

```bash
bash membrane_conversion_example/scripts/run_fl_to_hmmm.sh
bash membrane_conversion_example/scripts/run_hmmm_to_fl.sh
```

Or run both:

```bash
bash membrane_conversion_example/scripts/run_all.sh
```

The example scripts create temporary output under:

```text
membrane_conversion_example/work/
```

This directory is ignored by Git.

## Repository Contents

```text
.
|-- fl-to-hmmm/
|   |-- fl-to-hmmm-script.tcl
|   |-- toppar/
|   `-- README.md
|-- hmmm_to_fl/
|   |-- hmmm-to-fl-script.tcl
|   |-- organic_solvent_removal.tcl
|   |-- lipid_elongation.tcl
|   |-- ring_piercing_solver.tcl
|   |-- minimize_template.conf
|   |-- toppar/
|   `-- README.md
`-- membrane_conversion_example/
    |-- input/
    |-- expected/
    |-- scripts/
    `-- README.md
```

## FL to HMMM

Place a full-length `.psf` and `.pdb` file in `fl-to-hmmm/`, then run:

```bash
cd fl-to-hmmm
vmd -dispdev text -e fl-to-hmmm-script.tcl
```

When prompted, provide your input PSF and PDB filenames. The output files are
written with the `hmmm-` prefix:

```text
hmmm-<input>.psf
hmmm-<input>.pdb
```

## HMMM to Full-Length

Place an HMMM `.psf` and `.pdb` file in `hmmm_to_fl/`, then run:

```bash
cd hmmm_to_fl
vmd -dispdev text -e hmmm-to-fl-script.tcl
```

The workflow removes organic solvent, elongates lipid tails, and resolves ring
piercing. The final output files are:

```text
PROT_FLMEMB.psf
PROT_FLMEMB.pdb
```

## Runnable Example

The `membrane_conversion_example/` folder contains a compact, real molecular
test case. It includes:

- Full-length sample input: `sample_full.psf` and `sample_full.pdb`.
- HMMM sample input: `sample_hmmm.psf` and `sample_hmmm.pdb`.
- Shell wrappers that copy the required scripts/topologies into a temporary
  work directory.
- A Python validator that checks atom counts and residue composition.

Expected validation summaries:

```text
fl_to_hmmm: validation passed
  PSF atoms: 24035
  PDB atoms: 24035

hmmm_to_fl: validation passed
  PSF atoms: 27044
  PDB atoms: 27044
```

The example runners copy topology files into `work/`; they do not rely on
symlinks.

## Notes

- The included sample PDB for the full-length input is a single frame extracted
  from a CHARMM-GUI/NAMD trajectory-style PDB to keep the repository small.
- The scripts expect CHARMM-style PSF/PDB files and topology/parameter files
  compatible with the provided `toppar/` folders.
- For new systems with modified lipids or custom parameters, update the relevant
  topology/parameter files and verify that `lipid_elongation.tcl` and
  `minimize_template.conf` can read them.

## Acknowledgments

The HMMM-to-FL workflow uses a ring-piercing resolution step based on the VMD
ring-piercing plugin workflow. See the plugin project for installation details:

https://github.com/dgozgulbas/RPplugin
