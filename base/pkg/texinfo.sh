cd /sources
tar xf texinfo-7.1.tar.xz
cd texinfo-7.1

./configure --prefix=/usr

make
# # make check
make install

make TEXMF=/usr/share/texmf install-tex