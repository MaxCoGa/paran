#!/bin/bash
set -e

cd $PFS/sources
mkdir -p diffutils
tar xf diffutils*.tar.xz --strip-components=1 --directory=diffutils
pushd diffutils

./configure --prefix=/usr   \
            --host=$PFS_TGT \
            --build=$(./build-aux/config.guess)

make
make DESTDIR=$PFS install

popd
rm -rf diffutils