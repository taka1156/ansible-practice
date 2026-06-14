#!/bin/bash
set -e

SHARED_DIR=/shared/ssh
mkdir -p "$SHARED_DIR"

# 初回起動時のみ鍵を生成
if [ ! -f "$SHARED_DIR/id_rsa" ]; then
  echo "Generating SSH key pair..."
  ssh-keygen -t rsa -b 2048 -f "$SHARED_DIR/id_rsa" -N ""
fi

# 公開鍵をauthorized_keysに登録
cp "$SHARED_DIR/id_rsa.pub" /home/ansible/.ssh/authorized_keys
chown ansible:ansible /home/ansible/.ssh/authorized_keys
chmod 600 /home/ansible/.ssh/authorized_keys

# sshdのホストキーが無ければ生成
ssh-keygen -A

exec "$@"
