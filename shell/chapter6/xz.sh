./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --disable-static                  \
            --docdir=/usr/share/doc/xz-5.4.6


make

make DESTDIR=$LFS install

rm -v $LFS/usr/lib/liblzma.la
