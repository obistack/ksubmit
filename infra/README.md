# KSubmit Infrastructure

Repository: [github.com/obistack/ksubmit/infra](https://github.com/obistack/ksubmit/infra)

---

## Prerequisites

- Install [Pulumi CLI](https://www.pulumi.com/docs/get-started/install/)
- Install [Google Cloud SDK (gcloud)](https://cloud.google.com/sdk/docs/install)
- Install Python 3.7+ and pip

---

## Authentication Setup

Pulumi requires valid Google Cloud credentials to provision resources.

You have two options:

### Option 1: Use gcloud Application Default Credentials

Run this command and follow the browser login flow:

```bash
gcloud auth application-default login
```

### Option 2: Use a Service Account Key JSON

Create a service account in GCP with required roles (e.g., Storage Admin, IAM Workload Identity User).

Download the JSON key file.

Set environment variable to point to the key file:

```bash
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/key.json"
```

Pulumi will automatically use the credentials from this environment variable.

## Clone the Repository

```bash
git clone https://github.com/obistack/ksubmit.git
cd ksubmit/infra
```

## Setup Python Environment

Install dependencies:

```bash
pip install -r requirements.txt
```

## Pulumi Setup

### Login with Local Backend (No Pulumi Account Needed)

```bash
pulumi login --local
```

### Initialize a New Stack

```bash
pulumi stack init dev
```

## Configuration

Set required config values:

| Key | Description | Example |
|-----|-------------|---------|
| project | Your GCP project ID | my-gcp-project |
| region | GCP region (optional) | us-central1 |
| bucketName | Name of GCS scratch bucket | scratchspaces |
| mode | Deployment mode: admin or user | admin or user |
| username | Kubernetes namespace (user mode) | johnsmith (only in user mode) |
| user_email | User email (user mode) | john_smith_example_com |

Set config commands example:

```bash
pulumi config set project my-gcp-project
pulumi config set bucketName scratchspaces
pulumi config set mode admin
```

For user mode:

```bash
pulumi config set mode user
pulumi config set username johnsmith
pulumi config set user_email john_smith@example_com
```

## Deploying Infrastructure

Run the Pulumi deployment:

```bash
pulumi up
```

Review the preview output.

Confirm to apply changes.

## Destroying Resources

To tear down created resources:

```bash
pulumi destroy
```

## Modes Explained

### Admin Mode (mode=admin)

- Creates GCP Service Account for storage access.
- Creates GCS bucket (if not existing).
- Grants storage admin role to service account on bucket.
- Creates Kubernetes namespace ksubmit-admin.
- Creates Kubernetes service account annotated with GCP service account email.
- Configures Workload Identity binding.
- Creates global PersistentVolume and PersistentVolumeClaim.
- Deploys storage transfer helper deployment.

### User Mode (mode=user)

- Creates a Kubernetes namespace named after the user.
- Creates a PersistentVolume scoped to user's bucket path scratchspaces/<username>.
- Creates a PersistentVolumeClaim in the user namespace bound to the user PV.
- Labels namespace with user email (replacing @ with _).
- Designed for per-user scratch space isolation.

## Verification

Use kubectl to check namespaces, pods, PVCs, and PVs.

Example:

```bash
kubectl get namespaces
kubectl get pv
kubectl get pvc -n <namespace>
kubectl get pods -n ksubmit-admin
```

Use gcloud to verify IAM bindings and bucket existence.

## Notes

- Ensure your kubeconfig is set to the target Kubernetes cluster before running Pulumi.
- Use pulumi config set to switch between admin and user modes.
- To manage multiple users, run Pulumi in user mode with different username and user_email configs.

## Troubleshooting

If you see credential errors, ensure you have run either:

```bash
gcloud auth application-default login
```

or set:

```bash
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/key.json"
```

Confirm kubectl context points to the correct cluster:

```bash
kubectl config current-context
```

## Contact & Support

For issues, raise tickets on the repository or contact the infrastructure team.