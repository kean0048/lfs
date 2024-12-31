STATUS_LOG="./download.log"

source format-packages-info.sh "${PACKAGES_FILE}"
source format-patches-info.sh "${PATCHES_FILE}"

echo "START" > $STATUS_LOG
cat "$PACKAGES_FILE" | while read line; do
    NAME="`echo $line | cut -d\; -f1`"
    VERSION="`echo $line | cut -d\; -f2`"
    URL="`echo $line | cut -d\; -f3`"
    MD5SUM="`echo $line | cut -d\; -f4`"

    CACHEFILE="$(basename "$URL")"

    echo NAME $NAME
    echo VERSION $VERSION
    echo URL $URL
    echo MD5SUM $MD5SUM
    echo CACHEFILE $CACHEFILE

    if [ ! -f "$CACHEFILE" ]; then
        echo "Downloading $URL"
        wget -c "$URL"
    fi

    if ! echo "$MD5SUM $CACHEFILE" | md5sum -c > /dev/null; then
        rm -rf "$CACHEFILE"
        echo "Verification of $CACHEFILE failed! MD5 mismatch!"
	echo "FAIL" > $STATUS_LOG
	break
    fi
done

if [ "`cat $STATUS_LOG`" == "FAIL" ]; then
    exit 1
fi 

cat "$PATCHES_FILE" | while read line; do
    URL="`echo $line | cut -d\; -f2`"
    MD5SUM="`echo $line | cut -d\; -f3`"

    CACHEFILE="$(basename "$URL")"

    echo URL $URL
    echo MD5SUM $MD5SUM

    if [ ! -f "$CACHEFILE" ]; then
        echo "Downloading $URL"
        wget -c "$URL"
    fi

    if ! echo "$MD5SUM $CACHEFILE" | md5sum -c > /dev/null; then
        rm -rf "$CACHEFILE"
        echo "Verification of $CACHEFILE failed! MD5 mismatch!"
	echo "FAIL" > $STATUS_LOG
	break
    fi
done

if [ "`cat $STATUS_LOG`" == "FAIL" ]; then
    exit 1
fi 

cat "$ADDITIONAL_FILE" | while read line; do
    URL=$line

    echo URL $URL
    CACHEFILE="$(basename "$URL")"

    if [ ! -f "$CACHEFILE" ]; then
        echo "Downloading $URL"
        wget -c "$URL"
    fi
done

if [ "$STATUS" == "FAIL" ]; then
    exit 1
fi 
