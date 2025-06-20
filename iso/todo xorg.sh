# xorg
set -e
mkdir -p /sources

# https://www.linuxfromscratch.org/blfs/view/12.1/x/xorg7.html
cd /sources
export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"


cat > /etc/profile.d/xorg.sh << EOF
XORG_PREFIX="$XORG_PREFIX"
XORG_CONFIG="--prefix=\$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
export XORG_PREFIX XORG_CONFIG
EOF
chmod 644 /etc/profile.d/xorg.sh
touch /etc/profile.d/xorg.sh

# https://www.linuxfromscratch.org/blfs/view/12.1/x/util-macros.html
cd /sources
wget https://www.x.org/pub/individual/util/util-macros-1.20.0.tar.xz
tar -xf util-macros-1.20.0.tar.xz
cd util-macros-1.20.0
./configure $XORG_CONFIG
make install

# https://www.linuxfromscratch.org/blfs/view/12.1/x/xorgproto.html
cd /sources
wget https://xorg.freedesktop.org/archive/individual/proto/xorgproto-2023.2.tar.xz
tar -xf xorgproto-2023.2.tar.xz
cd xorgproto-2023.2
mkdir build &&
cd    build &&

meson setup --prefix=$XORG_PREFIX .. &&
ninja


ninja install &&
mv -v $XORG_PREFIX/share/doc/xorgproto{,-2023.2}


# https://www.linuxfromscratch.org/blfs/view/12.1/x/libXau.html
cd /sources
wget https://www.x.org/pub/individual/lib/libXau-1.0.11.tar.xz
tar -xf libXau-1.0.11.tar.xz
cd libXau-1.0.11
./configure $XORG_CONFIG &&
make
make install

# https://www.linuxfromscratch.org/blfs/view/12.1/x/libXdmcp.html
cd /sources
wget https://www.x.org/pub/individual/lib/libXdmcp-1.1.4.tar.xz
tar -xf libXdmcp-1.1.4.tar.xz
cd libXdmcp-1.1.4
./configure $XORG_CONFIG --docdir=/usr/share/doc/libXdmcp-1.1.4 &&
make
make install

# https://www.linuxfromscratch.org/blfs/view/12.1/x/xcb-proto.html
cd /sources
wget https://xorg.freedesktop.org/archive/individual/proto/xcb-proto-1.16.0.tar.xz
tar -xf xcb-proto-1.16.0.tar.xz
cd xcb-proto-1.16.0
PYTHON=python3 ./configure $XORG_CONFIG
make install
# If you are upgrading from version 1.15.1 or lower
# rm -f $XORG_PREFIX/lib/pkgconfig/xcb-proto.pc

# https://www.linuxfromscratch.org/blfs/view/12.1/x/libxcb.html
cd /sources
wget https://xorg.freedesktop.org/archive/individual/lib/libxcb-1.16.tar.xz
tar -xf libxcb-1.16.tar.xz
cd libxcb-1.16
./configure $XORG_CONFIG      \
            --without-doxygen \
            --docdir='${datadir}'/doc/libxcb-1.16 &&
LC_ALL=en_US.UTF-8 make

make install



# https://www.linuxfromscratch.org/blfs/view/12.1/x/x7lib.html Xorg Libraries
cd /sources
# wget https://www.x.org/pub/individual/lib/

cat > lib-7.md5 << "EOF"
12344cd74a1eb25436ca6e6a2cf93097  xtrans-1.5.0.tar.xz
1b9bc39366eab2cc7b018907df715f34  libX11-1.8.7.tar.xz
e59476db179e48c1fb4487c12d0105d1  libXext-1.3.6.tar.xz
742863a552ecd53cdb957b7b276213cc  libFS-1.0.9.tar.xz
b444a0e4c2163d1bbc7b046c3653eb8d  libICE-1.1.1.tar.xz
ffa434ed96ccae45533b3d653300730e  libSM-1.2.4.tar.xz
e613751d38e13aa0d0fd8e0149cec057  libXScrnSaver-1.2.4.tar.xz
4ea21d3b5a36d93a2177d9abed2e54d4  libXt-1.3.0.tar.xz
ed52d396115fbc4d05300762aab79685  libXmu-1.1.4.tar.xz
05b5667aadd476d77e9b5ba1a1de213e  libXpm-3.5.17.tar.xz
3f1e1052dbf3a2b8582ec24137e1fbd1  libXaw-1.0.15.tar.xz
65b9ba1e9ff3d16c4fa72915d4bb585a  libXfixes-6.0.1.tar.xz
af0a5f0abb5b55f8411cd738cf0e5259  libXcomposite-0.4.6.tar.xz
ebf7fb3241ec03e8a3b2af72f03b4631  libXrender-0.9.11.tar.xz
4cdd1886fe5cce6f68554296edb46db8  libXcursor-1.2.1.tar.xz
ca55d29fa0a8b5c4a89f609a7952ebf8  libXdamage-1.1.6.tar.xz
6d3f1b15bb5b0bb71ae9f0a5103c1fc4  libfontenc-1.1.7.tar.xz
c179daa707f5f432f1bc13977e5bb329  libXfont2-2.0.6.tar.xz
cea0a3304e47a841c90fbeeeb55329ee  libXft-2.3.8.tar.xz
89ac74ad6829c08d5c8ae8f48d363b06  libXi-1.8.1.tar.xz
228c877558c265d2f63c56a03f7d3f21  libXinerama-1.1.5.tar.xz
24e0b72abe16efce9bf10579beaffc27  libXrandr-1.5.4.tar.xz
66c9e9e01b0b53052bb1d02ebf8d7040  libXres-1.2.2.tar.xz
02f128fbf809aa9c50d6e54c8e57cb2e  libXtst-1.2.4.tar.xz
70bfdd14ca1a563c218794413f0c1f42  libXv-1.0.12.tar.xz
a90a5f01102dc445c7decbbd9ef77608  libXvMC-1.0.14.tar.xz
74d1acf93b83abeb0954824da0ec400b  libXxf86dga-1.1.6.tar.xz
5b913dac587f2de17a02e17f9a44a75f  libXxf86vm-1.1.5.tar.xz
54f48367e37666f9e0f12571d1ee3620  libpciaccess-0.18.tar.xz
229708c15c9937b6e5131d0413474139  libxkbfile-1.1.3.tar.xz
faa74f7483074ce7d4349e6bdc237497  libxshmfence-1.3.2.tar.xz
bdd3ec17c6181fd7b26f6775886c730d  libXpresent-1.0.1.tar.xz
EOF

mkdir lib &&
cd lib &&
grep -v '^#' ../lib-7.md5 | awk '{print $2}' | wget -i- -c \
    -B https://www.x.org/pub/individual/lib/ &&
md5sum -c ../lib-7.md5


as_root()
{
  if   [ $EUID = 0 ];        then $*
  elif [ -x /usr/bin/sudo ]; then sudo $*
  else                            su -c \\"$*\\"
  fi
}

export -f as_root

for package in $(grep -v '^#' ../lib-7.md5 | awk '{print $2}')
do
  packagedir=${package%.tar.?z*}
  echo "Building $packagedir"

  tar -xf $package
  pushd $packagedir
  docdir="--docdir=$XORG_PREFIX/share/doc/$packagedir"
  
  case $packagedir in
    libXfont2-[0-9]* )
      ./configure $XORG_CONFIG $docdir --disable-devel-docs
    ;;

    libXt-[0-9]* )
      ./configure $XORG_CONFIG $docdir \
                  --with-appdefaultdir=/etc/X11/app-defaults
    ;;

    libXpm-[0-9]* )
      ./configure $XORG_CONFIG $docdir --disable-open-zfile
    ;;
  
    libpciaccess* )
      mkdir build
      cd    build
        meson setup --prefix=$XORG_PREFIX --buildtype=release ..
        ninja
        #ninja test
        ninja install
      popd     # $packagedir
      continue # for loop
    ;;

    * )
      ./configure $XORG_CONFIG $docdir
    ;;
  esac

  make
  #make check 2>&1 | tee ../$packagedir-make_check.log
  make install
  popd
  rm -rf $packagedir
  /sbin/ldconfig
done

#dbus todo: https://www.linuxfromscratch.org/blfs/view/12.1/general/dbus.html
cd /sources
wget https://dbus.freedesktop.org/releases/dbus/dbus-1.14.10.tar.xz
tar -xf dbus-1.14.10.tar.xz
cd dbus-1.14.10

./configure --prefix=/usr                        \
            --sysconfdir=/etc                    \
            --localstatedir=/var                 \
            --runstatedir=/run                   \
            --disable-doxygen-docs               \
            --disable-xml-docs                   \
            --disable-static                     \
            --with-systemduserunitdir=no         \
            --with-systemdsystemunitdir=no       \
            --docdir=/usr/share/doc/dbus-1.14.10  \
            --with-system-socket=/run/dbus/system_bus_socket &&
make

make install

dbus-uuidgen --ensure

# https://www.linuxfromscratch.org/blfs/view/12.1/x/libxcvt.html
cd /sources
wget https://www.x.org/pub/individual/lib/libxcvt-0.1.2.tar.xz
tar -xf libxcvt-0.1.2.tar.xz
cd libxcvt-0.1.2
mkdir build &&
cd    build &&

meson setup --prefix=$XORG_PREFIX --buildtype=release .. &&
ninja

