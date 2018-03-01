# OScourse

## homework1

### 填空题

* 当前常见的操作系统主要用**C,C++,ASM**编程语言编写。
* "Operating system"这个单词起源于**Operator**。
* 在计算机系统中，控制和管理**各种资源**、有效地组织**多道程序**运行的系统软件称作**操作系统**。
* 允许多用户将若干个作业提交给计算机系统集中处理的操作系统称为**批处理**操作系统
* 你了解的当前世界上使用最多的32bit CPU是**ARM**，其上运行最多的操作系统是**Android**。
* 应用程序通过**系统调用**接口获得操作系统的服务。
* 现代操作系统的特征包括**并行性，虚拟性，异步性，共享性和持久性**。
* 操作系统内核的架构包括**宏内核，微内核，外核**。


### 问答题

- 请总结你认为操作系统应该具有的特征有什么？并对其特征进行简要阐述。

操作系统的特征：并发，共享，虚拟，异步。

并发：多个程序同时运行

共享：多个程序同时访问内存，知道哪些资源被占用了

虚拟：让用户感觉不到其他的程序

异步：只要运行环境相同，需要保证程序运行的结果是一致的

- 为什么现在的操作系统基本上用C语言来实现？为什么没有人用python，java来实现操作系统？

C语言足够高级，成熟，方便编写，足够底层，可以很好地实现操作系统

C在性能上优于python、java，而且更接近于底层语言。