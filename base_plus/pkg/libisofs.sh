#!/bin/bash 
set -e

cd /sources
tar xf libisofs-1.5.6.tar.gz
cd libisofs-1.5.6

./configure --prefix=/usr --disable-static &&
make

# doxygen doc/doxygen.conf

make install

install -v -dm755 /usr/share/doc/libisofs-1.5.6 &&
install -v -m644 doc/html/* /usr/share/doc/libisofs-1.5.6