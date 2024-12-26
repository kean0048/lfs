
PACKAGES_FILE="$1"

cat "${PACKAGES_FILE}.orig" | grep "Download:\|MD5 sum:\|(*) - " > "${PACKAGES_FILE}"
sed 's/) -.*//g' -i "${PACKAGES_FILE}"
sed 's/^[ ]*//g' -i "${PACKAGES_FILE}"
sed 's/ (/;/g' -i "${PACKAGES_FILE}"
sed 's/Download: /;/g' -i "${PACKAGES_FILE}"
sed 's/MD5 sum: /;/g' -i "${PACKAGES_FILE}"
sed 'N;N;s/\n/ /g' -i "${PACKAGES_FILE}"
sed 's/ //g' -i "${PACKAGES_FILE}"
sed 's/[A-Z]/\L&/' -i "${PACKAGES_FILE}"
sed 's/xML::Parser/XML-Parser/g' -i "${PACKAGES_FILE}"
sed 's/systemdManPages(255/systemdManPages;255/g' -i "${PACKAGES_FILE}"
