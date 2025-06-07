#!/bin/bash 
set -e

cd /sources
tar xf git-2.44.0.tar.xz
cd git-2.44.0

./configure --prefix=/usr \
            --with-gitconfig=/etc/gitconfig \
            --with-python=python3 &&
make

# make html
# make man

make perllibdir=/usr/lib/perl5/5.38/site_perl install