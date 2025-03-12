cd /sources
tar xf xz-5.4.7.tar.xz
cd xz-5.4.7


./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/xz-5.4.7

make
# make check
make install