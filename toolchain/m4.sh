#!/bin/bash
set -e

cd $PFS/sources
mkdir -p m4
tar xf m4-*.tar.xz --strip-components=1 --directory=m4
pushd m4

./configure --prefix=/usr   \
            --host=$PFS_TGT \
            --build=$(build-aux/config.guess)

make
make DESTDIR=$PFS install

popd
rm -rf m4