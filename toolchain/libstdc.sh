# LIBSTDC from GCC source
cd $PFS/sources
pushd gcc

mkdir -v libstd-build
cd       libstd-build

../libstdc++-v3/configure           \
    --host=$PFS_TGT                 \
    --build=$(../config.guess)      \
    --prefix=/usr                   \
    --disable-multilib              \
    --disable-nls                   \
    --disable-libstdcxx-pch         \
    --with-gxx-include-dir=/tools/$PFS_TGT/include/c++/13.2.0

make
make DESTDIR=$PFS install
rm -v $PFS/usr/lib/lib{stdc++{,exp,fs},supc++}.la
popd