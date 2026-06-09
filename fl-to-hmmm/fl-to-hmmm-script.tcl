# Modified by Zohreh Rostami on Sep 23, 2025


package require psfgen

set parampath toppar 
topology $parampath/top_scs.top
topology $parampath/patches6.top
topology $parampath/top_all36_lipid.rtf
topology $parampath/top_all36_cgenff.rtf
topology $parampath/top_all36_prot.rtf
topology $parampath/toppar_all36_lipid_hmmm.str
topology $parampath/toppar_all36_lipid_cholesterol.str
topology $parampath/toppar_water_ions_namd.str
topology $parampath/toppar_all36_prot_na_combined.str
topology $parampath/toppar_all36_lipid_sphingo.str
topology $parampath/toppar_all36_lipid_inositol.str



#Algorithm goes like this:
#Find the C26 and C36 atoms in every molecule
#-Apply a patch to retype them and their substituents
#-Delete all atoms lower in the chain
#	-Store the locations of carbon atoms
#Use the stored carbon atom locations to generate solvent positions

proc hmmmize {psf pdb solvent {scalefactor 1}} {
	set mid [mol load psf $psf pdb $pdb]
	#Sphingomyelin
	set sel [atomselect $mid "segname MEMB and ((name \"C\[2-3\]6\" and not resname CHL1) or (name \"C6\[FS\]\" and not resname CHL1))"]
	puts [$sel num]
	resetpsf
	readpsf $psf pdb $pdb 
	#coordpdb $pdb
	set coordlist [list ]
	#Make sure psfgen shuts up. Or at the very least only writes to the terminal.
	set cmd [interp alias {} ::puts]
	if {($cmd != {}) && [string equal $cmd ::tkcon_puts] } {
		interp alias {} ::puts {} ::tkcon_tcl_puts
	}
	foreach idx [$sel get index] {
		set atomsel [atomselect $mid "index $idx"]
		set sixfinder [atomselect $mid "index [lindex [$atomsel getbonds] 0]"]
		set sixindex [lindex [$sixfinder get index] [lsearch -all -regexp [$sixfinder get name] {C(?:27|37|7S|7F)}]]
		
		if {[$atomsel get name] == "C26"} {
			patch C26T "[$atomsel get segname]:[$atomsel get resid]"
		
		} elseif {[$atomsel get name] == "C36"} {
			patch C36T "[$atomsel get segname]:[$atomsel get resid]"
			
                } elseif {[$atomsel get name] == "C6S"} {
                        patch C6ST "[$atomsel get segname]:[$atomsel get resid]"

                } elseif {[$atomsel get name] == "C6F"} {
                        patch C6FT "[$atomsel get segname]:[$atomsel get resid]"

		} else {
			puts "Equality doesn't mean what I think it does."
		}
		
		lappend coordlist [crawl $mid $sixindex $idx]
		
		$sixfinder delete
		$atomsel delete
	}
	
	set carbonsremoved 0
	foreach acylchain $coordlist {
		incr carbonsremoved [llength $acylchain]
	}
	#exit
	puts "$carbonsremoved carbons removed"
	set carbonsremoved [expr {$scalefactor * $carbonsremoved}]
	#Need to regenerate solvents. Ratio of volume per CH2 is ~7:3 (DCLE:acyl)
	if {$solvent == 0} {
		set numdcle [expr { 3 * $carbonsremoved / 14}]
		puts "Adding $numdcle DCLE molecules to replace them."
		for {set i 0} {[expr {$i * 1000000}] < $numdcle} { incr i } {
			set segname HMM$i
			puts $segname
			segment $segname {
				for {set j 0} {[expr {($i * 1000000) + $j}] < $numdcle} {incr j} {
					residue $j DCLE
				}
			}
			for {set j 0} {[expr {$i * 1000000 + $j}] < $numdcle} {incr j} {
				set coords [lvarpop coordlist]
				set cordlen [llength $coords]
				if {$cordlen == 1} { #Place the DCLE according to the COM. Bond length equilibrium distance is 1.5 Angstroms.
					set rvec [vecscale 0.75 [randomunitvector]]
					set xyz [lvarpop coords]
					set xyz1 [vecadd $xyz $rvec]
					set xyz2 [vecsub $xyz $rvec]
				} else {
					set k [expr {int(rand()*($cordlen/2))}]
					set xyz1 [lindex $coords [expr {2*$k}]]
					set xyz2 [lindex $coords [expr {(2*$k)+1}]]
					set coords [lreplace $coords [expr {2*$k}] [expr {(2*$k)+1}]]
				}
				coord $segname $j C1 $xyz1
				coord $segname $j C2 $xyz2
				set rvec [randomunitvector]
				set v [vecnorm [vecsub $xyz1 $xyz2]] ;#V is the vector from C2 to C1
				set w [vecnorm [veccross $v $rvec]]
				set vrot [vecadd [vecscale -0.333807 $v] [vecscale 0.942641 [veccross $w $v]]]
				coord $segname $j CL11 [vecadd $xyz1 $vrot]
				if {[llength $coords] > 0} {
					lappend coordlist $coords
				}
			}
		}
	} elseif {$solvent == 1} { #SCSE
		set numscs [expr { $carbonsremoved / 2}]
		puts "Adding $numscs SCSE molecules to replace them."
		for {set i 0} {[expr {$i * 1000000}] < $numscs} { incr i } {
			set segname HMM$i
			puts $segname
			segment $segname {
				for {set j 0} {[expr {$i * 1000000 + $j}] < [expr { min($numscs, ($i + 1) * 1000000)}]} {incr j} {
					residue $j SCSE
				}
			}
			for {set j 0} {[expr {$i * 1000000 + $j}] < [expr { min($numscs, ($i + 1) * 1000000)}]} {incr j} {
				set coords [lvarpop coordlist]
				set cordlen [llength $coords]
				if {$cordlen == 1} {
					set rvec [vecscale 0.75 [randomunitvector]]
					set xyz [lvarpop coords]
					set xyz1 [vecadd $xyz $rvec]
					set xyz2 [vecsub $xyz $rvec]
				} else {
					set k [expr {int(rand()*($cordlen/2))}]
					set xyz1 [lindex $coords [expr {2*$k}]]
					set xyz2 [lindex $coords [expr {(2*$k)+1}]]
					set coords [lreplace $coords [expr {2*$k}] [expr {(2*$k)+1}]]
				}
				coord $segname $j C1 $xyz1
				coord $segname $j C2 $xyz2
				if {[llength $coords] > 0} {
					lappend coordlist $coords
				}
			}
		}
	} elseif {$solvent == 2} { #SCSM
		set numscs [expr { $carbonsremoved}]
		puts "Adding $numscs SCSM molecules to replace them."
		for {set i 0} {[expr {$i * 1000000}] < $numscs} { incr i } {
			set segname HMM$i
			puts $segname
			segment $segname {
				for {set j 0} {[expr {($i * 1000000) + $j}] < $numscs} {incr j} {
					residue $j SCSM
				}
			}
			for {set j 0} {[expr {$i * 1000000 + $j}] < $numscs} {incr j} {
				set coords [lvarpop coordlist]
				set cordlen [llength $coords]
				set k [expr {int(rand()*($cordlen))}]
				set xyz1 [lindex $coords $k]
				set coords [lreplace $coords $k $k]
				coord $segname $j C $xyz1
				if {[llength $coords] > 0} {
					lappend coordlist $coords
				}
			}
		}
	}
	$sel delete
	mol delete $mid
	regenerate angles dihedrals
	guesscoord
	#Revert where things get written to.
	if {($cmd != {}) } {
		interp alias {} ::puts {} $cmd
	}
	
	#set hmmmtype {DCLE SCSE SCSM}
	#writepsf hmmm-[lindex $hmmmtype [expr $solvent]]-[file tail $psf]
	#writepdb hmmm-[lindex $hmmmtype [expr $solvent]]-[file tail $pdb]
	writepsf hmmm-[file tail $psf]
	writepdb hmmm-[file tail $pdb]
}

