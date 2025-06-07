# remove for systemv

# https://www.linuxfromscratch.org/lfs/view/12.1-systemd/chapter09/network.html
ln -s /dev/null /etc/systemd/network/99-default.link

# get macadress from ip link
## NETWORKING
cat > /etc/systemd/network/10-eth-dhcp.network << "EOF"
[Match]
Name=ether0

[Network]
DHCP=ipv4

[DHCPv4]
UseDomains=true
EOF


echo "paran" > /etc/hostname


cat > /etc/hosts << "EOF"
# Begin /etc/hosts

# IPv4 and IPv6 localhost aliases
127.0.0.1       localhost
::1       ip6-localhost ip6-loopback
ff02::1   ip6-allnodes
ff02::2   ip6-allrouters

# End /etc/hosts
EOF


systemctl enable systemd-networkd

cat > /etc/resolv.conf << "EOF"
# Begin /etc/resolv.conf

domain localdomain
nameserver 8.8.8.8
nameserver 8.8.4.4

search localdomain

# End /etc/resolv.conf
EOF




## RANDOM
cat > /etc/adjtime << "EOF"
0.0 0 0.0
0
LOCAL
EOF

cat > /etc/shells << "EOF"
# Begin /etc/shells

/bin/sh
/bin/bash

# End /etc/shells
EOF

cat > /etc/bashrc << "EOF"
#!/bin/bash
# Begin /etc/bashrc
# Written for Beyond Linux From Scratch

# System wide aliases and functions.

# System wide environment variables and startup programs should go into
# /etc/profile.
# Personal environment variables and startup programs should go into ~/.bash_profile.
# Personal aliases and functions should go into ~/.bashrc

# Provides colored /bin/ls and /bin/grep commands.  Used in conjunction
# with code in /etc/profile.

alias ls='ls --color=auto'
alias ll='ls -l'
alias grep='grep --color=auto'

# Provides prompt for non-login shells, specifically shells started
# in the X environment. [Review the LFS archive thread titled
# PS1 Environment Variable for a great case study behind this script
# addendum.]

NORMAL="\[\e[0m\]"
RED="\[\e[1;31m\]"
GREEN="\[\e[1;32m\]"
if [[ $EUID == 0 ]] ; then
  PS1="$RED\u [ $NORMAL\w$RED ]# $NORMAL"
else
  PS1="$GREEN\u [ $NORMAL\w$GREEN ]\$ $NORMAL"
fi

unset RED GREEN NORMAL

# End /etc/bashrc
EOF

cat > /etc/inputrc << "EOF"
#!/bin/bash
# Begin /etc/inputrc
# Modified by Chris Lynn <roryo@roryo.dynup.net>

# Allow the command prompt to wrap to the next line
set horizontal-scroll-mode Off

# Enable 8-bit input
set meta-flag On
set input-meta On

# Turns off 8th bit stripping
set convert-meta Off

# Keep the 8th bit for display
set output-meta On

# none, visible or audible
set bell-style none

# All of the following map the escape sequence of the value
# contained in the 1st argument to the readline specific functions
"\eOd": backward-word
"\eOc": forward-word

# for linux console
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert

# for xterm
"\eOH": beginning-of-line
"\eOF": end-of-line

# for Konsole
"\e[H": beginning-of-line
"\e[F": end-of-line

# End /etc/inputrc
EOF


cat > /etc/vconsole.conf << "EOF"
KEYMAP=us
#FONT=Lat2-Terminus16
FONT="lat9w-16"
EOF

cat > /etc/locale.conf << "EOF"
LANG="en_US.UTF-8"
EOF




cat > /etc/profile << "EOF"
#!/bin/bash
# Begin /etc/profile
# Written for Beyond Linux From Scratch

# System wide environment variables and startup programs. /etc/profile

# System wide aliases and functions should go in /etc/bashrc.

