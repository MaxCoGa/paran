cd $PFS/sources
cd binutils-${BINUTILS_VERSION}

sed '6009s/$add_dir//' -i ltmain.sh


mkdir -v build2
cd       build2

../configure                   \
    --prefix=/usr              \
    --build=$(../config.guess) \
    --host=$PFS_TGT            \
    --disable-nls              \
    --enable-shared            \
    --enable-gprofng=no        \
    --disable-werror           \
    --enable-64-bit-bfd        \
    --enable-default-hash-style=gnu

make
make DESTDIR=$PFS install

rm -v $PFS/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}