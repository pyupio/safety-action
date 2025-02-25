FROM ghcr.io/pyupio/safety:3.3.1-cbc4843

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
