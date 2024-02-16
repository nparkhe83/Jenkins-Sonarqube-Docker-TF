# Site Deployment on GCP using Jenkins CI/CD

### Terraform IaC configuration to deploy GCP resources

### Jenkins for CI/CD,

### Sonarqube for Quality Scanning before Docker deploys website.

---

## How to use this repo

### Instructions

`./Instructions` folder contains instructions to Setup, Deploy and Cleanup Resources used in this project.

`Makefile` contains many recipes that simplify executing steps listed in the instructions. Run the make commands in terminal at the root directory of the repo as the Makefile resides in the root.

#### Makefile

<details>

<summary> List of Makefile recipes </summary>

Type `make` in the terminal to list recipes that you can use at different steps of implementing this repo.

Using the Makefile recipes you can

- Authorize login to GCP using gcloud
- Authorize Terraform to GCP
- Create GCP Project
- Run Script that deploys GCP resources as per Terraform Config
- Run script to update configuration
- Run script to destroy deployed resources.
- List resources created by Terraform
- List default names used by scripts.
- Enable Git Hook that ties Trello stories to each commit.
- Enable scripts with proper permissions.

</details>

---

### Expected Output

On successful completion of CI/CD pipeline,

- 3 GCP VMs are created
  - VM `ci-server`: Hosts Jenkins CI server that runs the CI/CD platform
  - VM `scanner-server`: Hosts Sonarqube that performs code quality analysis
  - VM `container-server`: Runs Docker image that runs an nginx webserver
- Website is deployed at IP address of `container-server`

---

### Best Practices Used:

- IAC (Terraform) used to create GCP resources.
- GCP VM instances are preconfigured with Jenkins, Sonarqube and Docker using Startup scripts hosted in GCP Cloud Storage
- Individual scripts to Create, Destroy and Update limit user interaction to supplying Project_ID and bucket_id and region.
- Git Commits are required to map to a story-id.
- GCP VMs are created on pre-emptible spot instances to keep GCP billing charges to a minimum.

---

### Terraform vs. gcloud CLI in Bash Scripts: A Clear Advantage

#### Conciseness and Maintainability:

- Effortlessly replaced over 400 lines of intricate shell scripting with a remarkably concise and maintainable Terraform configuration. This streamlining translates to significant time savings in both initial setup and ongoing management.

#### Declarative Nature Streamlines Execution:

- Eliminated the need for meticulous debugging and command ordering, which were previously required with manual gcloud interactions. Terraform's declarative approach ensures accurate execution by intelligently determining the optimal sequence of actions, freeing up valuable time and reducing the risk of errors.

<br>

---

### Deployment choices made to minimise GCP Costs

Spot VMs with life of only 2 hours are used to deploy Jenkins, Sonarqube and Docker.

These VMs are Spot Preemptible instances. However, they will incur charges.

Rest of the resources created like startup scripts stored on GCP are negligible in cost. Hence, you can keep them.

However, project created will be counted against your Projects quota and billing quota.
Hence, it is advisable to delete these when no longer required using instructions listed in ./instructions/cleanup-instructions.md