# Personal environment variables and startup programs  ~/.bash_profile.
# Personal aliases and functions should go into        ~/.bashrc.

# Functions to help us manage paths.  Second argument is the name of the
# path variable to be modified (default: PATH)
pathremove () {
        local IFS=':'
        local NEWPATH
        local DIR
        local PATHVARIABLE=${2:-PATH}
        for DIR in ${!PATHVARIABLE} ; do
                if [ "$DIR" != "$1" ] ; then
                  NEWPATH=${NEWPATH:+$NEWPATH:}$DIR
                fi
        done
        export $PATHVARIABLE="$NEWPATH"
}

pathprepend () {
        pathremove $1 $2
        local PATHVARIABLE=${2:-PATH}
        export $PATHVARIABLE="$1${!PATHVARIABLE:+:${!PATHVARIABLE}}"
}

pathappend () {
        pathremove $1 $2
        local PATHVARIABLE=${2:-PATH}
        export $PATHVARIABLE="${!PATHVARIABLE:+${!PATHVARIABLE}:}$1"
}

export -f pathremove pathprepend pathappend

# Set the initial path
export PATH=/usr/bin

# Attempt to provide backward compatibility with LFS earlier than 11
if [ ! -L /bin ]; then
        pathappend /bin
fi

if [ $EUID -eq 0 ] ; then
        pathappend /usr/sbin
        if [ ! -L /sbin ]; then
                pathappend /sbin
        fi
        unset HISTFILE
fi

if [[ "$TERM" = linux ]]; then
  export LANG=C.UTF-8
else
  source /etc/locale.conf
  for i in $(locale); do
    key=${i%=*}
    if [[ -v $key ]]; then
      export $key
    fi
  done
fi

# Set up some environment variables.
export HISTSIZE=1000
export HISTIGNORE="&:[bf]g:exit"

# Set some defaults for graphical systems
#export XDG_DATA_DIRS=${XDG_DATA_DIRS:-/usr/share}
#export XDG_CONFIG_DIRS=${XDG_CONFIG_DIRS:-/etc/xdg}
#export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-/tmp/xdg-$USER}

# Set up a red prompt for root and a green one for users.
NORMAL="\[\e[0m\]"
RED="\[\e[1;31m\]"
GREEN="\[\e[1;32m\]"
if [[ $EUID == 0 ]] ; then
  PS1="$RED\u [ $NORMAL\w$RED ]# $NORMAL"
else
  PS1="$GREEN\u [ $NORMAL\w$GREEN ]\$ $NORMAL"
fi

