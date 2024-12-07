# Terraform AWS Infrastructure

## Overview
This repository contains Terraform code to manage AWS resources using GitHub Actions for CI/CD.

## Setup
1. Create an IAM user with MFA and necessary permissions.
2. Set up GitHub Secrets for AWS credentials:
   - `AWS_ROLE_ARN`: The ARN of the IAM role.
   - `AWS_REGION`: The AWS region where resources are deployed.
3. Configure the workflow to trigger on push or pull request to the main branch.

## Running the Workflow
The GitHub Actions workflow runs the following:
- **Check**: Checks Terraform formatting.
- **Plan**: Plans the deployment.
- **Apply**: Applies the Terraform changes if on the main branch.

## Verification
To verify the setup:
1. Execute Terraform plans to ensure they run successfully.

## Task 2: Basic Infrastructure Configuration

Terraform code to configure the basic networking infrastructure required for a Kubernetes (K8s) cluster.

1. Created Terraform code to configure the following:

   - VPC (virtual private cloud) in us-east-1 zone
   - 2 public subnets in different AZs
   - 2 private subnets in different AZs
   - Internet Gateway
   - Routing configuration:
     - Instances in all subnets can reach each other
     - Instances in public subnets can reach addresses outside VPC and vice-versa
   - Security Groups and Network ACLs for the VPC and subnets
   - NAT for private subnets, so instances in private subnet can connect with outside world. In the task, creating one NAT Gateway for practice is enough, but in production, we should create NAT for every subnet.

2. Set up a GitHub Actions (GHA) pipeline for the Terraform code.

## Task 3: K8s Cluster Configuration and Creation

Configuration and deployment a Kubernetes (K8s) cluster on AWS using k3s. Verifying the cluster by running a simple workload.

1. Choose Deployment Method: kOps or k3s.

   - kOps handles the creation of most resources for you, while k3s requires you to manage the underlying infrastructure.
   - kOps may lead to additional expenses due to the creation of more AWS resources.
   - kOps requires a domain name or sub-domain.
   - Use AWS EC2 instances from the Free Tier to avoid additional expenses.

2. Extend Terraform Code: added a bastion host.

3. Deploy the Cluster

   - Deploy the K8s cluster using the chosen method (kOps or k3s).
   - Ensure the cluster is accessible from your local computer.

4. Verify the Cluster

   - Run the kubectl get nodes command from your local computer to get information about the cluster.
   ```bash
    kubectl get nodes
    ```
   - Provide a screenshot of the kubectl get nodes command output.

5. Deploy a Simple Workload

   - Deploy a simple workload on the cluster using the following command:
     ```bash
      kubectl apply -f https://k8s.io/examples/pods/simple-pod.yaml`
     ``` 
   - Ensure the workload runs successfully on the cluster.

6. Additional Task: Document the cluster setup and deployment process in a README file.

## Task 4: Jenkins Installation and Configuration

1. **Verify the Cluster and Jenkins:**

   ```bash
   kubectl get nodes
   ```
   
   ```bash
   kubectl get pods -n jenkins
   ```

2. **Access Jenkins:**

   ```bash
   kubectl get svc -n jenkins
   ```
   Open a web browser and navigate to http://<master_node_public_ip>:8080

3. **Check Persistent Volume Configuration:**

   ```bash
   kubectl get pv
   kubectl get pvc -n jenkins
   ```

4. **Verify Helm installation:**

   ```bash
   helm install my-nginx oci://registry-1.docker.io/bitnamicharts/nginx
   ```
   
   ```bash
   kubectl get pods
   ```
   
   ```bash
   helm uninstall my-nginx
   ```
   
   ```bash
   kubectl get pods
   kubectl get svc
   ```

## Task 5: Simple Application Deployment with Helm
1. **Access the WordPress Application:**

   Open a web browser and navigate to http://ec2-instance-public-ip:32000.

## Task 6: Simple Application Deployment with Helm
1. **SonarQube Configuration:**

   ```bash
   echo "http://<ec2-instance-public-ip>:9000"
   ```
   Use http://<ec2-instance-public-ip>:9000 for authentication.
   Default credentials are: login - admin, pw - admin.
   It needs to create a project and generate a project token, which should be used in a Jenkinsfile for the pipeline.

2. **Jenkins Configuration:**
   Use http://ec2-instance-public-ip:8080 for Jenkins.
   To retrieve password:
    
    ```bash
    kubectl exec --namespace jenkins -it svc/my-jenkins -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password
    ```
    Login is admin.
    It needs to install plugins:
       - Email Extension Plugin, 
       - SonarQube Scanner for Jenkins,
       - Amazon EC2 plugin,
       - Generic Webhook Trigger plugin.

    Provide credentials for the email and aws. 
    Make sure that AWS credentials include permission to EC2ContainerRegistry.

3. **Jenkins Job**
    Create a new pipeline job and start it either manually or automatically on a push event

## Task 7: Prometheus Deployment on Kubernetes
When the Control Node is configured, you can access the Prometheus UI using its public IP and NodePort/ForwarderPort.

For example:
- Prometheus Query UI: `http://52.23.179.239:80/query`
- Prometheus Alerts: `http://52.23.179.239:31492/#/alerts`

To detect the correct port, use the following command on the Control Node:
```bash
kubectl get svc -n monitoring
```
