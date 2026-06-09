# Workflows

This folder contains the conversion scripts and topology files.

## Contents

```text
workflows/
|-- fl-to-hmmm/
|   |-- fl-to-hmmm-script.tcl
|   `-- toppar/
`-- hmmm-to-fl/
    |-- hmmm-to-fl-script.tcl
    |-- organic_solvent_removal.tcl
    |-- lipid_elongation.tcl
    |-- ring_piercing_solver.tcl
    |-- minimize_template.conf
    `-- toppar/
```

Use `fl-to-hmmm/` for full-length to HMMM conversion and `hmmm-to-fl/` for
HMMM to full-length conversion.

For a runnable test system, run this from the repository root:

```bash
bash examples/membrane_conversion/scripts/run_all.sh
```

## Acknowledgment

These scripts are adapted from the workflow and scripts described in Hasdemir et al. (2026), with modifications to support HMMM membrane to full-length conversion of PSM.

Reference: Hasdemir, H. S., Li, Y., Kelich, P., Wen, P.-C., & Tajkhorshid, E. (2026).
Characterization of membrane binding and protein–lipid interactions at the atomic level
with an accelerated HMMM model. In J. H. Kleinschmidt (Ed.), Lipid-Protein Interactions
(Methods in Molecular Biology, Vol. 3001). Humana, New York, NY.
https://doi.org/10.1007/978-1-0716-5054-7_1
