# https://www.linuxfromscratch.org/lfs/view/stable-systemd/chapter09/network.html


echo "paran" > /etc/hostname

cat > /etc/resolv.conf << "EOF"
# Begin /etc/resolv.conf

# domain <Your Domain Name>
nameserver 8.8.8.8
nameserver 8.8.4.4

# End /etc/resolv.conf
EOF

cat > /etc/hosts <<"EOF"
127.0.0.1 localhost
# 127.0.1.1 <FQDN> <HOSTNAME>
# <192.168.1.1> <FQDN> <HOSTNAME> [alias1] [alias2 ...]
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF