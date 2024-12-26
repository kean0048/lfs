PATCHES_FILE="$1"

cat "${PATCHES_FILE}.orig" | grep "Download:\|MD5 sum:" > "${PATCHES_FILE}"
sed 's/^[ ]*//g' -i "${PATCHES_FILE}"
sed 's/Download: /;/g' -i "${PATCHES_FILE}"
sed 's/MD5 sum: /;/g' -i "${PATCHES_FILE}"
sed 'N;s/\n/ /g' -i "${PATCHES_FILE}"
sed 's/ //g' -i "${PATCHES_FILE}"
