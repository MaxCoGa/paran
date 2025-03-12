
# Paran OS

Current Version : indev
Supported Arch: x86x64

# Content
- [Requirements](#requirements)
- [Install](#install)
- [Compile from source](#compile-from-source)
- [Use](#Use)
- [Credits](#credits)
- [License](#license)


# Requirements

# Install

# Compile from source

./build.sh CMD
https://www.linuxjournal.com/content/diy-build-custom-minimal-linux-distribution-source
here: https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter08/aboutdebug.html
## Docker
in rootful mode!!!
e.g. podman machine set --rootful=true

image:
docker build -t ubuntudev . /-f dockerfile
or
podman build -f Dockerfile -t ubuntudev   

create container:
docker run --privileged -it --name UbuntuDev ubuntudev
or
podman run  --privileged -itd -v /mnt/pfs --name UbuntuDev ubuntudev

exec a container:
docker/podman start UbuntuDev
docker/podman exec --privileged  -it UbuntuDev bash

podman cp UbuntuDev:/tmp/paranos.iso .
# Use

# Credits
LFS: https://www.linuxfromscratch.org/

# License
https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter05/gcc-pass1.html


current base line:
https://www.linuxfromscratch.org/lfs/view/12.1/

to update core packages:
https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter01/whatsnew.html

wget list
https://www.linuxfromscratch.org/lfs/view/stable/chapter03/introduction.html
e.g. https://www.linuxfromscratch.org/lfs/view/stable/wget-list-sysv


https://www.linuxfromscratch.org/lfs/view/12.1-systemd/chapter08/grep.html