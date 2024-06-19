cd /sources
tar xf grub-2.12.tar.xz
cd grub-2.12

echo depends bli part_gpt > grub-core/extra_deps.lst

./configure --prefix=/usr          \
            --sysconfdir=/etc      \
            --disable-efiemu       \
            --disable-werror

make
make install
mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions