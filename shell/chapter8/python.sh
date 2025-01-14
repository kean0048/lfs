./configure --prefix=/usr        \
            --enable-shared      \
            --with-system-expat  \
            --enable-optimizations

make $MAKEFLAGS

make install

cat > /etc/pip.conf << EOF
[global]
root-user-action = ignore
disable-pip-version-check = true
EOF

install -v -dm755 /usr/share/doc/python-$VERSION/html

tar --no-same-owner \
    -xvf ../python-$VERSION-docs-html.tar.bz2
cp -R --no-preserve=mode python-$VERSION-docs-html/* \
    /usr/share/doc/python-$VERSION/html
