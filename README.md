# OScourse

## homework2

### 思考题

- 你理解的对于类似ucore这样需要进程/虚存/文件系统的操作系统，在硬件设计上至少需要有哪些直接的支持？至少应该提供哪些功能的特权指令？

硬件支持：

串口控制器，块设备控制器，存储控制亲，终端设备，磁盘和磁带，物理内存

特权指令：

涉及外部设备的输入输出指令

修改特殊寄存器的指令

改变机器状态的指令

- 你理解的x86的实模式和保护模式有什么区别？物理地址、线性地址、逻辑地址的含义分别是什么？

保护模式和实模式的区别是进程内存是否受保护。

实模式将整个物理内存看成分段的区域,程序代码和数据位于不同区域，系统程序和用户程序没有区别对待。

保护模式中物理内存地址不能直接被程序访问，虚拟地址要由操作系统转化为物理地址去访问，程序对此一无所知，支持优先级机制，不同程序运行在不同的优先级上

物理地址：处理器提交到总线上用于访问计算机系统中的内存和外设的最终地址

线性地址：操作系统的虚存管理之下每个运行的应用程序能访问的地址空间

逻辑地址：应用程序直接使用的地址空间

- 理解list_entry双向链表数据结构及其4个基本操作函数和ucore中一些基于它的代码实现（此题不用填写内容）

- 对于如下的代码段，请说明":"后面的数字是什么含义
```
 /* Gate descriptors for interrupts and traps */
 struct gatedesc {
    unsigned gd_off_15_0 : 16;        // low 16 bits of offset in segment
    unsigned gd_ss : 16;            // segment selector
    unsigned gd_args : 5;            // # args, 0 for interrupt/trap gates
    unsigned gd_rsv1 : 3;            // reserved(should be zero I guess)
    unsigned gd_type : 4;            // type(STS_{TG,IG32,TG32})
    unsigned gd_s : 1;                // must be 0 (system)
    unsigned gd_dpl : 2;            // descriptor(meaning new) privilege level
    unsigned gd_p : 1;                // Present
    unsigned gd_off_31_16 : 16;        // high bits of offset in segment
 };
```

- 对于如下的代码段，

```
#define SETGATE(gate, istrap, sel, off, dpl) {            \
    (gate).gd_off_15_0 = (uint32_t)(off) & 0xffff;        \
    (gate).gd_ss = (sel);                                \
    (gate).gd_args = 0;                                    \
    (gate).gd_rsv1 = 0;                                    \
    (gate).gd_type = (istrap) ? STS_TG32 : STS_IG32;    \
    (gate).gd_s = 0;                                    \
    (gate).gd_dpl = (dpl);                                \
    (gate).gd_p = 1;                                    \
    (gate).gd_off_31_16 = (uint32_t)(off) >> 16;        \
}
```
如果在其他代码段中有如下语句，
```
unsigned intr;
intr=8;
SETGATE(intr, 1,2,3,0);
```
请问执行上述指令后， intr的值是多少？

0x20003(131075)

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