cd /sources
tar xf dbus-1.14.10.tar.xz
cd dbus-1.14.10

./configure --prefix=/usr                        \
            --sysconfdir=/etc                    \
            --localstatedir=/var                 \
            --runstatedir=/run                   \
            --enable-user-session                \
            --disable-static                     \
            --disable-doxygen-docs               \
            --disable-xml-docs                   \
            --docdir=/usr/share/doc/dbus-1.14.10 \
            --with-system-socket=/run/dbus/system_bus_socket

make
# # make check
make install

ln -sfv /etc/machine-id /var/lib/dbus