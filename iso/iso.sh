git clone https://github.com/emmett1/mkinitrd

wget -c http://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-6.03.tar.xz


# isolinux : syslinux files to boot
# boot : kernel, initrd and squashed system
# rootfs : act like root
mkdir -p /live/{isolinux,boot}



tar xvf syslinux-6.03.tar.xz
cp syslinux-6.03/bios/com32/elflink/ldlinux/ldlinux.c32 /live/isolinux
cp syslinux-6.03/bios/com32/chain/chain.c32 /live/isolinux
cp syslinux-6.03/bios/core/isolinux.bin /live/isolinux
cp syslinux-6.03/bios/com32/libutil/libutil.c32 /live/isolinux
cp syslinux-6.03/bios/com32/modules/reboot.c32 /live/isolinux
cp syslinux-6.03/bios/com32/menu/menu.c32 /live/isolinux
cp syslinux-6.03/bios/com32/lib/libcom32.c32 /live/isolinux
cp syslinux-6.03/bios/com32/modules/poweroff.c32 /live/isolinux


mksquashfs $PFS /live/boot/filesystem.sfs \
    -b 1048576 \
    -comp zstd \
    -e $PFS/root/* \
    -e $PFS/tools* \
    -e $PFS/tmp/* \
    -e $PFS/dev/* \
    -e $PFS/proc/* \
    -e $PFS/sys/* \
    -e $PFS/run/* \
    -e $PFS/sources/*

cd mkinitrd
make -C mkinitrd DESTDIR=$PFS install
make DESTDIR="/mnt/pfs" install

# install base_plus

# chroot
mkinitrd -k 6.8.2 -a livecd -o /boot/initrd-6.8.2.img

mkinitramfs 6.8.2

# host
cp -v $PFS/boot/vmlinuz-6.8.2-lfs-12.1-systemd /live/boot/vmlinuz
cp -v $PFS/boot/initrd.img-6.8.2 /live/boot/initrd


cat > /live/isolinux/isolinux.cfg << "EOF"
UI /isolinux/menu.c32
DEFAULT silent
TIMEOUT 100

MENU VSHIFT 3

LABEL silent
        MENU LABEL Boot MyOwn Linux
	KERNEL /boot/vmlinuz
	APPEND initrd=/boot/initrd quiet 

LABEL debug
        MENU LABEL MyOwn Linux (Debug)
	KERNEL /boot/vmlinuz
	APPEND initrd=/boot/initrd verbose

LABEL existing
	MENU LABEL Boot existing OS
	COM32 chain.c32
	APPEND hd0 0

LABEL reboot
        MENU LABEL Reboot
        COM32 reboot.c32

LABEL poweroff
        MENU LABEL Poweroff
        COM32 poweroff.c32
EOF



mkdir -p /live/rootfs/etc
echo "# blank fstab" > /live/rootfs/etc/fstab



# FROM ROOT
cd /
xorriso -as mkisofs \
    -isohybrid-mbr $PFS/sources/syslinux-6.03/bios/mbr/isohdpfx.bin \
    -c isolinux/boot.cat \
    -b isolinux/isolinux.bin \
    -no-emul-boot \
    -boot-load-size 4 \
    -boot-info-table \
    -eltorito-alt-boot \
    -no-emul-boot \
    -isohybrid-gpt-basdat \
    -volid LIVECD \
    -o p.iso live






####
cat > /etc/fstab << "EOF"
# Begin /etc/fstab

# file system  mount-point    type     options             dump  fsck
#                                                                order

/dev/sr0     /              udf,iso9660 noauto,user,ro 0 0           1     1
proc           /proc          proc     nosuid,noexec,nodev 0     0
sysfs          /sys           sysfs    nosuid,noexec,nodev 0     0
devpts         /dev/pts       devpts   gid=5,mode=620      0     0
tmpfs          /run           tmpfs    defaults            0     0
devtmpfs       /dev           devtmpfs mode=0755,nosuid    0     0
tmpfs          /dev/shm       tmpfs    nosuid,nodev        0     0
cgroup2        /sys/fs/cgroup cgroup2  nosuid,noexec,nodev 0     0

# End /etc/fstab
EOF