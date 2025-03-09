cd $PFS/sources
tar xf gawk-5.3.0.tar.xz
cd gawk-5.3.0


sed -i 's/extras//' Makefile.in
./configure --prefix=/usr   \
            --host=$PFS_TGT   \
            --build=$(build-aux/config.guess)
make
make DESTDIR=$PFS install