# xfce
#optional Valgrind
#ICU xorg
#libxml2 xorg
# libxslt
cd /sources
wget https://download.gnome.org/sources/libxslt/1.1/libxslt-1.1.39.tar.xz
tar -xf libxslt-1.1.39.tar.xz
cd libxslt-1.1.39

./configure --prefix=/usr                          \
            --disable-static                       \
            --docdir=/usr/share/doc/libxslt-1.1.39 \
            PYTHON=/usr/bin/python3 &&
make

make install

# PCRE2
cd /sources
wget https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.42/pcre2-10.42.tar.bz2
tar -xf pcre2-10.42.tar.bz2
cd pcre2-10.42

./configure --prefix=/usr                       \
            --docdir=/usr/share/doc/pcre2-10.42 \
            --enable-unicode                    \
            --enable-jit                        \
            --enable-pcre2-16                   \
            --enable-pcre2-32                   \
            --enable-pcre2grep-libz             \
            --enable-pcre2grep-libbz2           \
            --enable-pcre2test-libreadline      \
            --disable-static                    &&
make

make install

#glib https://www.linuxfromscratch.org/blfs/view/12.1/general/glib2.html
cd /sources
wget https://download.gnome.org/sources/glib/2.78/glib-2.78.4.tar.xz
wget https://www.linuxfromscratch.org/patches/blfs/12.1/glib-skip_warnings-1.patch
tar -xf glib-2.78.4.tar.xz
cd glib-2.78.4

patch -Np1 -i ../glib-skip_warnings-1.patch

mkdir build &&
cd    build &&

meson setup ..            \
      --prefix=/usr       \
      --buildtype=release \
      -Dman=true          &&
ninja

ninja install &&

mkdir -p /usr/share/doc/glib-2.78.4 &&
cp -r ../docs/reference/{gio,glib,gobject} /usr/share/doc/glib-2.78.4

# gobject-introspection
cd /sources
wget https://download.gnome.org/sources/gobject-introspection/1.78/gobject-introspection-1.78.1.tar.xz
tar -xf gobject-introspection-1.78.1.tar.xz
cd gobject-introspection-1.78.1

mkdir build &&
cd    build &&

meson setup --prefix=/usr --buildtype=release .. &&
ninja

ninja install

# libxfce4util
cd /sources
wget https://archive.xfce.org/src/xfce/libxfce4util/4.18/libxfce4util-4.18.2.tar.bz2
tar -xf libxfce4util-4.18.2.tar.bz2
cd libxfce4util-4.18.2

./configure --prefix=/usr &&
make
make install

# xfconf
cd /sources
wget https://archive.xfce.org/src/xfce/xfconf/4.18/xfconf-4.18.3.tar.bz2
tar -xf xfconf-4.18.3.tar.bz2
cd xfconf-4.18.3

./configure --prefix=/usr &&
make
make install

# startup-notification
cd /sources
wget https://www.freedesktop.org/software/startup-notification/releases/startup-notification-0.12.tar.gz
tar -xf startup-notification-0.12.tar.gz
cd startup-notification-0.12

./configure --prefix=/usr --disable-static &&
make

make install &&
install -v -m644 -D doc/startup-notification.txt \
    /usr/share/doc/startup-notification-0.12/startup-notification.txt

# gsettings-desktop-schemas
cd /sources
wget https://download.gnome.org/sources/gsettings-desktop-schemas/45/gsettings-desktop-schemas-45.0.tar.xz
tar -xf gsettings-desktop-schemas-45.0.tar.xz
cd gsettings-desktop-schemas-45.0

