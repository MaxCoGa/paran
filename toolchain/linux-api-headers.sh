cd $PFS/sources
tar xf linux-${KERNEL_VERSION}.tar.xz
cd linux-${KERNEL_VERSION}

make mrproper
## extract header https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/linux-headers.html
make headers
find usr/include -type f ! -name '*.h' -delete
cp -rv usr/include $PFS/usr
