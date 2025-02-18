#!/bin/bash
#SBATCH --job-name=af2
#SBATCH --output=af2.out
#SBATCH --error=af2.err
#SBATCH --mail-type=ALL
##SBATCH --mail-user=g.jokent@gmail.com
#SBATCH --time=100:00:00
#SBATCH --ntasks=1
#SBATCH --distribution=cyclic:cyclic
#SBATCH --mem-per-cpu=40000
#SBATCH --qos=alberto.perezant
#SBATCH --cpus-per-gpu=1
#SBATCH --gpus-per-task=1
#SBATCH --partition=gpu
#SBATCH --constraint=a100

##########################################################

module purge
module load cuda/12.4.1

export PATH="/orange/alberto.perezant/jokent.gaza/af2/localcolabfold/colabfold-conda/bin:$PATH"

colabfold_batch --model-type 'alphafold2_ptm' seq.fasta output_af2

