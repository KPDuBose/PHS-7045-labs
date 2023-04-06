#!/bin/sh
#SBATCH --job-name=netplotfig
#SBATCH --account=notchpeak-shared-short
#SBATCH --partition=notchpeak-shared-short
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=00:05:00
#SBATCH --output=netplot.log

# Loading R
module load R/4.1.3

#  Running the script
Rscript --vanilla netplotfig.R