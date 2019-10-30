---
layout: post
title: "laravel cache"
date: 2019-10-30
categories: laravel
excerpt: laravel cache tag解析 
---

# laravel cache tag 在redis是怎样存储的
laravel 一个cache tag 在redis中一共存了`tag数量*2 + 1`个数据，分别是

1. 记录tag的记录(类型string)    
    对于每一个tag，都会先生成一个key，来记录这个tag，如`laravel:tag:tag1:key`,`laravel:tag:tag2:key`,其中tag1，tag2是实际的tag，其他为默认值，这条数据的value是一个随机字符串(通过`str_replace('.', '', uniqid('', true))`生成,如:5db980ca23b5a591932424)，这个值用会在下一条记录来记录这个tag中有多少数据

2. 记录tag里的所有数据(类型set)    
   对于1中的每一个记录，都会以其value(如：5db980ca23b5a591932424)，拼成一个新key`laravel:5db980ca23b5a591932424:standard_ref`,这个key里记录了对应tag名下所有的数据的key(如laravel:sha1([tag1的随机value]|[tag2的随机value):key)值

3. 记录实际数据(类型string)    
   对于2中的某一条数据，以`laravel:sha1([tag1的随机value]|[tag2的随机value):key` 为key,实际存储的值为值

### 示例:
```
Cache::tag(['tag1', 'tag2'])->put('key1', 'va1')
Cache::tag(['tag1'])->put('key2', 'va2')

1.
laravel:tag:tag1:key -> '5db986d1206e4892217737'
laravel:tag:tag2:key -> '5db986d1206e4892217738'
注:5db986d1206e4892217737与5db986d1206e4892217738都通过str_replace('.', '', uniqid('', true)) 生成

2.
laravel:5db986d1206e4892217737:standard_ref -> [laravel:3760cfdb62429b079a070b393a8d1578a6444da0:key1, laravel:4560rfdb6c429b0f9a070b393a8d1578a6444da0:key2]
表示tag1下存了两条数据key1,key2
laravel:5db986d1206e4892217738:standard_ref -> [laravel:3760cfdb62429b079a070b393a8d1578a6444da0:key1]
表示tag2下存了一条数据key1
注: 3760cfdb62429b079a070b393a8d1578a6444da0是通过sha1('5db986d1206e4892217737|5db986d1206e4892217738') 生成, 4560rfdb6c429b0f9a070b393a8d1578a6444da0通过sha1('5db986d1206e4892217737')生成

3.
laravel:3760cfdb62429b079a070b393a8d1578a6444da0:key1 -> val1
laravel:4560rfdb6c429b0f9a070b393a8d1578a6444da0:key2 -> val2

```
                                                                                                                                                    
