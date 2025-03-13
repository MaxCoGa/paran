#!/bin/bash
set -e

# export MAKEFLAGS="-j 16"

# Envrionment Setup
# bash profile
# cat > ~/.bash_profile << "EOF"
# exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
# EOF
cat > ~/.bash_profile << "EOF"
# No exec here, just set variables
HOME=$HOME
TERM=$TERM
PS1='\u:\w\$ '
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
export MAKEFLAGS=-j$(nproc)
EOF

# cat >> ~/.bashrc << "EOF"
# export MAKEFLAGS=-j$(nproc)
# EOF

# source ~/.bash_profile
source ~/.bashrc

##########################
# BUILDING THE TOOLCHAIN #
##########################
## ch.5 Compiling a Cross-Toolchain
# BINUTILS pass 1
cd $PFS/sources
sh $PFS/sources/toolchain/build_toolchain.sh $PFS/sources/toolchain