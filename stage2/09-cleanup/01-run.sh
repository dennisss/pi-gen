#!/bin/bash -e

# Copied from 'export-image/02-set-sources/01-run.sh' so that it runs before file system creation.

find "${ROOTFS_DIR}/var/lib/apt/lists/" -type f -delete
on_chroot << EOF
apt-get update
apt-get -y dist-upgrade --auto-remove --purge
apt-get clean
EOF

# Must be after the 'apt' commands so that they still use the proxy.
rm -f "${ROOTFS_DIR}/etc/apt/apt.conf.d/51cache"

# Extra cleaning of unnecessary files.

rm -rf "$ROOTFS_DIR/var/lib/apt/lists"
rm -rf "$ROOTFS_DIR/var/lib/dpkg"
rm -rf "$ROOTFS_DIR/usr/share/doc"
rm -rf "$ROOTFS_DIR/usr/share/man"
rm -rf "$ROOTFS_DIR/usr/share/locale/!(en*)"
rm -rf "$ROOTFS_DIR/usr/src"
rm -rf "$ROOTFS_DIR/usr/lib/gcc/aarch64-linux-gnu/*/cc1*"
rm -rf "$ROOTFS_DIR/usr/lib/gcc/aarch64-linux-gnu/*/lto*"