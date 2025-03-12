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


cp -r {bin,boot,dev,etc,home,lib,lib64,media,mnt,opt,proc,root,run,sbin,srv,sys,tmp,usr,var} pfs
find ./pfs/ | cpio -o -H newc | gzip > ${PFS}/boot/root.cpio.gz

find ./${PFS}/ | cpio -o -H newc | gzip > ${PFS}/boot/root.cpio.gz

cd $PFS
find / | cpio -o -H newc | gzip > /boot/root.cpio.gz
grub-mkrescue -o /tmp/paranos.iso ${PFS}/boot