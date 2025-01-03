sed -i 's/extras//' Makefile.in

./configure --prefix=/usr

make

chown -R tester .
su tester -c "PATH=$PATH make check"

rm -f /usr/bin/gawk-$VERSION
make install

ln -sv gawk.1 /usr/share/man/man1/awk.1

mkdir -pv                                   /usr/share/doc/gawk-$VERSION
cp    -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-$VERSION
