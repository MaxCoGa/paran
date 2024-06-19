cd /sources
tar xf gmp-6.3.0.tar.xz
cd gmp-6.3.0

# add for 32 bit ABI=32
./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-6.3.0

make
make html
make check 2>&1 | tee gmp-check-log
awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log #199
make install
make install-html