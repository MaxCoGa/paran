#!/bin/bash
set -e

cd $PFS/sources
mkdir -p findutils
tar xf findutils-*.tar.xz --strip-components=1 --directory=findutils
pushd findutils

./configure --prefix=/usr                   \
            --localstatedir=/var/lib/locate \
            --host=$PFS_TGT                   \
            --build=$(build-aux/config.guess)

make
make DESTDIR=$PFS install

popd
rm -rf findutils