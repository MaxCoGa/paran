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
KERNEL_VERSION=6.7.3
BUSYBOX_VERSION=1.36.1
BASH_VERSION=5.2.21


#
# INIT PARAN_DIR
#
init() {
  rm -rf $PARAN_DIR
  mkdir $PARAN_DIR
}


#
# GET
#
get_kernel() {
    echo "GET KERNEL";
}

get_all() {
    get_kernel;
}

#
# BUILD
#
build_kernel() {
    echo "BUILDING KERNEL";
}

build_all() {
    build_kernel;
}


#
# CLEAN
#
clean_kernel() {
    echo "CLEANING KERNEL";
}

clean_all() {
    clean_kernel;
}


version() {
  echo "PARAN build.sh version ${PARAN_VERSION}"
}


COMMAND_LIST=(get_kernel get_all build_kernel build_all clean_kernel clean_all version)
if [[ "${COMMAND_LIST[@]}" =~ "$1" ]]
then
	$1
else
    echo "$1 invalid."
	echo "e.g. use $0 version"
	echo "	get"
	echo "		get_kernel get_all"
	echo "	build"
	echo "		build_kernel build_all"
	echo "	clean"
	echo "		clean_kernel clean_all"
	echo "	version"
	exit 1
fi