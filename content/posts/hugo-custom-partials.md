---
title: "给 Hugo 博客添加自定义页眉/页脚"
date: 2022-02-01T17:35:20+08:00
draft: false
categories: ["博客"]
tags: ["博客", "Hugo", "Papermod"]
---

## 一些废话
最近想给博客添加统计代码, 但我使用的 Papermod 主题并没有除 Google Analysis 外的统计功能的模板, 所以我就尝试在 [官方文档的模板介绍页面](https://gohugo.io/templates/introduction/) 中寻找解决方案

首先我看到了 [这个](https://gohugo.io/templates/introduction/#template)
> The template function was used to include partial templates in much older Hugo versions. **Now it’s useful only for calling internal templates.** The syntax is {{ template "_internal/\<TEMPLATE>.\<EXTENSION>" . }}.

以及 [这个](https://gohugo.io/templates/alternatives/)
> **DEPRECATED** - Alternative Templating Languages
>
> **DEPRECATED** - Support for Ace & Amber templating has been **removed** in version 0.62
Support for Amber and Ace templates has been **removed** since Hugo 0.62 per issue #6609.

意思是大概就是说, 自定义模板功能在某个版本被移除了

瞬间感觉没有希望了.png

但我又想, 以我的能力水平, 并不能编写一个 "二次生成器", 或者叫 "修饰器"(?) 来对整个博客的页面加上一段东西 (没错, 能力限制了我的想象, 我菜)

然后我就继续在刚才的那个页面上找, 结果, 我发现了 partials (中文应该是叫 "部分" 吧(说话能力严重退化的我...))


## 使用 Partials
按照 [官方文档对 Partials 的介绍](https://gohugo.io/templates/introduction/#partial):
> The partial function is used to **include partial templates** using the syntax {{ partial "\<PATH>/\<PARTIAL>.\<EXTENSION>" . }}.

简单来说, partials 是一种 碎片化的 (废话), 可被引用的 (还是废话) 的 "模板", 而且这种 "模板" 没有被弃用, 也就是说, 我们还是可以对它进行自定义的 (希望又回来了有木有)

要使用 partials, 你需要先找到你的博客源码目录中的 layouts 文件夹中的 partials 文件夹 (没有的话要新建  (注意大小写哦)), 然后你就可以在里面编写你自己的 "碎片模板了"

例如, 我可以在里面创建一个 51la文件夹 (对的, 子目录也支持), 然后往里面放入一个 stats.html, 里面的内容就是你想要加入的内容, 可以是脚本, 标题, 文字等, 但要注意的是这是整个 html 页面的一个碎片, 所以不能加入 \<html>, \<head>, \<body> 这些

创建完碎片后, 怎么引用呢? 举我现在用的 Papermod 主题为例 (其他主题我还未验证), 我们可以在刚才的 partials 文件夹下创建 extend_head.html 和 extend_footer.html, 这两个文件分别对应页眉和页脚 (应该...是这么叫的吧怎么感觉一股 word 风 (明明就是)), 里面的内容格式和刚才的其它碎片一样. 如果想要引用其他碎片, 可以使用:

`{{ partial "碎片相对路径" . }}`

例如: 我想要在页眉添加刚才的 "51la 统计" 碎片, 就可以在 extend_head.html 中写入以下内容:
```html
{{ if hugo.IsProduction }}
    {{ partial "51la/stat.html" . }}
{{ end }}
```

这里的判断语句指的是只在生产环境 (也就是在 public 目录生成页面时) 才向页面中加入中间的代码, 变量和判断语句我有时间再讲 (咕咕咕), 你也可以直接查看 [官方文档](https://gohugo.io/templates/introduction/)

还要注意这里的点千万不要忘了, 不然的话不能正确加载, [官方文档](https://gohugo.io/templates/partials/#use-partials-in-your-templates) 中刻意强调了这一点:
> One of the most common mistakes with new Hugo users is failing to pass a context to the partial call. In the pattern above, note **how “the dot” (.) is required** as the second argument to give the partial context. You can read more about “the dot” in the Hugo templating introduction.

其实这里还有更高级的用法, 但是我也没玩懂, 所以就不写了 (逃, 如果感兴趣的话可以去阅读文档(小声)
