FROM registry.access.redhat.com/ubi8/ubi-minimal as aux
FROM docker.io/containercraft/ccio-golang:ubi8 as builder
ARG gitBranch="release-4.6"
ARG uriInstaller="https://github.com/openshift/installer.git"
ARG filePath_tlsgo="/root/dev/installer/pkg/asset/tls/tls.go"
WORKDIR /root/dev 
RUN set -ex \
     && git clone ${uriInstaller} \
     && cd /root/dev/installer    \
     && git checkout ${gitBranch} \
     && sed -i 's/ValidityOneDay = time.Hour \* 24/ValidityOneDay = time.Hour * 24\n\n        \/\/ ValidityOneMonth sets the validity of a cert to 30 Days.\n        ValidityOneMonth = ValidityOneDay \* 30/g' ${filePath_tlsgo} \
     && grep ValidityOneMonth pkg/asset/tls/tls.go \
     && grep ValidityOneDay pkg/asset/tls/tls.go \
     && export filePath_PatchList=$(grep -lR ValidityOneDay | grep -Ev "tls-patch|tls\.go") \
     && for patchFile in ${filePath_PatchList}; do sed -i 's/ValidityOneMonth/ValidityOneMonth/g' ${patchFile}; done \
     && ./hack/build.sh \
	 && mv ./bin/openshift-install /root/openshift-install-edge \
     && ls /root \
     && cd /root \
     && ./openshift-install-edge version \
	 && rm -rf /root/dev/installer
