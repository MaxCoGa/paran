cd /sources
tar xf diffutils-3.10.tar.xz
cd diffutils-3.10

./configure --prefix=/usr

make
make check
make install