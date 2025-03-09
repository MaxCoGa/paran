cd $PFS/sources

tar xf gzip-1.13.tar.xz
cd gzip-1.13

./configure --prefix=/usr --host=$PFS_TGT  
make
make DESTDIR=$PFS install