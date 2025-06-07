#!/bin/bash 
# https://www.linuxfromscratch.org/blfs/view/12.1/basicnet/curl.html
set -e

cd /sources
tar xf curl-8.6.0.tar.xz
cd curl-8.6.0

./configure --prefix=/usr                           \
            --disable-static                        \
            --with-openssl                          \
            --enable-threaded-resolver              \
            --with-ca-path=/etc/ssl/certs &&
make

make install &&

rm -rf docs/examples/.deps &&

find docs \( -name Makefile\* -o  \
             -name \*.1       -o  \
             -name \*.3       -o  \
             -name CMakeLists.txt \) -delete &&

cp -v -R docs -T /usr/share/doc/curl-8.6.0