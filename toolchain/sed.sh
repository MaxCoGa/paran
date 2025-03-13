#!/bin/bash
set -e

cd $PFS/sources
mkdir -p sed
tar xf sed-*.tar.xz --strip-components=1 --directory=sed
pushd sed

./configure --prefix=/usr   \
            --host=$PFS_TGT   \
            --build=$(./build-aux/config.guess)
make
make DESTDIR=$PFS install

popd
rm -rf sed