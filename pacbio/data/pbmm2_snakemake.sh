#!/bin/bash -login
#SBATCH -p high2                # use 'med2' partition for medium priority
#SBATCH -J pbmm2_snakemake               # name for job
#SBATCH -c 1                  # 1 core
#SBATCH -t 24:00:00             # ask for an hour, max
#SBATCH --mem=1000             # memory (2000 mb = 2gb)
#SBATCH --mail-type=ALL
#SBATCH --mail-user=rjkenny@ucdavis.edu

# initialize conda
. ~/mambaforge/etc/profile.d/conda.sh

# activate your desired conda environment
conda activate pacbio_aln

# fail on weird errors
set -e
set -x

### YOUR COMMANDS GO HERE ###
snakemake --slurm --default-resources slurm_account=adamgrp slurm_partition=low2 mem_mb=5000 runtime=240 nodes=1 -j 24 
### YOUR COMMANDS GO HERE ###

# Print out values of the current jobs SLURM environment variables
env | grep SLURM

# Print out final statistics about resource use before job exits
scontrol show job ${SLURM_JOB_ID}

sstat --format 'JobID,MaxRSS,AveCPU' -P ${SLURM_JOB_ID}.batch




