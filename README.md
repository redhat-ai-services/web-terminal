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
    controller.devfile.io/creator: ""
  generateName: terminal-
  namespace: openshift-terminal
spec:
  routingClass: web-terminal
  started: true
  template:
    components:
    - name: web-terminal-tooling
      plugin:
        components:
        - container:
            image: 
          name: web-terminal-tooling
        kubernetes:
          name: web-terminal-tooling
          namespace: openshift-operators
    - name: web-terminal-exec
      plugin:
        components:
        - container:
            image: quay.io/eformat/web-terminal:latest-x86_64
            env:
              - name: WEB_TERMINAL_IDLE_TIMEOUT
                value: 240m
            args: ["sleep", "infinity"]
          name: web-terminal-exec
        kubernetes:
          name: web-terminal-exec
          namespace: openshift-operators
EOF
```
