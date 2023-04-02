#!/bin/bash -e

# This likes to crash on startup so disable it.
# (normally we should have removed this package so this should be a no-op but we may accidentally add the package back in the future.)
on_chroot << EOF
sudo systemctl mask userconfig
EOF

rm -f "${ROOTFS_DIR}/etc/xdg/autostart/piwiz.desktop"