#!/bin/bash
set -e

cd /sources
tar xf libpsl-0.21.5.tar.gz
cd libpsl-0.21.5

mkdir build &&
cd    build &&

meson setup --prefix=/usr --buildtype=release &&

ninja

ninja install