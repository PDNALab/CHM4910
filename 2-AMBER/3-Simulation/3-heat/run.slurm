#! /bin/bash
#SBATCH --job-name=pmemd      # Job name
#SBATCH --mail-type=ALL
##SBATCH --mail-user=g.jokent@gmail.com
#SBATCH --output=out.out     # Standard output and error log
#SBATCH --error=err.err
#SBATCH --distribution=cyclic:cyclic
#SBATCH --account=alberto.perezant
#SBATCH --qos=alberto.perezant-b
#SBATCH --nodes=1                           # Use one node
#SBATCH --ntasks=1                          # Run a single task
#SBATCH --cpus-per-task=1                  # Number of CPU cores per task
#SBATCH --mem=10gb                          # Total memory limit
#SBATCH --time=10:00:00                     # Time limit hrs:min:sec

##################

# Sample slurm script for MD simulations using the SANDER or PMEMD MD engines

##################


module purge
module load cuda/11.1.0  gcc/9.3.0  openmpi/4.0.4 amber/20

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

# Modify actual paths
sander -O -i heat.in -o prot_heat.out \
    -p ../RAMP1_water.prmtop -c ../2-min/prot_min2.rst -r prot_heat.rst -ref ../2-min/prot_min2.rst

