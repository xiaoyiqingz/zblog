---
layout: post
title: "laravel model mutator"
date: 2016-09-14
categories: laravel
excerpt: laravel的model中新增自定义属性，或者对字段强制转换
---

# laravel的mutator实现

#### 什么是mutator?
在model中，新建一个函数名称为getXXXAttribute()方法，即可在model实例中像使用数据库中存在的字段使用。  
如: 数据库中存在first_name. last_name, 那么可以

    public function getAllNameAttribute($value)
    {
        return $this->first_name . $this->last_name;
    }

$model->all_name,即可获取此值。
对于存在的字段也可以定义此函数，

    public function getFirstNameAttribute($value)
    {
        return 'hello' . $this->value;
    }

那么以后使用$model->first_name,时都会在前面加上hello

(开始觉着这种用法挺好，但是后来想一想用一个普通方法getName()，$model->getName()也可以实现想要的功能)

#### 实现过程

在Model.php(Illuminate/Databate/Eloquent/Model.php)中的__get()魔术方法中,此魔术方法只有在调用私有或者不存在的成员变量时才会被调用,

    public function __get($key) {
        return $this->getAttribute($key);
    }

所以说,对于自定义的字段一定是在这里处理的，


    public function getAttribute($key)
    {
        if (array_key_exists($key, $this->attributes) || $this->hasGetMutator($key)) {
            return $this->getAttributeValue($key);
        }

        return $this->getRelationValue($key);
    }

在这里先判断了$key是不是本来就存在或者说我们自定义过

    public function hasGetMutator($key)
    {
        return method_exists($this, 'get'.Str::studly($key).'Attribute');
    }

这里其实就可以看到判断我们是不是定义过就是判断getXXXAttribute函数是否存在,并且通过Str::studly()将蛇形命名转换成了大驼峰命名

    public function getAttributeValue($key)
    {
        $value = $this->getAttributeFromArray($key);

        // If the attribute has a get mutator, we will call that then return what
        // it returns as the value, which is useful for transforming values on
        // retrieval from the model to a form that is more useful for usage.
        if ($this->hasGetMutator($key)) {
            return $this->mutateAttribute($key, $value);
        }

        // If the attribute exists within the cast array, we will convert it to
        // an appropriate native PHP type dependant upon the associated value
        // given with the key in the pair. Dayle made this comment line up.
        if ($this->hasCast($key)) {
            $value = $this->castAttribute($key, $value);
        }

        // If the attribute is listed as a date, we will convert it to a DateTime
        // instance on retrieval, which makes it quite convenient to work with
        // date fields without having to create a mutator for each property.
        elseif (in_array($key, $this->getDates())) {
            if (! is_null($value)) {
                return $this->asDateTime($value);
            }
        }

        return $value;
    }

然后这里就是真正的取值了:
1. 首先从$this->attributes数组中取值,即数据库中存在此字段的都会存在这个数组中,
2. 然后从我们自建的函数中取值，
3. 检查此字段我们是否定义过类型转换(在官方文档mutator篇章下面有讲如何将model字段做类型转换)

> 因为我们看到这三个过程是顺序执行的，也就是说即使本来model中存在此字段了，但是如果我们又做了自定义，或做了类型转换，此字段也会被我们自定义或做类型转换

#### Str helper 中大驼峰与蛇形命名之间的相互转换

    * 将蛇形命名法转大驼峰命名
    str_replace(' ', '', ucwords(str_replace(['-', '_'], ' ', $val)));


    * 将驼峰命名转蛇形命名
    function snake($val, $delimiter = '_')
    {
        if (! ctype_lower($val)) {
            $val = preg_replace('/\s+/', '', $val);

            $val = strtolower(preg_replace('/(.)(?=[A-Z])/', '$1'.$delimiter, $val));
        }

        return $val;
    }


对于/(.)(?=[A-Z])/ 用到两个正则知识 1.分组，2.断言

对于(.) 这事一个分组， 整个表达式为$0 第0组，所以第一个位置出现的分组即为第一组$1
断言有四种方式：前两种  
* 当任意一个字符后面跟大写字母才匹配 则 .(?=[A-Z]),   任意多个字符后面跟大写字母才匹配 .*(?=[A-Z])  
* 当任意一个字符前面跟大写字母才匹配 则 (?<=[A-Z]).  
* 把 ＝ 换为 ! 表示 后面(前面)跟着不是大写字母才匹配 .(?![A-Z])

整个表达式意思是将后面跟着大写字母的前一个字母 替换成 字母_

