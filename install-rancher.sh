helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
helm repo add jetstack https://charts.jetstack.io
kubectl create namespace cattle-system
kubectl create namespace cert-manager
kubectl apply --validate=false -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.1/cert-manager.crds.yaml
helm install cert-manager jetstack/cert-manager --namespace cert-manager 
helm install rancher rancher-stable/rancher --namespace cattle-system --set hostname=rancher-stg --set rancherImageTag=v2.7.3 --set global.cattle.psp.enabled=false
