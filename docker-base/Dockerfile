ARG BASE_IMAGE=debian:bookworm
FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && \
    apt-get -y install --no-install-recommends \
        git vim parted \
        quilt coreutils qemu-user-static debootstrap util-linux zip dosfstools \
        libarchive-tools libcap2-bin rsync grep udev xz-utils curl xxd file kmod bc\
        binfmt-support ca-certificates fdisk gpg pigz arch-test btrfs-progs\
        build-essential gcc-aarch64-linux-gnu device-tree-compiler\
    && rm -rf /var/lib/apt/lists/*
