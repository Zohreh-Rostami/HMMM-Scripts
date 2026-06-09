# FL to HMMM

This folder contains VMD/Tcl scripts for converting full-length membrane
systems to HMMM membrane models. The scripts currently support standard
palmitoyl-oleoyl lipids, CHL1 (cholesterol), and PSM (palmitoyl
sphingomyelin).

## Required Files

Place your full-length input files in this directory:

```text
<system>.psf
<system>.pdb
```

The script also expects the included topology directory:

```text
toppar/
```

## Run

```bash
vmd -dispdev text -e fl-to-hmmm-script.tcl
```

When prompted, enter the PSF and PDB filenames.

## Output

For inputs named:

```text
sample_full.psf
sample_full.pdb
```

the script writes:

```text
hmmm-sample_full.psf
hmmm-sample_full.pdb
```

## Test Example

To run a prepared sample from the repository root:

```bash
bash examples/membrane_conversion/scripts/run_fl_to_hmmm.sh
```

## Acknowledgment

These scripts are adapted from the workflow and scripts described in Hasdemir et al. (2026), with modifications to support HMMM membrane to full-length conversion of PSM.

Reference: Hasdemir, H. S., Li, Y., Kelich, P., Wen, P.-C., & Tajkhorshid, E. (2026).
Characterization of membrane binding and protein–lipid interactions at the atomic level
with an accelerated HMMM model. In J. H. Kleinschmidt (Ed.), Lipid-Protein Interactions
(Methods in Molecular Biology, Vol. 3001). Humana, New York, NY.
https://doi.org/10.1007/978-1-0716-5054-7_1
