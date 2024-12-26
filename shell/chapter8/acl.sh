./configure --prefix=/usr         \
            --disable-static      \
            --docdir=/usr/share/doc/acl-$VERSION

make

make install
