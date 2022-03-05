---
title: "Arch Linux 开机时打开 NumLock (数字小键盘)"
date: 2022-03-05T23:37:26+08:00
draft: false
categories: ["Linux"]
tags: ["Linux", "Arch Linux"]
---

## 问题和探索
最近把台式机的键盘从那种仿笔记本的键盘换成了标准的大键盘 (打代码更舒服了), 但也带来一个问题:

之前用我的那个笔记本键盘时, NumLock 需要保持关闭状态, 不然某些字母键会变成数字 (那个厂商独特设计的 "小键盘" ~~然而一点也不好用~~)

现在换到普通键盘后, 我才发现我的系统会在启动的多个过程中把 NumLock 关掉, 导致输入非常麻烦 (特别是密码, 然后我就在 万能的 wiki 上找到了 [解决方案](https://wiki.archlinux.org/title/Activating_numlock_on_bootup)


## 解决问题
我用的是 Artix (没有 systemd 的 arch 衍生版) + KDE, 所以只列举以下几个 (~~还不是因为懒~~
### 早期启动 (initcpio)
1. 安装 mkinitcpio-numlock 这个包 (在 Archlinuxcn 或 AUR 中能找到)
2. 在 ```/etc/mkinitcpio.conf``` 中的 HOOK 中 添加 numlock, 注意要在 keyboard 后, 在 encrypt 前 (如果有的话), 比如这样:
```
HOOKS=(base udev autodetect modconf block filesystems keyboard numlock resume fsck)
```

3. 重新生成 initcpio
```shell
# mkinitcpio -P
```

### 登录屏幕 (显示管理器 SDDM)
在 ```/etc/sddm.conf``` 中的 General 栏目下添加 ```Numlock=on```, 例如:
```
[General]
Numlock=on
```

### KDE
在系统设置中 选择 *输入设备 -> 键盘*, 把 Numlock 设置成 *开启* 即可

未解决的问题: 启动过程中 NumLock 会经历一两次 关闭在打开 (强迫症表示难受
