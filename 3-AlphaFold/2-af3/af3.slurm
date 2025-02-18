#!/bin/bash                                                                 
#SBATCH --job-name=af3   # Job name
#SBATCH --mail-type=END,FAIL         # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --ntasks=1               # Number of MPI ranks
##SBATCH --cpus-per-gpu=1           # Number of cores per MPI rank 
##SBATCH --gpus-per-task=1
##SBATCH --ntasks-per-node=1
##SBATCH --gpus-per-node=1
#SBATCH --partition=gpu
#SBATCH --gpus=a100:1
##SBATCH --nodes=1                  # Number of nodes
#SBATCH --mem-per-cpu=20gb          # Memory per processor
#SBATCH --time=168:00:00              # Time limit hrs:min:sec
#SBATCH --output=af3.log     # Standard output and error log
pwd; hostname; date

module load ufrc cuda/12 gcc hhsuite

singularity exec \
     --nv \
     /orange/alberto.perezant/jokent.gaza/af3/alphafold3/alphafold3.sif \
     python /orange/alberto.perezant/jokent.gaza/af3/alphafold3/run_alphafold.py \
     --json_path=test_run/af_input/fold_input.json \
     --model_dir=models \
     --db_dir=/orange/alberto.perezant/share/af3/db \
     --output_dir=test_run/af_output
