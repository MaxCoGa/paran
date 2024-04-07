# base # BUSYBOX DOENST COMPILE WITH LATEST VERSION BUG: http://lists.busybox.net/pipermail/busybox-cvs/2024-January/041752.html
FROM ubuntu:20.04 
ENV DEBIAN_FRONTEND noninteractive

ENV PFS=/mnt/pfs
ENV PFS_TGT=x86_64-pfs-linux-gnu
ENV PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin
ENV MAKEFLAGS="-j 16"
ENV LOOP=/dev/loop0

RUN apt-get update -y && apt-get upgrade -y 
# RUN apt-get install -y --no-install-recommends wget ca-certificates curl libdigest-sha-perl
RUN apt install -y bzip2 git make gcc libncurses-dev flex bison \
    bc cpio libelf-dev wget file g++ unzip rsync git \
    autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev \
    zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev \
    grub-common grub-pc-bin grub2-common grub-pc xorriso \
    genisoimage libssl-dev syslinux dosfstools python3 gawk \
    bzip2-doc extlinux libbrotli-dev libbz2-dev libfreetype-dev libltdl-dev \
    libltdl7 libpng-dev libpng-tools libtool texinfo

RUN git clone https://github.com/MaxCoGa/paran.git

# set the entrypoint
ENTRYPOINT ["/bin/bash"]