---
layout: post
title: "Inversion Of Control"
date: 2016-09-13
categories: laravel IOC DI
excerpt: laravel控制反转与依赖注入
---

# laravel的控制反转与依赖注入

####  一、控制反转(Inversion Of Control)

在没有引入IOC之前，如果对象a依赖于对象b，那么a在初始化或者运行到某一时刻时会new b，即:
{% highlight ruby %}
class a
{
    protected $b;
    public function __construct()
    {
        $this->b = new b();
    }

or

class a
{
    public function somefunc()
    {
        $b = new b();
    }
{% endhighlight %}

无论创建还是使用，b的控制权都在a的手上，但是问题是a与b的耦合度太高了，如果(1)a此时不再使用b而是需要使用c，那么必须修改a内部的代码。(2)如果需要做很多事，那就需要new许多的其它对象，所以应该将a对b的控制权放松，(解决1)将依赖的类传入而不是在内部new，(解决2)让一个管家（容器）来统一管理所有其它的类，将控制权交给容器，自己提出需求，容器返回相应的工具实现并返回实现结果。

***在这个过程中，具体实现的控制权从我们的代码转移到了容器，所以称之为控制反转。***

> 解决方式:使用依赖注入，不是在a中new b 而是将b作为参数传入到a中，那么需要使用c代替b时，直接传c即可
{% highlight ruby %}
class a
{
    protected $component;
    public function __construct($component)  //组件
    {
        $this->component = $component;
    }

or

class a
{
    public function somefunc($component)
    {
        $component = $component;
    }
{% endhighlight %}

#### 二、依赖注入(dependency injection)
1. 依赖注入(dependency injection):不是在代码内部中创建依赖关系，而是让其作为一个参数传递过去，这样使程序更容易维护，降低代码耦合度。

> 控制反转 是面向对象编程中的一种设计原则，可以用来减低计算机代码之间的耦合度。其中最常见的方式叫做依赖注入（Dependency Injection, DI）, 还有一种叫"依赖查找"（Dependency Lookup）。通过控制反转，对象在被创建的时候，由一个调控系统内所有对象的外界实体，将其所依赖的对象的引用传递给它。也可以说，依赖被注入到对象中。

#### 三、为什么
* 为什么需要依赖注入  
  解耦a类与b类的耦合

* 依赖注入为什么需要容器  
  如果a类中只依赖一个组件component直接注入即可，但是如果a类依赖多个组件，那么在构造函数或者是写多个setter方法太麻烦了，直接将所有组件放在一个全局容器数组中，将此容器注入到a类中，a需要用什么直接从容器中获取即可　
  ***这里将依赖的类作为组件，将所有组件放在容器中***

#### 四、在网上例子
网上一篇文章，感觉讲的比较清楚:[原文](https://my.oschina.net/cxz001/blog/209888?p=1)

  假设，我们要开发一个组件命名为SomeComponent。这个组件中现在将要注入一个数据库连接。在这个例子中，数据库连接在component中被创建，这种方法是不切实际的，这样做的话，我们将不能改变数据库连接参数及数据库类型等一些参数。

{% highlight ruby %}
<?php

class SomeComponent
{

    /**
     * The instantiation of the connection is hardcoded inside
     * the component so is difficult to replace it externally
     * or change its behavior
     */
    public function someDbTask()
    {
        $connection = new Connection(array(
            "host" => "localhost",
            "username" => "root",
            "password" => "secret",
            "dbname" => "invo"
        ));

        // ...
    }

}

$some = new SomeComponent();
$some->someDbTask();
{% endhighlight %}

  为了解决上面所说的问题，我们需要在使用前创建一个外部连接，并注入到容器中。就目前而言，这看起来是一个很好的解决方案：

{% highlight ruby %}
<?php

class SomeComponent
{

    protected $_connection;

    /**
     * Sets the connection externally
     */
    public function setConnection($connection)
    {
        $this->_connection = $connection;
    }

    public function someDbTask()
    {
        $connection = $this->_connection;

        // ...
    }

}

$some = new SomeComponent();

//Create the connection
$connection = new Connection(array(
    "host" => "localhost",
    "username" => "root",
    "password" => "secret",
    "dbname" => "invo"
));

//Inject the connection in the component
$some->setConnection($connection);

$some->someDbTask();
{% endhighlight %}

现在我们来考虑一个问题，我们在应用程序中的不同地方使用此组件，将多次创建数据库连接。使用一种类似全局注册表的方式，从这获得一个数据库连接实例，而不是使用一次就创建一次。

{% highlight ruby %}
<?php

class Registry
{

    /**
     * Returns the connection
     */
    public static function getConnection()
    {
       return new Connection(array(
            "host" => "localhost",
            "username" => "root",
            "password" => "secret",
            "dbname" => "invo"
        ));
    }

}

class SomeComponent
{

    protected $_connection;

    /**
     * Sets the connection externally
     */
    public function setConnection($connection){
        $this->_connection = $connection;
    }

    public function someDbTask()
    {
        $connection = $this->_connection;

        // ...
    }

}

$some = new SomeComponent();

//Pass the connection defined in the registry
$some->setConnection(Registry::getConnection());

$some->someDbTask();
{% endhighlight %}

现在，让我们来想像一下，我们必须在组件中实现两个方法，首先需要创建一个新的数据库连接，第二个总是获得一个共享连接：

{% highlight ruby %}
<?php

class Registry
{

    protected static $_connection;

    /**
     * Creates a connection
     */
    protected static function _createConnection()
    {
        return new Connection(array(
            "host" => "localhost",
            "username" => "root",
            "password" => "secret",
            "dbname" => "invo"
        ));
    }

    /**
     * Creates a connection only once and returns it
     */
    public static function getSharedConnection()
    {
        if (self::$_connection===null){
            $connection = self::_createConnection();
            self::$_connection = $connection;
        }
        return self::$_connection;
    }

    /**
     * Always returns a new connection
     */
    public static function getNewConnection()
    {
        return self::_createConnection();
    }

}

class SomeComponent
{

    protected $_connection;

    /**
     * Sets the connection externally
     */
    public function setConnection($connection){
        $this->_connection = $connection;
    }

    /**
     * This method always needs the shared connection
     */
    public function someDbTask()
    {
        $connection = $this->_connection;

        // ...
    }

    /**
     * This method always needs a new connection
     */
    public function someOtherDbTask($connection)
    {

    }

}

$some = new SomeComponent();

//This injects the shared connection
$some->setConnection(Registry::getSharedConnection());

$some->someDbTask();

//Here, we always pass a new connection as parameter
$some->someOtherDbTask(Registry::getConnection());
{% endhighlight %}

到此为止，我们已经看到了如何使用依赖注入解决我们的问题。不是在代码内部创建依赖关系，而是让其作为一个参数传递，这使得我们的程序更容易维护，降低程序代码的耦合度，实现一种松耦合。但是从长远来看，这种形式的依赖注入也有一些缺点。

例如，如果组件中有较多的依赖关系，我们需要创建多个setter方法传递，或创建构造函数进行传递。另外，每次使用组件时，都需要创建依赖组件，使代码维护不太易，我们编写的代码可能像这样：

{% highlight ruby %}
<?php

//Create the dependencies or retrieve them from the registry
$connection = new Connection();
$session = new Session();
$fileSystem = new FileSystem();
$filter = new Filter();
$selector = new Selector();

//Pass them as constructor parameters
$some = new SomeComponent($connection, $session, $fileSystem, $filter, $selector);

// ... or using setters

$some->setConnection($connection);
$some->setSession($session);
$some->setFileSystem($fileSystem);
$some->setFilter($filter);
$some->setSelector($selector);
{% endhighlight %}

我想，我们不得不在应用程序的许多地方创建这个对象。如果你不需要依赖的组件后，我们又要去代码注入部分移除构造函数中的参数或者是setter方法。为了解决这个问题，我们再次返回去使用一个全局注册表来创建组件。但是，在创建对象之前，它增加了一个新的抽象层：


{% highlight ruby %}
<?php
class SomeComponent
{

    // ...

    /**
     * Define a factory method to create SomeComponent instances injecting its dependencies
     */
    public static function factory()
    {

        $connection = new Connection();
        $session = new Session();
        $fileSystem = new FileSystem();
        $filter = new Filter();
        $selector = new Selector();

        return new self($connection, $session, $fileSystem, $filter, $selector);
    }

}
//Create the dependencies or retrieve them from the registry
$connection = new Connection();
$session = new Session();
$fileSystem = new FileSystem();
$filter = new Filter();
$selector = new Selector();

//Pass them as constructor parameters
$some = new SomeComponent($connection, $session, $fileSystem, $filter, $selector);

// ... or using setters

$some->setConnection($connection);
$some->setSession($session);
$some->setFileSystem($fileSystem);
$some->setFilter($filter);
$some->setSelector($selector);
{% endhighlight %}

这一刻，我们好像回到了问题的开始，我们正在创建组件内部的依赖，我们每次都在修改以及找寻一种解决问题的办法，但这都不是很好的做法。

一种实用和优雅的来解决这些问题，是使用容器的依赖注入，像我们在前面看到的，容器作为全局注册表，使用容器的依赖注入做为一种桥梁来解决依赖可以使我们的代码耦合度更低，很好的降低了组件的复杂性：


{% highlight ruby %}
<?php

class SomeComponent
{

    protected $_di;

    public function __construct($di)
    {
        $this->_di = $di;
    }

    public function someDbTask()
    {

        // Get the connection service
        // Always returns a new connection
        $connection = $this->_di->get('db');

    }

    public function someOtherDbTask()
    {

        // Get a shared connection service,
        // this will return the same connection everytime
        $connection = $this->_di->getShared('db');

        //This method also requires a input filtering service
        $filter = $this->_db->get('filter');

    }

}

$di = new Phalcon\DI();

//Register a "db" service in the container
$di->set('db', function(){
    return new Connection(array(
        "host" => "localhost",
        "username" => "root",
        "password" => "secret",
        "dbname" => "invo"
    ));
});

//Register a "filter" service in the container
$di->set('filter', function(){
    return new Filter();
});

//Register a "session" service in the container
$di->set('session', function(){
    return new Session();
});

//Pass the service container as unique parameter
$some = new SomeComponent($di);

$some->someTask();
{% endhighlight %}

现在，该组件只有访问某种service的时候才需要它，如果它不需要，它甚至不初始化，以节约资源。该组件是高度解耦。他们的行为，或者说他们的任何其他方面都不会影响到组件本身。

---
参考文章：  
* [PHP关于依赖注入(控制反转)的解释和例子说明](https://my.oschina.net/cxz001/blog/209888?p=1)  
* [理解依赖注入与控制反转](http://phphub.laravel-china.org/topics/2104)  
* [理解依赖注入与控制反转](http://blog.chinaunix.net/uid-24205507-id-3804578.html)  