sed -i -r 's:"(/system):"/org/gnome\1:g' schemas/*.in &&

mkdir build &&
cd    build &&

meson setup --prefix=/usr --buildtype=release .. &&
ninja

ninja install

# at-spi2-core
cd /sources
wget https://download.gnome.org/sources/at-spi2-core/2.50/at-spi2-core-2.50.1.tar.xz
tar -xf at-spi2-core-2.50.1* # todo: to this for all
cd at-spi2-core-2.50.1

mkdir build &&
cd    build &&

meson setup ..            \
      --prefix=/usr       \
      --buildtype=release \
      -Dsystemd_user_dir=/tmp &&
ninja

ninja install &&
rm /tmp/at-spi-dbus-bus.service

# shared-mime-info
cd /sources
wget https://gitlab.freedesktop.org/xdg/shared-mime-info/-/archive/2.4/shared-mime-info-2.4.tar.gz
wget https://anduin.linuxfromscratch.org/BLFS/xdgmime/xdgmime.tar.xz
tar -xf shared-mime-info-2.4*
cd shared-mime-info-2.4

tar -xf ../xdgmime.tar.xz &&
make -C xdgmime

mkdir build &&
cd    build &&

meson setup --prefix=/usr --buildtype=release -Dupdate-mimedb=true .. &&
ninja

ninja install

# libjpeg-turbo
cd /sources
wget https://downloads.sourceforge.net/libjpeg-turbo/libjpeg-turbo-3.0.1.tar.gz
tar -xf libjpeg-turbo-3.0.1*
cd libjpeg-turbo-3.0.1

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr        \
      -DCMAKE_BUILD_TYPE=RELEASE         \
      -DENABLE_STATIC=FALSE              \
      -DCMAKE_INSTALL_DEFAULT_LIBDIR=lib \
      -DCMAKE_INSTALL_DOCDIR=/usr/share/doc/libjpeg-turbo-3.0.1 \
      .. &&
make

make install

# docutils
cd /sources
wget https://files.pythonhosted.org/packages/source/d/docutils/docutils-0.20.1.tar.gz
tar -xf docutils-0.20.1.tar.gz
cd docutils-0.20.1

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD

pip3 install --no-index --find-links=dist --no-cache-dir --no-user docutils &&

for f in /usr/bin/rst*.py; do
  ln -svf $(basename $f) /usr/bin/$(basename $f .py)
done

rm -rfv /usr/bin/__pycache__

# gdk-pixbuf add deps https://www.linuxfromscratch.org/blfs/view/12.1/x/gdk-pixbuf.html
cd /sources
wget https://download.gnome.org/sources/gdk-pixbuf/2.42/gdk-pixbuf-2.42.10.tar.xz
tar -xf gdk-pixbuf-2.42.10*
cd gdk-pixbuf-2.42.10

mkdir build &&
cd    build &&

meson setup ..            \
      --prefix=/usr       \
      --buildtype=release \
      --wrap-mode=nofallback &&
ninja

ninja install

# Graphite2
cd /sources
wget https://github.com/silnrsi/graphite/releases/download/1.3.14/graphite2-1.3.14.tgz
tar -xf graphite2-1.3.14.tgz
cd graphite2-1.3.14

sed -i '/cmptest/d' tests/CMakeLists.txt

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr .. &&
make
make install

# HarfBuzz rebuild for cairo
cd /sources
wget https://github.com/harfbuzz/harfbuzz/releases/download/8.3.0/harfbuzz-8.3.0.tar.xz
tar -xf harfbuzz-8.3.0.tar.xz
cd harfbuzz-8.3.0

mkdir build &&
cd    build &&

meson setup ..            \
      --prefix=/usr       \
      --buildtype=release \
      -Dgraphite2=enabled &&
ninja

ninja install

# reinstall freetype
cd /sources
wget https://downloads.sourceforge.net/freetype/freetype-2.13.2.tar.xz
wget https://downloads.sourceforge.net/freetype/freetype-doc-2.13.2.tar.xz
tar -xf freetype-2.13.2.tar.xz
cd freetype-2.13.2

tar -xf ../freetype-doc-2.13.2.tar.xz --strip-components=2 -C docs
sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg &&

sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" \
    -i include/freetype/config/ftoption.h  &&

./configure --prefix=/usr --enable-freetype-config --disable-static &&
make
make install
cp -v -R docs -T /usr/share/doc/freetype-2.13.2 &&
rm -v /usr/share/doc/freetype-2.13.2/freetype-config.1

# FriBidi
cd /sources
wget https://github.com/fribidi/fribidi/releases/download/v1.0.13/fribidi-1.0.13.tar.xz
tar -xf fribidi-1.0.13.tar.xz
cd fribidi-1.0.13

mkdir build &&
cd    build &&

meson setup --prefix=/usr --buildtype=release .. &&
ninja
ninja install

# cairo +rebuild HarfBuzz
cd /sources
wget https://www.cairographics.org/releases/cairo-1.18.0.tar.xz
tar -xf cairo-1.18.0.tar.xz
cd cairo-1.18.0

mkdir build &&
cd    build &&

meson setup --prefix=/usr --buildtype=release .. &&
ninja

ninja install

# pango
cd /sources
wget https://download.gnome.org/sources/pango/1.51/pango-1.51.2.tar.xz
tar -xf pango-1.51.2.tar.xz
cd pango-1.51.2

mkdir build &&
cd    build &&

meson setup --prefix=/usr          \
            --buildtype=release    \
            --wrap-mode=nofallback \
            ..                     &&
ninja

ninja install

# libxkbcommon
cd /sources
wget https://xkbcommon.org/download/libxkbcommon-1.6.0.tar.xz
tar -xf libxkbcommon-1.6.0.tar.xz
cd libxkbcommon-1.6.0

mkdir build &&
cd    build &&

meson setup ..            \
      --prefix=/usr       \
      --buildtype=release \
      -Denable-docs=false &&
ninja
ninja install

# ISO Codes
cd /sources
wget https://ftp.debian.org/debian/pool/main/i/iso-codes/iso-codes_4.18.0.orig.tar.xz
tar -xf iso-codes_4.18.0.orig.tar.xz
cd iso-codes_4.18.0

./configure --prefix=/usr &&
make

sed -i '/^LN_S/s/s/sfvn/' */Makefile

