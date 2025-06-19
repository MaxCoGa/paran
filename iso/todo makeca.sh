# makeca

# dep:
# https://www.linuxfromscratch.org/blfs/view/svn/general/libtasn1.html
# https://www.linuxfromscratch.org/blfs/view/svn/postlfs/p11-kit.html

# source:
# https://www.linuxfromscratch.org/blfs/view/svn/postlfs/make-ca.html





wget --no-check-certificate https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.20.0.tar.gz
tar -xf libtasn1-4.20.0.tar.gz
cd libtasn1-4.20.0

./configure --prefix=/usr --disable-static
make
make install
make -C doc/reference install-data-local





wget --no-check-certificate https://github.com/p11-glue/p11-kit/releases/download/0.25.5/p11-kit-0.25.5.tar.xz
tar -xf p11-kit-0.25.5.tar.xz
cd p11-kit-0.25.5

sed '20,$ d' -i trust/trust-extract-compat &&

cat >> trust/trust-extract-compat << "EOF"
# Copy existing anchor modifications to /etc/ssl/local
/usr/libexec/make-ca/copy-trust-modifications

# Update trust stores
/usr/sbin/make-ca -r
EOF


mkdir p11-build &&
cd    p11-build &&

meson setup ..            \
      --prefix=/usr       \
      --buildtype=release \
      -D trust_paths=/etc/pki/anchors &&
ninja


ninja install &&
ln -sfv /usr/libexec/p11-kit/trust-extract-compat \
        /usr/bin/update-ca-certificates


ln -sfv ./pkcs11/p11-kit-trust.so /usr/lib/libnssckbi.so





wget --no-check-certificate https://github.com/lfs-book/make-ca/archive/v1.16.1/make-ca-1.16.1.tar.gz
tar -xf make-ca-1.16.1.tar.gz
cd make-ca-1.16.1

make install &&
install -vdm755 /etc/ssl/local

# WARNING no /dev/stdin error or else, make sure that /dev is mount on /mnt/pfs...
/usr/sbin/make-ca -g