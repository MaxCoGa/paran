#!/bin/bash 
set -e

cd /sources
tar xf cpio-2.15.tar.bz2
cd cpio-2.15

./configure --prefix=/usr \
            --enable-mt   \
            --with-rmt=/usr/libexec/rmt &&
make &&
makeinfo --html            -o doc/html      doc/cpio.texi &&
makeinfo --html --no-split -o doc/cpio.html doc/cpio.texi &&
makeinfo --plaintext       -o doc/cpio.txt  doc/cpio.texi


# make -C doc pdf &&
# make -C doc ps

make install &&
install -v -m755 -d /usr/share/doc/cpio-2.15/html &&
install -v -m644    doc/html/* \
                    /usr/share/doc/cpio-2.15/html &&
install -v -m644    doc/cpio.{html,txt} \
                    /usr/share/doc/cpio-2.15

# install -v -m644 doc/cpio.{pdf,ps,dvi} \
#     /usr/share/doc/cpio-2.15