---
layout: post
title: "laravel 依赖注入的实现解析"
date: 2017-10-23
categories: laravel
excerpt: laravel基本上所有的service都绑定在了container中，作为laravel的核心组件，container负责service类的绑定与创建，所以依赖注入也是在container中实现的
---


#### 一、laravel 的依赖注入
在controller中，经常会使用

    public function index(Requet $request, $id, User $user)
    {
        $type = $request->get('type');
        $u = $user->where('id', $id)->first();
    }

其中`Request $request` (Request type-hint  依赖约束), 以及`User $user`都是依赖注入
 $id是普通参数，这三个参数的顺序交换了也可以正常运行，但是如果是增加一个普通的参数，(Requet $request, $id, User $user, $type),如果route中没有$type就会报错。对于构造函数同样也可以, laravel中的这种依赖注入是怎么实现的呢？

#### 二、laravel 的 Container
container是laravel中的核心组件，所有service等都会在初始化的时候bind到container中，需要使用的时候从container中make，包括我们常用到的Route,Cache以及Controller。在Illuminate\Container\Container.php中有bind方法，负责初始化时将各种service中bind，还有就是make方法，负责使用时make，依赖注入也是在make中实现的

     public function make($abstract, array $parameters = [])
     {
         $abstract = $this->getAlias($this->normalize($abstract));

         if (isset($this->instances[$abstract])) {
             return $this->instances[$abstract];
         }

         $concrete = $this->getConcrete($abstract);

         if ($this->isBuildable($concrete, $abstract)) {
             $object = $this->build($concrete, $parameters);
         } else {
             $object = $this->make($concrete, $parameters);
         }

         foreach ($this->getExtenders($abstract) as $extender) {
             $object = $extender($object, $this);
         }

         if ($this->isShared($abstract)) {
             $this->instances[$abstract] = $object;
         }

         $this->fireResolvingCallbacks($abstract, $object);

         $this->resolved[$abstract] = true;

         return $object;
     }

在isBuildable之前都是为了把传入的$abstract(string)转换成可以build的类名字符串

否则迭代自己重复进行format，而isBuildable之后则是对创建成功的实例做后续处理，比如如果这个类是共享的，则要保存起来以后创建时直接取这个实例，所以具体new instance是在build()函数中实现的

     public function build($concrete, array $parameters = [])
     {
         if ($concrete instanceof Closure) {
             return $concrete($this, $parameters);
         }

         $reflector = new ReflectionClass($concrete);

         if (! $reflector->isInstantiable()) {
             if (! empty($this->buildStack)) {
                 $previous = implode(', ', $this->buildStack);

                 $message = "Target [$concrete] is not instantiable while building [$previous].";
             } else {
                 $message = "Target [$concrete] is not instantiable.";
             }

             throw new BindingResolutionException($message);
         }

         $this->buildStack[] = $concrete;

         $constructor = $reflector->getConstructor();

         if (is_null($constructor)) {
             array_pop($this->buildStack);

             return new $concrete;
         }
         $dependencies = $constructor->getParameters();

         $parameters = $this->keyParametersByArgument(
             $dependencies, $parameters
         );

         $instances = $this->getDependencies(
             $dependencies, $parameters
          );

         array_pop($this->buildStack);

         return $reflector->newInstanceArgs($instances);
     }

build中通过反射ReflectionClass得到$reflector,如果$reflector不可实例化报错，检查这个类的构造函数，如果构造函数不包含参数，则直接新建实例返回结束；如果有参数，则通过getDependencies，将有依赖约束的全部new instance注入，放在数组instances中，通过`$reflector->newInstanceArgs`新建一个实例
其中getDependencies内容

    protected function getDependencies(array $parameters, array $primitives = [])
    {
        $dependencies = [];

        foreach ($parameters as $parameter) {
            $dependency = $parameter->getClass();

            if (array_key_exists($parameter->name, $primitives)) {
                $dependencies[] = $primitives[$parameter->name];
            } elseif (is_null($dependency)) {
                $dependencies[] = $this->resolveNonClass($parameter);
            } else {
                $dependencies[] = $this->resolveClass($parameter);
            }
        }

        return (array) $dependencies;
    }


getDependencies会对每一个参数处理，在resolveClass中继续调用了自己的make，之后的步骤就与之前相同了

    protected function resolveClass(ReflectionParameter $parameter)
    {
        try {
            return $this->make($parameter->getClass()->name);
        }

        catch (BindingResolutionContractException $e) {
            if ($parameter->isOptional()) {
                return $parameter->getDefaultValue();
            }

            throw $e;
        }
    }

> 总的从container中new一个instance的步骤是，先通过make format 传入的字符串是一个可以new的类名字符串，然后传入build，在build中判断此类是否有构造函数，没有直接new这个类就可以返回结束了。否则，对这个构造函数中的每一个依赖注入逐次make，每一个依赖注入的类如果构造函数中也有依赖注入的类，则递归处理，直到所有参数全部new成功后返回。
