---
layout: post
title: "redis"
date:
categories:
---

#### redis 使用场景
1. 缓存
2. 队列
3. 排行榜


#### list 使用场景
1. 消息传递、任务队列
2. 存储任务信息
3. 最近浏览过文章
4. 常用联系人信息

#### pub / sub 模式
subscribe channel [channel ...]

publish channel message


#### redis 事务
1. multi exec
2. watch unwatch

#### 内存查询

redis-cli --bigkeys 返回每种数据类型top 1 big key
* 建议在从节点执行，因为--bigkeys也是通过scan完成的。
* 如果没有从节点，可以使用--i参数，例如(--i 0.1 代表100毫秒执行一次)
* 建议在节点本机执行，这样可以减少网络开销
* --bigkeys只能计算每种数据结构的top1，如果有些数据结构非常多的bigkey 使用 scan + debug object [key]

memory usage [key]  获取key占用内存，bytes  (/1024/1024)MB

info memory 查看总内存占用
