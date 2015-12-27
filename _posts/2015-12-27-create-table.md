---
layout: post
title: "21.创建和操纵表"
date: 2015-12-27
categories: db DDL
excerpt: 表的创建、更改、删除和重命名
---

###一、创建表(CREATE TABLE)
创建一个表时需要的信息：
* 新表的名字，在CREATE TABLE后给出
* 表列的名字和定义，用逗号分隔
例

{% highlight ruby %}
CREATE TABLE customers
(
    id      int         NOT NULL  AUTO_INCREMENT,
    name    char(50)    NOT NULL,
    address char(50)    NULL ,
    city    char(50)    NULL ,
    state   char(50)    NULL ,
    zip     char(50)    NULL ,
    country char(50)    NULL ,
    contact char(50)    NULL ,
    emial   char(255)   NULL ,
    PRIMARY KEY(id)
)ENGINE=InnoDB
{% endhighlight %}

`Tips:`sql创建新表时要求此表是不存在的，如果已存在此表，那么会返回错误
但是在表名后加上IF NOT EXISTS（CREATE TABLE IF NOT EXISTS customers）后，如果此表名存在，那么不会创建表，但是不会返回错误

`Tips:`与其他DBMS一样，MYSQL有一个具体管理和处理数据的内部引擎，它具体处理你的CREAT TABLE SELECT等命令，但是MYSQL有多种内部引擎，所以使用哪一个需要手动设置
    InnoDB：事务处理引擎，不支持全文本搜索
    MEMORY：在功能上等同于MyISAM,但数据存储在内存中，速度快(适合临时表)
    MyISAM：性能高，支持全文搜索，不支持事务处理
一个数据库中引擎可以混用，不同表使用不同引擎，但是问题，外键不能跨引擎(不同引擎的表不能引用不同引擎的表的外键)

多个列做主键 PRIMARY KEY(col1, col2)

每个表只允许有一个AUTO_INCREMENT列，且它必须被索引(如通过使它成为主键)
如何知道AUTO_INCREMENT后这个列的值，SELECT last_insert_id()返回最后一个AUTO_INCREMENT的值

对于not null的列， 设置默认值 id int NOT NULL DEFAULT 1


###二、更新表(ALTER TABLE)
更新一个表时需要给出的信息
* 在ALTER TABLE 之后给出需要更改的表名
* 所做更改的列表

例：
{% highlight ruby %}
ALTER TABLE customers
ADD age int;

ALTER TABLE customers
DROP COLUMN age;

ALTER TABLE 常见的用途就是定义外键
ALTER TABLE orderitems
ADD CONSTRAINT fk_orderitems_orders
FOREIGN KEY (order_num) REFERENCES products (prod_id)
{% endhighlight %}


### 三、删除表(DROP TABLE)
{% highlight ruby %}
DROP TABLE customers;
{% endhighlight %}

`Tips:`使用ALTER TABLE 和DROP TABLE时需要注意(甚至备份)，因为这些操作无法撤销

### 四、重命名表(RENAME)
{% highlight ruby %}
RENAME TABLE customer2 TO customers;
{% endhighlight %}

如果RENAME所做的只是重命名一个表，可以使用逗号隔开，一次重命名多张表
