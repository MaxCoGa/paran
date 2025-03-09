# GLIBC
cd $PFS/sources
tar xf glibc-${GLIBC_VERSION}.tar.xz
cd glibc-${GLIBC_VERSION}

case $(uname -m) in
    i?86)   ln -sfv ld-linux.so.2 $PFS/lib/ld-lsb.so.3
    ;;
    x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 $PFS/lib64
            ln -sfv ../lib/ld-linux-x86-64.so.2 $PFS/lib64/ld-lsb-x86-64.so.3
    ;;
esac

# wget https://www.linuxfromscratch.org/patches/lfs/12.1/glibc-2.39-fhs-1.patch
patch -Np1 -i ../glibc-2.39-fhs-1.patch

mkdir -v build
cd       build

echo "rootsbindir=/usr/sbin" > configparms

../configure                             \
      --prefix=/usr                      \
      --host=$PFS_TGT                    \
      --build=$(../scripts/config.guess) \
      --enable-kernel=4.19               \
      --with-headers=$PFS/usr/include    \
      --disable-nscd                     \
      libc_cv_slibdir=/usr/lib

make
make DESTDIR=$PFS install
sed '/RTLDLIST=/s@/usr@@g' -i $PFS/usr/bin/ldd
# test glib : output = [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]
echo 'int main(){}' | $PFS_TGT-gcc -xc -
readelf -l a.out | grep ld-linux
rm -v a.out