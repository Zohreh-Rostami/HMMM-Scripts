# Membrane Conversion Example

This folder contains a real, runnable test system for the HMMM conversion
workflows.

It tests:

1. Full-length membrane to HMMM conversion.
2. HMMM membrane to full-length conversion.
3. Creation of expected output PSF/PDB files.

The full-length input PDB is a single frame extracted from a CHARMM-GUI/NAMD
trajectory-style PDB. This keeps the example compact while still testing the
real conversion scripts.

## Folder Contents

```text
examples/membrane_conversion/
|-- input/
|   |-- full_length/
|   |   |-- sample_full.psf
|   |   `-- sample_full.pdb
|   `-- hmmm/
|       |-- sample_hmmm.psf
|       `-- sample_hmmm.pdb
|-- scripts/
|   |-- run_fl_to_hmmm.sh
|   |-- run_hmmm_to_fl.sh
|   `-- run_all.sh
`-- README.md
```

## Requirements

- VMD available as `vmd`.
- For HMMM-to-FL only: NAMD available as `namd`.
- For HMMM-to-FL only: the VMD ring-piercing plugin required by
  `ring_piercing_solver.tcl`.

If VMD is installed under a different command/path, set `VMD_BIN`:

```bash
VMD_BIN=/path/to/vmd bash examples/membrane_conversion/scripts/run_fl_to_hmmm.sh
```

If your NAMD executable is not named `namd`, set `NAMD_BIN`. For example:

```bash
NAMD_BIN=/Projects/dhardy/namd_builds/NAMD_3.1alpha3_Linux-x86_64-netlrts-smp-CUDA/namd3 \
  bash examples/membrane_conversion/scripts/run_hmmm_to_fl.sh
```

## Run FL to HMMM

From the repository root:

```bash
bash examples/membrane_conversion/scripts/run_fl_to_hmmm.sh
```

Expected outputs are written under:

```text
examples/membrane_conversion/work/fl-to-hmmm/
```

Expected outputs:

```text
hmmm-sample_full.psf
hmmm-sample_full.pdb
```

## Run HMMM to Full-Length

From the repository root:

```bash
bash examples/membrane_conversion/scripts/run_hmmm_to_fl.sh
```

Expected outputs are written under:

```text
examples/membrane_conversion/work/hmmm_to_fl/
```

Expected outputs:

```text
PROT_FLMEMB.psf
PROT_FLMEMB.pdb
```

## Run Both

```bash
bash examples/membrane_conversion/scripts/run_all.sh
```

The HMMM-to-FL step can take longer because it runs the NAMD minimization used
by the ring-piercing solver.

## Manual Use

To run manually, copy the sample PSF/PDB files into the relevant workflow folder
and run VMD there:

```bash
cd workflows/fl-to-hmmm
vmd -dispdev text -e fl-to-hmmm-script.tcl
```

or:

```bash
cd workflows/hmmm-to-fl
vmd -dispdev text -e hmmm-to-fl-script.tcl
```

## Acknowledgment

These scripts are adapted from the workflow and scripts described in Hasdemir et al. (2026), with modifications to support HMMM membrane to full-length conversion of PSM.

Reference: Hasdemir, H. S., Li, Y., Kelich, P., Wen, P.-C., & Tajkhorshid, E. (2026).
Characterization of membrane binding and protein–lipid interactions at the atomic level
with an accelerated HMMM model. In J. H. Kleinschmidt (Ed.), Lipid-Protein Interactions
(Methods in Molecular Biology, Vol. 3001). Humana, New York, NY.
https://doi.org/10.1007/978-1-0716-5054-7_1
