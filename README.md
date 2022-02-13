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

```
conda install -c bioconda quast
```
QUAST v5.0.2

## De Novo Assembly quality assessmnet with QUAST
```
quast.py <example.contigs.fasta> -o /path/to/output/dir
```
