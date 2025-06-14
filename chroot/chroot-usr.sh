#!/bin/bash
set -e
echo "Installing Basic System Software as chroot..."

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
uuidd:x:80:80:UUID Generation Daemon User:/dev/null:/usr/bin/false
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
input:x:24:
mail:x:34:
kvm:x:61:
uuidd:x:80:
wheel:x:97:
users:x:999:
nogroup:x:65534:
EOF

# test user, deleted later
echo "tester:x:101:101::/home/tester:/bin/bash" >> /etc/passwd
echo "tester:x:101:" >> /etc/group
install -o tester -d /home/tester

# remove i have no name (chroot) file is created
# exec /usr/bin/bash --login # will stop script

# log file WARN: wtmp, btmp, and lastlog deprecated
touch /var/log/{btmp,lastlog,faillog,wtmp}
chgrp -v utmp /var/log/lastlog
chmod -v 664  /var/log/lastlog
chmod -v 600  /var/log/btmp


#################
# BASE BUILDING #
#################
# building more pkg from sources directory
# TODO: create script

# Gettext
cd /sources
mkdir -p gettext
tar xf gettext-*.tar.xz --strip-components=1 --directory=gettext
pushd gettext

./configure --disable-shared
make
cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin
popd
rm -rf gettext

# Bison
cd /sources
mkdir -p bison
tar xf bison-*.tar.xz --strip-components=1 --directory=bison
pushd bison
./configure --prefix=/usr \
            --docdir=/usr/share/doc/bison-3.8.2

make
make install
popd
rm -rf bison

# Perl 
cd /sources
mkdir -p perl
tar xf perl-*.tar.xz --strip-components=1 --directory=perl
pushd perl
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

make
make install
popd
rm -rf perl

#Python tar xf Python-3.11.9.tar.xz https://www.python.org/ftp/python/3.11.9/Python-3.11.9.tar.xz
# 3.12.2 doesnt compile
cd /sources
mkdir -p Python
tar xf Python-*.tar.xz --strip-components=1 --directory=Python
pushd Python
./configure --prefix=/usr   \
            --enable-shared \
            --without-ensurepip

make
make install
popd
rm -rf Python


# texinfo
cd /sources
mkdir -p texinfo
tar xf texinfo-*.tar.xz --strip-components=1 --directory=texinfo
pushd texinfo

./configure --prefix=/usr

make
make install
popd
rm -rf texinfo

# Util-linux
cd /sources
mkdir -p util-linux
tar xf util-linux-*.tar.xz --strip-components=1 --directory=util-linux
pushd util-linux

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
popd
rm -rf util-linux

cd /sources
# CLEAN UP
rm -rf /usr/share/{info,man,doc}/*
find /usr/{lib,libexec} -name \*.la -delete
rm -rf /tools

#### BACKUP POINT IF NEEDED #####
## BACKUP ## https://www.linuxfromscratch.org/lfs/view/12.1/chapter07/cleanup.html
# exit
# mountpoint -q $PFS/dev/shm && umount $PFS/dev/shm
# umount $PFS/dev/pts
# umount $PFS/{sys,proc,run,dev}

# start of chapter 8
cd /sources
sh /sources/base/build_pkg.sh /sources/base/pkg
sh /sources/base/stripping.sh
sh /sources/base/cleanup.sh
cd /sources
sh /sources/base_plus/build_pkg.sh /sources/base_plus/pkg
cd /sources

echo "Done Installing Basic System Software."
# cd /sources after each scripts?
# start of chapter 9




# bash /usr/lib/udev/init-net-rules.sh

# cat /etc/udev/rules.d/70-persistent-net.rules