ninja install

# https://www.linuxfromscratch.org/blfs/view/12.1/x/xcb-util.html
cd /sources
wget https://xcb.freedesktop.org/dist/xcb-util-0.4.1.tar.xz
tar -xf xcb-util-0.4.1.tar.xz
cd xcb-util-0.4.1
./configure $XORG_CONFIG &&
make
make install


# https://www.linuxfromscratch.org/blfs/view/12.1/x/xcb-util-image.html
cd /sources
wget https://xcb.freedesktop.org/dist/xcb-util-image-0.4.1.tar.xz
tar -xf xcb-util-image-0.4.1.tar.xz
cd xcb-util-image-0.4.1
./configure $XORG_CONFIG &&
make
make install


# https://www.linuxfromscratch.org/blfs/view/12.1/x/xcb-util-keysyms.html
cd /sources
wget https://xcb.freedesktop.org/dist/xcb-util-keysyms-0.4.1.tar.xz
tar -xf xcb-util-keysyms-0.4.1.tar.xz
cd xcb-util-keysyms-0.4.1
./configure $XORG_CONFIG &&
make
make install


# https://www.linuxfromscratch.org/blfs/view/12.1/x/xcb-util-renderutil.html
cd /sources
wget https://xcb.freedesktop.org/dist/xcb-util-renderutil-0.3.10.tar.xz
tar -xf xcb-util-renderutil-0.3.10.tar.xz
cd xcb-util-renderutil-0.3.10
./configure $XORG_CONFIG &&
make
make install




# https://www.linuxfromscratch.org/blfs/view/12.1/x/xcb-util-wm.html
cd /sources
wget https://xcb.freedesktop.org/dist/xcb-util-wm-0.4.2.tar.xz
tar -xf xcb-util-wm-0.4.2.tar.xz
cd xcb-util-wm-0.4.2
./configure $XORG_CONFIG &&
make
make install





# https://www.linuxfromscratch.org/blfs/view/12.1/x/xcb-util-cursor.html
cd /sources
wget https://xcb.freedesktop.org/dist/xcb-util-cursor-0.1.4.tar.xz
tar -xf xcb-util-cursor-0.1.4.tar.xz
cd xcb-util-cursor-0.1.4
./configure $XORG_CONFIG &&
make
make install





## MESA
# libuv
cd /sources
wget https://dist.libuv.org/dist/v1.48.0/libuv-v1.48.0.tar.gz
tar -xf libuv-v1.48.0.tar.gz
cd libuv-v1.48.0
sh autogen.sh                              &&
./configure --prefix=/usr --disable-static &&
make 
make install

# cmake
cd /sources
wget https://cmake.org/files/v3.28/cmake-3.28.3.tar.gz
tar -xf cmake-3.28.3.tar.gz
cd cmake-3.28.3
sed -i '/"lib64"/s/64//' Modules/GNUInstallDirs.cmake &&

./bootstrap --prefix=/usr        \
            --system-libs        \
            --mandir=/share/man  \
            --no-system-jsoncpp  \
            --no-system-cppdap   \
            --no-system-librhash \
            --docdir=/share/doc/cmake-3.28.3 &&
make
make install
# https://www.linuxfromscratch.org/blfs/view/12.1/x/libdrm.html
cd /sources
wget https://dri.freedesktop.org/libdrm/libdrm-2.4.120.tar.xz
tar -xf libdrm-2.4.120.tar.xz
cd libdrm-2.4.120

mkdir build &&
cd    build &&

meson setup --prefix=$XORG_PREFIX \
            --buildtype=release   \
            -Dudev=true           \
            -Dvalgrind=disabled   \
            ..                    &&
ninja
ninja install

# https://www.linuxfromscratch.org/blfs/view/12.1/general/python-modules.html#Mako
cd /sources
wget https://files.pythonhosted.org/packages/source/M/Mako/Mako-1.3.2.tar.gz
tar -xf Mako-1.3.2.tar.gz
cd Mako-1.3.2
pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
pip3 install --no-index --find-links=dist --no-cache-dir --no-user Mako

# https://www.linuxfromscratch.org/blfs/view/12.1/multimedia/libvdpau.html
cd /sources
wget https://gitlab.freedesktop.org/vdpau/libvdpau/-/archive/1.5/libvdpau-1.5.tar.bz2
tar -xf libvdpau-1.5.tar.bz2
cd libvdpau-1.5

mkdir build &&
cd    build &&

meson setup --prefix=$XORG_PREFIX .. &&
ninja
ninja install

# SPIRV-Headers
cd /sources
wget https://github.com/KhronosGroup/SPIRV-Headers/archive/refs/tags/vulkan-sdk-1.3.275.0/SPIRV-Headers-1.3.275.0.tar.gz
tar -xf SPIRV-Headers-1.3.275.0.tar.gz
cd SPIRV-Headers-vulkan-sdk-1.3.275.0
mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr -G Ninja .. &&
ninja
ninja install

