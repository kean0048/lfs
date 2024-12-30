if [ "`uname -m`" == "aarch64" ]; then
    make $MAKEFLAGS ARCH=arm64 mrproper
    make $MAKEFLAGS ARCH=arm64 headers
else
    make $MAKEFLAGS mrproper
    make $MAKEFLAGS headers
fi

find usr/include -type f ! -name '*.h' -delete
cp -rv usr/include $LFS/usr
