#!/bin/bash 
set -e

cd /sources
tar xf libarchive-3.7.2.tar.xz
cd libarchive-3.7.2

./configure --prefix=/usr --disable-static &&
make

make install