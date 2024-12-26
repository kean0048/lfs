./configure --prefix=/usr

make

set +exo pipefail
make -k check
set -exo pipefail

make install

rm -fv /usr/lib/libltdl.a
