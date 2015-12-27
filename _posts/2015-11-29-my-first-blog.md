---
layout: post
title: "19 插入数据（INSERT）"
date: 2015-11-29
categories: database DML
excerpt: 插入数据
---
# 插入数据

#### 插入的几种方式
* 插入完整的行
* 插入行的一部分
* 插入多行
* 插入某些查询的结果

#### 插入一行
{% highlight ruby %}
1. INSERT INTO Table  VALUE(val1, val2); //不建议  缺点 不安全， 依靠列在表中的顺序， 如果 表的列顺序发生变化 很有可能出问题
2. INSERT INTO Table(col1, clo2) VALUE(val1,val2)  //建议这样写 Table后给出列名，这样比较安全，省略col可以只插入一部分
{% endhighlight %}

#### 插入多行
{% highlight ruby %}
INSERT INTO Table(col1, col2) VALUE(val1, val2),VALUE(val1, val2);
{% endhighlight %}

#### INSERT 还能将 SELECT语句的结果插入  （所谓的 INSERT SELECT）
{% highlight ruby %}
INSERT INTO Table1(col1, col2) SELECT col1, col2 FROM Table2;
{% endhighlight %}
