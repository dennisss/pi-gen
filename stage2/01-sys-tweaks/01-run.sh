#!/bin/bash -e

install -m 644 files/50raspi		"${ROOTFS_DIR}/etc/apt/apt.conf.d/"

install -m 644 files/console-setup   	"${ROOTFS_DIR}/etc/default/"

if [ true ]; then
	install -v -m 0700 -o 1000 -g 1000 -d "${ROOTFS_DIR}"/home/"${FIRST_USER_NAME}"/.ssh
	touch "${ROOTFS_DIR}"/home/"${FIRST_USER_NAME}"/.ssh/authorized_keys
	chown 1000:1000 "${ROOTFS_DIR}"/home/"${FIRST_USER_NAME}"/.ssh/authorized_keys
	chmod 0600 "${ROOTFS_DIR}"/home/"${FIRST_USER_NAME}"/.ssh/authorized_keys
fi

if [ "${PUBKEY_ONLY_SSH}" = "1" ]; then
	sed -i -Ee 's/^#?[[:blank:]]*PubkeyAuthentication[[:blank:]]*no[[:blank:]]*$/PubkeyAuthentication yes/
s/^#?[[:blank:]]*PasswordAuthentication[[:blank:]]*yes[[:blank:]]*$/PasswordAuthentication no/' "${ROOTFS_DIR}"/etc/ssh/sshd_config
fi

on_chroot << EOF
systemctl disable hwclock.sh
if [ "${ENABLE_SSH}" == "1" ]; then
	systemctl enable ssh
else
	systemctl disable ssh
fi
systemctl enable regenerate_ssh_host_keys
EOF

install -m 644 files/80-usb.rules "${ROOTFS_DIR}/etc/udev/rules.d/"
install -m 644 files/timesyncd.conf "${ROOTFS_DIR}/etc/systemd/"

install -m 644 files/80-perf.conf "${ROOTFS_DIR}/etc/sysctl.d/"

on_chroot <<EOF
for GRP in input spi i2c gpio edisk; do
	groupadd -f -r "\$GRP"
done
for GRP in adm dialout cdrom audio users sudo video games plugdev input gpio spi i2c netdev render edisk; do
  adduser $FIRST_USER_NAME \$GRP
done
EOF

if [ -f "${ROOTFS_DIR}/etc/sudoers.d/010_pi-nopasswd" ]; then
  sed -i "s/^pi /$FIRST_USER_NAME /" "${ROOTFS_DIR}/etc/sudoers.d/010_pi-nopasswd"
fi

# Disable EEPROM auto-updating
on_chroot << EOF
systemctl mask rpi-eeprom-update
EOF

# Disabling unused services.
on_chroot << EOF
systemctl disable triggerhappy
systemctl disable getty@tty1.service
EOF

on_chroot << EOF
usermod --pass='*' root
EOF

rm -f "${ROOTFS_DIR}/etc/ssh/"ssh_host_*_key*

sed -i 's/^#\?Storage=.*/Storage=volatile/' "${ROOTFS_DIR}/etc/systemd/journald.conf"

if [ -e "${ROOTFS_DIR}/etc/avahi/avahi-daemon.conf" ]; then
  sed -i 's/^#\?publish-workstation=.*/publish-workstation=yes/' "${ROOTFS_DIR}/etc/avahi/avahi-daemon.conf"
fi

on_chroot << EOF
echo i2c_dev >> /etc/modules
EOF
