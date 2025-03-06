# In Silico Mutations using AMBER

Here is a summary of the exercises we have done in class. Our workflow for in silico mutation is:

1. Clean the PDB file using pdb4amber
2. Modify the cleaned pdb file and use SCWRL4 to introduce the mutation.
3. Identify the correct protonation state using H++ webserver.
4. Prepare and run the MD simulations using AMBER

## Obtain PDB Files

You can either transfer a downloaded PDB file from your local machine to Hipergator 

```
scp -rv <pdb_file> <username>@hpg.rc.ufl.edu:<path_to_orange_directory>
```

or use curl directly on Hipergator to download the PDB from the RCSB.

```
# ET-TP complex
curl https://files.rcsb.org/download/7JQ8.pdb > 7jq8.pdb

# MDM2-p53 complex
curl https://files.rcsb.org/download/4HFZ.pdb > 4hfz.pdb
```

## Clean the PDB Files with `pdb4amber`

Use pdb4amber to remove hydrogens and water molecules. NOTE that it will also renumber the residues so that they start at residue 1.

```
pdb4amber -i <pdb_from_rcsb>.pdb -o <output_pdb>.pdb -y -d
```

Opt# y removes all hydrogens (which will be re-added later), and option d removes all the water molecules.

### Optional: Manually remove unstructured regions

If necessary, open `<output_pdb>.pdb` and remove unstructured N- and C- termini. For example, in ET-TP systems, you might want to only keep residues S29 to K96. Save this as cleaned.pdb.

## Manually Remove the Side Chain of the Mutation Site

Open `cleaned.pdb` using vim (or any other text editors) and remove the side-chain atoms of the residue you plan to mutate for (i.e. keep only N, C, CA, and O). Then, rename the residue name of the site you want to mutate.

## Mutate the Residue with SCWRL4

We will then mutate the cleaned.pdb file using SCWRL4:

```
scwrl4 −i cleaned.pdb -o scwrl_out.pdb -s seq.data
```

where seq.data is a file you will make and it contains information on which residue's functional group SCWRL will modify (i.e. the mutant). The option s points to the seq.data file. From the Scwrl website:

```
# Example:
SDERYCNM - full SCWRL side-chain replacement
SdERYCNM - input residue (aspartate) is left where as is.
SxERYCNM - input residue (aspartate) is left where as is.
```

## Remove Hydrogens Added by SCWRL4

SCWRL4 automatically adds hydrogens. We remove these again to prep for the H++ webserver:

```
pdb4amber -i scwrl_out.pdb -o for_h_plus.pdb -y
```

## Correct Protonation States via H++

Download this `for_h_plus.pdb` to your local computer. Then we'll submit this to the H++ webserver to get the proper protonation states of the residues at pH 7. H++ will provide a file named *genpdb.cpptraj.pdb, which already has the correct AMBER residue names. Download this file and upload it back to Hipergator.

## Prepare AMBER files

Generate the topology and coordinate files from the H++ pdb file using `tleap` and the `tleap.in` file. This would also add the water box and the counterions to your system.

## Running MD Simulations in AMBER

To run the MD simulations, use the input files we have used in the class. We have 5 steps. The first two steps are minimization (first is only on the solvent, and the second is for the whole system), the third step is heating of the solvent, the fourth step is equilibration on the whole system, and the final step is the actual MD run (or as we call it, the production run). The slurm files and input files for these simulations are in `3-Simulation` folder.
