# web-terminal

For use in OpenShift web terminal

```bash
oc apply -f - <<EOF
---
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: web-terminal
  namespace: openshift-operators
spec:
  channel: fast
  installPlanApproval: Automatic
  name: web-terminal
  source: redhat-operators
  sourceNamespace: openshift-marketplace
---
apiVersion: v1
kind: Namespace
metadata:
  name: openshift-terminal
EOF
```

```bash
oc create -f - <<EOF
---
apiVersion: workspace.devfile.io/v1alpha2
kind: DevWorkspace
metadata:
  annotations:
    controller.devfile.io/devworkspace-source: web-terminal
    controller.devfile.io/restricted-access: "true"
  labels:
    console.openshift.io/terminal: "true"
  generateName: terminal-
  namespace: openshift-terminal
spec:
  routingClass: web-terminal
  started: true
  template:
    components:
      - name: web-terminal-tooling
        plugin:
          kubernetes:
            name: web-terminal-tooling
            namespace: openshift-operators
          components:
          - container:
              image: quay.io/eformat/web-terminal:latest-x86_64
            name: web-terminal-tooling
      - name: web-terminal-exec
        plugin:
          kubernetes:
            name: web-terminal-exec
            namespace: openshift-operators
EOF
```
