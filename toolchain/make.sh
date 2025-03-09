cd $PFS/sources
tar xf make-4.4.1.tar.gz
cd make-4.4.1

./configure --prefix=/usr   \
            --without-guile \
            --host=$PFS_TGT   \
            --build=$(build-aux/config.guess)
make
make DESTDIR=$PFS install