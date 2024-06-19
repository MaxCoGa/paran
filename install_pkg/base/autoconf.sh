cd /sources
tar xf autoconf-2.72.tar.xz
cd autoconf-2.72

./configure --prefix=/usr

make
make check
make install