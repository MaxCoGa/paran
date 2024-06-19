cd /sources
tar xf m4-1.4.19.tar.xz
cd m4-1.4.19

./configure --prefix=/usr
make
make check
make install