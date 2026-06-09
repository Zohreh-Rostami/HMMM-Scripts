#######################################################################################
#### This script converts HMMMM back to full-length (FL) membrane including:       ####
#### 1. Remove all the organic solvent molecules in the membrane core              ####
#### 2.1 Manually set the coordinates of the 7th/8th carbon on each tail           ####
#### 2.2 Further extend the tails to their FL forms by PSFGEN                      ####
#### 3. Detect and resolve any ring piercing                                       ####
#### The script was originally developed by Dr. Defne Gorgun Ozgulbas and modified ####
#### by Yupeng Li, both from Dr. Emad Tajkhorshid's group                          ####
#######################################################################################

echo "*************************************************"
echo "** Remove the organic solvent from the system! **"
echo "*************************************************"
vmd -dispdev text -e organic_solvent_removal.tcl
wait

echo "*************************************************"
echo "**          Elongate HMMM lipid tails!         **"
echo "*************************************************"
vmd -dispdev text -e lipid_elongation.tcl
wait

echo "*************************************************"
echo "**            Resolve ring piercing!           **"
echo "*************************************************"
vmd -dispdev text -e ring_piercing_solver.tcl

echo "***************************************************************"
echo "** DONE. You can start simulations using PROT_FLMEMB.psf/pdb **"
echo "***************************************************************"
exit
