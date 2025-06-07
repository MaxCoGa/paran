#!/bin/bash
set -e

cd /sources
tar xf wget-1.21.4.tar.gz
cd wget-1.21.4

./configure --prefix=/usr      \
            --sysconfdir=/etc  \
            --with-ssl=openssl &&
make

make install