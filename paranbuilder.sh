# PKG VERSION
KERNEL_VERSION=6.8.2
BUSYBOX_VERSION=1.36.1
BASH_VERSION=5.2.21
BINUTILS_VERSION=2.42
GCC_VERSION=13.2.0
GMP_VERSION=6.3.0
MPFR_VERSION=4.2.1
MPC_VERSION=1.3.1
GLIBC_VERSION=2.39
# TODO: ADD ALL VERSION HERE

# mount already done with docker/podman command
# PWD_DIR="$(pwd)"
# PARAN_DIR="$PWD/pfs"
# export PFS=/mnt/pfs 
# export PFS=$PARAN_DIR

unset CFLAGS
unset CXXFLAGS

export PFS_HOST=$(echo ${MACHTYPE} | sed "s/-[^-]*/-cross/")
export PFS_TARGET=x86_64-unknown-linux-gnu
export PFS_ARCH=$(echo ${PFS_TARGET} | sed -e 's/-.*//' -e 's/i.86/i386/')


cd $PFS
# mkdir -pv $PFS

# get sources
mkdir -v $PFS/sources
chmod -v a+wt $PFS/sources

get_sources(){
  cd $PFS/sources
  wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${KERNEL_VERSION}.tar.xz --directory-prefix=$PFS/sources
  wget https://ftp.gnu.org/gnu/bash/bash-${BASH_VERSION}.tar.gz --directory-prefix=$PFS/sources
  wget https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.xz  --directory-prefix=$PFS/sources
  wget https://ftp.gnu.org/gnu/glibc/glibc-${GLIBC_VERSION}.tar.xz  --directory-prefix=$PFS/sources
  wget https://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VERSION}.tar.xz --directory-prefix=$PFS/sources
  wget https://ftp.gnu.org/gnu/gmp/gmp-${GMP_VERSION}.tar.xz  --directory-prefix=$PFS/sources
  wget https://ftp.gnu.org/gnu/mpc/mpc-${MPC_VERSION}.tar.gz  --directory-prefix=$PFS/sources
  wget https://ftp.gnu.org/gnu/mpfr/mpfr-${MPFR_VERSION}.tar.xz  --directory-prefix=$PFS/sources
  wget https://www.zlib.net/fossils/zlib-1.3.tar.gz  --directory-prefix=$PFS/sources
  wget https://fossies.org/linux/misc/xz-5.4.7.tar.gz
  wget https://www.linuxfromscratch.org/patches/lfs/12.1/glibc-2.39-fhs-1.patch
  wget https://ftp.gnu.org/gnu/m4/m4-1.4.19.tar.xz
  wget https://anduin.linuxfromscratch.org/LFS/ncurses-6.4-20230520.tar.xz 
  wget https://ftp.gnu.org/gnu/coreutils/coreutils-9.5.tar.xz
  wget https://ftp.gnu.org/gnu/diffutils/diffutils-3.10.tar.xz
  wget https://astron.com/pub/file/file-5.45.tar.gz
  wget https://ftp.gnu.org/gnu/findutils/findutils-4.9.0.tar.xz
  wget https://ftp.gnu.org/gnu/gawk/gawk-5.3.0.tar.xz
  wget https://ftp.gnu.org/gnu/grep/grep-3.11.tar.xz
  wget https://ftp.gnu.org/gnu/gzip/gzip-1.13.tar.xz
  wget https://ftp.gnu.org/gnu/make/make-4.4.1.tar.gz
  wget https://ftp.gnu.org/gnu/patch/patch-2.7.6.tar.xz
  wget https://ftp.gnu.org/gnu/sed/sed-4.9.tar.xz
  wget https://ftp.gnu.org/gnu/tar/tar-1.35.tar.xz
  wget https://fossies.org/linux/misc/xz-5.4.6.tar.gz
  wget https://ftp.gnu.org/gnu/gettext/gettext-0.22.4.tar.xz
  wget https://ftp.gnu.org/gnu/bison/bison-3.8.2.tar.xz
  wget https://www.cpan.org/src/5.0/perl-5.38.2.tar.xz
  wget https://www.python.org/ftp/python/3.12.2/Python-3.12.2.tar.xz
  wget https://ftp.gnu.org/gnu/texinfo/texinfo-7.1.tar.xz
  wget https://www.kernel.org/pub/linux/utils/util-linux/v2.39/util-linux-2.39.3.tar.xz
}

