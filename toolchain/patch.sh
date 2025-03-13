#!/bin/bash
set -e

cd $PFS/sources
mkdir -p patch
tar xf patch-*.tar.xz --strip-components=1 --directory=patch
pushd patch

./configure --prefix=/usr   \
            --host=$PFS_TGT   \
            --build=$(build-aux/config.guess)
make
make DESTDIR=$PFS install

popd
rm -rf patch