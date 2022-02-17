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
conda install -c bioconda mummer
conda install -c bioconda blast
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

QUAST v5.0.2

## De Novo Assembly quality assessment with QUAST
```
quast.py <contigs.fasta> -o /path/to/output
```

## Integration of multiple genome assemblies using Contig Integrator for Sequence Assembly(CISA)
CISA official website: http://sb.nhri.org.tw/CISA/en/CISA

CISA basically consists of four major phases:
* Identification of the representative contigs and possible extensions
* removal and splitting of the contigs that may be misassembled, and clipping of uncertain regions that are located at the extremities of the contigs
* iterative merging of the contigs with a minimum 30% overlap and estimating the maximal size of repetitive regions
* merging of the contigs based on the size of repetitive regions

Installation
```
conda install -c bioconda mummer
conda install -c bioconda blast
wget ftp://sb.nhri.org.tw/CISA/upload/en/2014/3/CISA_20140304-05194132.tar
tar xf CISA_20140304-05194132.tar
```

Create the merge.config configuration file
```
count=3 
data=assembler1.fasta,title=assembler1
data=assembler2.fasta,title=assembler2
data=assembler3.fasta,title=assembler3
Master_file=merge_contigs.fa
min_length=100
Gap=11
```
Merge contigs
```
Merge.py merge.config
```
Create the cisa.config configuration file
```
genome=n (Fill in the largest contigs size in Assemblies)
infile=merge_contigs.fa
outfile=cisa.contig.fa
nucmer=/tool/path/MUMmer3.23/nucmer
R2_Gap=0.95 (default:0.95)
CISA=/tool/path/CISA1.3
makeblastdb=/tool/path/makeblastdb
blastn=/tool/path/blastn
```
CISA
```
CISA.py cisa.config
```
#Evaluate final contig with Quast
```
quast.py cisa.config -o /path/to/output
```


