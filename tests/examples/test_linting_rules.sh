#!/bin/bash

# Test case 1: Job block doesn't start with an image directive
#$ -N test-case-1
#$ -I docker.io/library/python:3.10
#$ -v MSG1="This job block doesn't start with an image directive"
echo "$MSG1"

# Test case 2: Job name directive doesn't immediately follow the image directive
#$ -I docker.io/library/python:3.10
#$ -v MSG2="This directive is between -I and -N"
#$ -N test-case-2
echo "$MSG2"

# Test case 3: Correct job block (for comparison)
#$ -I docker.io/library/python:3.10
#$ -N test-case-3
#$ -v MSG3="This job block follows the rules"
echo "$MSG3"