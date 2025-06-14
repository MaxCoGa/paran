#!/bin/bash 
set -e

cd /sources
tar xf libisoburn-1.5.6.tar.gz
cd libisoburn-1.5.6

./configure --prefix=/usr              \
            --disable-static           \
            --enable-pkg-check-modules &&
make

# doxygen doc/doxygen.conf

make install

# install -v -dm755 /usr/share/doc/libisoburn-1.5.6 &&
# install -v -m644 doc/html/* /usr/share/doc/libisoburn-1.5.6