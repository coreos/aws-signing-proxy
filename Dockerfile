## aws-signing-proxy
FROM scratch

# Default listening port
EXPOSE 8080

ENTRYPOINT ["/aws-signing-proxy"]

COPY ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY aws-signing-proxy /aws-signing-proxy
