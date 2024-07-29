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

EOM

if (! grep '# Run network.bash regularly' /etc/crontab); then
  cat >> /etc/crontab <<EOM

# Run network.bash regularly
*/20 * * * * root timeout 60s /var/scripts/network.bash
EOM
fi

systemctl restart cron
