# openssh 
cd /sources
wget https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-9.6p1.tar.gz
tar -xf openssh-9.6p1.tar.gz
cd openssh-9.6p1

install -v -g sys -m700 -d /var/lib/sshd &&

groupadd -g 50 sshd        &&
useradd  -c 'sshd PrivSep' \
         -d /var/lib/sshd  \
         -g sshd           \
         -s /bin/false     \
         -u 50 sshd

./configure --prefix=/usr                            \
            --sysconfdir=/etc/ssh                    \
            --with-privsep-path=/var/lib/sshd        \
            --with-default-path=/usr/bin             \
            --with-superuser-path=/usr/sbin:/usr/bin \
            --with-pid-dir=/run                      &&
make

make install &&
install -v -m755    contrib/ssh-copy-id /usr/bin     &&

install -v -m644    contrib/ssh-copy-id.1 \
                    /usr/share/man/man1              &&
install -v -m755 -d /usr/share/doc/openssh-9.6p1     &&
install -v -m644    INSTALL LICENCE OVERVIEW README* \
                    /usr/share/doc/openssh-9.6p1
                    
# https://www.linuxfromscratch.org/blfs/view/12.1/general/which.html
cd /sources
wget https://ftp.gnu.org/gnu/which/which-2.21.tar.gz
tar -xf which-2.21.tar.gz
cd which-2.21
./configure --prefix=/usr &&
make
make install


# https://www.linuxfromscratch.org/blfs/view/12.1/general/freetype2.html
cd /sources
wget https://downloads.sourceforge.net/freetype/freetype-2.13.2.tar.xz
wget https://downloads.sourceforge.net/freetype/freetype-doc-2.13.2.tar.xz
tar -xf freetype-2.13.2.tar.xz
cd freetype-2.13.2

tar -xf ../freetype-doc-2.13.2.tar.xz --strip-components=2 -C docs
sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg &&

sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" \
    -i include/freetype/config/ftoption.h  &&

./configure --prefix=/usr --enable-freetype-config --disable-static &&
make
make install
cp -v -R docs -T /usr/share/doc/freetype-2.13.2 &&
rm -v /usr/share/doc/freetype-2.13.2/freetype-config.1


#https://www.linuxfromscratch.org/blfs/view/12.1/general/fontconfig.html
cd /sources
wget https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.15.0.tar.xz
tar -xf fontconfig-2.15.0.tar.xz
cd fontconfig-2.15.0

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-docs       \
            --docdir=/usr/share/doc/fontconfig-2.15.0 &&
make
make install

