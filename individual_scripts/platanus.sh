#! /bin/bash

#Example input: ./platanus.sh -p /home/groupb/bin/tools/ -d /home/groupb/data -o /home/groupb/platanus_output

function HELP {
	echo "The Platanus_B shell script requires flags, -p, -d, and -o for the path to the platanus executable, path to the data (fasta files), and the desired output directory, respectively."
	echo "Users can also submit optional flags -t, -k, and -K for threads, minimumn k size, and maximum k factor, respectively."
	echo "Minimum k size is 32 by default."
	echo "Maximum k factor is 0.5 by default. Maximum K = FLOAT*Read_Length"
	exit 2
}

threads=1
mink=32
maxk=0.5

while getopts "p:d:o:t:k:K:v" option; do 
	case $option in
		p) platanus_dir=$OPTARG;;
		d) data_dir=$OPTARG;;
		o) output=$OPTARG;;
		t) threads=$OPTARG;;
		k) mink=$OPTARG;;
		K) maxk=$OPTARG;;
		v)set -x;;
		\?) HELP;;
	esac
done

#Setting Up Timer
let start_time="$(date +%s)"
echo "$platanus_dir is the platanus directory"
echo "$data_dir is the data directory"

#Directory Check
if [ ! -d $output ]
then
    echo "Output directory not found. Creating directory."
	mkdir $output
fi

#Append files from file directory to file list
file_list=()
for FILE in $data_dir/*;
do 
	extension="${FILE##*/}"
	if [[ $extension == *"CGT"* ]]; then
		file_list+=("$FILE/$extension.fa")
		cd $output #Move to output
		mkdir $extension #Make a file for each isolate
	fi
done

cd $platanus_dir #Moving to tool's directory

#Loop through each path for ".fa" files
for READ in ${file_list[@]};
do
	echo "Running Platanus_B for $READ"
	#echo "${READ:(-10):(-3)}"
	file_output="$output/${READ:(-10):(-3)}"
	./platanus_b assemble -f $READ -t $threads -k $mink -K $maxk -o $file_output 2>log
done

#Assemble with list of reads and output both out_contig.fa and log
let current_time="$(date +%s)"
let seconds=$current_time-$start_time
echo "Platanus_B Runtime: $seconds"
