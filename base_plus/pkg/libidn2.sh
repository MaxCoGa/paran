#!/bin/bash 
set -e

cd /sources
tar xf libidn2-2.3.7.tar.gz
cd libidn2-2.3.7

./configure --prefix=/usr --disable-static &&
make

make install