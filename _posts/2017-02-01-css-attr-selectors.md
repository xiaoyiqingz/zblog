---
layout: post
title: "css attr selectors"
date: 2017-02-01
categories: css
---

#### css选择器

每个css属性都是由选择器与和声明块组成  
`h1 {color: red; background: yellow;}`  
中括号前面的为选择器，中括号里面的是由声明块组成，声明块则由键值对组成一个个属性声明

##### 1.元素选择器

##### 2.通配选择器

##### 3.类选择器
写法:
* \*.waring {color: red;}  //所有的warning类, 也可以省略通配符\*,写作.warning {color: red;}
* p.waring {color: red;}  // p标签中的warning类
* .waring.info {color: red;} // 同时包含warning和info类的标签

```
 <p class="warning"> 第一段</p>
```

##### 4.ID选择器
写法:
* \*#first-para {color: red;} // 所有ID为first-para的标签, 也可以省略通配符\*

```
 <p id="first-para"> 第一段</p>
```

> 类选择器还是ID选择器?
> 一个类可以在一个html文档中引用多次，但是一个ID只能在一个文档中引用一次。虽然html并不对ID的出现个数做检查
> ID选择器不支持像类选择第三种方式那样结合使用
> 类选择器和 ID选择器可能是区分大小写的，这取决与文档语言,HTML与XHTNL是区分大小写的



##### 5.属性选择器(CSS2)

##### 6.后代选择器
* h1 em {color: red;} // h1中斜体为红色

区分后代选择器与元素选择器分组的区别：
```
  h1 , em {color: red;}  // 所有h1与em中颜色都为红色
```

后代选择器并不区分子元素是父元素之间是几代关系，如果想明确是父元素下一代的子元素，使用h1 > em

```
table.summary td > p {color: red;}  // 含有summary类的table元素中td 且子元素为p的元素颜色为红色 
```

##### 7.兄弟元素选择器
* h1 + p {color: red;}   // 与h1为兄弟的p元素的颜色为红色

##### 8.伪类选择器
