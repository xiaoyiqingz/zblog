---
layout: post
title: "php magic methods and constants"
date: 2016-09-22
categories: PHP
excerpt: PHP 中的魔术方法与魔术变量
---

#### 魔术方法(magic methods)
* __constract(), __destrcut(), __clone()
* __get(), __set()    -> 类的未定义的变量get与set
* __isset(), __unset()   -> isset,empty    unset
* __call(), __callStatic() -> 调用未定义的方法与静态方法时
* __toString()  -> echo
* __invoke -> 当把一个对象当作函数调用的时候 如 $a = new A;  $a('a');

#### 魔术常量(magic constants)
* \_\_LINE\__
* \_\_FILE\_\_
* \_\_DIR\_\_
* \_\_CLASS\_\_
* \_\_FUNCTION\_\_
* \_\_METHOD\_\_
* \_\_TRAIT\_\_
* \_\_NAMESPACE\_\_
