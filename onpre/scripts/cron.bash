#!/usr/bin/env bash

set -euo pipefail

cat <<EOM

## Setup the cron job
EOM

if (! grep '# Run dhclient every 5 minutes' /etc/crontab); then
  cat >> /etc/crontab <<EOM

# Run dhclient every 5 minutes
*/5 * * * * root /root/onpre/vpn.bash
EOM
fi
