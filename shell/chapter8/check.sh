./configure --prefix=/usr --disable-static

make

make check

make docdir=/usr/share/doc/check-$VERSION install
