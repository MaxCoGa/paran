#!/bin/bash

###############################################################
#                      @@@@@@@@@@@@@@@                       
#                 @@@@       @          @@@@                 
#              @@                           @@@              
#           @@                   @             @@            
#         @@                      @               @@         
#        @             @@ @        @ @@             @        
#      @@          @@    @          @    @           @@      
#     @          @      @            @      @ @@@@     @     
#    @         @       @              @   @@@%@         @    
#   @                 @  @      @      @@@@              @   
#  @        @        @ @@     @@       @@@       @        @  
# @@       @      @@@ @@    @@@       @@@                 @@ 
# @               @@  @@   @@@@@@@@@@@@                    @ 
#@@       @   @   @@ @@@@@@@@@@@@@@@@@@            @       @@
#@           @@  @@@@@@@@@@@@@@@@@@@@@@@@@@@                @
#@       @   @@@@@@@@@@@@@@@@@@@@@@@@     @@@@@@@@@@@@@@    @
#@       @   @@@@@@@@@@@@@@@@@@              @      @       @
#@       @@  @@@@@@@@@@@@@@   @@              @             @
#@        @@@@@@@@@@@@@@  @@  @@@              @            @
#@@       @@@@@@@@@@@@ @@@ @@    @              @  @       @@
# @    @    @@@@@@@@ @@@ @@                      @         @ 
# @@   @@@@@@@@@@@@@@   @@                                @@ 
#  @     @@@@@@@@@  @@@                          @        @  
#   @     @@@@@@@@@@@@                                   @   
#    @@@  @@@@@@@@     @                      @     @   @    
#     @@@@@@@@@@@@@@@@@       @             @        @ @     
#      @@@@@@@@@@@ @@         @          @         @@@@      
#        @ @@@@@@@@ @@@@@     @      @@         @   @        
#         @@@@@@@@@@          @             @     @@         
#           @@@@@@@@@@@@@@@   @          @     @@            
#              @@@@@@@@@@     @      @      @@@              
#                 @@@@@@@@@@@@@  @@     @@@@                 
#                      @@@@@@@@@@@@@@@                       
###############################################################

set -euo pipefail

# Latest stable version
PWD_DIR="$(pwd)"
PARAN_DIR="$PWD/paran"
PARAN_VERSION="indev"
PARAN_ARCH="x86_64" #x86,ARM
KERNEL_VERSION=6.8.2
BUSYBOX_VERSION=1.36.1
BASH_VERSION=5.2.21
GLIBC_VERSION=2.39
INITFILESYSTEM_VERSION=1.0.0 #TODO: maybe buildroot 


#
# INIT PARAN_DIR
#
init() {
  echo "INIT ${PARAN_DIR}";
  rm -rf $PARAN_DIR
  mkdir -p $PARAN_DIR
}


#
# GET
#
get_kernel() {
    echo "GET KERNEL";
	cd ${PARAN_DIR}
	mkdir -p kernel
	cd kernel 
	wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${KERNEL_VERSION}.tar.xz
	tar xf linux-${KERNEL_VERSION}.tar.xz
}

get_bash() {
    echo "GET BASH";
	cd ${PARAN_DIR}
	mkdir -p bin
	cd bin
	wget https://ftp.gnu.org/gnu/bash/bash-${BASH_VERSION}.tar.gz
	tar xf bash-${BASH_VERSION}.tar.gz
}

get_busybox() {
    echo "GET BUSYBOX";
	cd ${PARAN_DIR}
	mkdir -p bin
	cd bin
	wget https://busybox.net/downloads/busybox-${BUSYBOX_VERSION}.tar.bz2
	tar xf busybox-${BUSYBOX_VERSION}.tar.bz2
}

get_glibc() {
    echo "GET GLIBC";
	cd ${PARAN_DIR}
	mkdir -p bin
	cd bin
	wget http://ftp.gnu.org/gnu/libc/glibc-${GLIBC_VERSION}.tar.gz
	tar -xvf glibc-${GLIBC_VERSION}.tar.gz
}

get_initfs() {
    echo "GET INITFS";
}

get_all() {
    get_kernel;
	get_bash;
	get_busybox;
	get_initfs;
}

#
# BUILD
#
build_kernel() {
    echo "BUILDING KERNEL";
	cd ${PARAN_DIR}
	cd kernel
	cd linux-${KERNEL_VERSION}
	
	# TODO: static config
	# make menuconfig
	make x86_64_defconfig -j $(nproc)
	make -j $(nproc)

	cd ${PARAN_DIR}
	mkdir -p boot-files
	cp kernel/linux-${KERNEL_VERSION}/arch/x86/boot/bzImage boot-files
	echo "BUILD PATH KERNEL: ${PARAN_DIR}/boot-files";
}