make install


# sassc
cd /sources
wget https://github.com/sass/sassc/archive/3.6.2/sassc-3.6.2.tar.gz
wget https://github.com/sass/libsass/archive/3.6.6/libsass-3.6.6.tar.gz
tar -xf sassc-3.6.2.tar.gz
cd sassc-3.6.2

tar -xf ../libsass-3.6.6.tar.gz &&
pushd libsass-3.6.6 &&

autoreconf -fi &&

./configure --prefix=/usr --disable-static &&
make
make install

popd &&
autoreconf -fi &&

./configure --prefix=/usr &&
make
make install

# docbook-xsl-nons config: https://www.linuxfromscratch.org/blfs/view/12.1/pst/docbook-xsl.html
cd /sources
wget https://github.com/docbook/xslt10-stylesheets/releases/download/release/1.79.2/docbook-xsl-nons-1.79.2.tar.bz2
wget https://www.linuxfromscratch.org/patches/blfs/12.1/docbook-xsl-nons-1.79.2-stack_fix-1.patch
wget https://github.com/docbook/xslt10-stylesheets/releases/download/release/1.79.2/docbook-xsl-doc-1.79.2.tar.bz2
tar -xf docbook-xsl-nons-1.79.2.tar.bz2
cd docbook-xsl-nons-1.79.2

patch -Np1 -i ../docbook-xsl-nons-1.79.2-stack_fix-1.patch
tar -xf ../docbook-xsl-doc-1.79.2.tar.bz2 --strip-components=1

install -v -m755 -d /usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2 &&

cp -v -R VERSION assembly common eclipse epub epub3 extensions fo        \
         highlighting html htmlhelp images javahelp lib manpages params  \
         profiling roundtrip slides template tests tools webhelp website \
         xhtml xhtml-1_1 xhtml5                                          \
    /usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2 &&

ln -s VERSION /usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2/VERSION.xsl &&

install -v -m644 -D README \
                    /usr/share/doc/docbook-xsl-nons-1.79.2/README.txt &&
install -v -m644    RELEASE-NOTES* NEWS* \
                    /usr/share/doc/docbook-xsl-nons-1.79.2

