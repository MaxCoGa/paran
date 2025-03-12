cd /sources
tar xf less-643.tar.gz
cd less-643

./configure --prefix=/usr --sysconfdir=/etc

make
# make check
make install