build_bash() {
    echo "BUILDING BASH";
	cd ${PARAN_DIR}
	cd bin
	cd bash-${BASH_VERSION}
	
	./configure --without-bash-malloc
	make -j $(nproc)
	
	cd ${PARAN_DIR}
	mkdir -p bin-files
	cp bin/bash-${BASH_VERSION}/bash bin-files
	echo "BUILD PATH BASH: ${PARAN_DIR}/bin-files";
}

build_busybox() {
    echo "BUILDING BUSYBOX";
	cd ${PARAN_DIR}
	cd bin
	cd busybox-${BUSYBOX_VERSION}
	
	make defconfig
	make CONFIG_STATIC=y busybox -j $(nproc)
	
	mkdir -p ${PARAN_DIR}/boot-files/initramfs
	make CONFIG_PREFIX=${PARAN_DIR}/boot-files/initramfs install
	echo "BUILD PATH BUSYBOX: ${PARAN_DIR}/boot-files/initramfs";
}

build_glibc() {
    echo "BULDING GLIBC";
	cd ${PARAN_DIR}
	cd bin
	cd glibc-${GLIBC_VERSION}

	mkdir -p build
	mkdir -p GLIBC
	cd build
	../configure --prefix=
	make -j $(nproc)
	
	echo "INSTALL TO GLIBC";
	make install DESTDIR=${PARAN_DIR}/bin/glibc-${GLIBC_VERSION}/GLIBC -j 2 # doesnt work with more 
	echo "BUILD PATH GLIBC: ${PARAN_DIR}/bin/glibc-${GLIBC_VERSION}/GLIBC";
}

build_initfs() {
    echo "BUILDING INITFS";
	cd ${PARAN_DIR}
	# TODO: finish initramfs ; wget initramfs.gz
	
	rm -rf initfs
	mkdir initfs
	mkdir -p {initfs/bin,initfs/dev,initfs/proc,initfs/sbin,initfs/usr/bin,initfs/usr/sbin}
	cp -r ${PARAN_DIR}/initramfs/* ${PARAN_DIR}/initfs
	
	# Add dependecies
	cp -r ${PARAN_DIR}/boot-files/initramfs/* ${PARAN_DIR}/initfs # BUSYBOX
	cp -r ${PARAN_DIR}/bin-files/* ${PARAN_DIR}/initfs/bin # BASH
	cp -r ${PARAN_DIR}/bin/glibc-${GLIBC_VERSION}/GLIBC/* ${PARAN_DIR}/initfs # GLIBC maybe sysroot
	
	sed -i 's/bash/sh/' ${PARAN_DIR}/initfs/bin/ldd
	cd ${PARAN_DIR}/initfs && ln -s lib lib64
	rm ${PARAN_DIR}/initfs/linuxrc
	set +e
	strip -g \
	${PARAN_DIR}/initfs/bin/* \
	${PARAN_DIR}/initfs/sbin/* \
	${PARAN_DIR}/initfs/lib/* \
	2>/dev/null
	set -e
}

create_iso() {
	echo "CREATE ISO";
	cd ${PARAN_DIR}
	rm -rf iso
	mkdir -p iso/boot/grub
	
	cd ${PARAN_DIR}/initfs
	find . | cpio -o -H newc | gzip > ${PARAN_DIR}/iso/boot/root.cpio.gz
	cp ${PARAN_DIR}/boot-files/bzImage ${PARAN_DIR}/iso/boot/bzImage
	cp ${PWD_DIR}/config/system/grub.cfg ${PARAN_DIR}/iso/boot/grub/grub.cfg
	grub-mkrescue -o ${PARAN_DIR}/paranos.iso ${PARAN_DIR}/iso
	
	
}

build_all() {
    build_kernel;
	build_bash;
	build_busybox;
	build_initfs;
	
	create_iso;
}


#
# CLEAN
#
clean_kernel() {
    echo "CLEANING KERNEL";
}

clean_bash() {
    echo "CLEANING BASH";
}

clean_busybox() {
    echo "CLEANING BUSYBOX";
}

clean_initfs() {
    echo "CLEANING INITFS";
}

clean_all() {
    clean_kernel;
	clean_bash;
	clean_busybox;
	clean_initfs;
}


version() {
  echo "PARAN build.sh version ${PARAN_VERSION}"
}


COMMAND_LIST=(init get_kernel get_bash get_busybox get_glibc get_all build_kernel build_bash build_busybox build_glibc build_initfs build_all clean_kernel clean_all create_iso version)
if [[ "${COMMAND_LIST[@]}" =~ "$1" ]]
then
	$1
else
    echo "$1 invalid."
	echo "e.g. use $0 version"
	echo "	init"
	echo "	get"
	echo "		get_kernel get_all"
	echo "	build"
	echo "		build_kernel build_all"
	echo "	clean"
	echo "		clean_kernel clean_all"
	echo "	version"
	exit 1
fi