---
title: "解决 KDE 搜索功能 (Baloo) 无法使用的问题"
date: 2022-02-06T17:41:18+08:00
draft: false
categories: ["Linux"]
tags: ["Linux", "KDE"]
---

## 前倾概要 (其实就是废话(划掉))
最近发现我的 KDE 无法搜索文件了, 无论在 Dolphin 下搜索什么得到的结果都是空, 但 find 指令却可以找到文件, 因为不常用搜索, 所以也没有怎么在意

之后的几天我又用到了搜索功能, KDE 依然无法搜索到文件, 不过这次我想到了之前在 [archlinuxcn群](https://t.me/archlinuxcn_group) 中看到的大佬们的一段对话, 大概就是说 KDE 的搜索功能靠的是一个叫 Baloo 组件, 于是我就在 archwiki 上搜索 baloo, 但由于没有看到我遇到的错误, 于是也放弃了

然后就到了今天, 我再次用到了搜索功能, 这次我再次找到 Troubleshooting 部分, 找到一个 [比较相似的错误的修复方式](https://wiki.archlinux.org/title/Baloo#Troubleshooting), 就是这个:
> Plasma Vault Files are indexed and available even when vault is closed
This is a major security bug not yet fixed. Any file inside vault is by default indexed and available through file manager search, Krunner and Kickoff.
>
> One workaround is to stop folder(s) from being indexed by Baloo. The relevant options are available in System Settings > Search > File Search > Folder specific configuration > Add folder configuration > Stop indexing a folder. After adding the desired folder, the existing Baloo data needs to be removed and freshly indexed again:
>
> ```shell
> $ balooctl purge
> $ balooctl disable
> $ balooctl enable
> $ balooctl check
> ```

大概意思就是, 删掉索引库, 停止索引, 在开启吧. 我抱着不可能相信的心理试了一下, 但这真的解决了我的问题 ~~, 原来 Linux 这边也开始流行重启解决问题了吗?~~


## 解决方法
如上, 我们只需要依次执行以下指令即可 (不需要 sudo 哦):
```shell
$ balooctl suspend # 暂停文件索引 (其实是可选的, 但还是觉得执行了更保险一点(胡思乱想))
$ balooctl disable # 禁用文件索引
$ balooctl purge # 扔掉文件索引数据库
$ balooctl enable # 启用文件搜索
$ balooctl check # 开始索引文件
```

其实好像在 *系统设置 -> 文件和搜索* 中好像也能完成, 但我没有测试:

取消 *启用索引* 的勾, 点击 *应用*, 这是会弹出一个警告框, 我们选择 *删除索引数据*, 再勾选 *启用索引*, 这时它应该就开始建立索引数据了, 在这里能看到进度 (包括上面由命令发起的索引)


## 疑问
这里最后一条指令打完后, 终端在输出一行 ```Started search for unindexed files``` 后就把控制台释放给了我们, 但我并不知道这个时候关闭终端窗口会不会中断索引, 因为一直有日志在输出
