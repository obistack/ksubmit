#!/bin/bash
# Test script for entrypoint handling

# Case 1: No entrypoint override (single command)
#$ -I ubuntu:latest
#$ -N test-no-entrypoint

echo "Hello from default entrypoint"

# Case 2: User overrides entrypoint
#$ -I ubuntu:latest
#$ -N test-with-entrypoint
#$ -entrypoint bash

echo "Hello from bash entrypoint"
echo "This is a multi-line command"

# Case 3: Shell wrapping fallback (multiple commands)

#$ -I ubuntu:latest
#$ -N test-shell-wrapping

echo "First command"
echo "Second command"
echo "Third command"
