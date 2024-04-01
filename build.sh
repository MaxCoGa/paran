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
	
}

build_initfs() {
    echo "BUILDING INITFS";
}

create_iso() {
	echo "CREATE ISO";
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


COMMAND_LIST=(init get_kernel get_bash get_busybox get_all build_kernel build_bash build_busybox build_all clean_kernel clean_all version)
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