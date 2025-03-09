cd $PFS/sources

tar xf xz-5.4.7.tar.gz
cd xz-5.4.7

./configure --prefix=/usr                     \
            --host=$PFS_TGT                     \
            --build=$(build-aux/config.guess) \
            --disable-static                  \
            --docdir=/usr/share/doc/xz-5.4.7
make
make DESTDIR=$PFS install
rm -v $PFS/usr/lib/liblzma.la 