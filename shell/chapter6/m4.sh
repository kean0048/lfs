export CFLAGS="$CFLAGS -Wno-error=null-dereference"

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make $MAKEFLAGS

make $MAKEFLAGS DESTDIR=$LFS install
