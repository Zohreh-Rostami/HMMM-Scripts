# FL to HMMM

This folder contains the VMD/Tcl workflow for converting a full-length membrane
system to an HMMM membrane representation.

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
bash membrane_conversion_example/scripts/run_fl_to_hmmm.sh
```
