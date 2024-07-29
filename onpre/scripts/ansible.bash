#!/usr/bin/env bash

set -euo pipefail

cat <<EOM

## Ansible setup
EOM

if (! grep '^ansible_user:' /etc/passwd); then
  cat <<EOM

### Add ansible_user
EOM

  useradd -m ansible_user
  usermod -aG sudo ansible_user
  echo "ansible_user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/ansible_user

  sed -i /etc/ssh/sshd_config -e 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/'
  mkdir -p /home/ansible_user/.ssh
  cat ./scripts/souzou.pub >> /home/ansible_user/.ssh/authorized_keys
  chmod 755 -R /home/ansible_user/
  chmod 700 -R /home/ansible_user/.ssh

  systemctl restart sshd
fi
