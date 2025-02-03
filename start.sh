#!/usr/bin/env bash

set -e

export RCLONE_CONFIG='/app/rclone/rclone.conf'
PATH="$(pwd):$PATH"
export PATH

if [[ ! -f "$RCLONE_CONFIG" ]]; then
  wget -o "$RCLONE_CONFIG" "$RCLONE_CONFIG_URL"
fi

if ! rclone lsd AllDrives: >/dev/null; then
  COMBINE_CONFIG=$(rclone backend -o config drives "${ROOT:-root:}")
  echo "$COMBINE_CONFIG" >>"$RCLONE_CONFIG"
fi

rclone ${RCLONE_ARGS:+$RCLONE_ARGS} mount --cache-dir=./cache AllDrives: /storage --allow-non-empty --daemon --vfs-cache-mode=minimal ${RCLONE_MOUNT_ARGS:+$RCLONE_MOUNT_ARGS}
# rclone mount --cache-dir=./cache root: /storage --allow-non-empty --daemon

/sbin/tini -- /usr/bin/samba.sh
