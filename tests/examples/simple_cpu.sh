#!/bin/bash

#$ -I docker.io/library/python:3.10
#$ -N hello-world
#$ -l h_vmem=9G
#$  -l h_rt=00:19:00
#$          -pe smp 5
#$ -v MSG="Hello from ksubmit"
#$ -ttl 600
#$ -mount docs=./docs --overwrite
#$ -mount user=./ksubmit/admin/user --overwrite
#$ -mount test=./ksubmit/admin/cluster --overwrite
echo "$MSG"


#$ -I docker.io/library/python:3.10
#$ -N hello-world-2
#$ -l h_vmem=2G
#$ -v MSG2="Hello from ksubmit"
echo "$MSG2"