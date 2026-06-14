#!/bin/bash
set -e

SHARED_DIR=/shared/ssh
DEST_DIR="$HOME/.ssh"

mkdir -p "$DEST_DIR"
chmod 700 "$DEST_DIR"

# targetでの鍵生成完了を待機
for i in $(seq 1 30); do
  if [ -f "$SHARED_DIR/id_rsa" ]; then
    break
  fi
  echo "[bastion] Waiting for SSH key from target... ($i)"
  sleep 1
done

if [ ! -f "$SHARED_DIR/id_rsa" ]; then
  echo "[bastion] WARNING: SSH key not found in $SHARED_DIR"
  exit 0
fi

cp "$SHARED_DIR/id_rsa" "$DEST_DIR/id_rsa"
chmod 600 "$DEST_DIR/id_rsa"

echo "[bastion] SSH key synced to $DEST_DIR/id_rsa"
