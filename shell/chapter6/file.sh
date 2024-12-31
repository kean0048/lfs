mkdir build
pushd build
  ../configure --disable-bzlib      \
               --disable-libseccomp \
               --disable-xzlib      \
               --disable-zlib
  make $MAKEFLAGS
popd

./configure --prefix=/usr --host=$LFS_TGT --build=$(./config.guess)

make $MAKEFLAGS FILE_COMPILE=$(pwd)/build/src/file

make $MAKEFLAGS DESTDIR=$LFS install

rm -v $LFS/usr/lib/libmagic.la
