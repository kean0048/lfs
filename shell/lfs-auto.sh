#!/bin/bash

export ARCH=$(uname -m)
export LFS=/mnt/lfs
export LFS_TGT=${ARCH}-lfs-linux-gnu
export LFS_DISK="$1"
export PACKAGES_FILE="packages.csv"
export PATCHES_FILE="patches.csv"
export ADDITIONAL_FILE="additional.csv"
export USER=$(id -un)
export FORMAT="$2"
export COMPILE_STATUS_FILE="${LFS}/sources/compile_status"
export MAKEFLAGS="-j$(nproc)"
export CHECKPOINT_FILE="${LFS}/checkpoint"

if [ -z "$LFS_DISK" ]; then
    echo "Usage: ./shell/lfs.sh devicePath [format]"
    exit 1
fi

function insidechroot_install_package() {
    chapter="$1"
    package="$2"

    echo -n ""
    source chroot_bash.sh "$LFS" "/sources/insidechrootpackageinstall.sh ${chapter} ${package}"
    result="$(cat ${COMPILE_STATUS_FILE})"
    if [ "$result" != "COMPILE $package DONE" ]; then
        echo "Compiling $package failed!"
        exit 1
    fi 
    echo "$chapter $package" > "$CHECKPOINT_FILE"
}

function setup_and_mount_lfs() {
    if ! grep -q "$LFS" /proc/mounts; then
        if [ "$FORMAT" == "format" ]; then
            source shell/setupdisk.sh "$LFS_DISK"
        fi

        sudo mkdir -pv "$LFS"
        sudo mount "${LFS_DISK}2" "$LFS"
        mounted=$(mount | grep "${LFS_DISK}2")
        if [ -z "$mounted" ]; then
            echo "Mount ${LFS_DISK}2 failed!"
            exit 1
        fi

        sudo chown -v $USER "$LFS"
        mkdir -pv $LFS/sources $LFS/tools
        sudo cp -rf sources/pub/lfs/lfs-packages/12.1/* $LFS/sources/
        mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}

        for i in bin lib sbin; do
            ln -sv usr/$i $LFS/$i
        done

        case $(uname -m) in
            x86_64) mkdir -pv $LFS/lib64 ;;
        esac
    fi
}

function install_packages_outside_chroot() {
    local chapter="$1"
    shift
    for package in "$@"; do
        echo -n ""
        source packageinstall.sh "$chapter" "$package"
        echo "$chapter $package" > "$CHECKPOINT_FILE"
    done
}

function install_packages_inside_chroot() {
    local chapter="$1"
    shift
    for package in "$@"; do
        echo -n ""
        insidechroot_install_package "$chapter" "$package"
    done
}

function handle_uefi_installation() {
    local boot_mounted=$(mount | grep "$LFS/boot/efi")
    if [ -z "$boot_mounted" ]; then
        sudo mkdir -pv "$LFS/boot/efi"
        sudo mount -v -t vfat "${LFS_DISK}1" -o codepage=437,iocharset=iso8859-1 "$LFS/boot/efi"
    fi

    source chroot_bash.sh "$LFS" "/sources/insidechroot5.sh"
    install_packages_inside_chroot 10 linux mandoc popt efivar efibootmgr freeType grub cpio dracut squashfstools

    source chroot_bash.sh "$LFS" "/sources/insidechroot7.sh"
    source chroot_bash.sh "$LFS" "/sources/insidechroot6.sh"

    if [ -n "$(mount | grep "$LFS/boot/efi")" ]; then
        umount -v $LFS/boot/efi
    fi
}

function resume_from_checkpoint() {
    if [ -f "$CHECKPOINT_FILE" ]; then
        local checkpoint=$(cat "$CHECKPOINT_FILE")
        local chapter=$(echo "$checkpoint" | cut -d ' ' -f 1)
        local package=$(echo "$checkpoint" | cut -d ' ' -f 2)
        echo "Resuming from chapter $chapter, package $package"
        return 0
    else
        return 1
    fi
}

# Main script execution
setup_and_mount_lfs

cp -rf shell/* data/* "$LFS/sources"
cd "$LFS/sources"

source download.sh
source versioncheck.sh

export PATH="$LFS/tools/bin:$PATH"

if ! resume_from_checkpoint; then
    echo "Starting from the beginning"
    echo "0 start" > "$CHECKPOINT_FILE"
fi

checkpoint=$(cat "$CHECKPOINT_FILE")
chapter=$(echo "$checkpoint" | cut -d ' ' -f 1)
package=$(echo "$checkpoint" | cut -d ' ' -f 2)

if [ "$chapter" -le 5 ]; then
    install_packages_outside_chroot 5 binutils gcc linux-api-headers glibc libstdc++
fi

if [ "$chapter" -le 6 ]; then
    install_packages_outside_chroot 6 m4 ncurses bash coreutils diffutils file findutils gawk grep gzip make patch sed tar xz binutils gcc
fi

chmod ugo+x insidechroot*.sh insidechrootpackageinstall.sh

if [ "$chapter" -le 7 ]; then
    source chroot_bash.sh "$LFS" "/sources/insidechroot.sh"
    install_packages_inside_chroot 7 gettext bison perl python texinfo util-linux
    source chroot_bash.sh "$LFS" "/sources/insidechroot2.sh"
fi

if [ "$chapter" -le 8 ]; then
    install_packages_inside_chroot 8 man-pages iana-etc glibc zlib bzip2 xz zstd file readline m4 bc flex tcl expect dejaGNU pkgconf binutils gmp mpfr mpc attr acl libcap libxcrypt shadow gcc ncurses sed psmisc gettext bison grep bash libtool gdbm gperf expat inetutils less perl XML-Parser intltool autoconf automake openSSL kmod libelf libffi python flit-Core wheel setuptools ninja meson coreutils check diffutils gawk findutils groff grub gzip IPRoute2 kbd libpipeline make patch tar texinfo vim markupSafe jinja2 systemd dbus man-DB procps-ng util-linux e2fsprogs
    source chroot_bash.sh "$LFS" "/sources/insidechroot3.sh"
    source chroot_bash.sh "$LFS" "/sources/insidechroot4.sh"
fi

if [ "$chapter" -le 10 ]; then
    handle_uefi_installation
fi

if [ -n "$(mount | grep "$LFS")" ]; then
    umount -v $LFS
fi

exit