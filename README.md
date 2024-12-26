# lfs-auto

## 介绍
LFS教程自动构建脚本，从零开始构建一个Linux操作系统。

## 实验环境

- 虚拟机：VirtualBox 7.0。
- 虚拟机系统版本：ubuntu 2404 desktop。
- 需要给虚拟机增加第二块磁盘，不少于30G，用于存放编译出来LFS系统文件。

## 构建LFS

首先需要按照教程中创建一个新的**lfs**用户，修改`/etc/sudoers`文件，在其中添加：

```
lfs ALL=(ALL:ALL) NOPASSWD: ALL
```

让lfs用户免密运行`sudo`命令，切换到**lfs**用户后，命令行运行：

```
bash ./shell/lfs.sh /dev/[sd*] [format]
```

如果给了format参数，则会将指定的磁盘重新进行格式化并进行分区。如果没有指定，则只会进行挂载。

## LFS系统启动

LFS系统构建完成后，重启虚拟机，在虚拟机启动时按下F12，然后选择第2块磁盘引导启动。

启动到登录终端后，输入用户名**root**以及密码**lfs.12.1**进行登录。

## 常见问题

- 软件包现在慢/或者直接下载不了
  - 可从http://ftp.lfs-matrix.net/pub/lfs/下载对应版本的源码压缩包，然后解压复制到对应sources目录下。
