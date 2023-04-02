#!/bin/bash -e

# Copied from 'export-image/02-set-sources/01-run.sh' so that it runs before file system creation.

rm -f "${ROOTFS_DIR}/etc/apt/apt.conf.d/51cache"
find "${ROOTFS_DIR}/var/lib/apt/lists/" -type f -delete
on_chroot << EOF
apt-get update
apt-get -y dist-upgrade --auto-remove --purge
apt-get clean
EOF


# Extra cleaning of unnecessary files.

rm -rf "$ROOTFS_DIR/var/lib/apt/lists"
rm -rf "$ROOTFS_DIR/var/lib/dpkg"
rm -rf "$ROOTFS_DIR/usr/share/doc"
rm -rf "$ROOTFS_DIR/usr/share/man"
