# https://github.com/aws/aws-cli/issues/4685#issuecomment-1441909537
ARG ALPINE_VERSION=3.17
FROM python:3.10-alpine${ALPINE_VERSION} as builder

ARG AWS_CLI_VERSION=2.10.0
RUN apk add --no-cache git unzip groff build-base libffi-dev cmake
RUN git clone --single-branch --depth 1 -b ${AWS_CLI_VERSION} https://github.com/aws/aws-cli.git

WORKDIR aws-cli
RUN ./configure --with-install-type=portable-exe --with-download-deps
RUN make
RUN make install

# reduce image size: remove autocomplete and examples
RUN rm -rf \
    /usr/local/lib/aws-cli/aws_completer \
    /usr/local/lib/aws-cli/awscli/data/ac.index \
    /usr/local/lib/aws-cli/awscli/examples
RUN find /usr/local/lib/aws-cli/awscli/data -name completions-1*.json -delete
RUN find /usr/local/lib/aws-cli/awscli/botocore/data -name examples-1.json -delete
RUN (cd /usr/local/lib/aws-cli; for a in *.so*; do test -f /lib/$a && rm $a; done)


FROM alpine:3.17.2
LABEL author: "Michael Riha <michael.riha@gmail.com>"

ARG TARGETARCH

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-x86_64}" \
    OS_FLAVOUR="alpine" \
    OS_NAME="linux"

#not used for now
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
# RUN AWS_ARCH=`uname -mm` && \
#     echo "install AWS CLI (for $OS_ARCH/$AWS_ARCH) according to -> https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html" && \
#     # https://github.com/BretFisher/multi-platform-docker-build/blob/main/README.md
#     curl "https://awscli.amazonaws.com/awscli-exe-linux-${AWS_ARCH}.zip" -o "awscliv2.zip" && \
#     ls -l && \
#     unzip awscliv2.zip && \
#     ls -l && \
#     ./aws/install && \
#     chmod -R 755 /usr/local/aws-cli && \ 
#     # https://stackoverflow.com/a/71904951
#     /usr/local/bin/aws --version \
#     aws --version
COPY --from=builder /usr/local/lib/aws-cli/ /usr/local/lib/aws-cli/
RUN ln -s /usr/local/lib/aws-cli/aws /usr/local/bin/aws

# latest  https://dl.k8s.io/release/stable.txt
RUN curl -LO "https://dl.k8s.io/release/v1.26.3/bin/linux/${OS_ARCH}/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    kubectl version --client

