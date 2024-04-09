> [!NOTE]
> This project was needed primarily for updating the ECR secret/password inside a `k8s` container via a `CronJob` for multi-arch systems

# aws_cli_v2-kubectl

this is basically a multi-arch updated "fork" from  👉 https://github.com/bearengineer/awscli-kubectl

## It includes
- built on: `alpine` `3.1.7`
- `aws cli v2`
- `kubectl`
- `helm` `3.0.0`
- `k9s`
- `kubeseal`



### build

`docker compose build --no-cache`

```
docker buildx build --push \
--platform linux/amd64,linux/arm64 \
--tag aws_cli_v2-kubectl .
```
`docker buildx build --push --platform linux/amd64,linux/arm64 --tag aws_cli_v2-kubectl . `

### run

`docker compose up`

#### enter the container

`docker compose exec awscli-kubectl sh`

## added `github`-Actions for publishing on `docker`-Hub

https://github.com/michael-riha/aws_cli_v2-kubectl -> https://hub.docker.com/repository/docker/miriha/aws_cli_v2-kubectl/general


## `aws`

`aws configure list`
`aws ecr get-login-password`
`aws eks update-kubeconfig --region region-code --name my-cluster`
e.g.
`aws eks update-kubeconfig --region us-west-2 --name company-aio-dev`
