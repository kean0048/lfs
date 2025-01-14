PERL_VERSION=`echo $VERSION | awk -F "." '{print $1"."$2}'`

echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h

./configure --prefix=/usr

make $MAKEFLAGS

set +exo pipefail
chown -R tester .

su tester -c "TERM=xterm-256color LANG=en_US.UTF-8 make -j1 test" \
   &> vim-test.log
set -exo pipefail

make install

if [ -f /usr/bin/vi ]; then
    rm -f /usr/bin/vi
fi

ln -sv vim /usr/bin/vi
for L in  /usr/share/man/{,*/}man1/vim.1; do
    ln -sv vim.1 $(dirname $L)/vi.1
done

if [ -f /usr/share/doc/vim-$VERSION ]; then
    rm -f /usr/share/doc/vim-$VERSION
fi
ln -sv ../vim/vim91/doc /usr/share/doc/vim-$VERSION

cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc

" Ensure defaults are set before customizing settings, not after
source $VIMRUNTIME/defaults.vim
let skip_defaults_vim=1

set nocompatible
set backspace=2
set mouse=
syntax on
if (&term == "xterm") || (&term == "putty")
  set background=dark
endif

" End /etc/vimrc
EOF
