
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


## Docker

docker build -t ubuntudev . /-f dockerfile
or
podman build -f Dockerfile -t ubuntudev   


docker run --privileged -it --name UbuntuDev ubuntudev
or
podman run  --privileged -itd -v /mnt/pfs --name UbuntuDev ubuntudev


docker/podman start UbuntuDev
docker/podman exec --privileged  -it UbuntuDev bash

# Use

# Credits

# License
