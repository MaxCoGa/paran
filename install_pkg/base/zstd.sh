cd /sources
tar xf zstd-1.5.5.tar.gz
cd zstd-1.5.5

make prefix=/usr
make check
make prefix=/usr install
rm -v /usr/lib/libzstd.a