cd /sources
tar xf groff-1.23.0.tar.gz
cd groff-1.23.0

PAGE=<paper_size> ./configure --prefix=/usr

make
make check
make install