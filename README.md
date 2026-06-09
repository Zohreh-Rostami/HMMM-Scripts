# Highly Mobile Membrane-Mimetic (HMMM) Conversion

VMD/Tcl workflows for converting membrane systems between full-length (FL)
lipid representations and Highly Mobile Membrane-Mimetic (HMMM)
representations.

The repository is organized around two things:

- `workflows/`: the conversion scripts and topology files.
- `examples/`: runnable sample systems and validation helpers.

## Start Here

Run the included membrane conversion example from the repository root:

```bash
bash examples/membrane_conversion/scripts/run_all.sh
```

This runs:

1. Full-length to HMMM conversion.
2. HMMM to full-length conversion.
3. Validation of the generated PSF/PDB files.

Expected validation summary:

```text
fl_to_hmmm: validation passed
  PSF atoms: 24035
  PDB atoms: 24035
hmmm_to_fl: validation passed
  PSF atoms: 27044
  PDB atoms: 27044
```

## Requirements

- VMD with `psfgen`.
- Python 3 for validation.
- For HMMM-to-FL: NAMD available as `namd2`.
- For HMMM-to-FL: the VMD ring-piercing plugin used by
  `ring_piercing_solver.tcl`.

If VMD is installed under a different command/path, set `VMD_BIN`:

```bash
VMD_BIN=/path/to/vmd bash examples/membrane_conversion/scripts/run_fl_to_hmmm.sh
```

## Repository Layout

```text
.
|-- README.md
|-- LICENSE
|-- workflows/
|   |-- README.md
|   |-- fl-to-hmmm/
|   |   |-- README.md
|   |   |-- fl-to-hmmm-script.tcl
|   |   `-- toppar/
|   `-- hmmm-to-fl/
|       |-- README.md
|       |-- hmmm-to-fl-script.tcl
|       |-- organic_solvent_removal.tcl
|       |-- lipid_elongation.tcl
|       |-- ring_piercing_solver.tcl
|       |-- minimize_template.conf
|       `-- toppar/
`-- examples/
    |-- README.md
    `-- membrane_conversion/
        |-- README.md
        |-- input/
        |-- expected/
        `-- scripts/
```

## Workflows

### FL to HMMM

Use `workflows/fl-to-hmmm/` to convert a full-length membrane to HMMM.

```bash
cd workflows/fl-to-hmmm
vmd -dispdev text -e fl-to-hmmm-script.tcl
```

When prompted, provide your input PSF and PDB filenames. The output files are
written with the `hmmm-` prefix.

### HMMM to Full-Length

Use `workflows/hmmm-to-fl/` to convert an HMMM membrane back to full-length.

```bash
cd workflows/hmmm-to-fl
vmd -dispdev text -e hmmm-to-fl-script.tcl
```

The final full-length output files are:

```text
PROT_FLMEMB.psf
PROT_FLMEMB.pdb
```

## Runnable Example

The example in `examples/membrane_conversion/` includes compact real PSF/PDB
inputs and automated checks:

```bash
bash examples/membrane_conversion/scripts/run_fl_to_hmmm.sh
bash examples/membrane_conversion/scripts/run_hmmm_to_fl.sh
```

The example scripts copy workflow files and topology files into
`examples/membrane_conversion/work/`; they do not use symlinks. The `work/`
directory is ignored by Git.

## License

This project is distributed under the MIT License. See `LICENSE`.

## Acknowledgment

These scripts are adapted from the workflow and scripts described in Hasdemir et al. (2026), with modifications to support HMMM membrane to full-length conversion of PSM.

Reference: Hasdemir, H. S., Li, Y., Kelich, P., Wen, P.-C., & Tajkhorshid, E. (2026).
Characterization of membrane binding and protein–lipid interactions at the atomic level
with an accelerated HMMM model. In J. H. Kleinschmidt (Ed.), Lipid-Protein Interactions
(Methods in Molecular Biology, Vol. 3001). Humana, New York, NY.
https://doi.org/10.1007/978-1-0716-5054-7_1
