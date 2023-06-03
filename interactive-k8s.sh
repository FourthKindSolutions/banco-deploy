#!/bin/bash

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