#Traverses the acyl tails, deleting atoms as it goes.
proc crawl {molid index previd} {
	set centeratom [atomselect $molid "index $index"]
	set xyz [lindex [$centeratom get {x y z}] 0]
	set bondlist [lindex [$centeratom getbonds] 0]
	#Remove the atom from where we came already.
	set posn [lsearch -exact $bondlist $previd]
 	set bondlist [lreplace $bondlist $posn $posn]
 	
	foreach atomindex $bondlist {
 		set atom [atomselect $molid "index $atomindex"]
		#Are we going forward?

		if {[string match "C\[2-3\]\[0-9\]*" [$atom get name]]} {
			set xyzlist [crawl $molid $atomindex $index]

		#Sphingomyelin		
		} elseif {[regexp {C[0-9]{1,2}[FS]*} [$atom get name]]} {
                        set xyzlist [crawl $molid $atomindex $index]
		} else {
			#Line that actually does the deleting.
			delatom [$atom get segname] [$atom get resid] [$atom get name]
		}
		$atom delete
 	}
 	delatom [$centeratom get segname] [$centeratom get resid] [$centeratom get name]
 	if {[info exists xyzlist]} {
 		lappend xyzlist $xyz
 	} else {
 		set xyzlist [list $xyz]
 	}
 	return $xyzlist
}

