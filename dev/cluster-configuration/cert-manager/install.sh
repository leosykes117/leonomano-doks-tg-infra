helm install cert-manager jetstack/cert-manager --version v1.19.1 --namespace cert-manager --create-namespace -f ./values.yaml --dry-run --debug

helm template cert-manager jetstack/cert-manager \
  --version v1.19.1 --namespace cert-manager \
  -f ./values.yaml \
  | tee cert-manager-rendered.yaml

helm install cert-manager jetstack/cert-manager \
  --version v1.19.1 \
  --namespace cert-manager \
  -f ./values.yaml \
  --wait --debug \
  | sed --unbuffered '/USER-SUPPLIED VALUES:/,$d'
