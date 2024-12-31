echo 12.1 > /etc/lfs-release

cat > /etc/lsb-release << "EOF"
DISTRIB_ID="Linux From Scratch"
DISTRIB_RELEASE="12.1"
DISTRIB_CODENAME="Spring Begins"
DISTRIB_DESCRIPTION="Linux From Scratch"
EOF

cat > /etc/os-release << "EOF"
NAME="Linux From Scratch"
VERSION="12.1"
ID=lfs
PRETTY_NAME="Linux From Scratch 12.1"
VERSION_CODENAME="Spring Begins"
HOME_URL="https://www.linuxfromscratch.org/lfs/"
EOF

echo "root:root" | chpasswd
