#!/usr/bin/env bash

set -euo pipefail

if (! grep '### pve settings' ~/.ssh/config); then
  SSH_CONF=$(cat <<EOM

### pve settings

Host souzou*
HostName %h.wr.suzuka-ct.ac.jp
User root

### pve settings end

EOM
)

  echo "$SSH_CONF"

  read  -rp "Do you want to add the above to ~/.ssh/config? [Y/n] " ADD_SSH_CONF
  if [[ "$ADD_SSH_CONF" =~ ^[nN]([oO])?$ ]]; then
    exit 0
  else
    echo "$SSH_CONF" >> ~/.ssh/config
    echo "Added to ~/.ssh/config"
  fi
else
  echo "Already added to ~/.ssh/config"
fi
