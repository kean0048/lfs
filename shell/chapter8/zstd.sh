make $MAKEFLAGS prefix=/usr

make $MAKEFLAGS check

make $MAKEFLAGS prefix=/usr install

rm -v /usr/lib/libzstd.a
