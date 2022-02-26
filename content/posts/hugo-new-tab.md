---
title: "让 Hugo 在新标签页打开外链"
date: 2022-02-27T01:18:53+08:00
draft: false
categories: ["博客"]
tags: ["博客", "Hugo"]
---

## 前面废话
Hugo 默认会把内部链接和外部链接都在当前标签页打开, 感觉很乱的说(

于是我在 [Bing 上](https://www.bing.com/search?q=hugo+new+tab) 得到了这个解决方案 (我也不知道哪个是原创, 抱歉

万能的 Bing 总能解决我的问题, ~~软粉值 +1~~


## 解决方法
在你的博客目录下找到以下文件, 如果没有就一层层的新建 ~~(废话)~~: ```layouts/_default/_markup/render-link.html```

在里面写下这些内容:
```html
<a href="{{ .Destination | safeURL }}"{{ with .Title}} title="{{ . }}"{{ end }}{{ if strings.HasPrefix .Destination "http" }} target="_blank"{{ end }}>{{ .Text }}</a>
```
我也看不太懂的说, 但大概意思应该就是: 如果链接开头包含 http 这个字段, 就插入 ```target="_blank"```, 这段插入的代码应该是让链接在新标签页中打开的 (如果有错误请指出喵((

之后写博客时, 外链就能在新标签页打开了, 而内链 (类似 ```/posts/hello-world``` 这样的) 不会受到影响

又水了一篇博客, 逃(
