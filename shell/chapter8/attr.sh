./configure --prefix=/usr     \
            --disable-static  \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/attr-$VERSION

make $MAKEFLAGS

# set +exo pipefail
# make check
# set -exo pipefail

make install $MAKEFLAGS
