#!/bin/bash

export LFS="$1"
export SCRIPT="$2"

if [ "$LFS" == "" ]; then
    exit 1
fi

chmod ugo+x preparechroot.sh

sudo ./preparechroot.sh "$LFS" 

sudo chroot "$LFS" /usr/bin/env -i   \
     HOME=/root                  \
     TERM="$TERM"                \
     PS1='(lfs chroot) \u:\w\$ ' \
     PATH=/usr/bin:/usr/sbin     \
     MAKEFLAGS="-j$(nproc)"      \
     TESTSUITEFLAGS="-j$(nproc)" \
     PACKAGES_FILE="$PACKAGES_FILE" \
     LFS_DISK="$LFS_DISK" \
    /bin/bash --login +h -c "$SCRIPT"

chmod ugo+x teardownchroot.sh
sudo ./teardownchroot.sh "$LFS"