# SPIRV-Tools
cd /sources 
wget https://github.com/KhronosGroup/SPIRV-Tools/archive/refs/tags/vulkan-sdk-1.3.275.0/SPIRV-Tools-1.3.275.0.tar.gz
tar -xf SPIRV-Tools-1.3.275.0.tar.gz
cd SPIRV-Tools-vulkan-sdk-1.3.275.0

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr     \
      -DCMAKE_BUILD_TYPE=Release      \
      -DSPIRV_WERROR=OFF              \
      -DBUILD_SHARED_LIBS=ON          \
      -DSPIRV_TOOLS_BUILD_STATIC=OFF  \
      -DSPIRV-Headers_SOURCE_DIR=/usr \
      -G Ninja .. &&
ninja

ninja install
# https://www.linuxfromscratch.org/blfs/view/12.1/x/glslang.html
cd /sources
wget https://github.com/KhronosGroup/glslang/archive/refs/tags/14.0.0/glslang-14.0.0.tar.gz
tar -xf glslang-14.0.0.tar.gz
cd glslang-14.0.0

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr     \
      -DCMAKE_BUILD_TYPE=Release      \
      -DALLOW_EXTERNAL_SPIRV_TOOLS=ON \
      -DBUILD_SHARED_LIBS=ON          \
      -DGLSLANG_TESTS=ON              \
      -G Ninja .. &&
ninja
ninja install

# llvm https://www.linuxfromscratch.org/blfs/view/12.1/general/llvm.html
cd /sources
wget https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.6/llvm-17.0.6.src.tar.xz
wget https://anduin.linuxfromscratch.org/BLFS/llvm/llvm-cmake-17.src.tar.xz
wget https://anduin.linuxfromscratch.org/BLFS/llvm/llvm-third-party-17.src.tar.xz
wget https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.6/clang-17.0.6.src.tar.xz
wget https://www.linuxfromscratch.org/patches/blfs/12.1/clang-17-enable_default_ssp-1.patch
wget https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.6/compiler-rt-17.0.6.src.tar.xz
tar -xf llvm-17.0.6.src.tar.xz
cd llvm-17.0.6.src

tar -xf ../llvm-cmake-17.src.tar.xz                                   &&
tar -xf ../llvm-third-party-17.src.tar.xz                             &&
sed '/LLVM_COMMON_CMAKE_UTILS/s@../cmake@llvm-cmake-17.src@'          \
    -i CMakeLists.txt                                                 &&
sed '/LLVM_THIRD_PARTY_DIR/s@../third-party@llvm-third-party-17.src@' \
    -i cmake/modules/HandleLLVMOptions.cmake

tar -xf ../clang-17.0.6.src.tar.xz -C tools &&
mv tools/clang-17.0.6.src tools/clang

tar -xf ../compiler-rt-17.0.6.src.tar.xz -C projects    &&
mv projects/compiler-rt-17.0.6.src projects/compiler-rt &&
sed '/^set(LLVM_COMMON_CMAKE_UTILS/d'                   \
    -i projects/compiler-rt/CMakeLists.txt

grep -rl '#!.*python' | xargs sed -i '1s/python$/python3/'

patch -Np2 -d tools/clang <../clang-17-enable_default_ssp-1.patch

sed 's/clang_dfsan/& -fno-stack-protector/' \
    -i projects/compiler-rt/test/dfsan/origin_unaligned_memtrans.c

mkdir -v build &&
cd       build &&

CC=gcc CXX=g++                              \
cmake -DCMAKE_INSTALL_PREFIX=/usr           \
      -DLLVM_ENABLE_FFI=ON                  \
      -DCMAKE_BUILD_TYPE=Release            \
      -DLLVM_BUILD_LLVM_DYLIB=ON            \
      -DLLVM_LINK_LLVM_DYLIB=ON             \
      -DLLVM_ENABLE_RTTI=ON                 \
      -DLLVM_TARGETS_TO_BUILD="host;AMDGPU" \
      -DLLVM_BINUTILS_INCDIR=/usr/include   \
      -DLLVM_INCLUDE_BENCHMARKS=OFF         \
      -DCLANG_DEFAULT_PIE_ON_LINUX=ON       \
      -Wno-dev -G Ninja ..                  &&
ninja

ninja install &&
cp bin/FileCheck /usr/bin


# wayland
# icu
cd /sources
wget https://github.com/unicode-org/icu/releases/download/release-74-2/icu4c-74_2-src.tgz
tar -xf icu4c-74_2-src.tgz
cd icu

cd source                                    &&

