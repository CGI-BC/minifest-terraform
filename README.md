# minifest-terraform

Terraform + Terragrunt starter for a codefest.

## Prerequisites

Install these tools before anything else:

### Terraform
https://developer.hashicorp.com/terraform/install

Download the package for your OS, unzip it, and move the binary to somewhere on your PATH.

**Verify:**
```bash
terraform -version
```

### Terragrunt
https://github.com/gruntwork-io/terragrunt/releases

Download the binary for your OS, rename it to `terragrunt`, and move it to somewhere on your PATH (same place as Terraform).

**Verify:**
```bash
terragrunt -version
```

### AWS CLI
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

Follow the installer for your OS (Windows/Mac/Linux options on that page).

**Verify:**
```bash
aws --version
```

---

## Registry

All documentation for services and AWS provider:

https://registry.terraform.io

---

## Structure

```
minifest-terraform/
├── services/               ← your .tf files live here
│   ├── infrastructure.tf   ← terraform version + data sources
│   ├── variables.tf        ← input variables
│   └── s3.tf               ← add service files here (ec2.tf, rds.tf, etc.)
│
└── terraform/              ← terragrunt configs
    ├── terragrunt.hcl      ← parent: sources services/, generates backend + provider + common tfvars
    ├── dev/
    │   └── terragrunt.hcl  ← include parent + dev-specific tfvars
    ├── test/
    │   └── terragrunt.hcl
    └── prod/
        └── terragrunt.hcl
```

The parent `terraform/terragrunt.hcl` generates `provider.tf`, `backend.tf`, and shared tfvars for every environment. Each env dir only needs to define its own resource-specific values.

---

## Connecting to AWS

**Step 1 — Log in to the AWS Console:**

Your account admin should have given you:
- A console login URL in this format: `https://<account-id>.signin.aws.amazon.com/console`
- Your IAM **username** and **password**

Go to that URL, sign in, and change your password if prompted.

**Step 2 — Get your access keys:**

1. Click your username in the top-right corner → **Security credentials**
2. Scroll to **Access keys** → click **Create access key**
3. Choose **Command Line Interface (CLI)** → **Next** → **Create access key**
4. Copy your **Access Key ID** and **Secret Access Key** — you won't see the secret again

**Step 3 — Configure the CLI:**

```bash
aws configure

# Enter when prompted:
#   AWS Access Key ID:     AKIA...
#   AWS Secret Access Key: your-secret
#   Default region:        ca-central-1
#   Default output format: json

# Verify it works
aws sts get-caller-identity
```

> `aws sts get-caller-identity` should return your account ID and user/role ARN. If it does, you're ready to run Terragrunt.

---

## Setup

1. Edit `project_name` and `aws_region` in [terraform/terragrunt.hcl](terraform/terragrunt.hcl).
2. Create the S3 bucket and DynamoDB table for remote state.

**Why?** Terraform needs somewhere to store its state file — a record of everything it has deployed. Without it, Terraform has no idea what already exists in AWS.
- **S3** stores the state file so your whole team shares the same view of what's deployed (instead of it living only on one person's laptop)
- **DynamoDB** acts as a lock so two people can't run `apply` at the same time and corrupt the state

Run these once before your first `terragrunt init`:

```bash
aws s3api create-bucket --bucket terraform-remote-state-<project>-<env> --region ca-central-1 \
  --create-bucket-configuration LocationConstraint=ca-central-1

aws s3api put-bucket-versioning --bucket terraform-remote-state-<project>-<env> \
  --versioning-configuration Status=Enabled

aws dynamodb create-table --table-name terraform-remote-state-lock-<project> \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST --region ca-central-1
```

---

## Commands

Run these from an env directory (`terraform/dev/`, `terraform/test/`, or `terraform/prod/`):

| Command | What it does |
|---------|-------------|
| `terragrunt init` | Downloads the AWS provider and connects to the S3 remote state backend. Run this first, and any time you add a new provider. |
| `terragrunt plan` | Shows you exactly what will be created, changed, or destroyed — without touching anything. Always run this before apply. |
| `terragrunt apply` | Builds the infrastructure in AWS. Asks for confirmation before making changes. |
| `terragrunt destroy` | Tears down everything Terraform deployed. Use with caution — this deletes real resources. |

```bash
terragrunt init
terragrunt plan
terragrunt apply
terragrunt destroy

