helm repo add external-secrets https://charts.external-secrets.io

helm template external-secrets \
  external-secrets/external-secrets \
    -n external-secrets \
    --create-namespace \
    --set 'installCRDs=true'

helm install external-secrets \
   external-secrets/external-secrets \
    -n external-secrets \
    --create-namespace \
    --set 'installCRDs=true'

helm uninstall external-secrets -n external-secrets
