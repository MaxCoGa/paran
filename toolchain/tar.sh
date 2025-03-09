cd $PFS/sources

tar xf tar-1.35.tar.xz
cd tar-1.35

./configure --prefix=/usr                     \
            --host=$PFS_TGT                     \
            --build=$(build-aux/config.guess)
make
make DESTDIR=$PFS install
