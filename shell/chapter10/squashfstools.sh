cd squashfs-tools
sed -i 's/#XZ_SUPPORT/XZ_SUPPORT/g' Makefile 
sed -i 's/#ZSTD_SUPPORT/ZSTD_SUPPORT/g' Makefile
#sed -i 's/local/ /g' Makefile
make 
make install
cp -rv /usr/local/bin/{unsquashfs,mksquashfs} /usr/bin/
