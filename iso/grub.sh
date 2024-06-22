mkdir /boot/grub
cat > /boot/grub/grub.cfg << "EOF"
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod part_gpt
insmod ext2
set root=(hd0,2)

menuentry "GNU/Linux, Linux 6.8.2-paran" {
        linux   /boot/vmlinuz-6.8.2-lfs-12.1-systemd root=/dev/sda1 ro
        initrd /boot/root.cpio.gz
}
EOF