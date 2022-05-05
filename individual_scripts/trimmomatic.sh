#! /bin/bash

#Trimming Script

#./trimmomatic.sh -r /home/groupb/bin/tools/trimmomatic-0.39-hdfd78af_2/bin -d /home/groupb/data -t 8 -o /home/aharris334/trimmomatic_test

threads=1

function HELP {
	echo "Use -r flag for trimmomatic directory"
	echo "Use -d flag for data directory"
	echo "Use -o flag for output directory"
	exit 2
}
while getopts "r:d:t:o:v" option; do 
	case $option in
		r) trim_dir=$OPTARG;;
		d) data_dir=$OPTARG;;
		t) threads=$OPTARG;;
		o) output=$OPTARG;;
		v)set -x;;
		\?) HELP;;
	esac
done

let start_time="$(date +%s)"
echo "$trim_dir is the trimmomatic directory"
echo "$data_dir is the data directory"

function trim()
{
	cd $output
	#trimmomatic PE $1_1.fq $2_2.fq $3_1.fq $3_1_unpaired.fq $3_2.fq $3_2_unpaired.fq HEADCROP:10 TRAILING:20 SLIDINGWINDOW:4:20 AVGQUAL:10 MINLEN:10
	trimmomatic PE $1_1.fq $2_2.fq $3_1.fq $3_1_unpaired.fq $3_2.fq $3_2_unpaired.fq HEADCROP:10 TRAILING:3 SLIDINGWINDOW:4:20 AVGQUAL:15 MINLEN:10
	cat $3_1_unpaired.fq $3_2_unpaired.fq > merged_$3.fq
}

if [ ! -d $output ]
then
    echo "Output does not exist in Bash"
	mkdir $output
fi

#Creation of List of File Paths to Loop Over
for FILE in $data_dir/*;
do 
	extension="${FILE##*/}"
	if [[ $extension == *"CGT"* ]]; then
		echo $FILE/$extension
		trim $FILE/$extension $FILE/$extension $extension 
	fi
done

#Implement Quast next 