---
layout: post
title: "html css js"
date:
categories:
---

#### 一、CSS 设置背景图

{% highlight ruby %}
body {
    background-image: url('paper.gif'); //设置背景图片
    background-size: cover;  //只支持IE9+
    -webkit-background-size: cover; //webkit核心
    -moz-background-size: cover; //FF核心
    -o-background-size: cover; //Opera核心
}
{% endhighlight %}
