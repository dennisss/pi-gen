#!/bin/bash -e

install -m 644 files/81-periphmem.rules "${ROOTFS_DIR}/etc/udev/rules.d/"

dtc -@ -O dtb -o "${ROOTFS_DIR}/boot/overlays/periphmem.dtbo" files/periphmem.dts

mkdir -p "${ROOTFS_DIR}/opt/periphmem/"
chmod 755 "${ROOTFS_DIR}/opt/periphmem/"
install -m 644 files/periphmem.c "${ROOTFS_DIR}/opt/periphmem/"
install -m 644 files/Makefile "${ROOTFS_DIR}/opt/periphmem/"

on_chroot << 'EOF'
cd /opt/periphmem

ls /lib/modules | while read KERNEL ; do
    echo "Available Kernel: ${KERNEL}"
done

ls /lib/modules | while read KERNEL ; do
    KERNEL_DIR="/lib/modules/${KERNEL}/build"
    make -C "${KERNEL_DIR}" M="/opt/periphmem" modules
    make -C "${KERNEL_DIR}" M="/opt/periphmem" modules_install
    depmod -A ${KERNEL}
    make -C "${KERNEL_DIR}" M="/opt/periphmem" clean
done

rm -r /opt/periphmem
EOF
