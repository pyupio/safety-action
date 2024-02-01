FROM ghcr.io/pyupio/safety:3.0.1_multi-ecosystem.0

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
