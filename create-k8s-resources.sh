#/bin/bash
aws eks update-kubeconfig --name ada-cluster --region us-east-1
kubectl apply -f ./backend
kubectl apply -f ./frontend