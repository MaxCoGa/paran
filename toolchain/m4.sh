cd $PFS/sources

tar xf m4-1.4.19.tar.xz
cd m4-1.4.19
./configure --prefix=/usr   \
            --host=$PFS_TGT \
            --build=$(build-aux/config.guess)

make
make DESTDIR=$PFS install