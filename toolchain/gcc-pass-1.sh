# GCC pass 1
cd $PFS/sources
tar xf gcc-${GCC_VERSION}.tar.xz
cd gcc-${GCC_VERSION}


tar -xf ../mpfr-${MPFR_VERSION}.tar.xz
mv -v mpfr-${MPFR_VERSION} mpfr
tar -xf ../gmp-${GMP_VERSION}.tar.xz
mv -v gmp-${GMP_VERSION} gmp
tar -xf ../mpc-${MPC_VERSION}.tar.gz
mv -v mpc-${MPC_VERSION} mpc

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
 ;;
esac

mkdir -v build
cd       build

../configure                  \
    --target=$PFS_TGT         \
    --prefix=$PFS/tools       \
    --with-glibc-version=2.39 \
    --with-sysroot=$PFS       \
    --with-newlib             \
    --without-headers         \
    --enable-default-pie      \
    --enable-default-ssp      \
    --disable-nls             \
    --disable-shared          \
    --disable-multilib        \
    --disable-threads         \
    --disable-libatomic       \
    --disable-libgomp         \
    --disable-libquadmath     \
    --disable-libssp          \
    --disable-libvtv          \
    --disable-libstdcxx       \
    --enable-languages=c,c++

make
make install
cd ..
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  `dirname $($PFS_TGT-gcc -print-libgcc-file-name)`/include/limits.h