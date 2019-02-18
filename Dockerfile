FROM opnfv/xtesting

ENV HOME=/config

ENV KUBERNETES_VERSION="v1.6.4"
ENV HELM_VERSION="v2.9.1"

# Install kubectl
# Note: Latest version may be found on:
# https://aur.archlinux.org/packages/kubectl-bin/

ADD https://storage.googleapis.com/kubernetes-release/release/${KUBERNETES_VERSION}/bin/linux/amd64/kubectl /usr/local/bin/kubectl

COPY check_onap_k8s.sh /check_onap_k8s.sh
COPY check_onap_helm.sh /check_onap_helm.sh

RUN set -x && \
    apk add --no-cache curl ca-certificates && \
    chmod +x /usr/local/bin/kubectl && \
    adduser kubectl -Du 2342 -h /config && \
    wget -q https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    chmod +x /check_onap_*.sh

COPY testcases.yaml /usr/lib/python2.7/site-packages/xtesting/ci/testcases.yaml
CMD ["run_tests", "-t", "all"]
