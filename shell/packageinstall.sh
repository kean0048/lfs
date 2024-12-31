CHAPTER="$1"
PACKAGE="$2"

if [ "$PACKAGE" == "linux-api-headers" ]; then
    line="`cat "$PACKAGES_FILE" | grep -i "^linux" | grep -i -v "\.patch;"`"
elif [ "$PACKAGE" == "libstdc++" ]; then
    line="`cat "$PACKAGES_FILE" | grep -i "^gcc" | grep -i -v "\.patch;"`"
elif [ "$PACKAGE" == "libelf" ]; then
    line="`cat "$PACKAGES_FILE" | grep -i "^elfutils" | grep -i -v "\.patch;"`"
elif [ "$PACKAGE" == "udev" ]; then
    line="`cat "$PACKAGES_FILE" | grep -i "^systemd" | grep -i -v "\.patch;"`"
elif [ "$PACKAGE" == "procps-ng" ]; then
    line="`cat "$PACKAGES_FILE" | grep -i "^procps" | grep -i -v "\.patch;"`"
else
    line="`cat "$PACKAGES_FILE" | grep -i "^$PACKAGE" | grep -i -v "\.patch;"`"
fi

if [ "$line" == "" ] ; then
    echo "Canot not find $PACKAGE!"
    exit 1
fi

export MAKEFLAGS="-j`nproc`"
export VERSION="`echo $line | cut -d\; -f2`"
URL="`echo $line | cut -d\; -f3`"
CACHEFILE="$(basename "$URL")"
DIRNAME="$(echo "$CACHEFILE" | sed 's/\(.*\)\.tar\..*/\1/')"

if [ -d "$DIRNAME" ]; then
   rm -rfd "$DIRNAME"
fi

mkdir -pv "$DIRNAME"

echo "Extracting $CACHEFILE"
tar -xf "$CACHEFILE" -C "$DIRNAME"

pushd $DIRNAME
    if [ "$(ls -1A | wc -l)" == "1" ]; then
        mv $(ls -1A)/{*,.*} ./
    fi

    echo "Compiling $PACKAGE"
    sleep 5

    mkdir -pv "../log/chapter$CHAPTER/"

    # set -exo pipefail
    set -eo pipefail
    echo "Build ../chapter$CHAPTER/$PACKAGE ..."
    source "../chapter$CHAPTER/$PACKAGE.sh" 2>&1 | cat > "../log/chapter$CHAPTER/$PACKAGE.log"
    set +eo pipefail

    echo "Done Compiling $PACKAGE"

popd
