#!/usr/bin/env bash

set -e

export RCLONE_CONFIG='/app/rclone/rclone.conf'
PATH="$(pwd):$PATH"
export PATH

if [[ ! -f "$RCLONE_CONFIG" ]]; then
  mkdir -p "${RCLONE_CONFIG%/*}"
  wget -O "$RCLONE_CONFIG" "$RCLONE_CONFIG_URL"
fi

all_drives=$(rclone backend -o config drives "${ROOT:-root:}")
echo "$all_drives" >>"$RCLONE_CONFIG"

sleep 5 # Let rclone rest, update sth

rclone ${RCLONE_ARGS:+$RCLONE_ARGS} mount --cache-dir=./cache AllDrives: /storage --allow-non-empty --daemon --vfs-cache-mode=minimal ${RCLONE_MOUNT_ARGS:+$RCLONE_MOUNT_ARGS}

/sbin/tini -- /usr/bin/samba.sh
