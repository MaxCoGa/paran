#!/bin/bash
set -e

cd $PFS/sources

mkdir -p linux
tar xf linux-*.tar.xz --strip-components=1 --directory=linux
pushd linux

make mrproper
## extract header https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/linux-headers.html
make headers
find usr/include -type f ! -name '*.h' -delete
cp -rv usr/include $PFS/usr

popd
rm -rf linux