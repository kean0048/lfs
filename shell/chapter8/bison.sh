./configure --prefix=/usr --docdir=/usr/share/doc/bison-$VERSION

make

set +exo pipefail
make check
set -exo pipefail

make install
