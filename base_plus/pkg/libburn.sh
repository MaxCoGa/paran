#!/bin/bash 
set -e

cd /sources
tar xf libburn-1.5.6.tar.gz
cd libburn-1.5.6

./configure --prefix=/usr --disable-static &&
make

# doxygen doc/doxygen.conf

make install

# install -v -dm755 /usr/share/doc/libburn-1.5.6 &&
# install -v -m644 doc/html/* /usr/share/doc/libburn-1.5.6