---
title: "为 Arch Linux 启用休眠"
date: 2022-02-13T15:54:01+08:00
draft: false
categories: ["Linux"]
tags: ["Linux", "Arch Linux"]
---

## 前面的废话
话说我的 Arch Linux 运行了这么久还没有睡过一次 (~~虽然指的是休眠不是睡眠~~ (小声), 这次就给她一个休眠的能力吧

看起来似乎挺容易的, 但实际上还是在 Archlinuxcn 群友的帮助下完成的 (~~我什么也不会, 不像群友个个都是全栈, 呜~~

可能因为我用的是休眠文件, 而且错误的理解了 wiki 的意思, 然后就把挂在参数填错了, 最后还是群友帮我指出哪里错了 ~~英语教学~~, 真的非常感谢, 这里偷偷地放个传送门吧: [我不是链接](https://t.me/archlinuxcn_group)


## 具体步骤
其实跟着 [wiki](https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Hibernation) 走就行啦 (只要不像我一样理解错意思

### 创建交换文件
如果你想使用 swap 分区, 可以跳过这一步, ~~也可以绕过我踩的坑~~
```shell
# dd if=/dev/zero of=/swapfile bs=1M count=大小(MB) status=progress #创建空文件
# chmod 600 /swapfile #更改文件权限(为了安全)
# mkswap /swapfile #把空文件格式化为交换 分区(?)
# swapon /swapfile #启用交换文件
```
这里的交换文件可以放在别的地方,比如其它的分区或子目录

关于交换文件的大小, [wiki](https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Hibernation_into_swap_file) 中是这么说的:
> About swap partition/file size
>
>Even if your swap partition is smaller than RAM, you still have a big chance of hibernating successfully. See "image_size" in the kernel documentation for information on the image_size sysfs(5) pseudo-file.
>
>You may either decrease the value of /sys/power/image_size to make the suspend image as small as possible (for small swap partitions), or increase it to possibly speed up the hibernation process. For systems with a large amount of RAM, smaller values may drastically increase the speed of resuming a hibernating system. See systemd#systemd-tmpfiles - temporary files to make this change persistent.
>
>The suspend image cannot span multiple swap partitions and/or swap files. It must fully fit in one swap partition or one swap file.

但是为了保证休眠成功, 我觉得还是把大小设置为 1.5-2 倍内存大小比较好

### 修改 fstab来挂载交换分区/文件:
向 /etc/fstab 中添加这一行:
```
/swapfile none swap defaults 0 0
```
如果你使用交换分区, 那么把 /swapfile 改为分区 UUID 或 /dev 下的设备文件即可

注意, 交换分区启用前也需要格式化(刚才忘了说了, 抱歉):
```shell
# mkswap /dev/sdxy # 格式化交换分区
# swapon /dev/sdxy # 启用交换分区
```

### 修改内核参数
在你的内核参数后添加:
```
resume=交换文件所在分区或交换分区, resume_offset=交换文件偏移量(如果是交换分区就不用添加这个)
```
内核参数的写法可参照 [wiki](https://wiki.archlinux.org/title/Kernel_parameters)

如果你使用 grub, 那么可以编辑 /etc/default/grub 中的 GRUB_CMDLINE_LINUX 后面的值, 保存后执行 update-grub 来更新即可

需要注意的是, 如果你使用交换文件, resume后面应该写上交换文件 **所在的分区** 而不是交换文件本身 (我就被卡在这里(, [原文](https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Hibernation_into_swap_file):
> swap_device is the volume where the swap file resides and it follows the same format as for the root parameter.

交换文件偏移量可以用以下指令来获取:
```shell
# filefrag -v /swapfile | awk '$1=="0:" {print substr($4, 1, length($4)-2)}'
```
得到的数字就是偏移量 (废话

### 配置 initramfs

在 /etc/mkinitcpio.conf 中的 HOOKS 后面加入 resume 这个钩子, 注意这个钩子必须添加在 udev 的后面 (lvm 用户还要保证他在 lvm 钩子后面, 如果存在 systemd钩子, 则不需要进行此步骤), 参考 [原文](https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Configure_the_initramfs):
> Configure the initramfs
> When an initramfs with the base hook is used, which is the default, the resume hook is required in /etc/mkinitcpio.conf. Whether by label or by UUID, the swap partition is referred to with a udev device node, so the resume hook must go after the udev hook. This example was made starting from the default hook configuration:
> HOOKS=(base udev autodetect keyboard modconf block filesystems resume fsck)
> Remember to regenerate the initramfs for these changes to take effect.
> Note: LVM users should add the resume hook after lvm2.
> When an initramfs with the systemd hook is used, a resume mechanism is already provided, and no further hooks need to be added.

修改完后, 需要 [刷新 initramfs](https://wiki.archlinux.org/title/Mkinitcpio#Image_creation_and_activation):
```shell
# mkinitcpio -p linux #仅刷新 linux
# mkinitcpio -P #刷新全部
```

如果一切正确, 在下次重启后, 你的 Arch 应该就可以休眠了 (如果是 KDE, 休眠图标就会在开始菜单中出现啦)
