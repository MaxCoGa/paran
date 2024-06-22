cd /sources
tar xf expat-2.6.2.tar.xz
cd expat-2.6.2

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/expat-2.6.2

make
# make check
make install
install -v -m644 doc/*.{html,css} /usr/share/doc/expat-2.6.2