./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/expat-$VERSION

make

make check

make install

install -v -m644 doc/*.{html,css} /usr/share/doc/expat-$VERSION