./configure --prefix=/usr                    &&
make
make install

# libxml
cd /sources
wget https://download.gnome.org/sources/libxml2/2.12/libxml2-2.12.5.tar.xz
tar -xf libxml2-2.12.5.tar.xz
cd libxml2-2.12.5

./configure --prefix=/usr           \
            --sysconfdir=/etc       \
            --disable-static        \
            --with-history          \
            --with-icu              \
            PYTHON=/usr/bin/python3 \
            --docdir=/usr/share/doc/libxml2-2.12.5 &&
make
make install

# wayland
cd /sources
wget https://gitlab.freedesktop.org/wayland/wayland/-/releases/1.22.0/downloads/wayland-1.22.0.tar.xz
tar -xf wayland-1.22.0.tar.xz
cd wayland-1.22.0

mkdir build &&
cd    build &&

meson setup ..            \
      --prefix=/usr       \
      --buildtype=release \
      -Ddocumentation=false &&
ninja
ninja install

# wayland-protocols
cd /sources
wget https://gitlab.freedesktop.org/wayland/wayland-protocols/-/releases/1.33/downloads/wayland-protocols-1.33.tar.xz
tar -xf wayland-protocols-1.33.tar.xz
cd wayland-protocols-1.33

mkdir build &&
cd    build &&

meson setup --prefix=/usr --buildtype=release &&
ninja
ninja install


# https://www.linuxfromscratch.org/blfs/view/12.1/x/mesa.html
# todo: check for kernel config
cd /sources
wget https://mesa.freedesktop.org/archive/mesa-24.0.1.tar.xz
wget https://www.linuxfromscratch.org/patches/blfs/12.1/mesa-add_xdemos-2.patch
tar -xf mesa-24.0.1.tar.xz
cd mesa-24.0.1
patch -Np1 -i ../mesa-add_xdemos-2.patch

mkdir build &&
cd    build &&

meson setup                   \
      --prefix=$XORG_PREFIX   \
      --buildtype=release     \
      -Dplatforms=x11,wayland \
      -Dgallium-drivers=auto  \
      -Dvulkan-drivers=auto   \
      -Dvalgrind=disabled     \
      -Dlibunwind=disabled    \
      ..                      &&

ninja
ninja install
cp -rv ../docs -T /usr/share/doc/mesa-24.0.1


#xbitmaps
cd /sources
wget https://www.x.org/pub/individual/data/xbitmaps-1.1.3.tar.xz
tar -xf xbitmaps-1.1.3.tar.xz
cd xbitmaps-1.1.3

./configure $XORG_CONFIG
make install

## Xorg Applications
#libpng
cd /sources
wget https://downloads.sourceforge.net/libpng/libpng-1.6.42.tar.xz
wget https://downloads.sourceforge.net/sourceforge/libpng-apng/libpng-1.6.40-apng.patch.gz
tar -xf libpng-1.6.42.tar.xz
cd libpng-1.6.42

gzip -cd ../libpng-1.6.40-apng.patch.gz | patch -p1

./configure --prefix=/usr --disable-static &&
make

make install &&
mkdir -v /usr/share/doc/libpng-1.6.42 &&
cp -v README libpng-manual.txt /usr/share/doc/libpng-1.6.42

