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

# thunar https://www.linuxfromscratch.org/blfs/view/12.1/xfce/thunar.html