#!/bin/bash
set -e

# mount already done with docker/podman command
# PWD_DIR="$(pwd)"
# PARAN_DIR="$PWD/pfs"
# export PFS=/mnt/pfs 
# export PFS=$PARAN_DIR

unset CFLAGS
unset CXXFLAGS

# not use
export PFS_HOST=$(echo ${MACHTYPE} | sed "s/-[^-]*/-cross/")
export PFS_TARGET=x86_64-unknown-linux-gnu
export PFS_ARCH=$(echo ${PFS_TARGET} | sed -e 's/-.*//' -e 's/i.86/i386/')

chmod +x /paran-src/helper/*.sh
sh /paran-src/helper/bash-fix.sh
# sh /paran-src/helper/requirements.sh # TODO: fix this one

##########################
# BUILDING THE TOOLCHAIN #
##########################
cd $PFS
# mkdir -pv $PFS

# Ch. 3
# get sources
mkdir -v $PFS/sources
chmod -v a+wt $PFS/sources

# add helper script
cp -r /paran-src/base/ $PFS/sources
cp -r /paran-src/base_plus/ $PFS/sources
cp -r /paran-src/toolchain $PFS/sources
cp -r /paran-src/chroot $PFS/sources
chmod +x $PFS/sources/toolchain/*.sh 
chmod +x $PFS/sources/base/*.sh 
chmod +x $PFS/sources/base/pkg/*.sh 
chmod +x $PFS/sources/base_plus/*.sh 
chmod +x $PFS/sources/base_plus/pkg/*.sh 
chmod +x $PFS/sources/chroot/*.sh 

cd $PFS/sources
sh $PFS/sources/base/get_pkg.sh $PFS/sources/base
sh $PFS/sources/base_plus/get_pkg.sh $PFS/sources/base_plus
cd $PFS

chown root:root $PFS/sources/*



# Ch. 4
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

#passwd root
# echo "pfs ALL = NOPASSWD : ALL" >> /etc/sudoers
# switch to pfs user
# su - pfs -c "/paran-src/pfs.sh"
su pfs -c "/paran-src/pfs.sh" # toolchain

# # Envrionment Setup
# # bash profile
# cat > ~/.bash_profile << "EOF"
# exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
# EOF

# # bashrc
# cat > ~/.bashrc << "EOF"
# set +h
# umask 022
# PFS=/mnt/pfs
# LC_ALL=POSIX
# PFS_TGT=$(uname -m)-pfs-linux-gnu
# PATH=/usr/bin
# if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
# PATH=$PFS/tools/bin:$PATH
# CONFIG_SITE=$PFS/usr/share/config.site
# export PFS LC_ALL PFS_TGT PATH CONFIG_SITE
# EOF

# cat >> ~/.bashrc << "EOF"
# export MAKEFLAGS=-j$(nproc)
# EOF

# source ~/.bash_profile

# ##########################
# # BUILDING THE TOOLCHAIN #
# ##########################
# ## ch.5 Compiling a Cross-Toolchain
# # BINUTILS pass 1
# cd $PFS/sources
# sh $PFS/sources/toolchain/build_toolchain.sh $PFS/sources/toolchain


###################
### CHROOT TOOLCHAIN

# exit pfs user
# exit
###
# CREATE CHROOT  ch 7 with virtual kernel run these from chroot 

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

# as root https://www.linuxfromscratch.org/lfs/view/12.1-systemd/chapter07/chroot.html
chroot "$PFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(pfs chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin     \
    MAKEFLAGS="-j$(nproc)"      \
    TESTSUITEFLAGS="-j$(nproc)" \
    /bin/bash --login           \
    -c "sh /sources/chroot/chroot-usr.sh"


# chroot /mnt/pfs/ /bin/bash

# building
# https://www.linuxfromscratch.org/lfs/view/12.1-systemd/chapter09/chapter09.html



# # networking
# echo "paranos-infdev" > /etc/hostname

# # locale
# locale -a
# LC_ALL=en_US.utf8 locale charmap
# LC_ALL=en_US.utf8 locale language
# LC_ALL=en_US.utf8 locale int_curr_symbol
# LC_ALL=en_US.utf8 locale int_prefix

# cat > /etc/locale.conf << "EOF"
# LANG=<ll>_<CC>.<charmap><@modifiers>
# EOF

# cat > /etc/profile << "EOF"
# # Begin /etc/profile

# for i in $(locale); do
#   unset ${i%=*}
# done

# if [[ "$TERM" = linux ]]; then
#   export LANG=C.UTF-8
# else
#   source /etc/locale.conf

#   for i in $(locale); do
#     key=${i%=*}
#     if [[ -v $key ]]; then
#       export $key
#     fi
#   done
# fi

# # End /etc/profile
# EOF

# # inputrc
# cat > /etc/inputrc << "EOF"
# # Begin /etc/inputrc
# # Modified by Chris Lynn <roryo@roryo.dynup.net>

# # Allow the command prompt to wrap to the next line
# set horizontal-scroll-mode Off

# # Enable 8-bit input
# set meta-flag On
# set input-meta On

# # Turns off 8th bit stripping
# set convert-meta Off

# # Keep the 8th bit for display
# set output-meta On

# # none, visible or audible
# set bell-style none

# # All of the following map the escape sequence of the value
# # contained in the 1st argument to the readline specific functions
# "\eOd": backward-word
# "\eOc": forward-word

# # for linux console
# "\e[1~": beginning-of-line
# "\e[4~": end-of-line
# "\e[5~": beginning-of-history
# "\e[6~": end-of-history
# "\e[3~": delete-char
# "\e[2~": quoted-insert

# # for xterm
# "\eOH": beginning-of-line
# "\eOF": end-of-line

# # for Konsole
# "\e[H": beginning-of-line
# "\e[F": end-of-line

# # End /etc/inputrc
# EOF

# # shells
# cat > /etc/shells << "EOF"
# # Begin /etc/shells

# /bin/sh
# /bin/bash

# # End /etc/shells
# EOF





# ### https://www.linuxfromscratch.org/lfs/view/12.1-systemd/chapter10/chapter10.html
# # fstab
# cat > /etc/fstab << "EOF"
# # Begin /etc/fstab

# # file system  mount-point  type     options             dump  fsck
# #                                                              order

# /dev/sda2     /            ext4    defaults            1     1
# /dev/sda5     swap         swap     pri=1               0     0

# # End /etc/fstab
# EOF


# ## Kernel
# cd /sources
# # tar
# cd linux-6.8.12/  
# make mrproper
