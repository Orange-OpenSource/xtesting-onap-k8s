FROM opnfv/xtesting

ENV HOME=/config

ARG KUBERNETES_VERSION="v1.12.7"
ARG HELM_VERSION="v2.9.1"
ARG ONAP_TESTS_TAG=master

# Install kubectl
# Note: Latest version may be found on:
# https://aur.archlinux.org/packages/kubectl-bin/

ADD https://storage.googleapis.com/kubernetes-release/release/${KUBERNETES_VERSION}/bin/linux/amd64/kubectl /usr/local/bin/kubectl

COPY scripts/check_onap_k8s.sh /check_onap_k8s.sh
COPY scripts/check_onap_helm.sh /check_onap_helm.sh

RUN set -x && \
    apk add --no-cache curl ca-certificates && \
    chmod +x /usr/local/bin/kubectl && \
    adduser kubectl -Du 2342 -h /config && \
    wget -q https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    chmod +x /check_onap_*.sh && \
    pip3 install --upgrade pip && \
    pip3 install --no-cache-dir \
        git+https://github.com/Orange-OpenSource/xtesting-onap-k8s.git@$ONAP_TESTS_TAG#egg=onap_k8s

COPY docker/testcases.yaml /usr/lib/python3.6/site-packages/xtesting/ci/testcases.yaml
CMD ["run_tests", "-t", "all"]
