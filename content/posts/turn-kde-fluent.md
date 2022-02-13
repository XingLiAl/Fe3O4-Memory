---
title: "把 KDE 打造成 Fluent 风格"
date: 2022-01-29T19:57:29+08:00
draft: false
categories: ["Linux"]
tags: ["Linux", "美化", "KDE", "Fluent Design"]
---

## 千言万语
最近有些看腻了 KDE 默认的 Breeze 主题, 打算换一个, 但我还是喜欢简洁风格的

在 KDE 商店挑来挑去后, 我最终选择了 Fluent Round Light 这款主题

它是一个全局主题, 包含了 Plasma Shell 外观, 窗口装饰以及图标等等. 你可以在 Discover 中 选择左侧的 *Plasma 加载项 -> 全局主题*, 再在搜索框中搜索来找到并下载它. 如果你没有 Discover, 你也可以在 KDE 设置中选择 *外观*, 在 首先出现的 *全局主题* 页面的右下角选择 *安装新主题* 来下载它

另外, 同一个作者还创作了 GTK 和 SDDM 的主题, 它们是不包含在全局主题里面的, 如果你想让 GTK 程序 和 SDDM 看起来风格更加一致, 你可以在 Discover 或 KDE 设置中安装它们, 方法和上面一样, 只不过位置稍有不同

GTK 主题在 Discover 的 *应用程序加载项* 里面, 在 KDE 设置中的 *外观 -> 应用程序样式 ->* 右下角的 *管理 GTK 应用程序样式*

SDDM 主题仍在 Discover 的 *Plasma 加载项* 里面, 但在 KDE 设置中的 *启动和关机*

如果你没有在 KDE 设置中找到 *管理 GTK 应用程序样式*, 那么你可能需要根据  [Arch Wiki 上的这篇文章](https://wiki.archlinux.org/title/Uniform_look_for_Qt_and_GTK_applications_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)) 进行调整了 (需要安装一些软件包来让 KDE 能接管 GTK 程序的一些活动)

你还可以安装同一个作者写的 Splash Screen (不会翻译), 这样在登录时就能看到田牌图标 (雾)


## 效果图
前面说了这么多, 现在直接看看实际的效果吧

桌面和启动器 (壁纸也是主题里面的):
![桌面和启动器](desktop.png)

~~资源管理器~~ Dolphin:
![Dolphin](dolphin.png)

Konsole 及 neofetch:
![Konsole 及 neofetch](konsole.png)
neofetch 的显示似乎有点小问题的样子

计算器 (KCalc):
![计算器(KCalc)](kcalc.png)
~~好像~~ 没什么变化额
