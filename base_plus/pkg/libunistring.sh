#!/bin/bash
set -e

cd /sources
tar xf libunistring-1.1.tar.xz
cd libunistring-1.1

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/libunistring-1.1 &&
make

make install