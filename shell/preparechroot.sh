#!/bin/bash

export LFS="$1"

if [ "$LFS" == "" ]; then
    exit 1
fi

chown -R root:root $LFS/{usr,lib,var,etc,bin,sbin}
if [ -d $LFS/tools ]; then
    chown -R root:root $LFS/tools
fi
case $(uname -m) in
  x86_64) chown -R root:root $LFS/lib64 ;;
esac

mkdir -pv $LFS/{dev,proc,sys,run}

dev_mounted=`mount | grep "$LFS/dev"`
if [ "$dev_mounted" == "" ] ;then
    mount -v --bind /dev $LFS/dev
    mount -vt devpts devpts -o gid=5,mode=0620 $LFS/dev/pts

    if [ -h $LFS/dev/shm ]; then
      install -v -d -m 1777 $LFS$(realpath /dev/shm)
    else
      mount -vt tmpfs -o nosuid,nodev tmpfs $LFS/dev/shm
    fi
fi	

run_mounted=`mount | grep "$LFS/run"`
if [ "$run_mounted" == "" ] ;then
    mount -vt tmpfs tmpfs $LFS/run
fi	

sys_mounted=`mount | grep "$LFS/sys"`
if [ "$sys_mounted" == "" ] ;then
    mount -vt sysfs sysfs $LFS/sys
fi	

proc_mounted=`mount | grep "$LFS/proc"`
if [ "$proc_mounted" == "" ] ;then
    mount -vt proc proc $LFS/proc
fi	
