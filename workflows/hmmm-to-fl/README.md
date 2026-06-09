# HMMM to Full-Length

This folder contains VMD/Tcl scripts for converting HMMM systems back to
full-length membranes. The scripts currently support standard palmitoyl-oleoyl
lipids, CHL1 (cholesterol), and PSM (palmitoyl sphingomyelin).

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
bash examples/membrane_conversion/scripts/run_hmmm_to_fl.sh
```

## Acknowledgment

These scripts are adapted from the workflow and scripts described in Hasdemir et al. (2026), with modifications to support HMMM membrane to full-length conversion of PSM.

Reference: Hasdemir, H. S., Li, Y., Kelich, P., Wen, P.-C., & Tajkhorshid, E. (2026).
Characterization of membrane binding and protein–lipid interactions at the atomic level
with an accelerated HMMM model. In J. H. Kleinschmidt (Ed.), Lipid-Protein Interactions
(Methods in Molecular Biology, Vol. 3001). Humana, New York, NY.
https://doi.org/10.1007/978-1-0716-5054-7_1
