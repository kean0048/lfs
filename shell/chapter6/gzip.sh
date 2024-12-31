./configure --prefix=/usr --host=$LFS_TGT

make $MAKEFLAGS

make $MAKEFLAGS DESTDIR=$LFS install
