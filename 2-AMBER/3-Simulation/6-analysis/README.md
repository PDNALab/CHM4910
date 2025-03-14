# Analysis using CPPTRAJ

You can use CPPTRAJ either in interactive mode (typing each command in its interface) or by providing an input file. To run an input file, use:

```
cpptraj -i <input_file>.in
```

Some notes:

1. A common CPPTRAJ error is when you have inconsistencies between the topology and the trajectory file (i.e., have different number and order of atoms).
2. The analysis files are broken down to multiple scripts, but it always possible to write all analyses in a single script.
3. There are a lot of resources for CPPTRAJ. You can always consult the AMBER manual:
   
https://ambermd.org/Manuals.php

or the AMBER-hub

https://amberhub.chpc.utah.edu/cpptraj/

## Strip Water

A common post-processing step is to remove explicit solvent molecules and counterions. This would reduce both file size and computational overhead, making analyses faster and easier. Of course, this should only be performed if we only need to focus on the solute and not on the solute-solvent interactions (or even solvent-solvent).
Below is an example (`strip.in`) for removing water from a trajectory:

```
# Load the original topology
parm ../RAMP1_water.prmtop

# Load the trajectory
trajin /orange/alberto.perezant/jokent.gaza/CHM4910/2-AMBER/3-Simulation/5-md/prot_md.nc 

# Center the trajectory
autoimage

# Remove water molecules 
strip :WAT

# Save a new trajectory file
trajout image.dcd

# Execute
go
```

Because the new trajectory no longer contains water, you need a matching topology file. You can generate one by running the `parmwrite.in` CPPTRAJ script:

```
# Same as above
parm ../RAMP1_water.prmtop
autoimage

# Remove water in the topology file and write
parmstrip :WAT
parmwrite out prot_nowater.parm7

# Execute
go
```

## RMSD and RMSF analysis

Two common analyses are root mean square deviation (RMSD) and root mean square fluctuation (RMSF):

1. RMSD measures how much each frame deviates from a reference structure (e.g., the first frame or a crystal structure).
2. RMSF measures the fluctuation of each atom over the trajectory.

```
# Load topology and trajectory with stripped water
parm prot_nowater.parm7
trajin image.dcd

# Calculate RMSD of residues 1-81 with atom types CA and CB. Use the first frame as the reference, and write the output to rmsd.dat
rms ToFirst :1-81@CA,CB first out rmsd.dat

# Calculate RMSF of all atoms and writ to bfactor.dat
atomicfluct af3_fluct out bfactor.dat

# Execute
go
```

## Clustering

Clustering groups similar structures together to identify distinct conformational states. This task can be computationally intensive, so we can submit it as a job (e.g., via SLURM using `cpptraj.slurm`) instead. 

```
# Load topology and trajectory with stripped water
parm prot_nowater.parm7
trajin image.dcd

# Cluster using the Hierarchical (average) algorithm
# CLuster the non-H atoms of residues 1-10 to 10 clusters
cluster c1 \
  hieragglo epsilon 3.0 clusters 10 averagelinkage \
  rms :1-81&!@H= \
  sieve 10 random \
  summary summary.dat \
  repout rep repfmt pdb
run
```
