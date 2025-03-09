cd $PFS/sources

tar xf grep-3.11.tar.xz
cd grep-3.11

./configure --prefix=/usr   \
            --host=$PFS_TGT   \
            --build=$(./build-aux/config.guess)
make
make DESTDIR=$PFS install
