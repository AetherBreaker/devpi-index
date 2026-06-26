FROM python:3.14-alpine

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/local/bin/

ENV PYTHONDONTWRITEBYTECODE=1 \
  PYTHONUNBUFFERED=1 \
  DEVPISERVER_SERVERDIR=/var/db/devpi-server \
  UV_SYSTEM_PYTHON=1 \
  UV_NO_CACHE=1

WORKDIR /app

RUN apk add --no-cache libffi \
  && apk add --no-cache --virtual .build-deps gcc musl-dev libffi-dev \
  && uv pip install --system devpi-server devpi-web \
  && apk del .build-deps

RUN adduser -D -h /var/lib/devpi -s /sbin/nologin devpi \
  && mkdir -p /var/db/devpi-server /etc/devpi-server \
  && chown -R devpi:devpi /var/db/devpi-server /etc/devpi-server /var/lib/devpi

COPY --chown=devpi:devpi devpi-server.yml /etc/devpi-server/devpi-server.yml
COPY --chown=devpi:devpi entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 3141

USER devpi

VOLUME ["/var/db/devpi-server"]

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
