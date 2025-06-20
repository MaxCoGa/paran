cd /sources
tar xf linux-6.8.12.tar.xz
cd linux-6.8.12

make mrproper
make defconfig
make menuconfig
make
make modules_install
make firmware_install


	make x86_64_defconfig -j $(nproc)
	make -j $(nproc)
# Run make menuconfig, navigate to File systems -> Miscellaneous filesystems, and enable SquashFS as built-in ([*]).



cp -iv arch/x86/boot/bzImage /boot/vmlinuz-6.8.12-lfs-12.1
cp -iv System.map /boot/System.map-6.8.12
cp -iv .config /boot/config-6.8.12
cp -r Documentation -T /usr/share/doc/linux-6.8.12

install -v -m755 -d /etc/modprobe.d
cat > /etc/modprobe.d/usb.conf << "EOF"
# Begin /etc/modprobe.d/usb.conf

install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

# End /etc/modprobe.d/usb.conf
EOF