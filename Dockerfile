FROM localhost/builder:latest as builder
FROM registry.redhat.io/ubi8/ubi-minimal
COPY --from=builder /root/openshift-install-mod /root/
WORKDIR /root
RUN ./openshift-install-mod version
CMD ["bash"]
