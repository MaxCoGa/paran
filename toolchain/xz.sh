#!/bin/bash
set -e

cd $PFS/sources
mkdir -p xz
tar xf xz-*.tar.xz --strip-components=1 --directory=xz
pushd xz

./configure --prefix=/usr                     \
            --host=$PFS_TGT                     \
            --build=$(build-aux/config.guess) \
            --disable-static                  \
            --docdir=/usr/share/doc/xz-5.4.7
make
make DESTDIR=$PFS install
rm -v $PFS/usr/lib/liblzma.la 

popd
rm -rf xz