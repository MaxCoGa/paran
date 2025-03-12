cd /sources
tar xf mpfr-4.2.1.tar.xz
cd mpfr-4.2.1

./configure --prefix=/usr        \
            --disable-static     \
            --enable-thread-safe \
            --docdir=/usr/share/doc/mpfr-4.2.1

make
make html
# make check #198
make install
make install-html