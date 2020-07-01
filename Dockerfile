FROM localhost/builder:latest as builder
FROM docker.io/library/alpine:latest
COPY --from=builder /root/openshift-install-mod /root/
WORKDIR /root
RUN ./openshift-install-mod version
CMD ["ash"]
