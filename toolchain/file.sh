## File
cd $PFS/sources
# wget https://astron.com/pub/file/file-5.45.tar.gz
tar xf file-5.45.tar.gz
cd file-5.45

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
