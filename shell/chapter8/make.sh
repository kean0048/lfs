./configure --prefix=/usr

make $MAKEFLAGS

chown -R tester .
su tester -c "PATH=$PATH make check"

make install
