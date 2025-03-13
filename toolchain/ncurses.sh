#!/bin/bash
set -e

cd $PFS/sources
mkdir -p ncurses
tar xf ncurses-*.tar.xz --strip-components=1 --directory=ncurses
pushd ncurses

sed -i s/mawk// configure
mkdir build
pushd build
  ../configure
  make -C include
  make -C progs tic
popd


./configure --prefix=/usr                \
            --host=$PFS_TGT              \
            --build=$(./config.guess)    \
            --mandir=/usr/share/man      \
            --with-manpage-format=normal \
            --with-shared                \
            --without-normal             \
            --with-cxx-shared            \
            --without-debug              \
            --without-ada                \
            --disable-stripping          \
            --enable-widec

make
make DESTDIR=$PFS TIC_PATH=$(pwd)/build/progs/tic install
ln -sv libncursesw.so $PFS/usr/lib/libncurses.so
sed -e 's/^#if.*XOPEN.*$/#if 1/' \
    -i $PFS/usr/include/curses.h

popd
rm -rf ncurses