for script in /etc/profile.d/*.sh ; do
        if [ -r $script ] ; then
                . $script
        fi
done

unset script RED GREEN NORMAL

# End /etc/profile

EOF



mkdir -pv /etc/profile.d
cat > /etc/profile.d/dircolors.sh << "EOF"
#!/bin/bash
# Setup for /bin/ls and /bin/grep to support color, the alias is in /etc/bashrc.
if [ -f "/etc/dircolors" ] ; then
        eval $(dircolors -b /etc/dircolors)
fi

if [ -f "$HOME/.dircolors" ] ; then
        eval $(dircolors -b $HOME/.dircolors)
fi
EOF



cat > /etc/profile.d/extrapaths.sh << "EOF"
#!/bin/bash
if [ -d /usr/local/lib/pkgconfig ] ; then
        pathappend /usr/local/lib/pkgconfig PKG_CONFIG_PATH
fi
if [ -d /usr/local/bin ]; then
        pathprepend /usr/local/bin
fi
if [ -d /usr/local/sbin -a $EUID -eq 0 ]; then
        pathprepend /usr/local/sbin
fi

if [ -d /usr/local/share ]; then
        pathprepend /usr/local/share XDG_DATA_DIRS
fi

# Set some defaults before other applications add to these paths.
pathappend /usr/share/info INFOPATH

EOF




cat > /etc/profile.d/i18.sh << "EOF"
#!/bin/bash
# Set up i18n variables
for i in $(locale); do
  unset ${i%=*}
done

if [[ "$TERM" = linux ]]; then
  export LANG=C.UTF-8
else
  source /etc/locale.conf

  for i in $(locale); do
    key=${i%=*}
    if [[ -v $key ]]; then
      export $key
    fi
  done
fi
EOF



cat > /etc/profile.d/readline.sh << "EOF"
#!/bin/bash
# Set up the INPUTRC environment variable.
if [ -z "$INPUTRC" -a ! -f "$HOME/.inputrc" ] ; then
        INPUTRC=/etc/inputrc
fi
export INPUTRC
EOF



cat > /etc/profile.d/umask.sh << "EOF"
#!/bin/bash
# By default, the umask should be set.
if [ "$(id -gn)" = "$(id -un)" -a $EUID -gt 99 ] ; then
  umask 002
else
  umask 022
fi
EOF



# BASH
cat > ~/.bash_login << "EOF"
#!/bin/bash
# Begin ~/.bash_login

# Personal items to perform on logout.
clear
cat<<'EOF'
           _..._
         .'     '.
        /  _   _  \
        | (o)_(o) |
         \(     ) /
         //'._.'\ \
        //   .   \ \
       ||   .     \ \
       |\   :     / |
       \ `) '   (`  /_
     _)``".____,.'"` (_
     )     )'--'(     (
      '---`      `---`
'EOF'
echo "Hello $(whoami)"

echo "Current Date and Time"
echo $(date '+%A %B %d/%Y_%H:%M:%S')

# End ~/.bash_login
EOF

cat > ~/.bash_profile << "EOF"
#!/bin/bash
# Begin ~/.bash_profile
# Written for Beyond Linux From Scratch

# Personal environment variables and startup programs.

# Personal aliases and functions should go in ~/.bashrc.

# System wide environment variables and startup programs are in /etc/profile.

# System wide aliases and functions are in /etc/bashrc.

if [ -f "$HOME/.bashrc" ] ; then
  source $HOME/.bashrc
fi

if [ -d "$HOME/bin" ] ; then
  pathprepend $HOME/bin
fi

# Having . in the PATH is dangerous
#if [ $EUID -gt 99 ]; then
#  pathappend .
#fi

# End ~/.bash_profile
EOF


cat > ~/.bashrc << "EOF"
#!/bin/bash
# Begin ~/.bashrc

# Personal aliases and functions.

# Personal environment variables and startup programs should go in ~/.bash_profile.
# System wide environment variables and startup programs are in /etc/profile.
# System wide aliases and functions are in /etc/bashrc.

if [ -f "/etc/bashrc" ] ; then
  source /etc/bashrc
fi

# Set up user specific i18n variables
export LANG=en_US.UTF-8

# End ~/.bashrc
EOF



cat > ~/.profile << "EOF"
#!/bin/bash
# Begin ~/.profile
# Personal environment variables and startup programs.

if [ -d "$HOME/bin" ] ; then
  pathprepend $HOME/bin
fi

# Set up user specific i18n variables
export LANG=en_US.UTF-8

alias ls='ls --color=auto'
alias ll='ls -l'
alias grep='grep --color=auto'

# End ~/.profile
EOF


cat > /etc/shells << "EOF"
# Begin /etc/shells

/bin/sh
/bin/bash

# End /etc/shells
EOF







# BOOT
cat > /etc/fstab << "EOF"
# Begin /etc/fstab

# file system  mount-point  type     options             dump  fsck
#                                                              order

/dev/cdrom	/media/cdrom	iso9660	noauto,ro 0 0
/dev/usbdisk	/media/usb	vfat	noauto,ro 0 0
tmpfs   /tmp    tmpfs   defaults,size=1G,nosuid,nodev,noatime,mode=1777   0   0

# End /etc/fstab
EOF



