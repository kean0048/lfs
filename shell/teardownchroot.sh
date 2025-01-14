#!/bin/bash

export LFS="$1"

if [ "$LFS" == "" ]; then
    exit 1
fi

dev_mounted=`mount | grep "$LFS/dev"`
if [ "$dev_mounted" != "" ] ;then
    mountpoint -q $LFS/dev/shm && umount $LFS/dev/shm
    umount -v $LFS/dev/pts
    umount -v $LFS/dev
fi

run_mounted=`mount | grep "$LFS/run"`
if [ "$run_mounted" != "" ] ;then
    umount -v $LFS/run
fi

proc_mounted=`mount | grep "$LFS/proc"`
if [ "$proc_mounted" != "" ] ;then
    umount -v $LFS/proc
fi

efivar_mounted=`mount | grep "$LFS/sys/firmware/efi/efivars"`
if [ "$efivar_mounted" != "" ] ;then
    umount -v $LFS/sys/firmware/efi/efivars
fi

sys_mounted=`mount | grep "$LFS/sys"`
if [ "$sys_mounted" != "" ] ;then
    umount -v $LFS/sys
fi

