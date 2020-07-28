FROM localhost/builder:offline as builder
FROM registry.access.redhat.com/ubi8/ubi-minimal
COPY --from=builder /root/openshift-install-offline /root/
WORKDIR /root
RUN ./openshift-install-offline version
CMD ["bash"]
