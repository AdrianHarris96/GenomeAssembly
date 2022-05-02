# Team2-GenomeAssembly

The Genome Assembly group members for Team 2 are:
* Adrian Harris
* Ashlesha Gogate
* Nilavrah Sensarma
* Sreenath Srikrishnan
* Zheying Xu
* Wei-An Chen
* Howard Page
* Harini Narasimhan

## Installation

```
conda install -c bioconda fastqc
conda install -c bioconda trimmomatic
conda install -c bioconda quast

## SPAdes Installation

To download SPAdes Linux binaries and extract them, go to the directory in which you wish SPAdes to be installed and run:

    wget http://cab.spbu.ru/files/release3.15.2/SPAdes-3.15.2-Linux.tar.gz
    tar -xzf SPAdes-3.15.2-Linux.tar.gz
    cd SPAdes-3.15.2-Linux/bin/
In this case you do not need to run any installation scripts – SPAdes is ready to use. We also suggest adding SPAdes installation directory to the PATH variable.

## Platanus_B Installation

To download Platanus_B binaries, go to the directory in which you wish to install Platanus_B and run:

    git clone https://github.com/rkajitani/Platanus_B.git
    cd Platanus_B
    make
    cp platanus_b <installation_path>

Platanus_B also requires the installation of OpenMP (to compile the source code), Minimap2 (for the assembly of long reads), and Perl (to execute the scripts).
Linux 64 bit binary (precompiled) can also be downloaded here: http://platanus.bio.titech.ac.jp/platanus-assembler/platanus-1-2-4

## IDBA_UD Installation 

To download IDBA_UD binaries, go to the directory in which you wish to install IDBA_UD and run:

    git clone https://github.com/loneknightpy/idba.git
    cd idba
    ./build.sh

IBDA_UD requires GCC to compile source code. All IDBA executables will be listed under the bin directory in IDBA upon installation. 
```
## Pre Trimming Quality assessmnet with FastQC
The fastQC command used was
```
fastqc *_1.fastq  *_2.fastq
```
## Trimming
Trimming was done using trimmomatic. The following command was used
```
trimmomatic PE input_1.fq.gz input_2.fq.gz output_1.fq output_1_unpaired.fq output_2.fq output_2_unpaired.fq HEADCROP:10 TRAILING:20 SLIDINGWINDOW:4:20 AVGQUAL:20 MINLEN:75

cat output_1_unpaired.fq output_2_unpaired.fq > merged_output.fq
```


## De Novo Assembly Quality Assessment with QUAST
QUAST is a common tool for evaluating the quality of genome assembly. It can calculate basic contig information such as N50 (without reference), and can also calculate fraction, duplication, misassembly, unaligned, mismatch and other information by aligning the reference genome (reference-based).

We are using [QUAST v5.0.2](http://quast.sourceforge.net/install.html) for post-QC evalution and visualization. 

After replacing module ```cgi.escape``` to ```html.escape``` in ``` quast_libs/site_packages/jsontemplate/jsontemplate.py ```.

Run following code and direct to ```report.pdf``` to check the evalution result of the assemblers.
```
quast.py <spades_contigs.fasta> <megahit_contigs.fasta> <platanus_contigs.fasta> <idba_contigs.fasta> -o /quast/output
```

