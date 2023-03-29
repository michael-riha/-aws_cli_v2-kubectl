---
This project is needed primarily for updating the ECR secret/password inside a `k8s` container via a `CronJob` for multi-arch systems
---

# aws_cli_v2-kubectl

this is basically a multi-arch updated "fork" from  👉 https://github.com/bearengineer/awscli-kubectl

## It includes
- `aws cli vs`
- `kubectl`
- `alpine`


### build

`docker compose build --no-cache`

```
docker buildx build --push \
--platform linux/amd64,linux/arm64 \
--tag aws_cli_v2-kubectl .
```
`docker buildx build --push --platform linux/amd64,linux/arm64 --tag aws_cli_v2-kubectl . `


## added `github`-Actions for publishing on `docker`-Hub

https://github.com/michael-riha/aws_cli_v2-kubectl -> https://hub.docker.com/repository/docker/miriha/aws_cli_v2-kubectl/general