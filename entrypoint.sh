#!/bin/sh
set -e

if [ ! -f "${DEVPISERVER_SERVERDIR}/.serverversion" ]; then
  echo "Initializing devpi-server data in ${DEVPISERVER_SERVERDIR}..."
  uv run --no-project devpi-init
fi

if [ ! -f "${DEVPISERVER_SERVERDIR}/secret" ]; then
  echo "Generating server secret..."
  uv run --no-project devpi-gen-secret --secretfile "${DEVPISERVER_SERVERDIR}/secret"
fi

exec uv run --no-project devpi-server \
  --configfile /etc/devpi-server/devpi-server.yml \
  --outside-url https://pypi.sweetfiretobacco.com
