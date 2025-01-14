./configure --prefix=/usr --docdir=/usr/share/doc/automake-$VERSION

make $MAKEFLAGS

# make -j$(($(nproc)>4?$(nproc):4)) check

make install
