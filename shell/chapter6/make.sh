./configure --prefix=/usr   \
            --without-guile \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make $MAKEFLAGS

make $MAKEFLAGS DESTDIR=$LFS install
