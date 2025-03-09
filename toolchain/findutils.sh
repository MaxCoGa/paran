cd $PFS/sources
tar xf findutils-4.9.0.tar.xz
cd findutils-4.9.0


./configure --prefix=/usr                   \
            --localstatedir=/var/lib/locate \
            --host=$PFS_TGT                   \
            --build=$(build-aux/config.guess)

make
make DESTDIR=$PFS install
