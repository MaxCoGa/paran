cd /sources
tar xf groff-1.23.0.tar.gz
cd groff-1.23.0

PAGESIZE=letter
PAGE=$PAGESIZE ./configure --prefix=/usr

make
# make check
make install