# 设计模式
### SOLID
* S 单一职责原则（Single Responsibility Principle）
* O 开闭原则 （Open Closed Principle）
* L 里氏替换原则（Liskov Substitution Principle）、迪米特法则（Law of Demeter）
* I 接口隔离原则（Interface Segregation Principle）
* D 依赖倒置原则（Dependence Inversion Principle）

建立稳定、灵活、健壮的设计，而开闭原则又是重中之重，是最基础的原则。  

### 单例模式
* 饿汉式：类加载时完成初始化，线程安全
* 懒汉式：第一次使用时初始化，线程不安全

优点：  
...  

缺点：
  1. 一般没有接口，扩展很困难
  2. 对测试不利，没有开发完不能测试，因为没有接口也没法mock一个虚拟的对象
  3. 违背单一指责

变形：有上限的单例模式（多个有限实例）

### 工厂模式
* 简单工厂模式
* 多个工厂模式

### 抽象工厂模式

场景：系统的产品有多于一个的产品_族_   

### 模版方法模式

### 建造者模式
