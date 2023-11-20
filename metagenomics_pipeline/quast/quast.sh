### quast
###
###

# e.g. megahit quast

mkdir quast
cd quast
for i in `cat /work/RPTU-MIMeS/pipeline_pilot_DNA/first_steps/samples.txt`
do
  echo ${i}
  SAMPLE=$(echo ${i}) 
  echo ${SAMPLE}
  sbatch -N 1 --account=RPTU-MIMeS --tasks=24 --mem=50000 --time=01:00:00 --wrap="/work/vdully/CoastMon/quast/quast_files/metaquast.py /work/RPTU-MIMeS/pipeline_pilot_DNA/first_steps/step4b_megahit/${SAMPLE}/final.contigs.fa --max-ref-number 0 -o ${SAMPLE}"
done

# get numbers automated
# echo Sample and sed results will be appended for every directory. 

for i in `cat /work/RPTU-MIMeS/pipeline_pilot_DNA/first_steps/samples.txt`
do
  echo ${i} >> report_results.txt
  sed -n '16p;5p;6p;7p;8p;20p' /work/RPTU-MIMeS/pipeline_pilot_DNA/first_steps/step4b_megahit/quast/${i}/report.txt >> report_results.txt
done
