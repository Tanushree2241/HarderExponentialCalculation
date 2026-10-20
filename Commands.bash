docker build -t expo:1.0 .
docker run --rm expo:1.0 2 10
minikube start
minikube image load expo:1.0
kubectl apply -f Job.yaml
kubectl wait --for=condition=complete job/expo-job --timeout=60s
kubectl logs job/expo-job
minikube delete