---
layout: post
title: "mac starup items"
date: 2017-04-12
categories: mac
excerpt: set mac app startup
---

mac 三种设置自启动的方式，只了解了两种

### 一.System Preferences
系统偏好设置->用户与群组->登录项中添加
> 注意: 此中自启动需要使用添加的默认打开方式，在添加shell脚本时，脚本显示简介中默认打开方式是xcode，且无法改成terminal，所以使用了第二种方式

### 二.Launchd
macOS开机启动一般使用launchctl加载plist文件, 所以写好shell脚本，将脚本的路径写在plist中即可
plist文件放置处：
```
~/Library/LaunchAgents 由用户自己定义的任务项
/Library/LaunchAgents 由管理员为用户定义的任务项
/Library/LaunchDaemons 由管理员定义的守护进程任务项
/System/Library/LaunchAgents 由苹果官方为用户定义的任务项
/System/Library/LaunchDaemons 由苹果官方定义的守护进程任务项
```

/System/Library和/Library和~/Library目录的区别？
```
/System/Library目录是存放Apple自己开发的软件。
/Library目录是系统管理员存放的第三方软件。
~/Library/是用户自己存放的第三方软件。
```

LaunchDaemons和LaunchAgents的区别？
```
LaunchDaemons是用户未登陆前就启动的服务（守护进程）, 不是启动带有GUI的程序。
LaunchAgents是用户登陆后启动的服务（守护进程）,可以启动带GUI的程序。
```

一般自己用的就直接放在~/Library/LaunchAgents即可，因为放在这里的plist不需要修改文件所属组，权限是644即可
而其他目录中的plist一般 用户组应该是root:wheel 权限是644

plist 写法
{% highlight ruby linenos %}
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC -//Apple Computer//DTD PLIST 1.0//EN
http://www.apple.com/DTDs/PropertyList-1.0.dtd >
<plist version="1.0">
<dict>
    <key>Label</key>
        <string>com.example.exampled(plist名称,不需要后缀)</string>
    <key>ProgramArguments</key>
        <array>
            <string>exampled(脚本全路径或者直接命令)</string>
        </array>
    <key>KeepAlive</key>
        <true/>
    <key>RunAtLoad</key>
        <true/>
</dict>
</plist>
{% endhighlight %}

检查plist 写法是否正确
```
plutil ~/Library/LaunchAgents/example.plist
```

载入配置
```
launchctl load ~/Library/LaunchAgents/example.plist
```

卸载配置
```
launchctl unload ~/Library/LaunchAgents/example.plist
```

查看是否运行
```
launchctl list
```

### 三.StartupItems


--------------
参考文章:
* [LaunchDaemons vs LaunchAgents](http://www.grivet-tools.com/blog/2014/launchdaemons-vs-launchagents/)
* [Mac设置开机启动](http://www.jianshu.com/p/49dabd8ec9bb)
