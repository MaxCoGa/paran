cd /sources
tar xf systemd-255.tar.gz
cd systemd-255

sed -i -e 's/GROUP="render"/GROUP="video"/' \
       -e 's/GROUP="sgx", //' rules.d/50-udev-default.rules.in

patch -Np1 -i ../systemd-255-upstream_fixes-1.patch

mkdir -p build
cd       build

meson setup \
      --prefix=/usr                 \
      --buildtype=release           \
      -Ddefault-dnssec=no           \
      -Dfirstboot=false             \
      -Dinstall-tests=false         \
      -Dldconfig=false              \
      -Dsysusers=false              \
      -Drpmmacrosdir=no             \
      -Dhomed=disabled              \
      -Duserdb=false                \
      -Dman=disabled                \
      -Dmode=release                \
      -Dpamconfdir=no               \
      -Ddev-kvm-mode=0660           \
      -Dnobody-group=nogroup        \
      -Dsysupdate=disabled          \
      -Dukify=disabled              \
      -Ddocdir=/usr/share/doc/systemd-255 \
      ..

ninja
ninja install

tar -xf ../../systemd-man-pages-255.tar.xz \
    --no-same-owner --strip-components=1   \
    -C /usr/share/man

systemd-machine-id-setup
systemctl preset-all