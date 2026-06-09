# Membrane Conversion Example

This folder contains a real, runnable test system for the HMMM conversion
workflows.

It tests:

1. Full-length membrane to HMMM conversion.
2. HMMM membrane to full-length conversion.
3. Creation of output PSF/PDB files that can be compared with tracked
   reference outputs.

The full-length input PDB is a single frame extracted from a CHARMM-GUI/NAMD
trajectory-style PDB. This keeps the example compact while still testing the
real conversion scripts.

## Folder Contents

```text
examples/membrane_conversion/
|-- expected_outputs/
|   |-- fl-to-hmmm/
|   |   |-- hmmm-sample_full.psf
|   |   `-- hmmm-sample_full.pdb
|   `-- hmmm-to-fl/
|       |-- PROT_FLMEMB.psf
|       `-- PROT_FLMEMB.pdb
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
- For HMMM-to-FL only: NAMD available as `namd`, or set `NAMD_BIN` to the
  executable on your system.
- For HMMM-to-FL only: the VMD ring-piercing plugin required by
  `ring_piercing_solver.tcl`. Install it from
  https://github.com/dgozgulbas/RPplugin?tab=readme-ov-file.

If VMD is installed under a different command/path, set `VMD_BIN`:

```bash
VMD_BIN=/path/to/vmd bash examples/membrane_conversion/scripts/run_fl_to_hmmm.sh
```

If your NAMD executable is not named `namd`, set `NAMD_BIN`. For example:

```bash
NAMD_BIN=/path/to/namd bash examples/membrane_conversion/scripts/run_hmmm_to_fl.sh
```

## Run FL to HMMM

From the repository root:

```bash
bash examples/membrane_conversion/scripts/run_fl_to_hmmm.sh
```

Generated outputs are written under:

```text
examples/membrane_conversion/work/fl-to-hmmm/
```

Reference outputs are stored under:

```text
examples/membrane_conversion/expected_outputs/fl-to-hmmm/
```

Files:

```text
hmmm-sample_full.psf
hmmm-sample_full.pdb
```

## Run HMMM to Full-Length

From the repository root:

```bash
bash examples/membrane_conversion/scripts/run_hmmm_to_fl.sh
```

Generated outputs are written under:

```text
examples/membrane_conversion/work/hmmm_to_fl/
```

Reference outputs are stored under:

```text
examples/membrane_conversion/expected_outputs/hmmm-to-fl/
```

Files:

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

To compare against the reference outputs, use `diff -q` on the generated and
reference PSF/PDB files. For example:

```bash
diff -q examples/membrane_conversion/work/fl-to-hmmm/hmmm-sample_full.psf \
  examples/membrane_conversion/expected_outputs/fl-to-hmmm/hmmm-sample_full.psf
```

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
