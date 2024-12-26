mkdir -v build
cd       build

../libstdc++-v3/configure           \
    --host=$LFS_TGT                 \
    --build=$(../config.guess)      \
    --prefix=/usr                   \
    --disable-multilib              \
    --disable-nls                   \
    --disable-libstdcxx-pch         \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/$VERSION

make 

make DESTDIR=$LFS install

if [ "`uname -m`" == "aarch64" ]; then
    rm -v $LFS/usr/lib64/lib{stdc++{,exp,fs},supc++}.la
else
    rm -v $LFS/usr/lib/lib{stdc++{,exp,fs},supc++}.la
fi
