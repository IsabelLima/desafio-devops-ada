#/bin/bash
aws eks update-kubeconfig --name ada-cluster --region us-east-1
kubectl apply -f ./backend/k8s
kubectl apply -f ./frontend/k8s