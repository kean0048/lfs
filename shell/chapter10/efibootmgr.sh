if [ "`uname -m`" == "aarch64" ]; then
	make EFIDIR=LFS EFI_LOADER=grubarm64.efi
else
	make EFIDIR=LFS EFI_LOADER=grubx64.efi
fi

make install EFIDIR=LFS
