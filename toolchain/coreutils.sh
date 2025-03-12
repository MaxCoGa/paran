cd $PFS/sources
tar xf coreutils-*.tar.xz --strip-components=1 --directory=coreutils
pushd coreutils
./configure --prefix=/usr                     \
            --host=$PFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --enable-install-program=hostname \
            --enable-no-install-program=kill,uptime

make
make DESTDIR=$PFS install

mv -v $PFS/usr/bin/chroot              $PFS/usr/sbin
mkdir -pv $PFS/usr/share/man/man8
mv -v $PFS/usr/share/man/man1/chroot.1 $PFS/usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/'                    $PFS/usr/share/man/man8/chroot.8

popd
rm -rf coreutils