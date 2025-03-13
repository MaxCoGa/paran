#!/bin/bash
set -e

cd $PFS/sources
mkdir -p gawk
tar xf gawk-*.tar.xz --strip-components=1 --directory=gawk
pushd gawk

sed -i 's/extras//' Makefile.in
./configure --prefix=/usr   \
            --host=$PFS_TGT   \
            --build=$(build-aux/config.guess)
make
make DESTDIR=$PFS install

popd
rm -rf gawk