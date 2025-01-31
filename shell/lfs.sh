#!/bin/bash

export ARCH=`uname -m`
export LFS=/mnt/lfs
export LFS_TGT=${ARCH}-lfs-linux-gnu
export LFS_DISK="$1"
export PACKAGES_FILE="packages.csv"
export PATCHES_FILE="patches.csv"
export ADDITIONAL_FILE="additional.csv"
export USER=`id -un`
export FORMAT="$2"
export COMPILE_STATUS_FILE="${LFS}/sources/compile_status"
export MAKEFLAGS="-j`nproc`"

if [ "$LFS_DISK" == "" ]; then
    echo "Usage: ./shell/lfs.sh devicePath [format]"
    exit 1
fi

function insidechroot_install_package()
{
    chapter="$1"
    package="$2"

    echo -n ""
    source chroot_bash.sh "$LFS" "/sources/insidechrootpackageinstall.sh ${chapter} ${package}"
    result="$(cat ${COMPILE_STATUS_FILE})"
    if [ "$result" != "COMPLIE $package DONE" ]; then
	echo "Compiling $package failed!"
	exit 1
    fi 
}

if ! grep -q "$LFS" /proc/mounts; then
    if [ "$FORMAT" == "format" ]; then
        source shell/setupdisk.sh "$LFS_DISK"
    fi

    sudo mkdir -pv "$LFS"
    sudo mount "${LFS_DISK}2" "$LFS"
    mounted=`mount | grep "${LFS_DISK}2"`
    if [ "$mounted" == "" ] ;then
	echo "Mount ${LFS_DISK}2 failed!"
	exit 1
    fi

    sudo chown -v $USER "$LFS"

    mkdir -pv $LFS/sources
    mkdir -pv $LFS/tools
    
    sudo cp -rf sources/pub/lfs/lfs-packages/12.1/* $LFS/sources/
    mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}
    
    for i in bin lib sbin; do
        ln -sv usr/$i $LFS/$i
    done
    
    case $(uname -m) in
      x86_64) mkdir -pv $LFS/lib64 ;;
    esac

fi

cp -rf shell/* data/* "$LFS/sources"
cd "$LFS/sources"

# Check all exist packages, if not will download it
source download.sh

# Base check
source versioncheck.sh

export PATH="$LFS/tools/bin:$PATH"

# Step 1 [out side of lfs]
for package in binutils gcc linux-api-headers glibc libstdc++; do
    echo -n ""
    source packageinstall.sh 5 $package
done

# Step 2 [outside of lfs]
for package in m4 ncurses bash coreutils diffutils file findutils gawk grep gzip make patch sed tar xz binutils gcc; do
    echo -n ""
    source packageinstall.sh 6 $package
done

chmod ugo+x insidechroot*.sh
chmod ugo+x insidechrootpackageinstall.sh 

# Ready for inside of chroot
source chroot_bash.sh "$LFS" "/sources/insidechroot.sh"

# Stage 3 [inside of lfs]
for package in gettext bison perl python texinfo util-linux; do
    echo -n ""
    insidechroot_install_package 7 $package
done
source chroot_bash.sh "$LFS" "/sources/insidechroot2.sh"

# Stage 4 [inside of lfs]
for package in man-pages iana-etc glibc zlib bzip2 xz zstd file readline m4 bc flex tcl expect \
dejaGNU pkgconf binutils gmp mpfr mpc attr acl libcap libxcrypt shadow gcc ncurses sed psmisc gettext \
bison grep bash libtool gdbm gperf expat inetutils less perl XML-Parser intltool autoconf automake openSSL \
kmod libelf libffi python flit-Core wheel setuptools ninja meson coreutils check diffutils gawk findutils \
groff grub gzip IPRoute2 kbd libpipeline make patch tar texinfo vim markupSafe jinja2 systemd dbus man-DB procps-ng \
util-linux e2fsprogs; do
    echo -n ""
    insidechroot_install_package 8 $package
done
source chroot_bash.sh "$LFS" "/sources/insidechroot3.sh"
source chroot_bash.sh "$LFS" "/sources/insidechroot4.sh"

# Stage 5 include UEFI installation
# >mount uefi partition first
boot_mounted=`mount | grep "$LFS/boot/efi"`
if [ "$boot_mounted" == "" ] ;then
    sudo mkdir -pv "$LFS/boot/efi"
    sudo mount -v -t vfat "${LFS_DISK}1" -o codepage=437,iocharset=iso8859-1 \
      "$LFS/boot/efi"
fi

source chroot_bash.sh "$LFS" "/sources/insidechroot5.sh"        # fstab create
for package in linux mandoc popt efivar efibootmgr freeType grub cpio dracut which; do
    echo -n ""
    insidechroot_install_package 10 $package
done
source chroot_bash.sh "$LFS" "/sources/insidechroot7.sh"
source chroot_bash.sh "$LFS" "/sources/insidechroot6.sh"

# Unmount efi
efi_mounted=`mount | grep "$LFS/boot/efi"`
if [ "$efi_mounted" != "" ] ;then
    sudo umount -v $LFS/boot/efi
fi

# Unmount lfs
lfs_mounted=`mount | grep "$LFS"`
if [ "$lfs_mounted" != "" ] ;then
    sudo umount -v $LFS
fi

exit
