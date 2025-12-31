helm repo add external-secrets https://charts.external-secrets.io

helm template external-secrets \
  external-secrets/external-secrets \
    -n external-secrets \
    --set 'installCRDs=true'

helm upgrade external-secrets \
   external-secrets/external-secrets \
    -n external-secrets \
    --create-namespace -i \
    --set 'installCRDs=true'

helm uninstall external-secrets -n external-secrets
