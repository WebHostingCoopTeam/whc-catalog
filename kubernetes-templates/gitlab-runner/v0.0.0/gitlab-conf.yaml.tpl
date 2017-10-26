apiVersion: v1
kind: ConfigMap
metadata:
  name: gitlab-runner
  namespace: ${NAMESPACE}
data:
  config.toml: |
    concurrent = 4

    [[runners]]
      name = "WHC Kubernetes Runner"
      url = "${GITLAB_URL}"
      token = "${GITLAB_TOKEN}"
      executor = "kubernetes"
      [runners.kubernetes]
        namespace = "${NAMESPACE}"
        image = "busybox"
