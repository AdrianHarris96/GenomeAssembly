#!/usr/bin/env python3
import subprocess
import shlex
import os
import sys

# def clear_tempfiles():

def fast_qc():
    """
    :return: HTML report
    """
    #fastqc * _1.fastq * _2.fastq

def trimmomatic():
    """

    :return:
    """
    # trimmomatic PE input_1.fq.gz input_2.fq.gz output_1.fq output_1_unpaired.fq output_2.fq output_2_unpaired.fq
    # HEADCROP:10 TRAILING:20 SLIDINGWINDOW:4:20 AVGQUAL:20 MINLEN:75
    #
    # cat output_1_unpaired.fq output_2_unpaired.fq > merged_output.fq

def quast():
    """

    :return:
    """
    #if [ ! -d quast ];
    #then
        #To store output files
    #   mkdir post_QC/test 
    #fi

    #main quast command
    #python /home/groupb/bin/tools/quast/quast.py /home/groupb/analysis/Team2-GenomeAssembly/post_QC/contig/*.fasta -o /home/groupb/analysis/Team2-GenomeAssembly/post_QC/test

    #echo "Based on the quast report, the ideal assmbly tool is: 'SPADES'."
    #echo "Please direct to /home/groupb/analysis/Team2-GenomeAssembly/de_novo/spades for the final whole genome output."

def run_idba_ud(combined_reads,threads,output_dir):
    global errors
    try:
        ## Converting fastq to fasta
        # Must be converted from fq to fa
        # Fastq files must be merged if paired-end: GT1005_1.fq + GT1005_2.fq -> GT1005.fq
        for isolate in combined_reads.split(","):
            fasta_extension = isolate.rstrip(".fq")
            fasta_extension +=".fa"
            fastq_2_fasta = "fq2fa" + " --paired --filter " + isolate + " " + fasta_extension
            print("Converting fastq to fasta with command: ", fastq_2_fasta, "\n \n")
            subprocess.call(shlex.split(fastq_2_fasta))

        ## Run Assembly
        # ./ idba / bin / idba_ud - l fasta1.fa fasta2.fa... - o idba_output /
        # -l flag for reads greater than 128
        # --mink minimum k (<=124)
        # --maxk maximum k (<=124)
        # --num_threads

        idba_ud_assembly = "idba_ud" + " -l" + forward_reads + " -2 " + backward_reads + " -o " + output_dir
        print("Running idba_ud for all isolates together with command: ", idba_ud_assembly, "\n \n")
        subprocess.call(shlex.split(idba_ud_assembly))

    except:
        errors += "IDBA_UD didnt work"

def run_platanus_b(combined_reads,threads,output_dir):
    global errors
    try:
        platanus_b_assembly = "platanus_b" + " -f" + combined_reads + " -o " + output_dir
        print("Running idba_ud for all isolates together with command: ", platanus_b_assembly, "\n \n")
        subprocess.call(shlex.split(platanus_b_assembly))
    except:
        errors += "PlatanusB did not work"

    # This should output a out_contig.fa and an assemble.log
    # Optional -k flag -> minimum k-mer to initialize with (default=32)
    # Optional -K flag -> maximum k-mer

def run_spades(combined_reads,threads,output_dir):
    global errors
    try:
        spades_assembly = "spades.py " + " -k 21,33,55,77" + " --careful --only-assembler -s " + combined_reads + " -o " + output_dir
        print("Running Megahit for all isolates together with command: ", spades_assembly, "\n \n")
        subprocess.call(shlex.split(spades_assembly))
    except:
        errors += "Spades didnt work"

def run_megahit(forward_reads,backward_reads,threads,output_dir):
    global errors
    try:
        megahit_assembly = "megahit" + " --k-list 21,29,33,39,55,59,77,79,99,119,125,141" + " -1 " + forward_reads + " -2 " + backward_reads + " -o " + output_dir
        print("Running Megahit for all isolates together with command: ", megahit_assembly, "\n \n")
        subprocess.call(shlex.split(megahit_assembly))
    except:
        errors += "Megahit did not work"

def parse_inputs(input_dir):
    """
    :param input_dir:
    :return: list of forward reads and backward reads for all isolates combined
    """
    global errors
    isolate_ids = []
    for directory in os.listdir(input_dir):
        if "CGT" in directory:
            isolate_ids.append(directory)
    print(isolate_ids)

    forward_reads = ""
    backward_reads = ""
    combined_reads = ""

    for isolate in isolate_ids:
        isolte_input_location = input_dir + isolate + "/"
        forward_reads += isolte_input_location + isolate + "_1.fq,"
        backward_reads += isolte_input_location + isolate + "_2.fq,"
        combined_reads += isolte_input_location + isolate + ".fq,"

    forward_reads = forward_reads.rstrip(",")
    backward_reads = backward_reads.rstrip(",")
    combined_reads = combined_reads.rstrip(",")

    return forward_reads, backward_reads, combined_reads

def run_assembly(input_dir, threads, output_dir):
    forward_reads, backward_reads, combined_reads = parse_inputs(input_dir)
    errors = ""

    run_megahit(forward_reads,backward_reads,threads,output_dir)
    run_spades()
    run_idba_ud()
    run_platanusz_b()

    with open("errors.txt", "w+") as file:
        file.write(errors)

def sanity_check(input_dir):
    #ToDo: Add Check for directory structure
    if os.path.exists(input_dir):
        exit_code = 0
    else:
        exit_code = 1
    return exit_code

    # echo "Usage: $0 [ -i Top Level Data Directory ] [ -o output directory ]"
    # exit
    # ;;
    # :)
    # echo "Usage: $0 [ -i Top Level Data Directory ] [ -o output directory ]"
    # exit

def main():
    global threads
    parser = argparse.ArgumentParser()
    parser.add_argument("-o", "--output", help="Output Directorry", required=False, type=str)
    parser.add_argument("-i", "--input", help="Input Directory", required=True, type=str)
    parser.add_argument("-t", "--threads", help="Number of Threads to use", required=False, type=int)
    # parse.add_argument("-a")
    args = parser.parse_args()

    # input_dir = "/home/groupb/data/"
    # output_dir = "/home/groupb/output/"

    if args.threads == None:
        threads = 4
    else:
        threads = int(args.threads)

    if sanity_check()==0:
        sys.exit()

    run_assembly(args.input,threads,args.output)

    with open (args.input, "r") as file_handle:
        input_file = file_handle.readlines()

if __name__ == "__main__":
    main()

"""
1. Allow the user to pick the final contigs file based on QUAST results
2. Add a temp folder
3. Accept choise of assembler - individual, best, combined
4. Accept choice of k-list
5. Check if software are installed
6. Parallelize the runs for each software
"""
