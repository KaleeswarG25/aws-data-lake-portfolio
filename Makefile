.PHONY: init plan apply destroy test fmt validate sample upload clean

init:
    cd terraform && terraform init

plan:
    cd terraform && terraform plan

apply:
    cd terraform && terraform apply -auto-approve

destroy:
    cd terraform && terraform destroy -auto-approve

fmt:
    terraform fmt -recursive terraform/

validate:
    cd terraform && terraform validate

test:
    python -m pytest tests/ -v

sample:
    python scripts/generate_sample_data.py

upload: sample
    aws s3 cp data/sample.csv s3://$(cd terraform && terraform output -raw raw_bucket_name)/raw/sample.csv

clean:
    rm -rf data/sample.csv
