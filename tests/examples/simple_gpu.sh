#!/bin/bash
#$ -N train-model
#$ -I docker.io/pytorch/pytorch:2.0.1-cuda11.7-cudnn8-runtime
#$ -l h_vmem=32G
#$ -l h_rt=12:00:00
#$ -pe smp 8
#$ -gpus 1
#$ -retry 2
#$ -mount model=./model_checkpoints
#$ -labels project=vision,owner=team-a
#$ -workdir /mnt/model

python train.py --data /mnt/input/images --epochs 50
