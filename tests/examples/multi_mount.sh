#!/bin/bash
#$ -N global-setup
#$ -v REFGENOME=hg38
#$ -mount data=./data
#$ -mount code=./pipeline

#fffdfd
#$ -N pepatac-run
#$ -I docker.io/continuumio/miniconda3
#$ -l h_vmem=16G
#$ -l h_rt=04:00:00
#$ -pe smp 4
#$ -file ./pipeline/env.yaml
#$ -entrypoint bash
conda env create -f /mnt/code/env.yaml || true
conda activate pepatac
python /mnt/code/run.py --genome $REFGENOME --input /mnt/data/sample.tsv

#$ -N bam-filter
#$ -I docker.io/biocontainers/samtools:v1.9-4-deb_cv1
#$ -after pepatac-run
#$ -l h_vmem=8G
samtools view -b /mnt/data/sample.bam > /mnt/data/sample.filtered.bam
