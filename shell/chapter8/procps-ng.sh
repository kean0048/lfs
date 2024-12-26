./configure --prefix=/usr                           \
            --docdir=/usr/share/doc/procps-ng-$VERSION \
            --disable-static                        \
            --disable-kill

make

set +exo pipefail
make -k check
set -exo pipefail

make install
