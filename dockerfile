# base
FROM ubuntu:24.04

RUN apt-get update -y && apt-get upgrade -y 
# RUN apt-get install -y --no-install-recommends wget ca-certificates curl libdigest-sha-perl
RUN apt install -y bzip2 git vim make gcc libncurses-dev flex bison \
    bc cpio libelf-dev wget file g++ unzip rsync git \
    autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev \
    zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev \
    grub-common grub-pc-bin grub2-common grub-pc xorriso \
    genisoimage libssl-dev syslinux dosfstools python3 gawk

RUN git clone https://github.com/MaxCoGa/paran.git

# set the entrypoint
ENTRYPOINT ["/paran"]