chown root:root $PFS/sources/*




# create PFS filesystem
mkdir -pv $PFS/{etc,var} $PFS/usr/{bin,lib,sbin}

for i in bin lib sbin; do
  ln -sv usr/$i $PFS/$i
done

case $(uname -m) in
  x86_64) mkdir -pv $PFS/lib64 ;;
esac

# cc directory toolchain
mkdir -pv $PFS/tools


# sanity user
groupadd pfs
useradd -s /bin/bash -g pfs -m -k /dev/null pfs
chown -v pfs $PFS/{usr{,/*},lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown -v pfs $PFS/lib64 ;;
esac

passwd root

su - pfs

# bash profile
cat > ~/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

# bashrc
cat > ~/.bashrc << "EOF"
set +h
umask 022
PFS=/mnt/pfs
LC_ALL=POSIX
PFS_TGT=$(uname -m)-pfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$PFS/tools/bin:$PATH
CONFIG_SITE=$PFS/usr/share/config.site
export PFS LC_ALL PFS_TGT PATH CONFIG_SITE
EOF

export MAKEFLAGS=-j16

cat >> ~/.bashrc << "EOF"
export MAKEFLAGS=-j$(nproc)
EOF

source ~/.bash_profile


KERNEL_VERSION=6.8.2
BUSYBOX_VERSION=1.36.1
BASH_VERSION=5.2.21
BINUTILS_VERSION=2.42
GCC_VERSION=13.2.0
GMP_VERSION=6.3.0
MPFR_VERSION=4.2.1
MPC_VERSION=1.3.1
GLIBC_VERSION=2.39


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


# KERNEL HEADER
cd $PFS/sources
tar xf linux-${KERNEL_VERSION}.tar.xz
cd linux-${KERNEL_VERSION}

make mrproper

## extract header https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/linux-headers.html
make headers
find usr/include -type f ! -name '*.h' -delete
cp -rv usr/include $PFS/usr


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


# LIBSTDC from GCC source
cd $PFS/sources
cd gcc-${GCC_VERSION}

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


# CC TEMP TOOLS 
# https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter03/packages.html
# https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter03/patches.html


## M4
cd $PFS/sources
# wget https://ftp.gnu.org/gnu/m4/m4-1.4.19.tar.xz
tar xf m4-1.4.19.tar.xz
cd m4-1.4.19
./configure --prefix=/usr   \
            --host=$PFS_TGT \
            --build=$(build-aux/config.guess)

make
make DESTDIR=$PFS install

## NCURSES
cd $PFS/sources
# wget https://anduin.linuxfromscratch.org/LFS/ncurses-6.4-20230520.tar.xz 
# https://ftp.gnu.org/gnu/ncurses/ncurses-6.4.tar.gz change to original source
tar xf ncurses-6.4-20230520.tar.xz
cd ncurses-6.4-20230520

sed -i s/mawk// configure
mkdir build
pushd build
  ../configure
  make -C include
  make -C progs tic
popd


./configure --prefix=/usr                \
            --host=$PFS_TGT              \
            --build=$(./config.guess)    \
            --mandir=/usr/share/man      \
            --with-manpage-format=normal \
            --with-shared                \
            --without-normal             \
            --with-cxx-shared            \
            --without-debug              \
            --without-ada                \
            --disable-stripping          \
            --enable-widec

make
make DESTDIR=$PFS TIC_PATH=$(pwd)/build/progs/tic install
ln -sv libncursesw.so $PFS/usr/lib/libncurses.so
sed -e 's/^#if.*XOPEN.*$/#if 1/' \
    -i $PFS/usr/include/curses.h

## BASH
cd $PFS/sources
tar xf bash-${BASH_VERSION}.tar.gz
cd bash-${BASH_VERSION}

./configure --prefix=/usr                      \
            --build=$(sh support/config.guess) \
            --host=$PFS_TGT                    \
            --without-bash-malloc

make
make DESTDIR=$PFS install
ln -sv bash $PFS/bin/sh

## Coreutils
cd $PFS/sources
# wget https://ftp.gnu.org/gnu/coreutils/coreutils-9.5.tar.xz
tar xf coreutils-9.5.tar.xz
cd coreutils-9.5
./configure --prefix=/usr                     \
            --host=$PFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --enable-install-program=hostname \
            --enable-no-install-program=kill,uptime

make
make DESTDIR=$PFS install

mv -v $PFS/usr/bin/chroot              $PFS/usr/sbin
mkdir -pv $PFS/usr/share/man/man8
mv -v $PFS/usr/share/man/man1/chroot.1 $PFS/usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/'                    $PFS/usr/share/man/man8/chroot.8


## Diffutils
cd $PFS/sources
# wget https://ftp.gnu.org/gnu/diffutils/diffutils-3.10.tar.xz
tar xf diffutils-3.10.tar.xz
cd diffutils-3.10

./configure --prefix=/usr   \
            --host=$PFS_TGT \
            --build=$(./build-aux/config.guess)

make
make DESTDIR=$PFS install

## File
cd $PFS/sources
# wget https://astron.com/pub/file/file-5.45.tar.gz
tar xf file-5.45.tar.gz
cd file-5.45

mkdir build
pushd build
  ../configure --disable-bzlib      \
               --disable-libseccomp \
               --disable-xzlib      \
               --disable-zlib
  make
popd

./configure --prefix=/usr --host=$PFS_TGT   --build=$(./config.guess)

make FILE_COMPILE=$(pwd)/build/src/file
make DESTDIR=$PFS install

rm -v $PFS/usr/lib/libmagic.la

# Findutils
cd $PFS/sources
# wget https://ftp.gnu.org/gnu/findutils/findutils-4.9.0.tar.xz
tar xf findutils-4.9.0.tar.xz
cd findutils-4.9.0


./configure --prefix=/usr                   \
            --localstatedir=/var/lib/locate \
            --host=$PFS_TGT                   \
            --build=$(build-aux/config.guess)

make
make DESTDIR=$PFS install


# GAWK
cd $PFS/sources
# wget https://ftp.gnu.org/gnu/gawk/gawk-5.3.0.tar.xz
tar xf gawk-5.3.0.tar.xz
cd gawk-5.3.0


sed -i 's/extras//' Makefile.in
./configure --prefix=/usr   \
            --host=$PFS_TGT   \
            --build=$(build-aux/config.guess)
make
make DESTDIR=$PFS install

# Grep
cd $PFS/sources
# wget https://ftp.gnu.org/gnu/grep/grep-3.11.tar.xz
tar xf grep-3.11.tar.xz
cd grep-3.11

./configure --prefix=/usr   \
            --host=$PFS_TGT   \
            --build=$(./build-aux/config.guess)
make
make DESTDIR=$PFS install

# GZIP
cd $PFS/sources
# wget https://ftp.gnu.org/gnu/gzip/gzip-1.13.tar.xz
tar xf gzip-1.13.tar.xz
cd gzip-1.13

./configure --prefix=/usr --host=$PFS_TGT  
make
make DESTDIR=$PFS install


# MAKE
cd $PFS/sources
# wget https://ftp.gnu.org/gnu/make/make-4.4.1.tar.gz
tar xf make-4.4.1.tar.gz
cd make-4.4.1

./configure --prefix=/usr   \
            --without-guile \
            --host=$PFS_TGT   \
            --build=$(build-aux/config.guess)
make
make DESTDIR=$PFS install


# PATCH 
cd $PFS/sources
# wget https://ftp.gnu.org/gnu/patch/patch-2.7.6.tar.xz
tar xf patch-2.7.6.tar.xz
cd patch-2.7.6

./configure --prefix=/usr   \
            --host=$PFS_TGT   \
            --build=$(build-aux/config.guess)
make
make DESTDIR=$PFS install

# SED
cd $PFS/sources
# wget https://ftp.gnu.org/gnu/sed/sed-4.9.tar.xz
tar xf sed-4.9.tar.xz
cd sed-4.9

./configure --prefix=/usr   \
            --host=$PFS_TGT   \
            --build=$(./build-aux/config.guess)
make
make DESTDIR=$PFS install


# TAR
cd $PFS/sources
# wget https://ftp.gnu.org/gnu/tar/tar-1.35.tar.xz
tar xf tar-1.35.tar.xz
cd tar-1.35

./configure --prefix=/usr                     \
            --host=$PFS_TGT                     \
            --build=$(build-aux/config.guess)
make
make DESTDIR=$PFS install



# xz
cd $PFS/sources

# CVE TEMP git clone https://git.tukaani.org/?p=xz.git;a=summary
#wget https://github.com/tukaani-project/xz/releases/download/v5.4.6/xz-5.4.6.tar.xz
# wget https://fossies.org/linux/misc/xz-5.4.6.tar.gz
tar xf xz-5.4.7.tar.gz
cd xz-5.4.7
# git clone https://git.tukaani.org/xz.git
# cd xz
# git checkout tags/v5.4.6
# git status # check for the version 5.4.6


./configure --prefix=/usr                     \
            --host=$PFS_TGT                     \
            --build=$(build-aux/config.guess) \
            --disable-static                  \
            --docdir=/usr/share/doc/xz-5.4.7
make
make DESTDIR=$PFS install
rm -v $PFS/usr/lib/liblzma.la #harmful



# BINUTILS pass 2
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



# GCC pass 2
cd $PFS/sources
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



# exit pfs user
###
# CREATE CHROOT  ch 7 with virtual kernel run these from chroot 
exit
# PFS=/paran/test/pfs

# get more pkgs
cd $PFS/sources
# wget https://ftp.gnu.org/gnu/gettext/gettext-0.22.4.tar.xz
# wget https://ftp.gnu.org/gnu/bison/bison-3.8.2.tar.xz
# wget https://www.cpan.org/src/5.0/perl-5.38.2.tar.xz
# wget https://www.python.org/ftp/python/3.12.2/Python-3.12.2.tar.xz
# wget https://ftp.gnu.org/gnu/texinfo/texinfo-7.1.tar.xz
# wget https://www.kernel.org/pub/linux/utils/util-linux/v2.39/util-linux-2.39.3.tar.xz


cd $PFS
chown -R root:root $PFS/{usr,lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown -R root:root $PFS/lib64 ;;
esac

mkdir -pv $PFS/{dev,proc,sys,run}

# temp mnt NEED TO BE REDONE IF SESSION IS EXIT!!!!
# lsof /dev/null

mount -v --bind /dev $PFS/dev

mount -vt devpts devpts -o gid=5,mode=0620 $PFS/dev/pts
mount -vt proc proc $PFS/proc
mount -vt sysfs sysfs $PFS/sys
mount -vt tmpfs tmpfs $PFS/run
###


# mountpoint -q $PFS/dev/shm && umount $PFS/dev/shm
# umount $PFS/dev/pts
# umount $PFS/{sys,proc,run,dev}

if [ -h $PFS/dev/shm ]; then
  install -v -d -m 1777 $PFS$(realpath /dev/shm)
else
  mount -vt tmpfs -o nosuid,nodev tmpfs $PFS/dev/shm
fi

chroot "$PFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(pfs chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin     \
    MAKEFLAGS="-j$(nproc)"      \
    TESTSUITEFLAGS="-j$(nproc)" \
    /bin/bash --login

## create directory struture https://refspecs.linuxfoundation.org/fhs.shtml FHS COMPLIANCE
mkdir -pv /{boot,home,mnt,opt,srv}
mkdir -pv /etc/{opt,sysconfig}
mkdir -pv /lib/firmware
mkdir -pv /media/{floppy,cdrom}
mkdir -pv /usr/{,local/}{include,src}
mkdir -pv /usr/local/{bin,lib,sbin}
mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -pv /usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv /usr/{,local/}share/man/man{1..8}
mkdir -pv /var/{cache,local,log,mail,opt,spool}
mkdir -pv /var/lib/{color,misc,locate}


ln -sfv /run /var/run
ln -sfv /run/lock /var/lock

install -dv -m 0750 /root
install -dv -m 1777 /tmp /var/tmp

# essential files and symlinks
ln -sv /proc/self/mounts /etc/mtab

cat > /etc/hosts << EOF
127.0.0.1  localhost $(hostname)
::1        localhost
EOF

cat > /etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/usr/bin/false
daemon:x:6:6:Daemon User:/dev/null:/usr/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/run/dbus:/usr/bin/false
systemd-journal-gateway:x:73:73:systemd Journal Gateway:/:/usr/bin/false
systemd-journal-remote:x:74:74:systemd Journal Remote:/:/usr/bin/false
systemd-journal-upload:x:75:75:systemd Journal Upload:/:/usr/bin/false
systemd-network:x:76:76:systemd Network Management:/:/usr/bin/false
systemd-resolve:x:77:77:systemd Resolver:/:/usr/bin/false
systemd-timesync:x:78:78:systemd Time Synchronization:/:/usr/bin/false
systemd-coredump:x:79:79:systemd Core Dumper:/:/usr/bin/false
uuidd:x:80:80:UUID Generation Daemon User:/dev/null:/usr/bin/false
systemd-oom:x:81:81:systemd Out Of Memory Daemon:/:/usr/bin/false
nobody:x:65534:65534:Unprivileged User:/dev/null:/usr/bin/false
EOF

cat > /etc/group << "EOF"
root:x:0:
bin:x:1:daemon
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
cdrom:x:15:
adm:x:16:
messagebus:x:18:
systemd-journal:x:23:
input:x:24:
mail:x:34:
kvm:x:61:
systemd-journal-gateway:x:73:
systemd-journal-remote:x:74:
systemd-journal-upload:x:75:
systemd-network:x:76:
systemd-resolve:x:77:
systemd-timesync:x:78:
systemd-coredump:x:79:
uuidd:x:80:
systemd-oom:x:81:
wheel:x:97:
users:x:999:
nogroup:x:65534:
EOF


# test user, deleted later
echo "tester:x:101:101::/home/tester:/bin/bash" >> /etc/passwd
echo "tester:x:101:" >> /etc/group
install -o tester -d /home/tester

# remove i have no name (chroot) file is created
exec /usr/bin/bash --login

# log file WARN: wtmp, btmp, and lastlog deprecated
touch /var/log/{btmp,lastlog,faillog,wtmp}
chgrp -v utmp /var/log/lastlog
chmod -v 664  /var/log/lastlog
chmod -v 600  /var/log/btmp



# building more pkg from sources directory
cd /sources

# Gettext
tar xf gettext-0.22.4.tar.xz
cd gettext-0.22.4

./configure --disable-shared
make
cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin

# Bison
cd /sources
tar xf bison-3.8.2.tar.xz
cd bison-3.8.2
./configure --prefix=/usr \
            --docdir=/usr/share/doc/bison-3.8.2

make
make install

# Perl doesnt work with chroot
cd /sources
tar xf perl-5.38.2.tar.xz
cd perl-5.38.2
sh Configure -des                                        \
             -Dprefix=/usr                               \
             -Dvendorprefix=/usr                         \
             -Duseshrplib                                \
             -Dprivlib=/usr/lib/perl5/5.38/core_perl     \
             -Darchlib=/usr/lib/perl5/5.38/core_perl     \
             -Dsitelib=/usr/lib/perl5/5.38/site_perl     \
             -Dsitearch=/usr/lib/perl5/5.38/site_perl    \
             -Dvendorlib=/usr/lib/perl5/5.38/vendor_perl \
             -Dvendorarch=/usr/lib/perl5/5.38/vendor_perl


# LC_ALL=POSIX
# PFS_TGT=$(uname -m)-pfs-linux-gnu

# without chroot is working
# sh Configure -des                                        \
#              -Dprefix=$PFS/usr                               \
#              -Dvendorprefix=$PFS/usr                         \
#              -Duseshrplib                                \
#              -Dprivlib=$PFS/usr/lib/perl5/5.38/core_perl     \
#              -Darchlib=$PFS/usr/lib/perl5/5.38/core_perl     \
#              -Dsitelib=$PFS/usr/lib/perl5/5.38/site_perl     \
#              -Dsitearch=$PFS/usr/lib/perl5/5.38/site_perl    \
#              -Dvendorlib=$PFS/usr/lib/perl5/5.38/vendor_perl \
#              -Dvendorarch=$PFS/usr/lib/perl5/5.38/vendor_perl
# comment out /dev/null part from configure for docker...

# target is wrong???
make
make install

####  doesnt work with chroot
#Python tar xf Python-3.11.9.tar.xz https://www.python.org/ftp/python/3.11.9/Python-3.11.9.tar.xz
# 3.12.2 doesnt compile
cd /sources
tar xf Python-3.12.2.tar.xz
cd  Python-3.12.2
./configure --prefix=/usr   \
            --enable-shared \
            --without-ensurepip

# without chroot...
# ./configure --prefix=$PFS/usr   \
#             --enable-shared \
#             --without-ensurepip

make
make install


# texinfo
cd /sources
tar xf texinfo-7.1.tar.xz
cd  texinfo-7.1

./configure --prefix=/usr
./configure --prefix=$PFS/usr

make
make install

# Util-linux
cd /sources
tar xf util-linux-2.39.3.tar.xz
cd  util-linux-2.39.3

mkdir -pv /var/lib/hwclock

./configure --libdir=/usr/lib    \
            --runstatedir=/run   \
            --disable-chfn-chsh  \
            --disable-login      \
            --disable-nologin    \
            --disable-su         \
            --disable-setpriv    \
            --disable-runuser    \
            --disable-pylibmount \
            --disable-static     \
            --without-python     \
            ADJTIME_PATH=/var/lib/hwclock/adjtime \
            --docdir=/usr/share/doc/util-linux-2.39.3

make
make install

wget 


# CLEAN UP
rm -rf /usr/share/{info,man,doc}/*
find /usr/{lib,libexec} -name \*.la -delete
rm -rf /tools

## BACKUP ## https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter07/cleanup.html
exit
mountpoint -q $PFS/dev/shm && umount $PFS/dev/shm
umount $PFS/dev/pts
umount $PFS/{sys,proc,run,dev}

cd $PFS
tar -cJpf $HOME/lfs-temp-tools-12.1-systemd.tar.xz .
## DOCKER BUILD END ##