# PRODIGAL
# prodigal using metaSPAdes output

module load bioconda/latest
for i in `cat /work/RPTU-MIMeS/pipeline_pilot_DNA/first_steps/samples.txt`
do
  echo ${i}
  SAMPLE=$(echo ${i}) 
  mkdir ${SAMPLE}
  cd ${SAMPLE}
  sbatch -N 1 --account=RPTU-MIMeS --mail-type=END --tasks=24 --mem=100000 --time=08:00:00 --wrap="prodigal -i /work/RPTU-MIMeS/pipeline_pilot_DNA/first_steps/step4a_metaspades/${SAMPLE}/contigs.fasta -a /work/RPTU-MIMeS/pipeline_pilot_DNA/count_tables/spades_prodigal/${SAMPLE}/orfs_${SAMPLE}.faa -o /work/RPTU-MIMeS/pipeline_pilot_DNA/count_tables/spades_prodigal/${SAMPLE}/orfs_${SAMPLE}.gff -p meta"
  cd ..
done

## lineariz ORFs
## keep only complete ORFs

for i in `cat /work/RPTU-MIMeS/pipeline_pilot_DNA/first_steps/samples.txt`
do
  echo ${i}
  SAMPLE=$(echo ${i}) 
  awk '/^>/ {printf("%s%s\t",(N>0?"\n":""),$0);N++;next;} {printf("%s",$0);} END {printf("\n");}' < //work/RPTU-MIMeS/pipeline_pilot_DNA/count_tables/spades_prodigal/${SAMPLE}/orfs_${SAMPLE}.faa | sed 's/\t/\n/g' > /work/RPTU-MIMeS/pipeline_pilot_DNA/count_tables/spades_prodigal/${SAMPLE}/orfs_${SAMPLE}_lin.faa
  grep -B 1 "^M" /work/RPTU-MIMeS/pipeline_pilot_DNA/count_tables/spades_prodigal/${SAMPLE}/orfs_${SAMPLE}_lin.faa | grep -B 1 "*" | sed '/^--$/d' > /work/RPTU-MIMeS/pipeline_pilot_DNA/count_tables/spades_prodigal/${SAMPLE}/orfs_complete_${SAMPLE}.faa
done

## count ORFs
grep -c "^>" **/*lin.faa > count_orfs.txt

## count complete ORFs
grep -c "^>" **/*orfs_complete_***.faa > count_orfs_complete.txt
