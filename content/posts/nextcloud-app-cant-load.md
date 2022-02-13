---
title: "解决 Arch Linux 下 Nextcloud 应用无法从其他路径加载的问题"
date: 2022-01-29T06:33:09+08:00
draft: false
categories: ["Linux"]
tags: ["Linux", "服务器", "Arch Linux", "Nextcloud"]
---

## 起因
由于主硬盘空间不够, 我将服务器上的 Nextcloud 数据文件夹放在了外置硬盘, 在经过官网的教程配置后, 文件存储功能正常, 但从商店安装的应用无法正常使用, 表现为白屏, 不可操作, 不显示图标


## 摸索过程
以下是我的 config.php 的一部分:
```php
<?php
$CONFIG = array (
  'datadirectory' => '/mnt/DATA/nextcloud/data',
  'apps_paths' =>
  array (
    0 =>
    array (
      'path' => '/usr/share/webapps/nextcloud/apps',
      'url' => '/apps',
      'writable' => false,
    ),
    1 =>
    array (
      'path' => '/mnt/DATA/nextcloud/apps',
      'url' => '/wapps',
      'writable' => true,
    ),
  ),
);
```

可以看出我已经配置了自定义应用目录

首先排查网络, 手动下载安装 zip 格式的应用包, 问题依旧

按照群友所说的排查以下日志

/var/log/nextcloud/nextcloud.log 只有webdav的错误输出:
```
{"reqId":"d1ajoI8p31PhTdgATuFV","level":4,"time":"2022-01-16T13:59:57+00:00","remoteAddr":"192.168.1.11","user":"Fe3O4","app":"webdav","method":"POST","url":"/remote.php/dav/bulk","message":"Unknown error while seeking content","userAgent":"Mozilla/5.0 (Linux) mirall/3.4.1git (Nextcloud, artix-5.15.12-artix1-1 ClientArchitecture: x86_64 OsArchitecture: x86_64)","version":"23.0.0.10","exception":{"Exception":"Sabre\\DAV\\Exception","Message":"Unknown error while seeking content","Code":500,"Trace":[{"file":"/usr/share/webapps/nextcloud/apps/dav/lib/BulkUpload/MultipartRequestParser.php","line":129,"function":"isAt","class":"OCA\\DAV\\BulkUpload\\MultipartRequestParser","type":"->"},{"file":"/usr/share/webapps/nextcloud/apps/dav/lib/BulkUpload/BulkUploadPlugin.php","line":69,"function":"isAtLastBoundary","class":"OCA\\DAV\\BulkUpload\\MultipartRequestParser","type":"->"},{"file":"/usr/share/webapps/nextcloud/3rdparty/sabre/event/lib/WildcardEmitterTrait.php","line":89,"function":"httpPost","class":"OCA\\DAV\\BulkUpload\\BulkUploadPlugin","type":"->"},{"file":"/usr/share/webapps/nextcloud/3rdparty/sabre/dav/lib/DAV/Server.php","line":472,"function":"emit","class":"Sabre\\DAV\\Server","type":"->"},{"file":"/usr/share/webapps/nextcloud/3rdparty/sabre/dav/lib/DAV/Server.php","line":253,"function":"invokeMethod","class":"Sabre\\DAV\\Server","type":"->"},{"file":"/usr/share/webapps/nextcloud/3rdparty/sabre/dav/lib/DAV/Server.php","line":321,"function":"start","class":"Sabre\\DAV\\Server","type":"->"},{"file":"/usr/share/webapps/nextcloud/apps/dav/lib/Server.php","line":339,"function":"exec","class":"Sabre\\DAV\\Server","type":"->"},{"file":"/usr/share/webapps/nextcloud/apps/dav/appinfo/v2/remote.php","line":35,"function":"exec","class":"OCA\\DAV\\Server","type":"->"},{"file":"/usr/share/webapps/nextcloud/remote.php","line":166,"args":["/usr/share/webapps/nextcloud/apps/dav/appinfo/v2/remote.php"],"function":"require_once"}],"File":"/usr/share/webapps/nextcloud/apps/dav/lib/BulkUpload/MultipartRequestParser.php","Line":111,"CustomMessage":"--"}
```

/var/log/httpd/error_log (php-fpm) 没有任何异常

/var/log/httpd/nextcloud.feo.info-error_log (虚拟主机错误日志):
```log
[Tue Jan 18 08:46:32.514615 2022] [proxy_fcgi:error] [pid 858:tid 140214391510592] (70008)Partial results are valid but processing is incomplete: [client 192.168.1.11:49582] AH01075: Error dispatching request to : (reading input brigade)
```
好像有错误但无法定位

/var/log/httpd/nextcloud.feo.info-access_log (虚拟主机访问记录):
```log
192.168.1.11 - - [22/Jan/2022:19:35:39 +0800] "GET /wapps/spreed/img/app.svg?v=513c0a09 HTTP/1.1" 302 -
```
找到你了, 302 (Moved Temporarily) 错误

查看 nextcloud 安装目录, 输出如下:
```shell
[fe3o4@Fe3O4-Server ~]$ ls -al  /usr/share/webapps/nextcloud
drwxr-xr-x 48 nextcloud nextcloud  4096 Aug 11 18:44 apps
lrwxrwxrwx  1 root      root         23 Jan 22 20:57 wapps -> /var/lib/nextcloud/apps
```
可以看到, 刚才 nextcloud 尝试访问的 wapps 实际上是一个软链接, 问题也就出在这里

/var/lib/nextcloud/apps 是 archlinux 源 中 nextcloud 的默认应用路径, 但应用路径实际上已经被我们移走, 而这个软链接由 pacman 管理, 并不会跟随 nextcloud 设置


## 解决方法
删除/var/lib/nextcloud/apps 并 创建同名软链接到我们的应用目录即可:
```shell
# rm -r /var/lib/nextcloud/apps
# ln -s /mnt/DATA/nextcloud/data(替换为你的真实应用目录) /var/lib/nextcloud/apps
```
P.S.不要直接操作 /usr/share/webapps/nextcloud 下的 wapps, ~~因为每次更新后它都会被覆盖~~ (未验证)
