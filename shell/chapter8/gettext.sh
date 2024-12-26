./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/gettext-$VERSION

make

set +exo pipefail
make check
set -exo pipefail

make install
chmod -v 0755 /usr/lib/preloadable_libintl.so
