PROJECT_NAME=jsd-with-terraform4

.PHONY: help
help:
	@echo "help: Show this help message"
	@echo "create_gcp_project: Create a new GCP project. Change the project name in the Makefile."

.PHONY: create_gcp_project
create_gcp_project:
	@echo "Assuming gcloud works on your machine. If not, please install it first."
	@gcloud projects create $(PROJECT_NAME) --name=$(PROJECT_NAME)
	@sed -i '' -e "s/project_name=\(.*\)/project_name=${PROJECT_NAME}/g" scripts/default-values.sh