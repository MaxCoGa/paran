cd /sources
tar xf procps-ng-4.0.4.tar.xz
cd procps-ng-4.0.4

./configure --prefix=/usr                           \
            --docdir=/usr/share/doc/procps-ng-4.0.4 \
            --disable-static                        \
            --disable-kill                          \
            --with-systemd

make src_w_LDADD='$(LDADD) -lsystemd'
# make -k check
make install