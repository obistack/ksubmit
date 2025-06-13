#!/bin/bash
#$ -N mount-overwrite-test
#$ -I docker.io/library/python:3.10
#$ -l h_vmem=9G
#$ -l h_rt=00:19:00
#$ -pe smp 5
#$ -v MSG="Testing mount overwrite"
#$ -ttl 600
#$ -mount docs=./docs
#$ -mount user=./ksubmit/admin/user --overwrite
#$ -mount test=./ksubmit/admin/cluster
#$ -remote-mount test=gs://my-bucket/test

echo "$MSG"

ls /mnt/cloud/test

python /mnt/cloud/test/test.input