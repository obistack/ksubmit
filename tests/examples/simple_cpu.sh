#!/bin/bash

#$ -I docker.io/library/python:3.10
#$ -N hello-world
#$ -l h_vmem=9G
#$  -l h_rt=00:19:00
#$          -pe smp 5
#$ -v MSG="Hello from ksub"
#$ -ttl 600
#$ -mount docs=./docs --overwrite
#$ -mount user=./ksub/admin/user --overwrite
#$ -mount test=./ksub/admin/cluster --overwrite
echo "$MSG"


#$ -I docker.io/library/python:3.10
#$ -l h_vmem=2G
#$ -N hello-world-2
#$ -v MSG2="Hello from ksub"
echo "$MSG2"