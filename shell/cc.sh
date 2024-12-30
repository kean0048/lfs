#!/bin/bash

export ARCH=`uname -m`
export LFS=/mnt/lfs
export LFS_TGT=${ARCH}-lfs-linux-gnu
export LFS_DISK=""
export PACKAGES_FILE="packages.csv"
export PATCHES_FILE="patches.csv"
export ADDITIONAL_FILE="additional.csv"
export USER=`id -un`
export FORMAT=""
export COMPILE_STATUS_FILE="${LFS}/sources/compile_status"
export MAKEFLAGS="-j`nproc`"
export PATH="$LFS/tools/bin:$PATH"

chapter=""
package=""
index=""

function usage()
{
	# TODO
	echo "Hello World"
}

function insidechroot_install_package()
{
	echo "chapter = ${chapter}"
	echo "package = ${package}"
    echo -n ""
    source chroot_bash.sh "$LFS" "/sources/insidechrootpackageinstall.sh ${chapter} ${package}"
    result="$(cat ${COMPILE_STATUS_FILE})"
    if [ "$result" != "COMPLIE $package DONE" ]; then
		echo "Compiling $package failed!"
		exit 1
    fi 
}

function inside_nonchroot_install_package()
{
	echo "chapter = ${chapter}"
	echo "package = ${package}"
    echo -n ""

    source packageinstall.sh ${chapter} ${package}
}

function insidechroot()
{
	echo "index = $index"
	source chroot_bash.sh "$LFS" "/sources/insidechroot${index}.sh"
}

function mount_efi()
{
	boot_mounted=`mount | grep "$LFS/boot/efi"`
	if [ "$boot_mounted" == "" ] ;then
		sudo mkdir -pv "$LFS/boot/efi"
		sudo mount -v -t vfat "${LFS_DISK}1" -o codepage=437,iocharset=iso8859-1 \
		  "$LFS/boot/efi"
	fi
}

function umount_lfs()
{    
	lfs_mounted=`mount | grep "$LFS"`
	if [ -n "$lfs_mounted" ];then
		echo "$lfs_mounted" | cut -d" " -f3 | sort -n -r | tac | xargs sudo umount
		echo "$lfs_mounted" | cut -d" " -f3 | sort -n -r | tac
	fi
}


INSIDECHROOT=false
INSIDENONCHROOTPACKAGE=false
INSIDECHROOTPACKAGE=false
UEFI=false
UNMOUNT=false

while [ $# -gt 0 ]; do
  case $1 in
    -v|--version|v)
      echo $LFS_VERSION
      exit
      ;;
    -i|--insidechroot|i)
      index=$2
      INSIDECHROOT=true
      shift
      shift
      ;;
    -e|--uefi|e)
      UEFI=true
      shift
      ;;
    -n|--insidenonchroot|n)
      INSIDENONCHROOTPACKAGE=true
      chapter="$2"
      package="$3"
      shift
      shift
      shift
      ;;
    -r|--insidechroot|r)
      chapter="$2"
      package="$3"
      INSIDECHROOTPACKAGE=true
      shift
      shift
      shift
      ;;
    -d|--device|d)
    	  LFS_DISK=$2
    	  shift
    	  shift
    	  ;;
    	-f|--format|f)
    	  FORMAT=$2
    	  shift
    	  shift
    	  ;;
    	-u|--umount|u)
    	  UNMOUNT=true
    	  shift
    	  ;;
    *)
      echo "Unknown options set."
      echo "Read the manual for usage instructions."
      exit 1
      ;;
  esac
done

set -x
if ! grep -q "$LFS" /proc/mounts; then
    if [ "$FORMAT" == "format" ]; then
        source shell/setupdisk.sh "$LFS_DISK"
    fi

    sudo mount "${LFS_DISK}2" "$LFS"
    mounted=`mount | grep "${LFS_DISK}2"`
    if [ "$mounted" == "" ] ;then
	echo "Mount ${LFS_DISK}2 failed!"
	exit 1
    fi

    sudo chown -v $USER "$LFS"
    cd "$LFS/sources"
    chmod ugo+x insidechroot*.sh
	chmod ugo+x insidechrootpackageinstall.sh 
fi

function main()
{
	$UEFI && mount_efi
	$INSIDECHROOT && insidechroot
    $INSIDENONCHROOTPACKAGE && inside_nonchroot_install_package
    $INSIDECHROOTPACKAGE && insidechroot_install_package
    
    $UNMOUNT && umount_lfs
    
    if [ $UNMOUNT == false ];then
    		umount_lfs
    	fi
}

main

