mkdir -pv /usr/share/fonts/unifont &&
gunzip -c ../unifont-15.1.04.pcf.gz > /usr/share/fonts/unifont/unifont.pcf

unset {C,CPP,CXX,LD}FLAGS

echo depends bli part_gpt > grub-core/extra_deps.lst

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --disable-efiemu     \
            --enable-grub-mkfont \
            --with-platform=efi  \
            --target=x86_64      \
            --disable-werror     &&
unset TARGET_CC &&
make

make install &&
mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions

make -j1 DESTDIR=$PWD/dest install
cp -av dest/usr/lib/grub/x86_64-efi -T /usr/lib/grub/x86_64-efi
cp -av dest/usr/share/grub/*.{pf2,h}   /usr/share/grub
cp -av dest/usr/bin/grub-mkfont        /usr/bin

for libdir in /lib /usr/lib $(find /opt -name lib); do
  find $libdir -name *.la           \
             ! -path *ImageMagick* \
               -delete
done
