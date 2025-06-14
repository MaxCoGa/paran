# Verify the LFS Filesystem
mkdir /lfs-iso
cp -a /mnt/pfs/* /lfs-iso/
rm -rf /lfs-iso/proc /lfs-iso/sys /lfs-iso/dev /lfs-iso/tmp
rm -rf $PFS/proc $PFS/sys $PFS/dev $PFS/tmp

# configure bootloader
mkdir -p /lfs-iso/boot/grub
cat << EOF > /lfs-iso/boot/grub/grub.cfg
set default=0
set timeout=5

menuentry "Linux From Scratch" {
    linux /boot/vmlinuz root=/dev/ram0
    initrd /boot/initrd.img
}
EOF


cp /mnt/pfs/boot/vmlinuz* /lfs-iso/boot/vmlinuz
cp /mnt/pfs/boot/initrd.img* /lfs-iso/boot/ 2>/dev/null || true

grub-mkimage -O i386-pc -o /boot/grub/boot.img --prefix=/boot/grub -c /boot/grub/grub.cfg ext2

grub-mkimage -O i386-pc -o /lfs-iso/boot/grub/boot.img --prefix=/boot/grub -c /lfs-iso/boot/grub/grub.cfg ext2
genisoimage -o lfs.iso -b boot/grub/boot.img -c boot.catalog -no-emul-boot -boot-load-size 4 -boot-info-table -R -J -v /lfs-iso







mkdir rootfs
cd rootfs
mkdir -p bin sbin lib lib64 etc dev proc sys tmp usr/bin usr/sbin


cp -a $PFS/bin/* bin/  # Basic shell and commands
cp -a $PFS/sbin/init sbin/                 # System init
cp -a $PFS/lib/* lib/  # Core libraries
cp -a $PFS/lib64/* lib64/  # For 64-bit

find . | cpio -o -H newc | gzip > /boot/test/initramfs.img







find . | cpio -o -H newc | gzip > ${PARAN_DIR}/iso/boot/root.cpio.gz
cp ${PARAN_DIR}/boot-files/bzImage ${PARAN_DIR}/iso/boot/bzImage
cp ${PWD_DIR}/config/system/grub.cfg ${PARAN_DIR}/iso/boot/grub/grub.cfg
grub-mkrescue -o ${PARAN_DIR}/paranos.iso ${PARAN_DIR}/iso