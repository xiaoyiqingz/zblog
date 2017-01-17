---
layout: post
title: "jekyll 模版引擎解析"
date: 2017-01-16
categories: jekyll templateclass
---

#### 相关目录

1. _includes/: web页头与页脚html文件,全局可用的模版
2. _layouts/: posts about.md 等具体内容展示页所使用的模版
3. css/  导入了_sass的css文件
4. _sass/ css文件
5. _site/ 最后web生成目标

#### 具体解析

#### 1._includes/目录
此目录主要存放一些展示性的界面，与业务数据(内容)是分离的，当前包含
* 头部web名称:zhang's blog 与About页的链接
* 页脚zhang's blog与邮箱，github等介绍信息
* 以后做日历，tags可能会在_includes/新建一个.html(待学习)

所以我们可以通过修改_includes/中的文件修改web页头与页脚的内容

#### 2._layouts/目录
内容的模版现在主要包含的layout，page，post模版  

1. layout
* default模版是post,page的父模版,也是index.html的模版，default中include了head.html 与footer.html 所以所有以default为模版或父模版的都包含了head与footer
* default模版中 `content` 就是引用了default模版的模版或数据的内容，即所有引用default的文件最终都替换了content
* index.html 以defualt 为模版，而其他页面(about post)基本上都是以post或page为模版

2. post,page
* post与page模版平级，目前只有about.html使用了page模板，_posts/里的文章数据全都是以post为模版
* yaml头中layout就是指当前文件的模板,指定好模板后，就是用当前文件中非yaml头的内容去替换模版中的`content`

所以整个一个完整post文件结构是这样的
```
    default模版
        default中的html 内容
        {content: post 模版
            post中的html 内容
            {content:
                文章数据
            }
            post中的html 内容
        }
        default中的html 内容
```

因此: 我们可以通过修改post或者添加新的模版来修改内容页面的界面，也可以通过修改default来修改整个web中框架界面

#### 3.css/目录
存放main.scss目录，main.scss导入中了_sass/中的css文件
(待了解)

#### 4._sass/
存放css文件
(待了解)

#### 5._site/
最终web解释后的文件存放的目录

