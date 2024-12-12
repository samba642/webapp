# Kubernetes Web Application Deployment

This repository contains all the files and instructions needed to deploy a static web application in a Kubernetes cluster. The solution includes infrastructure provisioning using Terraform, Kubernetes manifests, Docker containerization, and monitoring with Prometheus.

---

## **Prerequisites**

Ensure you have the following tools installed on your system:

1. **Kubernetes Cluster** (Minikube, Kind, or a cloud-based solution like EKS, GKE, or AKS).
2. **kubectl**: To interact with the Kubernetes cluster.
3. **Terraform**: To provision cloud infrastructure.
4. **Docker**: To build and test containerized applications.
5. **Helm**: To deploy Prometheus for monitoring.

---

## **Folder Structure**

```
.
├── Dockerfile                 # Dockerfile to build the web application image
├── terraform/                # Terraform configuration files for cloud infrastructure
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── k8s/                      # Kubernetes manifests for the application
│   ├── configmap.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   └── prometheus-config.yaml
├── README.md                 # Documentation
└── app/                      # Static web application source code
    ├── index.html
```

---

## **Steps to Deploy the Application**

### **Step 1: Build and Test Docker Image**

1. Navigate to the project root directory.
2. Build the Docker image:
   ```bash
   docker build -t static-web-app .
   ```
3. Run the container locally to verify:
   ```bash
   docker run -p 8080:80 static-web-app
   ```
4. Access the application in your browser at `http://localhost:8080`.

---

### **Step 2: Provision Cloud Infrastructure (Optional)**

If using a cloud provider for Kubernetes, provision the required resources using Terraform:

1. Navigate to the `terraform` directory:
   ```bash
   cd terraform
   ```
2. Initialize Terraform:
   ```bash
   terraform init
   ```
3. Review and apply the configuration:
   ```bash
   terraform apply
   ```
4. Note the output, which typically includes the Kubernetes cluster endpoint and authentication details.

---

### **Step 3: Configure Kubernetes Context**

Ensure `kubectl` is configured to connect to your cluster:

```bash
kubectl config use-context <your-cluster-context>
```
Verify the connection:

```bash
kubectl get nodes
```

---

### **Step 4: Deploy the Application**

1. Navigate to the `k8s` directory:
   ```bash
   cd k8s
   ```
2. Apply the ConfigMap:
   ```bash
   kubectl apply -f configmap.yaml
   ```
3. Deploy the web application:
   ```bash
   kubectl apply -f deployment.yaml
   ```
4. Expose the application as a service:
   ```bash
   kubectl apply -f service.yaml
   ```
5. Verify that all resources are running:
   ```bash
   kubectl get all
   ```

---

### **Step 5: Access the Application**

Retrieve the service URL (if using Minikube):

```bash
minikube service web-app-service
```

For cloud-based Kubernetes, use the external IP from the service:

```bash
kubectl get service web-app-service
```

---

### **Step 6: Set Up Monitoring with Prometheus**

1. Install Prometheus using Helm:
   ```bash
   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
   helm repo update
   helm install prometheus prometheus-community/prometheus
   ```
2. Verify that Prometheus pods are running:
   ```bash
   kubectl get pods -n default
   ```
3. Access Prometheus:
   ```bash
   kubectl port-forward svc/prometheus-server 9090:80
   ```
   Open your browser at `http://localhost:9090`.

4. Apply the custom Prometheus configuration (if any):
   ```bash
   kubectl apply -f prometheus-config.yaml
   ```

---

## **Files Explanation**

### **Dockerfile**
Defines the steps to containerize the web application.

### **Terraform Files**
- **`main.tf`**: Configures cloud infrastructure (e.g., Kubernetes cluster, networking).
- **`variables.tf`**: Defines input variables for reusable configurations.
- **`outputs.tf`**: Specifies outputs like cluster endpoint and credentials.

### **Kubernetes Manifests**
- **`configmap.yaml`**: Contains environment variables or configuration data.
- **`deployment.yaml`**: Describes the deployment of the web application.
- **`service.yaml`**: Exposes the application for external access.
- **`prometheus-config.yaml`**: Custom configuration for Prometheus monitoring.

---

## **Cleanup**

To delete the deployed resources:

```bash
kubectl delete -f k8s/
helm uninstall prometheus
```

To destroy the Terraform-provisioned infrastructure:

```bash
cd terraform
terraform destroy
```

---

## **References**
- [Docker Documentation](https://docs.docker.com/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Terraform Documentation](https://www.terraform.io/docs/)
