export LFS=""
cd /sources

CHAPTER="$1"
PACKAGE="$2"

echo -n ""
echo "START COMPLIE $PACKAGE" > compile_status

if [ -f /usr/sbin/ldconfig ]; then
    /usr/sbin/ldconfig
fi

source packageinstall.sh "$CHAPTER" "$PACKAGE"
echo "COMPLIE $PACKAGE DONE" > compile_status
