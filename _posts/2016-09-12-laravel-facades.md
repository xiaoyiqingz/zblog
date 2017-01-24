---
layout: post
title: "laravel facades"
date: 2016-09-12
categories: laravel
excerpt: laravel的facades原理
---
# laravel Facades 是如何实现的

* laravel 并不是实现了每一个对应的静态方法。

* 所有的facade(Log,Cache等)都继成自Facade基类(Illuminate/Support/Facades/Facade.php)


* 所有的facade都只需要实现(基类的抽象方法getFacadeAccessor)返回一个字符串用于标示此类的service即可

{% highlight ruby linenos %}
Class Cache extends Facade
{
    protected static getFacadeAccessor()
    {
        // 在$app这个应用的实例(也是container)中，有$app['cache'] = a instance of Cache
        return 'cache';
    }
}
{% endhighlight %}


* laraval的app容器会根据键值对的方式，在初始化的时候保存每一个service,其中键与getFacadeAccessor返回的字符串相同，而值就是此sevice的一个实例,而facade基类保存了此app container

{% highlight ruby linenos %}
abstract Class Facade
{
    protected static $app; //保存应用实例,作为container包含每一个service对应的实例
{% endhighlight %}


* 在调用如Log::info(), 等方法的时候,如果不存在此静态方法，则会调用__callStatic魔术方法, 基类则在此函数中，先调用子类的getFacadeAccessor，从容器中拿到此facade对应的实例，然后$instance->method(argv)的方式，调用对应方法即可

{% highlight ruby %}
public static function __callStatic($method, $args)
{
    ...
    $statnce = $app[static::getFacadeAccessor()];
    ...

    switch (count($args)) {
        case 0:
            return $instance->$method();
        case 1:
            return $instance->$method($args[0]);
        case 2:
            return $instance->$method($args[0], $args[1]);
        case 3:
            return $instance->$method($args[0], $args[1], $args[2]);
        default:
            return call_user_func_array([$instance, $method], $args);
    }
}
{% endhighlight %}

