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

![Screenshot](final_pipeline.jpg)

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
FastQC <br>
* Used to provide an overview of basic quality control metrics for raw next generation sequencing data.
* Reason to choose- Easy graphical visualization, Industry standard <br>
* Criteria- Basic statistics, Per base sequence quality, sequence length distribution
![Screenshot](fastqc.jpg)
###### (Above is an example of FastQC visualization)
 
## Trimming
Trimming was done using trimmomatic. The following command was used
```
trimmomatic PE input_1.fq.gz input_2.fq.gz output_1.fq output_1_unpaired.fq output_2.fq output_2_unpaired.fq HEADCROP:10 TRAILING:20 SLIDINGWINDOW:4:20 AVGQUAL:20 MINLEN:75

cat output_1_unpaired.fq output_2_unpaired.fq > merged_output.fq
```
Trimmomatic <br>
* Trimmomatic is a fast, multithreaded command line tool that can be used to trim and crop Illumina (FASTQ) data as well as to remove adapters. <br>
* Adapter sequences should be removed from reads because they interfere with downstream analyses, such as alignment of reads to a reference. The adapters contain the sequencing primer binding sites, the index sequences, and the sites that allow library fragments to attach to the flow cell lawn. <br>
* Reason to choose- Fast, Works well with paired end reads <br>
* Criteria- Trimming the ends, maintaining an average quality score, maintaining a minimum read length <br>

## SPADES
* SPAdes is a universal A-Bruijn assembler <br>
* It uses k-mers only for building the initial de Bruijn graph <br>
* SPAdes outputs contigs and allows to map reads back to their positions in the assembly graph after graph simplification

## Platanus_B
* Platanus_B was designed to improve assemblies by introducing more steps than there are in Platanus and Platanus-allee <br>
* De novo assembler for bacterial genomes using an iterative error-removal process <br>
* Platanus_B’s advantages of contiguities and accuracies for short-read inputs is useful to proceed large-scale projects, which target hundreds of isolates and focus on a few variant sites between genomes. 

## MEGAHIT
* MEGAHIT makes use of succinct de Bruijn graphs <br>

## IDBA_UD
*  De Bruijn graph approach <br>
*  The technique of local assembly with paired-end information is used to solve the branch problem of low-depth short repeat regions

## Comparison of different tools
![Screenshot](tool.jpg)

## De Novo Assembly Quality Assessment with QUAST
![plot](./QuastReport/example_quast_report.jpg)
###### (Above is an example of QUAST visualization)

QUAST is a common tool for evaluating the quality of genome assembly. It can calculate basic contig information such as N50 (without reference), and can also calculate fraction, duplication, misassembly, unaligned, mismatch and other information by aligning the reference genome (reference-based).

We are using [QUAST v5.0.2](http://quast.sourceforge.net/install.html) for post-QC evalution and visualization. 

After replacing module ```cgi.escape``` to ```html.escape``` in ``` quast_libs/site_packages/jsontemplate/jsontemplate.py ```.

Run following code and direct to ```report.pdf``` to check the evalution result of the assemblers.
```
quast.py <spades_contigs.fasta> <megahit_contigs.fasta> <platanus_contigs.fasta> <idba_contigs.fasta> -o /quast/output
```

### References
1. Leggett, R. M., Ramirez-Gonzalez, R. H., Clavijo, B. J., Waite, D., & Davey, R. P. (2013). Sequencing quality assessment tools to enable data-driven informatics for high throughput genomics. Frontiers in genetics, 4, 288. https://doi.org/10.3389/fgene.2013.00288
2. Anthony M. Bolger, Marc Lohse, Bjoern Usadel, Trimmomatic: a flexible trimmer for Illumina sequence data, Bioinformatics, Volume 30, Issue 15, 1 August 2014, Pages 2114–2120, https://doi.org/10.1093/bioinformatics/btu170
3. Gurevich A, Saveliev V, Vyahhi N, Tesler G. QUAST: quality assessment tool for genome assemblies. Bioinformatics. 2013 Apr 15;29(8):1072-5. doi: 10.1093/bioinformatics/btt086. Epub 2013 Feb 19. PMID: 23422339; PMCID: PMC3624806.
4. Bankevich, A., Nurk, S., Antipov, D., Gurevich, A. A., Dvorkin, M., Kulikov, A. S., Lesin, V. M., Nikolenko, S. I., Pham, S., Prjibelski, A. D., Pyshkin, A. V., Sirotkin, A. V., Vyahhi, N., Tesler, G., Alekseyev, M. A., & Pevzner, P. A. (2012). SPAdes: a new genome assembly algorithm and its applications to single-cell sequencing. Journal of computational biology : a journal of computational molecular cell biology, 19(5), 455–477. https://doi.org/10.1089/cmb.2012.0021
5. Kajitani R, Toshimoto K, Noguchi H, Toyoda A, Ogura Y, Okuno M, Yabana M, Harada M, Nagayasu E, Maruyama H, Kohara Y, Fujiyama A, Hayashi T, Itoh T. Efficient de novo assembly of highly heterozygous genomes from whole-genome shotgun short reads. Genome Res. 2014 Aug;24(8):1384-95. doi: 10.1101/gr.170720.113. Epub 2014 Apr 22. PMID: 24755901; PMCID: PMC4120091.
6. Yu Peng, Henry C. M. Leung, S. M. Yiu, Francis Y. L. Chin, IDBA-UD: a de novo assembler for single-cell and metagenomic sequencing data with highly uneven depth, Bioinformatics, Volume 28, Issue 11, 1 June 2012, Pages 1420–1428, https://doi.org/10.1093/bioinformatics/bts174

