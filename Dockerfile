FROM docker.io/containercraft/ccio-golang:ubi8 as builder
FROM docker.io/library/alpine:latest as final

FROM builder
ARG gitBranch="release-4.5"
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
	 && mv ./bin/openshift-install /root/openshift-install-mod \
	 && cd /root \
     && ./openshift-install-mod version \
	 && rm -rf /root/dev/installer

FROM final
COPY --from=builder /root/openshift-install-mod /root/
WORKDIR /root
CMD ["bash"]
