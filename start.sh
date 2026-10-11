#!/usr/bin/env bash
set -eu

: "${SSH_PASSWORD:?Set SSH_PASSWORD in Railway Variables}"

echo "railway:${SSH_PASSWORD}" | chpasswd
ssh-keygen -A

# Railway routes the service's TCP proxy to the configured target port.
PORT="${PORT:-2222}"
sed -i "s/^#*Port .*/Port ${PORT}/" /etc/ssh/sshd_config
sed -i 's/^#*PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#*PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^#*AllowUsers .*/AllowUsers railway/' /etc/ssh/sshd_config

exec /usr/sbin/sshd -D -e
