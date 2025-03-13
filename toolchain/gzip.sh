#!/bin/bash
set -e

cd $PFS/sources
mkdir -p gzip
tar xf gzip-*.tar.xz --strip-components=1 --directory=gzip
pushd gzip

./configure --prefix=/usr --host=$PFS_TGT  
make
make DESTDIR=$PFS install

popd
rm -rf gzip