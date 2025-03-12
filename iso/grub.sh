# https://www.linuxfromscratch.org/blfs/view/12.1/postlfs/grub-setup.html
mkdir /boot/grub
cat > /boot/grub/grub.cfg << "EOF"
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod part_gpt
insmod ext2
set root=(hd0,2)

insmod all_video
if loadfont /boot/grub/fonts/unicode.pf2; then
  terminal_output gfxterm
fi

menuentry "GNU/Linux, Linux 6.8.2-paran" {
        linux   /vmlinuz-6.8.2-lfs-12.1-systemd root=/dev/sda2 ro
        initrd /root.cpio.gz
}
EOF