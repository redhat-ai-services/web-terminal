# web-terminal

For use in OpenShift web terminal

Deploy the Operator

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

Create a DevWorkspace for Web Terminal

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
              image: quay.io/redhat-ai-services/web-terminal:latest-x86_64
            name: web-terminal-tooling
      - name: web-terminal-exec
        plugin:
          kubernetes:
            name: web-terminal-exec
            namespace: openshift-operators
EOF
```

### Signature

The public key of [web-terminal image](https://quay.io/repository/redhat-ai-services/web-terminal)

[Cosign](https://github.com/sigstore/cosign) public key:

```shell
-----BEGIN PUBLIC KEY-----
MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE8uVyWFdZwq0eE/u3yeXqHJr/ZIEV
C5MS7M9++JtsEYGuvpZ45tr962KOegDc3uUrDjxKv9Zu+/FZWf5v+fqwtA==
-----END PUBLIC KEY-----
```

The public key is also available online: <https://raw.githubusercontent.com/redhat-ai-services/web-terminal/refs/heads/main/cosign.pub>

To verify an image:

```shell
curl --progress-bar -o cosign.pub https://raw.githubusercontent.com/redhat-ai-services/web-terminal/refs/heads/main/cosign.pub
cosign verify --key cosign.pub https://quay.io/repository/redhat-ai-services/web-terminal:${VERSION}
```