#Xorg Applications
cd /sources
cat > app-7.md5 << "EOF"
5d3feaa898875484b6b340b3888d49d8  iceauth-1.0.9.tar.xz
c4a3664e08e5a47c120ff9263ee2f20c  luit-1.1.1.tar.bz2
fd2e6e5a297ac2bf3d7d54799bf69de0  mkfontscale-1.2.2.tar.xz
05423bb42a006a6eb2c36ba10393de23  sessreg-1.1.3.tar.xz
1d61c9f4a3d1486eff575bf233e5776c  setxkbmap-1.3.4.tar.xz
9f7a4305f0e79d5a46c3c7d02df9437d  smproxy-1.0.7.tar.xz
e96b56756990c56c24d2d02c2964456b  x11perf-1.6.1.tar.bz2
dbcf944eb59343b84799b2cc70aace16  xauth-1.1.2.tar.xz
#5b6405973db69c0443be2fba8e1a8ab7  xbacklight-1.2.3.tar.bz2
82a90e2feaeab5c5e7610420930cc0f4  xcmsdb-1.0.6.tar.xz
89e81a1c31e4a1fbd0e431425cd733d7  xcursorgen-1.0.8.tar.xz
933e6d65f96c890f8e96a9f21094f0de  xdpyinfo-1.3.4.tar.xz
34aff1f93fa54d6a64cbe4fee079e077  xdriinfo-1.0.7.tar.xz
61219e492511b3d78375da76defbdc97  xev-1.2.5.tar.xz
41afaa5a68cdd0de7e7ece4805a37f11  xgamma-1.0.7.tar.xz
48ac13856838d34f2e7fca8cdc1f1699  xhost-1.0.9.tar.xz
8e4d14823b7cbefe1581c398c6ab0035  xinput-1.6.4.tar.xz
83d711948de9ccac550d2f4af50e94c3  xkbcomp-1.4.7.tar.xz
05ce1abd8533a400572784b1186a44d0  xkbevd-1.1.5.tar.xz
07483ddfe1d83c197df792650583ff20  xkbutils-1.0.6.tar.xz
f62b99839249ce9a7a8bb71a5bab6f9d  xkill-1.0.6.tar.xz
da5b7a39702841281e1d86b7349a03ba  xlsatoms-1.1.4.tar.xz
ab4b3c47e848ba8c3e47c021230ab23a  xlsclients-1.1.5.tar.xz
f33841b022db1648c891fdc094014aee  xmessage-1.0.6.tar.xz
0d66e07595ea083871048c4b805d8b13  xmodmap-1.0.11.tar.xz
9cf272cba661f7acc35015f2be8077db  xpr-1.1.0.tar.xz
d050642a667b518cb3429273a59fa36d  xprop-1.2.7.tar.xz
f822a8d5f233e609d27cc22d42a177cb  xrandr-1.5.2.tar.xz
c8629d5a0bc878d10ac49e1b290bf453  xrdb-1.2.2.tar.xz
33b04489e417d73c90295bd2a0781cbb  xrefresh-1.0.7.tar.xz
18ff5cdff59015722431d568a5c0bad2  xset-1.2.5.tar.xz
fa9a24fe5b1725c52a4566a62dd0a50d  xsetroot-1.1.3.tar.xz
d698862e9cad153c5fefca6eee964685  xvinfo-1.1.5.tar.xz
b0081fb92ae56510958024242ed1bc23  xwd-1.0.9.tar.xz
c91201bc1eb5e7b38933be8d0f7f16a8  xwininfo-1.1.6.tar.xz
5ff5dc120e8e927dc3c331c7fee33fc3  xwud-1.0.6.tar.xz
EOF

mkdir app &&
cd app &&
grep -v '^#' ../app-7.md5 | awk '{print $2}' | wget -i- -c \
    -B https://www.x.org/pub/individual/app/ &&
md5sum -c ../app-7.md5

for package in $(grep -v '^#' ../app-7.md5 | awk '{print $2}')
do
  packagedir=${package%.tar.?z*}
  tar -xf $package
  pushd $packagedir
     case $packagedir in
       luit-[0-9]* )
         sed -i -e "/D_XOPEN/s/5/6/" configure
       ;;
     esac

     ./configure $XORG_CONFIG
     make
     make install
  popd
  rm -rf $packagedir
done

rm -f $XORG_PREFIX/bin/xkeystone

# xcursor-themes
cd /sources
wget https://www.x.org/pub/individual/data/xcursor-themes-1.0.7.tar.xz
tar -xf xcursor-themes-1.0.7.tar.xz
cd xcursor-themes-1.0.7

./configure --prefix=/usr &&
make
make install

# Xorg Fonts
cd /sources
cat > font-7.md5 << "EOF"
a6541d12ceba004c0c1e3df900324642  font-util-1.4.1.tar.xz
357d91d87c5d5a1ac3ea4e6a6daf833d  encodings-1.0.7.tar.xz
79f4c023e27d1db1dfd90d041ce89835  font-alias-1.0.5.tar.xz
546d17feab30d4e3abcf332b454f58ed  font-adobe-utopia-type1-1.0.5.tar.xz
063bfa1456c8a68208bf96a33f472bb1  font-bh-ttf-1.0.4.tar.xz
51a17c981275439b85e15430a3d711ee  font-bh-type1-1.0.4.tar.xz
00f64a84b6c9886040241e081347a853  font-ibm-type1-1.0.4.tar.xz
fe972eaf13176fa9aa7e74a12ecc801a  font-misc-ethiopic-1.0.5.tar.xz
3b47fed2c032af3a32aad9acc1d25150  font-xfree86-type1-1.0.5.tar.xz
EOF

mkdir font &&
cd font &&
grep -v '^#' ../font-7.md5 | awk '{print $2}' | wget -i- -c \
    -B https://www.x.org/pub/individual/font/ &&
md5sum -c ../font-7.md5

for package in $(grep -v '^#' ../font-7.md5 | awk '{print $2}')
do
  packagedir=${package%.tar.?z*}
  tar -xf $package
  pushd $packagedir
    ./configure $XORG_CONFIG
    make
    make install
  popd
  rm -rf $packagedir
done

