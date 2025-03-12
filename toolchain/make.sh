cd $PFS/sources

tar xf make-*.tar.gz --strip-components=1 --directory=make
pushd make

./configure --prefix=/usr   \
            --without-guile \
            --host=$PFS_TGT   \
            --build=$(build-aux/config.guess)
make
make DESTDIR=$PFS install

popd
rm -rf make