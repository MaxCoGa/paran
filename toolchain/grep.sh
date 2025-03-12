cd $PFS/sources

tar xf grep-*.tar.xz --strip-components=1 --directory=grep
pushd grep

./configure --prefix=/usr   \
            --host=$PFS_TGT   \
            --build=$(./build-aux/config.guess)
make
make DESTDIR=$PFS install

popd
rm -rf grep