cd /sources
tar xf acl-2.3.2.tar.xz
cd acl-2.3.2

./configure --prefix=/usr         \
            --disable-static      \
            --docdir=/usr/share/doc/acl-2.3.2
make
make install