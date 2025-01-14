sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install

patch -Np1 -i ../readline-8.2-upstream_fixes-3.patch

./configure --prefix=/usr    \
            --disable-static \
            --with-curses    \
            --docdir=/usr/share/doc/readline-$VERSION

make $MAKEFLAGS SHLIB_LIBS="-lncursesw"

make $MAKEFLAGS SHLIB_LIBS="-lncursesw" install

install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-8.2
