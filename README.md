# web-terminal

For use in OpenShift web terminal

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
              imagePullPolicy: Always
              env:
                - name: WEB_TERMINAL_IDLE_TIMEOUT
                  value: 240m
            name: web-terminal-tooling
      - name: web-terminal-exec
        plugin:
          kubernetes:
            name: web-terminal-exec
            namespace: openshift-operators
EOF
```
