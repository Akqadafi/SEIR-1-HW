# Terraform GCP Lab

## What This Lab Does

This lab uses Terraform to build a small proof-of-concept setup in Google Cloud. The main thing it creates is a GCP VPC network. It also uses Terraform to create a local text file with my favorite food in it.

The point of the lab is to show that Terraform can manage both cloud resources and local resources from the same configuration. It demonstrates the basic workflow: write the code, initialize Terraform, validate it, apply it, and confirm the output.

## How I Built It

### 1. Repo Setup

I started by creating a new GitHub repository for this lab and cloning it to my local machine. I also added a `.gitignore` file so Terraform state files, the `.terraform` folder, and other local files do not get pushed to GitHub.

This avoids uploading files that should stay local.

### 2. Provider Configuration

I used the Terraform Registry to check the current Google provider documentation. The Google provider is what allows Terraform to communicate with GCP and create resources there.

I also added the local provider because this lab required Terraform to create a text file on my machine.

### 3. GCP VPC Network

For the VPC, I used the `google_compute_network` resource from the Terraform documentation.

I set:

```hcl
auto_create_subnetworks = false
```

This means GCP will not automatically create subnets for me. 

### 4. Local File Resource

I used the `local_file` resource to create a basic text file. The file contains my favorite food.

This part of the lab shows that Terraform is not only for cloud infrastructure. It can also create and manage local files as part of the same workflow.

### 5. Output Block

I added an output block in `outputs.tf` to print the name of the VPC after Terraform finishes applying the configuration.

This makes the result easier to verify from the terminal.

## How to Run This Lab

From the project folder, run:

```bash
terraform init
terraform validate
terraform plan -var="project_id=YOUR_PROJECT_ID"
terraform apply -var="project_id=YOUR_PROJECT_ID"
```

Replace `YOUR_PROJECT_ID` with your actual GCP project ID.

After the apply finishes, Terraform should show the VPC name in the output. It should also create the local text file.

## Documentation Used

- Terraform Google Provider: https://registry.terraform.io/providers/hashicorp/google/latest/docs
- `google_compute_network` resource: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
- Terraform Local Provider: https://registry.terraform.io/providers/hashicorp/local/latest/docs
- `local_file` resource: https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file

## Issues Encountered

The main thing I had to pay attention to was making sure the provider configuration matched my GCP project and that Terraform could authenticate correctly.

I also had to remember that putting something in a variable description does not assign the value. If I want Terraform to automatically use a value, I either need to set a default value or put the value in a `terraform.tfvars` file.

## What I Learned

This lab helped reinforce the basic Terraform workflow by showing how Terraform resources are referenced by their Terraform resource names not just by the names of the cloud resources.

It also helped me understand the difference between provider configuration, resource creation, and outputs. Even though this was a small lab, it connects to the same skills used in larger infrastructure projects.