install -v -d -m755 /usr/share/fonts                               &&
ln -svfn $XORG_PREFIX/share/fonts/X11/OTF /usr/share/fonts/X11-OTF &&
ln -svfn $XORG_PREFIX/share/fonts/X11/TTF /usr/share/fonts/X11-TTF

# XKeyboardConfig-2.41
cd /sources
wget https://www.x.org/pub/individual/data/xkeyboard-config/xkeyboard-config-2.41.tar.xz
tar -xf xkeyboard-config-2.41.tar.xz
cd xkeyboard-config-2.41

mkdir build &&
cd    build &&

meson setup --prefix=$XORG_PREFIX --buildtype=release .. &&
ninja

ninja install


#pixman
cd /sources
wget https://www.cairographics.org/releases/pixman-0.43.2.tar.gz
tar -xf pixman-0.43.2.tar.gz
cd pixman-0.43.2


mkdir build &&
cd    build &&

meson setup --prefix=/usr --buildtype=release .. &&
ninja

ninja install

#libepoxy
cd /sources
wget https://download.gnome.org/sources/libepoxy/1.5/libepoxy-1.5.10.tar.xz
tar -xf libepoxy-1.5.10.tar.xz
cd libepoxy-1.5.10

mkdir build &&
cd    build &&

meson setup --prefix=/usr --buildtype=release .. &&
ninja

ninja install

#libtirpc-1.3.4
cd /sources
wget https://downloads.sourceforge.net/libtirpc/libtirpc-1.3.4.tar.bz2
tar -xf libtirpc-1.3.4.tar.bz2
cd libtirpc-1.3.4

./configure --prefix=/usr                                   \
            --sysconfdir=/etc                               \
            --disable-static                                \
            --disable-gssapi                                &&
make

make install

# xwayland
cd /sources
wget  https://www.x.org/pub/individual/xserver/xwayland-23.2.4.tar.xz
tar -xf xwayland-23.2.4.tar.xz
cd xwayland-23.2.4

sed -i '/install_man/,$d' meson.build &&

mkdir build &&
cd    build &&

meson setup --prefix=$XORG_PREFIX         \
            --buildtype=release           \
            -Dxkb_output_dir=/var/lib/xkb \
            ..                            &&
ninja

ninja install &&
cat >> /etc/sysconfig/createfiles << "EOF"
/tmp/.X11-unix dir 1777 root root
EOF

install -vm755 hw/vfb/Xvfb /usr/bin

# xorg-server https://www.linuxfromscratch.org/blfs/view/12.1/x/xorg-server.html
cd /sources
wget https://www.x.org/pub/individual/xserver/xorg-server-21.1.11.tar.xz
wget https://www.linuxfromscratch.org/patches/blfs/12.1/xorg-server-21.1.11-tearfree_backport-1.patch
tar -xf xorg-server-21.1.11.tar.xz
cd xorg-server-21.1.11

patch -Np1 -i ../xorg-server-21.1.11-tearfree_backport-1.patch

mkdir build &&
cd    build &&

meson setup ..              \
      --prefix=$XORG_PREFIX \
      --localstatedir=/var  \
      -Dglamor=true         \
      -Dxkb_output_dir=/var/lib/xkb &&
ninja

ninja install &&
mkdir -pv /etc/X11/xorg.conf.d &&
install -v -d -m1777 /tmp/.{ICE,X11}-unix &&
cat >> /etc/sysconfig/createfiles << "EOF"
/tmp/.ICE-unix dir 1777 root root
/tmp/.X11-unix dir 1777 root root
EOF


#acpid todo: https://www.linuxfromscratch.org/blfs/view/12.1/general/acpid.html laptop
cd /sources
wget https://downloads.sourceforge.net/acpid2/acpid-2.0.34.tar.xz
tar -xf acpid-2.0.34.tar.xz
cd acpid-2.0.34

./configure --prefix=/usr \
            --docdir=/usr/share/doc/acpid-2.0.34 &&
make

make install                         &&
install -v -m755 -d /etc/acpi/events &&
cp -r samples /usr/share/doc/acpid-2.0.34

#pciutils
cd /sources
wget https://mj.ucw.cz/download/linux/pci/pciutils-3.13.0.tar.gz
tar -xf pciutils-3.13.0.tar.gz
cd pciutils-3.13.0

sed -r '/INSTALL/{/PCI_IDS|update-pciids /d; s/update-pciids.8//}' \
    -i Makefile

make PREFIX=/usr                \
     SHAREDIR=/usr/share/hwdata \
     SHARED=yes

make PREFIX=/usr                \
     SHAREDIR=/usr/share/hwdata \
     SHARED=yes                 \
     install install-lib        &&

chmod -v 755 /usr/lib/libpci.so

