# BINUTILS pass 1
cd $PFS/sources
tar xf binutils-*.tar.xz --strip-components=1 --directory=binutils
pushd binutils
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

popd