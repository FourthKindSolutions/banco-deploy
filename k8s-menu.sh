#!/bin/bash
export KUBECONFIG=/cluster/kube_config_cluster.yml
# Function to list deployments
list_deployments() {
    kubectl get deployments --all-namespaces
}

# Function to execute console inside a pod
exec_console() {
    read -p "Enter the namespace of the pod: " namespace
    read -p "Enter the name of the pod: " pod_name
    kubectl exec -it $pod_name -n $namespace -- sh
}

# Function to list pods
list_pods() {
    kubectl get pods --all-namespaces
}

# Function to list namespaces
list_namespaces() {
    kubectl get namespaces
}

# Function to delete pods
delete_pods() {
    read -p "Enter the namespace of the pod: " namespace
    read -p "Enter the name of the pod: " pod_name
    kubectl delete pod $pod_name -n $namespace
}

# Function to restart deployments
restart_deployments() {
    read -p "Enter the namespace of the deployment: " namespace
    read -p "Enter the name of the deployment: " deployment_name
    kubectl rollout restart deployment/$deployment_name -n $namespace
}

# Function to install Helm chart
install_helm_chart() {
    read -p "Enter the namespace for the Helm chart installation: " namespace
    read -p "Enter the name of the Helm chart: " chart_name
    helm install $chart_name -n $namespace
}

# Function to create PVC (PersistentVolumeClaim)
create_pvc() {
    read -p "Enter the namespace for PVC creation: " namespace
    read -p "Enter the name of the PVC: " pvc_name
    read -p "Enter the size of the PVC: " pvc_size
    cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: $pvc_name
  namespace: $namespace
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: $pvc_size
EOF
}

# Function to delete PVC (PersistentVolumeClaim)
delete_pvc() {
    read -p "Enter the namespace of the PVC: " namespace
    read -p "Enter the name of the PVC: " pvc_name
    kubectl delete pvc $pvc_name -n $namespace
}

# Function to create namespace
create_namespace() {
    read -p "Enter the name of the namespace: " namespace_name
    kubectl create namespace $namespace_name
}

# Function to clean pods in various failure states
clean_pods() {
    read -p "Enter the namespace to clean pods: " namespace
    read -p "Enter the failure state of the pods (failed, crashloop, evicted): " failure_state

    case $failure_state in
        failed)
            kubectl delete pods --field-selector=status.phase=Failed -n $namespace
            ;;
        crashloop)
            kubectl delete pods --field-selector=status.phase=Running,status.reason=CrashLoopBackOff -n $namespace
            ;;
        evicted)
            kubectl delete pods --field-selector=status.phase=Failed,status.reason=Evicted -n $namespace
            ;;
        *)
            echo "Invalid failure state. Please try again."
            ;;
    esac
}

# Main menu
while true; do
    echo "Welcome to the Kubernetes interactive script!"
    echo "Please select an option:"
    echo "1. List Deployments"
    echo "2. Execute Console Inside a Pod"
    echo "3. List Pods"
    echo "4. List Namespaces"
    echo "5. Delete Pods"
    echo "6. Restart Deployments"
    echo "7. Install Helm Chart"
    echo "8. Create PVC"
    echo "9. Delete PVC"
    echo "10. Create Namespace"
    echo "11. Clean Pods (failed, crashloop, evicted)"
    echo "0. Exit"

    read -p "Option: " option

    case $option in
        1)
            list_deployments
            ;;
        2)
            exec_console
            ;;
        3)
            list_pods
            ;;
        4)
            list_namespaces
            ;;
        5)
            delete_pods
            ;;
        6)
            restart_deployments
            ;;
        7)
            install_helm_chart
            ;;
        8)
            create_pvc
            ;;
        9)
            delete_pvc
            ;;
        10)
            create_namespace
            ;;
        11)
            clean_pods
            ;;
        0)
            echo "Exiting the script. Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac

    echo
done
