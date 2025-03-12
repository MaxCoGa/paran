## File
cd $PFS/sources

tar xf file-*.tar.gz --strip-components=1 --directory=file
pushd file

mkdir build
pushd build
  ../configure --disable-bzlib      \
               --disable-libseccomp \
               --disable-xzlib      \
               --disable-zlib
  make
popd

./configure --prefix=/usr --host=$PFS_TGT   --build=$(./config.guess)

make FILE_COMPILE=$(pwd)/build/src/file
make DESTDIR=$PFS install

rm -v $PFS/usr/lib/libmagic.la

popd
rm -rf file