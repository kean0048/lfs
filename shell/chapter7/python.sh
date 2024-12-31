./configure --prefix=/usr   \
            --enable-shared \
            --without-ensurepip


make $MAKEFLAGS

make $MAKEFLAGS install
