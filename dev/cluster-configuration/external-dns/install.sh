helm repo add external-dns https://kubernetes-sigs.github.io/external-dns/

helm template external-dns external-dns/external-dns \
  --version 1.18.0 \
  --namespace external-dns \
  --values ./values.yaml \
  --debug \
  | tee external-dns-manifest.yaml

helm upgrade --install external-dns external-dns/external-dns \
  --version 1.18.0 \
  --namespace external-dns \
  --create-namespace \
  --values ./values.yaml \
  --wait --debug

helm uninstall external-dns --namespace external-dns
