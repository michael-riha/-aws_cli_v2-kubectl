FROM alpine:3.17.2
LABEL author: "Michael Riha <michael.riha@gmail.com>"


ARG TARGETARCH

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-x86_64}" \
    OS_FLAVOUR="alpine" \
    OS_NAME="linux"

ARG AWS_VERSION="1.17.3"
ARG KUBE_VERSION="v1.17.1"


#  &&  pip install --upgrade pip "awscli==${AWS_VERSION}" \

RUN apk update \
  &&  apk add ca-certificates curl \
#  &&  pip install --upgrade pip "awscli==${AWS_VERSION}" \
#  &&  curl --silent -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
#  &&  chmod +x /usr/local/bin/kubectl \
#  &&  curl --silent -L https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator -o /usr/local/bin/aws-iam-authenticator \
#  &&  chmod +x /usr/local/bin/aws-iam-authenticator \
 &&  rm /var/cache/apk/*

# we need need `x86_64` instead of `amd64`
RUN AWS_ARCH=`uname -mm` && \
    echo "install AWS CLI (for $OS_ARCH/$AWS_ARCH) according to -> https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html" && \
    # https://github.com/BretFisher/multi-platform-docker-build/blob/main/README.md
    curl "https://awscli.amazonaws.com/awscli-exe-linux-${AWS_ARCH}.zip" -o "awscliv2.zip" && \
    ls -l && \
    unzip awscliv2.zip && \
    ls -l && \
    ./aws/install

# latest  https://dl.k8s.io/release/stable.txt
RUN curl -LO "https://dl.k8s.io/release/v1.26.3/bin/linux/${OS_ARCH}/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    kubectl version --client

