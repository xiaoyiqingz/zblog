---
layout: post
title: "nginx start and stop"
date: 2017-04-12
categories: nginx
excerpt: nginx start reload and stop
---

#### nginx 查看配置信息
* -v 查看nginx版本   
* -V 版本以及编译选项

#### nginx 启动停止操作
nginx执行文件一般安装在/usr/bin/nginx (root 安装则在/usr/sbin/nginx中) 所以执行相关命令都是`/usr/sbin/nginx -s` 命令, nginx安装的时候应该是加入到PATH中了，所以可以直接使用`nginx -s`
1. start (-c 加载配置文件)
    nginx -c /etc/nginx/nginx.conf -g "pid /var/run/nginx.pid; worker_processes 2;"
2. stop
    nginx -s stop  nginx -s quit  kill -QUIT pid
3. reload(首先-t测试配置文件是否修改正确)
     nginx -t  nginx -s reload

#### nginx的默认页面
nginx 在配置文件中(/etc/nginx/nginx.conf)中有`include /etc/nginx/sites-enabled/*;`配置了默认页面, 所以注释掉这行,然后自己添加serve信息来配置自己的site

#### nginx对serve中的root指定的目录至少要有读权限
nginx.conf 中第一行 `user www www;` 指定了nginx的启动用户与组。

自己在配置文件中一个serve后，root指定的目录以及其父目录一定要是nginx的组有可读(甚至写)权限, 如在root用户下建的路径，由于/root `drwx------`, 所以一般nginx用户没有读此目录下权限，所以log中会报nginx log stat() failed, permission denied的错误,而在其他非root用户的目录一般是`drwxr-xr-x`,所以nginx用户可以直接读取

如果此路径不能被other用户读，也可以将此目录的user加入到nginx的用户组中(gpasswd -a www username)，这样nginx就有此目录的组访问权限，或者直接将此目录的所属组改为nginx用户组

#### nginx 支持php
nginx本身不能处理PHP，它只是个web服务器，当接收到请求后，如果是php请求，则发给php解释器处理，并把结果返回给客户端。nginx一般是把请求发fastcgi管理进程处理，fascgi管理进程选择cgi子进程处理结果并返回被nginx。也就是说，nginx将处理请求交给php5-fpm，再接收处理返回结果。  php解析服务，如php-fpm，或spawn-fcgi）
1. 安装安装 php5-fpm
2. 在serve 中增加配置

{% highlight ruby linenos %}
location ~ \.php$ {
    fastcgi_split_path_info ^(.+\.php)(/.+)$;
    fastcgi_pass   unix:/var/run/php/php7.0-fpm.sock;
    fastcgi_index  index.php;
    fastcgi_param  SCRIPT_FILENAME $document_root/$fastcgi_script_name;    //缺少此行后虽然不报错，但是返回空白页面
    include        fastcgi_params;
}
{% endhighlight %}
