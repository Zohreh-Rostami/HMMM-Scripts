# Membrane Conversion Example

This example provides a real, runnable test system for the HMMM conversion
scripts:

1. Convert a full-length membrane system to HMMM.
2. Convert an HMMM system back to a full-length membrane.
3. Validate the generated files by atom counts and residue composition.

The full-length input PDB is a single frame extracted from a CHARMM-GUI/NAMD
trajectory-style PDB. This keeps the example small enough for GitHub while still
testing the real conversion workflow.

## Included Files

```text
membrane_conversion_example/
|-- input/
|   |-- full_length/
|   |   |-- sample_full.psf
|   |   `-- sample_full.pdb
|   `-- hmmm/
|       |-- sample_hmmm.psf
|       `-- sample_hmmm.pdb
|-- expected/
|   `-- summary.json
|-- scripts/
|   |-- run_fl_to_hmmm.sh
|   |-- run_hmmm_to_fl.sh
|   |-- run_all.sh
|   `-- validate_conversion.py
`-- README.md
```

The example reuses the topology folders already included in the repository:

```text
fl-to-hmmm/toppar/
hmmm_to_fl/toppar/
```

The run scripts copy these topology folders into the temporary `work/`
directory; they do not create symlinks.

## Requirements

- VMD available as `vmd`.
- Python 3 for validation.
- For HMMM-to-FL only: NAMD available as `namd2`.
- For HMMM-to-FL only: the VMD ring-piercing plugin required by
  `ring_piercing_solver.tcl`.

If VMD is installed under a different name or path, set `VMD_BIN`:

```bash
VMD_BIN=/path/to/vmd bash membrane_conversion_example/scripts/run_fl_to_hmmm.sh
```

## Run FL to HMMM

From the repository root:

```bash
bash membrane_conversion_example/scripts/run_fl_to_hmmm.sh
```

The runner creates a clean working directory at:

```text
membrane_conversion_example/work/fl-to-hmmm/
```

Expected outputs:

```text
hmmm-sample_full.psf
hmmm-sample_full.pdb
fl-to-hmmm.log
```

The validation step should report:

```text
fl_to_hmmm: validation passed
  PSF atoms: 24035
  PDB atoms: 24035
```

## Run HMMM to Full-Length

From the repository root:

```bash
bash membrane_conversion_example/scripts/run_hmmm_to_fl.sh
```

The runner calls `organic_solvent_removal.tcl`, `lipid_elongation.tcl`, and
`ring_piercing_solver.tcl` directly. This follows the same sequence as
`hmmm-to-fl-script.tcl`, but keeps automated input and logs cleaner for testing.

The runner creates a clean working directory at:

```text
membrane_conversion_example/work/hmmm_to_fl/
```

Expected outputs:

```text
PROT_FLMEMB.psf
PROT_FLMEMB.pdb
organic_solvent_removal.log
lipid_elongation.log
ring_piercing_solver.log
```

The validation step should report:

```text
hmmm_to_fl: validation passed
  PSF atoms: 27044
  PDB atoms: 27044
```

## Run Both Tests

```bash
bash membrane_conversion_example/scripts/run_all.sh
```

The HMMM-to-FL test can take longer because it runs the NAMD minimization step
used by the ring-piercing solver.

## Manual Commands

The helper scripts prepare isolated working folders and feed the prompts
automatically. To run the same inputs manually, copy the relevant sample PSF/PDB
files into `fl-to-hmmm/` or `hmmm_to_fl/` and run:

```bash
vmd -dispdev text -e fl-to-hmmm-script.tcl
```

or:

```bash
vmd -dispdev text -e hmmm-to-fl-script.tcl
```

## Suggested Main README Entry

Add this short section to the repository-level README:

````markdown
## Example

A runnable membrane conversion example is available in
`membrane_conversion_example/`. It includes small PSF/PDB input files, helper
scripts for FL-to-HMMM and HMMM-to-FL conversion, and a validation script for
checking the generated structures.

```bash
bash membrane_conversion_example/scripts/run_fl_to_hmmm.sh
bash membrane_conversion_example/scripts/run_hmmm_to_fl.sh
```
````
