# GCC pass 2
#!/bin/bash
set -e

cd $PFS/sources
pushd gcc


tar -xf ../mpfr-*.t*ar.xz
mv -v mpfr-* mpfr
tar -xf ../gmp-*.tar.xz
mv -v gmp-* gmp
tar -xf ../mpc-*.tar.gz
mv -v mpc-* mpc

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac

sed '/thread_header =/s/@.*@/gthr-posix.h/' \
    -i libgcc/Makefile.in libstdc++-v3/include/Makefile.in

mkdir -v build2
cd       build2

../configure                                       \
    --build=$(../config.guess)                     \
    --host=$PFS_TGT                                \
    --target=$PFS_TGT                              \
    LDFLAGS_FOR_TARGET=-L$PWD/$PFS_TGT/libgcc      \
    --prefix=/usr                                  \
    --with-build-sysroot=$PFS                      \
    --enable-default-pie                           \
    --enable-default-ssp                           \
    --disable-nls                                  \
    --disable-multilib                             \
    --disable-libatomic                            \
    --disable-libgomp                              \
    --disable-libquadmath                          \
    --disable-libsanitizer                         \
    --disable-libssp                               \
    --disable-libvtv                               \
    --enable-languages=c,c++

make
# https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter06/gcc-pass2.html
make DESTDIR=$PFS install
ln -sv gcc $PFS/usr/bin/cc

popd
rm -rf gcc