---
layout: post
title: "linux serve note"
date: 2017-04-01
categories: linux
excerpt: linux serve 初使用笔记
---

## linux serve端使用学习

#### 一、用户管理
 使用root创建新用户:`useradd`
    实际是在/etc/passwd 文件中新添加了一个用户(了解每一个字段意义)
    `useradd 选项 用户名`
    **-D** 指定用户主目录位置
    **-m** 默认生成用户主目录(一般在/home下)
    **-s** 指定shell(/bin/bash, 出现过问题 未指定时以该用户登录无法使用linux命令)
    -c comment 指定一段注释性描述
    -g 用户组 指定用户所属的用户组。
    -G 用户组，用户组 指定用户所属的附加组。
    
> /etc 存放系统配置文件的位置 

#### 二、为新用户添加密码
 在root下使用`passwd 用户名`即可

#### 三、删除用户
 `userdel 用户名`

#### 四、为用户添加sudo权限
 实际是在/etc/sudoers中增加，使用命令`visudo`, 在root下paste一行修改用户名为当前用户名
 也可以将此用户加到sudo组中

#### 五、修改hostname
 新的主机实例的主机名是随机名称，/etc/hostname中修改主机hostname

#### 修改ubuntu默认编辑器
 ubuntu默认编辑器是nano，修改方法：
 1. 使用系统管理工具update-alternatives: `update-alternatives --config editor` 选择vim.basic
 2. 在.bashrc中添加`export EDITOR=/usr/bin/vim`
