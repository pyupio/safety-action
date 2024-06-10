FROM ghcr.io/pyupio/safety:3.2.3-a6de00f

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
