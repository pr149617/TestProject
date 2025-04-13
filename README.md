
# GCP Infrastructure Deployment using Jenkins CI/CD and Terraform

This project demonstrates how to automate the deployment of a Google Cloud infrastructure (VPC, Subnet, and VM instance) using a Jenkins pipeline integrated with Terraform.

---

## 📂 Project Structure

```
![image](https://github.com/user-attachments/assets/4ee61353-86ff-4b2a-b17a-10fcd417809c)

```

---

## 🛠️ What This Project Does

- Provisions a **Custom VPC**
- Creates a **Subnet** inside the VPC
- Deploys a **Compute Engine VM instance** connected to the Subnet
- Uses **Jenkins Pipeline** to automate the deployment process
- Uses **Terraform** as Infrastructure as Code (IaC)

---

## 🔧 Jenkinsfile Explanation

```groovy
pipeline {
    agent any

    environment {
        GIT_TOKEN = credentials('git-auth')                        // GitHub access token (if required for private repo)
        GOOGLE_APPLICATION_CREDENTIALS = credentials('gcp-auth')   // Service account key for GCP authentication
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/pr149617/TestProject.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                    terraform init
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh '''
                    terraform plan
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: "Approve Terraform Apply?"
                sh '''
                    terraform apply -auto-approve
                '''
            }
        }
    }
}
```
#### PipeLine Configuration in Jenkins Console.

![image](https://github.com/user-attachments/assets/164a964a-cd9b-43fb-9b80-84e282da52ff)


### 💡 How Jenkins Pipeline Works:
- **Git Checkout**: Clones the `main` branch from GitHub
- **Terraform Init**: Initializes Terraform in the working directory
- **Terraform Plan**: Shows execution plan to preview changes
- **Terraform Apply**: Provisions infrastructure after manual approval

---

## 📄 Terraform `main.tf` Explanation

```hcl
provider "google" {
  project = "Your-Project-name"
}
```

Sets up GCP provider and points to the specific project.

```hcl
resource "google_compute_network" "TestVPC" {
  name = "customvpc"
  auto_create_subnetworks = false
  description = "customPVC for creation"
}
```

Creates a custom Virtual Private Cloud (VPC) without auto subnet creation.

```hcl
resource "google_compute_subnetwork" "testsubnet" {
  name          = "test-subnetwork"
  ip_cidr_range = "10.0.0.0/24"
  region        = "us-central1"
  network       = google_compute_network.TestVPC.id
}
```

Creates a subnet inside the above VPC with a specific CIDR block.

```hcl
resource "google_compute_instance" "TestVM" {
  name         = "my-instance"
  machine_type = "n2-standard-2"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.testsubnet.id
  }
}
```

Creates a virtual machine in the subnet with Debian 11 image and connects it to the defined network.

---

## 🔐 Prerequisites

- A GCP service account with appropriate IAM permissions:
  - `Compute Admin`
  - `Service Account User`
- Jenkins with the following configured:
  - Git plugin
  - Terraform plugin or Terraform binary installed
  - Credentials added for:
    - `gcp-auth`: GCP service account JSON File
    - `git-auth`: GitHub token (if private repo)

---

## 📌 Notes

- Ensure APIs are enabled in GCP: Compute Engine, IAM, Cloud Resource Manager
- Adjust regions, machine types, or image names as per your requirement
- Don't store credentials inside your Terraform code; Jenkins should inject them securely

---

## 📎 Example Jenkins Credentials

| ID         | Type             | Purpose                    |
|------------|------------------|----------------------------|
| gcp-auth   | Secret File      | GCP service account key    |
| git-auth   | Secret Text      | GitHub personal access token |

![image](https://github.com/user-attachments/assets/55cf65ac-1837-4249-81b0-c8843c464ed5)


---


## ✅ Result

Once the pipeline completes, you’ll have:
- A custom VPC
- A dedicated subnet
- A Debian VM deployed and networked in GCP

---


