./configure --disable-shared

make $MAKEFLAGS

cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin
