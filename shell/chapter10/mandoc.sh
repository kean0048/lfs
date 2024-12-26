./configure &&
make mandoc

make regress

install -vm755 mandoc   /usr/bin
