#! /bin/bash
#SBATCH --job-name=hier-single      # Job name
#SBATCH --mail-type=ALL
##SBATCH --mail-user=g.jokent@gmail.com
#SBATCH --output=means.out     # Standard output and error log
#SBATCH --error=means.err
#SBATCH --distribution=cyclic:cyclic
#SBATCH --account=alberto.perezant
#SBATCH --qos=alberto.perezant
#SBATCH --nodes=1                           # Use one node
#SBATCH --ntasks=1                          # Run a single task
#SBATCH --cpus-per-task=8                  # Number of CPU cores per task
#SBATCH --mem=50gb                          # Total memory limit
#SBATCH --time=100:00:00                     # Time limit hrs:min:sec

##################

module purge
module load cuda/11.1.0  gcc/9.3.0  openmpi/4.0.4 amber/20

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
cpptraj.OMP -i cluster*.in
