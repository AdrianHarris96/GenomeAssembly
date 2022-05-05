#! /bin/bash

#Example input: ./idba.sh -i /home/groupb/bin/tools/idba/bin -d /home/groupb/data -t 8 -o /home/groupb/idba_output

threads=1
mink=20
maxk=100

function HELP {
	echo "The idba shell script requires flags, -i, -d, and -o for the path to the idba executable, path to the data (fasta files), and the desired output directory, respectively."
	echo "Users can also submit optional flags -t, -n, and -m for threads, minimumn k, and maximum k, respectively."
	echo "Minimum and maximum k must both be below 124."
	exit 2
}
while getopts "i:d:t:n:m:o:v" option; do 
	case $option in
		i) idba_dir=$OPTARG;;
		d) data_dir=$OPTARG;;
		t) threads=$OPTARG;;
		n) mink=$OPTARG;;
		m) maxk=$OPTARG;;
		o) output=$OPTARG;;
		v)set -x;;
		\?) HELP;;
	esac
done

#Setting Up Timer
let start_time="$(date +%s)"
echo "$idba_dir is the idba directory"
echo "$data_dir is the data directory"

function fq2fa()
{
	cd $idba_dir
	./fq2fa --paired --filter $1.fq $2.fa
}

#Directory Check
if [ ! -d $output ]
then
    echo "Output directory not found. Creating directory."
	mkdir $output
fi

#Creation of List of File Paths to Loop Over
#As each are appended to the list, the loop calls the function fq2fa to convert these files to fasta files
file_list=()
for FILE in $data_dir/*;
do 
	extension="${FILE##*/}"
	if [[ $extension == *"CGT"* ]]; then
		echo "Running fq2fa for $extension"
		fq2fa $FILE/$extension $FILE/$extension #Calling function
		file_list+=("$FILE/$extension.fa")
		cd $output #Move to output
		mkdir $extension #Make a file for each isolate
	fi
done

cd $idba_dir #Moving to the tool's directory

#Loop through each path for ".fa" files 
for READ in ${file_list[@]};
do
	echo "Running IDBA_UD for $READ"
	#echo "${READ:(-10):(-3)}"
	file_output="$output/${READ:(-10):(-3)}"
	./idba_ud -l $READ --num_threads $threads --mink $mink --maxk $maxk -o $file_output
done 

#Stop Timer
let current_time="$(date +%s)"
let seconds=$current_time-$start_time
echo "IDBA_UD Runtime: $seconds"
