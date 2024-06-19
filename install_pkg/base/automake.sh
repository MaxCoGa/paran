cd /sources
tar xf automake-1.16.5.tar.xz
cd automake-1.16.5

./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.16.5

make
make -j$(($(nproc)>4?$(nproc):4)) check
make install