proc randomunitvector {} {
	set vec [list [expr {2.0 * rand() - 1}] [expr {2.0 * rand() - 1}] [expr {2.0 * rand() - 1}]]
	while {[veclength $vec] > 1.0} {
		set vec [list [expr {2.0 * rand() - 1}] [expr {2.0 * rand() - 1}] [expr {2.0 * rand() - 1}]]
	}
	return [vecnorm $vec] 
}

################################# Added By Zohreh #####################################
#######################################################################################
####                              Prompt Function                                  ####
#######################################################################################
# Prompt for psf file
proc psfinput {prompt} {
  # Start an infinite loop to repeatedly prompt for valid input
  while 1 {
     # Print the prompt without a newline to keep user input on the same line
    puts -nonewline "${prompt}: "
    flush stdout; # Flush the output buffer to ensure the prompt appears immediately
        
    # Read a line of input from stdin
    if {[gets stdin line] < 0 && [eof stdin]} {
      return -code error "end of file detected"; # If end-of-file (EOF) is detected, return an error with a message
    } elseif {$line eq ""} {
      puts "Input cannot be empty. Please try again."; # If the input is empty, prompt the user to re-enter a valid value
    } else {
      if {[file exists $line]} {
        return $line; # If the input is valid and exists, return the input
      } else {
        puts "Error: File '$line' does not exist. Please enter a valid file path."; # If the file does not exist, display an error and re-prompt the user
      }
    }
  }
}

# Prompt for pdb file
proc pdbinput {prompt} {
  # Start an infinite loop to repeatedly prompt for valid input
  while 1 {
     # Print the prompt without a newline to keep user input on the same line
    puts -nonewline "${prompt}: "
    flush stdout; # Flush the output buffer to ensure the prompt appears immediately

    # Read a line of input from stdin
    if {[gets stdin line] < 0 && [eof stdin]} {
      return -code error "end of file detected"; # If end-of-file (EOF) is detected, return an error with a message
    } elseif {$line eq ""} {
      puts "Input cannot be empty. Please try again."; # If the input is empty, prompt the user to re-enter a valid value
    } else {
      if {[file exists $line]} {
        return $line; # If the input is valid and exists, return the input
      } else {
        puts "Error: File '$line' does not exist. Please enter a valid file path."; # If the file does not exist, display an error and re-prompt the user
      }
    }
  }
}

#######################################################################################
####                            Script Execution                                   ####
#######################################################################################
# Get the input file paths from the user.
set psf_file [psfinput "Enter your psf file"]
set pdb_file [pdbinput "Enter your pdb file"]

# Now, call the hmmmize procedure with the obtained file paths.
hmmmize $psf_file $pdb_file 1

exit
