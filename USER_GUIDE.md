# KSUB: Kubernetes Job Submission Tool with Shorthand Commands

## Introduction

KSUB (pronounced "sub" - the 'k' is silent, like in "knife") is a Python-based CLI tool that simplifies submitting batch jobs to Kubernetes clusters using a familiar syntax inspired by Univa Grid Engine (UGE). It bridges the gap between traditional HPC job submission systems and modern Kubernetes orchestration, making it easier for users to transition their workloads to Kubernetes without having to learn complex YAML specifications.

## UGE Inspiration

KSUB is heavily inspired by Univa Grid Engine (UGE) and similar HPC job schedulers. This inspiration is evident in several aspects:

1. **Directive Syntax**: KSUB uses the familiar `#$` directive syntax in job scripts, making it immediately familiar to UGE users.
   ```bash
   #$ -N my-job        # Job name (same as UGE)
   #$ -l h_vmem=4G     # Memory request (same syntax as UGE)
   #$ -l h_rt=01:00:00 # Runtime limit (same syntax as UGE)
   #$ -pe smp 2        # CPU request (same syntax as UGE)
   ```

2. **Resource Specification**: The way resources are requested (memory, CPU, runtime) follows UGE conventions.

3. **Job Management Workflow**: The overall workflow of writing a script, submitting it, and monitoring its progress mirrors the UGE experience.

## Key Differences from UGE

While KSUB maintains familiar syntax and workflows, it adds several modern features that go beyond traditional UGE capabilities:

1. **Container-Based Execution**: Unlike UGE which typically runs jobs directly on hosts, KSUB runs every job in a container, specified with the `-I` directive:
   ```bash
   #$ -I docker.io/library/python:3.10
   ```

2. **Simplified Storage Mounting**: KSUB provides easy ways to mount local and cloud storage into job containers:
   ```bash
   #$ -mount data=./data
   #$ -remote-mount reference=gs://my-bucket/reference-data
   ```

3. **GPU Support**: Native support for requesting GPUs with a simple directive:
   ```bash
   #$ -gpus 1
   ```

4. **Job Dependencies**: More flexible job dependency management:
   ```bash
   #$ -after job-a,job-b
   ```

5. **Custom Entrypoints**: Ability to override container entrypoints:
   ```bash
   #$ -entrypoint bash
   ```

6. **Kubernetes Integration**: Full access to Kubernetes features like labels, annotations, and namespaces:
   ```bash
   #$ -labels project=ml,env=dev
   ```

7. **Run Management**: KSUB introduces the concept of "runs" that group related jobs together, making it easier to manage complex workflows.

## CLI Commands and Usage

KSUB provides a set of shorthand commands that follow the pattern `k<command>`. Here's a comprehensive guide to these commands:

### Initialization and Configuration

#### `kinit`
Initializes user configuration for submitting jobs via Kubernetes.

```bash
kinit
kinit --namespace my-namespace --email user@example.com
```

This command:
- Selects Kubernetes cluster context
- Asks for email and normalizes it for use as a label
- Checks that user namespace exists
- Verifies namespace is labeled correctly
- Checks admin storage transfer pod exists
- Verifies shared volume mounts
- Saves configuration

#### `kconfig`
Manages KSUB configuration.

```bash
# View all configuration
kconfig list

# Get a specific configuration value
kconfig get namespace

# Set a configuration value
kconfig set namespace my-namespace

# Reset configuration
kconfig reset
```

#### `kversion`
Displays the current version of KSUB.

```bash
kversion
```

### Job Submission

#### `krun`
Parses a job script with UGE-like directives and submits it to Kubernetes.

```bash
krun my_script.sh
krun my_script.sh --dry-run  # Generate YAML but don't submit
krun my_script.sh --watch    # Watch job progress after submission
```

Options:
- `--dry-run, -d`: Generate YAML but don't submit
- `--overwrite`: Overwrite existing directories in destination
- `--watch, -w`: Watch job progress after submission
- `--timeout`: Timeout in seconds when watching job
- `--output, -o`: Output format (table, json)

### Job Management

#### `kls`
Lists submitted jobs in your namespace.

```bash
kls                      # List all jobs
kls --status running     # Filter by status
kls --label project=ml   # Filter by label
kls --run run-12345abc   # Filter by run ID
```

#### `klist`
Lists all runs and their associated jobs.

```bash
klist
klist --limit 10         # Show only 10 most recent runs
klist --output json      # Output in JSON format
```

#### `kstat`
Gets the status of a job or all jobs in a run.

```bash
kstat job-12345          # Status of a specific job
kstat run-12345abc       # Status of all jobs in a run
kstat run-12345abc --output json  # Output in JSON format
```

#### `klogs`
Shows logs of a completed or running job.

```bash
klogs job-12345          # View logs of a specific job
klogs run-12345abc       # View logs of all jobs in a run
klogs job-12345 --follow # Follow logs in real-time
klogs job-12345 --output-file logs.txt  # Save logs to file
```

#### `kdesc`
Shows detailed information about a job or all jobs in a run.

```bash
kdesc job-12345          # Describe a specific job
kdesc run-12345abc       # Describe all jobs in a run
kdesc job-12345 --yaml   # Show full YAML specification
```

#### `kdel`
Deletes a submitted job or all jobs in a run.

