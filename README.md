# openshift-install-mod
unofficial experimental tls ttl mod
```
mkdir /tmp/offline
```
```
cat <<EOF >/tmp/offline/offline-config.yaml
rhcos:
  architecture: amd64
  version:      4.5.2-x86_64
  provider:     aws
  url: http://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/latest/latest/rhcos-4.5.2-x86_64-aws.x86_64.vmdk.gz

ocpmirror:
  ocbin: "/usr/bin/oc"
  pullsecret: "/root/.docker/config.json"
  src: "quay.io/openshift-release-dev/ocp-release:4.5.4-x86_64"
  dest: "/tmp/offline"

ocpdistribution:
  destdir: /tmp/offline
  isofile: offline-ocp4-components.iso
EOF
```
```
sudo podman run --rm -it \
  --name offline --pull=always \
  --entrypoint bash --volume /tmp/offline:/root/offline:z \
 quay.io/codesparta/konductor:latest
```
```
openshift-install-offline create offline-package \
  --dir=/tmp/offline --log-level=debug
```
```
 ls -lah /tmp/offline
```
