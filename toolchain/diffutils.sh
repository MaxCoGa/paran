## Diffutils
cd $PFS/sources

tar xf diffutils-3.10.tar.xz
cd diffutils-3.10

./configure --prefix=/usr   \
            --host=$PFS_TGT \
            --build=$(./build-aux/config.guess)

make
make DESTDIR=$PFS install

