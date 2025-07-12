# unmount VFS
umount -v $PFS/dev/pts
umount -v $PFS/dev
umount -v $PFS/run
umount -v $PFS/proc
umount -v $PFS/sys

# unmount PFS
umount -v $PFS

rm -rf tools/
rm -rf sources/







mkdir /pfs-boot
mkdir /pfs-boot/rootfs
cp -r $PFS/{bin,boot,dev,etc,home,lib,lib64,media,mnt,opt,proc,root,run,sbin,srv,sys,tmp,usr,var} /pfs-boot/rootfs



cd /pfs-boot

mkdir -p iso/boot/grub

mksquashfs rootfs/ iso/rootfs.squashfs -comp xz

cp rootfs/boot/vmlinuz-6.8.2-lfs-12.1 iso/boot/vmlinuz
# cp rootfs/boot/initrd.img-* iso/boot/initrd.img


cat << EOF > iso/boot/grub/grub.cfg
set default="0"
set timeout="5"

menuentry "pfs" {
    linux /boot/vmlinuz root=/dev/ram0 rw
    initrd /boot/initrd.img
}
EOF


mkdir -p initrd
cd initrd
mkdir -p bin dev proc sys mnt/root

wget https://busybox.net/downloads/busybox-1.37.0.tar.bz2
tar -xf busybox-1.37.0.tar.bz2
cd busybox-1.37.0
make menuconfig # static library
make -j 8
make CONFIG_PREFIX=../initrd install



# mkdir -p initrd/lib/modules/6.8.2   #$(ls rootfs/boot/vmlinuz-* | grep -o '[0-9].*')
# cp rootfs/lib/modules/6.8.2/kernel/fs/squashfs/squashfs.ko initrd/lib/modules/6.8.2/

cat << EOF > /pfs-boot/initrd/init
#!/bin/sh
set -x
mount -t devtmpfs devtmpfs /dev || echo "Failed to mount /dev"
mount -t proc proc /proc || echo "Failed to mount /proc"
mount -t sysfs sysfs /sys || echo "Failed to mount /sys"

# Verify rootfs.squashfs exists
ls -l /rootfs.squashfs || echo "rootfs.squashfs not found"

# Mount the ISO's rootfs.squashfs
mount -o loop /rootfs.squashfs /mnt/root || echo "Failed to mount rootfs.squashfs"

# Verify /sbin/init exists
ls -l /mnt/root/sbin/init || echo "/sbin/init not found"

# Switch to the new root filesystem
exec switch_root /mnt/root /sbin/init || echo "Failed to switch_root"
EOF
chmod +x /pfs-boot/initrd/init


cp ../iso/rootfs.squashfs .
find . | cpio -o -H newc | gzip > ../iso/boot/initrd.img
cd ..

grub-mkrescue -o p.iso iso








find ${PFS} | cpio -o -H newc | gzip > ${PFS}/boot/initrd.img
mkinitramfs -o ${PFS}/boot/initrd.img

cd $PFS
find / | cpio -o -H newc | gzip > /boot/initrd.img

grub-mkrescue -o /tmp/paranos.iso ${PFS}/boot

grub-mkimage -O i386-pc -o /iso/boot/grub/boot.img --prefix=/boot/grub -c /iso/boot/grub/grub.cfg ext2
genisoimage -o lfs.iso -b boot/grub/boot.img -c boot.catalog -no-emul-boot -boot-load-size 4 -boot-info-table -R -J -v /iso

grub-mkimage -O i386-pc -o /boot/grub/boot.img --prefix=/boot/grub -c /boot/grub/grub.cfg ext2

cpio missing


mkdir -p boot/grub/
find . | cpio -o -H newc | gzip > ${PARAN_DIR}/iso/boot/root.cpio.gz
find ${PFS} | cpio -o -H newc | gzip > initrd.img
cp ${PFS}/boot/vmlinuz* bzImage
cp ${PFS}/boot/grub/grub.cfg boot/grub/grub.cfg
grub-mkrescue -o ${PARAN_DIR}/paranos.iso ${PARAN_DIR}/iso



mkdir -p bin sbin lib lib64 etc dev proc sys tmp usr/bin usr/sbin
cp -a $PFS/bin/* bin/
cp -a $PFS/sbin/* sbin/
cp -a $PFS/lib/* lib/
cp -a $PFS/lib64/* lib64/  # If 64-bit system
cp -a $PFS/etc/* etc/
cp -a $PFS/usr/bin/* usr/bin/
cp -a $PFS/usr/sbin/* usr/sbin/



mkdir -p /iso/boot/grub
cat << EOF > /iso/boot/grub/grub.cfg
set default=0
set timeout=5

menuentry "LFS" {
    linux /vmlinuz-6.8.2-lfs-12.1-systemd root=/dev/sr0 ro console=ttyS0
}
EOF




make CONFIG_STATIC=y -j$(nproc)
cat << EOF > init
#!/bin/sh
exec /bin/sh
EOF
chmod +x init



cat << EOF > iso/boot/grub/grub.cfg
set timeout=5
set default=0
menuentry "Minimal Linux" {
    linux /boot/vmlinuz quiet init=/init
    initrd /boot/initrd.img
}

EOF