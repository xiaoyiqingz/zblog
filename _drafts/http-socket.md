---
layout: post
title: "Http-socket"
date:
categories: http socket
---

#### URI URL URN
URI: (Uniform Resource Identifier) 统一资源标识，用来定位网络上资源位置，可以使用 location, or a name, or both的方式，所以URL与URN只是URI的一种实现方式。
URL: (Uniform Resource Locator) 统一资源定位,是目前常见的URI实现方式，表示的是实际的地址，而不是准确的名字。这就意味着 URL 会告诉你资源此时处于什么位置。它会为你提供特定端口上特定服务器的名字，告诉你在何处可以找到这个资源。这种方案的缺点在于如果资源被移走了， URL 也就不再有效了。那时，它就无法对对象进行定位了
URN: (Uniform Resource Name) 统一资源名,有了对象的准确名称，则不论其位于何处都可以找到这个对象
> 永久统一资源定位符（persistent uniform resource locators，PURL）是用 URL 来实现 URN 功能的一个例子。其基本思想是在搜索资源的过程中引入另一个中间层，通过一个中间资源定位符（resource locator）服务器对资源的实际 URL 进行登记和跟踪。客户端可以向定位符请求一个永久 URL，定位符可以以一个资源作为响应，将客户端重定向到资源当前实际的 URL 上去

#### Http事务的时延
 与建立tcp链接，以及传输请求和响应报文的时间相比，事务处理时间可能很短。除非客户端或者服务器超载，或正在处理复杂的动态资源，否则http的时延主要是由tcp网络时延引起。

 HTTP时延几种原因:
 * 客户端首先根据url分析出ip与端口，如果用户最近没有访问过该主机，那么DNS解析可能花数十秒。
 * 新的TCP请求连接建立时的时延，单个只需要一两秒，如果这个请求比较多，时间可能会比较长
 * 网络上请求报文以及处理报文的时间
 * web会送http请求的时间
