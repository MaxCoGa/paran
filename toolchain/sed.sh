cd $PFS/sources

tar xf sed-4.9.tar.xz
cd sed-4.9

./configure --prefix=/usr   \
            --host=$PFS_TGT   \
            --build=$(./build-aux/config.guess)
make
make DESTDIR=$PFS install
