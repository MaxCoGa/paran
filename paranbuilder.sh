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
PWD_DIR="$(pwd)"
PARAN_DIR="$PWD/pfs"
# export PFS=/mnt/pfs 
# export PFS=$PARAN_DIR

mkdir -pv $PFS

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
  wget https://fossies.org/linux/misc/xz-5.4.6.tar.gz
  wget https://www.linuxfromscratch.org/patches/PFS/12.1/glibc-2.39-fhs-1.patch
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


