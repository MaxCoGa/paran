# unmount VFS
umount -v $PFS/dev/pts
umount -v $PFS/dev
umount -v $PFS/run
umount -v $PFS/proc
umount -v $PFS/sys

# unmount PFS
umount -v $PFS




find . | cpio -o -H newc | gzip > ${PFS}/boot/root.cpio.gz
grub-mkrescue -o /tmp/paranos.iso ${PFS}/boot