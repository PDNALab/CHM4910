#! /bin/bash
#SBATCH --job-name=pmemd      # Job name
#SBATCH --mail-type=ALL
##SBATCH --mail-user=g.jokent@gmail.com
#SBATCH --output=means.out     # Standard output and error log
#SBATCH --error=means.err
#SBATCH --distribution=cyclic:cyclic
#SBATCH --account=alberto.perezant
#SBATCH --qos=alberto.perezant
#SBATCH --nodes=1                           # Use one node
#SBATCH --ntasks=1                          # Run a single task
#SBATCH --mem=10gb                          # Total memory limit
#SBATCH --time=100:00:00                     # Time limit hrs:min:sec
#SBATCH --partition=gpu
#SBATCH --gpus-per-task=1
#SBATCH --cpus-per-gpu=1
#SBATCH --constraint=2080ti
##SBATCH --gpus=a100:1

##################


module purge
module load cuda/11.1.0  gcc/9.3.0  openmpi/4.0.4 amber/20

pmemd.cuda -O -i eq.in -o prot_eq.out \
    -p ../RAMP1_water.prmtop -c ../3-heat/prot_heat.rst -r prot_eq.rst -ref ../3-heat/prot_heat.rst

