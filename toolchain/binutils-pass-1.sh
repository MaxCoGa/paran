# BINUTILS pass 1
cd $PFS/sources
tar xf binutils-${BINUTILS_VERSION}.tar.xz
cd binutils-${BINUTILS_VERSION}
mkdir -v build
cd       build

../configure --prefix=$PFS/tools \
             --with-sysroot=$PFS \
             --target=$PFS_TGT   \
             --disable-nls       \
             --enable-gprofng=no \
             --disable-werror    \
             --enable-default-hash-style=gnu

make
make install