# openshift-install-offline
```
mkdir /tmp/offline
```
```
sudo podman run --rm -it \
    --name offline --pull=always \
    --entrypoint bash --volume /tmp/offline:/ocp-images:z \
  quay.io/codesparta/konductor:latest
```
```
cat <<EOF >/ocp-images/offline-config.yaml
rhcos:
  architecture: amd64
  version:      4.5.2-x86_64
  provider:     aws
  url: http://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/latest/latest/rhcos-4.5.2-x86_64-aws.x86_64.vmdk.gz

ocpmirror:
  ocbin: "/usr/bin/oc"
  pullsecret: "/root/.docker/config.json"
  src: "quay.io/openshift-release-dev/ocp-release:4.5.4-x86_64"
  dest: "/ocp-images"

ocpdistribution:
  destdir: /ocp-images
  isofile: offline-ocp4-components.iso
EOF
```

```
openshift-install-offline create offline-package \
  --dir=/ocp-images --log-level=debug
```
```
exit
```
```
 ls -lah /tmp/offline
```
