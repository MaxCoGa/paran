cd /sources
tar xf psmisc-23.6.tar.xz
cd psmisc-23.6

./configure --prefix=/usr

make
# make check
make install