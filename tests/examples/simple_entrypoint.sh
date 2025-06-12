#!/bin/bash
# Test script for entrypoint handling

# Case 1: No entrypoint override (single command)
#$ -N test-no-entrypoint
#$ -I ubuntu:latest

echo "Hello from default entrypoint"

# Case 2: User overrides entrypoint
#$ -N test-with-entrypoint
#$ -I ubuntu:latest
#$ -entrypoint bash

echo "Hello from bash entrypoint"
echo "This is a multi-line command"

# Case 3: Shell wrapping fallback (multiple commands)
#$ -N test-shell-wrapping
#$ -I ubuntu:latest

echo "First command"
echo "Second command"
echo "Third command"
