# Setup Infrastructure for Eth Holesky

## Install a VM Workstation

 * Create a small VM workstation to run these commands. A cloud shell could be used, but a VM workstation would be better to store files specifically for this deployment.

 * The workstation VM should have Ubuntu 20.04 OS installed.

 * Created an eth user to run commands under

```
sudo useradd -m eth
sudo usermod -aG sudo eth
sudo usermod -aG google-sudoers eth
sudo su eth
bash
cd ~
```
 * Install [common tools](../../common/vm/scripts/install-common-tools.sh) as needed.

## Clone this repo to have the files for deployment.

Confirm the user or service account has access to the [repo](https://source.cloud.google.com/gcda-dev/gcda-node-hosting)

```
gcloud source repos clone gcda-node-hosting --project=gcda-dev
```

## Setup Terraform

Install pre-requisites if needed:

   * Terraform 1.1.7: https://www.terraform.io/downloads.html
   * Google Cloud CLI with kubectl: https://cloud.google.com/sdk/docs/install-sdk#deb
   * Install gcloud components `sudo apt-get update && sudo apt-get install google-cloud-cli kubectl google-cloud-sdk-gke-gcloud-auth-plugin`

1. Create a working directory for your configuration.

    * Choose a workspace name e.g. `mainnet`. Note: this defines Terraform workspace name, which in turn is used to form resource names.
    ```
    export WORKSPACE=testnet
    ```

    * Create a directory for the workspace
    ```
    mkdir -p ~/eth/$WORKSPACE
    ```
2. Create a storage bucket for storing the Terraform state on Google Cloud Storage.  Use the GCP UI or Google Cloud Storage command to create the bucket.  The name of the bucket must be unique.  See the Google Cloud Storage documentation here: https://cloud.google.com/storage/docs/creating-buckets#prereq-cli

  ```
  gsutil mb gs://$BUCKET_NAME
  # for example
  gsutil mb gs://<project-name>-arb-tf
  ```

3. Copy the Ethereum Holesky terraform files
  ```
  cd ~/$WORKSPACE
  cp gcda-node-hosting/ethereum/holesky/terraform/* ./testnet/
  ```

4. Modify `main.tf` file to configure Terraform, and update the BUCKET_NAME. Example content for `main.tf`:
  ```
  terraform {
    backend "gcs" {
      bucket = "BUCKET_NAME" # bucket name created in step 2
      prefix = "state/validator"
    }
  }
  ```

4.5 Update `variables.tf` with project id, region and zone


5. Initialize Terraform in the same directory of your `main.tf` file
  ```
  $ terraform init
  ```
This will download all the Terraform dependencies for you, in the `.terraform` folder in your current working directory.

6. Create a new Terraform workspace to isolate your environments:
  ```
  terraform workspace new $WORKSPACE
  # This command will list all workspaces
  terraform workspace list
  ```

7. Apply the configuration.

  ```
  $ terraform plan
  $ terraform apply
  ```

  This might take a while to finish (10 - 20 minutes), Terraform will create all the resources on your cloud account. 

8. Once Terraform apply finishes, you can check if these resources are created:

    GKE
    * eth-holesky-validator-cluster



## Validator

kubectl exec -i -t consensus-0 --container execution -- /bin/sh
kubectl exec -i -t consensus-0 --container beacon -- /bin/bash

kubectl exec -i -t validator-0 -- /bin/bash
I believe the keys go here: 
cd /opt/validator-data/client/validators


To make changes to validator config and restart:

Modify ~/gcda-node-hosting/ethereum/holesky-validator/k8s/deployment_validator.yaml if you need to change any runtime parameters.  If you do, do the following to apply the changes and restart

kubectl apply -f deployment_validator.yaml

Get pods:
kubectl get pods

To restart pod, delete it and it will automatically restart:
kubectl delete pod validator-0

To get logs:
kubectl logs validator-0

Install software:

apt install 

Instructions to install gcloud: https://cloud.google.com/sdk/docs/install-sdk#deb

Update: 
 - Region
 - Cluster name

Regions:
 - us-central1-a
 - asia-northeast1-a (Tokyo)
 - asia-southeast1-b (singapore)
 - asia-south1-c (Mumbai, India)
 - australia-southeast1-a (Sydney, Australia)
 - europe-west2-a (London)
 - me-west1-a (Tel Aviv)
 - northamerica-northeast2-a (Toronto)
 - southamerica-east1-b (Sao Paulo, Brazil)


 - 1) us-central1-a (Iowa)
 - 2) asia-southeast1-b (Singapore)
 - 3) asia-southeast2-b (Jakarta, Indonesia)
 - 4) asia-south1-c (Mumbai, India)
 - 5) australia-southeast1-a (Sydney, Australia)
 - 6) europe-central2-b (warsaw, Poland)
 - 7) me-west1-a (Tel Aviv)
 - 8) southamerica-east1-c (Sao Paulo, Brazil)
 - 9) southamerica-east1-b (Sao Paulo, Brazil)
  
terraform workspace create cluster2 ...
asia-northeast1-a




