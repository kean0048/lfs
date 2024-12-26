# lfs-auto

##Introduction
LFS tutorial automatically builds scripts to build a Linux operating system from scratch.

##Experimental environment
-We need to add a second disk to the virtual machine, no less than 30GB, to store the compiled LFS system files.

##Building LFS
Firstly, you need to create a new * * lfs * * user according to the tutorial, modify the '/etc/sudoers' file, and add:

```
lfs ALL=(ALL:ALL) NOPASSWD: ALL
```

Ask the lfs user to run the 'sudo' command without password, switch to the * * lfs * * user, and run the command line:

```
bash ./shell/lfs.sh /dev/[sd*] [format]
```

If the format parameter is given, the specified disk will be reformatted and partitioned. If not specified, only mounting will be performed.

##LFS system startup
After the LFS system is built, restart the virtual machine, press F12 when the virtual machine starts, and then select the second disk to boot up.
After starting the login terminal, enter the username * * root * * and password * * root * * to log in.

##Frequently Asked Questions
-The software package is currently slow or cannot be downloaded directly
-Can be obtained from http://ftp.lfs-matrix.net/pub/lfs/ Download the corresponding version of the source code compressed file, then unzip and copy it to the corresponding sources directory.
