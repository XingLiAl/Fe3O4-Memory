---
title: "修复 Arch Linux 图形化挂载本地硬盘分区需要输入密码的问题"
date: 2022-03-06T07:28:39+08:00
draft: false
categories: ["Linux"]
tags: ["Linux", "Arch Linux"]
---

## 问题
发现我的 Arch KDE 在 Dolphin 文件管理器下挂载本地硬盘分区需要输入密码才能挂载, 但挂载 U 盘时不需要

经 [Archlinuxcn](https://t.me/archlinuxcn_group) 的群友提醒后, 去查找 polkit 的问题 (~~然而一直拖到了现在~~

然后就在 ```/etc/polkit-1/rules.d/50-udiskie.rules``` 中发现了这么一段东东(
```shell
if (subject.isInGroup("storage")) {
    return permission[action.id];
  }
```
这里会判断用户是否在 storage 这个组里面

我用 ```groups fe3o4``` 指令看了一下, 发现我并不在这个组里, 这也就解释了为什么我挂载本地磁盘需要密码了

Ps. 但我还是不知道为什么挂载 U 盘时不需要


## 解决
把自己加到这个组里就好了(

例如用:
```shell
# gpasswd -a 你的用户名 storage
```
就好啦
