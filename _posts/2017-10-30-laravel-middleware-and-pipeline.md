---
layout: post
title: "laravel 的中间件与管道"
date: 2017-10-30
categories: laravel
excerpt: laravel src 中在许多地方都会看到使用了Pipeline。laravel中的Pipeline是实现Middleware的基础。Middleware的使用可以看成是Pipeline调用的。
---

一、php中的debug_backtrace()
    php的调试一直是一个比较困难的问题，最近发现`debug_backtrace()`是一个比较好用函数，可以在任何地方使用，直接在页面上打印出函数堆栈。

    class AController extends Controller
    {
        public function index(Request $request)
        {
            return debug_backtrace();
        }
    }

OR

    Route::get('/', function() {
        return debug_backtrace();   
    });


    在index中使用`debug_backtrace`会发现laravel中使用了很多的Pipeline，其实这就是在使用Middleware对请求进行过滤

二、Pipeline做了什么
    使用一段示例代码看看Pipeline到底做了什么 

	<?php
		use Illuminate\Pipeline\Pipeline;

		$pipe1 = function ($poster, Closure $next) {
			$poster += 1;
			echo "pipe1: $poster\n";
			return $next($poster);
		};

		$pipe2 = function ($poster, Closure $next) {
			if ($poster > 7) {
				return $poster;
			}

			$poster += 3;
			echo "pipe2: $poster\n";
			return $next($poster);
		};

		$pipe3 = function ($poster, Closure $next) {
			$result = $next($poster);
			echo "pipe3: $result\n";
			return $result * 2;
		};

		$pipe4 = function ($poster, Closure $next) {
			$poster += 2;
			echo "pipe4 : $poster\n";
			return $next($poster);
		};

		$pipes = [$pipe1, $pipe2, $pipe3, $pipe4];

		function dispatcher($poster, $pipes)
		{
			echo "result: " . (new Pipeline)->send($poster)->through($pipes)->then(function ($poster) {
					echo "received: $poster\n";
					return 3;
				}) . "\n";
		}

		echo "==> action 1:\n";
		dispatcher(5, $pipes);
		echo "==> action 2:\n";
		dispatcher(7, $pipes);


上述代码执行结果如下：

==> action 1:
pipe1: 6
pipe2: 9 
pipe4 : 11
received: 11
pipe3: 3
result: 6
==> action 2:
pipe1: 8
result: 8
