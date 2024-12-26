FORCE_UNSAFE_CONFIGURE=1  \
./configure --prefix=/usr

make

set +exo pipefail
make check
set -exo pipefail

make install
make -C doc install-html docdir=/usr/share/doc/tar-$VERSION
