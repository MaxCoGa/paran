cd /sources
tar xf gzip-1.13.tar.xz
cd gzip-1.13

./configure --prefix=/usr

make
make check
make install