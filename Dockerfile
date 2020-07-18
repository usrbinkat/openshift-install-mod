FROM localhost/builder:4.6 as builder
FROM registry.access.redhat.com/ubi8/ubi-minimal
COPY --from=builder /root/openshift-install-edge /root/
WORKDIR /root
RUN ./openshift-install-edge version
CMD ["bash"]
