# HMMM to Full-Length

This folder contains the VMD/Tcl workflow for converting an HMMM membrane system
back to a full-length membrane representation.

## Required Files

Place your HMMM input files in this directory:

```text
<hmmm-system>.psf
<hmmm-system>.pdb
```

The workflow also expects:

```text
hmmm-to-fl-script.tcl
organic_solvent_removal.tcl
lipid_elongation.tcl
ring_piercing_solver.tcl
minimize_template.conf
toppar/
```

## Requirements

- VMD.
- NAMD available as `namd2`, or update the NAMD command in
  `ring_piercing_solver.tcl`.
- The VMD ring-piercing plugin required by the ring-piercing step.

## Run

```bash
vmd -dispdev text -e hmmm-to-fl-script.tcl
```

When prompted, enter the HMMM PSF and PDB filenames.

## Output

The final full-length output files are:

```text
PROT_FLMEMB.psf
PROT_FLMEMB.pdb
```

Intermediate folders such as `hmmm2fl_building/` and
`hmmm2fl_ringpiercing/` may be created during the run.

## Test Example

To run a prepared sample from the repository root:

```bash
bash membrane_conversion_example/scripts/run_hmmm_to_fl.sh
```
