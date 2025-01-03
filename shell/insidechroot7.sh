grub-install --target=x86_64-efi --removable

mountpoint /sys/firmware/efi/efivars || mount -v -t efivarfs efivarfs /sys/firmware/efi/efivars

grub-install --bootloader-id=LFS --recheck

efibootmgr | cut -f 1

dracut --omit "systemd systemd-initrd" -I "/usr/lib/libkmod.so" --kver 6.7.4 /boot/initrd.img-6.7.4 --force
# dracut   --omit  "systemd dracut-systemd systemd-initrd systemd-networkd systemd-sysusers" \
#        --add "dm dmsquash-live dmsquash-live-autooverlay kernel-modules bash" \  
#        --zstd  --no-hostonly   --no-hostonly-cmdline   --no-hostonly-i18n  --force \
#        --kver 6.7.4
       
cat > /boot/grub/grub.cfg << EOF
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod part_gpt
insmod ext4
set root=(hd0,2)

insmod all_video
if loadfont /boot/grub/fonts/unicode.pf2; then
  terminal_output gfxterm
fi

menuentry "GNU/Linux, Linux 6.7.4-lfs-12.1"  {
  linux   /boot/vmlinuz-6.7.4-lfs-12.1 root=/dev/sda2 ro video=efifb:on splash console=tty
  initrd /boot/initrd.img-6.7.4
}

menuentry "Firmware Setup" {
  fwsetup
}
EOF
