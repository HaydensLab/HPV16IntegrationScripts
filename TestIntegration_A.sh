#!/bin/bash
#!/bin/sh
#SBATCH --time=60:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=64gb
#SBATCH --output=IntegrationTest_A.out
#SBATCH --error=IntegrationTest_A.err
#SBATCH --mail-type=ALL
#SBATCH --job-name=IntegrationTest_A


source /mainfs/scratch/#########################/miniconda3/etc/profile.d/conda.sh
conda activate py2env
echo "conda active"
echo "printing python version"
which python
python --version

#finding all .bam files (not .bam.bai) EDIT THIS TO THE DIRECTORY OF EACH PATIENT ALONG WITH THE TASK NAME
bamsources=$(find #########################/reordered_exomes_H/Patient_A/ -type f -name "*.FilterFFPE.bam" | sort | uniq)

echo "bam sources acquired"


#iterating over all items with *.bam file type in directories under the specified directory
for b in $bamsources;
do

sample_id=$(basename $b .FilterFFPE.bam);
workdir="#########################/reordered_exomes_H/IntegrationDir/${sample_id}_Integration"
mkdir -p $workdir

echo "commencing integration find for $sample_id"

python2 #########################/reordered_exomes_H/IntegrationDir/SurVirus-master/surveyor.py $b $workdir #########################/VariablesFile/GRCh38.p14.genome.fa #########################/VariablesFile/HPV_RefGenome.fa #########################/VariablesFile/GRCh38_HPV.p14.genome.fa

echo "Round complete"

done

echo "deactivating conda"

conda deactivate