cd /sources
tar xf file-5.45.tar.gz
cd file-5.45

./configure --prefix=/usr
make
# make check
make install