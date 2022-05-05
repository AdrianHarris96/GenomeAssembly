#! /bin/bash

#Post-trimming QC 

#/home/groupb/bin/tools/fastqc-0.11.9-hdfd78af_1/bin/fastqc /home/groupb/data/CGT1005/CGT1005_1.fq /home/groupb/data/CGT1005/CGT1005_2.fq -o /home/aharris334

#Example: ./post_fast.sh -f /home/groupb/bin/tools/fastqc-0.11.9-hdfd78af_1/bin/ -d /home/aharris334/trimmomatic_test -o /home/aharris334/postQC

function HELP {
	echo "Use -f flag for fastqc directory"
	echo "Use -d flag for data directory"
	echo "Use -o flag for output directory"
	exit 2
}

while getopts "f:d:t:o:v" option; do 
	case $option in
		f) fastqc_dir=$OPTARG;;
		d) data_dir=$OPTARG;;
		o) output=$OPTARG;;
		v)set -x;;
		\?) HELP;;
	esac
done

let start_time="$(date +%s)"
echo "$fastqc_dir is the fastqc directory"
echo "$data_dir is the data directory"

function fast()
{
	cd $fastqc_dir
	./fastqc $1_1.fq $1_2.fq -o $output
}

if [ ! -d $output ]
then
    echo "Output does not exist in Bash"
	mkdir $output
fi

#Creation of List of File Paths to Loop Over
file_list=()
for FILE in $data_dir/*;
do 
	if [[ $FILE == *"_1."* ]]; then
		echo ${FILE:0:-5}
		fast ${FILE:0:-5}
	fi
done
