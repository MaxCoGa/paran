#!/bin/bash
set -e

cd $PFS/sources
mkdir -p bash
tar xf bash-*.tar.gz --strip-components=1 --directory=bash
pushd bash

./configure --prefix=/usr                      \
            --build=$(sh support/config.guess) \
            --host=$PFS_TGT                    \
            --without-bash-malloc

make
make DESTDIR=$PFS install
ln -sv bash $PFS/bin/sh

popd
rm -rf bash