cd $PFS/sources
tar xf bash-${BASH_VERSION}.tar.gz
cd bash-${BASH_VERSION}

./configure --prefix=/usr                      \
            --build=$(sh support/config.guess) \
            --host=$PFS_TGT                    \
            --without-bash-malloc

make
make DESTDIR=$PFS install
ln -sv bash $PFS/bin/sh
