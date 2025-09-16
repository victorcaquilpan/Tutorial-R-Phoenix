#  Using R in Phoenix

I recommend cloning this repository to access the data and scripts, ensuring a smoother learning experience.

```bash
git clone https://github.com/victorcaquilpan/Tutorial-R-Phoenix.git
```

First, you need to check if you have connection to Phoenix. Open a terminal in your computer and run:

```bash
ssh a1785655@phoenix-login1.adelaide.edu.au   # Replace with your University ID
```
Here, you would need to enter your password. If everything is okay, you can access to Phoenix. 

## Data Management

There are different locations in Phoenix where you can store your data. Currently, it's recommended to use hpcfs. Enter to your storage and create a folder **data** and others called **scripts** and **outputs**.

```bash
cd /hpcfs/users/a1785655 # Replace with your University ID
mkdir data
mkdir scripts
mkdir output
```

Now that you created your folder data, you can open a new terminal and copy the files that you need to transfer using:

```bash
scp -r /path-to-data-folder/data a1785655@phoenix-login1.adelaide.edu.au:/hpcfs/users/a1785655/  # Replace with your University ID
```

Also you can transfer your scripts using the same nomenclature. You need to have your R script and your bash script to run the job in Phoenix.

```bash
scp -r /path-to-script-folder/scripts a1785655@phoenix-login1.adelaide.edu.au:/hpcfs/users/a1785655/   # Replace with your University ID
cd /hpcfs/users/a1785655/scripts # Replace with your University ID
```

Before running your script, you need to create a folder for your libraries/packages in R. After that, in R you need to indicate the path of the libraries and from R you can install all the libraries that you need. Since Phoenix doesn't provide internet connection at the moment of running your scripts, you need to install all the libraries that you need ahead.

```bash
# Create a personal library folder for R packages (if it doesn't exist yet)
mkdir -p /hpcfs/users/a1785655/local/RLibs # Replace with your University ID

# Load the R module available on the HPC system
module load R

# Start an interactive R session
R

# Inside R: Add your personal library path to the search paths for R packages
.libPaths(c("/hpcfs/users/a1785655/local/RLibs", .libPaths()))    # Replace with your University ID

# Inside R: Check which library paths are currently active
.libPaths()

# Inside R: Install required R packages into your personal library

install.packages("readr")
install.packages("ggplot2")
install.packages("caret")
install.packages("randomForest")

# Exit the R session
quit()

# Add your personal R library path to your bash profile
# so that it is automatically set up each time you log in
echo "export R_LIBS_USER=/hpcfs/users/a1785655/local/RLibs" >> ~/.bashrc      # Replace with your University ID
```

## Running your scripts

Finally, you can execute your script:
```bash
sbatch my-job.sh 
```

The file .sh is simply a list of instructions to be run in Phoenix and execute your script. Here you can see the contain of a basic sh file:

```bash
#!/bin/bash
#SBATCH -p batch        	                                # partition (this is the queue your job will be added to) 
#SBATCH -N 1               	                                # number of nodes (use a single node)
#SBATCH -n 1              	                                # number of cores (sequential job => uses 1 core)
#SBATCH --time=01:00:00    	                                # time allocation, which has the format (D-HH:MM:SS), here set to 1 hour
#SBATCH --mem=4GB         	                                # specify the memory required per node (here set to 4 GB)

# Notification configuration 
#SBATCH --mail-type=END					    	            # Send a notification email when the job is done (=END)
#SBATCH --mail-type=FAIL   					                # Send a notification email when the job fails (=FAIL)
#SBATCH --mail-user=victor.caquilpanparra@adelaide.edu.au  	# Email to which notifications will be sent

# Load R module
module load R/4.4.1-gfbf-2023a   # change version if needed
export R_LIBS_USER=/hpcfs/users/a1785655/local/RLibs 
# Execute the program
Rscript example-script.R  	                                # your software with any arguments
```

When you run your bash script, you will see something like: **Submitted batch job 5640513**, indicating that your job was submitted to Phoenix. 

Running: 

```bash
squeue -u$USER
```

You can obtain the state of your job. You can see something like:

```bash
JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
           5640542   icelake my-job.s a1785655  R       1:54      1 p3-cpu-88
```

From this output you can see mostly the ID of your running experiment, your user and  the state (ST). ST can take the next values: R - running, PD - Pending, F - Failed, ST - Stopped, TO - Timeout. The logs of each experiments will be saving in an ```slurm-xxxxx.out``` file, in the same directory where the bashs script is. There, you can check the output of your running. For each running, a new **.out** file is generated. I recommend deleting them as you are running new experiments.

## Downloading the output to your computer

You can get any file that you are generating inside Phoenix to your computer. For that you can use the next next script:

```bash
scp -r a1785655@phoenix-login1.adelaide.edu.au:/hpcfs/users/a1785655/output /Users/victorcaquilpan/Desktop/aiml/projects/Tutorial-Phoenix/output-phoenix/ # Replace with your University ID
```

## Missing libraries 

If you need some extra libraries, open R inside Phoenix and install any packages as you can see below:

```bash
# Load the R module available on the HPC system
module load R

# Start an interactive R session
R

# Inside R: Install required R packages into your personal library
install.packages("torch") 

# Exit the R session
quit()
```

All the information here is wrapped it out from https://wiki.adelaide.edu.au/hpc/Category:Basics and more specific R-related info in: https://wiki.adelaide.edu.au/hpc/Installing_R_packages.






