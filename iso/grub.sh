# https://www.linuxfromscratch.org/blfs/view/12.1/postlfs/grub-setup.html
mkdir -p /boot/grub
cat > /iso/boot/grub/grub.cfg << "EOF"
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

menuentry "Linux From Scratch" {
    linux /vmlinuz-6.8.2-lfs-12.1-systemd rw root=/dev/sda ro console=ttyS0
    initrd /initramfs.img
}
EOF


cat > /boot/grub/grub.cfg << "EOF"
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod part_gpt
insmod ext2
set root=(hd0,2)

menuentry "GNU/Linux, Linux 6.7.4-lfs-12.1" {
        linux   /boot/vmlinuz-6.7.4-lfs-12.1 root=/dev/sda2 ro
}
EOF