python3 -c 'from pty import spawn; spawn(["echo", "ok"])'

if [ "`uname -m`" == "aarch64" ]; then
./configure --prefix=/usr           \
            --with-tcl=/usr/lib     \
            --enable-shared         \
            --mandir=/usr/share/man \
	    --build=aarch64-unknown-linux-gnu \
            --with-tclinclude=/usr/include
else
./configure --prefix=/usr           \
            --with-tcl=/usr/lib     \
            --enable-shared         \
            --mandir=/usr/share/man \
            --with-tclinclude=/usr/include
fi

make

make test

make install
ln -svf expect$VERSION/libexpect$VERSION.so /usr/lib
