patch -Np1 -i ../kbd-$VERSION-backspace-1.patch

sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in

./configure --prefix=/usr --disable-vlock

make

make check

make install

cp -R -v docs/doc -T /usr/share/doc/kbd-$VERSION