cp -v -R doc/* /usr/share/doc/docbook-xsl-nons-1.79.2


# GTK+ https://www.linuxfromscratch.org/blfs/view/12.1/x/gtk3.html todo: adwaita
cd /sources
wget https://download.gnome.org/sources/gtk+/3.24/gtk+-3.24.41.tar.xz
tar -xf gtk+-3.24.41.tar.xz
cd gtk+-3.24.41

mkdir build &&
cd    build &&
meson setup --prefix=/usr           \
            --buildtype=release     \
            -Dman=true              \
            -Dbroadway_backend=true \
            ..                      &&
ninja

ninja install

# https://www.linuxfromscratch.org/blfs/view/12.1/x/adwaita-icon-theme.html after require gtk
# libxfce4ui
cd /sources
wget https://archive.xfce.org/src/xfce/libxfce4ui/4.18/libxfce4ui-4.18.5.tar.bz2
tar -xf libxfce4ui-4.18.5.tar.bz2
cd libxfce4ui-4.18.5

./configure --prefix=/usr --sysconfdir=/etc &&
make
make install

#exo
cd /sources
wget https://archive.xfce.org/src/xfce/exo/4.18/exo-4.18.0.tar.bz2
tar -xf exo-4.18.0.tar.bz2
cd exo-4.18.0

./configure --prefix=/usr --sysconfdir=/etc &&
make
make install

# garcon
cd /sources
wget https://archive.xfce.org/src/xfce/garcon/4.18/garcon-4.18.2.tar.bz2
tar -xf garcon-4.18.2.tar.bz2
cd garcon-4.18.2

./configure --prefix=/usr --sysconfdir=/etc &&
make
make install

# libwnck
cd /sources
wget https://download.gnome.org/sources/libwnck/43/libwnck-43.0.tar.xz
tar -xf libwnck-43.0.tar.xz
cd libwnck-43.0

mkdir build &&
cd    build &&

meson setup --prefix=/usr --buildtype=release .. &&
ninja
ninja install

# xfce4-panel
cd /sources
wget https://archive.xfce.org/src/xfce/xfce4-panel/4.18/xfce4-panel-4.18.5.tar.bz2
tar -xf xfce4-panel-4.18.5*
cd xfce4-panel-4.18.5

./configure --prefix=/usr --sysconfdir=/etc &&
make
make install


#hicolor-icon-theme
cd /sources
wget https://icon-theme.freedesktop.org/releases/hicolor-icon-theme-0.17.tar.xz
tar -xf hicolor-icon-theme-0.17*
cd hicolor-icon-theme-0.17

./configure --prefix=/usr
make install

#libgudev
cd /sources
wget https://download.gnome.org/sources/libgudev/238/libgudev-238.tar.xz
tar -xf libgudev-238*
cd libgudev-238

mkdir build &&
cd    build &&

meson setup --prefix=/usr --buildtype=release .. &&
ninja
ninja install

#libnotify
cd /sources
wget https://download.gnome.org/sources/libnotify/0.8/libnotify-0.8.3.tar.xz
tar -xf libnotify-0.8.3*
cd libnotify-0.8.3

mkdir build &&
cd    build &&

meson setup --prefix=/usr       \
            --buildtype=release \
            -Dgtk_doc=false     \
            -Dman=false         \
            ..                  &&
ninja

ninja install &&
if [ -e /usr/share/doc/libnotify ]; then
  rm -rf /usr/share/doc/libnotify-0.8.3
  mv -v  /usr/share/doc/libnotify{,-0.8.3}
fi

#libogg
cd /sources
wget https://downloads.xiph.org/releases/ogg/libogg-1.3.5.tar.xz
tar -xf libogg-1.3.5*
cd libogg-1.3.5

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/libogg-1.3.5 &&
make
make install

#libvorbis
cd /sources
wget https://downloads.xiph.org/releases/vorbis/libvorbis-1.3.7.tar.xz
tar -xf libvorbis-1.3.7*
cd libvorbis-1.3.7

./configure --prefix=/usr --disable-static &&
make

make install &&
install -v -m644 doc/Vorbis* /usr/share/doc/libvorbis-1.3.7

#gstreamer
cd /sources
wget https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.22.10.tar.xz
tar -xf gstreamer-1.22.10*
cd gstreamer-1.22.10

mkdir build &&
cd    build &&

meson  setup ..            \
       --prefix=/usr       \
       --buildtype=release \
       -Dgst_debug=false   \
       -Dpackage-origin=https://www.linuxfromscratch.org/blfs/view/12.1/ \
       -Dpackage-name="GStreamer 1.22.10 BLFS" &&
ninja

rm -rf /usr/bin/gst-* /usr/{lib,libexec}/gstreamer-1.0

ninja install

#alsa-lib deps https://www.linuxfromscratch.org/blfs/view/12.1/general/elogind.html TODO https://www.linuxfromscratch.org/blfs/view/12.1/multimedia/alsa-lib.html kernel
cd /sources
wget https://www.alsa-project.org/files/pub/lib/alsa-lib-1.2.11.tar.bz2
tar -xf alsa-lib-1.2.11*
cd alsa-lib-1.2.11

./configure &&
make
# make doc TODO need doxygen
make install

install -v -d -m755 /usr/share/doc/alsa-lib-1.2.11/html/search &&
install -v -m644 doc/doxygen/html/*.* \
                /usr/share/doc/alsa-lib-1.2.11/html &&
install -v -m644 doc/doxygen/html/search/* \
                /usr/share/doc/alsa-lib-1.2.11/html/search

#sound-theme-freedesktop
cd /sources
wget https://people.freedesktop.org/~mccann/dist/sound-theme-freedesktop-0.8.tar.bz2
tar -xf sound-theme-freedesktop-0.8*
cd sound-theme-freedesktop-0.8

./configure --prefix=/usr &&
make
make install

#libcanberra
cd /sources
wget https://0pointer.de/lennart/projects/libcanberra/libcanberra-0.30.tar.xz
wget https://www.linuxfromscratch.org/patches/blfs/12.1/libcanberra-0.30-wayland-1.patch
tar -xf libcanberra-0.30.tar.xz
cd libcanberra-0.30

patch -Np1 -i ../libcanberra-0.30-wayland-1.patch

./configure --prefix=/usr --disable-oss &&
make
make docdir=/usr/share/doc/libcanberra-0.30 install

#notification-daemon
cd /sources
wget https://download.gnome.org/sources/notification-daemon/3.20/notification-daemon-3.20.0.tar.xz
tar -xf notification-daemon-3.20.0.tar.xz
cd notification-daemon-3.20.0

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  &&
make
make install

#xfce4-dev-tools
cd /sources
wget http://archive.xfce.org/src/xfce/xfce4-dev-tools/4.18/xfce4-dev-tools-4.18.1.tar.bz2
tar -xf xfce4-dev-tools-4.18.1.tar.bz2
cd xfce4-dev-tools-4.18.1

./configure --prefix=/usr &&
make
make install

#SQLite
cd /sources
wget https://sqlite.org/2024/sqlite-autoconf-3450100.tar.gz
# wget https://sqlite.org/2024/sqlite-doc-3450100.zip
tar -xf sqlite-autoconf-3450100.tar.gz
cd sqlite-autoconf-3450100

./configure --prefix=/usr     \
            --disable-static  \
            --enable-fts{4,5} \
            CPPFLAGS="-DSQLITE_ENABLE_COLUMN_METADATA=1 \
                      -DSQLITE_ENABLE_UNLOCK_NOTIFY=1   \
                      -DSQLITE_ENABLE_DBSTAT_VTAB=1     \
                      -DSQLITE_SECURE_DELETE=1          \
                      -DSQLITE_ENABLE_FTS3_TOKENIZER=1" &&
make
make install
# install -v -m755 -d /usr/share/doc/sqlite-3.45.1 &&
# cp -v -R sqlite-doc-3450100/* /usr/share/doc/sqlite-3.45.1

#xfce4-notifyd deps SQLite not mentionned
cd /sources
wget https://archive.xfce.org/src/apps/xfce4-notifyd/0.9/xfce4-notifyd-0.9.4.tar.bz2
tar -xf xfce4-notifyd-0.9.4.tar.bz2
cd xfce4-notifyd-0.9.4

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-systemd &&
make
make install
# notify-send -i info Information "Hi ${USER}, This is a Test"

# thunar
cd /sources
wget https://archive.xfce.org/src/xfce/thunar/4.18/thunar-4.18.10.tar.bz2
tar -xf thunar-4.18.10.tar.bz2
cd thunar-4.18.10

sed -i 's/\tinstall-systemd_userDATA/\t/' Makefile.in

./configure --prefix=/usr \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/thunar-4.18.10 &&
make


# thunar-volman deps Gvfs-1.52.2 https://www.linuxfromscratch.org/blfs/view/12.1/xfce/thunar-volman.html
cd /sources
wget https://archive.xfce.org/src/xfce/thunar-volman/4.18/thunar-volman-4.18.0.tar.bz2
tar -xf thunar-volman-4.18.0.tar.bz2
cd thunar-volman-4.18.0

./configure --prefix=/usr &&
make

make install

# tumbler
cd /sources
wget https://archive.xfce.org/src/xfce/tumbler/4.18/tumbler-4.18.2.tar.bz2
tar -xf tumbler-4.18.2.tar.bz2
cd tumbler-4.18.2

./configure --prefix=/usr --sysconfdir=/etc &&
make

make install

rm -fv /usr/lib/systemd/user/tumblerd.service

# xfce4-appfinder
cd /sources
wget https://archive.xfce.org/src/xfce/xfce4-appfinder/4.18/xfce4-appfinder-4.18.1.tar.bz2
tar -xf xfce4-appfinder-4.18.1.tar.bz2
cd xfce4-appfinder-4.18.1

./configure --prefix=/usr &&
make

make install

#Doxygen
cd /sources
wget https://doxygen.nl/files/doxygen-1.10.0.src.tar.gz
tar -xf doxygen-1.10.0.src.tar.gz
cd doxygen-1.10.0

grep -rl '^#!.*python$' | xargs sed -i '1s/python/&3/'

mkdir -v build &&
cd       build &&

cmake -G "Unix Makefiles"         \
      -DCMAKE_BUILD_TYPE=Release  \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -Wno-dev .. &&

make

make install &&
install -vm644 ../doc/*.1 /usr/share/man/man1

#libusb kernel https://www.linuxfromscratch.org/blfs/view/12.1/general/libusb.html
cd /sources
wget https://github.com/libusb/libusb/releases/download/v1.0.27/libusb-1.0.27.tar.bz2
tar -xf libusb-1.0.27.tar.bz2
cd libusb-1.0.27

./configure --prefix=/usr --disable-static &&
make

pushd doc                &&
  doxygen -u doxygen.cfg &&
  make docs              &&
popd

make install

#upower
cd /sources
wget https://gitlab.freedesktop.org/upower/upower/-/archive/v1.90.2/upower-v1.90.2.tar.bz2
tar -xf upower-v1.90.2.tar.bz2
cd upower-v1.90.2

sed '/parse_version/d' -i src/linux/integration-test.py
mkdir build &&
cd    build &&

meson setup ..                  \
      --prefix=/usr             \
      --buildtype=release       \
      -Dgtk-doc=false           \
      -Dman=false               \
      -Dsystemdsystemunitdir=no \
      -Dudevrulesdir=/usr/lib/udev/rules.d &&
ninja
ninja install

# xfce4-power-manager deps https://www.linuxfromscratch.org/blfs/view/12.1/xfce/xfce4-power-manager.html
cd /sources
wget https://archive.xfce.org/src/xfce/xfce4-power-manager/4.18/xfce4-power-manager-4.18.3.tar.bz2
tar -xf xfce4-power-manager-4.18.3.tar.bz2
cd xfce4-power-manager-4.18.3

./configure --prefix=/usr --sysconfdir=/etc &&
make
make install

#libxklavier
cd /sources
wget https://people.freedesktop.org/~svu/libxklavier-5.4.tar.bz2
tar -xf libxklavier-5.4.tar.bz2
cd libxklavier-5.4

./configure --prefix=/usr --disable-static &&
make
make install

#lxde-icon-theme
cd /sources
wget https://downloads.sourceforge.net/lxde/lxde-icon-theme-0.5.1.tar.xz
tar -xf lxde-icon-theme-0.5.1.tar.xz
cd lxde-icon-theme-0.5.1

./configure --prefix=/usr
make install
gtk-update-icon-cache -qf /usr/share/icons/nuoveXT2

# xfce4-settings
cd /sources
wget https://archive.xfce.org/src/xfce/xfce4-settings/4.18/xfce4-settings-4.18.4.tar.bz2
tar -xf xfce4-settings-4.18.4.tar.bz2
cd xfce4-settings-4.18.4

./configure --prefix=/usr --sysconfdir=/etc &&
make
make install

# Xfdesktop
cd /sources
wget https://archive.xfce.org/src/xfce/xfdesktop/4.18/xfdesktop-4.18.1.tar.bz2
tar -xf xfdesktop-4.18.1.tar.bz2
cd xfdesktop-4.18.1

./configure --prefix=/usr &&
make
make install

# Xfwm4
cd /sources
wget https://archive.xfce.org/src/xfce/xfwm4/4.18/xfwm4-4.18.0.tar.bz2
tar -xf xfwm4-4.18.0.tar.bz2
cd xfwm4-4.18.0

./configure --prefix=/usr &&
make
make install

#desktop-file-utils
cd /sources
wget https://www.freedesktop.org/software/desktop-file-utils/releases/desktop-file-utils-0.27.tar.xz
tar -xf desktop-file-utils-0.27.tar.xz
cd desktop-file-utils-0.27

rm -fv /usr/bin/desktop-file-edit

mkdir build &&
cd    build &&

meson setup --prefix=/usr --buildtype=release .. &&
ninja
ninja install

# xfce4-session
cd /sources
wget https://archive.xfce.org/src/xfce/xfce4-session/4.18/xfce4-session-4.18.3.tar.bz2
tar -xf xfce4-session-4.18.3.tar.bz2
cd xfce4-session-4.18.3

./configure --prefix=/usr \
            --sysconfdir=/etc \
            --disable-legacy-sm &&
make
make install

#Nettle-3.9.1
cd /sources
wget https://ftp.gnu.org/gnu/nettle/nettle-3.9.1.tar.gz
tar -xf nettle-3.9.1.tar.gz
cd nettle-3.9.1

./configure --prefix=/usr --disable-static &&
make

make install &&
chmod   -v   755 /usr/lib/lib{hogweed,nettle}.so &&
install -v -m755 -d /usr/share/doc/nettle-3.9.1 &&
install -v -m644 nettle.{html,pdf} /usr/share/doc/nettle-3.9.1


#GnuTLS
cd /sources
wget https://www.gnupg.org/ftp/gcrypt/gnutls/v3.8/gnutls-3.8.3.tar.xz
tar -xf gnutls-3.8.3.tar.xz
cd gnutls-3.8.3

./configure --prefix=/usr \
            --docdir=/usr/share/doc/gnutls-3.8.3 \
            --with-default-trust-store-pkcs11="pkcs11:" &&
make
make install

#Graphene
cd /sources
wget https://download.gnome.org/sources/graphene/1.10/graphene-1.10.8.tar.xz
tar -xf graphene-1.10.8.tar.xz
cd graphene-1.10.8

mkdir build &&
cd    build &&

meson setup --prefix=/usr --buildtype=release .. &&
ninja
ninja install


#PyCairo
cd /sources
wget https://github.com/pygobject/pycairo/releases/download/v1.26.0/pycairo-1.26.0.tar.gz
tar -xf pycairo-1.26.0.tar.gz
cd pycairo-1.26.0

mkdir build &&
cd    build &&

meson setup --prefix=/usr --buildtype=release .. &&
ninja
ninja install

#PyGObject
cd /sources
wget https://download.gnome.org/sources/pygobject/3.46/pygobject-3.46.0.tar.xz
tar -xf pygobject-3.46.0.tar.xz
cd pygobject-3.46.0

mv -v tests/test_gdbus.py{,.nouse} &&
mv -v tests/test_overrides_gtk.py{,.nouse}

mkdir build &&
cd    build &&

meson setup --prefix=/usr --buildtype=release .. &&
ninja
ninja install

#gst-plugins-base-bad-good
cd /sources
wget https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.22.10.tar.xz
tar -xf gst-plugins-base-1.22.10.tar.xz
cd gst-plugins-base-1.22.10

mkdir build &&
cd    build &&

meson  setup ..               \
       --prefix=/usr          \
       --buildtype=release    \
       --wrap-mode=nodownload \
       -Dpackage-origin=https://www.linuxfromscratch.org/blfs/view/12.1/ \
       -Dpackage-name="GStreamer 1.22.10 BLFS"    &&
ninja
ninja install

cd /sources
wget https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.22.10.tar.xz
tar -xf gst-plugins-bad-1.22.10.tar.xz
cd gst-plugins-bad-1.22.10

mkdir build &&
cd    build &&

meson  setup ..            \
       --prefix=/usr       \
       --buildtype=release \
       -Dgpl=enabled       \
       -Dpackage-origin=https://www.linuxfromscratch.org/blfs/view/12.1/ \
       -Dpackage-name="GStreamer 1.22.10 BLFS" &&
ninja
ninja install


cd /sources
wget https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.22.10.tar.xz
tar -xf gst-plugins-good-1.22.10.tar.xz
cd gst-plugins-good-1.22.10

mkdir build &&
cd    build &&

meson setup ..            \
      --prefix=/usr       \
      --buildtype=release \
      -Dpackage-origin=https://www.linuxfromscratch.org/blfs/view/12.1/ \
      -Dpackage-name="GStreamer 1.22.10 BLFS" &&
ninja
ninja install

#gtk4
cd /sources
wget https://download.gnome.org/sources/gtk/4.12/gtk-4.12.5.tar.xz
tar -xf gtk-4.12.5.tar.xz
cd gtk-4.12.5

mkdir build &&
cd    build &&

meson setup --prefix=/usr           \
            --buildtype=release     \
            -Dbroadway-backend=true \
            -Dintrospection=enabled \
            .. &&
ninja
ninja install

#Graphviz
cd /sources
wget https://gitlab.com/graphviz/graphviz/-/archive/13.1.0/graphviz-13.1.0.tar.bz2
tar -xf graphviz-13.1.0.tar.bz2
cd graphviz-13.1.0

mkdir build &&
cd    build &&

cmake -D CMAKE_INSTALL_PREFIX=/usr \
      -D CMAKE_BUILD_TYPE=Release  \
      ..                           &&

sed -i '/GZIP/s/:.*$/=/' CMakeCache.txt &&

make
make install

#Vala deps Graphviz not mentionned
cd /sources
wget https://download.gnome.org/sources/vala/0.56/vala-0.56.14.tar.xz
tar -xf vala-0.56.14.tar.xz
cd vala-0.56.14

sed -i '/gvc.h/a#define TRUE 1' libvaladoc/gvc-compat.c
./configure --prefix=/usr &&
make
make install

#VTE
cd /sources
wget https://gitlab.gnome.org/GNOME/vte/-/archive/0.74.2/vte-0.74.2.tar.gz
tar -xf vte-0.74.2.tar.gz
cd vte-0.74.2

mkdir build &&
cd    build &&

meson setup --prefix=/usr       \
            --buildtype=release \
            -D_systemd=false    &&
ninja
ninja install &&
rm -v /etc/profile.d/vte.*

# xfce4-terminal
cd /sources
wget https://archive.xfce.org/src/apps/xfce4-terminal/1.1/xfce4-terminal-1.1.2.tar.bz2
tar -xf xfce4-terminal-1.1.2.tar.bz2
cd xfce4-terminal-1.1.2

./configure --prefix=/usr &&
make
make install