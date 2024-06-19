cd /sources
tar xf man-pages-6.06.tar.xz
cd  man-pages-6.06

rm -v man3/crypt*
make prefix=/usr install