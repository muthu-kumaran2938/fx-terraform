apiVersion: v1
clusters:
- cluster:
    server: ${endpoint}
    certificate-authority-data: ${cert}
  name: ${cluster_name}
contexts: []
current-context: ""
kind: Config
preferences: {}
users: []
