# Subaru cluster

k8s を動かす LXC コンテナで構築されたクラスターです。

## Setup

### 1. LXC Template(VMID 500)をコピー

### 2. Proxmox VE の LXC の config を編集

`/etc/pve/lxc/{VMID}.conf`を編集

```config
lxc.apparmor.profile: unconfined
lxc.cap.drop:
lxc.cgroup.devices.allow: a
lxc.mount.auto: proc:rw sys:rw
```

### 3. ターミナルに入る

#### 3.1. sshd の設定

```bash
dnf install openssh-server -y
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl restart sshd
```

#### 3.2. ansible_user の作成

```bash
adduser ansible_user
echo "ansible_user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/ansible_user
mkdir -p /home/ansible_user/.ssh
cat /root/.ssh/authorized_keys > /home/ansible_user/.ssh/authorized_keys
chown ansible_user:ansible_user -R /home/ansible_user/.ssh
```