#hwdata
cd /sources
wget https://github.com/vcrhonek/hwdata/archive/v0.392/hwdata-0.392.tar.gz
tar -xf hwdata-0.392.tar.gz
cd hwdata-0.392

./configure --prefix=/usr --disable-blacklist
make install

##
# xorg input drivers https://www.linuxfromscratch.org/blfs/view/12.1/x/x7driver.html check kernel option
#libevdev 
cd /sources
wget https://www.freedesktop.org/software/libevdev/libevdev-1.13.1.tar.xz
tar -xf libevdev-1.13.1.tar.xz
cd libevdev-1.13.1

mkdir build &&
cd    build &&

meson setup ..                 \
      --prefix=$XORG_PREFIX    \
      --buildtype=release      \
      -Ddocumentation=disabled &&
ninja
ninja install

#mtdev
cd /sources
wget https://bitmath.org/code/mtdev/mtdev-1.1.6.tar.bz2
tar -xf mtdev-1.1.6.tar.bz2
cd mtdev-1.1.6

./configure --prefix=/usr --disable-static &&
make
make install

#Xorg Evdev
cd /sources
wget https://www.x.org/pub/individual/driver/xf86-input-evdev-2.10.6.tar.bz2
tar -xf xf86-input-evdev-2.10.6.tar.bz2
cd xf86-input-evdev-2.10.6

./configure $XORG_CONFIG &&
make
make install

# libinput
cd /sources
wget https://gitlab.freedesktop.org/libinput/libinput/-/archive/1.25.0/libinput-1.25.0.tar.gz
tar -xf libinput-1.25.0.tar.gz
cd libinput-1.25.0

mkdir build &&
cd    build &&

meson setup --prefix=$XORG_PREFIX    \
            --buildtype=release      \
            -Ddebug-gui=false        \
            -Dtests=false            \
            -Dlibwacom=false         \
            -Dudev-dir=/usr/lib/udev \
            ..                      &&
ninja

ninja install

#Xorg Libinput Driver
cd /sources
wget https://www.x.org/pub/individual/driver/xf86-input-libinput-1.4.0.tar.xz
tar -xf xf86-input-libinput-1.4.0.tar.xz
cd xf86-input-libinput-1.4.0

./configure $XORG_CONFIG &&
make
make install

#Xorg Synaptics
cd /sources
wget https://www.x.org/pub/individual/driver/xf86-input-synaptics-1.9.2.tar.xz
tar -xf xf86-input-synaptics-1.9.2.tar.xz
cd xf86-input-synaptics-1.9.2

./configure $XORG_CONFIG &&
make
make install

#Xorg Wacom check kernel
cd /sources
wget https://github.com/linuxwacom/xf86-input-wacom/releases/download/xf86-input-wacom-1.2.0/xf86-input-wacom-1.2.0.tar.bz2
tar -xf xf86-input-wacom-1.2.0.tar.bz2
cd xf86-input-wacom-1.2.0

./configure $XORG_CONFIG --with-systemd-unit-dir=no &&
make

make install



## twm-1.0.12
cd /sources
wget https://www.x.org/pub/individual/app/twm-1.0.12.tar.xz
tar -xf twm-1.0.12.tar.xz
cd twm-1.0.12

sed -i -e '/^rcdir =/s,^\(rcdir = \).*,\1/etc/X11/app-defaults,' src/Makefile.in &&
./configure $XORG_CONFIG &&
make

make install

#xterm
cd /sources
wget https://invisible-mirror.net/archives/xterm/xterm-390.tgz
tar -xf xterm-390.tgz
cd xterm-390


sed -i '/v0/{n;s/new:/new:kb=^?:/}' termcap &&
printf '\tkbs=\\177,\n' >> terminfo &&

TERMINFO=/usr/share/terminfo \
./configure $XORG_CONFIG     \
    --with-app-defaults=/etc/X11/app-defaults &&

make

make install    &&
make install-ti &&

mkdir -pv /usr/share/applications &&
cp -v *.desktop /usr/share/applications/

cat >> /etc/X11/app-defaults/XTerm << "EOF"
*VT100*locale: true
*VT100*faceName: Monospace
*VT100*faceSize: 10
*backarrowKeyIsErase: true
*ptyInitialErase: true
EOF

#xclock
cd /sources
wget https://www.x.org/pub/individual/app/xclock-1.1.1.tar.xz
tar -xf xclock-1.1.1.tar.xz
cd xclock-1.1.1

./configure $XORG_CONFIG &&
make

make install

#xinit
cd /sources
wget https://www.x.org/pub/individual/app/xinit-1.4.2.tar.xz
tar -xf xinit-1.4.2.tar.xz
cd xinit-1.4.2

./configure $XORG_CONFIG --with-xinitdir=/etc/X11/app-defaults &&
make

make install &&
ldconfig