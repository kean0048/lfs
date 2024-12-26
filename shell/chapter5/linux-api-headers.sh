if [ "`uname -m`" == "aarch64" ]; then
    make ARCH=arm64 mrproper
    make ARCH=arm64 headers
else
    make mrproper
    make headers
fi

find usr/include -type f ! -name '*.h' -delete
cp -rv usr/include $LFS/usr