```bash
kdel job-12345           # Delete a specific job
kdel run-12345abc        # Delete all jobs in a run
kdel run-12345abc --force # Delete without confirmation
```

#### `klint`
Lints job scripts for errors.

```bash
klint my_script.sh
klint my_script.sh --strict  # Treat warnings as errors
```

## Job Script Directives

KSUB job scripts use UGE-like directives that start with `#$`. Here are the supported directives:

### Important Directive Ordering Rules

> **⚠️ IMPORTANT:** 
> 1. Every job **MUST** have a name (using the `-N` directive)
> 2. Every job block **MUST** start with an image directive (`-I`)
> 3. The job name directive (`-N`) **MUST** immediately follow the image directive
> 4. No directives are allowed between `-I` and `-N`

For example, this is the correct order:
```bash
#$ -I ubuntu:latest
#$ -N my-job
#$ -l h_vmem=4G
```

| Directive                      | Description                   | Example                                                    |
|--------------------------------|-------------------------------|------------------------------------------------------------|
| `-N <name>`                    | Job name                      | `#$ -N my-job`                                             |
| `-I <image>`                   | Container image               | `#$ -I ubuntu:latest`                                      |
| `-l h_vmem=<mem>`              | Memory request                | `#$ -l h_vmem=4G`                                          |
| `-l h_rt=<dur>`                | Runtime limit                 | `#$ -l h_rt=01:00:00`                                      |
| `-pe smp <n>`                  | CPU request                   | `#$ -pe smp 2`                                             |
| `-v VAR=val,...`               | Environment variables         | `#$ -v DEBUG=1,LOG_LEVEL=info`                             |
| `-mount name=path`             | Mount local path              | `#$ -mount data=./data`                                    |
| `-retry <n>`                   | Retry job up to n times       | `#$ -retry 3`                                              |
| `-after job-a,...`             | Job dependencies              | `#$ -after prepare-data`                                   |
| `-entrypoint <cmd>`            | Override container entrypoint | `#$ -entrypoint bash`                                      |
| `-workdir <path>`              | Set working directory         | `#$ -workdir /app`                                         |
| `-remote-mount reference=path` | Mount remote storage          | `#$ -remote-mount reference=gs://my-bucket/reference-data` |
| `-gpus <n>`                    | Request n NVIDIA GPUs         | `#$ -gpus 1`                                               |
| `-labels k=v,...`              | Apply Kubernetes labels       | `#$ -labels project=ml,env=dev`                            |
| `-ttl <seconds>`               | Time to keep Job object       | `#$ -ttl 3600`                                             |

## Simple Example Workflow

Let's walk through a complete example of using KSUB from initialization to job submission and management:

### 1. Initialize KSUB

```bash
kinit
```

This will set up your configuration for submitting jobs.

### 2. Create a Simple Job Script (hello.sh)

```bash
#!/bin/bash
#$ -I docker.io/library/python:3.10
#$ -N hello-world
#$ -l h_vmem=2G
#$ -l h_rt=00:10:00
#$ -pe smp 1
#$ -v MSG="Hello from ksub"

echo "$MSG"
```

### 3. Submit the Job

```bash
krun hello.sh
```

Expected output:
```
Processing script: hello.sh
📄 Parsed 1 job block(s).
✅ All 1 job(s) have been submitted successfully.

Your run run-12345abc has been stored in database.
Use this run ID to manage all jobs in this submission:
  • Check status: kstat run-12345abc
  • View logs: klogs run-12345abc
  • Get details: kdesc run-12345abc
  • Delete jobs: kdel run-12345abc
  • List all runs: klist
```

### 4. Check Job Status

```bash
kstat run-12345abc
```

Expected output:
```
Jobs in Run run-12345abc
┌────────────┬──────────────────┬─────────┬─────────────────────┬──────────┐
│ Run/Job    │ Job ID           │ Status  │ Start Time          │ Duration │
│ Name       │                  │         │                     │          │
├────────────┼──────────────────┼─────────┼─────────────────────┼──────────┤
│ hello-world│ job-abcdef123456 │ Running │ 2023-06-01 12:34:56 │ 00:01:23 │
└────────────┴──────────────────┴─────────┴─────────────────────┴──────────┘
```

### 5. View Job Logs

```bash
klogs run-12345abc
```

Expected output:
```
===== Logs for job: hello-world (job-abcdef123456) =====

Hello from ksub
```

### 6. Get Detailed Job Information

```bash
kdesc run-12345abc
```

This will show detailed information about the job, including resource usage, pod status, and more.

### 7. Delete the Job When Done

```bash
kdel run-12345abc
```

Expected output:
```
Are you sure you want to delete 1 job in run run-12345abc? [y/N]: y
Deleting job: hello-world (job-abcdef123456)... Done
All jobs in run run-12345abc have been processed.
```

## Conclusion

KSUB provides a user-friendly interface for submitting and managing Kubernetes jobs, bridging the gap between traditional HPC job submission systems like UGE and modern container orchestration. With its intuitive UGE-like syntax and comprehensive command set, KSUB makes it easy to transition workloads to Kubernetes without having to learn complex YAML specifications.

By using KSUB, users can focus on their computational tasks rather than the intricacies of Kubernetes job configuration, leading to increased productivity and more efficient resource utilization.
