#######################################################################################
#### This script converts HMMM back to full-length (FL) membrane including:       ####
#### 1. Remove all the organic solvent molecules in the membrane core              ####
#### 2.1 Manually set the coordinates of the 7th/8th carbon on each tail           ####
#### 2.2 Further extend the tails to their FL forms by PSFGEN                      ####
#### 3. Detect and resolve any ring piercing                                       ####
#### The script was originally developed by Dr. Defne Gorgun Ozgulbas and modified ####
#### by Yupeng Li and Zohreh Rostami, both from Dr. Emad Tajkhorshid's group       ####
#######################################################################################

proc input_existing_file {prompt} {
  while {1} {
    puts -nonewline "${prompt}: "
    flush stdout

    if {[gets stdin line] < 0 && [eof stdin]} {
      return -code error "end of file detected while reading input"
    }

    set line [string trim $line]
    if {$line eq ""} {
      puts "Input cannot be empty. Please try again."
    } elseif {[file exists $line]} {
      return $line
    } else {
      puts "Error: File '$line' does not exist. Please enter a valid file path."
    }
  }
}

proc resolve_vmd_executable {} {
  if {[info exists ::env(VMD_BIN)] && $::env(VMD_BIN) ne ""} {
    set candidate $::env(VMD_BIN)
  } else {
    set candidate vmd
  }

  if {[file executable $candidate] || [auto_execok $candidate] ne ""} {
    return $candidate
  }

  set current [info nameofexecutable]
  if {$current ne "" && [file executable $current]} {
    return $current
  }

  return -code error "VMD executable '$candidate' was not found. Set VMD_BIN=/path/to/vmd or add VMD to PATH."
}

proc run_vmd_step {vmdbin script logfile {input ""}} {
  if {![file exists $script]} {
    return -code error "Required script '$script' was not found."
  }

  puts "Running $script"
  set cmd [list $vmdbin -dispdev text -e $script]

  if {$input eq ""} {
    set status [catch {exec {*}$cmd > $logfile 2>@1} result options]
  } else {
    set status [catch {exec {*}$cmd << $input > $logfile 2>@1} result options]
  }

  if {$status != 0} {
    puts stderr "Error while running $script. See log: $logfile"
    return -options $options $result
  }
}

proc require_nonempty_file {path} {
  if {![file exists $path] || [file size $path] == 0} {
    return -code error "Expected output was not created: $path"
  }
}

set psffile [input_existing_file "Enter your psf file"]
set pdbfile [input_existing_file "Enter your pdb file"]
set vmdbin [resolve_vmd_executable]

file delete -force hmmm2fl_building hmmm2fl_ringpiercing

puts "*************************************************"
puts "** Remove the organic solvent from the system! **"
puts "*************************************************"
run_vmd_step $vmdbin organic_solvent_removal.tcl organic_solvent_removal.log "$psffile\n$pdbfile\n"

puts "*************************************************"
puts "**          Elongate HMMM lipid tails!         **"
puts "*************************************************"
run_vmd_step $vmdbin lipid_elongation.tcl lipid_elongation.log

puts "*************************************************"
puts "**            Resolve ring piercing!           **"
puts "*************************************************"
run_vmd_step $vmdbin ring_piercing_solver.tcl ring_piercing_solver.log

require_nonempty_file PROT_FLMEMB.psf
require_nonempty_file PROT_FLMEMB.pdb

puts "***************************************************************"
puts "** DONE. You can start simulations using PROT_FLMEMB.psf/pdb **"
puts "***************************************************************"
quit
