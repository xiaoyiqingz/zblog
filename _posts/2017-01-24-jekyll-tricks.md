---
layout: post
title: "jekyll的一些技巧"
date: 2017-01-24
categories: jekyll
excerpt: '' 
---

#### Liquid模版与sass
jekyll中使用了Liquid模版,构建页面,css使用了sass扩展,YAML作为配置文件 

#### Page 与 Post
可以认为所有不在`_posts`中的页面都是page而不是post,所以在index.html中展示所有文件列表的时候是对post循环获取所有文章,而在header中展示about,category等标签栏使用的是page循环获取

#### 配置信息
* jekyll使用yaml作为配置文件(有些使用json做配置文件)，`_config.yml`
* 所有`site.*`的属性都是对应`_config.yml`中的属性
* 可以在`_config.yml`中配置exclude属性来忽略不需要生成站点的文件

#### Data
Data 相当于动态页面中的数据库，Jekyll无法读取数据库中内容，所以提供了读取静态数据的方式Data File, Jekyll Data支持 yaml, json, CSV 三种格式，放在`_data`目录下, 可以通过 site.data 直接访问。

例如：

团队成员有 Fa, Li, Zhang 三人，于是我们在默认路径 `_data` 创建一个数据文件 member.yml：

```
- name: Fa
- name: Li
- name: Zhang
```
在页面中显示队成员列表：

```
{%raw%}
{% for member in site.data.member %}
    <ul>
      <li>{{ member.name }}</li>
    </ul>
{% endfor %}
{%endraw%}
```
