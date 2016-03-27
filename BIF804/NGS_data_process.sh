#!/bin/bash

# NOTE: Change program locations to suit your setup
gatk='java -jar /usr/local/GATK/GenomeAnalysisTK.jar';
picard='java -jar /usr/local/picard/picard.jar';


# Perform aln alignment for read1's
for arg in $(ls *read1.fastq);
do
	arrayArg=(${arg//_/ });
	bwa aln chrX.fa $arg >${arrayArg[0]}_1.sai;
done

# Perform aln alignment for read2's
for arg in $(ls *read2.fastq);
do
	arrayArg=(${arg//_/ });
	bwa aln chrX.fa $arg >${arrayArg[0]}_2.sai;

	# Convert sai files to sam files
	bwa sampe -r "@RG\tID:${arrayArg[0]}\tSM:${arrayArg[0]}\tLB:lib1\tPL:Illumina\tPU:none" chrX.fa ${arrayArg[0]}_1.sai ${arrayArg[0]}_2.sai ${arrayArg[0]}_chrX_read1.fastq ${arrayArg[0]}_chrX_read2.fastq > ${arrayArg[0]}.sam;
done

# # Convert sam files to bam files
for arg in $(ls *.sam);
do
	arrayArg=(${arg//\./ });
	samtools view -S -b $arg > ${arrayArg[0]}.bam;
done

# #CALCULATE FOLD COVERAGE

# Sort Bam file by coordinate
for arg in $(ls *.bam);
do
	echo "Sorting $arg";
	arrayArg=(${arg//\./ });
	samtools sort $arg > ${arrayArg[0]}_sorted.bam;
done

# Delete Sam files
ls *.sam | xargs rm;

# Creates dictionary file for chrX.fa
$picard CreateSequenceDictionary R=chrX.fa O=chrX.dict

# Mark Duplicates in each sorted bam file
for arg in $(ls *_sorted.bam);
do
	echo "Marking Duplicates for $arg";
	arrayArg=(${arg//\./ });
	$picard MarkDuplicates I=$arg O=${arrayArg[0]}_dedup.bam M=${arrayArg[0]}_dedup.metrics;
done

# Prepare reference index for GATK
echo "Preparing chrX.fa reference index for GATK"
samtools faidx chrX.fa;

# Index each Marked Duplicates bam file
for arg in $(ls *_sorted_dedup.bam);
do
	echo "Indexing $arg";
	samtools index $arg;
done

# Perform GATK data clean up
