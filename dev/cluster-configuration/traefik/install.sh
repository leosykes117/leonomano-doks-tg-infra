helm template traefik traefik/traefik -f ./values.yaml --debug \
  | tee traefik-rendered.yaml

helm install traefik traefik/traefik -f ./values.yaml --wait --debug

helm upgrade traefik traefik/traefik --namespace traefik --values ./values.yaml --wait --debug


htpasswd -c -B .htpasswd admin
kubectl create secret generic traefik-dashboard-auth \
  -n traefik \
  --from-file=users=.htpasswd
