#!/bin/bash
#SBATCH -p batch        	                                # partition (this is the queue your job will be added to) 
#SBATCH -N 1               	                                # number of nodes (use a single node)
#SBATCH -n 1              	                                # number of cores (sequential job => uses 1 core)
#SBATCH --time=01:00:00    	                                # time allocation, which has the format (D-HH:MM:SS), here set to 1 hour
#SBATCH --mem=4GB         	                                # specify the memory required per node (here set to 4 GB)

# Load R module
module load R/4.4.1-gfbf-2023a   # change version if needed
export R_LIBS_USER=/hpcfs/users/a1785655/local/RLibs       # set your R library path (use your user ID)    
# Execute the program
Rscript example-script.R  	                                # your software with any arguments