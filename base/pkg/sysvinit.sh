cd /sources
tar xf sysvinit-3.08.tar.xz
cd sysvinit-3.08


patch -Np1 -i ../sysvinit-3.08-consolidated-1.patch

make

make install