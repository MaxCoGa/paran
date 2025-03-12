cd /sources
tar xf gettext-0.22.4.tar.xz
cd gettext-0.22.4

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/gettext-0.22.4

make
# make check
make install
chmod -v 0755 /usr/lib/preloadable_libintl.so