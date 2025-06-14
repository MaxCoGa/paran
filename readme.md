
# Paran OS

Current Version : indev
Supported Arch: x86x64

# Content
- [Requirements](#requirements)
- [Install](#install)
- [Compile from source](#compile-from-source)
- [Use](#Use)
- [Credits](#credits)
- [License](#license)


# Requirements

# Install

# Compile from source

./build.sh CMD
https://www.linuxjournal.com/content/diy-build-custom-minimal-linux-distribution-source
here: https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter08/aboutdebug.html
## Docker
in rootful mode!!!
e.g. podman machine set --rootful=true

image:
docker build -t ubuntudev . /-f dockerfile
or
podman build -f Dockerfile -t ubuntudev   

create container:
docker run --privileged -it --name UbuntuDev ubuntudev
or
podman run  --privileged -itd -v /mnt/pfs --name UbuntuDev ubuntudev

exec a container:
docker/podman start UbuntuDev
docker/podman exec --privileged  -it UbuntuDev bash

execute sh paranbuilder.sh

podman cp UbuntuDev:/tmp/paranos.iso .
# Use

# Credits
LFS: https://www.linuxfromscratch.org/

# License
https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/gcc-pass1.html


current base line:
https://www.linuxfromscratch.org/lfs/view/12.1/

https://www.linuxfromscratch.org/lfs/view/12.1/wget-list-sysv

to update core packages:
https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter01/whatsnew.html

wget list
https://www.linuxfromscratch.org/lfs/view/stable/chapter03/introduction.html
e.g. https://www.linuxfromscratch.org/lfs/view/stable/wget-list-sysv


https://www.linuxfromscratch.org/lfs/view/12.1-systemd/chapter08/grep.html



notes:
Boot (syslinux) -> Kernel (linux) -> User Space (bin)

mkdir /boot-files
# kernel
cp $PFS/boot/vmlinuz-6.8.2-lfs-12.1-systemd /boot-files/

# User Space
# build pkg 
# bin -> usr/bin    lib -> usr/lib    sbin -> usr/sbin
mkdir /boot-files/initramfs
cp -r $PFS/{usr,bin,sbin,lib,lib64} /boot-files/initramfs


# init file
cat > /boot-files/initramfs/init << "EOF"
#!/bin/sh

/bin/sh

EOF

chmod +x /boot-files/initramfs/init


# initramfs
cd /boot-files/initramfs/
find . | cpio -o -H newc > /boot-files/init.cpio


# syslinux
cd /boot-files
apt install syslinux dosfstools
dd if=/dev/zero of=boot bs=1M count=5000
mkfs -t fat boot

syslinux boot
mkdir tmpmount
mount boot tmpmount
cp init.cpio tmpmount
cp vmlinuz-6.8.2-lfs-12.1-systemd tmpmount
umount tmpmount





mkdir tmpmount
truncate -s 5GB boot.img
mkfs boot.img
mount boot.img tmpmount
cp rootfs/* tmpmount
umount tmpmount


apt install extlinux
extlinux -i tmpmount

cp vmlinuz tmpmount
cp initramfs/* tmpmount
mkdir tmpmount/{var,etc,root,tmp,dev,proc}
umount tmpmount

# copy boot img
podman cp UbuntuDev:/boot-files/boot .

qemu-system-x86_64 boot