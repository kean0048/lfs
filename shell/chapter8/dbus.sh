./configure --prefix=/usr                        \
            --sysconfdir=/etc                    \
            --localstatedir=/var                 \
            --runstatedir=/run                   \
            --enable-user-session                \
            --disable-static                     \
            --disable-doxygen-docs               \
            --disable-xml-docs                   \
            --docdir=/usr/share/doc/dbus-$VERSION \
            --with-system-socket=/run/dbus/system_bus_socket

make

make check

make install

ln -sfv /etc/machine-id /var/lib/dbus
