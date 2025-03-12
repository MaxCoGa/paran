cd $PFS/sources

tar xf tar-*.tar.xz --strip-components=1 --directory=tar
pushd tar

./configure --prefix=/usr                     \
            --host=$PFS_TGT                     \
            --build=$(build-aux/config.guess)
make
make DESTDIR=$PFS install

popd
rm -rf tar