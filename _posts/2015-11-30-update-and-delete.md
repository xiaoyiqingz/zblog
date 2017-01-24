---
layout: post
title: "20.更新和删除"
date: 2015-11-30
categories: database
excerpt: 更新和删除数据
---
# 更新和删除数据

### 一、更新数据(UPDATE)

* 更新表中所有的行
* 更新表中特定的行

UPDATE 语句由三部分组成
1.  要更新的表
2.  列名和它们的新值(SET)
3.  过滤条件(WHERE)

{% highlight ruby %}
UPDATE Table
SET col1 = val1,
    col2 = val2
WHERE col3 = val3;
{% endhighlight %}
当取消WHERE子句时，即对所有行进行更新

> IGNORE 关键字
> 默认更新一行或者是多行时，若是中间出现错误，所有的行会恢复到原来的值，但是如果加了IGNORE后即使发生错误也会继续更新
UPDATE IGNORE Table...

可以使用 SET col = NULL 来删除某列值

### 二、删除数据(DELETE)

* 删除所有的行
* 删除特定的行

{% highlight ruby %}
DELETE FROM Table
WHERE col1 = val1;
{% endhighlight %}

> DELETE 是删除表中的行而不是删除表的结构(DROP)

> 想要删除所有的行，TRUNCATE会更快些，TRUNCATE会删除整个表，然后再新建一个表

`Tips:` 在对UPDATE和DELETE使用WHERE子句前，可以先使用SELECT语句进行测试，保证选择的行是正确的

`Tips:` 区分DML与DDL， DML是对一个表中的行进行操作，如：插入行，更新行和删除行，而DDL则是数据库或数据表层的操作，如创建数据库或表(CREATE)，更新数据库或表(ALTER),删除数据库或表(DROP)
