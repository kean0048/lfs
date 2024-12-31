./configure --prefix=/usr                      \
            --build=$(sh support/config.guess) \
            --host=$LFS_TGT                    \
            --without-bash-malloc

make $MAKEFLAGS

make $MAKEFLAGS DESTDIR=$LFS install

ln -sv bash $LFS/bin/sh
