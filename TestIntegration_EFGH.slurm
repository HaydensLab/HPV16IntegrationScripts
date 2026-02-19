#!/bin/sh
#!/bin/bash
#SBATCH --job-name=TestIntegrationEFGH
#SBATCH --output=TestIntegrationEFGH_%A_%a.out
#SBATCH --error=TestIntegrationEFGH_%A_%a.err
#SBATCH --array=1-4  # Specify the number of tasks in the array
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mail-type=ALL
#SBATCH --mem=64gb
#SBATCH --time=60:00:00

# Define the array of script names
scripts=(TestIntegration_E.sh TestIntegration_F.sh TestIntegration_G.sh TestIntegration_H.sh)

# Get the script name based on the array index
script_name=${scripts[$SLURM_ARRAY_TASK_ID-1]}

# Run the script
bash "$script_name"

