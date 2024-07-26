#!/usr/bin/env bash

set -euo pipefail

cat <<EOM

## Setup the cron job
EOM

mkdir -p /var/scripts/

cat > /var/scripts/network.bash <<EOM
#!/usr/bin/env bash

set -euo pipefail

ifreload -a
dhclient enp2s0

EOM

if (! grep '# Run dhclient every 20 minutes' /etc/crontab); then
  cat >> /etc/crontab <<EOM

# Run dhclient every 20 minutes
*/20 * * * * root timeout 60s /var/scripts/network.bash
EOM
fi

systemctl restart cron
