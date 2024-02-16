
# define standard colors
ifneq (,$(findstring xterm,${TERM}))
	RED          := $(shell tput -Txterm setaf 1)
	GREEN        := $(shell tput -Txterm setaf 2)
	RESET := $(shell tput -Txterm sgr0)
else
	RED          := ""
	GREEN        := ""
	RESET        := ""
endif


PROJECT_NAME=jsd-with-terraform4

.PHONY: help
help:
	@echo "================================================================"
	@echo "${GREEN}help${RESET}: Show this help message"

	@echo "\nMiscellaneous:"
	@echo "${GREEN}  enforce_story-id${RESET}: Configure Pre-commit hook to enforce story id in commit message."
	@echo "${GREEN}  enable_scripts${RESET}: Enable scripts to be executed"

	@echo "\nAuthentication and Authorization:"
	@echo "${GREEN}  login_gcp${RESET}: Login to GCP"
	@echo "${GREEN}  authorize_terraform${RESET}: Authorize Terraform"
	
	@echo "\nGCP:"
	@echo "${GREEN}  init_gloud${RESET}: Initialize Gcloud"
	@echo "${GREEN}  create_gcp_project${RESET}: Create a new GCP project. Change the project name in the Makefile."

	@echo "\nTerraform:"
	@echo "${GREEN}  initialize_terraform: Initialize Terraform"
	@echo "${GREEN}  migrate_terraform_state${RESET}: Migrate Terraform state"
	@echo "${GREEN}  change_terraform_backend${RESET}: Change Terraform backend"
	
	@echo "\nScripts:"
	@echo "${GREEN}  list_default_values${RESET}: List default values to use when creating project"
	@echo "${GREEN}  create_resources${RESET}: Create resources in GCP"
	@echo "${GREEN}  clear_resources${RESET}: Destroy resources in GCP"
	@echo "${GREEN}  destroy_tf_resources${RESET}: Destroy resources created by Terraform in GCP. Does not remove project and storage bucket used by Terraform backend"
	@echo "${GREEN}  update_configuration${RESET}: Update configuration in GCP"
	@echo "${GREEN}  list_resources${RESET}: List resources in GCP"

	@echo "\nGet URLs:"
	@echo "${GREEN}  get_jenkins_url${RESET}: Get Jenkins Server URL"
	@echo "${GREEN}  get_webhook_url${RESET}: Get webhook URL for github to push updates to Jenkins server"
	@echo "${GREEN}  get_sonarqube_url${RESET}: Get Sonarqube Server URL"
	@echo "${GREEN}  get_website_url${RESET}: Get website URL"
	@echo "================================================================"

.PHONY: login_gcp
login_gcp:
	@echo "Logging in to GCP"
	@gcloud auth login

.PHONY: authorize_terraform
authorize_terraform:
	@echo "Authorizing GCP"
	@gcloud auth application-default login

.PHONY: enforce_story-id
enforce_story-id:
	@echo "Configure Pre-commit hook to enforce story id in commit message."
	@cd scripts && chmod +x enforce-story-id.sh
	@cd scripts && sh enforce-story-id.sh


.PHONY: init_gcloud
init_gcloud:
	@echo "Initializing Gcloud"
	@gcloud init

.PHONY: create_gcp_project
create_gcp_project:
	@echo "Assuming gcloud works on your machine. If not, please install it first."
	@gcloud projects create $(PROJECT_NAME) --name=$(PROJECT_NAME)
	@sed -i '' -e "s/project_name=\(.*\)/project_name=${PROJECT_NAME}/g" scripts/default-values.sh

.PHONY: create_resources
create_resources:
	@echo "Creating resources in GCP"
	@cd scripts && tf-create.sh

.PHONY: clear_resources
clear_resources:
	@echo "Destroying resources in GCP"
	@cd scripts && export PATH=$PATH:$(pwd)
	@cd scripts && tf-destroy.sh

.PHONY: destroy_tf_resources
destroy_tf_resources:
	@echo "Destroying resources in GCP"
	@cd terraform-config && terraform destroy

.PHONY: update_configuration
update_configuration:
	@echo "Updating configuration in GCP"
	@cd scripts && tf-update.sh

.PHONY: list_resources
list_resources:
	@echo "Listing resources in GCP"
	@cd terraform-config && terraform show

.PHONY: list_default_values
list_default_values:
	@echo "Listing default values"
	@cd scripts && cat default-values.sh

.PHONY: enable_scripts
enable_scripts:
	@cd scripts && chmod +x *.sh
	@export PATH=$PATH:$(pwd)/scripts

.PHONY: initialize_terraform
initialize_terraform:
	@echo "Initializing Terraform"
	@cd terraform-config && terraform init

.PHONY: migrate_terraform_state
migrate_terraform_state:
	@echo "Migrating Terraform state"
	@cd terraform-config && terraform init --migrate-state


.PHONY: change_terraform_backend
change_terraform_backend:
	@echo "Changing Terraform backend"
	@cd terraform-config && terraform init --backend-config=backend.hcl --migrate-state

.PHONY: get_jenkins_url
get_jenkins_url:
	@echo "Getting Jenkins server URL"
	@cd terraform-config && terraform output -raw jenkins_url

.PHONY: get_webhook_url
	@echo "getting webhook URL for github to push updates to Jenkins server"
	@cd terraform-config && terraform output -raw jenkins-webhook-url

.PHONY: get_sonarqube_url
	@echo "getting sonarqube server URL"
	@cd terraform-config && terraform output -raw sonarqube-url

.PHONY: get_website_url
	@echo "getting website URL"
	@cd terraform-config && terraform output -raw docker-url