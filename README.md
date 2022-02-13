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
```
conda install -c bioconda quast
```
QUAST v5.0.2

## De Novo Assembly quality assessmnet with QUAST
```
quast.py <example.contigs.fasta> -o /path/to/output/dir
```
