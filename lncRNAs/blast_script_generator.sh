#!/bin/bash

#############################################################################################

db=uniref
blast_type=x

#############################################################################################

db_path=$db.fasta
COUNTER=5000
until [ $COUNTER -eq "30000" ]; do
	echo "#!/bin/bash

#SBATCH -J $db.$COUNTER.$blast_type                          # JobID
#SBATCH -o $db.$COUNTER.$blast_type.o%J              # Defines stdout. %J expands to JobID
#SBATCH -e $db.$COUNTER.$blast_type.e%J              # Defines stderr
#SBATCH -n 1                                    # Defines number of jobs per node
#SBATCH -p normal                               # Job type
#SBATCH -t 24:00:00                             # Still need to define
#SBATCH --mail-user=znh1992@gmail.com           # Defines email
#SBATCH --mail-type=begin                       # Email me when the job starts
#SBATCH --mail-type=end                         # Email me when the job finishes

module load blast/2.2.29

blast$blast_type -query $COUNTER.fasta -db $db_path -num_threads 16 -evalue 1e-20 -max_target_seqs 1 -outfmt 6 > $COUNTER.outfmt6_$blast_type " > $db.$COUNTER.sh

	COUNTER=$(( $COUNTER + 5000))
done

