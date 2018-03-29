
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 70 11 40 	lgdtl  0x40117018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba 68 89 11 00       	mov    $0x118968,%edx
  100035:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100049:	00 
  10004a:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  100051:	e8 f5 5d 00 00       	call   105e4b <memset>

    cons_init();                // init the console
  100056:	e8 76 15 00 00       	call   1015d1 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10005b:	c7 45 f4 e0 5f 10 00 	movl   $0x105fe0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100065:	89 44 24 04          	mov    %eax,0x4(%esp)
  100069:	c7 04 24 fc 5f 10 00 	movl   $0x105ffc,(%esp)
  100070:	e8 c7 02 00 00       	call   10033c <cprintf>

    print_kerninfo();
  100075:	e8 f6 07 00 00       	call   100870 <print_kerninfo>

    grade_backtrace();
  10007a:	e8 86 00 00 00       	call   100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007f:	e8 d9 42 00 00       	call   10435d <pmm_init>

    pic_init();                 // init interrupt controller
  100084:	e8 b1 16 00 00       	call   10173a <pic_init>
    idt_init();                 // init interrupt descriptor table
  100089:	e8 29 18 00 00       	call   1018b7 <idt_init>

    clock_init();               // init clock interrupt
  10008e:	e8 f4 0c 00 00       	call   100d87 <clock_init>
    intr_enable();              // enable irq interrupt
  100093:	e8 10 16 00 00       	call   1016a8 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100098:	eb fe                	jmp    100098 <kern_init+0x6e>

0010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009a:	55                   	push   %ebp
  10009b:	89 e5                	mov    %esp,%ebp
  10009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000a7:	00 
  1000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000af:	00 
  1000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000b7:	e8 fd 0b 00 00       	call   100cb9 <mon_backtrace>
}
  1000bc:	c9                   	leave  
  1000bd:	c3                   	ret    

001000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000be:	55                   	push   %ebp
  1000bf:	89 e5                	mov    %esp,%ebp
  1000c1:	53                   	push   %ebx
  1000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000cb:	8d 55 08             	lea    0x8(%ebp),%edx
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000dd:	89 04 24             	mov    %eax,(%esp)
  1000e0:	e8 b5 ff ff ff       	call   10009a <grade_backtrace2>
}
  1000e5:	83 c4 14             	add    $0x14,%esp
  1000e8:	5b                   	pop    %ebx
  1000e9:	5d                   	pop    %ebp
  1000ea:	c3                   	ret    

001000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000eb:	55                   	push   %ebp
  1000ec:	89 e5                	mov    %esp,%ebp
  1000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1000fb:	89 04 24             	mov    %eax,(%esp)
  1000fe:	e8 bb ff ff ff       	call   1000be <grade_backtrace1>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <grade_backtrace>:

void
grade_backtrace(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10010b:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100117:	ff 
  100118:	89 44 24 04          	mov    %eax,0x4(%esp)
  10011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100123:	e8 c3 ff ff ff       	call   1000eb <grade_backtrace0>
}
  100128:	c9                   	leave  
  100129:	c3                   	ret    

0010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012a:	55                   	push   %ebp
  10012b:	89 e5                	mov    %esp,%ebp
  10012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 c0             	movzwl %ax,%eax
  100143:	83 e0 03             	and    $0x3,%eax
  100146:	89 c2                	mov    %eax,%edx
  100148:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10014d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100151:	89 44 24 04          	mov    %eax,0x4(%esp)
  100155:	c7 04 24 01 60 10 00 	movl   $0x106001,(%esp)
  10015c:	e8 db 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100165:	0f b7 d0             	movzwl %ax,%edx
  100168:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10016d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100171:	89 44 24 04          	mov    %eax,0x4(%esp)
  100175:	c7 04 24 0f 60 10 00 	movl   $0x10600f,(%esp)
  10017c:	e8 bb 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100185:	0f b7 d0             	movzwl %ax,%edx
  100188:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 1d 60 10 00 	movl   $0x10601d,(%esp)
  10019c:	e8 9b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001a5:	0f b7 d0             	movzwl %ax,%edx
  1001a8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b5:	c7 04 24 2b 60 10 00 	movl   $0x10602b,(%esp)
  1001bc:	e8 7b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001c5:	0f b7 d0             	movzwl %ax,%edx
  1001c8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d5:	c7 04 24 39 60 10 00 	movl   $0x106039,(%esp)
  1001dc:	e8 5b 01 00 00       	call   10033c <cprintf>
    round ++;
  1001e1:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001e6:	83 c0 01             	add    $0x1,%eax
  1001e9:	a3 40 7a 11 00       	mov    %eax,0x117a40
}
  1001ee:	c9                   	leave  
  1001ef:	c3                   	ret    

001001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001f3:	5d                   	pop    %ebp
  1001f4:	c3                   	ret    

001001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001f5:	55                   	push   %ebp
  1001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001f8:	5d                   	pop    %ebp
  1001f9:	c3                   	ret    

001001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001fa:	55                   	push   %ebp
  1001fb:	89 e5                	mov    %esp,%ebp
  1001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100200:	e8 25 ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100205:	c7 04 24 48 60 10 00 	movl   $0x106048,(%esp)
  10020c:	e8 2b 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_user();
  100211:	e8 da ff ff ff       	call   1001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
  100216:	e8 0f ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021b:	c7 04 24 68 60 10 00 	movl   $0x106068,(%esp)
  100222:	e8 15 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_kernel();
  100227:	e8 c9 ff ff ff       	call   1001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10022c:	e8 f9 fe ff ff       	call   10012a <lab1_print_cur_status>
}
  100231:	c9                   	leave  
  100232:	c3                   	ret    

00100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100233:	55                   	push   %ebp
  100234:	89 e5                	mov    %esp,%ebp
  100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10023d:	74 13                	je     100252 <readline+0x1f>
        cprintf("%s", prompt);
  10023f:	8b 45 08             	mov    0x8(%ebp),%eax
  100242:	89 44 24 04          	mov    %eax,0x4(%esp)
  100246:	c7 04 24 87 60 10 00 	movl   $0x106087,(%esp)
  10024d:	e8 ea 00 00 00       	call   10033c <cprintf>
    }
    int i = 0, c;
  100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100259:	e8 66 01 00 00       	call   1003c4 <getchar>
  10025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100265:	79 07                	jns    10026e <readline+0x3b>
            return NULL;
  100267:	b8 00 00 00 00       	mov    $0x0,%eax
  10026c:	eb 79                	jmp    1002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100272:	7e 28                	jle    10029c <readline+0x69>
  100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10027b:	7f 1f                	jg     10029c <readline+0x69>
            cputchar(c);
  10027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100280:	89 04 24             	mov    %eax,(%esp)
  100283:	e8 da 00 00 00       	call   100362 <cputchar>
            buf[i ++] = c;
  100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10028b:	8d 50 01             	lea    0x1(%eax),%edx
  10028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100294:	88 90 60 7a 11 00    	mov    %dl,0x117a60(%eax)
  10029a:	eb 46                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  10029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002a0:	75 17                	jne    1002b9 <readline+0x86>
  1002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002a6:	7e 11                	jle    1002b9 <readline+0x86>
            cputchar(c);
  1002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002ab:	89 04 24             	mov    %eax,(%esp)
  1002ae:	e8 af 00 00 00       	call   100362 <cputchar>
            i --;
  1002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002b7:	eb 29                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002bd:	74 06                	je     1002c5 <readline+0x92>
  1002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002c3:	75 1d                	jne    1002e2 <readline+0xaf>
            cputchar(c);
  1002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 92 00 00 00       	call   100362 <cputchar>
            buf[i] = '\0';
  1002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002d3:	05 60 7a 11 00       	add    $0x117a60,%eax
  1002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002db:	b8 60 7a 11 00       	mov    $0x117a60,%eax
  1002e0:	eb 05                	jmp    1002e7 <readline+0xb4>
        }
    }
  1002e2:	e9 72 ff ff ff       	jmp    100259 <readline+0x26>
}
  1002e7:	c9                   	leave  
  1002e8:	c3                   	ret    

001002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002e9:	55                   	push   %ebp
  1002ea:	89 e5                	mov    %esp,%ebp
  1002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f2:	89 04 24             	mov    %eax,(%esp)
  1002f5:	e8 03 13 00 00       	call   1015fd <cons_putc>
    (*cnt) ++;
  1002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002fd:	8b 00                	mov    (%eax),%eax
  1002ff:	8d 50 01             	lea    0x1(%eax),%edx
  100302:	8b 45 0c             	mov    0xc(%ebp),%eax
  100305:	89 10                	mov    %edx,(%eax)
}
  100307:	c9                   	leave  
  100308:	c3                   	ret    

00100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100309:	55                   	push   %ebp
  10030a:	89 e5                	mov    %esp,%ebp
  10030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100316:	8b 45 0c             	mov    0xc(%ebp),%eax
  100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10031d:	8b 45 08             	mov    0x8(%ebp),%eax
  100320:	89 44 24 08          	mov    %eax,0x8(%esp)
  100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100327:	89 44 24 04          	mov    %eax,0x4(%esp)
  10032b:	c7 04 24 e9 02 10 00 	movl   $0x1002e9,(%esp)
  100332:	e8 2d 53 00 00       	call   105664 <vprintfmt>
    return cnt;
  100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10033a:	c9                   	leave  
  10033b:	c3                   	ret    

0010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10033c:	55                   	push   %ebp
  10033d:	89 e5                	mov    %esp,%ebp
  10033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100342:	8d 45 0c             	lea    0xc(%ebp),%eax
  100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10034b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10034f:	8b 45 08             	mov    0x8(%ebp),%eax
  100352:	89 04 24             	mov    %eax,(%esp)
  100355:	e8 af ff ff ff       	call   100309 <vcprintf>
  10035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100360:	c9                   	leave  
  100361:	c3                   	ret    

00100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100362:	55                   	push   %ebp
  100363:	89 e5                	mov    %esp,%ebp
  100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100368:	8b 45 08             	mov    0x8(%ebp),%eax
  10036b:	89 04 24             	mov    %eax,(%esp)
  10036e:	e8 8a 12 00 00       	call   1015fd <cons_putc>
}
  100373:	c9                   	leave  
  100374:	c3                   	ret    

00100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100375:	55                   	push   %ebp
  100376:	89 e5                	mov    %esp,%ebp
  100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100382:	eb 13                	jmp    100397 <cputs+0x22>
        cputch(c, &cnt);
  100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
  10038b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10038f:	89 04 24             	mov    %eax,(%esp)
  100392:	e8 52 ff ff ff       	call   1002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  100397:	8b 45 08             	mov    0x8(%ebp),%eax
  10039a:	8d 50 01             	lea    0x1(%eax),%edx
  10039d:	89 55 08             	mov    %edx,0x8(%ebp)
  1003a0:	0f b6 00             	movzbl (%eax),%eax
  1003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003aa:	75 d8                	jne    100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003ba:	e8 2a ff ff ff       	call   1002e9 <cputch>
    return cnt;
  1003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003c2:	c9                   	leave  
  1003c3:	c3                   	ret    

001003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003c4:	55                   	push   %ebp
  1003c5:	89 e5                	mov    %esp,%ebp
  1003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003ca:	e8 6a 12 00 00       	call   101639 <cons_getc>
  1003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003d6:	74 f2                	je     1003ca <getchar+0x6>
        /* do nothing */;
    return c;
  1003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003db:	c9                   	leave  
  1003dc:	c3                   	ret    

001003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003dd:	55                   	push   %ebp
  1003de:	89 e5                	mov    %esp,%ebp
  1003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003e6:	8b 00                	mov    (%eax),%eax
  1003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1003ee:	8b 00                	mov    (%eax),%eax
  1003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003fa:	e9 d2 00 00 00       	jmp    1004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100405:	01 d0                	add    %edx,%eax
  100407:	89 c2                	mov    %eax,%edx
  100409:	c1 ea 1f             	shr    $0x1f,%edx
  10040c:	01 d0                	add    %edx,%eax
  10040e:	d1 f8                	sar    %eax
  100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100419:	eb 04                	jmp    10041f <stab_binsearch+0x42>
            m --;
  10041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100425:	7c 1f                	jl     100446 <stab_binsearch+0x69>
  100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10042a:	89 d0                	mov    %edx,%eax
  10042c:	01 c0                	add    %eax,%eax
  10042e:	01 d0                	add    %edx,%eax
  100430:	c1 e0 02             	shl    $0x2,%eax
  100433:	89 c2                	mov    %eax,%edx
  100435:	8b 45 08             	mov    0x8(%ebp),%eax
  100438:	01 d0                	add    %edx,%eax
  10043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10043e:	0f b6 c0             	movzbl %al,%eax
  100441:	3b 45 14             	cmp    0x14(%ebp),%eax
  100444:	75 d5                	jne    10041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10044c:	7d 0b                	jge    100459 <stab_binsearch+0x7c>
            l = true_m + 1;
  10044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100451:	83 c0 01             	add    $0x1,%eax
  100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100457:	eb 78                	jmp    1004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100463:	89 d0                	mov    %edx,%eax
  100465:	01 c0                	add    %eax,%eax
  100467:	01 d0                	add    %edx,%eax
  100469:	c1 e0 02             	shl    $0x2,%eax
  10046c:	89 c2                	mov    %eax,%edx
  10046e:	8b 45 08             	mov    0x8(%ebp),%eax
  100471:	01 d0                	add    %edx,%eax
  100473:	8b 40 08             	mov    0x8(%eax),%eax
  100476:	3b 45 18             	cmp    0x18(%ebp),%eax
  100479:	73 13                	jae    10048e <stab_binsearch+0xb1>
            *region_left = m;
  10047b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100486:	83 c0 01             	add    $0x1,%eax
  100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10048c:	eb 43                	jmp    1004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100491:	89 d0                	mov    %edx,%eax
  100493:	01 c0                	add    %eax,%eax
  100495:	01 d0                	add    %edx,%eax
  100497:	c1 e0 02             	shl    $0x2,%eax
  10049a:	89 c2                	mov    %eax,%edx
  10049c:	8b 45 08             	mov    0x8(%ebp),%eax
  10049f:	01 d0                	add    %edx,%eax
  1004a1:	8b 40 08             	mov    0x8(%eax),%eax
  1004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004a7:	76 16                	jbe    1004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
  1004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004af:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b7:	83 e8 01             	sub    $0x1,%eax
  1004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004bd:	eb 12                	jmp    1004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004c5:	89 10                	mov    %edx,(%eax)
            l = m;
  1004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004d7:	0f 8e 22 ff ff ff    	jle    1003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004e1:	75 0f                	jne    1004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e6:	8b 00                	mov    (%eax),%eax
  1004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1004ee:	89 10                	mov    %edx,(%eax)
  1004f0:	eb 3f                	jmp    100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004f2:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f5:	8b 00                	mov    (%eax),%eax
  1004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004fa:	eb 04                	jmp    100500 <stab_binsearch+0x123>
  1004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100500:	8b 45 0c             	mov    0xc(%ebp),%eax
  100503:	8b 00                	mov    (%eax),%eax
  100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100508:	7d 1f                	jge    100529 <stab_binsearch+0x14c>
  10050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10050d:	89 d0                	mov    %edx,%eax
  10050f:	01 c0                	add    %eax,%eax
  100511:	01 d0                	add    %edx,%eax
  100513:	c1 e0 02             	shl    $0x2,%eax
  100516:	89 c2                	mov    %eax,%edx
  100518:	8b 45 08             	mov    0x8(%ebp),%eax
  10051b:	01 d0                	add    %edx,%eax
  10051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100521:	0f b6 c0             	movzbl %al,%eax
  100524:	3b 45 14             	cmp    0x14(%ebp),%eax
  100527:	75 d3                	jne    1004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100529:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10052f:	89 10                	mov    %edx,(%eax)
    }
}
  100531:	c9                   	leave  
  100532:	c3                   	ret    

00100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100533:	55                   	push   %ebp
  100534:	89 e5                	mov    %esp,%ebp
  100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100539:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053c:	c7 00 8c 60 10 00    	movl   $0x10608c,(%eax)
    info->eip_line = 0;
  100542:	8b 45 0c             	mov    0xc(%ebp),%eax
  100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10054c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10054f:	c7 40 08 8c 60 10 00 	movl   $0x10608c,0x8(%eax)
    info->eip_fn_namelen = 9;
  100556:	8b 45 0c             	mov    0xc(%ebp),%eax
  100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100560:	8b 45 0c             	mov    0xc(%ebp),%eax
  100563:	8b 55 08             	mov    0x8(%ebp),%edx
  100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100569:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100573:	c7 45 f4 08 73 10 00 	movl   $0x107308,-0xc(%ebp)
    stab_end = __STAB_END__;
  10057a:	c7 45 f0 00 20 11 00 	movl   $0x112000,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100581:	c7 45 ec 01 20 11 00 	movl   $0x112001,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100588:	c7 45 e8 57 4a 11 00 	movl   $0x114a57,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100595:	76 0d                	jbe    1005a4 <debuginfo_eip+0x71>
  100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10059a:	83 e8 01             	sub    $0x1,%eax
  10059d:	0f b6 00             	movzbl (%eax),%eax
  1005a0:	84 c0                	test   %al,%al
  1005a2:	74 0a                	je     1005ae <debuginfo_eip+0x7b>
        return -1;
  1005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005a9:	e9 c0 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005bb:	29 c2                	sub    %eax,%edx
  1005bd:	89 d0                	mov    %edx,%eax
  1005bf:	c1 f8 02             	sar    $0x2,%eax
  1005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005c8:	83 e8 01             	sub    $0x1,%eax
  1005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005dc:	00 
  1005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005ee:	89 04 24             	mov    %eax,(%esp)
  1005f1:	e8 e7 fd ff ff       	call   1003dd <stab_binsearch>
    if (lfile == 0)
  1005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005f9:	85 c0                	test   %eax,%eax
  1005fb:	75 0a                	jne    100607 <debuginfo_eip+0xd4>
        return -1;
  1005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100602:	e9 67 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100613:	8b 45 08             	mov    0x8(%ebp),%eax
  100616:	89 44 24 10          	mov    %eax,0x10(%esp)
  10061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100621:	00 
  100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100625:	89 44 24 08          	mov    %eax,0x8(%esp)
  100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10062c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100633:	89 04 24             	mov    %eax,(%esp)
  100636:	e8 a2 fd ff ff       	call   1003dd <stab_binsearch>

    if (lfun <= rfun) {
  10063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100641:	39 c2                	cmp    %eax,%edx
  100643:	7f 7c                	jg     1006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100648:	89 c2                	mov    %eax,%edx
  10064a:	89 d0                	mov    %edx,%eax
  10064c:	01 c0                	add    %eax,%eax
  10064e:	01 d0                	add    %edx,%eax
  100650:	c1 e0 02             	shl    $0x2,%eax
  100653:	89 c2                	mov    %eax,%edx
  100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100658:	01 d0                	add    %edx,%eax
  10065a:	8b 10                	mov    (%eax),%edx
  10065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100662:	29 c1                	sub    %eax,%ecx
  100664:	89 c8                	mov    %ecx,%eax
  100666:	39 c2                	cmp    %eax,%edx
  100668:	73 22                	jae    10068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10066d:	89 c2                	mov    %eax,%edx
  10066f:	89 d0                	mov    %edx,%eax
  100671:	01 c0                	add    %eax,%eax
  100673:	01 d0                	add    %edx,%eax
  100675:	c1 e0 02             	shl    $0x2,%eax
  100678:	89 c2                	mov    %eax,%edx
  10067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10067d:	01 d0                	add    %edx,%eax
  10067f:	8b 10                	mov    (%eax),%edx
  100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100684:	01 c2                	add    %eax,%edx
  100686:	8b 45 0c             	mov    0xc(%ebp),%eax
  100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068f:	89 c2                	mov    %eax,%edx
  100691:	89 d0                	mov    %edx,%eax
  100693:	01 c0                	add    %eax,%eax
  100695:	01 d0                	add    %edx,%eax
  100697:	c1 e0 02             	shl    $0x2,%eax
  10069a:	89 c2                	mov    %eax,%edx
  10069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10069f:	01 d0                	add    %edx,%eax
  1006a1:	8b 50 08             	mov    0x8(%eax),%edx
  1006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ad:	8b 40 10             	mov    0x10(%eax),%eax
  1006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006bf:	eb 15                	jmp    1006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c4:	8b 55 08             	mov    0x8(%ebp),%edx
  1006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d9:	8b 40 08             	mov    0x8(%eax),%eax
  1006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006e3:	00 
  1006e4:	89 04 24             	mov    %eax,(%esp)
  1006e7:	e8 d3 55 00 00       	call   105cbf <strfind>
  1006ec:	89 c2                	mov    %eax,%edx
  1006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f1:	8b 40 08             	mov    0x8(%eax),%eax
  1006f4:	29 c2                	sub    %eax,%edx
  1006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
  100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  10070a:	00 
  10070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10070e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100715:	89 44 24 04          	mov    %eax,0x4(%esp)
  100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071c:	89 04 24             	mov    %eax,(%esp)
  10071f:	e8 b9 fc ff ff       	call   1003dd <stab_binsearch>
    if (lline <= rline) {
  100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10072a:	39 c2                	cmp    %eax,%edx
  10072c:	7f 24                	jg     100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  10072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100731:	89 c2                	mov    %eax,%edx
  100733:	89 d0                	mov    %edx,%eax
  100735:	01 c0                	add    %eax,%eax
  100737:	01 d0                	add    %edx,%eax
  100739:	c1 e0 02             	shl    $0x2,%eax
  10073c:	89 c2                	mov    %eax,%edx
  10073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100741:	01 d0                	add    %edx,%eax
  100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100747:	0f b7 d0             	movzwl %ax,%edx
  10074a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100750:	eb 13                	jmp    100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100757:	e9 12 01 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10075f:	83 e8 01             	sub    $0x1,%eax
  100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10076b:	39 c2                	cmp    %eax,%edx
  10076d:	7c 56                	jl     1007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  10076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100772:	89 c2                	mov    %eax,%edx
  100774:	89 d0                	mov    %edx,%eax
  100776:	01 c0                	add    %eax,%eax
  100778:	01 d0                	add    %edx,%eax
  10077a:	c1 e0 02             	shl    $0x2,%eax
  10077d:	89 c2                	mov    %eax,%edx
  10077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100782:	01 d0                	add    %edx,%eax
  100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100788:	3c 84                	cmp    $0x84,%al
  10078a:	74 39                	je     1007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10078f:	89 c2                	mov    %eax,%edx
  100791:	89 d0                	mov    %edx,%eax
  100793:	01 c0                	add    %eax,%eax
  100795:	01 d0                	add    %edx,%eax
  100797:	c1 e0 02             	shl    $0x2,%eax
  10079a:	89 c2                	mov    %eax,%edx
  10079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10079f:	01 d0                	add    %edx,%eax
  1007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007a5:	3c 64                	cmp    $0x64,%al
  1007a7:	75 b3                	jne    10075c <debuginfo_eip+0x229>
  1007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ac:	89 c2                	mov    %eax,%edx
  1007ae:	89 d0                	mov    %edx,%eax
  1007b0:	01 c0                	add    %eax,%eax
  1007b2:	01 d0                	add    %edx,%eax
  1007b4:	c1 e0 02             	shl    $0x2,%eax
  1007b7:	89 c2                	mov    %eax,%edx
  1007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007bc:	01 d0                	add    %edx,%eax
  1007be:	8b 40 08             	mov    0x8(%eax),%eax
  1007c1:	85 c0                	test   %eax,%eax
  1007c3:	74 97                	je     10075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007cb:	39 c2                	cmp    %eax,%edx
  1007cd:	7c 46                	jl     100815 <debuginfo_eip+0x2e2>
  1007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d2:	89 c2                	mov    %eax,%edx
  1007d4:	89 d0                	mov    %edx,%eax
  1007d6:	01 c0                	add    %eax,%eax
  1007d8:	01 d0                	add    %edx,%eax
  1007da:	c1 e0 02             	shl    $0x2,%eax
  1007dd:	89 c2                	mov    %eax,%edx
  1007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e2:	01 d0                	add    %edx,%eax
  1007e4:	8b 10                	mov    (%eax),%edx
  1007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007ec:	29 c1                	sub    %eax,%ecx
  1007ee:	89 c8                	mov    %ecx,%eax
  1007f0:	39 c2                	cmp    %eax,%edx
  1007f2:	73 21                	jae    100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f7:	89 c2                	mov    %eax,%edx
  1007f9:	89 d0                	mov    %edx,%eax
  1007fb:	01 c0                	add    %eax,%eax
  1007fd:	01 d0                	add    %edx,%eax
  1007ff:	c1 e0 02             	shl    $0x2,%eax
  100802:	89 c2                	mov    %eax,%edx
  100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100807:	01 d0                	add    %edx,%eax
  100809:	8b 10                	mov    (%eax),%edx
  10080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10080e:	01 c2                	add    %eax,%edx
  100810:	8b 45 0c             	mov    0xc(%ebp),%eax
  100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10081b:	39 c2                	cmp    %eax,%edx
  10081d:	7d 4a                	jge    100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  10081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100822:	83 c0 01             	add    $0x1,%eax
  100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100828:	eb 18                	jmp    100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10082a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10082d:	8b 40 14             	mov    0x14(%eax),%eax
  100830:	8d 50 01             	lea    0x1(%eax),%edx
  100833:	8b 45 0c             	mov    0xc(%ebp),%eax
  100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10083c:	83 c0 01             	add    $0x1,%eax
  10083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100848:	39 c2                	cmp    %eax,%edx
  10084a:	7d 1d                	jge    100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084f:	89 c2                	mov    %eax,%edx
  100851:	89 d0                	mov    %edx,%eax
  100853:	01 c0                	add    %eax,%eax
  100855:	01 d0                	add    %edx,%eax
  100857:	c1 e0 02             	shl    $0x2,%eax
  10085a:	89 c2                	mov    %eax,%edx
  10085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10085f:	01 d0                	add    %edx,%eax
  100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100865:	3c a0                	cmp    $0xa0,%al
  100867:	74 c1                	je     10082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10086e:	c9                   	leave  
  10086f:	c3                   	ret    

00100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100870:	55                   	push   %ebp
  100871:	89 e5                	mov    %esp,%ebp
  100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100876:	c7 04 24 96 60 10 00 	movl   $0x106096,(%esp)
  10087d:	e8 ba fa ff ff       	call   10033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100882:	c7 44 24 04 2a 00 10 	movl   $0x10002a,0x4(%esp)
  100889:	00 
  10088a:	c7 04 24 af 60 10 00 	movl   $0x1060af,(%esp)
  100891:	e8 a6 fa ff ff       	call   10033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100896:	c7 44 24 04 d4 5f 10 	movl   $0x105fd4,0x4(%esp)
  10089d:	00 
  10089e:	c7 04 24 c7 60 10 00 	movl   $0x1060c7,(%esp)
  1008a5:	e8 92 fa ff ff       	call   10033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008aa:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  1008b1:	00 
  1008b2:	c7 04 24 df 60 10 00 	movl   $0x1060df,(%esp)
  1008b9:	e8 7e fa ff ff       	call   10033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008be:	c7 44 24 04 68 89 11 	movl   $0x118968,0x4(%esp)
  1008c5:	00 
  1008c6:	c7 04 24 f7 60 10 00 	movl   $0x1060f7,(%esp)
  1008cd:	e8 6a fa ff ff       	call   10033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008d2:	b8 68 89 11 00       	mov    $0x118968,%eax
  1008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008dd:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1008e2:	29 c2                	sub    %eax,%edx
  1008e4:	89 d0                	mov    %edx,%eax
  1008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ec:	85 c0                	test   %eax,%eax
  1008ee:	0f 48 c2             	cmovs  %edx,%eax
  1008f1:	c1 f8 0a             	sar    $0xa,%eax
  1008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008f8:	c7 04 24 10 61 10 00 	movl   $0x106110,(%esp)
  1008ff:	e8 38 fa ff ff       	call   10033c <cprintf>
}
  100904:	c9                   	leave  
  100905:	c3                   	ret    

00100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100906:	55                   	push   %ebp
  100907:	89 e5                	mov    %esp,%ebp
  100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100912:	89 44 24 04          	mov    %eax,0x4(%esp)
  100916:	8b 45 08             	mov    0x8(%ebp),%eax
  100919:	89 04 24             	mov    %eax,(%esp)
  10091c:	e8 12 fc ff ff       	call   100533 <debuginfo_eip>
  100921:	85 c0                	test   %eax,%eax
  100923:	74 15                	je     10093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100925:	8b 45 08             	mov    0x8(%ebp),%eax
  100928:	89 44 24 04          	mov    %eax,0x4(%esp)
  10092c:	c7 04 24 3a 61 10 00 	movl   $0x10613a,(%esp)
  100933:	e8 04 fa ff ff       	call   10033c <cprintf>
  100938:	eb 6d                	jmp    1009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100941:	eb 1c                	jmp    10095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100949:	01 d0                	add    %edx,%eax
  10094b:	0f b6 00             	movzbl (%eax),%eax
  10094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100957:	01 ca                	add    %ecx,%edx
  100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100965:	7f dc                	jg     100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100970:	01 d0                	add    %edx,%eax
  100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100978:	8b 55 08             	mov    0x8(%ebp),%edx
  10097b:	89 d1                	mov    %edx,%ecx
  10097d:	29 c1                	sub    %eax,%ecx
  10097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100993:	89 54 24 08          	mov    %edx,0x8(%esp)
  100997:	89 44 24 04          	mov    %eax,0x4(%esp)
  10099b:	c7 04 24 56 61 10 00 	movl   $0x106156,(%esp)
  1009a2:	e8 95 f9 ff ff       	call   10033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  1009a7:	c9                   	leave  
  1009a8:	c3                   	ret    

001009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009a9:	55                   	push   %ebp
  1009aa:	89 e5                	mov    %esp,%ebp
  1009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009af:	8b 45 04             	mov    0x4(%ebp),%eax
  1009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009b8:	c9                   	leave  
  1009b9:	c3                   	ret    

001009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009ba:	55                   	push   %ebp
  1009bb:	89 e5                	mov    %esp,%ebp
  1009bd:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009c0:	89 e8                	mov    %ebp,%eax
  1009c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  1009c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
  1009c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
  1009cb:	e8 d9 ff ff ff       	call   1009a9 <read_eip>
  1009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i, j;
	for(i = 0; i < STACKFRAME_DEPTH; i++)
  1009d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009da:	e9 93 00 00 00       	jmp    100a72 <print_stackframe+0xb8>
	{
		if(ebp == 0)
  1009df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1009e3:	75 05                	jne    1009ea <print_stackframe+0x30>
			break;
  1009e5:	e9 92 00 00 00       	jmp    100a7c <print_stackframe+0xc2>
		 cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  1009ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009ed:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f8:	c7 04 24 68 61 10 00 	movl   $0x106168,(%esp)
  1009ff:	e8 38 f9 ff ff       	call   10033c <cprintf>
		 uint32_t *args = (uint32_t *)ebp + 2;
  100a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a07:	83 c0 08             	add    $0x8,%eax
  100a0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		 for (j = 0; j < 4; j ++)
  100a0d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a14:	eb 25                	jmp    100a3b <print_stackframe+0x81>
		      cprintf("0x%08x ", args[j]);
  100a16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a19:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a23:	01 d0                	add    %edx,%eax
  100a25:	8b 00                	mov    (%eax),%eax
  100a27:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a2b:	c7 04 24 84 61 10 00 	movl   $0x106184,(%esp)
  100a32:	e8 05 f9 ff ff       	call   10033c <cprintf>
	{
		if(ebp == 0)
			break;
		 cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
		 uint32_t *args = (uint32_t *)ebp + 2;
		 for (j = 0; j < 4; j ++)
  100a37:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a3b:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a3f:	7e d5                	jle    100a16 <print_stackframe+0x5c>
		      cprintf("0x%08x ", args[j]);

		 cprintf("\n");
  100a41:	c7 04 24 8c 61 10 00 	movl   $0x10618c,(%esp)
  100a48:	e8 ef f8 ff ff       	call   10033c <cprintf>
		 print_debuginfo(eip - 1);
  100a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a50:	83 e8 01             	sub    $0x1,%eax
  100a53:	89 04 24             	mov    %eax,(%esp)
  100a56:	e8 ab fe ff ff       	call   100906 <print_debuginfo>
		 eip = ((uint32_t *)ebp)[1];
  100a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a5e:	83 c0 04             	add    $0x4,%eax
  100a61:	8b 00                	mov    (%eax),%eax
  100a63:	89 45 f0             	mov    %eax,-0x10(%ebp)
		 ebp = ((uint32_t *)ebp)[0];
  100a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a69:	8b 00                	mov    (%eax),%eax
  100a6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();
	int i, j;
	for(i = 0; i < STACKFRAME_DEPTH; i++)
  100a6e:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a72:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a76:	0f 8e 63 ff ff ff    	jle    1009df <print_stackframe+0x25>
		 print_debuginfo(eip - 1);
		 eip = ((uint32_t *)ebp)[1];
		 ebp = ((uint32_t *)ebp)[0];
	}

}
  100a7c:	c9                   	leave  
  100a7d:	c3                   	ret    

00100a7e <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a7e:	55                   	push   %ebp
  100a7f:	89 e5                	mov    %esp,%ebp
  100a81:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a84:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a8b:	eb 0c                	jmp    100a99 <parse+0x1b>
            *buf ++ = '\0';
  100a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  100a90:	8d 50 01             	lea    0x1(%eax),%edx
  100a93:	89 55 08             	mov    %edx,0x8(%ebp)
  100a96:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a99:	8b 45 08             	mov    0x8(%ebp),%eax
  100a9c:	0f b6 00             	movzbl (%eax),%eax
  100a9f:	84 c0                	test   %al,%al
  100aa1:	74 1d                	je     100ac0 <parse+0x42>
  100aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa6:	0f b6 00             	movzbl (%eax),%eax
  100aa9:	0f be c0             	movsbl %al,%eax
  100aac:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ab0:	c7 04 24 10 62 10 00 	movl   $0x106210,(%esp)
  100ab7:	e8 d0 51 00 00       	call   105c8c <strchr>
  100abc:	85 c0                	test   %eax,%eax
  100abe:	75 cd                	jne    100a8d <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  100ac3:	0f b6 00             	movzbl (%eax),%eax
  100ac6:	84 c0                	test   %al,%al
  100ac8:	75 02                	jne    100acc <parse+0x4e>
            break;
  100aca:	eb 67                	jmp    100b33 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100acc:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ad0:	75 14                	jne    100ae6 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ad2:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ad9:	00 
  100ada:	c7 04 24 15 62 10 00 	movl   $0x106215,(%esp)
  100ae1:	e8 56 f8 ff ff       	call   10033c <cprintf>
        }
        argv[argc ++] = buf;
  100ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ae9:	8d 50 01             	lea    0x1(%eax),%edx
  100aec:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100aef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100af6:	8b 45 0c             	mov    0xc(%ebp),%eax
  100af9:	01 c2                	add    %eax,%edx
  100afb:	8b 45 08             	mov    0x8(%ebp),%eax
  100afe:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b00:	eb 04                	jmp    100b06 <parse+0x88>
            buf ++;
  100b02:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b06:	8b 45 08             	mov    0x8(%ebp),%eax
  100b09:	0f b6 00             	movzbl (%eax),%eax
  100b0c:	84 c0                	test   %al,%al
  100b0e:	74 1d                	je     100b2d <parse+0xaf>
  100b10:	8b 45 08             	mov    0x8(%ebp),%eax
  100b13:	0f b6 00             	movzbl (%eax),%eax
  100b16:	0f be c0             	movsbl %al,%eax
  100b19:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b1d:	c7 04 24 10 62 10 00 	movl   $0x106210,(%esp)
  100b24:	e8 63 51 00 00       	call   105c8c <strchr>
  100b29:	85 c0                	test   %eax,%eax
  100b2b:	74 d5                	je     100b02 <parse+0x84>
            buf ++;
        }
    }
  100b2d:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b2e:	e9 66 ff ff ff       	jmp    100a99 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b36:	c9                   	leave  
  100b37:	c3                   	ret    

00100b38 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b38:	55                   	push   %ebp
  100b39:	89 e5                	mov    %esp,%ebp
  100b3b:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b3e:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b41:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b45:	8b 45 08             	mov    0x8(%ebp),%eax
  100b48:	89 04 24             	mov    %eax,(%esp)
  100b4b:	e8 2e ff ff ff       	call   100a7e <parse>
  100b50:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b53:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b57:	75 0a                	jne    100b63 <runcmd+0x2b>
        return 0;
  100b59:	b8 00 00 00 00       	mov    $0x0,%eax
  100b5e:	e9 85 00 00 00       	jmp    100be8 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b6a:	eb 5c                	jmp    100bc8 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b6c:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b72:	89 d0                	mov    %edx,%eax
  100b74:	01 c0                	add    %eax,%eax
  100b76:	01 d0                	add    %edx,%eax
  100b78:	c1 e0 02             	shl    $0x2,%eax
  100b7b:	05 20 70 11 00       	add    $0x117020,%eax
  100b80:	8b 00                	mov    (%eax),%eax
  100b82:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b86:	89 04 24             	mov    %eax,(%esp)
  100b89:	e8 5f 50 00 00       	call   105bed <strcmp>
  100b8e:	85 c0                	test   %eax,%eax
  100b90:	75 32                	jne    100bc4 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b95:	89 d0                	mov    %edx,%eax
  100b97:	01 c0                	add    %eax,%eax
  100b99:	01 d0                	add    %edx,%eax
  100b9b:	c1 e0 02             	shl    $0x2,%eax
  100b9e:	05 20 70 11 00       	add    $0x117020,%eax
  100ba3:	8b 40 08             	mov    0x8(%eax),%eax
  100ba6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100ba9:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100bac:	8b 55 0c             	mov    0xc(%ebp),%edx
  100baf:	89 54 24 08          	mov    %edx,0x8(%esp)
  100bb3:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100bb6:	83 c2 04             	add    $0x4,%edx
  100bb9:	89 54 24 04          	mov    %edx,0x4(%esp)
  100bbd:	89 0c 24             	mov    %ecx,(%esp)
  100bc0:	ff d0                	call   *%eax
  100bc2:	eb 24                	jmp    100be8 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bc4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bcb:	83 f8 02             	cmp    $0x2,%eax
  100bce:	76 9c                	jbe    100b6c <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bd0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bd7:	c7 04 24 33 62 10 00 	movl   $0x106233,(%esp)
  100bde:	e8 59 f7 ff ff       	call   10033c <cprintf>
    return 0;
  100be3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100be8:	c9                   	leave  
  100be9:	c3                   	ret    

00100bea <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bea:	55                   	push   %ebp
  100beb:	89 e5                	mov    %esp,%ebp
  100bed:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bf0:	c7 04 24 4c 62 10 00 	movl   $0x10624c,(%esp)
  100bf7:	e8 40 f7 ff ff       	call   10033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bfc:	c7 04 24 74 62 10 00 	movl   $0x106274,(%esp)
  100c03:	e8 34 f7 ff ff       	call   10033c <cprintf>

    if (tf != NULL) {
  100c08:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c0c:	74 0b                	je     100c19 <kmonitor+0x2f>
        print_trapframe(tf);
  100c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  100c11:	89 04 24             	mov    %eax,(%esp)
  100c14:	e8 dc 0d 00 00       	call   1019f5 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c19:	c7 04 24 99 62 10 00 	movl   $0x106299,(%esp)
  100c20:	e8 0e f6 ff ff       	call   100233 <readline>
  100c25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c2c:	74 18                	je     100c46 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  100c31:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c38:	89 04 24             	mov    %eax,(%esp)
  100c3b:	e8 f8 fe ff ff       	call   100b38 <runcmd>
  100c40:	85 c0                	test   %eax,%eax
  100c42:	79 02                	jns    100c46 <kmonitor+0x5c>
                break;
  100c44:	eb 02                	jmp    100c48 <kmonitor+0x5e>
            }
        }
    }
  100c46:	eb d1                	jmp    100c19 <kmonitor+0x2f>
}
  100c48:	c9                   	leave  
  100c49:	c3                   	ret    

00100c4a <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c4a:	55                   	push   %ebp
  100c4b:	89 e5                	mov    %esp,%ebp
  100c4d:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c57:	eb 3f                	jmp    100c98 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c5c:	89 d0                	mov    %edx,%eax
  100c5e:	01 c0                	add    %eax,%eax
  100c60:	01 d0                	add    %edx,%eax
  100c62:	c1 e0 02             	shl    $0x2,%eax
  100c65:	05 20 70 11 00       	add    $0x117020,%eax
  100c6a:	8b 48 04             	mov    0x4(%eax),%ecx
  100c6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c70:	89 d0                	mov    %edx,%eax
  100c72:	01 c0                	add    %eax,%eax
  100c74:	01 d0                	add    %edx,%eax
  100c76:	c1 e0 02             	shl    $0x2,%eax
  100c79:	05 20 70 11 00       	add    $0x117020,%eax
  100c7e:	8b 00                	mov    (%eax),%eax
  100c80:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c84:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c88:	c7 04 24 9d 62 10 00 	movl   $0x10629d,(%esp)
  100c8f:	e8 a8 f6 ff ff       	call   10033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c94:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c9b:	83 f8 02             	cmp    $0x2,%eax
  100c9e:	76 b9                	jbe    100c59 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100ca0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ca5:	c9                   	leave  
  100ca6:	c3                   	ret    

00100ca7 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100ca7:	55                   	push   %ebp
  100ca8:	89 e5                	mov    %esp,%ebp
  100caa:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100cad:	e8 be fb ff ff       	call   100870 <print_kerninfo>
    return 0;
  100cb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cb7:	c9                   	leave  
  100cb8:	c3                   	ret    

00100cb9 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cb9:	55                   	push   %ebp
  100cba:	89 e5                	mov    %esp,%ebp
  100cbc:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cbf:	e8 f6 fc ff ff       	call   1009ba <print_stackframe>
    return 0;
  100cc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cc9:	c9                   	leave  
  100cca:	c3                   	ret    

00100ccb <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100ccb:	55                   	push   %ebp
  100ccc:	89 e5                	mov    %esp,%ebp
  100cce:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cd1:	a1 60 7e 11 00       	mov    0x117e60,%eax
  100cd6:	85 c0                	test   %eax,%eax
  100cd8:	74 02                	je     100cdc <__panic+0x11>
        goto panic_dead;
  100cda:	eb 48                	jmp    100d24 <__panic+0x59>
    }
    is_panic = 1;
  100cdc:	c7 05 60 7e 11 00 01 	movl   $0x1,0x117e60
  100ce3:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100ce6:	8d 45 14             	lea    0x14(%ebp),%eax
  100ce9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cec:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cef:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  100cf6:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cfa:	c7 04 24 a6 62 10 00 	movl   $0x1062a6,(%esp)
  100d01:	e8 36 f6 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d09:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d0d:	8b 45 10             	mov    0x10(%ebp),%eax
  100d10:	89 04 24             	mov    %eax,(%esp)
  100d13:	e8 f1 f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d18:	c7 04 24 c2 62 10 00 	movl   $0x1062c2,(%esp)
  100d1f:	e8 18 f6 ff ff       	call   10033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100d24:	e8 85 09 00 00       	call   1016ae <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d29:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d30:	e8 b5 fe ff ff       	call   100bea <kmonitor>
    }
  100d35:	eb f2                	jmp    100d29 <__panic+0x5e>

00100d37 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d37:	55                   	push   %ebp
  100d38:	89 e5                	mov    %esp,%ebp
  100d3a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d3d:	8d 45 14             	lea    0x14(%ebp),%eax
  100d40:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d43:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d46:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  100d4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d51:	c7 04 24 c4 62 10 00 	movl   $0x1062c4,(%esp)
  100d58:	e8 df f5 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d60:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d64:	8b 45 10             	mov    0x10(%ebp),%eax
  100d67:	89 04 24             	mov    %eax,(%esp)
  100d6a:	e8 9a f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d6f:	c7 04 24 c2 62 10 00 	movl   $0x1062c2,(%esp)
  100d76:	e8 c1 f5 ff ff       	call   10033c <cprintf>
    va_end(ap);
}
  100d7b:	c9                   	leave  
  100d7c:	c3                   	ret    

00100d7d <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d7d:	55                   	push   %ebp
  100d7e:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d80:	a1 60 7e 11 00       	mov    0x117e60,%eax
}
  100d85:	5d                   	pop    %ebp
  100d86:	c3                   	ret    

00100d87 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d87:	55                   	push   %ebp
  100d88:	89 e5                	mov    %esp,%ebp
  100d8a:	83 ec 28             	sub    $0x28,%esp
  100d8d:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d93:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d97:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d9b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d9f:	ee                   	out    %al,(%dx)
  100da0:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100da6:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100daa:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100dae:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100db2:	ee                   	out    %al,(%dx)
  100db3:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100db9:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100dbd:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dc1:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dc5:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dc6:	c7 05 4c 89 11 00 00 	movl   $0x0,0x11894c
  100dcd:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dd0:	c7 04 24 e2 62 10 00 	movl   $0x1062e2,(%esp)
  100dd7:	e8 60 f5 ff ff       	call   10033c <cprintf>
    pic_enable(IRQ_TIMER);
  100ddc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100de3:	e8 24 09 00 00       	call   10170c <pic_enable>
}
  100de8:	c9                   	leave  
  100de9:	c3                   	ret    

00100dea <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100dea:	55                   	push   %ebp
  100deb:	89 e5                	mov    %esp,%ebp
  100ded:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100df0:	9c                   	pushf  
  100df1:	58                   	pop    %eax
  100df2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100df8:	25 00 02 00 00       	and    $0x200,%eax
  100dfd:	85 c0                	test   %eax,%eax
  100dff:	74 0c                	je     100e0d <__intr_save+0x23>
        intr_disable();
  100e01:	e8 a8 08 00 00       	call   1016ae <intr_disable>
        return 1;
  100e06:	b8 01 00 00 00       	mov    $0x1,%eax
  100e0b:	eb 05                	jmp    100e12 <__intr_save+0x28>
    }
    return 0;
  100e0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e12:	c9                   	leave  
  100e13:	c3                   	ret    

00100e14 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e14:	55                   	push   %ebp
  100e15:	89 e5                	mov    %esp,%ebp
  100e17:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e1e:	74 05                	je     100e25 <__intr_restore+0x11>
        intr_enable();
  100e20:	e8 83 08 00 00       	call   1016a8 <intr_enable>
    }
}
  100e25:	c9                   	leave  
  100e26:	c3                   	ret    

00100e27 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e27:	55                   	push   %ebp
  100e28:	89 e5                	mov    %esp,%ebp
  100e2a:	83 ec 10             	sub    $0x10,%esp
  100e2d:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e33:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e37:	89 c2                	mov    %eax,%edx
  100e39:	ec                   	in     (%dx),%al
  100e3a:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e3d:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e43:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e47:	89 c2                	mov    %eax,%edx
  100e49:	ec                   	in     (%dx),%al
  100e4a:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e4d:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e53:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e57:	89 c2                	mov    %eax,%edx
  100e59:	ec                   	in     (%dx),%al
  100e5a:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e5d:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e63:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e67:	89 c2                	mov    %eax,%edx
  100e69:	ec                   	in     (%dx),%al
  100e6a:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e6d:	c9                   	leave  
  100e6e:	c3                   	ret    

00100e6f <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e6f:	55                   	push   %ebp
  100e70:	89 e5                	mov    %esp,%ebp
  100e72:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e75:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e7f:	0f b7 00             	movzwl (%eax),%eax
  100e82:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e86:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e89:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e91:	0f b7 00             	movzwl (%eax),%eax
  100e94:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e98:	74 12                	je     100eac <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100e9a:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100ea1:	66 c7 05 86 7e 11 00 	movw   $0x3b4,0x117e86
  100ea8:	b4 03 
  100eaa:	eb 13                	jmp    100ebf <cga_init+0x50>
    } else {
        *cp = was;
  100eac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eaf:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100eb3:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100eb6:	66 c7 05 86 7e 11 00 	movw   $0x3d4,0x117e86
  100ebd:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ebf:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ec6:	0f b7 c0             	movzwl %ax,%eax
  100ec9:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100ecd:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ed1:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ed5:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100ed9:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100eda:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ee1:	83 c0 01             	add    $0x1,%eax
  100ee4:	0f b7 c0             	movzwl %ax,%eax
  100ee7:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100eeb:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100eef:	89 c2                	mov    %eax,%edx
  100ef1:	ec                   	in     (%dx),%al
  100ef2:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100ef5:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ef9:	0f b6 c0             	movzbl %al,%eax
  100efc:	c1 e0 08             	shl    $0x8,%eax
  100eff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f02:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f09:	0f b7 c0             	movzwl %ax,%eax
  100f0c:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100f10:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f14:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f18:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f1c:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f1d:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f24:	83 c0 01             	add    $0x1,%eax
  100f27:	0f b7 c0             	movzwl %ax,%eax
  100f2a:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f2e:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f32:	89 c2                	mov    %eax,%edx
  100f34:	ec                   	in     (%dx),%al
  100f35:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100f38:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f3c:	0f b6 c0             	movzbl %al,%eax
  100f3f:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f45:	a3 80 7e 11 00       	mov    %eax,0x117e80
    crt_pos = pos;
  100f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f4d:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
}
  100f53:	c9                   	leave  
  100f54:	c3                   	ret    

00100f55 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f55:	55                   	push   %ebp
  100f56:	89 e5                	mov    %esp,%ebp
  100f58:	83 ec 48             	sub    $0x48,%esp
  100f5b:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f61:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f65:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f69:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f6d:	ee                   	out    %al,(%dx)
  100f6e:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f74:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f78:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f7c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f80:	ee                   	out    %al,(%dx)
  100f81:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f87:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f8b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f8f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f93:	ee                   	out    %al,(%dx)
  100f94:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f9a:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f9e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fa2:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fa6:	ee                   	out    %al,(%dx)
  100fa7:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100fad:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100fb1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fb5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fb9:	ee                   	out    %al,(%dx)
  100fba:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fc0:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fc4:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fc8:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fcc:	ee                   	out    %al,(%dx)
  100fcd:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fd3:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100fd7:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fdb:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fdf:	ee                   	out    %al,(%dx)
  100fe0:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fe6:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100fea:	89 c2                	mov    %eax,%edx
  100fec:	ec                   	in     (%dx),%al
  100fed:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100ff0:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100ff4:	3c ff                	cmp    $0xff,%al
  100ff6:	0f 95 c0             	setne  %al
  100ff9:	0f b6 c0             	movzbl %al,%eax
  100ffc:	a3 88 7e 11 00       	mov    %eax,0x117e88
  101001:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101007:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  10100b:	89 c2                	mov    %eax,%edx
  10100d:	ec                   	in     (%dx),%al
  10100e:	88 45 d5             	mov    %al,-0x2b(%ebp)
  101011:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  101017:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  10101b:	89 c2                	mov    %eax,%edx
  10101d:	ec                   	in     (%dx),%al
  10101e:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101021:	a1 88 7e 11 00       	mov    0x117e88,%eax
  101026:	85 c0                	test   %eax,%eax
  101028:	74 0c                	je     101036 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  10102a:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101031:	e8 d6 06 00 00       	call   10170c <pic_enable>
    }
}
  101036:	c9                   	leave  
  101037:	c3                   	ret    

00101038 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101038:	55                   	push   %ebp
  101039:	89 e5                	mov    %esp,%ebp
  10103b:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10103e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101045:	eb 09                	jmp    101050 <lpt_putc_sub+0x18>
        delay();
  101047:	e8 db fd ff ff       	call   100e27 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10104c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101050:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101056:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10105a:	89 c2                	mov    %eax,%edx
  10105c:	ec                   	in     (%dx),%al
  10105d:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101060:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101064:	84 c0                	test   %al,%al
  101066:	78 09                	js     101071 <lpt_putc_sub+0x39>
  101068:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10106f:	7e d6                	jle    101047 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101071:	8b 45 08             	mov    0x8(%ebp),%eax
  101074:	0f b6 c0             	movzbl %al,%eax
  101077:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  10107d:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101080:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101084:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101088:	ee                   	out    %al,(%dx)
  101089:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10108f:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101093:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101097:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10109b:	ee                   	out    %al,(%dx)
  10109c:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  1010a2:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  1010a6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010aa:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010ae:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010af:	c9                   	leave  
  1010b0:	c3                   	ret    

001010b1 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010b1:	55                   	push   %ebp
  1010b2:	89 e5                	mov    %esp,%ebp
  1010b4:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010b7:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010bb:	74 0d                	je     1010ca <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1010c0:	89 04 24             	mov    %eax,(%esp)
  1010c3:	e8 70 ff ff ff       	call   101038 <lpt_putc_sub>
  1010c8:	eb 24                	jmp    1010ee <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  1010ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010d1:	e8 62 ff ff ff       	call   101038 <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010d6:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010dd:	e8 56 ff ff ff       	call   101038 <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010e2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010e9:	e8 4a ff ff ff       	call   101038 <lpt_putc_sub>
    }
}
  1010ee:	c9                   	leave  
  1010ef:	c3                   	ret    

001010f0 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010f0:	55                   	push   %ebp
  1010f1:	89 e5                	mov    %esp,%ebp
  1010f3:	53                   	push   %ebx
  1010f4:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1010fa:	b0 00                	mov    $0x0,%al
  1010fc:	85 c0                	test   %eax,%eax
  1010fe:	75 07                	jne    101107 <cga_putc+0x17>
        c |= 0x0700;
  101100:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101107:	8b 45 08             	mov    0x8(%ebp),%eax
  10110a:	0f b6 c0             	movzbl %al,%eax
  10110d:	83 f8 0a             	cmp    $0xa,%eax
  101110:	74 4c                	je     10115e <cga_putc+0x6e>
  101112:	83 f8 0d             	cmp    $0xd,%eax
  101115:	74 57                	je     10116e <cga_putc+0x7e>
  101117:	83 f8 08             	cmp    $0x8,%eax
  10111a:	0f 85 88 00 00 00    	jne    1011a8 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  101120:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101127:	66 85 c0             	test   %ax,%ax
  10112a:	74 30                	je     10115c <cga_putc+0x6c>
            crt_pos --;
  10112c:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101133:	83 e8 01             	sub    $0x1,%eax
  101136:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  10113c:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101141:	0f b7 15 84 7e 11 00 	movzwl 0x117e84,%edx
  101148:	0f b7 d2             	movzwl %dx,%edx
  10114b:	01 d2                	add    %edx,%edx
  10114d:	01 c2                	add    %eax,%edx
  10114f:	8b 45 08             	mov    0x8(%ebp),%eax
  101152:	b0 00                	mov    $0x0,%al
  101154:	83 c8 20             	or     $0x20,%eax
  101157:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10115a:	eb 72                	jmp    1011ce <cga_putc+0xde>
  10115c:	eb 70                	jmp    1011ce <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  10115e:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101165:	83 c0 50             	add    $0x50,%eax
  101168:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  10116e:	0f b7 1d 84 7e 11 00 	movzwl 0x117e84,%ebx
  101175:	0f b7 0d 84 7e 11 00 	movzwl 0x117e84,%ecx
  10117c:	0f b7 c1             	movzwl %cx,%eax
  10117f:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101185:	c1 e8 10             	shr    $0x10,%eax
  101188:	89 c2                	mov    %eax,%edx
  10118a:	66 c1 ea 06          	shr    $0x6,%dx
  10118e:	89 d0                	mov    %edx,%eax
  101190:	c1 e0 02             	shl    $0x2,%eax
  101193:	01 d0                	add    %edx,%eax
  101195:	c1 e0 04             	shl    $0x4,%eax
  101198:	29 c1                	sub    %eax,%ecx
  10119a:	89 ca                	mov    %ecx,%edx
  10119c:	89 d8                	mov    %ebx,%eax
  10119e:	29 d0                	sub    %edx,%eax
  1011a0:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
        break;
  1011a6:	eb 26                	jmp    1011ce <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011a8:	8b 0d 80 7e 11 00    	mov    0x117e80,%ecx
  1011ae:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011b5:	8d 50 01             	lea    0x1(%eax),%edx
  1011b8:	66 89 15 84 7e 11 00 	mov    %dx,0x117e84
  1011bf:	0f b7 c0             	movzwl %ax,%eax
  1011c2:	01 c0                	add    %eax,%eax
  1011c4:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1011ca:	66 89 02             	mov    %ax,(%edx)
        break;
  1011cd:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011ce:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011d5:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011d9:	76 5b                	jbe    101236 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011db:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011e0:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011e6:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011eb:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011f2:	00 
  1011f3:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011f7:	89 04 24             	mov    %eax,(%esp)
  1011fa:	e8 8b 4c 00 00       	call   105e8a <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011ff:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101206:	eb 15                	jmp    10121d <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  101208:	a1 80 7e 11 00       	mov    0x117e80,%eax
  10120d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101210:	01 d2                	add    %edx,%edx
  101212:	01 d0                	add    %edx,%eax
  101214:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101219:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10121d:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101224:	7e e2                	jle    101208 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  101226:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10122d:	83 e8 50             	sub    $0x50,%eax
  101230:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101236:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  10123d:	0f b7 c0             	movzwl %ax,%eax
  101240:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  101244:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  101248:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10124c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101250:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101251:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101258:	66 c1 e8 08          	shr    $0x8,%ax
  10125c:	0f b6 c0             	movzbl %al,%eax
  10125f:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  101266:	83 c2 01             	add    $0x1,%edx
  101269:	0f b7 d2             	movzwl %dx,%edx
  10126c:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101270:	88 45 ed             	mov    %al,-0x13(%ebp)
  101273:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101277:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10127b:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10127c:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101283:	0f b7 c0             	movzwl %ax,%eax
  101286:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  10128a:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  10128e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101292:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101296:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101297:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10129e:	0f b6 c0             	movzbl %al,%eax
  1012a1:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  1012a8:	83 c2 01             	add    $0x1,%edx
  1012ab:	0f b7 d2             	movzwl %dx,%edx
  1012ae:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1012b2:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1012b5:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012b9:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012bd:	ee                   	out    %al,(%dx)
}
  1012be:	83 c4 34             	add    $0x34,%esp
  1012c1:	5b                   	pop    %ebx
  1012c2:	5d                   	pop    %ebp
  1012c3:	c3                   	ret    

001012c4 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012c4:	55                   	push   %ebp
  1012c5:	89 e5                	mov    %esp,%ebp
  1012c7:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012d1:	eb 09                	jmp    1012dc <serial_putc_sub+0x18>
        delay();
  1012d3:	e8 4f fb ff ff       	call   100e27 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012d8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012dc:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012e2:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012e6:	89 c2                	mov    %eax,%edx
  1012e8:	ec                   	in     (%dx),%al
  1012e9:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012ec:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012f0:	0f b6 c0             	movzbl %al,%eax
  1012f3:	83 e0 20             	and    $0x20,%eax
  1012f6:	85 c0                	test   %eax,%eax
  1012f8:	75 09                	jne    101303 <serial_putc_sub+0x3f>
  1012fa:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101301:	7e d0                	jle    1012d3 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101303:	8b 45 08             	mov    0x8(%ebp),%eax
  101306:	0f b6 c0             	movzbl %al,%eax
  101309:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10130f:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101312:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101316:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10131a:	ee                   	out    %al,(%dx)
}
  10131b:	c9                   	leave  
  10131c:	c3                   	ret    

0010131d <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10131d:	55                   	push   %ebp
  10131e:	89 e5                	mov    %esp,%ebp
  101320:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101323:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101327:	74 0d                	je     101336 <serial_putc+0x19>
        serial_putc_sub(c);
  101329:	8b 45 08             	mov    0x8(%ebp),%eax
  10132c:	89 04 24             	mov    %eax,(%esp)
  10132f:	e8 90 ff ff ff       	call   1012c4 <serial_putc_sub>
  101334:	eb 24                	jmp    10135a <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  101336:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10133d:	e8 82 ff ff ff       	call   1012c4 <serial_putc_sub>
        serial_putc_sub(' ');
  101342:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101349:	e8 76 ff ff ff       	call   1012c4 <serial_putc_sub>
        serial_putc_sub('\b');
  10134e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101355:	e8 6a ff ff ff       	call   1012c4 <serial_putc_sub>
    }
}
  10135a:	c9                   	leave  
  10135b:	c3                   	ret    

0010135c <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10135c:	55                   	push   %ebp
  10135d:	89 e5                	mov    %esp,%ebp
  10135f:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101362:	eb 33                	jmp    101397 <cons_intr+0x3b>
        if (c != 0) {
  101364:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101368:	74 2d                	je     101397 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10136a:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10136f:	8d 50 01             	lea    0x1(%eax),%edx
  101372:	89 15 a4 80 11 00    	mov    %edx,0x1180a4
  101378:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10137b:	88 90 a0 7e 11 00    	mov    %dl,0x117ea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101381:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101386:	3d 00 02 00 00       	cmp    $0x200,%eax
  10138b:	75 0a                	jne    101397 <cons_intr+0x3b>
                cons.wpos = 0;
  10138d:	c7 05 a4 80 11 00 00 	movl   $0x0,0x1180a4
  101394:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101397:	8b 45 08             	mov    0x8(%ebp),%eax
  10139a:	ff d0                	call   *%eax
  10139c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10139f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013a3:	75 bf                	jne    101364 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1013a5:	c9                   	leave  
  1013a6:	c3                   	ret    

001013a7 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013a7:	55                   	push   %ebp
  1013a8:	89 e5                	mov    %esp,%ebp
  1013aa:	83 ec 10             	sub    $0x10,%esp
  1013ad:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013b3:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013b7:	89 c2                	mov    %eax,%edx
  1013b9:	ec                   	in     (%dx),%al
  1013ba:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013bd:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013c1:	0f b6 c0             	movzbl %al,%eax
  1013c4:	83 e0 01             	and    $0x1,%eax
  1013c7:	85 c0                	test   %eax,%eax
  1013c9:	75 07                	jne    1013d2 <serial_proc_data+0x2b>
        return -1;
  1013cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013d0:	eb 2a                	jmp    1013fc <serial_proc_data+0x55>
  1013d2:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013d8:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013dc:	89 c2                	mov    %eax,%edx
  1013de:	ec                   	in     (%dx),%al
  1013df:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013e2:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013e6:	0f b6 c0             	movzbl %al,%eax
  1013e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013ec:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013f0:	75 07                	jne    1013f9 <serial_proc_data+0x52>
        c = '\b';
  1013f2:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013fc:	c9                   	leave  
  1013fd:	c3                   	ret    

001013fe <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013fe:	55                   	push   %ebp
  1013ff:	89 e5                	mov    %esp,%ebp
  101401:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101404:	a1 88 7e 11 00       	mov    0x117e88,%eax
  101409:	85 c0                	test   %eax,%eax
  10140b:	74 0c                	je     101419 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  10140d:	c7 04 24 a7 13 10 00 	movl   $0x1013a7,(%esp)
  101414:	e8 43 ff ff ff       	call   10135c <cons_intr>
    }
}
  101419:	c9                   	leave  
  10141a:	c3                   	ret    

0010141b <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  10141b:	55                   	push   %ebp
  10141c:	89 e5                	mov    %esp,%ebp
  10141e:	83 ec 38             	sub    $0x38,%esp
  101421:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101427:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10142b:	89 c2                	mov    %eax,%edx
  10142d:	ec                   	in     (%dx),%al
  10142e:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101431:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101435:	0f b6 c0             	movzbl %al,%eax
  101438:	83 e0 01             	and    $0x1,%eax
  10143b:	85 c0                	test   %eax,%eax
  10143d:	75 0a                	jne    101449 <kbd_proc_data+0x2e>
        return -1;
  10143f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101444:	e9 59 01 00 00       	jmp    1015a2 <kbd_proc_data+0x187>
  101449:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10144f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101453:	89 c2                	mov    %eax,%edx
  101455:	ec                   	in     (%dx),%al
  101456:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101459:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  10145d:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101460:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101464:	75 17                	jne    10147d <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101466:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10146b:	83 c8 40             	or     $0x40,%eax
  10146e:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  101473:	b8 00 00 00 00       	mov    $0x0,%eax
  101478:	e9 25 01 00 00       	jmp    1015a2 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  10147d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101481:	84 c0                	test   %al,%al
  101483:	79 47                	jns    1014cc <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101485:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10148a:	83 e0 40             	and    $0x40,%eax
  10148d:	85 c0                	test   %eax,%eax
  10148f:	75 09                	jne    10149a <kbd_proc_data+0x7f>
  101491:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101495:	83 e0 7f             	and    $0x7f,%eax
  101498:	eb 04                	jmp    10149e <kbd_proc_data+0x83>
  10149a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10149e:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014a1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a5:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014ac:	83 c8 40             	or     $0x40,%eax
  1014af:	0f b6 c0             	movzbl %al,%eax
  1014b2:	f7 d0                	not    %eax
  1014b4:	89 c2                	mov    %eax,%edx
  1014b6:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014bb:	21 d0                	and    %edx,%eax
  1014bd:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  1014c2:	b8 00 00 00 00       	mov    $0x0,%eax
  1014c7:	e9 d6 00 00 00       	jmp    1015a2 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1014cc:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014d1:	83 e0 40             	and    $0x40,%eax
  1014d4:	85 c0                	test   %eax,%eax
  1014d6:	74 11                	je     1014e9 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014d8:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014dc:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014e1:	83 e0 bf             	and    $0xffffffbf,%eax
  1014e4:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    }

    shift |= shiftcode[data];
  1014e9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ed:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014f4:	0f b6 d0             	movzbl %al,%edx
  1014f7:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014fc:	09 d0                	or     %edx,%eax
  1014fe:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    shift ^= togglecode[data];
  101503:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101507:	0f b6 80 60 71 11 00 	movzbl 0x117160(%eax),%eax
  10150e:	0f b6 d0             	movzbl %al,%edx
  101511:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101516:	31 d0                	xor    %edx,%eax
  101518:	a3 a8 80 11 00       	mov    %eax,0x1180a8

    c = charcode[shift & (CTL | SHIFT)][data];
  10151d:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101522:	83 e0 03             	and    $0x3,%eax
  101525:	8b 14 85 60 75 11 00 	mov    0x117560(,%eax,4),%edx
  10152c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101530:	01 d0                	add    %edx,%eax
  101532:	0f b6 00             	movzbl (%eax),%eax
  101535:	0f b6 c0             	movzbl %al,%eax
  101538:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  10153b:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101540:	83 e0 08             	and    $0x8,%eax
  101543:	85 c0                	test   %eax,%eax
  101545:	74 22                	je     101569 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101547:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  10154b:	7e 0c                	jle    101559 <kbd_proc_data+0x13e>
  10154d:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101551:	7f 06                	jg     101559 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101553:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101557:	eb 10                	jmp    101569 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101559:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10155d:	7e 0a                	jle    101569 <kbd_proc_data+0x14e>
  10155f:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101563:	7f 04                	jg     101569 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101565:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101569:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10156e:	f7 d0                	not    %eax
  101570:	83 e0 06             	and    $0x6,%eax
  101573:	85 c0                	test   %eax,%eax
  101575:	75 28                	jne    10159f <kbd_proc_data+0x184>
  101577:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10157e:	75 1f                	jne    10159f <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101580:	c7 04 24 fd 62 10 00 	movl   $0x1062fd,(%esp)
  101587:	e8 b0 ed ff ff       	call   10033c <cprintf>
  10158c:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101592:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101596:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10159a:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  10159e:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10159f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015a2:	c9                   	leave  
  1015a3:	c3                   	ret    

001015a4 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015a4:	55                   	push   %ebp
  1015a5:	89 e5                	mov    %esp,%ebp
  1015a7:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015aa:	c7 04 24 1b 14 10 00 	movl   $0x10141b,(%esp)
  1015b1:	e8 a6 fd ff ff       	call   10135c <cons_intr>
}
  1015b6:	c9                   	leave  
  1015b7:	c3                   	ret    

001015b8 <kbd_init>:

static void
kbd_init(void) {
  1015b8:	55                   	push   %ebp
  1015b9:	89 e5                	mov    %esp,%ebp
  1015bb:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015be:	e8 e1 ff ff ff       	call   1015a4 <kbd_intr>
    pic_enable(IRQ_KBD);
  1015c3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015ca:	e8 3d 01 00 00       	call   10170c <pic_enable>
}
  1015cf:	c9                   	leave  
  1015d0:	c3                   	ret    

001015d1 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015d1:	55                   	push   %ebp
  1015d2:	89 e5                	mov    %esp,%ebp
  1015d4:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015d7:	e8 93 f8 ff ff       	call   100e6f <cga_init>
    serial_init();
  1015dc:	e8 74 f9 ff ff       	call   100f55 <serial_init>
    kbd_init();
  1015e1:	e8 d2 ff ff ff       	call   1015b8 <kbd_init>
    if (!serial_exists) {
  1015e6:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1015eb:	85 c0                	test   %eax,%eax
  1015ed:	75 0c                	jne    1015fb <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015ef:	c7 04 24 09 63 10 00 	movl   $0x106309,(%esp)
  1015f6:	e8 41 ed ff ff       	call   10033c <cprintf>
    }
}
  1015fb:	c9                   	leave  
  1015fc:	c3                   	ret    

001015fd <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015fd:	55                   	push   %ebp
  1015fe:	89 e5                	mov    %esp,%ebp
  101600:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  101603:	e8 e2 f7 ff ff       	call   100dea <__intr_save>
  101608:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  10160b:	8b 45 08             	mov    0x8(%ebp),%eax
  10160e:	89 04 24             	mov    %eax,(%esp)
  101611:	e8 9b fa ff ff       	call   1010b1 <lpt_putc>
        cga_putc(c);
  101616:	8b 45 08             	mov    0x8(%ebp),%eax
  101619:	89 04 24             	mov    %eax,(%esp)
  10161c:	e8 cf fa ff ff       	call   1010f0 <cga_putc>
        serial_putc(c);
  101621:	8b 45 08             	mov    0x8(%ebp),%eax
  101624:	89 04 24             	mov    %eax,(%esp)
  101627:	e8 f1 fc ff ff       	call   10131d <serial_putc>
    }
    local_intr_restore(intr_flag);
  10162c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10162f:	89 04 24             	mov    %eax,(%esp)
  101632:	e8 dd f7 ff ff       	call   100e14 <__intr_restore>
}
  101637:	c9                   	leave  
  101638:	c3                   	ret    

00101639 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101639:	55                   	push   %ebp
  10163a:	89 e5                	mov    %esp,%ebp
  10163c:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  10163f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101646:	e8 9f f7 ff ff       	call   100dea <__intr_save>
  10164b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  10164e:	e8 ab fd ff ff       	call   1013fe <serial_intr>
        kbd_intr();
  101653:	e8 4c ff ff ff       	call   1015a4 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101658:	8b 15 a0 80 11 00    	mov    0x1180a0,%edx
  10165e:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101663:	39 c2                	cmp    %eax,%edx
  101665:	74 31                	je     101698 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  101667:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  10166c:	8d 50 01             	lea    0x1(%eax),%edx
  10166f:	89 15 a0 80 11 00    	mov    %edx,0x1180a0
  101675:	0f b6 80 a0 7e 11 00 	movzbl 0x117ea0(%eax),%eax
  10167c:	0f b6 c0             	movzbl %al,%eax
  10167f:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101682:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101687:	3d 00 02 00 00       	cmp    $0x200,%eax
  10168c:	75 0a                	jne    101698 <cons_getc+0x5f>
                cons.rpos = 0;
  10168e:	c7 05 a0 80 11 00 00 	movl   $0x0,0x1180a0
  101695:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101698:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10169b:	89 04 24             	mov    %eax,(%esp)
  10169e:	e8 71 f7 ff ff       	call   100e14 <__intr_restore>
    return c;
  1016a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016a6:	c9                   	leave  
  1016a7:	c3                   	ret    

001016a8 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1016a8:	55                   	push   %ebp
  1016a9:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  1016ab:	fb                   	sti    
    sti();
}
  1016ac:	5d                   	pop    %ebp
  1016ad:	c3                   	ret    

001016ae <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016ae:	55                   	push   %ebp
  1016af:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  1016b1:	fa                   	cli    
    cli();
}
  1016b2:	5d                   	pop    %ebp
  1016b3:	c3                   	ret    

001016b4 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016b4:	55                   	push   %ebp
  1016b5:	89 e5                	mov    %esp,%ebp
  1016b7:	83 ec 14             	sub    $0x14,%esp
  1016ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1016bd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016c1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016c5:	66 a3 70 75 11 00    	mov    %ax,0x117570
    if (did_init) {
  1016cb:	a1 ac 80 11 00       	mov    0x1180ac,%eax
  1016d0:	85 c0                	test   %eax,%eax
  1016d2:	74 36                	je     10170a <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016d4:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016d8:	0f b6 c0             	movzbl %al,%eax
  1016db:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016e1:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1016e4:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016e8:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016ec:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016ed:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016f1:	66 c1 e8 08          	shr    $0x8,%ax
  1016f5:	0f b6 c0             	movzbl %al,%eax
  1016f8:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016fe:	88 45 f9             	mov    %al,-0x7(%ebp)
  101701:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101705:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101709:	ee                   	out    %al,(%dx)
    }
}
  10170a:	c9                   	leave  
  10170b:	c3                   	ret    

0010170c <pic_enable>:

void
pic_enable(unsigned int irq) {
  10170c:	55                   	push   %ebp
  10170d:	89 e5                	mov    %esp,%ebp
  10170f:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101712:	8b 45 08             	mov    0x8(%ebp),%eax
  101715:	ba 01 00 00 00       	mov    $0x1,%edx
  10171a:	89 c1                	mov    %eax,%ecx
  10171c:	d3 e2                	shl    %cl,%edx
  10171e:	89 d0                	mov    %edx,%eax
  101720:	f7 d0                	not    %eax
  101722:	89 c2                	mov    %eax,%edx
  101724:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  10172b:	21 d0                	and    %edx,%eax
  10172d:	0f b7 c0             	movzwl %ax,%eax
  101730:	89 04 24             	mov    %eax,(%esp)
  101733:	e8 7c ff ff ff       	call   1016b4 <pic_setmask>
}
  101738:	c9                   	leave  
  101739:	c3                   	ret    

0010173a <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10173a:	55                   	push   %ebp
  10173b:	89 e5                	mov    %esp,%ebp
  10173d:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101740:	c7 05 ac 80 11 00 01 	movl   $0x1,0x1180ac
  101747:	00 00 00 
  10174a:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101750:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  101754:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101758:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10175c:	ee                   	out    %al,(%dx)
  10175d:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101763:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  101767:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10176b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10176f:	ee                   	out    %al,(%dx)
  101770:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101776:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  10177a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10177e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101782:	ee                   	out    %al,(%dx)
  101783:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  101789:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  10178d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101791:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101795:	ee                   	out    %al,(%dx)
  101796:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  10179c:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  1017a0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1017a4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017a8:	ee                   	out    %al,(%dx)
  1017a9:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1017af:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1017b3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017b7:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017bb:	ee                   	out    %al,(%dx)
  1017bc:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017c2:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1017c6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017ca:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017ce:	ee                   	out    %al,(%dx)
  1017cf:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  1017d5:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  1017d9:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017dd:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017e1:	ee                   	out    %al,(%dx)
  1017e2:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  1017e8:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  1017ec:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017f0:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017f4:	ee                   	out    %al,(%dx)
  1017f5:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  1017fb:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  1017ff:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101803:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101807:	ee                   	out    %al,(%dx)
  101808:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  10180e:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101812:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101816:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10181a:	ee                   	out    %al,(%dx)
  10181b:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101821:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101825:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101829:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10182d:	ee                   	out    %al,(%dx)
  10182e:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  101834:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  101838:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10183c:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101840:	ee                   	out    %al,(%dx)
  101841:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  101847:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  10184b:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  10184f:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101853:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101854:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  10185b:	66 83 f8 ff          	cmp    $0xffff,%ax
  10185f:	74 12                	je     101873 <pic_init+0x139>
        pic_setmask(irq_mask);
  101861:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101868:	0f b7 c0             	movzwl %ax,%eax
  10186b:	89 04 24             	mov    %eax,(%esp)
  10186e:	e8 41 fe ff ff       	call   1016b4 <pic_setmask>
    }
}
  101873:	c9                   	leave  
  101874:	c3                   	ret    

00101875 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101875:	55                   	push   %ebp
  101876:	89 e5                	mov    %esp,%ebp
  101878:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10187b:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101882:	00 
  101883:	c7 04 24 40 63 10 00 	movl   $0x106340,(%esp)
  10188a:	e8 ad ea ff ff       	call   10033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  10188f:	c7 04 24 4a 63 10 00 	movl   $0x10634a,(%esp)
  101896:	e8 a1 ea ff ff       	call   10033c <cprintf>
    panic("EOT: kernel seems ok.");
  10189b:	c7 44 24 08 58 63 10 	movl   $0x106358,0x8(%esp)
  1018a2:	00 
  1018a3:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  1018aa:	00 
  1018ab:	c7 04 24 6e 63 10 00 	movl   $0x10636e,(%esp)
  1018b2:	e8 14 f4 ff ff       	call   100ccb <__panic>

001018b7 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018b7:	55                   	push   %ebp
  1018b8:	89 e5                	mov    %esp,%ebp
  1018ba:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int cnt_idt = sizeof(idt) / sizeof(struct gatedesc);
  1018bd:	c7 45 f8 00 01 00 00 	movl   $0x100,-0x8(%ebp)
	int i;
	for (i = 0; i < cnt_idt; i++)
  1018c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018cb:	e9 c3 00 00 00       	jmp    101993 <idt_init+0xdc>
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1018d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d3:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  1018da:	89 c2                	mov    %eax,%edx
  1018dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018df:	66 89 14 c5 c0 80 11 	mov    %dx,0x1180c0(,%eax,8)
  1018e6:	00 
  1018e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ea:	66 c7 04 c5 c2 80 11 	movw   $0x8,0x1180c2(,%eax,8)
  1018f1:	00 08 00 
  1018f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f7:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018fe:	00 
  1018ff:	83 e2 e0             	and    $0xffffffe0,%edx
  101902:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  101909:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10190c:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  101913:	00 
  101914:	83 e2 1f             	and    $0x1f,%edx
  101917:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  10191e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101921:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101928:	00 
  101929:	83 e2 f0             	and    $0xfffffff0,%edx
  10192c:	83 ca 0e             	or     $0xe,%edx
  10192f:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101936:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101939:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101940:	00 
  101941:	83 e2 ef             	and    $0xffffffef,%edx
  101944:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10194b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10194e:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101955:	00 
  101956:	83 e2 9f             	and    $0xffffff9f,%edx
  101959:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101960:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101963:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10196a:	00 
  10196b:	83 ca 80             	or     $0xffffff80,%edx
  10196e:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101975:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101978:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  10197f:	c1 e8 10             	shr    $0x10,%eax
  101982:	89 c2                	mov    %eax,%edx
  101984:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101987:	66 89 14 c5 c6 80 11 	mov    %dx,0x1180c6(,%eax,8)
  10198e:	00 
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int cnt_idt = sizeof(idt) / sizeof(struct gatedesc);
	int i;
	for (i = 0; i < cnt_idt; i++)
  10198f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101993:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101996:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  101999:	0f 8c 31 ff ff ff    	jl     1018d0 <idt_init+0x19>
  10199f:	c7 45 f4 80 75 11 00 	movl   $0x117580,-0xc(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  1019a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1019a9:	0f 01 18             	lidtl  (%eax)
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
	lidt(&idt_pd);
}
  1019ac:	c9                   	leave  
  1019ad:	c3                   	ret    

001019ae <trapname>:

static const char *
trapname(int trapno) {
  1019ae:	55                   	push   %ebp
  1019af:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1019b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1019b4:	83 f8 13             	cmp    $0x13,%eax
  1019b7:	77 0c                	ja     1019c5 <trapname+0x17>
        return excnames[trapno];
  1019b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1019bc:	8b 04 85 c0 66 10 00 	mov    0x1066c0(,%eax,4),%eax
  1019c3:	eb 18                	jmp    1019dd <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1019c5:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1019c9:	7e 0d                	jle    1019d8 <trapname+0x2a>
  1019cb:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1019cf:	7f 07                	jg     1019d8 <trapname+0x2a>
        return "Hardware Interrupt";
  1019d1:	b8 7f 63 10 00       	mov    $0x10637f,%eax
  1019d6:	eb 05                	jmp    1019dd <trapname+0x2f>
    }
    return "(unknown trap)";
  1019d8:	b8 92 63 10 00       	mov    $0x106392,%eax
}
  1019dd:	5d                   	pop    %ebp
  1019de:	c3                   	ret    

001019df <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1019df:	55                   	push   %ebp
  1019e0:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1019e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1019e5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1019e9:	66 83 f8 08          	cmp    $0x8,%ax
  1019ed:	0f 94 c0             	sete   %al
  1019f0:	0f b6 c0             	movzbl %al,%eax
}
  1019f3:	5d                   	pop    %ebp
  1019f4:	c3                   	ret    

001019f5 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1019f5:	55                   	push   %ebp
  1019f6:	89 e5                	mov    %esp,%ebp
  1019f8:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  1019fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1019fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a02:	c7 04 24 d3 63 10 00 	movl   $0x1063d3,(%esp)
  101a09:	e8 2e e9 ff ff       	call   10033c <cprintf>
    print_regs(&tf->tf_regs);
  101a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  101a11:	89 04 24             	mov    %eax,(%esp)
  101a14:	e8 a1 01 00 00       	call   101bba <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a19:	8b 45 08             	mov    0x8(%ebp),%eax
  101a1c:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a20:	0f b7 c0             	movzwl %ax,%eax
  101a23:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a27:	c7 04 24 e4 63 10 00 	movl   $0x1063e4,(%esp)
  101a2e:	e8 09 e9 ff ff       	call   10033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a33:	8b 45 08             	mov    0x8(%ebp),%eax
  101a36:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a3a:	0f b7 c0             	movzwl %ax,%eax
  101a3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a41:	c7 04 24 f7 63 10 00 	movl   $0x1063f7,(%esp)
  101a48:	e8 ef e8 ff ff       	call   10033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a50:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a54:	0f b7 c0             	movzwl %ax,%eax
  101a57:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a5b:	c7 04 24 0a 64 10 00 	movl   $0x10640a,(%esp)
  101a62:	e8 d5 e8 ff ff       	call   10033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a67:	8b 45 08             	mov    0x8(%ebp),%eax
  101a6a:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a6e:	0f b7 c0             	movzwl %ax,%eax
  101a71:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a75:	c7 04 24 1d 64 10 00 	movl   $0x10641d,(%esp)
  101a7c:	e8 bb e8 ff ff       	call   10033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a81:	8b 45 08             	mov    0x8(%ebp),%eax
  101a84:	8b 40 30             	mov    0x30(%eax),%eax
  101a87:	89 04 24             	mov    %eax,(%esp)
  101a8a:	e8 1f ff ff ff       	call   1019ae <trapname>
  101a8f:	8b 55 08             	mov    0x8(%ebp),%edx
  101a92:	8b 52 30             	mov    0x30(%edx),%edx
  101a95:	89 44 24 08          	mov    %eax,0x8(%esp)
  101a99:	89 54 24 04          	mov    %edx,0x4(%esp)
  101a9d:	c7 04 24 30 64 10 00 	movl   $0x106430,(%esp)
  101aa4:	e8 93 e8 ff ff       	call   10033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  101aac:	8b 40 34             	mov    0x34(%eax),%eax
  101aaf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ab3:	c7 04 24 42 64 10 00 	movl   $0x106442,(%esp)
  101aba:	e8 7d e8 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101abf:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac2:	8b 40 38             	mov    0x38(%eax),%eax
  101ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ac9:	c7 04 24 51 64 10 00 	movl   $0x106451,(%esp)
  101ad0:	e8 67 e8 ff ff       	call   10033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad8:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101adc:	0f b7 c0             	movzwl %ax,%eax
  101adf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ae3:	c7 04 24 60 64 10 00 	movl   $0x106460,(%esp)
  101aea:	e8 4d e8 ff ff       	call   10033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101aef:	8b 45 08             	mov    0x8(%ebp),%eax
  101af2:	8b 40 40             	mov    0x40(%eax),%eax
  101af5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101af9:	c7 04 24 73 64 10 00 	movl   $0x106473,(%esp)
  101b00:	e8 37 e8 ff ff       	call   10033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b05:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b0c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b13:	eb 3e                	jmp    101b53 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b15:	8b 45 08             	mov    0x8(%ebp),%eax
  101b18:	8b 50 40             	mov    0x40(%eax),%edx
  101b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b1e:	21 d0                	and    %edx,%eax
  101b20:	85 c0                	test   %eax,%eax
  101b22:	74 28                	je     101b4c <print_trapframe+0x157>
  101b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b27:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b2e:	85 c0                	test   %eax,%eax
  101b30:	74 1a                	je     101b4c <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b35:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b40:	c7 04 24 82 64 10 00 	movl   $0x106482,(%esp)
  101b47:	e8 f0 e7 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b4c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b50:	d1 65 f0             	shll   -0x10(%ebp)
  101b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b56:	83 f8 17             	cmp    $0x17,%eax
  101b59:	76 ba                	jbe    101b15 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5e:	8b 40 40             	mov    0x40(%eax),%eax
  101b61:	25 00 30 00 00       	and    $0x3000,%eax
  101b66:	c1 e8 0c             	shr    $0xc,%eax
  101b69:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b6d:	c7 04 24 86 64 10 00 	movl   $0x106486,(%esp)
  101b74:	e8 c3 e7 ff ff       	call   10033c <cprintf>

    if (!trap_in_kernel(tf)) {
  101b79:	8b 45 08             	mov    0x8(%ebp),%eax
  101b7c:	89 04 24             	mov    %eax,(%esp)
  101b7f:	e8 5b fe ff ff       	call   1019df <trap_in_kernel>
  101b84:	85 c0                	test   %eax,%eax
  101b86:	75 30                	jne    101bb8 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b88:	8b 45 08             	mov    0x8(%ebp),%eax
  101b8b:	8b 40 44             	mov    0x44(%eax),%eax
  101b8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b92:	c7 04 24 8f 64 10 00 	movl   $0x10648f,(%esp)
  101b99:	e8 9e e7 ff ff       	call   10033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba1:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101ba5:	0f b7 c0             	movzwl %ax,%eax
  101ba8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bac:	c7 04 24 9e 64 10 00 	movl   $0x10649e,(%esp)
  101bb3:	e8 84 e7 ff ff       	call   10033c <cprintf>
    }
}
  101bb8:	c9                   	leave  
  101bb9:	c3                   	ret    

00101bba <print_regs>:

void
print_regs(struct pushregs *regs) {
  101bba:	55                   	push   %ebp
  101bbb:	89 e5                	mov    %esp,%ebp
  101bbd:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc3:	8b 00                	mov    (%eax),%eax
  101bc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc9:	c7 04 24 b1 64 10 00 	movl   $0x1064b1,(%esp)
  101bd0:	e8 67 e7 ff ff       	call   10033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd8:	8b 40 04             	mov    0x4(%eax),%eax
  101bdb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bdf:	c7 04 24 c0 64 10 00 	movl   $0x1064c0,(%esp)
  101be6:	e8 51 e7 ff ff       	call   10033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101beb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bee:	8b 40 08             	mov    0x8(%eax),%eax
  101bf1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf5:	c7 04 24 cf 64 10 00 	movl   $0x1064cf,(%esp)
  101bfc:	e8 3b e7 ff ff       	call   10033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c01:	8b 45 08             	mov    0x8(%ebp),%eax
  101c04:	8b 40 0c             	mov    0xc(%eax),%eax
  101c07:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c0b:	c7 04 24 de 64 10 00 	movl   $0x1064de,(%esp)
  101c12:	e8 25 e7 ff ff       	call   10033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c17:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1a:	8b 40 10             	mov    0x10(%eax),%eax
  101c1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c21:	c7 04 24 ed 64 10 00 	movl   $0x1064ed,(%esp)
  101c28:	e8 0f e7 ff ff       	call   10033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c30:	8b 40 14             	mov    0x14(%eax),%eax
  101c33:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c37:	c7 04 24 fc 64 10 00 	movl   $0x1064fc,(%esp)
  101c3e:	e8 f9 e6 ff ff       	call   10033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c43:	8b 45 08             	mov    0x8(%ebp),%eax
  101c46:	8b 40 18             	mov    0x18(%eax),%eax
  101c49:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c4d:	c7 04 24 0b 65 10 00 	movl   $0x10650b,(%esp)
  101c54:	e8 e3 e6 ff ff       	call   10033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c59:	8b 45 08             	mov    0x8(%ebp),%eax
  101c5c:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c63:	c7 04 24 1a 65 10 00 	movl   $0x10651a,(%esp)
  101c6a:	e8 cd e6 ff ff       	call   10033c <cprintf>
}
  101c6f:	c9                   	leave  
  101c70:	c3                   	ret    

00101c71 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c71:	55                   	push   %ebp
  101c72:	89 e5                	mov    %esp,%ebp
  101c74:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101c77:	8b 45 08             	mov    0x8(%ebp),%eax
  101c7a:	8b 40 30             	mov    0x30(%eax),%eax
  101c7d:	83 f8 2f             	cmp    $0x2f,%eax
  101c80:	77 21                	ja     101ca3 <trap_dispatch+0x32>
  101c82:	83 f8 2e             	cmp    $0x2e,%eax
  101c85:	0f 83 0e 01 00 00    	jae    101d99 <trap_dispatch+0x128>
  101c8b:	83 f8 21             	cmp    $0x21,%eax
  101c8e:	0f 84 8b 00 00 00    	je     101d1f <trap_dispatch+0xae>
  101c94:	83 f8 24             	cmp    $0x24,%eax
  101c97:	74 60                	je     101cf9 <trap_dispatch+0x88>
  101c99:	83 f8 20             	cmp    $0x20,%eax
  101c9c:	74 16                	je     101cb4 <trap_dispatch+0x43>
  101c9e:	e9 be 00 00 00       	jmp    101d61 <trap_dispatch+0xf0>
  101ca3:	83 e8 78             	sub    $0x78,%eax
  101ca6:	83 f8 01             	cmp    $0x1,%eax
  101ca9:	0f 87 b2 00 00 00    	ja     101d61 <trap_dispatch+0xf0>
  101caf:	e9 91 00 00 00       	jmp    101d45 <trap_dispatch+0xd4>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
		ticks ++;
  101cb4:	a1 4c 89 11 00       	mov    0x11894c,%eax
  101cb9:	83 c0 01             	add    $0x1,%eax
  101cbc:	a3 4c 89 11 00       	mov    %eax,0x11894c
		if (ticks % TICK_NUM == 0)
  101cc1:	8b 0d 4c 89 11 00    	mov    0x11894c,%ecx
  101cc7:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101ccc:	89 c8                	mov    %ecx,%eax
  101cce:	f7 e2                	mul    %edx
  101cd0:	89 d0                	mov    %edx,%eax
  101cd2:	c1 e8 05             	shr    $0x5,%eax
  101cd5:	6b c0 64             	imul   $0x64,%eax,%eax
  101cd8:	29 c1                	sub    %eax,%ecx
  101cda:	89 c8                	mov    %ecx,%eax
  101cdc:	85 c0                	test   %eax,%eax
  101cde:	75 14                	jne    101cf4 <trap_dispatch+0x83>
		{
			print_ticks();
  101ce0:	e8 90 fb ff ff       	call   101875 <print_ticks>
			ticks = 0;
  101ce5:	c7 05 4c 89 11 00 00 	movl   $0x0,0x11894c
  101cec:	00 00 00 
		}
		break;
  101cef:	e9 a6 00 00 00       	jmp    101d9a <trap_dispatch+0x129>
  101cf4:	e9 a1 00 00 00       	jmp    101d9a <trap_dispatch+0x129>

    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101cf9:	e8 3b f9 ff ff       	call   101639 <cons_getc>
  101cfe:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d01:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d05:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d09:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d11:	c7 04 24 29 65 10 00 	movl   $0x106529,(%esp)
  101d18:	e8 1f e6 ff ff       	call   10033c <cprintf>
        break;
  101d1d:	eb 7b                	jmp    101d9a <trap_dispatch+0x129>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d1f:	e8 15 f9 ff ff       	call   101639 <cons_getc>
  101d24:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d27:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d2b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d2f:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d33:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d37:	c7 04 24 3b 65 10 00 	movl   $0x10653b,(%esp)
  101d3e:	e8 f9 e5 ff ff       	call   10033c <cprintf>
        break;
  101d43:	eb 55                	jmp    101d9a <trap_dispatch+0x129>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101d45:	c7 44 24 08 4a 65 10 	movl   $0x10654a,0x8(%esp)
  101d4c:	00 
  101d4d:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
  101d54:	00 
  101d55:	c7 04 24 6e 63 10 00 	movl   $0x10636e,(%esp)
  101d5c:	e8 6a ef ff ff       	call   100ccb <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101d61:	8b 45 08             	mov    0x8(%ebp),%eax
  101d64:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d68:	0f b7 c0             	movzwl %ax,%eax
  101d6b:	83 e0 03             	and    $0x3,%eax
  101d6e:	85 c0                	test   %eax,%eax
  101d70:	75 28                	jne    101d9a <trap_dispatch+0x129>
            print_trapframe(tf);
  101d72:	8b 45 08             	mov    0x8(%ebp),%eax
  101d75:	89 04 24             	mov    %eax,(%esp)
  101d78:	e8 78 fc ff ff       	call   1019f5 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101d7d:	c7 44 24 08 5a 65 10 	movl   $0x10655a,0x8(%esp)
  101d84:	00 
  101d85:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
  101d8c:	00 
  101d8d:	c7 04 24 6e 63 10 00 	movl   $0x10636e,(%esp)
  101d94:	e8 32 ef ff ff       	call   100ccb <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101d99:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101d9a:	c9                   	leave  
  101d9b:	c3                   	ret    

00101d9c <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101d9c:	55                   	push   %ebp
  101d9d:	89 e5                	mov    %esp,%ebp
  101d9f:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101da2:	8b 45 08             	mov    0x8(%ebp),%eax
  101da5:	89 04 24             	mov    %eax,(%esp)
  101da8:	e8 c4 fe ff ff       	call   101c71 <trap_dispatch>
}
  101dad:	c9                   	leave  
  101dae:	c3                   	ret    

00101daf <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101daf:	1e                   	push   %ds
    pushl %es
  101db0:	06                   	push   %es
    pushl %fs
  101db1:	0f a0                	push   %fs
    pushl %gs
  101db3:	0f a8                	push   %gs
    pushal
  101db5:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101db6:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101dbb:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101dbd:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101dbf:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101dc0:	e8 d7 ff ff ff       	call   101d9c <trap>

    # pop the pushed stack pointer
    popl %esp
  101dc5:	5c                   	pop    %esp

00101dc6 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101dc6:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101dc7:	0f a9                	pop    %gs
    popl %fs
  101dc9:	0f a1                	pop    %fs
    popl %es
  101dcb:	07                   	pop    %es
    popl %ds
  101dcc:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101dcd:	83 c4 08             	add    $0x8,%esp
    iret
  101dd0:	cf                   	iret   

00101dd1 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101dd1:	6a 00                	push   $0x0
  pushl $0
  101dd3:	6a 00                	push   $0x0
  jmp __alltraps
  101dd5:	e9 d5 ff ff ff       	jmp    101daf <__alltraps>

00101dda <vector1>:
.globl vector1
vector1:
  pushl $0
  101dda:	6a 00                	push   $0x0
  pushl $1
  101ddc:	6a 01                	push   $0x1
  jmp __alltraps
  101dde:	e9 cc ff ff ff       	jmp    101daf <__alltraps>

00101de3 <vector2>:
.globl vector2
vector2:
  pushl $0
  101de3:	6a 00                	push   $0x0
  pushl $2
  101de5:	6a 02                	push   $0x2
  jmp __alltraps
  101de7:	e9 c3 ff ff ff       	jmp    101daf <__alltraps>

00101dec <vector3>:
.globl vector3
vector3:
  pushl $0
  101dec:	6a 00                	push   $0x0
  pushl $3
  101dee:	6a 03                	push   $0x3
  jmp __alltraps
  101df0:	e9 ba ff ff ff       	jmp    101daf <__alltraps>

00101df5 <vector4>:
.globl vector4
vector4:
  pushl $0
  101df5:	6a 00                	push   $0x0
  pushl $4
  101df7:	6a 04                	push   $0x4
  jmp __alltraps
  101df9:	e9 b1 ff ff ff       	jmp    101daf <__alltraps>

00101dfe <vector5>:
.globl vector5
vector5:
  pushl $0
  101dfe:	6a 00                	push   $0x0
  pushl $5
  101e00:	6a 05                	push   $0x5
  jmp __alltraps
  101e02:	e9 a8 ff ff ff       	jmp    101daf <__alltraps>

00101e07 <vector6>:
.globl vector6
vector6:
  pushl $0
  101e07:	6a 00                	push   $0x0
  pushl $6
  101e09:	6a 06                	push   $0x6
  jmp __alltraps
  101e0b:	e9 9f ff ff ff       	jmp    101daf <__alltraps>

00101e10 <vector7>:
.globl vector7
vector7:
  pushl $0
  101e10:	6a 00                	push   $0x0
  pushl $7
  101e12:	6a 07                	push   $0x7
  jmp __alltraps
  101e14:	e9 96 ff ff ff       	jmp    101daf <__alltraps>

00101e19 <vector8>:
.globl vector8
vector8:
  pushl $8
  101e19:	6a 08                	push   $0x8
  jmp __alltraps
  101e1b:	e9 8f ff ff ff       	jmp    101daf <__alltraps>

00101e20 <vector9>:
.globl vector9
vector9:
  pushl $9
  101e20:	6a 09                	push   $0x9
  jmp __alltraps
  101e22:	e9 88 ff ff ff       	jmp    101daf <__alltraps>

00101e27 <vector10>:
.globl vector10
vector10:
  pushl $10
  101e27:	6a 0a                	push   $0xa
  jmp __alltraps
  101e29:	e9 81 ff ff ff       	jmp    101daf <__alltraps>

00101e2e <vector11>:
.globl vector11
vector11:
  pushl $11
  101e2e:	6a 0b                	push   $0xb
  jmp __alltraps
  101e30:	e9 7a ff ff ff       	jmp    101daf <__alltraps>

00101e35 <vector12>:
.globl vector12
vector12:
  pushl $12
  101e35:	6a 0c                	push   $0xc
  jmp __alltraps
  101e37:	e9 73 ff ff ff       	jmp    101daf <__alltraps>

00101e3c <vector13>:
.globl vector13
vector13:
  pushl $13
  101e3c:	6a 0d                	push   $0xd
  jmp __alltraps
  101e3e:	e9 6c ff ff ff       	jmp    101daf <__alltraps>

00101e43 <vector14>:
.globl vector14
vector14:
  pushl $14
  101e43:	6a 0e                	push   $0xe
  jmp __alltraps
  101e45:	e9 65 ff ff ff       	jmp    101daf <__alltraps>

00101e4a <vector15>:
.globl vector15
vector15:
  pushl $0
  101e4a:	6a 00                	push   $0x0
  pushl $15
  101e4c:	6a 0f                	push   $0xf
  jmp __alltraps
  101e4e:	e9 5c ff ff ff       	jmp    101daf <__alltraps>

00101e53 <vector16>:
.globl vector16
vector16:
  pushl $0
  101e53:	6a 00                	push   $0x0
  pushl $16
  101e55:	6a 10                	push   $0x10
  jmp __alltraps
  101e57:	e9 53 ff ff ff       	jmp    101daf <__alltraps>

00101e5c <vector17>:
.globl vector17
vector17:
  pushl $17
  101e5c:	6a 11                	push   $0x11
  jmp __alltraps
  101e5e:	e9 4c ff ff ff       	jmp    101daf <__alltraps>

00101e63 <vector18>:
.globl vector18
vector18:
  pushl $0
  101e63:	6a 00                	push   $0x0
  pushl $18
  101e65:	6a 12                	push   $0x12
  jmp __alltraps
  101e67:	e9 43 ff ff ff       	jmp    101daf <__alltraps>

00101e6c <vector19>:
.globl vector19
vector19:
  pushl $0
  101e6c:	6a 00                	push   $0x0
  pushl $19
  101e6e:	6a 13                	push   $0x13
  jmp __alltraps
  101e70:	e9 3a ff ff ff       	jmp    101daf <__alltraps>

00101e75 <vector20>:
.globl vector20
vector20:
  pushl $0
  101e75:	6a 00                	push   $0x0
  pushl $20
  101e77:	6a 14                	push   $0x14
  jmp __alltraps
  101e79:	e9 31 ff ff ff       	jmp    101daf <__alltraps>

00101e7e <vector21>:
.globl vector21
vector21:
  pushl $0
  101e7e:	6a 00                	push   $0x0
  pushl $21
  101e80:	6a 15                	push   $0x15
  jmp __alltraps
  101e82:	e9 28 ff ff ff       	jmp    101daf <__alltraps>

00101e87 <vector22>:
.globl vector22
vector22:
  pushl $0
  101e87:	6a 00                	push   $0x0
  pushl $22
  101e89:	6a 16                	push   $0x16
  jmp __alltraps
  101e8b:	e9 1f ff ff ff       	jmp    101daf <__alltraps>

00101e90 <vector23>:
.globl vector23
vector23:
  pushl $0
  101e90:	6a 00                	push   $0x0
  pushl $23
  101e92:	6a 17                	push   $0x17
  jmp __alltraps
  101e94:	e9 16 ff ff ff       	jmp    101daf <__alltraps>

00101e99 <vector24>:
.globl vector24
vector24:
  pushl $0
  101e99:	6a 00                	push   $0x0
  pushl $24
  101e9b:	6a 18                	push   $0x18
  jmp __alltraps
  101e9d:	e9 0d ff ff ff       	jmp    101daf <__alltraps>

00101ea2 <vector25>:
.globl vector25
vector25:
  pushl $0
  101ea2:	6a 00                	push   $0x0
  pushl $25
  101ea4:	6a 19                	push   $0x19
  jmp __alltraps
  101ea6:	e9 04 ff ff ff       	jmp    101daf <__alltraps>

00101eab <vector26>:
.globl vector26
vector26:
  pushl $0
  101eab:	6a 00                	push   $0x0
  pushl $26
  101ead:	6a 1a                	push   $0x1a
  jmp __alltraps
  101eaf:	e9 fb fe ff ff       	jmp    101daf <__alltraps>

00101eb4 <vector27>:
.globl vector27
vector27:
  pushl $0
  101eb4:	6a 00                	push   $0x0
  pushl $27
  101eb6:	6a 1b                	push   $0x1b
  jmp __alltraps
  101eb8:	e9 f2 fe ff ff       	jmp    101daf <__alltraps>

00101ebd <vector28>:
.globl vector28
vector28:
  pushl $0
  101ebd:	6a 00                	push   $0x0
  pushl $28
  101ebf:	6a 1c                	push   $0x1c
  jmp __alltraps
  101ec1:	e9 e9 fe ff ff       	jmp    101daf <__alltraps>

00101ec6 <vector29>:
.globl vector29
vector29:
  pushl $0
  101ec6:	6a 00                	push   $0x0
  pushl $29
  101ec8:	6a 1d                	push   $0x1d
  jmp __alltraps
  101eca:	e9 e0 fe ff ff       	jmp    101daf <__alltraps>

00101ecf <vector30>:
.globl vector30
vector30:
  pushl $0
  101ecf:	6a 00                	push   $0x0
  pushl $30
  101ed1:	6a 1e                	push   $0x1e
  jmp __alltraps
  101ed3:	e9 d7 fe ff ff       	jmp    101daf <__alltraps>

00101ed8 <vector31>:
.globl vector31
vector31:
  pushl $0
  101ed8:	6a 00                	push   $0x0
  pushl $31
  101eda:	6a 1f                	push   $0x1f
  jmp __alltraps
  101edc:	e9 ce fe ff ff       	jmp    101daf <__alltraps>

00101ee1 <vector32>:
.globl vector32
vector32:
  pushl $0
  101ee1:	6a 00                	push   $0x0
  pushl $32
  101ee3:	6a 20                	push   $0x20
  jmp __alltraps
  101ee5:	e9 c5 fe ff ff       	jmp    101daf <__alltraps>

00101eea <vector33>:
.globl vector33
vector33:
  pushl $0
  101eea:	6a 00                	push   $0x0
  pushl $33
  101eec:	6a 21                	push   $0x21
  jmp __alltraps
  101eee:	e9 bc fe ff ff       	jmp    101daf <__alltraps>

00101ef3 <vector34>:
.globl vector34
vector34:
  pushl $0
  101ef3:	6a 00                	push   $0x0
  pushl $34
  101ef5:	6a 22                	push   $0x22
  jmp __alltraps
  101ef7:	e9 b3 fe ff ff       	jmp    101daf <__alltraps>

00101efc <vector35>:
.globl vector35
vector35:
  pushl $0
  101efc:	6a 00                	push   $0x0
  pushl $35
  101efe:	6a 23                	push   $0x23
  jmp __alltraps
  101f00:	e9 aa fe ff ff       	jmp    101daf <__alltraps>

00101f05 <vector36>:
.globl vector36
vector36:
  pushl $0
  101f05:	6a 00                	push   $0x0
  pushl $36
  101f07:	6a 24                	push   $0x24
  jmp __alltraps
  101f09:	e9 a1 fe ff ff       	jmp    101daf <__alltraps>

00101f0e <vector37>:
.globl vector37
vector37:
  pushl $0
  101f0e:	6a 00                	push   $0x0
  pushl $37
  101f10:	6a 25                	push   $0x25
  jmp __alltraps
  101f12:	e9 98 fe ff ff       	jmp    101daf <__alltraps>

00101f17 <vector38>:
.globl vector38
vector38:
  pushl $0
  101f17:	6a 00                	push   $0x0
  pushl $38
  101f19:	6a 26                	push   $0x26
  jmp __alltraps
  101f1b:	e9 8f fe ff ff       	jmp    101daf <__alltraps>

00101f20 <vector39>:
.globl vector39
vector39:
  pushl $0
  101f20:	6a 00                	push   $0x0
  pushl $39
  101f22:	6a 27                	push   $0x27
  jmp __alltraps
  101f24:	e9 86 fe ff ff       	jmp    101daf <__alltraps>

00101f29 <vector40>:
.globl vector40
vector40:
  pushl $0
  101f29:	6a 00                	push   $0x0
  pushl $40
  101f2b:	6a 28                	push   $0x28
  jmp __alltraps
  101f2d:	e9 7d fe ff ff       	jmp    101daf <__alltraps>

00101f32 <vector41>:
.globl vector41
vector41:
  pushl $0
  101f32:	6a 00                	push   $0x0
  pushl $41
  101f34:	6a 29                	push   $0x29
  jmp __alltraps
  101f36:	e9 74 fe ff ff       	jmp    101daf <__alltraps>

00101f3b <vector42>:
.globl vector42
vector42:
  pushl $0
  101f3b:	6a 00                	push   $0x0
  pushl $42
  101f3d:	6a 2a                	push   $0x2a
  jmp __alltraps
  101f3f:	e9 6b fe ff ff       	jmp    101daf <__alltraps>

00101f44 <vector43>:
.globl vector43
vector43:
  pushl $0
  101f44:	6a 00                	push   $0x0
  pushl $43
  101f46:	6a 2b                	push   $0x2b
  jmp __alltraps
  101f48:	e9 62 fe ff ff       	jmp    101daf <__alltraps>

00101f4d <vector44>:
.globl vector44
vector44:
  pushl $0
  101f4d:	6a 00                	push   $0x0
  pushl $44
  101f4f:	6a 2c                	push   $0x2c
  jmp __alltraps
  101f51:	e9 59 fe ff ff       	jmp    101daf <__alltraps>

00101f56 <vector45>:
.globl vector45
vector45:
  pushl $0
  101f56:	6a 00                	push   $0x0
  pushl $45
  101f58:	6a 2d                	push   $0x2d
  jmp __alltraps
  101f5a:	e9 50 fe ff ff       	jmp    101daf <__alltraps>

00101f5f <vector46>:
.globl vector46
vector46:
  pushl $0
  101f5f:	6a 00                	push   $0x0
  pushl $46
  101f61:	6a 2e                	push   $0x2e
  jmp __alltraps
  101f63:	e9 47 fe ff ff       	jmp    101daf <__alltraps>

00101f68 <vector47>:
.globl vector47
vector47:
  pushl $0
  101f68:	6a 00                	push   $0x0
  pushl $47
  101f6a:	6a 2f                	push   $0x2f
  jmp __alltraps
  101f6c:	e9 3e fe ff ff       	jmp    101daf <__alltraps>

00101f71 <vector48>:
.globl vector48
vector48:
  pushl $0
  101f71:	6a 00                	push   $0x0
  pushl $48
  101f73:	6a 30                	push   $0x30
  jmp __alltraps
  101f75:	e9 35 fe ff ff       	jmp    101daf <__alltraps>

00101f7a <vector49>:
.globl vector49
vector49:
  pushl $0
  101f7a:	6a 00                	push   $0x0
  pushl $49
  101f7c:	6a 31                	push   $0x31
  jmp __alltraps
  101f7e:	e9 2c fe ff ff       	jmp    101daf <__alltraps>

00101f83 <vector50>:
.globl vector50
vector50:
  pushl $0
  101f83:	6a 00                	push   $0x0
  pushl $50
  101f85:	6a 32                	push   $0x32
  jmp __alltraps
  101f87:	e9 23 fe ff ff       	jmp    101daf <__alltraps>

00101f8c <vector51>:
.globl vector51
vector51:
  pushl $0
  101f8c:	6a 00                	push   $0x0
  pushl $51
  101f8e:	6a 33                	push   $0x33
  jmp __alltraps
  101f90:	e9 1a fe ff ff       	jmp    101daf <__alltraps>

00101f95 <vector52>:
.globl vector52
vector52:
  pushl $0
  101f95:	6a 00                	push   $0x0
  pushl $52
  101f97:	6a 34                	push   $0x34
  jmp __alltraps
  101f99:	e9 11 fe ff ff       	jmp    101daf <__alltraps>

00101f9e <vector53>:
.globl vector53
vector53:
  pushl $0
  101f9e:	6a 00                	push   $0x0
  pushl $53
  101fa0:	6a 35                	push   $0x35
  jmp __alltraps
  101fa2:	e9 08 fe ff ff       	jmp    101daf <__alltraps>

00101fa7 <vector54>:
.globl vector54
vector54:
  pushl $0
  101fa7:	6a 00                	push   $0x0
  pushl $54
  101fa9:	6a 36                	push   $0x36
  jmp __alltraps
  101fab:	e9 ff fd ff ff       	jmp    101daf <__alltraps>

00101fb0 <vector55>:
.globl vector55
vector55:
  pushl $0
  101fb0:	6a 00                	push   $0x0
  pushl $55
  101fb2:	6a 37                	push   $0x37
  jmp __alltraps
  101fb4:	e9 f6 fd ff ff       	jmp    101daf <__alltraps>

00101fb9 <vector56>:
.globl vector56
vector56:
  pushl $0
  101fb9:	6a 00                	push   $0x0
  pushl $56
  101fbb:	6a 38                	push   $0x38
  jmp __alltraps
  101fbd:	e9 ed fd ff ff       	jmp    101daf <__alltraps>

00101fc2 <vector57>:
.globl vector57
vector57:
  pushl $0
  101fc2:	6a 00                	push   $0x0
  pushl $57
  101fc4:	6a 39                	push   $0x39
  jmp __alltraps
  101fc6:	e9 e4 fd ff ff       	jmp    101daf <__alltraps>

00101fcb <vector58>:
.globl vector58
vector58:
  pushl $0
  101fcb:	6a 00                	push   $0x0
  pushl $58
  101fcd:	6a 3a                	push   $0x3a
  jmp __alltraps
  101fcf:	e9 db fd ff ff       	jmp    101daf <__alltraps>

00101fd4 <vector59>:
.globl vector59
vector59:
  pushl $0
  101fd4:	6a 00                	push   $0x0
  pushl $59
  101fd6:	6a 3b                	push   $0x3b
  jmp __alltraps
  101fd8:	e9 d2 fd ff ff       	jmp    101daf <__alltraps>

00101fdd <vector60>:
.globl vector60
vector60:
  pushl $0
  101fdd:	6a 00                	push   $0x0
  pushl $60
  101fdf:	6a 3c                	push   $0x3c
  jmp __alltraps
  101fe1:	e9 c9 fd ff ff       	jmp    101daf <__alltraps>

00101fe6 <vector61>:
.globl vector61
vector61:
  pushl $0
  101fe6:	6a 00                	push   $0x0
  pushl $61
  101fe8:	6a 3d                	push   $0x3d
  jmp __alltraps
  101fea:	e9 c0 fd ff ff       	jmp    101daf <__alltraps>

00101fef <vector62>:
.globl vector62
vector62:
  pushl $0
  101fef:	6a 00                	push   $0x0
  pushl $62
  101ff1:	6a 3e                	push   $0x3e
  jmp __alltraps
  101ff3:	e9 b7 fd ff ff       	jmp    101daf <__alltraps>

00101ff8 <vector63>:
.globl vector63
vector63:
  pushl $0
  101ff8:	6a 00                	push   $0x0
  pushl $63
  101ffa:	6a 3f                	push   $0x3f
  jmp __alltraps
  101ffc:	e9 ae fd ff ff       	jmp    101daf <__alltraps>

00102001 <vector64>:
.globl vector64
vector64:
  pushl $0
  102001:	6a 00                	push   $0x0
  pushl $64
  102003:	6a 40                	push   $0x40
  jmp __alltraps
  102005:	e9 a5 fd ff ff       	jmp    101daf <__alltraps>

0010200a <vector65>:
.globl vector65
vector65:
  pushl $0
  10200a:	6a 00                	push   $0x0
  pushl $65
  10200c:	6a 41                	push   $0x41
  jmp __alltraps
  10200e:	e9 9c fd ff ff       	jmp    101daf <__alltraps>

00102013 <vector66>:
.globl vector66
vector66:
  pushl $0
  102013:	6a 00                	push   $0x0
  pushl $66
  102015:	6a 42                	push   $0x42
  jmp __alltraps
  102017:	e9 93 fd ff ff       	jmp    101daf <__alltraps>

0010201c <vector67>:
.globl vector67
vector67:
  pushl $0
  10201c:	6a 00                	push   $0x0
  pushl $67
  10201e:	6a 43                	push   $0x43
  jmp __alltraps
  102020:	e9 8a fd ff ff       	jmp    101daf <__alltraps>

00102025 <vector68>:
.globl vector68
vector68:
  pushl $0
  102025:	6a 00                	push   $0x0
  pushl $68
  102027:	6a 44                	push   $0x44
  jmp __alltraps
  102029:	e9 81 fd ff ff       	jmp    101daf <__alltraps>

0010202e <vector69>:
.globl vector69
vector69:
  pushl $0
  10202e:	6a 00                	push   $0x0
  pushl $69
  102030:	6a 45                	push   $0x45
  jmp __alltraps
  102032:	e9 78 fd ff ff       	jmp    101daf <__alltraps>

00102037 <vector70>:
.globl vector70
vector70:
  pushl $0
  102037:	6a 00                	push   $0x0
  pushl $70
  102039:	6a 46                	push   $0x46
  jmp __alltraps
  10203b:	e9 6f fd ff ff       	jmp    101daf <__alltraps>

00102040 <vector71>:
.globl vector71
vector71:
  pushl $0
  102040:	6a 00                	push   $0x0
  pushl $71
  102042:	6a 47                	push   $0x47
  jmp __alltraps
  102044:	e9 66 fd ff ff       	jmp    101daf <__alltraps>

00102049 <vector72>:
.globl vector72
vector72:
  pushl $0
  102049:	6a 00                	push   $0x0
  pushl $72
  10204b:	6a 48                	push   $0x48
  jmp __alltraps
  10204d:	e9 5d fd ff ff       	jmp    101daf <__alltraps>

00102052 <vector73>:
.globl vector73
vector73:
  pushl $0
  102052:	6a 00                	push   $0x0
  pushl $73
  102054:	6a 49                	push   $0x49
  jmp __alltraps
  102056:	e9 54 fd ff ff       	jmp    101daf <__alltraps>

0010205b <vector74>:
.globl vector74
vector74:
  pushl $0
  10205b:	6a 00                	push   $0x0
  pushl $74
  10205d:	6a 4a                	push   $0x4a
  jmp __alltraps
  10205f:	e9 4b fd ff ff       	jmp    101daf <__alltraps>

00102064 <vector75>:
.globl vector75
vector75:
  pushl $0
  102064:	6a 00                	push   $0x0
  pushl $75
  102066:	6a 4b                	push   $0x4b
  jmp __alltraps
  102068:	e9 42 fd ff ff       	jmp    101daf <__alltraps>

0010206d <vector76>:
.globl vector76
vector76:
  pushl $0
  10206d:	6a 00                	push   $0x0
  pushl $76
  10206f:	6a 4c                	push   $0x4c
  jmp __alltraps
  102071:	e9 39 fd ff ff       	jmp    101daf <__alltraps>

00102076 <vector77>:
.globl vector77
vector77:
  pushl $0
  102076:	6a 00                	push   $0x0
  pushl $77
  102078:	6a 4d                	push   $0x4d
  jmp __alltraps
  10207a:	e9 30 fd ff ff       	jmp    101daf <__alltraps>

0010207f <vector78>:
.globl vector78
vector78:
  pushl $0
  10207f:	6a 00                	push   $0x0
  pushl $78
  102081:	6a 4e                	push   $0x4e
  jmp __alltraps
  102083:	e9 27 fd ff ff       	jmp    101daf <__alltraps>

00102088 <vector79>:
.globl vector79
vector79:
  pushl $0
  102088:	6a 00                	push   $0x0
  pushl $79
  10208a:	6a 4f                	push   $0x4f
  jmp __alltraps
  10208c:	e9 1e fd ff ff       	jmp    101daf <__alltraps>

00102091 <vector80>:
.globl vector80
vector80:
  pushl $0
  102091:	6a 00                	push   $0x0
  pushl $80
  102093:	6a 50                	push   $0x50
  jmp __alltraps
  102095:	e9 15 fd ff ff       	jmp    101daf <__alltraps>

0010209a <vector81>:
.globl vector81
vector81:
  pushl $0
  10209a:	6a 00                	push   $0x0
  pushl $81
  10209c:	6a 51                	push   $0x51
  jmp __alltraps
  10209e:	e9 0c fd ff ff       	jmp    101daf <__alltraps>

001020a3 <vector82>:
.globl vector82
vector82:
  pushl $0
  1020a3:	6a 00                	push   $0x0
  pushl $82
  1020a5:	6a 52                	push   $0x52
  jmp __alltraps
  1020a7:	e9 03 fd ff ff       	jmp    101daf <__alltraps>

001020ac <vector83>:
.globl vector83
vector83:
  pushl $0
  1020ac:	6a 00                	push   $0x0
  pushl $83
  1020ae:	6a 53                	push   $0x53
  jmp __alltraps
  1020b0:	e9 fa fc ff ff       	jmp    101daf <__alltraps>

001020b5 <vector84>:
.globl vector84
vector84:
  pushl $0
  1020b5:	6a 00                	push   $0x0
  pushl $84
  1020b7:	6a 54                	push   $0x54
  jmp __alltraps
  1020b9:	e9 f1 fc ff ff       	jmp    101daf <__alltraps>

001020be <vector85>:
.globl vector85
vector85:
  pushl $0
  1020be:	6a 00                	push   $0x0
  pushl $85
  1020c0:	6a 55                	push   $0x55
  jmp __alltraps
  1020c2:	e9 e8 fc ff ff       	jmp    101daf <__alltraps>

001020c7 <vector86>:
.globl vector86
vector86:
  pushl $0
  1020c7:	6a 00                	push   $0x0
  pushl $86
  1020c9:	6a 56                	push   $0x56
  jmp __alltraps
  1020cb:	e9 df fc ff ff       	jmp    101daf <__alltraps>

001020d0 <vector87>:
.globl vector87
vector87:
  pushl $0
  1020d0:	6a 00                	push   $0x0
  pushl $87
  1020d2:	6a 57                	push   $0x57
  jmp __alltraps
  1020d4:	e9 d6 fc ff ff       	jmp    101daf <__alltraps>

001020d9 <vector88>:
.globl vector88
vector88:
  pushl $0
  1020d9:	6a 00                	push   $0x0
  pushl $88
  1020db:	6a 58                	push   $0x58
  jmp __alltraps
  1020dd:	e9 cd fc ff ff       	jmp    101daf <__alltraps>

001020e2 <vector89>:
.globl vector89
vector89:
  pushl $0
  1020e2:	6a 00                	push   $0x0
  pushl $89
  1020e4:	6a 59                	push   $0x59
  jmp __alltraps
  1020e6:	e9 c4 fc ff ff       	jmp    101daf <__alltraps>

001020eb <vector90>:
.globl vector90
vector90:
  pushl $0
  1020eb:	6a 00                	push   $0x0
  pushl $90
  1020ed:	6a 5a                	push   $0x5a
  jmp __alltraps
  1020ef:	e9 bb fc ff ff       	jmp    101daf <__alltraps>

001020f4 <vector91>:
.globl vector91
vector91:
  pushl $0
  1020f4:	6a 00                	push   $0x0
  pushl $91
  1020f6:	6a 5b                	push   $0x5b
  jmp __alltraps
  1020f8:	e9 b2 fc ff ff       	jmp    101daf <__alltraps>

001020fd <vector92>:
.globl vector92
vector92:
  pushl $0
  1020fd:	6a 00                	push   $0x0
  pushl $92
  1020ff:	6a 5c                	push   $0x5c
  jmp __alltraps
  102101:	e9 a9 fc ff ff       	jmp    101daf <__alltraps>

00102106 <vector93>:
.globl vector93
vector93:
  pushl $0
  102106:	6a 00                	push   $0x0
  pushl $93
  102108:	6a 5d                	push   $0x5d
  jmp __alltraps
  10210a:	e9 a0 fc ff ff       	jmp    101daf <__alltraps>

0010210f <vector94>:
.globl vector94
vector94:
  pushl $0
  10210f:	6a 00                	push   $0x0
  pushl $94
  102111:	6a 5e                	push   $0x5e
  jmp __alltraps
  102113:	e9 97 fc ff ff       	jmp    101daf <__alltraps>

00102118 <vector95>:
.globl vector95
vector95:
  pushl $0
  102118:	6a 00                	push   $0x0
  pushl $95
  10211a:	6a 5f                	push   $0x5f
  jmp __alltraps
  10211c:	e9 8e fc ff ff       	jmp    101daf <__alltraps>

00102121 <vector96>:
.globl vector96
vector96:
  pushl $0
  102121:	6a 00                	push   $0x0
  pushl $96
  102123:	6a 60                	push   $0x60
  jmp __alltraps
  102125:	e9 85 fc ff ff       	jmp    101daf <__alltraps>

0010212a <vector97>:
.globl vector97
vector97:
  pushl $0
  10212a:	6a 00                	push   $0x0
  pushl $97
  10212c:	6a 61                	push   $0x61
  jmp __alltraps
  10212e:	e9 7c fc ff ff       	jmp    101daf <__alltraps>

00102133 <vector98>:
.globl vector98
vector98:
  pushl $0
  102133:	6a 00                	push   $0x0
  pushl $98
  102135:	6a 62                	push   $0x62
  jmp __alltraps
  102137:	e9 73 fc ff ff       	jmp    101daf <__alltraps>

0010213c <vector99>:
.globl vector99
vector99:
  pushl $0
  10213c:	6a 00                	push   $0x0
  pushl $99
  10213e:	6a 63                	push   $0x63
  jmp __alltraps
  102140:	e9 6a fc ff ff       	jmp    101daf <__alltraps>

00102145 <vector100>:
.globl vector100
vector100:
  pushl $0
  102145:	6a 00                	push   $0x0
  pushl $100
  102147:	6a 64                	push   $0x64
  jmp __alltraps
  102149:	e9 61 fc ff ff       	jmp    101daf <__alltraps>

0010214e <vector101>:
.globl vector101
vector101:
  pushl $0
  10214e:	6a 00                	push   $0x0
  pushl $101
  102150:	6a 65                	push   $0x65
  jmp __alltraps
  102152:	e9 58 fc ff ff       	jmp    101daf <__alltraps>

00102157 <vector102>:
.globl vector102
vector102:
  pushl $0
  102157:	6a 00                	push   $0x0
  pushl $102
  102159:	6a 66                	push   $0x66
  jmp __alltraps
  10215b:	e9 4f fc ff ff       	jmp    101daf <__alltraps>

00102160 <vector103>:
.globl vector103
vector103:
  pushl $0
  102160:	6a 00                	push   $0x0
  pushl $103
  102162:	6a 67                	push   $0x67
  jmp __alltraps
  102164:	e9 46 fc ff ff       	jmp    101daf <__alltraps>

00102169 <vector104>:
.globl vector104
vector104:
  pushl $0
  102169:	6a 00                	push   $0x0
  pushl $104
  10216b:	6a 68                	push   $0x68
  jmp __alltraps
  10216d:	e9 3d fc ff ff       	jmp    101daf <__alltraps>

00102172 <vector105>:
.globl vector105
vector105:
  pushl $0
  102172:	6a 00                	push   $0x0
  pushl $105
  102174:	6a 69                	push   $0x69
  jmp __alltraps
  102176:	e9 34 fc ff ff       	jmp    101daf <__alltraps>

0010217b <vector106>:
.globl vector106
vector106:
  pushl $0
  10217b:	6a 00                	push   $0x0
  pushl $106
  10217d:	6a 6a                	push   $0x6a
  jmp __alltraps
  10217f:	e9 2b fc ff ff       	jmp    101daf <__alltraps>

00102184 <vector107>:
.globl vector107
vector107:
  pushl $0
  102184:	6a 00                	push   $0x0
  pushl $107
  102186:	6a 6b                	push   $0x6b
  jmp __alltraps
  102188:	e9 22 fc ff ff       	jmp    101daf <__alltraps>

0010218d <vector108>:
.globl vector108
vector108:
  pushl $0
  10218d:	6a 00                	push   $0x0
  pushl $108
  10218f:	6a 6c                	push   $0x6c
  jmp __alltraps
  102191:	e9 19 fc ff ff       	jmp    101daf <__alltraps>

00102196 <vector109>:
.globl vector109
vector109:
  pushl $0
  102196:	6a 00                	push   $0x0
  pushl $109
  102198:	6a 6d                	push   $0x6d
  jmp __alltraps
  10219a:	e9 10 fc ff ff       	jmp    101daf <__alltraps>

0010219f <vector110>:
.globl vector110
vector110:
  pushl $0
  10219f:	6a 00                	push   $0x0
  pushl $110
  1021a1:	6a 6e                	push   $0x6e
  jmp __alltraps
  1021a3:	e9 07 fc ff ff       	jmp    101daf <__alltraps>

001021a8 <vector111>:
.globl vector111
vector111:
  pushl $0
  1021a8:	6a 00                	push   $0x0
  pushl $111
  1021aa:	6a 6f                	push   $0x6f
  jmp __alltraps
  1021ac:	e9 fe fb ff ff       	jmp    101daf <__alltraps>

001021b1 <vector112>:
.globl vector112
vector112:
  pushl $0
  1021b1:	6a 00                	push   $0x0
  pushl $112
  1021b3:	6a 70                	push   $0x70
  jmp __alltraps
  1021b5:	e9 f5 fb ff ff       	jmp    101daf <__alltraps>

001021ba <vector113>:
.globl vector113
vector113:
  pushl $0
  1021ba:	6a 00                	push   $0x0
  pushl $113
  1021bc:	6a 71                	push   $0x71
  jmp __alltraps
  1021be:	e9 ec fb ff ff       	jmp    101daf <__alltraps>

001021c3 <vector114>:
.globl vector114
vector114:
  pushl $0
  1021c3:	6a 00                	push   $0x0
  pushl $114
  1021c5:	6a 72                	push   $0x72
  jmp __alltraps
  1021c7:	e9 e3 fb ff ff       	jmp    101daf <__alltraps>

001021cc <vector115>:
.globl vector115
vector115:
  pushl $0
  1021cc:	6a 00                	push   $0x0
  pushl $115
  1021ce:	6a 73                	push   $0x73
  jmp __alltraps
  1021d0:	e9 da fb ff ff       	jmp    101daf <__alltraps>

001021d5 <vector116>:
.globl vector116
vector116:
  pushl $0
  1021d5:	6a 00                	push   $0x0
  pushl $116
  1021d7:	6a 74                	push   $0x74
  jmp __alltraps
  1021d9:	e9 d1 fb ff ff       	jmp    101daf <__alltraps>

001021de <vector117>:
.globl vector117
vector117:
  pushl $0
  1021de:	6a 00                	push   $0x0
  pushl $117
  1021e0:	6a 75                	push   $0x75
  jmp __alltraps
  1021e2:	e9 c8 fb ff ff       	jmp    101daf <__alltraps>

001021e7 <vector118>:
.globl vector118
vector118:
  pushl $0
  1021e7:	6a 00                	push   $0x0
  pushl $118
  1021e9:	6a 76                	push   $0x76
  jmp __alltraps
  1021eb:	e9 bf fb ff ff       	jmp    101daf <__alltraps>

001021f0 <vector119>:
.globl vector119
vector119:
  pushl $0
  1021f0:	6a 00                	push   $0x0
  pushl $119
  1021f2:	6a 77                	push   $0x77
  jmp __alltraps
  1021f4:	e9 b6 fb ff ff       	jmp    101daf <__alltraps>

001021f9 <vector120>:
.globl vector120
vector120:
  pushl $0
  1021f9:	6a 00                	push   $0x0
  pushl $120
  1021fb:	6a 78                	push   $0x78
  jmp __alltraps
  1021fd:	e9 ad fb ff ff       	jmp    101daf <__alltraps>

00102202 <vector121>:
.globl vector121
vector121:
  pushl $0
  102202:	6a 00                	push   $0x0
  pushl $121
  102204:	6a 79                	push   $0x79
  jmp __alltraps
  102206:	e9 a4 fb ff ff       	jmp    101daf <__alltraps>

0010220b <vector122>:
.globl vector122
vector122:
  pushl $0
  10220b:	6a 00                	push   $0x0
  pushl $122
  10220d:	6a 7a                	push   $0x7a
  jmp __alltraps
  10220f:	e9 9b fb ff ff       	jmp    101daf <__alltraps>

00102214 <vector123>:
.globl vector123
vector123:
  pushl $0
  102214:	6a 00                	push   $0x0
  pushl $123
  102216:	6a 7b                	push   $0x7b
  jmp __alltraps
  102218:	e9 92 fb ff ff       	jmp    101daf <__alltraps>

0010221d <vector124>:
.globl vector124
vector124:
  pushl $0
  10221d:	6a 00                	push   $0x0
  pushl $124
  10221f:	6a 7c                	push   $0x7c
  jmp __alltraps
  102221:	e9 89 fb ff ff       	jmp    101daf <__alltraps>

00102226 <vector125>:
.globl vector125
vector125:
  pushl $0
  102226:	6a 00                	push   $0x0
  pushl $125
  102228:	6a 7d                	push   $0x7d
  jmp __alltraps
  10222a:	e9 80 fb ff ff       	jmp    101daf <__alltraps>

0010222f <vector126>:
.globl vector126
vector126:
  pushl $0
  10222f:	6a 00                	push   $0x0
  pushl $126
  102231:	6a 7e                	push   $0x7e
  jmp __alltraps
  102233:	e9 77 fb ff ff       	jmp    101daf <__alltraps>

00102238 <vector127>:
.globl vector127
vector127:
  pushl $0
  102238:	6a 00                	push   $0x0
  pushl $127
  10223a:	6a 7f                	push   $0x7f
  jmp __alltraps
  10223c:	e9 6e fb ff ff       	jmp    101daf <__alltraps>

00102241 <vector128>:
.globl vector128
vector128:
  pushl $0
  102241:	6a 00                	push   $0x0
  pushl $128
  102243:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102248:	e9 62 fb ff ff       	jmp    101daf <__alltraps>

0010224d <vector129>:
.globl vector129
vector129:
  pushl $0
  10224d:	6a 00                	push   $0x0
  pushl $129
  10224f:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102254:	e9 56 fb ff ff       	jmp    101daf <__alltraps>

00102259 <vector130>:
.globl vector130
vector130:
  pushl $0
  102259:	6a 00                	push   $0x0
  pushl $130
  10225b:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102260:	e9 4a fb ff ff       	jmp    101daf <__alltraps>

00102265 <vector131>:
.globl vector131
vector131:
  pushl $0
  102265:	6a 00                	push   $0x0
  pushl $131
  102267:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10226c:	e9 3e fb ff ff       	jmp    101daf <__alltraps>

00102271 <vector132>:
.globl vector132
vector132:
  pushl $0
  102271:	6a 00                	push   $0x0
  pushl $132
  102273:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102278:	e9 32 fb ff ff       	jmp    101daf <__alltraps>

0010227d <vector133>:
.globl vector133
vector133:
  pushl $0
  10227d:	6a 00                	push   $0x0
  pushl $133
  10227f:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102284:	e9 26 fb ff ff       	jmp    101daf <__alltraps>

00102289 <vector134>:
.globl vector134
vector134:
  pushl $0
  102289:	6a 00                	push   $0x0
  pushl $134
  10228b:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102290:	e9 1a fb ff ff       	jmp    101daf <__alltraps>

00102295 <vector135>:
.globl vector135
vector135:
  pushl $0
  102295:	6a 00                	push   $0x0
  pushl $135
  102297:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10229c:	e9 0e fb ff ff       	jmp    101daf <__alltraps>

001022a1 <vector136>:
.globl vector136
vector136:
  pushl $0
  1022a1:	6a 00                	push   $0x0
  pushl $136
  1022a3:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1022a8:	e9 02 fb ff ff       	jmp    101daf <__alltraps>

001022ad <vector137>:
.globl vector137
vector137:
  pushl $0
  1022ad:	6a 00                	push   $0x0
  pushl $137
  1022af:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1022b4:	e9 f6 fa ff ff       	jmp    101daf <__alltraps>

001022b9 <vector138>:
.globl vector138
vector138:
  pushl $0
  1022b9:	6a 00                	push   $0x0
  pushl $138
  1022bb:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1022c0:	e9 ea fa ff ff       	jmp    101daf <__alltraps>

001022c5 <vector139>:
.globl vector139
vector139:
  pushl $0
  1022c5:	6a 00                	push   $0x0
  pushl $139
  1022c7:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1022cc:	e9 de fa ff ff       	jmp    101daf <__alltraps>

001022d1 <vector140>:
.globl vector140
vector140:
  pushl $0
  1022d1:	6a 00                	push   $0x0
  pushl $140
  1022d3:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1022d8:	e9 d2 fa ff ff       	jmp    101daf <__alltraps>

001022dd <vector141>:
.globl vector141
vector141:
  pushl $0
  1022dd:	6a 00                	push   $0x0
  pushl $141
  1022df:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1022e4:	e9 c6 fa ff ff       	jmp    101daf <__alltraps>

001022e9 <vector142>:
.globl vector142
vector142:
  pushl $0
  1022e9:	6a 00                	push   $0x0
  pushl $142
  1022eb:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1022f0:	e9 ba fa ff ff       	jmp    101daf <__alltraps>

001022f5 <vector143>:
.globl vector143
vector143:
  pushl $0
  1022f5:	6a 00                	push   $0x0
  pushl $143
  1022f7:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1022fc:	e9 ae fa ff ff       	jmp    101daf <__alltraps>

00102301 <vector144>:
.globl vector144
vector144:
  pushl $0
  102301:	6a 00                	push   $0x0
  pushl $144
  102303:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102308:	e9 a2 fa ff ff       	jmp    101daf <__alltraps>

0010230d <vector145>:
.globl vector145
vector145:
  pushl $0
  10230d:	6a 00                	push   $0x0
  pushl $145
  10230f:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102314:	e9 96 fa ff ff       	jmp    101daf <__alltraps>

00102319 <vector146>:
.globl vector146
vector146:
  pushl $0
  102319:	6a 00                	push   $0x0
  pushl $146
  10231b:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102320:	e9 8a fa ff ff       	jmp    101daf <__alltraps>

00102325 <vector147>:
.globl vector147
vector147:
  pushl $0
  102325:	6a 00                	push   $0x0
  pushl $147
  102327:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10232c:	e9 7e fa ff ff       	jmp    101daf <__alltraps>

00102331 <vector148>:
.globl vector148
vector148:
  pushl $0
  102331:	6a 00                	push   $0x0
  pushl $148
  102333:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102338:	e9 72 fa ff ff       	jmp    101daf <__alltraps>

0010233d <vector149>:
.globl vector149
vector149:
  pushl $0
  10233d:	6a 00                	push   $0x0
  pushl $149
  10233f:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102344:	e9 66 fa ff ff       	jmp    101daf <__alltraps>

00102349 <vector150>:
.globl vector150
vector150:
  pushl $0
  102349:	6a 00                	push   $0x0
  pushl $150
  10234b:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102350:	e9 5a fa ff ff       	jmp    101daf <__alltraps>

00102355 <vector151>:
.globl vector151
vector151:
  pushl $0
  102355:	6a 00                	push   $0x0
  pushl $151
  102357:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10235c:	e9 4e fa ff ff       	jmp    101daf <__alltraps>

00102361 <vector152>:
.globl vector152
vector152:
  pushl $0
  102361:	6a 00                	push   $0x0
  pushl $152
  102363:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102368:	e9 42 fa ff ff       	jmp    101daf <__alltraps>

0010236d <vector153>:
.globl vector153
vector153:
  pushl $0
  10236d:	6a 00                	push   $0x0
  pushl $153
  10236f:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102374:	e9 36 fa ff ff       	jmp    101daf <__alltraps>

00102379 <vector154>:
.globl vector154
vector154:
  pushl $0
  102379:	6a 00                	push   $0x0
  pushl $154
  10237b:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102380:	e9 2a fa ff ff       	jmp    101daf <__alltraps>

00102385 <vector155>:
.globl vector155
vector155:
  pushl $0
  102385:	6a 00                	push   $0x0
  pushl $155
  102387:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10238c:	e9 1e fa ff ff       	jmp    101daf <__alltraps>

00102391 <vector156>:
.globl vector156
vector156:
  pushl $0
  102391:	6a 00                	push   $0x0
  pushl $156
  102393:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102398:	e9 12 fa ff ff       	jmp    101daf <__alltraps>

0010239d <vector157>:
.globl vector157
vector157:
  pushl $0
  10239d:	6a 00                	push   $0x0
  pushl $157
  10239f:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1023a4:	e9 06 fa ff ff       	jmp    101daf <__alltraps>

001023a9 <vector158>:
.globl vector158
vector158:
  pushl $0
  1023a9:	6a 00                	push   $0x0
  pushl $158
  1023ab:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1023b0:	e9 fa f9 ff ff       	jmp    101daf <__alltraps>

001023b5 <vector159>:
.globl vector159
vector159:
  pushl $0
  1023b5:	6a 00                	push   $0x0
  pushl $159
  1023b7:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1023bc:	e9 ee f9 ff ff       	jmp    101daf <__alltraps>

001023c1 <vector160>:
.globl vector160
vector160:
  pushl $0
  1023c1:	6a 00                	push   $0x0
  pushl $160
  1023c3:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1023c8:	e9 e2 f9 ff ff       	jmp    101daf <__alltraps>

001023cd <vector161>:
.globl vector161
vector161:
  pushl $0
  1023cd:	6a 00                	push   $0x0
  pushl $161
  1023cf:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1023d4:	e9 d6 f9 ff ff       	jmp    101daf <__alltraps>

001023d9 <vector162>:
.globl vector162
vector162:
  pushl $0
  1023d9:	6a 00                	push   $0x0
  pushl $162
  1023db:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1023e0:	e9 ca f9 ff ff       	jmp    101daf <__alltraps>

001023e5 <vector163>:
.globl vector163
vector163:
  pushl $0
  1023e5:	6a 00                	push   $0x0
  pushl $163
  1023e7:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1023ec:	e9 be f9 ff ff       	jmp    101daf <__alltraps>

001023f1 <vector164>:
.globl vector164
vector164:
  pushl $0
  1023f1:	6a 00                	push   $0x0
  pushl $164
  1023f3:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1023f8:	e9 b2 f9 ff ff       	jmp    101daf <__alltraps>

001023fd <vector165>:
.globl vector165
vector165:
  pushl $0
  1023fd:	6a 00                	push   $0x0
  pushl $165
  1023ff:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102404:	e9 a6 f9 ff ff       	jmp    101daf <__alltraps>

00102409 <vector166>:
.globl vector166
vector166:
  pushl $0
  102409:	6a 00                	push   $0x0
  pushl $166
  10240b:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102410:	e9 9a f9 ff ff       	jmp    101daf <__alltraps>

00102415 <vector167>:
.globl vector167
vector167:
  pushl $0
  102415:	6a 00                	push   $0x0
  pushl $167
  102417:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10241c:	e9 8e f9 ff ff       	jmp    101daf <__alltraps>

00102421 <vector168>:
.globl vector168
vector168:
  pushl $0
  102421:	6a 00                	push   $0x0
  pushl $168
  102423:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102428:	e9 82 f9 ff ff       	jmp    101daf <__alltraps>

0010242d <vector169>:
.globl vector169
vector169:
  pushl $0
  10242d:	6a 00                	push   $0x0
  pushl $169
  10242f:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102434:	e9 76 f9 ff ff       	jmp    101daf <__alltraps>

00102439 <vector170>:
.globl vector170
vector170:
  pushl $0
  102439:	6a 00                	push   $0x0
  pushl $170
  10243b:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102440:	e9 6a f9 ff ff       	jmp    101daf <__alltraps>

00102445 <vector171>:
.globl vector171
vector171:
  pushl $0
  102445:	6a 00                	push   $0x0
  pushl $171
  102447:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10244c:	e9 5e f9 ff ff       	jmp    101daf <__alltraps>

00102451 <vector172>:
.globl vector172
vector172:
  pushl $0
  102451:	6a 00                	push   $0x0
  pushl $172
  102453:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102458:	e9 52 f9 ff ff       	jmp    101daf <__alltraps>

0010245d <vector173>:
.globl vector173
vector173:
  pushl $0
  10245d:	6a 00                	push   $0x0
  pushl $173
  10245f:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102464:	e9 46 f9 ff ff       	jmp    101daf <__alltraps>

00102469 <vector174>:
.globl vector174
vector174:
  pushl $0
  102469:	6a 00                	push   $0x0
  pushl $174
  10246b:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102470:	e9 3a f9 ff ff       	jmp    101daf <__alltraps>

00102475 <vector175>:
.globl vector175
vector175:
  pushl $0
  102475:	6a 00                	push   $0x0
  pushl $175
  102477:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10247c:	e9 2e f9 ff ff       	jmp    101daf <__alltraps>

00102481 <vector176>:
.globl vector176
vector176:
  pushl $0
  102481:	6a 00                	push   $0x0
  pushl $176
  102483:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102488:	e9 22 f9 ff ff       	jmp    101daf <__alltraps>

0010248d <vector177>:
.globl vector177
vector177:
  pushl $0
  10248d:	6a 00                	push   $0x0
  pushl $177
  10248f:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102494:	e9 16 f9 ff ff       	jmp    101daf <__alltraps>

00102499 <vector178>:
.globl vector178
vector178:
  pushl $0
  102499:	6a 00                	push   $0x0
  pushl $178
  10249b:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1024a0:	e9 0a f9 ff ff       	jmp    101daf <__alltraps>

001024a5 <vector179>:
.globl vector179
vector179:
  pushl $0
  1024a5:	6a 00                	push   $0x0
  pushl $179
  1024a7:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1024ac:	e9 fe f8 ff ff       	jmp    101daf <__alltraps>

001024b1 <vector180>:
.globl vector180
vector180:
  pushl $0
  1024b1:	6a 00                	push   $0x0
  pushl $180
  1024b3:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1024b8:	e9 f2 f8 ff ff       	jmp    101daf <__alltraps>

001024bd <vector181>:
.globl vector181
vector181:
  pushl $0
  1024bd:	6a 00                	push   $0x0
  pushl $181
  1024bf:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1024c4:	e9 e6 f8 ff ff       	jmp    101daf <__alltraps>

001024c9 <vector182>:
.globl vector182
vector182:
  pushl $0
  1024c9:	6a 00                	push   $0x0
  pushl $182
  1024cb:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1024d0:	e9 da f8 ff ff       	jmp    101daf <__alltraps>

001024d5 <vector183>:
.globl vector183
vector183:
  pushl $0
  1024d5:	6a 00                	push   $0x0
  pushl $183
  1024d7:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1024dc:	e9 ce f8 ff ff       	jmp    101daf <__alltraps>

001024e1 <vector184>:
.globl vector184
vector184:
  pushl $0
  1024e1:	6a 00                	push   $0x0
  pushl $184
  1024e3:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1024e8:	e9 c2 f8 ff ff       	jmp    101daf <__alltraps>

001024ed <vector185>:
.globl vector185
vector185:
  pushl $0
  1024ed:	6a 00                	push   $0x0
  pushl $185
  1024ef:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1024f4:	e9 b6 f8 ff ff       	jmp    101daf <__alltraps>

001024f9 <vector186>:
.globl vector186
vector186:
  pushl $0
  1024f9:	6a 00                	push   $0x0
  pushl $186
  1024fb:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102500:	e9 aa f8 ff ff       	jmp    101daf <__alltraps>

00102505 <vector187>:
.globl vector187
vector187:
  pushl $0
  102505:	6a 00                	push   $0x0
  pushl $187
  102507:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10250c:	e9 9e f8 ff ff       	jmp    101daf <__alltraps>

00102511 <vector188>:
.globl vector188
vector188:
  pushl $0
  102511:	6a 00                	push   $0x0
  pushl $188
  102513:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102518:	e9 92 f8 ff ff       	jmp    101daf <__alltraps>

0010251d <vector189>:
.globl vector189
vector189:
  pushl $0
  10251d:	6a 00                	push   $0x0
  pushl $189
  10251f:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102524:	e9 86 f8 ff ff       	jmp    101daf <__alltraps>

00102529 <vector190>:
.globl vector190
vector190:
  pushl $0
  102529:	6a 00                	push   $0x0
  pushl $190
  10252b:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102530:	e9 7a f8 ff ff       	jmp    101daf <__alltraps>

00102535 <vector191>:
.globl vector191
vector191:
  pushl $0
  102535:	6a 00                	push   $0x0
  pushl $191
  102537:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10253c:	e9 6e f8 ff ff       	jmp    101daf <__alltraps>

00102541 <vector192>:
.globl vector192
vector192:
  pushl $0
  102541:	6a 00                	push   $0x0
  pushl $192
  102543:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102548:	e9 62 f8 ff ff       	jmp    101daf <__alltraps>

0010254d <vector193>:
.globl vector193
vector193:
  pushl $0
  10254d:	6a 00                	push   $0x0
  pushl $193
  10254f:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102554:	e9 56 f8 ff ff       	jmp    101daf <__alltraps>

00102559 <vector194>:
.globl vector194
vector194:
  pushl $0
  102559:	6a 00                	push   $0x0
  pushl $194
  10255b:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102560:	e9 4a f8 ff ff       	jmp    101daf <__alltraps>

00102565 <vector195>:
.globl vector195
vector195:
  pushl $0
  102565:	6a 00                	push   $0x0
  pushl $195
  102567:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10256c:	e9 3e f8 ff ff       	jmp    101daf <__alltraps>

00102571 <vector196>:
.globl vector196
vector196:
  pushl $0
  102571:	6a 00                	push   $0x0
  pushl $196
  102573:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102578:	e9 32 f8 ff ff       	jmp    101daf <__alltraps>

0010257d <vector197>:
.globl vector197
vector197:
  pushl $0
  10257d:	6a 00                	push   $0x0
  pushl $197
  10257f:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102584:	e9 26 f8 ff ff       	jmp    101daf <__alltraps>

00102589 <vector198>:
.globl vector198
vector198:
  pushl $0
  102589:	6a 00                	push   $0x0
  pushl $198
  10258b:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102590:	e9 1a f8 ff ff       	jmp    101daf <__alltraps>

00102595 <vector199>:
.globl vector199
vector199:
  pushl $0
  102595:	6a 00                	push   $0x0
  pushl $199
  102597:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10259c:	e9 0e f8 ff ff       	jmp    101daf <__alltraps>

001025a1 <vector200>:
.globl vector200
vector200:
  pushl $0
  1025a1:	6a 00                	push   $0x0
  pushl $200
  1025a3:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1025a8:	e9 02 f8 ff ff       	jmp    101daf <__alltraps>

001025ad <vector201>:
.globl vector201
vector201:
  pushl $0
  1025ad:	6a 00                	push   $0x0
  pushl $201
  1025af:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1025b4:	e9 f6 f7 ff ff       	jmp    101daf <__alltraps>

001025b9 <vector202>:
.globl vector202
vector202:
  pushl $0
  1025b9:	6a 00                	push   $0x0
  pushl $202
  1025bb:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1025c0:	e9 ea f7 ff ff       	jmp    101daf <__alltraps>

001025c5 <vector203>:
.globl vector203
vector203:
  pushl $0
  1025c5:	6a 00                	push   $0x0
  pushl $203
  1025c7:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1025cc:	e9 de f7 ff ff       	jmp    101daf <__alltraps>

001025d1 <vector204>:
.globl vector204
vector204:
  pushl $0
  1025d1:	6a 00                	push   $0x0
  pushl $204
  1025d3:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1025d8:	e9 d2 f7 ff ff       	jmp    101daf <__alltraps>

001025dd <vector205>:
.globl vector205
vector205:
  pushl $0
  1025dd:	6a 00                	push   $0x0
  pushl $205
  1025df:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1025e4:	e9 c6 f7 ff ff       	jmp    101daf <__alltraps>

001025e9 <vector206>:
.globl vector206
vector206:
  pushl $0
  1025e9:	6a 00                	push   $0x0
  pushl $206
  1025eb:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1025f0:	e9 ba f7 ff ff       	jmp    101daf <__alltraps>

001025f5 <vector207>:
.globl vector207
vector207:
  pushl $0
  1025f5:	6a 00                	push   $0x0
  pushl $207
  1025f7:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1025fc:	e9 ae f7 ff ff       	jmp    101daf <__alltraps>

00102601 <vector208>:
.globl vector208
vector208:
  pushl $0
  102601:	6a 00                	push   $0x0
  pushl $208
  102603:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102608:	e9 a2 f7 ff ff       	jmp    101daf <__alltraps>

0010260d <vector209>:
.globl vector209
vector209:
  pushl $0
  10260d:	6a 00                	push   $0x0
  pushl $209
  10260f:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102614:	e9 96 f7 ff ff       	jmp    101daf <__alltraps>

00102619 <vector210>:
.globl vector210
vector210:
  pushl $0
  102619:	6a 00                	push   $0x0
  pushl $210
  10261b:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102620:	e9 8a f7 ff ff       	jmp    101daf <__alltraps>

00102625 <vector211>:
.globl vector211
vector211:
  pushl $0
  102625:	6a 00                	push   $0x0
  pushl $211
  102627:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10262c:	e9 7e f7 ff ff       	jmp    101daf <__alltraps>

00102631 <vector212>:
.globl vector212
vector212:
  pushl $0
  102631:	6a 00                	push   $0x0
  pushl $212
  102633:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102638:	e9 72 f7 ff ff       	jmp    101daf <__alltraps>

0010263d <vector213>:
.globl vector213
vector213:
  pushl $0
  10263d:	6a 00                	push   $0x0
  pushl $213
  10263f:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102644:	e9 66 f7 ff ff       	jmp    101daf <__alltraps>

00102649 <vector214>:
.globl vector214
vector214:
  pushl $0
  102649:	6a 00                	push   $0x0
  pushl $214
  10264b:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102650:	e9 5a f7 ff ff       	jmp    101daf <__alltraps>

00102655 <vector215>:
.globl vector215
vector215:
  pushl $0
  102655:	6a 00                	push   $0x0
  pushl $215
  102657:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10265c:	e9 4e f7 ff ff       	jmp    101daf <__alltraps>

00102661 <vector216>:
.globl vector216
vector216:
  pushl $0
  102661:	6a 00                	push   $0x0
  pushl $216
  102663:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102668:	e9 42 f7 ff ff       	jmp    101daf <__alltraps>

0010266d <vector217>:
.globl vector217
vector217:
  pushl $0
  10266d:	6a 00                	push   $0x0
  pushl $217
  10266f:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102674:	e9 36 f7 ff ff       	jmp    101daf <__alltraps>

00102679 <vector218>:
.globl vector218
vector218:
  pushl $0
  102679:	6a 00                	push   $0x0
  pushl $218
  10267b:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102680:	e9 2a f7 ff ff       	jmp    101daf <__alltraps>

00102685 <vector219>:
.globl vector219
vector219:
  pushl $0
  102685:	6a 00                	push   $0x0
  pushl $219
  102687:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10268c:	e9 1e f7 ff ff       	jmp    101daf <__alltraps>

00102691 <vector220>:
.globl vector220
vector220:
  pushl $0
  102691:	6a 00                	push   $0x0
  pushl $220
  102693:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102698:	e9 12 f7 ff ff       	jmp    101daf <__alltraps>

0010269d <vector221>:
.globl vector221
vector221:
  pushl $0
  10269d:	6a 00                	push   $0x0
  pushl $221
  10269f:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1026a4:	e9 06 f7 ff ff       	jmp    101daf <__alltraps>

001026a9 <vector222>:
.globl vector222
vector222:
  pushl $0
  1026a9:	6a 00                	push   $0x0
  pushl $222
  1026ab:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1026b0:	e9 fa f6 ff ff       	jmp    101daf <__alltraps>

001026b5 <vector223>:
.globl vector223
vector223:
  pushl $0
  1026b5:	6a 00                	push   $0x0
  pushl $223
  1026b7:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1026bc:	e9 ee f6 ff ff       	jmp    101daf <__alltraps>

001026c1 <vector224>:
.globl vector224
vector224:
  pushl $0
  1026c1:	6a 00                	push   $0x0
  pushl $224
  1026c3:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1026c8:	e9 e2 f6 ff ff       	jmp    101daf <__alltraps>

001026cd <vector225>:
.globl vector225
vector225:
  pushl $0
  1026cd:	6a 00                	push   $0x0
  pushl $225
  1026cf:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1026d4:	e9 d6 f6 ff ff       	jmp    101daf <__alltraps>

001026d9 <vector226>:
.globl vector226
vector226:
  pushl $0
  1026d9:	6a 00                	push   $0x0
  pushl $226
  1026db:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1026e0:	e9 ca f6 ff ff       	jmp    101daf <__alltraps>

001026e5 <vector227>:
.globl vector227
vector227:
  pushl $0
  1026e5:	6a 00                	push   $0x0
  pushl $227
  1026e7:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1026ec:	e9 be f6 ff ff       	jmp    101daf <__alltraps>

001026f1 <vector228>:
.globl vector228
vector228:
  pushl $0
  1026f1:	6a 00                	push   $0x0
  pushl $228
  1026f3:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1026f8:	e9 b2 f6 ff ff       	jmp    101daf <__alltraps>

001026fd <vector229>:
.globl vector229
vector229:
  pushl $0
  1026fd:	6a 00                	push   $0x0
  pushl $229
  1026ff:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102704:	e9 a6 f6 ff ff       	jmp    101daf <__alltraps>

00102709 <vector230>:
.globl vector230
vector230:
  pushl $0
  102709:	6a 00                	push   $0x0
  pushl $230
  10270b:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102710:	e9 9a f6 ff ff       	jmp    101daf <__alltraps>

00102715 <vector231>:
.globl vector231
vector231:
  pushl $0
  102715:	6a 00                	push   $0x0
  pushl $231
  102717:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10271c:	e9 8e f6 ff ff       	jmp    101daf <__alltraps>

00102721 <vector232>:
.globl vector232
vector232:
  pushl $0
  102721:	6a 00                	push   $0x0
  pushl $232
  102723:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102728:	e9 82 f6 ff ff       	jmp    101daf <__alltraps>

0010272d <vector233>:
.globl vector233
vector233:
  pushl $0
  10272d:	6a 00                	push   $0x0
  pushl $233
  10272f:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102734:	e9 76 f6 ff ff       	jmp    101daf <__alltraps>

00102739 <vector234>:
.globl vector234
vector234:
  pushl $0
  102739:	6a 00                	push   $0x0
  pushl $234
  10273b:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102740:	e9 6a f6 ff ff       	jmp    101daf <__alltraps>

00102745 <vector235>:
.globl vector235
vector235:
  pushl $0
  102745:	6a 00                	push   $0x0
  pushl $235
  102747:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10274c:	e9 5e f6 ff ff       	jmp    101daf <__alltraps>

00102751 <vector236>:
.globl vector236
vector236:
  pushl $0
  102751:	6a 00                	push   $0x0
  pushl $236
  102753:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102758:	e9 52 f6 ff ff       	jmp    101daf <__alltraps>

0010275d <vector237>:
.globl vector237
vector237:
  pushl $0
  10275d:	6a 00                	push   $0x0
  pushl $237
  10275f:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102764:	e9 46 f6 ff ff       	jmp    101daf <__alltraps>

00102769 <vector238>:
.globl vector238
vector238:
  pushl $0
  102769:	6a 00                	push   $0x0
  pushl $238
  10276b:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102770:	e9 3a f6 ff ff       	jmp    101daf <__alltraps>

00102775 <vector239>:
.globl vector239
vector239:
  pushl $0
  102775:	6a 00                	push   $0x0
  pushl $239
  102777:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10277c:	e9 2e f6 ff ff       	jmp    101daf <__alltraps>

00102781 <vector240>:
.globl vector240
vector240:
  pushl $0
  102781:	6a 00                	push   $0x0
  pushl $240
  102783:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102788:	e9 22 f6 ff ff       	jmp    101daf <__alltraps>

0010278d <vector241>:
.globl vector241
vector241:
  pushl $0
  10278d:	6a 00                	push   $0x0
  pushl $241
  10278f:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102794:	e9 16 f6 ff ff       	jmp    101daf <__alltraps>

00102799 <vector242>:
.globl vector242
vector242:
  pushl $0
  102799:	6a 00                	push   $0x0
  pushl $242
  10279b:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1027a0:	e9 0a f6 ff ff       	jmp    101daf <__alltraps>

001027a5 <vector243>:
.globl vector243
vector243:
  pushl $0
  1027a5:	6a 00                	push   $0x0
  pushl $243
  1027a7:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1027ac:	e9 fe f5 ff ff       	jmp    101daf <__alltraps>

001027b1 <vector244>:
.globl vector244
vector244:
  pushl $0
  1027b1:	6a 00                	push   $0x0
  pushl $244
  1027b3:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1027b8:	e9 f2 f5 ff ff       	jmp    101daf <__alltraps>

001027bd <vector245>:
.globl vector245
vector245:
  pushl $0
  1027bd:	6a 00                	push   $0x0
  pushl $245
  1027bf:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1027c4:	e9 e6 f5 ff ff       	jmp    101daf <__alltraps>

001027c9 <vector246>:
.globl vector246
vector246:
  pushl $0
  1027c9:	6a 00                	push   $0x0
  pushl $246
  1027cb:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1027d0:	e9 da f5 ff ff       	jmp    101daf <__alltraps>

001027d5 <vector247>:
.globl vector247
vector247:
  pushl $0
  1027d5:	6a 00                	push   $0x0
  pushl $247
  1027d7:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1027dc:	e9 ce f5 ff ff       	jmp    101daf <__alltraps>

001027e1 <vector248>:
.globl vector248
vector248:
  pushl $0
  1027e1:	6a 00                	push   $0x0
  pushl $248
  1027e3:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1027e8:	e9 c2 f5 ff ff       	jmp    101daf <__alltraps>

001027ed <vector249>:
.globl vector249
vector249:
  pushl $0
  1027ed:	6a 00                	push   $0x0
  pushl $249
  1027ef:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1027f4:	e9 b6 f5 ff ff       	jmp    101daf <__alltraps>

001027f9 <vector250>:
.globl vector250
vector250:
  pushl $0
  1027f9:	6a 00                	push   $0x0
  pushl $250
  1027fb:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102800:	e9 aa f5 ff ff       	jmp    101daf <__alltraps>

00102805 <vector251>:
.globl vector251
vector251:
  pushl $0
  102805:	6a 00                	push   $0x0
  pushl $251
  102807:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  10280c:	e9 9e f5 ff ff       	jmp    101daf <__alltraps>

00102811 <vector252>:
.globl vector252
vector252:
  pushl $0
  102811:	6a 00                	push   $0x0
  pushl $252
  102813:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102818:	e9 92 f5 ff ff       	jmp    101daf <__alltraps>

0010281d <vector253>:
.globl vector253
vector253:
  pushl $0
  10281d:	6a 00                	push   $0x0
  pushl $253
  10281f:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102824:	e9 86 f5 ff ff       	jmp    101daf <__alltraps>

00102829 <vector254>:
.globl vector254
vector254:
  pushl $0
  102829:	6a 00                	push   $0x0
  pushl $254
  10282b:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102830:	e9 7a f5 ff ff       	jmp    101daf <__alltraps>

00102835 <vector255>:
.globl vector255
vector255:
  pushl $0
  102835:	6a 00                	push   $0x0
  pushl $255
  102837:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10283c:	e9 6e f5 ff ff       	jmp    101daf <__alltraps>

00102841 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102841:	55                   	push   %ebp
  102842:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102844:	8b 55 08             	mov    0x8(%ebp),%edx
  102847:	a1 64 89 11 00       	mov    0x118964,%eax
  10284c:	29 c2                	sub    %eax,%edx
  10284e:	89 d0                	mov    %edx,%eax
  102850:	c1 f8 02             	sar    $0x2,%eax
  102853:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102859:	5d                   	pop    %ebp
  10285a:	c3                   	ret    

0010285b <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  10285b:	55                   	push   %ebp
  10285c:	89 e5                	mov    %esp,%ebp
  10285e:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102861:	8b 45 08             	mov    0x8(%ebp),%eax
  102864:	89 04 24             	mov    %eax,(%esp)
  102867:	e8 d5 ff ff ff       	call   102841 <page2ppn>
  10286c:	c1 e0 0c             	shl    $0xc,%eax
}
  10286f:	c9                   	leave  
  102870:	c3                   	ret    

00102871 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  102871:	55                   	push   %ebp
  102872:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102874:	8b 45 08             	mov    0x8(%ebp),%eax
  102877:	8b 00                	mov    (%eax),%eax
}
  102879:	5d                   	pop    %ebp
  10287a:	c3                   	ret    

0010287b <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  10287b:	55                   	push   %ebp
  10287c:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  10287e:	8b 45 08             	mov    0x8(%ebp),%eax
  102881:	8b 55 0c             	mov    0xc(%ebp),%edx
  102884:	89 10                	mov    %edx,(%eax)
}
  102886:	5d                   	pop    %ebp
  102887:	c3                   	ret    

00102888 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  102888:	55                   	push   %ebp
  102889:	89 e5                	mov    %esp,%ebp
  10288b:	83 ec 10             	sub    $0x10,%esp
  10288e:	c7 45 fc 50 89 11 00 	movl   $0x118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  102895:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102898:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10289b:	89 50 04             	mov    %edx,0x4(%eax)
  10289e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1028a1:	8b 50 04             	mov    0x4(%eax),%edx
  1028a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1028a7:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  1028a9:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  1028b0:	00 00 00 
}
  1028b3:	c9                   	leave  
  1028b4:	c3                   	ret    

001028b5 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  1028b5:	55                   	push   %ebp
  1028b6:	89 e5                	mov    %esp,%ebp
  1028b8:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  1028bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1028bf:	75 24                	jne    1028e5 <default_init_memmap+0x30>
  1028c1:	c7 44 24 0c 10 67 10 	movl   $0x106710,0xc(%esp)
  1028c8:	00 
  1028c9:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  1028d0:	00 
  1028d1:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
  1028d8:	00 
  1028d9:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  1028e0:	e8 e6 e3 ff ff       	call   100ccb <__panic>
    struct Page *p = base;
  1028e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1028e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  1028eb:	eb 7d                	jmp    10296a <default_init_memmap+0xb5>
        assert(PageReserved(p));
  1028ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1028f0:	83 c0 04             	add    $0x4,%eax
  1028f3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1028fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1028fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102900:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102903:	0f a3 10             	bt     %edx,(%eax)
  102906:	19 c0                	sbb    %eax,%eax
  102908:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  10290b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10290f:	0f 95 c0             	setne  %al
  102912:	0f b6 c0             	movzbl %al,%eax
  102915:	85 c0                	test   %eax,%eax
  102917:	75 24                	jne    10293d <default_init_memmap+0x88>
  102919:	c7 44 24 0c 41 67 10 	movl   $0x106741,0xc(%esp)
  102920:	00 
  102921:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  102928:	00 
  102929:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
  102930:	00 
  102931:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  102938:	e8 8e e3 ff ff       	call   100ccb <__panic>
        p->flags = p->property = 0;
  10293d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102940:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  102947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10294a:	8b 50 08             	mov    0x8(%eax),%edx
  10294d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102950:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  102953:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10295a:	00 
  10295b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10295e:	89 04 24             	mov    %eax,(%esp)
  102961:	e8 15 ff ff ff       	call   10287b <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  102966:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  10296a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10296d:	89 d0                	mov    %edx,%eax
  10296f:	c1 e0 02             	shl    $0x2,%eax
  102972:	01 d0                	add    %edx,%eax
  102974:	c1 e0 02             	shl    $0x2,%eax
  102977:	89 c2                	mov    %eax,%edx
  102979:	8b 45 08             	mov    0x8(%ebp),%eax
  10297c:	01 d0                	add    %edx,%eax
  10297e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102981:	0f 85 66 ff ff ff    	jne    1028ed <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
  102987:	8b 45 08             	mov    0x8(%ebp),%eax
  10298a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10298d:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102990:	8b 45 08             	mov    0x8(%ebp),%eax
  102993:	83 c0 04             	add    $0x4,%eax
  102996:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  10299d:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1029a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1029a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1029a6:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
  1029a9:	8b 15 58 89 11 00    	mov    0x118958,%edx
  1029af:	8b 45 0c             	mov    0xc(%ebp),%eax
  1029b2:	01 d0                	add    %edx,%eax
  1029b4:	a3 58 89 11 00       	mov    %eax,0x118958
    list_add(&free_list, &(base->page_link));
  1029b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1029bc:	83 c0 0c             	add    $0xc,%eax
  1029bf:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
  1029c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  1029c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1029cc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1029cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1029d2:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  1029d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1029d8:	8b 40 04             	mov    0x4(%eax),%eax
  1029db:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1029de:	89 55 cc             	mov    %edx,-0x34(%ebp)
  1029e1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1029e4:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1029e7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  1029ea:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1029ed:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1029f0:	89 10                	mov    %edx,(%eax)
  1029f2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1029f5:	8b 10                	mov    (%eax),%edx
  1029f7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1029fa:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1029fd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a00:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102a03:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102a06:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a09:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102a0c:	89 10                	mov    %edx,(%eax)
}
  102a0e:	c9                   	leave  
  102a0f:	c3                   	ret    

00102a10 <default_alloc_pages>:
static struct Page *
default_alloc_pages(size_t n) {
  102a10:	55                   	push   %ebp
  102a11:	89 e5                	mov    %esp,%ebp
  102a13:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  102a16:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102a1a:	75 24                	jne    102a40 <default_alloc_pages+0x30>
  102a1c:	c7 44 24 0c 10 67 10 	movl   $0x106710,0xc(%esp)
  102a23:	00 
  102a24:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  102a2b:	00 
  102a2c:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
  102a33:	00 
  102a34:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  102a3b:	e8 8b e2 ff ff       	call   100ccb <__panic>
    if (n > nr_free) {
  102a40:	a1 58 89 11 00       	mov    0x118958,%eax
  102a45:	3b 45 08             	cmp    0x8(%ebp),%eax
  102a48:	73 0a                	jae    102a54 <default_alloc_pages+0x44>
        return NULL;
  102a4a:	b8 00 00 00 00       	mov    $0x0,%eax
  102a4f:	e9 3d 01 00 00       	jmp    102b91 <default_alloc_pages+0x181>
    }
    struct Page *page = NULL;
  102a54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  102a5b:	c7 45 f0 50 89 11 00 	movl   $0x118950,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  102a62:	eb 1c                	jmp    102a80 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
  102a64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a67:	83 e8 0c             	sub    $0xc,%eax
  102a6a:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
  102a6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102a70:	8b 40 08             	mov    0x8(%eax),%eax
  102a73:	3b 45 08             	cmp    0x8(%ebp),%eax
  102a76:	72 08                	jb     102a80 <default_alloc_pages+0x70>
            page = p;
  102a78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102a7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  102a7e:	eb 18                	jmp    102a98 <default_alloc_pages+0x88>
  102a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a83:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102a86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102a89:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  102a8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102a8f:	81 7d f0 50 89 11 00 	cmpl   $0x118950,-0x10(%ebp)
  102a96:	75 cc                	jne    102a64 <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
  102a98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102a9c:	0f 84 ec 00 00 00    	je     102b8e <default_alloc_pages+0x17e>
        if (page->property > n) {
  102aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102aa5:	8b 40 08             	mov    0x8(%eax),%eax
  102aa8:	3b 45 08             	cmp    0x8(%ebp),%eax
  102aab:	0f 86 8c 00 00 00    	jbe    102b3d <default_alloc_pages+0x12d>
            struct Page *p = page + n;
  102ab1:	8b 55 08             	mov    0x8(%ebp),%edx
  102ab4:	89 d0                	mov    %edx,%eax
  102ab6:	c1 e0 02             	shl    $0x2,%eax
  102ab9:	01 d0                	add    %edx,%eax
  102abb:	c1 e0 02             	shl    $0x2,%eax
  102abe:	89 c2                	mov    %eax,%edx
  102ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ac3:	01 d0                	add    %edx,%eax
  102ac5:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  102ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102acb:	8b 40 08             	mov    0x8(%eax),%eax
  102ace:	2b 45 08             	sub    0x8(%ebp),%eax
  102ad1:	89 c2                	mov    %eax,%edx
  102ad3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ad6:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
  102ad9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102adc:	83 c0 04             	add    $0x4,%eax
  102adf:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  102ae6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  102ae9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102aec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102aef:	0f ab 10             	bts    %edx,(%eax)
            list_add_after(&(page->page_link), &(p->page_link));
  102af2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102af5:	83 c0 0c             	add    $0xc,%eax
  102af8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102afb:	83 c2 0c             	add    $0xc,%edx
  102afe:	89 55 d8             	mov    %edx,-0x28(%ebp)
  102b01:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102b04:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102b07:	8b 40 04             	mov    0x4(%eax),%eax
  102b0a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102b0d:	89 55 d0             	mov    %edx,-0x30(%ebp)
  102b10:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102b13:	89 55 cc             	mov    %edx,-0x34(%ebp)
  102b16:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102b19:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102b1c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102b1f:	89 10                	mov    %edx,(%eax)
  102b21:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102b24:	8b 10                	mov    (%eax),%edx
  102b26:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102b29:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102b2c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102b2f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102b32:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102b35:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102b38:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102b3b:	89 10                	mov    %edx,(%eax)
        }
        list_del(&(page->page_link));
  102b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b40:	83 c0 0c             	add    $0xc,%eax
  102b43:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102b46:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102b49:	8b 40 04             	mov    0x4(%eax),%eax
  102b4c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102b4f:	8b 12                	mov    (%edx),%edx
  102b51:	89 55 c0             	mov    %edx,-0x40(%ebp)
  102b54:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102b57:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102b5a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102b5d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102b60:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102b63:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102b66:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
  102b68:	a1 58 89 11 00       	mov    0x118958,%eax
  102b6d:	2b 45 08             	sub    0x8(%ebp),%eax
  102b70:	a3 58 89 11 00       	mov    %eax,0x118958
        ClearPageProperty(page);
  102b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b78:	83 c0 04             	add    $0x4,%eax
  102b7b:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  102b82:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102b85:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102b88:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102b8b:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
  102b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102b91:	c9                   	leave  
  102b92:	c3                   	ret    

00102b93 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102b93:	55                   	push   %ebp
  102b94:	89 e5                	mov    %esp,%ebp
  102b96:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
  102b9c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102ba0:	75 24                	jne    102bc6 <default_free_pages+0x33>
  102ba2:	c7 44 24 0c 10 67 10 	movl   $0x106710,0xc(%esp)
  102ba9:	00 
  102baa:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  102bb1:	00 
  102bb2:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
  102bb9:	00 
  102bba:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  102bc1:	e8 05 e1 ff ff       	call   100ccb <__panic>
    struct Page *p = base;
  102bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  102bc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102bcc:	e9 9d 00 00 00       	jmp    102c6e <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
  102bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bd4:	83 c0 04             	add    $0x4,%eax
  102bd7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  102bde:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102be1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102be4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102be7:	0f a3 10             	bt     %edx,(%eax)
  102bea:	19 c0                	sbb    %eax,%eax
  102bec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  102bef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102bf3:	0f 95 c0             	setne  %al
  102bf6:	0f b6 c0             	movzbl %al,%eax
  102bf9:	85 c0                	test   %eax,%eax
  102bfb:	75 2c                	jne    102c29 <default_free_pages+0x96>
  102bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c00:	83 c0 04             	add    $0x4,%eax
  102c03:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  102c0a:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102c0d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102c10:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102c13:	0f a3 10             	bt     %edx,(%eax)
  102c16:	19 c0                	sbb    %eax,%eax
  102c18:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  102c1b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  102c1f:	0f 95 c0             	setne  %al
  102c22:	0f b6 c0             	movzbl %al,%eax
  102c25:	85 c0                	test   %eax,%eax
  102c27:	74 24                	je     102c4d <default_free_pages+0xba>
  102c29:	c7 44 24 0c 54 67 10 	movl   $0x106754,0xc(%esp)
  102c30:	00 
  102c31:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  102c38:	00 
  102c39:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
  102c40:	00 
  102c41:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  102c48:	e8 7e e0 ff ff       	call   100ccb <__panic>
        p->flags = 0;
  102c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c50:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  102c57:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102c5e:	00 
  102c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c62:	89 04 24             	mov    %eax,(%esp)
  102c65:	e8 11 fc ff ff       	call   10287b <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  102c6a:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102c6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c71:	89 d0                	mov    %edx,%eax
  102c73:	c1 e0 02             	shl    $0x2,%eax
  102c76:	01 d0                	add    %edx,%eax
  102c78:	c1 e0 02             	shl    $0x2,%eax
  102c7b:	89 c2                	mov    %eax,%edx
  102c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  102c80:	01 d0                	add    %edx,%eax
  102c82:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102c85:	0f 85 46 ff ff ff    	jne    102bd1 <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
  102c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  102c8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c91:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102c94:	8b 45 08             	mov    0x8(%ebp),%eax
  102c97:	83 c0 04             	add    $0x4,%eax
  102c9a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  102ca1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102ca4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102ca7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102caa:	0f ab 10             	bts    %edx,(%eax)
  102cad:	c7 45 cc 50 89 11 00 	movl   $0x118950,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102cb4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102cb7:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  102cba:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  102cbd:	e9 08 01 00 00       	jmp    102dca <default_free_pages+0x237>
        p = le2page(le, page_link);
  102cc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cc5:	83 e8 0c             	sub    $0xc,%eax
  102cc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ccb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cce:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102cd1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102cd4:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  102cd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
  102cda:	8b 45 08             	mov    0x8(%ebp),%eax
  102cdd:	8b 50 08             	mov    0x8(%eax),%edx
  102ce0:	89 d0                	mov    %edx,%eax
  102ce2:	c1 e0 02             	shl    $0x2,%eax
  102ce5:	01 d0                	add    %edx,%eax
  102ce7:	c1 e0 02             	shl    $0x2,%eax
  102cea:	89 c2                	mov    %eax,%edx
  102cec:	8b 45 08             	mov    0x8(%ebp),%eax
  102cef:	01 d0                	add    %edx,%eax
  102cf1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102cf4:	75 5a                	jne    102d50 <default_free_pages+0x1bd>
            base->property += p->property;
  102cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  102cf9:	8b 50 08             	mov    0x8(%eax),%edx
  102cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cff:	8b 40 08             	mov    0x8(%eax),%eax
  102d02:	01 c2                	add    %eax,%edx
  102d04:	8b 45 08             	mov    0x8(%ebp),%eax
  102d07:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  102d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d0d:	83 c0 04             	add    $0x4,%eax
  102d10:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  102d17:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102d1a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102d1d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102d20:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
  102d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d26:	83 c0 0c             	add    $0xc,%eax
  102d29:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102d2c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102d2f:	8b 40 04             	mov    0x4(%eax),%eax
  102d32:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102d35:	8b 12                	mov    (%edx),%edx
  102d37:	89 55 b8             	mov    %edx,-0x48(%ebp)
  102d3a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102d3d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102d40:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102d43:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102d46:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102d49:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102d4c:	89 10                	mov    %edx,(%eax)
  102d4e:	eb 7a                	jmp    102dca <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
  102d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d53:	8b 50 08             	mov    0x8(%eax),%edx
  102d56:	89 d0                	mov    %edx,%eax
  102d58:	c1 e0 02             	shl    $0x2,%eax
  102d5b:	01 d0                	add    %edx,%eax
  102d5d:	c1 e0 02             	shl    $0x2,%eax
  102d60:	89 c2                	mov    %eax,%edx
  102d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d65:	01 d0                	add    %edx,%eax
  102d67:	3b 45 08             	cmp    0x8(%ebp),%eax
  102d6a:	75 5e                	jne    102dca <default_free_pages+0x237>
            p->property += base->property;
  102d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d6f:	8b 50 08             	mov    0x8(%eax),%edx
  102d72:	8b 45 08             	mov    0x8(%ebp),%eax
  102d75:	8b 40 08             	mov    0x8(%eax),%eax
  102d78:	01 c2                	add    %eax,%edx
  102d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d7d:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  102d80:	8b 45 08             	mov    0x8(%ebp),%eax
  102d83:	83 c0 04             	add    $0x4,%eax
  102d86:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
  102d8d:	89 45 ac             	mov    %eax,-0x54(%ebp)
  102d90:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102d93:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102d96:	0f b3 10             	btr    %edx,(%eax)
            base = p;
  102d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d9c:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  102d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102da2:	83 c0 0c             	add    $0xc,%eax
  102da5:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102da8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102dab:	8b 40 04             	mov    0x4(%eax),%eax
  102dae:	8b 55 a8             	mov    -0x58(%ebp),%edx
  102db1:	8b 12                	mov    (%edx),%edx
  102db3:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  102db6:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102db9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102dbc:	8b 55 a0             	mov    -0x60(%ebp),%edx
  102dbf:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102dc2:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102dc5:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102dc8:	89 10                	mov    %edx,(%eax)
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
  102dca:	81 7d f0 50 89 11 00 	cmpl   $0x118950,-0x10(%ebp)
  102dd1:	0f 85 eb fe ff ff    	jne    102cc2 <default_free_pages+0x12f>
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
  102dd7:	8b 15 58 89 11 00    	mov    0x118958,%edx
  102ddd:	8b 45 0c             	mov    0xc(%ebp),%eax
  102de0:	01 d0                	add    %edx,%eax
  102de2:	a3 58 89 11 00       	mov    %eax,0x118958
  102de7:	c7 45 9c 50 89 11 00 	movl   $0x118950,-0x64(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102dee:	8b 45 9c             	mov    -0x64(%ebp),%eax
  102df1:	8b 40 04             	mov    0x4(%eax),%eax

    le = list_next(&free_list);
  102df4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  102df7:	eb 36                	jmp    102e2f <default_free_pages+0x29c>
        p = le2page(le, page_link);
  102df9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dfc:	83 e8 0c             	sub    $0xc,%eax
  102dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if(base + base->property <= p)
  102e02:	8b 45 08             	mov    0x8(%ebp),%eax
  102e05:	8b 50 08             	mov    0x8(%eax),%edx
  102e08:	89 d0                	mov    %edx,%eax
  102e0a:	c1 e0 02             	shl    $0x2,%eax
  102e0d:	01 d0                	add    %edx,%eax
  102e0f:	c1 e0 02             	shl    $0x2,%eax
  102e12:	89 c2                	mov    %eax,%edx
  102e14:	8b 45 08             	mov    0x8(%ebp),%eax
  102e17:	01 d0                	add    %edx,%eax
  102e19:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102e1c:	77 02                	ja     102e20 <default_free_pages+0x28d>
        	break;
  102e1e:	eb 18                	jmp    102e38 <default_free_pages+0x2a5>
  102e20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e23:	89 45 98             	mov    %eax,-0x68(%ebp)
  102e26:	8b 45 98             	mov    -0x68(%ebp),%eax
  102e29:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  102e2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
    }
    nr_free += n;

    le = list_next(&free_list);
    while (le != &free_list) {
  102e2f:	81 7d f0 50 89 11 00 	cmpl   $0x118950,-0x10(%ebp)
  102e36:	75 c1                	jne    102df9 <default_free_pages+0x266>
        p = le2page(le, page_link);
        if(base + base->property <= p)
        	break;
        le = list_next(le);
    }
    list_add_before(le, &(base->page_link));
  102e38:	8b 45 08             	mov    0x8(%ebp),%eax
  102e3b:	8d 50 0c             	lea    0xc(%eax),%edx
  102e3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e41:	89 45 94             	mov    %eax,-0x6c(%ebp)
  102e44:	89 55 90             	mov    %edx,-0x70(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102e47:	8b 45 94             	mov    -0x6c(%ebp),%eax
  102e4a:	8b 00                	mov    (%eax),%eax
  102e4c:	8b 55 90             	mov    -0x70(%ebp),%edx
  102e4f:	89 55 8c             	mov    %edx,-0x74(%ebp)
  102e52:	89 45 88             	mov    %eax,-0x78(%ebp)
  102e55:	8b 45 94             	mov    -0x6c(%ebp),%eax
  102e58:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102e5b:	8b 45 84             	mov    -0x7c(%ebp),%eax
  102e5e:	8b 55 8c             	mov    -0x74(%ebp),%edx
  102e61:	89 10                	mov    %edx,(%eax)
  102e63:	8b 45 84             	mov    -0x7c(%ebp),%eax
  102e66:	8b 10                	mov    (%eax),%edx
  102e68:	8b 45 88             	mov    -0x78(%ebp),%eax
  102e6b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102e6e:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102e71:	8b 55 84             	mov    -0x7c(%ebp),%edx
  102e74:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102e77:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102e7a:	8b 55 88             	mov    -0x78(%ebp),%edx
  102e7d:	89 10                	mov    %edx,(%eax)
}
  102e7f:	c9                   	leave  
  102e80:	c3                   	ret    

00102e81 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  102e81:	55                   	push   %ebp
  102e82:	89 e5                	mov    %esp,%ebp
    return nr_free;
  102e84:	a1 58 89 11 00       	mov    0x118958,%eax
}
  102e89:	5d                   	pop    %ebp
  102e8a:	c3                   	ret    

00102e8b <basic_check>:

static void
basic_check(void) {
  102e8b:	55                   	push   %ebp
  102e8c:	89 e5                	mov    %esp,%ebp
  102e8e:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  102e91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ea1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  102ea4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102eab:	e8 9d 0e 00 00       	call   103d4d <alloc_pages>
  102eb0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102eb3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102eb7:	75 24                	jne    102edd <basic_check+0x52>
  102eb9:	c7 44 24 0c 79 67 10 	movl   $0x106779,0xc(%esp)
  102ec0:	00 
  102ec1:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  102ec8:	00 
  102ec9:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
  102ed0:	00 
  102ed1:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  102ed8:	e8 ee dd ff ff       	call   100ccb <__panic>
    assert((p1 = alloc_page()) != NULL);
  102edd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102ee4:	e8 64 0e 00 00       	call   103d4d <alloc_pages>
  102ee9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102eec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102ef0:	75 24                	jne    102f16 <basic_check+0x8b>
  102ef2:	c7 44 24 0c 95 67 10 	movl   $0x106795,0xc(%esp)
  102ef9:	00 
  102efa:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  102f01:	00 
  102f02:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
  102f09:	00 
  102f0a:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  102f11:	e8 b5 dd ff ff       	call   100ccb <__panic>
    assert((p2 = alloc_page()) != NULL);
  102f16:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102f1d:	e8 2b 0e 00 00       	call   103d4d <alloc_pages>
  102f22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102f29:	75 24                	jne    102f4f <basic_check+0xc4>
  102f2b:	c7 44 24 0c b1 67 10 	movl   $0x1067b1,0xc(%esp)
  102f32:	00 
  102f33:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  102f3a:	00 
  102f3b:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
  102f42:	00 
  102f43:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  102f4a:	e8 7c dd ff ff       	call   100ccb <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  102f4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f52:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102f55:	74 10                	je     102f67 <basic_check+0xdc>
  102f57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f5a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102f5d:	74 08                	je     102f67 <basic_check+0xdc>
  102f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f62:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102f65:	75 24                	jne    102f8b <basic_check+0x100>
  102f67:	c7 44 24 0c d0 67 10 	movl   $0x1067d0,0xc(%esp)
  102f6e:	00 
  102f6f:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  102f76:	00 
  102f77:	c7 44 24 04 a3 00 00 	movl   $0xa3,0x4(%esp)
  102f7e:	00 
  102f7f:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  102f86:	e8 40 dd ff ff       	call   100ccb <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  102f8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f8e:	89 04 24             	mov    %eax,(%esp)
  102f91:	e8 db f8 ff ff       	call   102871 <page_ref>
  102f96:	85 c0                	test   %eax,%eax
  102f98:	75 1e                	jne    102fb8 <basic_check+0x12d>
  102f9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f9d:	89 04 24             	mov    %eax,(%esp)
  102fa0:	e8 cc f8 ff ff       	call   102871 <page_ref>
  102fa5:	85 c0                	test   %eax,%eax
  102fa7:	75 0f                	jne    102fb8 <basic_check+0x12d>
  102fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102fac:	89 04 24             	mov    %eax,(%esp)
  102faf:	e8 bd f8 ff ff       	call   102871 <page_ref>
  102fb4:	85 c0                	test   %eax,%eax
  102fb6:	74 24                	je     102fdc <basic_check+0x151>
  102fb8:	c7 44 24 0c f4 67 10 	movl   $0x1067f4,0xc(%esp)
  102fbf:	00 
  102fc0:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  102fc7:	00 
  102fc8:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
  102fcf:	00 
  102fd0:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  102fd7:	e8 ef dc ff ff       	call   100ccb <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  102fdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fdf:	89 04 24             	mov    %eax,(%esp)
  102fe2:	e8 74 f8 ff ff       	call   10285b <page2pa>
  102fe7:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102fed:	c1 e2 0c             	shl    $0xc,%edx
  102ff0:	39 d0                	cmp    %edx,%eax
  102ff2:	72 24                	jb     103018 <basic_check+0x18d>
  102ff4:	c7 44 24 0c 30 68 10 	movl   $0x106830,0xc(%esp)
  102ffb:	00 
  102ffc:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  103003:	00 
  103004:	c7 44 24 04 a6 00 00 	movl   $0xa6,0x4(%esp)
  10300b:	00 
  10300c:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  103013:	e8 b3 dc ff ff       	call   100ccb <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  103018:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10301b:	89 04 24             	mov    %eax,(%esp)
  10301e:	e8 38 f8 ff ff       	call   10285b <page2pa>
  103023:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  103029:	c1 e2 0c             	shl    $0xc,%edx
  10302c:	39 d0                	cmp    %edx,%eax
  10302e:	72 24                	jb     103054 <basic_check+0x1c9>
  103030:	c7 44 24 0c 4d 68 10 	movl   $0x10684d,0xc(%esp)
  103037:	00 
  103038:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  10303f:	00 
  103040:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
  103047:	00 
  103048:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  10304f:	e8 77 dc ff ff       	call   100ccb <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  103054:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103057:	89 04 24             	mov    %eax,(%esp)
  10305a:	e8 fc f7 ff ff       	call   10285b <page2pa>
  10305f:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  103065:	c1 e2 0c             	shl    $0xc,%edx
  103068:	39 d0                	cmp    %edx,%eax
  10306a:	72 24                	jb     103090 <basic_check+0x205>
  10306c:	c7 44 24 0c 6a 68 10 	movl   $0x10686a,0xc(%esp)
  103073:	00 
  103074:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  10307b:	00 
  10307c:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  103083:	00 
  103084:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  10308b:	e8 3b dc ff ff       	call   100ccb <__panic>

    list_entry_t free_list_store = free_list;
  103090:	a1 50 89 11 00       	mov    0x118950,%eax
  103095:	8b 15 54 89 11 00    	mov    0x118954,%edx
  10309b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10309e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1030a1:	c7 45 e0 50 89 11 00 	movl   $0x118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1030a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1030ab:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1030ae:	89 50 04             	mov    %edx,0x4(%eax)
  1030b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1030b4:	8b 50 04             	mov    0x4(%eax),%edx
  1030b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1030ba:	89 10                	mov    %edx,(%eax)
  1030bc:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  1030c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1030c6:	8b 40 04             	mov    0x4(%eax),%eax
  1030c9:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1030cc:	0f 94 c0             	sete   %al
  1030cf:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1030d2:	85 c0                	test   %eax,%eax
  1030d4:	75 24                	jne    1030fa <basic_check+0x26f>
  1030d6:	c7 44 24 0c 87 68 10 	movl   $0x106887,0xc(%esp)
  1030dd:	00 
  1030de:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  1030e5:	00 
  1030e6:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  1030ed:	00 
  1030ee:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  1030f5:	e8 d1 db ff ff       	call   100ccb <__panic>

    unsigned int nr_free_store = nr_free;
  1030fa:	a1 58 89 11 00       	mov    0x118958,%eax
  1030ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  103102:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  103109:	00 00 00 

    assert(alloc_page() == NULL);
  10310c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103113:	e8 35 0c 00 00       	call   103d4d <alloc_pages>
  103118:	85 c0                	test   %eax,%eax
  10311a:	74 24                	je     103140 <basic_check+0x2b5>
  10311c:	c7 44 24 0c 9e 68 10 	movl   $0x10689e,0xc(%esp)
  103123:	00 
  103124:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  10312b:	00 
  10312c:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  103133:	00 
  103134:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  10313b:	e8 8b db ff ff       	call   100ccb <__panic>

    free_page(p0);
  103140:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103147:	00 
  103148:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10314b:	89 04 24             	mov    %eax,(%esp)
  10314e:	e8 32 0c 00 00       	call   103d85 <free_pages>
    free_page(p1);
  103153:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10315a:	00 
  10315b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10315e:	89 04 24             	mov    %eax,(%esp)
  103161:	e8 1f 0c 00 00       	call   103d85 <free_pages>
    free_page(p2);
  103166:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10316d:	00 
  10316e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103171:	89 04 24             	mov    %eax,(%esp)
  103174:	e8 0c 0c 00 00       	call   103d85 <free_pages>
    assert(nr_free == 3);
  103179:	a1 58 89 11 00       	mov    0x118958,%eax
  10317e:	83 f8 03             	cmp    $0x3,%eax
  103181:	74 24                	je     1031a7 <basic_check+0x31c>
  103183:	c7 44 24 0c b3 68 10 	movl   $0x1068b3,0xc(%esp)
  10318a:	00 
  10318b:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  103192:	00 
  103193:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
  10319a:	00 
  10319b:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  1031a2:	e8 24 db ff ff       	call   100ccb <__panic>

    assert((p0 = alloc_page()) != NULL);
  1031a7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031ae:	e8 9a 0b 00 00       	call   103d4d <alloc_pages>
  1031b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1031b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1031ba:	75 24                	jne    1031e0 <basic_check+0x355>
  1031bc:	c7 44 24 0c 79 67 10 	movl   $0x106779,0xc(%esp)
  1031c3:	00 
  1031c4:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  1031cb:	00 
  1031cc:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
  1031d3:	00 
  1031d4:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  1031db:	e8 eb da ff ff       	call   100ccb <__panic>
    assert((p1 = alloc_page()) != NULL);
  1031e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031e7:	e8 61 0b 00 00       	call   103d4d <alloc_pages>
  1031ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1031ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1031f3:	75 24                	jne    103219 <basic_check+0x38e>
  1031f5:	c7 44 24 0c 95 67 10 	movl   $0x106795,0xc(%esp)
  1031fc:	00 
  1031fd:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  103204:	00 
  103205:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
  10320c:	00 
  10320d:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  103214:	e8 b2 da ff ff       	call   100ccb <__panic>
    assert((p2 = alloc_page()) != NULL);
  103219:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103220:	e8 28 0b 00 00       	call   103d4d <alloc_pages>
  103225:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103228:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10322c:	75 24                	jne    103252 <basic_check+0x3c7>
  10322e:	c7 44 24 0c b1 67 10 	movl   $0x1067b1,0xc(%esp)
  103235:	00 
  103236:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  10323d:	00 
  10323e:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
  103245:	00 
  103246:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  10324d:	e8 79 da ff ff       	call   100ccb <__panic>

    assert(alloc_page() == NULL);
  103252:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103259:	e8 ef 0a 00 00       	call   103d4d <alloc_pages>
  10325e:	85 c0                	test   %eax,%eax
  103260:	74 24                	je     103286 <basic_check+0x3fb>
  103262:	c7 44 24 0c 9e 68 10 	movl   $0x10689e,0xc(%esp)
  103269:	00 
  10326a:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  103271:	00 
  103272:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
  103279:	00 
  10327a:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  103281:	e8 45 da ff ff       	call   100ccb <__panic>

    free_page(p0);
  103286:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10328d:	00 
  10328e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103291:	89 04 24             	mov    %eax,(%esp)
  103294:	e8 ec 0a 00 00       	call   103d85 <free_pages>
  103299:	c7 45 d8 50 89 11 00 	movl   $0x118950,-0x28(%ebp)
  1032a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1032a3:	8b 40 04             	mov    0x4(%eax),%eax
  1032a6:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  1032a9:	0f 94 c0             	sete   %al
  1032ac:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  1032af:	85 c0                	test   %eax,%eax
  1032b1:	74 24                	je     1032d7 <basic_check+0x44c>
  1032b3:	c7 44 24 0c c0 68 10 	movl   $0x1068c0,0xc(%esp)
  1032ba:	00 
  1032bb:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  1032c2:	00 
  1032c3:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
  1032ca:	00 
  1032cb:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  1032d2:	e8 f4 d9 ff ff       	call   100ccb <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  1032d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032de:	e8 6a 0a 00 00       	call   103d4d <alloc_pages>
  1032e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1032e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1032e9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1032ec:	74 24                	je     103312 <basic_check+0x487>
  1032ee:	c7 44 24 0c d8 68 10 	movl   $0x1068d8,0xc(%esp)
  1032f5:	00 
  1032f6:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  1032fd:	00 
  1032fe:	c7 44 24 04 c2 00 00 	movl   $0xc2,0x4(%esp)
  103305:	00 
  103306:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  10330d:	e8 b9 d9 ff ff       	call   100ccb <__panic>
    assert(alloc_page() == NULL);
  103312:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103319:	e8 2f 0a 00 00       	call   103d4d <alloc_pages>
  10331e:	85 c0                	test   %eax,%eax
  103320:	74 24                	je     103346 <basic_check+0x4bb>
  103322:	c7 44 24 0c 9e 68 10 	movl   $0x10689e,0xc(%esp)
  103329:	00 
  10332a:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  103331:	00 
  103332:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
  103339:	00 
  10333a:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  103341:	e8 85 d9 ff ff       	call   100ccb <__panic>

    assert(nr_free == 0);
  103346:	a1 58 89 11 00       	mov    0x118958,%eax
  10334b:	85 c0                	test   %eax,%eax
  10334d:	74 24                	je     103373 <basic_check+0x4e8>
  10334f:	c7 44 24 0c f1 68 10 	movl   $0x1068f1,0xc(%esp)
  103356:	00 
  103357:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  10335e:	00 
  10335f:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
  103366:	00 
  103367:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  10336e:	e8 58 d9 ff ff       	call   100ccb <__panic>
    free_list = free_list_store;
  103373:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103376:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103379:	a3 50 89 11 00       	mov    %eax,0x118950
  10337e:	89 15 54 89 11 00    	mov    %edx,0x118954
    nr_free = nr_free_store;
  103384:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103387:	a3 58 89 11 00       	mov    %eax,0x118958

    free_page(p);
  10338c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103393:	00 
  103394:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103397:	89 04 24             	mov    %eax,(%esp)
  10339a:	e8 e6 09 00 00       	call   103d85 <free_pages>
    free_page(p1);
  10339f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1033a6:	00 
  1033a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033aa:	89 04 24             	mov    %eax,(%esp)
  1033ad:	e8 d3 09 00 00       	call   103d85 <free_pages>
    free_page(p2);
  1033b2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1033b9:	00 
  1033ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033bd:	89 04 24             	mov    %eax,(%esp)
  1033c0:	e8 c0 09 00 00       	call   103d85 <free_pages>
}
  1033c5:	c9                   	leave  
  1033c6:	c3                   	ret    

001033c7 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  1033c7:	55                   	push   %ebp
  1033c8:	89 e5                	mov    %esp,%ebp
  1033ca:	53                   	push   %ebx
  1033cb:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  1033d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1033d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  1033df:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1033e6:	eb 6b                	jmp    103453 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  1033e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033eb:	83 e8 0c             	sub    $0xc,%eax
  1033ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  1033f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033f4:	83 c0 04             	add    $0x4,%eax
  1033f7:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1033fe:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103401:	8b 45 cc             	mov    -0x34(%ebp),%eax
  103404:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103407:	0f a3 10             	bt     %edx,(%eax)
  10340a:	19 c0                	sbb    %eax,%eax
  10340c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  10340f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  103413:	0f 95 c0             	setne  %al
  103416:	0f b6 c0             	movzbl %al,%eax
  103419:	85 c0                	test   %eax,%eax
  10341b:	75 24                	jne    103441 <default_check+0x7a>
  10341d:	c7 44 24 0c fe 68 10 	movl   $0x1068fe,0xc(%esp)
  103424:	00 
  103425:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  10342c:	00 
  10342d:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
  103434:	00 
  103435:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  10343c:	e8 8a d8 ff ff       	call   100ccb <__panic>
        count ++, total += p->property;
  103441:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  103445:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103448:	8b 50 08             	mov    0x8(%eax),%edx
  10344b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10344e:	01 d0                	add    %edx,%eax
  103450:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103453:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103456:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103459:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10345c:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  10345f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103462:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  103469:	0f 85 79 ff ff ff    	jne    1033e8 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  10346f:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  103472:	e8 40 09 00 00       	call   103db7 <nr_free_pages>
  103477:	39 c3                	cmp    %eax,%ebx
  103479:	74 24                	je     10349f <default_check+0xd8>
  10347b:	c7 44 24 0c 0e 69 10 	movl   $0x10690e,0xc(%esp)
  103482:	00 
  103483:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  10348a:	00 
  10348b:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  103492:	00 
  103493:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  10349a:	e8 2c d8 ff ff       	call   100ccb <__panic>

    basic_check();
  10349f:	e8 e7 f9 ff ff       	call   102e8b <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  1034a4:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1034ab:	e8 9d 08 00 00       	call   103d4d <alloc_pages>
  1034b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  1034b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1034b7:	75 24                	jne    1034dd <default_check+0x116>
  1034b9:	c7 44 24 0c 27 69 10 	movl   $0x106927,0xc(%esp)
  1034c0:	00 
  1034c1:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  1034c8:	00 
  1034c9:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
  1034d0:	00 
  1034d1:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  1034d8:	e8 ee d7 ff ff       	call   100ccb <__panic>
    assert(!PageProperty(p0));
  1034dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1034e0:	83 c0 04             	add    $0x4,%eax
  1034e3:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  1034ea:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1034ed:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1034f0:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1034f3:	0f a3 10             	bt     %edx,(%eax)
  1034f6:	19 c0                	sbb    %eax,%eax
  1034f8:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  1034fb:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  1034ff:	0f 95 c0             	setne  %al
  103502:	0f b6 c0             	movzbl %al,%eax
  103505:	85 c0                	test   %eax,%eax
  103507:	74 24                	je     10352d <default_check+0x166>
  103509:	c7 44 24 0c 32 69 10 	movl   $0x106932,0xc(%esp)
  103510:	00 
  103511:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  103518:	00 
  103519:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
  103520:	00 
  103521:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  103528:	e8 9e d7 ff ff       	call   100ccb <__panic>

    list_entry_t free_list_store = free_list;
  10352d:	a1 50 89 11 00       	mov    0x118950,%eax
  103532:	8b 15 54 89 11 00    	mov    0x118954,%edx
  103538:	89 45 80             	mov    %eax,-0x80(%ebp)
  10353b:	89 55 84             	mov    %edx,-0x7c(%ebp)
  10353e:	c7 45 b4 50 89 11 00 	movl   $0x118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  103545:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103548:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  10354b:	89 50 04             	mov    %edx,0x4(%eax)
  10354e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103551:	8b 50 04             	mov    0x4(%eax),%edx
  103554:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103557:	89 10                	mov    %edx,(%eax)
  103559:	c7 45 b0 50 89 11 00 	movl   $0x118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  103560:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103563:	8b 40 04             	mov    0x4(%eax),%eax
  103566:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  103569:	0f 94 c0             	sete   %al
  10356c:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10356f:	85 c0                	test   %eax,%eax
  103571:	75 24                	jne    103597 <default_check+0x1d0>
  103573:	c7 44 24 0c 87 68 10 	movl   $0x106887,0xc(%esp)
  10357a:	00 
  10357b:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  103582:	00 
  103583:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  10358a:	00 
  10358b:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  103592:	e8 34 d7 ff ff       	call   100ccb <__panic>
    assert(alloc_page() == NULL);
  103597:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10359e:	e8 aa 07 00 00       	call   103d4d <alloc_pages>
  1035a3:	85 c0                	test   %eax,%eax
  1035a5:	74 24                	je     1035cb <default_check+0x204>
  1035a7:	c7 44 24 0c 9e 68 10 	movl   $0x10689e,0xc(%esp)
  1035ae:	00 
  1035af:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  1035b6:	00 
  1035b7:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  1035be:	00 
  1035bf:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  1035c6:	e8 00 d7 ff ff       	call   100ccb <__panic>

    unsigned int nr_free_store = nr_free;
  1035cb:	a1 58 89 11 00       	mov    0x118958,%eax
  1035d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  1035d3:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  1035da:	00 00 00 

    free_pages(p0 + 2, 3);
  1035dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035e0:	83 c0 28             	add    $0x28,%eax
  1035e3:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1035ea:	00 
  1035eb:	89 04 24             	mov    %eax,(%esp)
  1035ee:	e8 92 07 00 00       	call   103d85 <free_pages>
    assert(alloc_pages(4) == NULL);
  1035f3:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1035fa:	e8 4e 07 00 00       	call   103d4d <alloc_pages>
  1035ff:	85 c0                	test   %eax,%eax
  103601:	74 24                	je     103627 <default_check+0x260>
  103603:	c7 44 24 0c 44 69 10 	movl   $0x106944,0xc(%esp)
  10360a:	00 
  10360b:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  103612:	00 
  103613:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
  10361a:	00 
  10361b:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  103622:	e8 a4 d6 ff ff       	call   100ccb <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  103627:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10362a:	83 c0 28             	add    $0x28,%eax
  10362d:	83 c0 04             	add    $0x4,%eax
  103630:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  103637:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10363a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10363d:	8b 55 ac             	mov    -0x54(%ebp),%edx
  103640:	0f a3 10             	bt     %edx,(%eax)
  103643:	19 c0                	sbb    %eax,%eax
  103645:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  103648:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  10364c:	0f 95 c0             	setne  %al
  10364f:	0f b6 c0             	movzbl %al,%eax
  103652:	85 c0                	test   %eax,%eax
  103654:	74 0e                	je     103664 <default_check+0x29d>
  103656:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103659:	83 c0 28             	add    $0x28,%eax
  10365c:	8b 40 08             	mov    0x8(%eax),%eax
  10365f:	83 f8 03             	cmp    $0x3,%eax
  103662:	74 24                	je     103688 <default_check+0x2c1>
  103664:	c7 44 24 0c 5c 69 10 	movl   $0x10695c,0xc(%esp)
  10366b:	00 
  10366c:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  103673:	00 
  103674:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  10367b:	00 
  10367c:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  103683:	e8 43 d6 ff ff       	call   100ccb <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  103688:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  10368f:	e8 b9 06 00 00       	call   103d4d <alloc_pages>
  103694:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103697:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10369b:	75 24                	jne    1036c1 <default_check+0x2fa>
  10369d:	c7 44 24 0c 88 69 10 	movl   $0x106988,0xc(%esp)
  1036a4:	00 
  1036a5:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  1036ac:	00 
  1036ad:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
  1036b4:	00 
  1036b5:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  1036bc:	e8 0a d6 ff ff       	call   100ccb <__panic>
    assert(alloc_page() == NULL);
  1036c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1036c8:	e8 80 06 00 00       	call   103d4d <alloc_pages>
  1036cd:	85 c0                	test   %eax,%eax
  1036cf:	74 24                	je     1036f5 <default_check+0x32e>
  1036d1:	c7 44 24 0c 9e 68 10 	movl   $0x10689e,0xc(%esp)
  1036d8:	00 
  1036d9:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  1036e0:	00 
  1036e1:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  1036e8:	00 
  1036e9:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  1036f0:	e8 d6 d5 ff ff       	call   100ccb <__panic>
    assert(p0 + 2 == p1);
  1036f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036f8:	83 c0 28             	add    $0x28,%eax
  1036fb:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  1036fe:	74 24                	je     103724 <default_check+0x35d>
  103700:	c7 44 24 0c a6 69 10 	movl   $0x1069a6,0xc(%esp)
  103707:	00 
  103708:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  10370f:	00 
  103710:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  103717:	00 
  103718:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  10371f:	e8 a7 d5 ff ff       	call   100ccb <__panic>

    p2 = p0 + 1;
  103724:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103727:	83 c0 14             	add    $0x14,%eax
  10372a:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  10372d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103734:	00 
  103735:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103738:	89 04 24             	mov    %eax,(%esp)
  10373b:	e8 45 06 00 00       	call   103d85 <free_pages>
    free_pages(p1, 3);
  103740:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103747:	00 
  103748:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10374b:	89 04 24             	mov    %eax,(%esp)
  10374e:	e8 32 06 00 00       	call   103d85 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  103753:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103756:	83 c0 04             	add    $0x4,%eax
  103759:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  103760:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103763:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103766:	8b 55 a0             	mov    -0x60(%ebp),%edx
  103769:	0f a3 10             	bt     %edx,(%eax)
  10376c:	19 c0                	sbb    %eax,%eax
  10376e:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  103771:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  103775:	0f 95 c0             	setne  %al
  103778:	0f b6 c0             	movzbl %al,%eax
  10377b:	85 c0                	test   %eax,%eax
  10377d:	74 0b                	je     10378a <default_check+0x3c3>
  10377f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103782:	8b 40 08             	mov    0x8(%eax),%eax
  103785:	83 f8 01             	cmp    $0x1,%eax
  103788:	74 24                	je     1037ae <default_check+0x3e7>
  10378a:	c7 44 24 0c b4 69 10 	movl   $0x1069b4,0xc(%esp)
  103791:	00 
  103792:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  103799:	00 
  10379a:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
  1037a1:	00 
  1037a2:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  1037a9:	e8 1d d5 ff ff       	call   100ccb <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  1037ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1037b1:	83 c0 04             	add    $0x4,%eax
  1037b4:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  1037bb:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1037be:	8b 45 90             	mov    -0x70(%ebp),%eax
  1037c1:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1037c4:	0f a3 10             	bt     %edx,(%eax)
  1037c7:	19 c0                	sbb    %eax,%eax
  1037c9:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  1037cc:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  1037d0:	0f 95 c0             	setne  %al
  1037d3:	0f b6 c0             	movzbl %al,%eax
  1037d6:	85 c0                	test   %eax,%eax
  1037d8:	74 0b                	je     1037e5 <default_check+0x41e>
  1037da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1037dd:	8b 40 08             	mov    0x8(%eax),%eax
  1037e0:	83 f8 03             	cmp    $0x3,%eax
  1037e3:	74 24                	je     103809 <default_check+0x442>
  1037e5:	c7 44 24 0c dc 69 10 	movl   $0x1069dc,0xc(%esp)
  1037ec:	00 
  1037ed:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  1037f4:	00 
  1037f5:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
  1037fc:	00 
  1037fd:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  103804:	e8 c2 d4 ff ff       	call   100ccb <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  103809:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103810:	e8 38 05 00 00       	call   103d4d <alloc_pages>
  103815:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103818:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10381b:	83 e8 14             	sub    $0x14,%eax
  10381e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103821:	74 24                	je     103847 <default_check+0x480>
  103823:	c7 44 24 0c 02 6a 10 	movl   $0x106a02,0xc(%esp)
  10382a:	00 
  10382b:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  103832:	00 
  103833:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
  10383a:	00 
  10383b:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  103842:	e8 84 d4 ff ff       	call   100ccb <__panic>
    free_page(p0);
  103847:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10384e:	00 
  10384f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103852:	89 04 24             	mov    %eax,(%esp)
  103855:	e8 2b 05 00 00       	call   103d85 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  10385a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  103861:	e8 e7 04 00 00       	call   103d4d <alloc_pages>
  103866:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103869:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10386c:	83 c0 14             	add    $0x14,%eax
  10386f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103872:	74 24                	je     103898 <default_check+0x4d1>
  103874:	c7 44 24 0c 20 6a 10 	movl   $0x106a20,0xc(%esp)
  10387b:	00 
  10387c:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  103883:	00 
  103884:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  10388b:	00 
  10388c:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  103893:	e8 33 d4 ff ff       	call   100ccb <__panic>

    free_pages(p0, 2);
  103898:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10389f:	00 
  1038a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1038a3:	89 04 24             	mov    %eax,(%esp)
  1038a6:	e8 da 04 00 00       	call   103d85 <free_pages>
    free_page(p2);
  1038ab:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1038b2:	00 
  1038b3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1038b6:	89 04 24             	mov    %eax,(%esp)
  1038b9:	e8 c7 04 00 00       	call   103d85 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  1038be:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1038c5:	e8 83 04 00 00       	call   103d4d <alloc_pages>
  1038ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1038cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1038d1:	75 24                	jne    1038f7 <default_check+0x530>
  1038d3:	c7 44 24 0c 40 6a 10 	movl   $0x106a40,0xc(%esp)
  1038da:	00 
  1038db:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  1038e2:	00 
  1038e3:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  1038ea:	00 
  1038eb:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  1038f2:	e8 d4 d3 ff ff       	call   100ccb <__panic>
    assert(alloc_page() == NULL);
  1038f7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1038fe:	e8 4a 04 00 00       	call   103d4d <alloc_pages>
  103903:	85 c0                	test   %eax,%eax
  103905:	74 24                	je     10392b <default_check+0x564>
  103907:	c7 44 24 0c 9e 68 10 	movl   $0x10689e,0xc(%esp)
  10390e:	00 
  10390f:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  103916:	00 
  103917:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
  10391e:	00 
  10391f:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  103926:	e8 a0 d3 ff ff       	call   100ccb <__panic>

    assert(nr_free == 0);
  10392b:	a1 58 89 11 00       	mov    0x118958,%eax
  103930:	85 c0                	test   %eax,%eax
  103932:	74 24                	je     103958 <default_check+0x591>
  103934:	c7 44 24 0c f1 68 10 	movl   $0x1068f1,0xc(%esp)
  10393b:	00 
  10393c:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  103943:	00 
  103944:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  10394b:	00 
  10394c:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  103953:	e8 73 d3 ff ff       	call   100ccb <__panic>
    nr_free = nr_free_store;
  103958:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10395b:	a3 58 89 11 00       	mov    %eax,0x118958

    free_list = free_list_store;
  103960:	8b 45 80             	mov    -0x80(%ebp),%eax
  103963:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103966:	a3 50 89 11 00       	mov    %eax,0x118950
  10396b:	89 15 54 89 11 00    	mov    %edx,0x118954
    free_pages(p0, 5);
  103971:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  103978:	00 
  103979:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10397c:	89 04 24             	mov    %eax,(%esp)
  10397f:	e8 01 04 00 00       	call   103d85 <free_pages>

    le = &free_list;
  103984:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  10398b:	eb 1d                	jmp    1039aa <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  10398d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103990:	83 e8 0c             	sub    $0xc,%eax
  103993:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  103996:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10399a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10399d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1039a0:	8b 40 08             	mov    0x8(%eax),%eax
  1039a3:	29 c2                	sub    %eax,%edx
  1039a5:	89 d0                	mov    %edx,%eax
  1039a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1039aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1039ad:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1039b0:	8b 45 88             	mov    -0x78(%ebp),%eax
  1039b3:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  1039b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1039b9:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  1039c0:	75 cb                	jne    10398d <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  1039c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1039c6:	74 24                	je     1039ec <default_check+0x625>
  1039c8:	c7 44 24 0c 5e 6a 10 	movl   $0x106a5e,0xc(%esp)
  1039cf:	00 
  1039d0:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  1039d7:	00 
  1039d8:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
  1039df:	00 
  1039e0:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  1039e7:	e8 df d2 ff ff       	call   100ccb <__panic>
    assert(total == 0);
  1039ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1039f0:	74 24                	je     103a16 <default_check+0x64f>
  1039f2:	c7 44 24 0c 69 6a 10 	movl   $0x106a69,0xc(%esp)
  1039f9:	00 
  1039fa:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  103a01:	00 
  103a02:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  103a09:	00 
  103a0a:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  103a11:	e8 b5 d2 ff ff       	call   100ccb <__panic>
}
  103a16:	81 c4 94 00 00 00    	add    $0x94,%esp
  103a1c:	5b                   	pop    %ebx
  103a1d:	5d                   	pop    %ebp
  103a1e:	c3                   	ret    

00103a1f <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  103a1f:	55                   	push   %ebp
  103a20:	89 e5                	mov    %esp,%ebp
    return page - pages;
  103a22:	8b 55 08             	mov    0x8(%ebp),%edx
  103a25:	a1 64 89 11 00       	mov    0x118964,%eax
  103a2a:	29 c2                	sub    %eax,%edx
  103a2c:	89 d0                	mov    %edx,%eax
  103a2e:	c1 f8 02             	sar    $0x2,%eax
  103a31:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103a37:	5d                   	pop    %ebp
  103a38:	c3                   	ret    

00103a39 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  103a39:	55                   	push   %ebp
  103a3a:	89 e5                	mov    %esp,%ebp
  103a3c:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  103a42:	89 04 24             	mov    %eax,(%esp)
  103a45:	e8 d5 ff ff ff       	call   103a1f <page2ppn>
  103a4a:	c1 e0 0c             	shl    $0xc,%eax
}
  103a4d:	c9                   	leave  
  103a4e:	c3                   	ret    

00103a4f <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  103a4f:	55                   	push   %ebp
  103a50:	89 e5                	mov    %esp,%ebp
  103a52:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  103a55:	8b 45 08             	mov    0x8(%ebp),%eax
  103a58:	c1 e8 0c             	shr    $0xc,%eax
  103a5b:	89 c2                	mov    %eax,%edx
  103a5d:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103a62:	39 c2                	cmp    %eax,%edx
  103a64:	72 1c                	jb     103a82 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103a66:	c7 44 24 08 a4 6a 10 	movl   $0x106aa4,0x8(%esp)
  103a6d:	00 
  103a6e:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  103a75:	00 
  103a76:	c7 04 24 c3 6a 10 00 	movl   $0x106ac3,(%esp)
  103a7d:	e8 49 d2 ff ff       	call   100ccb <__panic>
    }
    return &pages[PPN(pa)];
  103a82:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  103a88:	8b 45 08             	mov    0x8(%ebp),%eax
  103a8b:	c1 e8 0c             	shr    $0xc,%eax
  103a8e:	89 c2                	mov    %eax,%edx
  103a90:	89 d0                	mov    %edx,%eax
  103a92:	c1 e0 02             	shl    $0x2,%eax
  103a95:	01 d0                	add    %edx,%eax
  103a97:	c1 e0 02             	shl    $0x2,%eax
  103a9a:	01 c8                	add    %ecx,%eax
}
  103a9c:	c9                   	leave  
  103a9d:	c3                   	ret    

00103a9e <page2kva>:

static inline void *
page2kva(struct Page *page) {
  103a9e:	55                   	push   %ebp
  103a9f:	89 e5                	mov    %esp,%ebp
  103aa1:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  103aa7:	89 04 24             	mov    %eax,(%esp)
  103aaa:	e8 8a ff ff ff       	call   103a39 <page2pa>
  103aaf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ab5:	c1 e8 0c             	shr    $0xc,%eax
  103ab8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103abb:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103ac0:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103ac3:	72 23                	jb     103ae8 <page2kva+0x4a>
  103ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ac8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103acc:	c7 44 24 08 d4 6a 10 	movl   $0x106ad4,0x8(%esp)
  103ad3:	00 
  103ad4:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103adb:	00 
  103adc:	c7 04 24 c3 6a 10 00 	movl   $0x106ac3,(%esp)
  103ae3:	e8 e3 d1 ff ff       	call   100ccb <__panic>
  103ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103aeb:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103af0:	c9                   	leave  
  103af1:	c3                   	ret    

00103af2 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  103af2:	55                   	push   %ebp
  103af3:	89 e5                	mov    %esp,%ebp
  103af5:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103af8:	8b 45 08             	mov    0x8(%ebp),%eax
  103afb:	83 e0 01             	and    $0x1,%eax
  103afe:	85 c0                	test   %eax,%eax
  103b00:	75 1c                	jne    103b1e <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103b02:	c7 44 24 08 f8 6a 10 	movl   $0x106af8,0x8(%esp)
  103b09:	00 
  103b0a:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103b11:	00 
  103b12:	c7 04 24 c3 6a 10 00 	movl   $0x106ac3,(%esp)
  103b19:	e8 ad d1 ff ff       	call   100ccb <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  103b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  103b21:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103b26:	89 04 24             	mov    %eax,(%esp)
  103b29:	e8 21 ff ff ff       	call   103a4f <pa2page>
}
  103b2e:	c9                   	leave  
  103b2f:	c3                   	ret    

00103b30 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  103b30:	55                   	push   %ebp
  103b31:	89 e5                	mov    %esp,%ebp
  103b33:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  103b36:	8b 45 08             	mov    0x8(%ebp),%eax
  103b39:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103b3e:	89 04 24             	mov    %eax,(%esp)
  103b41:	e8 09 ff ff ff       	call   103a4f <pa2page>
}
  103b46:	c9                   	leave  
  103b47:	c3                   	ret    

00103b48 <page_ref>:

static inline int
page_ref(struct Page *page) {
  103b48:	55                   	push   %ebp
  103b49:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  103b4e:	8b 00                	mov    (%eax),%eax
}
  103b50:	5d                   	pop    %ebp
  103b51:	c3                   	ret    

00103b52 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  103b52:	55                   	push   %ebp
  103b53:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  103b55:	8b 45 08             	mov    0x8(%ebp),%eax
  103b58:	8b 55 0c             	mov    0xc(%ebp),%edx
  103b5b:	89 10                	mov    %edx,(%eax)
}
  103b5d:	5d                   	pop    %ebp
  103b5e:	c3                   	ret    

00103b5f <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  103b5f:	55                   	push   %ebp
  103b60:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103b62:	8b 45 08             	mov    0x8(%ebp),%eax
  103b65:	8b 00                	mov    (%eax),%eax
  103b67:	8d 50 01             	lea    0x1(%eax),%edx
  103b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  103b6d:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  103b72:	8b 00                	mov    (%eax),%eax
}
  103b74:	5d                   	pop    %ebp
  103b75:	c3                   	ret    

00103b76 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103b76:	55                   	push   %ebp
  103b77:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103b79:	8b 45 08             	mov    0x8(%ebp),%eax
  103b7c:	8b 00                	mov    (%eax),%eax
  103b7e:	8d 50 ff             	lea    -0x1(%eax),%edx
  103b81:	8b 45 08             	mov    0x8(%ebp),%eax
  103b84:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103b86:	8b 45 08             	mov    0x8(%ebp),%eax
  103b89:	8b 00                	mov    (%eax),%eax
}
  103b8b:	5d                   	pop    %ebp
  103b8c:	c3                   	ret    

00103b8d <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  103b8d:	55                   	push   %ebp
  103b8e:	89 e5                	mov    %esp,%ebp
  103b90:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103b93:	9c                   	pushf  
  103b94:	58                   	pop    %eax
  103b95:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103b9b:	25 00 02 00 00       	and    $0x200,%eax
  103ba0:	85 c0                	test   %eax,%eax
  103ba2:	74 0c                	je     103bb0 <__intr_save+0x23>
        intr_disable();
  103ba4:	e8 05 db ff ff       	call   1016ae <intr_disable>
        return 1;
  103ba9:	b8 01 00 00 00       	mov    $0x1,%eax
  103bae:	eb 05                	jmp    103bb5 <__intr_save+0x28>
    }
    return 0;
  103bb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103bb5:	c9                   	leave  
  103bb6:	c3                   	ret    

00103bb7 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  103bb7:	55                   	push   %ebp
  103bb8:	89 e5                	mov    %esp,%ebp
  103bba:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103bbd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103bc1:	74 05                	je     103bc8 <__intr_restore+0x11>
        intr_enable();
  103bc3:	e8 e0 da ff ff       	call   1016a8 <intr_enable>
    }
}
  103bc8:	c9                   	leave  
  103bc9:	c3                   	ret    

00103bca <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103bca:	55                   	push   %ebp
  103bcb:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  103bd0:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103bd3:	b8 23 00 00 00       	mov    $0x23,%eax
  103bd8:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103bda:	b8 23 00 00 00       	mov    $0x23,%eax
  103bdf:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103be1:	b8 10 00 00 00       	mov    $0x10,%eax
  103be6:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103be8:	b8 10 00 00 00       	mov    $0x10,%eax
  103bed:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103bef:	b8 10 00 00 00       	mov    $0x10,%eax
  103bf4:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103bf6:	ea fd 3b 10 00 08 00 	ljmp   $0x8,$0x103bfd
}
  103bfd:	5d                   	pop    %ebp
  103bfe:	c3                   	ret    

00103bff <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103bff:	55                   	push   %ebp
  103c00:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103c02:	8b 45 08             	mov    0x8(%ebp),%eax
  103c05:	a3 e4 88 11 00       	mov    %eax,0x1188e4
}
  103c0a:	5d                   	pop    %ebp
  103c0b:	c3                   	ret    

00103c0c <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103c0c:	55                   	push   %ebp
  103c0d:	89 e5                	mov    %esp,%ebp
  103c0f:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103c12:	b8 00 70 11 00       	mov    $0x117000,%eax
  103c17:	89 04 24             	mov    %eax,(%esp)
  103c1a:	e8 e0 ff ff ff       	call   103bff <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103c1f:	66 c7 05 e8 88 11 00 	movw   $0x10,0x1188e8
  103c26:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103c28:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  103c2f:	68 00 
  103c31:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103c36:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  103c3c:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103c41:	c1 e8 10             	shr    $0x10,%eax
  103c44:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  103c49:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c50:	83 e0 f0             	and    $0xfffffff0,%eax
  103c53:	83 c8 09             	or     $0x9,%eax
  103c56:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c5b:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c62:	83 e0 ef             	and    $0xffffffef,%eax
  103c65:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c6a:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c71:	83 e0 9f             	and    $0xffffff9f,%eax
  103c74:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c79:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c80:	83 c8 80             	or     $0xffffff80,%eax
  103c83:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c88:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c8f:	83 e0 f0             	and    $0xfffffff0,%eax
  103c92:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c97:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c9e:	83 e0 ef             	and    $0xffffffef,%eax
  103ca1:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103ca6:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103cad:	83 e0 df             	and    $0xffffffdf,%eax
  103cb0:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103cb5:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103cbc:	83 c8 40             	or     $0x40,%eax
  103cbf:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103cc4:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103ccb:	83 e0 7f             	and    $0x7f,%eax
  103cce:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103cd3:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103cd8:	c1 e8 18             	shr    $0x18,%eax
  103cdb:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103ce0:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  103ce7:	e8 de fe ff ff       	call   103bca <lgdt>
  103cec:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103cf2:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103cf6:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  103cf9:	c9                   	leave  
  103cfa:	c3                   	ret    

00103cfb <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103cfb:	55                   	push   %ebp
  103cfc:	89 e5                	mov    %esp,%ebp
  103cfe:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103d01:	c7 05 5c 89 11 00 88 	movl   $0x106a88,0x11895c
  103d08:	6a 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103d0b:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d10:	8b 00                	mov    (%eax),%eax
  103d12:	89 44 24 04          	mov    %eax,0x4(%esp)
  103d16:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  103d1d:	e8 1a c6 ff ff       	call   10033c <cprintf>
    pmm_manager->init();
  103d22:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d27:	8b 40 04             	mov    0x4(%eax),%eax
  103d2a:	ff d0                	call   *%eax
}
  103d2c:	c9                   	leave  
  103d2d:	c3                   	ret    

00103d2e <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103d2e:	55                   	push   %ebp
  103d2f:	89 e5                	mov    %esp,%ebp
  103d31:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103d34:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d39:	8b 40 08             	mov    0x8(%eax),%eax
  103d3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  103d3f:	89 54 24 04          	mov    %edx,0x4(%esp)
  103d43:	8b 55 08             	mov    0x8(%ebp),%edx
  103d46:	89 14 24             	mov    %edx,(%esp)
  103d49:	ff d0                	call   *%eax
}
  103d4b:	c9                   	leave  
  103d4c:	c3                   	ret    

00103d4d <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103d4d:	55                   	push   %ebp
  103d4e:	89 e5                	mov    %esp,%ebp
  103d50:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103d53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103d5a:	e8 2e fe ff ff       	call   103b8d <__intr_save>
  103d5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103d62:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d67:	8b 40 0c             	mov    0xc(%eax),%eax
  103d6a:	8b 55 08             	mov    0x8(%ebp),%edx
  103d6d:	89 14 24             	mov    %edx,(%esp)
  103d70:	ff d0                	call   *%eax
  103d72:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103d75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103d78:	89 04 24             	mov    %eax,(%esp)
  103d7b:	e8 37 fe ff ff       	call   103bb7 <__intr_restore>
    return page;
  103d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103d83:	c9                   	leave  
  103d84:	c3                   	ret    

00103d85 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103d85:	55                   	push   %ebp
  103d86:	89 e5                	mov    %esp,%ebp
  103d88:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103d8b:	e8 fd fd ff ff       	call   103b8d <__intr_save>
  103d90:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103d93:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d98:	8b 40 10             	mov    0x10(%eax),%eax
  103d9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  103d9e:	89 54 24 04          	mov    %edx,0x4(%esp)
  103da2:	8b 55 08             	mov    0x8(%ebp),%edx
  103da5:	89 14 24             	mov    %edx,(%esp)
  103da8:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103dad:	89 04 24             	mov    %eax,(%esp)
  103db0:	e8 02 fe ff ff       	call   103bb7 <__intr_restore>
}
  103db5:	c9                   	leave  
  103db6:	c3                   	ret    

00103db7 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103db7:	55                   	push   %ebp
  103db8:	89 e5                	mov    %esp,%ebp
  103dba:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103dbd:	e8 cb fd ff ff       	call   103b8d <__intr_save>
  103dc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103dc5:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103dca:	8b 40 14             	mov    0x14(%eax),%eax
  103dcd:	ff d0                	call   *%eax
  103dcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103dd5:	89 04 24             	mov    %eax,(%esp)
  103dd8:	e8 da fd ff ff       	call   103bb7 <__intr_restore>
    return ret;
  103ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103de0:	c9                   	leave  
  103de1:	c3                   	ret    

00103de2 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103de2:	55                   	push   %ebp
  103de3:	89 e5                	mov    %esp,%ebp
  103de5:	57                   	push   %edi
  103de6:	56                   	push   %esi
  103de7:	53                   	push   %ebx
  103de8:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103dee:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103df5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103dfc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103e03:	c7 04 24 3b 6b 10 00 	movl   $0x106b3b,(%esp)
  103e0a:	e8 2d c5 ff ff       	call   10033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103e0f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103e16:	e9 15 01 00 00       	jmp    103f30 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103e1b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e1e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e21:	89 d0                	mov    %edx,%eax
  103e23:	c1 e0 02             	shl    $0x2,%eax
  103e26:	01 d0                	add    %edx,%eax
  103e28:	c1 e0 02             	shl    $0x2,%eax
  103e2b:	01 c8                	add    %ecx,%eax
  103e2d:	8b 50 08             	mov    0x8(%eax),%edx
  103e30:	8b 40 04             	mov    0x4(%eax),%eax
  103e33:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103e36:	89 55 bc             	mov    %edx,-0x44(%ebp)
  103e39:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e3f:	89 d0                	mov    %edx,%eax
  103e41:	c1 e0 02             	shl    $0x2,%eax
  103e44:	01 d0                	add    %edx,%eax
  103e46:	c1 e0 02             	shl    $0x2,%eax
  103e49:	01 c8                	add    %ecx,%eax
  103e4b:	8b 48 0c             	mov    0xc(%eax),%ecx
  103e4e:	8b 58 10             	mov    0x10(%eax),%ebx
  103e51:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103e54:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103e57:	01 c8                	add    %ecx,%eax
  103e59:	11 da                	adc    %ebx,%edx
  103e5b:	89 45 b0             	mov    %eax,-0x50(%ebp)
  103e5e:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103e61:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e64:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e67:	89 d0                	mov    %edx,%eax
  103e69:	c1 e0 02             	shl    $0x2,%eax
  103e6c:	01 d0                	add    %edx,%eax
  103e6e:	c1 e0 02             	shl    $0x2,%eax
  103e71:	01 c8                	add    %ecx,%eax
  103e73:	83 c0 14             	add    $0x14,%eax
  103e76:	8b 00                	mov    (%eax),%eax
  103e78:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  103e7e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103e81:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103e84:	83 c0 ff             	add    $0xffffffff,%eax
  103e87:	83 d2 ff             	adc    $0xffffffff,%edx
  103e8a:	89 c6                	mov    %eax,%esi
  103e8c:	89 d7                	mov    %edx,%edi
  103e8e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e91:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e94:	89 d0                	mov    %edx,%eax
  103e96:	c1 e0 02             	shl    $0x2,%eax
  103e99:	01 d0                	add    %edx,%eax
  103e9b:	c1 e0 02             	shl    $0x2,%eax
  103e9e:	01 c8                	add    %ecx,%eax
  103ea0:	8b 48 0c             	mov    0xc(%eax),%ecx
  103ea3:	8b 58 10             	mov    0x10(%eax),%ebx
  103ea6:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  103eac:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  103eb0:	89 74 24 14          	mov    %esi,0x14(%esp)
  103eb4:	89 7c 24 18          	mov    %edi,0x18(%esp)
  103eb8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103ebb:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103ebe:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103ec2:	89 54 24 10          	mov    %edx,0x10(%esp)
  103ec6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103eca:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103ece:	c7 04 24 48 6b 10 00 	movl   $0x106b48,(%esp)
  103ed5:	e8 62 c4 ff ff       	call   10033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  103eda:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103edd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103ee0:	89 d0                	mov    %edx,%eax
  103ee2:	c1 e0 02             	shl    $0x2,%eax
  103ee5:	01 d0                	add    %edx,%eax
  103ee7:	c1 e0 02             	shl    $0x2,%eax
  103eea:	01 c8                	add    %ecx,%eax
  103eec:	83 c0 14             	add    $0x14,%eax
  103eef:	8b 00                	mov    (%eax),%eax
  103ef1:	83 f8 01             	cmp    $0x1,%eax
  103ef4:	75 36                	jne    103f2c <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  103ef6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103ef9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103efc:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103eff:	77 2b                	ja     103f2c <page_init+0x14a>
  103f01:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103f04:	72 05                	jb     103f0b <page_init+0x129>
  103f06:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  103f09:	73 21                	jae    103f2c <page_init+0x14a>
  103f0b:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103f0f:	77 1b                	ja     103f2c <page_init+0x14a>
  103f11:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103f15:	72 09                	jb     103f20 <page_init+0x13e>
  103f17:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  103f1e:	77 0c                	ja     103f2c <page_init+0x14a>
                maxpa = end;
  103f20:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103f23:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103f26:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103f29:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103f2c:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103f30:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103f33:	8b 00                	mov    (%eax),%eax
  103f35:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103f38:	0f 8f dd fe ff ff    	jg     103e1b <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  103f3e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103f42:	72 1d                	jb     103f61 <page_init+0x17f>
  103f44:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103f48:	77 09                	ja     103f53 <page_init+0x171>
  103f4a:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  103f51:	76 0e                	jbe    103f61 <page_init+0x17f>
        maxpa = KMEMSIZE;
  103f53:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  103f5a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  103f61:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103f64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103f67:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103f6b:	c1 ea 0c             	shr    $0xc,%edx
  103f6e:	a3 c0 88 11 00       	mov    %eax,0x1188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  103f73:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  103f7a:	b8 68 89 11 00       	mov    $0x118968,%eax
  103f7f:	8d 50 ff             	lea    -0x1(%eax),%edx
  103f82:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103f85:	01 d0                	add    %edx,%eax
  103f87:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103f8a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103f8d:	ba 00 00 00 00       	mov    $0x0,%edx
  103f92:	f7 75 ac             	divl   -0x54(%ebp)
  103f95:	89 d0                	mov    %edx,%eax
  103f97:	8b 55 a8             	mov    -0x58(%ebp),%edx
  103f9a:	29 c2                	sub    %eax,%edx
  103f9c:	89 d0                	mov    %edx,%eax
  103f9e:	a3 64 89 11 00       	mov    %eax,0x118964

    for (i = 0; i < npage; i ++) {
  103fa3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103faa:	eb 2f                	jmp    103fdb <page_init+0x1f9>
        SetPageReserved(pages + i);
  103fac:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  103fb2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fb5:	89 d0                	mov    %edx,%eax
  103fb7:	c1 e0 02             	shl    $0x2,%eax
  103fba:	01 d0                	add    %edx,%eax
  103fbc:	c1 e0 02             	shl    $0x2,%eax
  103fbf:	01 c8                	add    %ecx,%eax
  103fc1:	83 c0 04             	add    $0x4,%eax
  103fc4:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  103fcb:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103fce:	8b 45 8c             	mov    -0x74(%ebp),%eax
  103fd1:	8b 55 90             	mov    -0x70(%ebp),%edx
  103fd4:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  103fd7:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103fdb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fde:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103fe3:	39 c2                	cmp    %eax,%edx
  103fe5:	72 c5                	jb     103fac <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  103fe7:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  103fed:	89 d0                	mov    %edx,%eax
  103fef:	c1 e0 02             	shl    $0x2,%eax
  103ff2:	01 d0                	add    %edx,%eax
  103ff4:	c1 e0 02             	shl    $0x2,%eax
  103ff7:	89 c2                	mov    %eax,%edx
  103ff9:	a1 64 89 11 00       	mov    0x118964,%eax
  103ffe:	01 d0                	add    %edx,%eax
  104000:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  104003:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  10400a:	77 23                	ja     10402f <page_init+0x24d>
  10400c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  10400f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104013:	c7 44 24 08 78 6b 10 	movl   $0x106b78,0x8(%esp)
  10401a:	00 
  10401b:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  104022:	00 
  104023:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  10402a:	e8 9c cc ff ff       	call   100ccb <__panic>
  10402f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104032:	05 00 00 00 40       	add    $0x40000000,%eax
  104037:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  10403a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104041:	e9 74 01 00 00       	jmp    1041ba <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  104046:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104049:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10404c:	89 d0                	mov    %edx,%eax
  10404e:	c1 e0 02             	shl    $0x2,%eax
  104051:	01 d0                	add    %edx,%eax
  104053:	c1 e0 02             	shl    $0x2,%eax
  104056:	01 c8                	add    %ecx,%eax
  104058:	8b 50 08             	mov    0x8(%eax),%edx
  10405b:	8b 40 04             	mov    0x4(%eax),%eax
  10405e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104061:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104064:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104067:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10406a:	89 d0                	mov    %edx,%eax
  10406c:	c1 e0 02             	shl    $0x2,%eax
  10406f:	01 d0                	add    %edx,%eax
  104071:	c1 e0 02             	shl    $0x2,%eax
  104074:	01 c8                	add    %ecx,%eax
  104076:	8b 48 0c             	mov    0xc(%eax),%ecx
  104079:	8b 58 10             	mov    0x10(%eax),%ebx
  10407c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10407f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104082:	01 c8                	add    %ecx,%eax
  104084:	11 da                	adc    %ebx,%edx
  104086:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104089:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  10408c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10408f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104092:	89 d0                	mov    %edx,%eax
  104094:	c1 e0 02             	shl    $0x2,%eax
  104097:	01 d0                	add    %edx,%eax
  104099:	c1 e0 02             	shl    $0x2,%eax
  10409c:	01 c8                	add    %ecx,%eax
  10409e:	83 c0 14             	add    $0x14,%eax
  1040a1:	8b 00                	mov    (%eax),%eax
  1040a3:	83 f8 01             	cmp    $0x1,%eax
  1040a6:	0f 85 0a 01 00 00    	jne    1041b6 <page_init+0x3d4>
            if (begin < freemem) {
  1040ac:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1040af:	ba 00 00 00 00       	mov    $0x0,%edx
  1040b4:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1040b7:	72 17                	jb     1040d0 <page_init+0x2ee>
  1040b9:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1040bc:	77 05                	ja     1040c3 <page_init+0x2e1>
  1040be:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1040c1:	76 0d                	jbe    1040d0 <page_init+0x2ee>
                begin = freemem;
  1040c3:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1040c6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1040c9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  1040d0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  1040d4:	72 1d                	jb     1040f3 <page_init+0x311>
  1040d6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  1040da:	77 09                	ja     1040e5 <page_init+0x303>
  1040dc:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  1040e3:	76 0e                	jbe    1040f3 <page_init+0x311>
                end = KMEMSIZE;
  1040e5:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  1040ec:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  1040f3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1040f6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1040f9:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1040fc:	0f 87 b4 00 00 00    	ja     1041b6 <page_init+0x3d4>
  104102:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104105:	72 09                	jb     104110 <page_init+0x32e>
  104107:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  10410a:	0f 83 a6 00 00 00    	jae    1041b6 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  104110:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  104117:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10411a:	8b 45 9c             	mov    -0x64(%ebp),%eax
  10411d:	01 d0                	add    %edx,%eax
  10411f:	83 e8 01             	sub    $0x1,%eax
  104122:	89 45 98             	mov    %eax,-0x68(%ebp)
  104125:	8b 45 98             	mov    -0x68(%ebp),%eax
  104128:	ba 00 00 00 00       	mov    $0x0,%edx
  10412d:	f7 75 9c             	divl   -0x64(%ebp)
  104130:	89 d0                	mov    %edx,%eax
  104132:	8b 55 98             	mov    -0x68(%ebp),%edx
  104135:	29 c2                	sub    %eax,%edx
  104137:	89 d0                	mov    %edx,%eax
  104139:	ba 00 00 00 00       	mov    $0x0,%edx
  10413e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104141:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  104144:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104147:	89 45 94             	mov    %eax,-0x6c(%ebp)
  10414a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  10414d:	ba 00 00 00 00       	mov    $0x0,%edx
  104152:	89 c7                	mov    %eax,%edi
  104154:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  10415a:	89 7d 80             	mov    %edi,-0x80(%ebp)
  10415d:	89 d0                	mov    %edx,%eax
  10415f:	83 e0 00             	and    $0x0,%eax
  104162:	89 45 84             	mov    %eax,-0x7c(%ebp)
  104165:	8b 45 80             	mov    -0x80(%ebp),%eax
  104168:	8b 55 84             	mov    -0x7c(%ebp),%edx
  10416b:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10416e:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  104171:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104174:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104177:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10417a:	77 3a                	ja     1041b6 <page_init+0x3d4>
  10417c:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10417f:	72 05                	jb     104186 <page_init+0x3a4>
  104181:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104184:	73 30                	jae    1041b6 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  104186:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  104189:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  10418c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10418f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104192:	29 c8                	sub    %ecx,%eax
  104194:	19 da                	sbb    %ebx,%edx
  104196:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  10419a:	c1 ea 0c             	shr    $0xc,%edx
  10419d:	89 c3                	mov    %eax,%ebx
  10419f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1041a2:	89 04 24             	mov    %eax,(%esp)
  1041a5:	e8 a5 f8 ff ff       	call   103a4f <pa2page>
  1041aa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1041ae:	89 04 24             	mov    %eax,(%esp)
  1041b1:	e8 78 fb ff ff       	call   103d2e <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  1041b6:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  1041ba:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1041bd:	8b 00                	mov    (%eax),%eax
  1041bf:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  1041c2:	0f 8f 7e fe ff ff    	jg     104046 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  1041c8:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  1041ce:	5b                   	pop    %ebx
  1041cf:	5e                   	pop    %esi
  1041d0:	5f                   	pop    %edi
  1041d1:	5d                   	pop    %ebp
  1041d2:	c3                   	ret    

001041d3 <enable_paging>:

static void
enable_paging(void) {
  1041d3:	55                   	push   %ebp
  1041d4:	89 e5                	mov    %esp,%ebp
  1041d6:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  1041d9:	a1 60 89 11 00       	mov    0x118960,%eax
  1041de:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  1041e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1041e4:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  1041e7:	0f 20 c0             	mov    %cr0,%eax
  1041ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  1041ed:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  1041f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  1041f3:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  1041fa:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
  1041fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104201:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  104204:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104207:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  10420a:	c9                   	leave  
  10420b:	c3                   	ret    

0010420c <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  10420c:	55                   	push   %ebp
  10420d:	89 e5                	mov    %esp,%ebp
  10420f:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  104212:	8b 45 14             	mov    0x14(%ebp),%eax
  104215:	8b 55 0c             	mov    0xc(%ebp),%edx
  104218:	31 d0                	xor    %edx,%eax
  10421a:	25 ff 0f 00 00       	and    $0xfff,%eax
  10421f:	85 c0                	test   %eax,%eax
  104221:	74 24                	je     104247 <boot_map_segment+0x3b>
  104223:	c7 44 24 0c aa 6b 10 	movl   $0x106baa,0xc(%esp)
  10422a:	00 
  10422b:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104232:	00 
  104233:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  10423a:	00 
  10423b:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104242:	e8 84 ca ff ff       	call   100ccb <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  104247:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  10424e:	8b 45 0c             	mov    0xc(%ebp),%eax
  104251:	25 ff 0f 00 00       	and    $0xfff,%eax
  104256:	89 c2                	mov    %eax,%edx
  104258:	8b 45 10             	mov    0x10(%ebp),%eax
  10425b:	01 c2                	add    %eax,%edx
  10425d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104260:	01 d0                	add    %edx,%eax
  104262:	83 e8 01             	sub    $0x1,%eax
  104265:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104268:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10426b:	ba 00 00 00 00       	mov    $0x0,%edx
  104270:	f7 75 f0             	divl   -0x10(%ebp)
  104273:	89 d0                	mov    %edx,%eax
  104275:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104278:	29 c2                	sub    %eax,%edx
  10427a:	89 d0                	mov    %edx,%eax
  10427c:	c1 e8 0c             	shr    $0xc,%eax
  10427f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  104282:	8b 45 0c             	mov    0xc(%ebp),%eax
  104285:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104288:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10428b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104290:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  104293:	8b 45 14             	mov    0x14(%ebp),%eax
  104296:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104299:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10429c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1042a1:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1042a4:	eb 6b                	jmp    104311 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  1042a6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1042ad:	00 
  1042ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  1042b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1042b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1042b8:	89 04 24             	mov    %eax,(%esp)
  1042bb:	e8 cc 01 00 00       	call   10448c <get_pte>
  1042c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  1042c3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1042c7:	75 24                	jne    1042ed <boot_map_segment+0xe1>
  1042c9:	c7 44 24 0c d6 6b 10 	movl   $0x106bd6,0xc(%esp)
  1042d0:	00 
  1042d1:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  1042d8:	00 
  1042d9:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  1042e0:	00 
  1042e1:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  1042e8:	e8 de c9 ff ff       	call   100ccb <__panic>
        *ptep = pa | PTE_P | perm;
  1042ed:	8b 45 18             	mov    0x18(%ebp),%eax
  1042f0:	8b 55 14             	mov    0x14(%ebp),%edx
  1042f3:	09 d0                	or     %edx,%eax
  1042f5:	83 c8 01             	or     $0x1,%eax
  1042f8:	89 c2                	mov    %eax,%edx
  1042fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1042fd:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1042ff:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  104303:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  10430a:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  104311:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104315:	75 8f                	jne    1042a6 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  104317:	c9                   	leave  
  104318:	c3                   	ret    

00104319 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  104319:	55                   	push   %ebp
  10431a:	89 e5                	mov    %esp,%ebp
  10431c:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  10431f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104326:	e8 22 fa ff ff       	call   103d4d <alloc_pages>
  10432b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  10432e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104332:	75 1c                	jne    104350 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  104334:	c7 44 24 08 e3 6b 10 	movl   $0x106be3,0x8(%esp)
  10433b:	00 
  10433c:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  104343:	00 
  104344:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  10434b:	e8 7b c9 ff ff       	call   100ccb <__panic>
    }
    return page2kva(p);
  104350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104353:	89 04 24             	mov    %eax,(%esp)
  104356:	e8 43 f7 ff ff       	call   103a9e <page2kva>
}
  10435b:	c9                   	leave  
  10435c:	c3                   	ret    

0010435d <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  10435d:	55                   	push   %ebp
  10435e:	89 e5                	mov    %esp,%ebp
  104360:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  104363:	e8 93 f9 ff ff       	call   103cfb <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  104368:	e8 75 fa ff ff       	call   103de2 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  10436d:	e8 75 04 00 00       	call   1047e7 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  104372:	e8 a2 ff ff ff       	call   104319 <boot_alloc_page>
  104377:	a3 c4 88 11 00       	mov    %eax,0x1188c4
    memset(boot_pgdir, 0, PGSIZE);
  10437c:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104381:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104388:	00 
  104389:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104390:	00 
  104391:	89 04 24             	mov    %eax,(%esp)
  104394:	e8 b2 1a 00 00       	call   105e4b <memset>
    boot_cr3 = PADDR(boot_pgdir);
  104399:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10439e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1043a1:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1043a8:	77 23                	ja     1043cd <pmm_init+0x70>
  1043aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043ad:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1043b1:	c7 44 24 08 78 6b 10 	movl   $0x106b78,0x8(%esp)
  1043b8:	00 
  1043b9:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  1043c0:	00 
  1043c1:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  1043c8:	e8 fe c8 ff ff       	call   100ccb <__panic>
  1043cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043d0:	05 00 00 00 40       	add    $0x40000000,%eax
  1043d5:	a3 60 89 11 00       	mov    %eax,0x118960

    check_pgdir();
  1043da:	e8 26 04 00 00       	call   104805 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  1043df:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1043e4:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  1043ea:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1043ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1043f2:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1043f9:	77 23                	ja     10441e <pmm_init+0xc1>
  1043fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1043fe:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104402:	c7 44 24 08 78 6b 10 	movl   $0x106b78,0x8(%esp)
  104409:	00 
  10440a:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  104411:	00 
  104412:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104419:	e8 ad c8 ff ff       	call   100ccb <__panic>
  10441e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104421:	05 00 00 00 40       	add    $0x40000000,%eax
  104426:	83 c8 03             	or     $0x3,%eax
  104429:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  10442b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104430:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  104437:	00 
  104438:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10443f:	00 
  104440:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  104447:	38 
  104448:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  10444f:	c0 
  104450:	89 04 24             	mov    %eax,(%esp)
  104453:	e8 b4 fd ff ff       	call   10420c <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  104458:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10445d:	8b 15 c4 88 11 00    	mov    0x1188c4,%edx
  104463:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  104469:	89 10                	mov    %edx,(%eax)

    enable_paging();
  10446b:	e8 63 fd ff ff       	call   1041d3 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  104470:	e8 97 f7 ff ff       	call   103c0c <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  104475:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10447a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  104480:	e8 1b 0a 00 00       	call   104ea0 <check_boot_pgdir>

    print_pgdir();
  104485:	e8 a3 0e 00 00       	call   10532d <print_pgdir>

}
  10448a:	c9                   	leave  
  10448b:	c3                   	ret    

0010448c <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  10448c:	55                   	push   %ebp
  10448d:	89 e5                	mov    %esp,%ebp
  10448f:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];   // (1) find page directory entry
  104492:	8b 45 0c             	mov    0xc(%ebp),%eax
  104495:	c1 e8 16             	shr    $0x16,%eax
  104498:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10449f:	8b 45 08             	mov    0x8(%ebp),%eax
  1044a2:	01 d0                	add    %edx,%eax
  1044a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if ((PTE_P & *pdep) == 0) {              // (2) check if entry is not present
  1044a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044aa:	8b 00                	mov    (%eax),%eax
  1044ac:	83 e0 01             	and    $0x1,%eax
  1044af:	85 c0                	test   %eax,%eax
  1044b1:	0f 85 b9 00 00 00    	jne    104570 <get_pte+0xe4>
    	if(!create)        // (3) check if creating is needed, then alloc page for page table
  1044b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1044bb:	75 0a                	jne    1044c7 <get_pte+0x3b>
    		return NULL;
  1044bd:	b8 00 00 00 00       	mov    $0x0,%eax
  1044c2:	e9 05 01 00 00       	jmp    1045cc <get_pte+0x140>
    	struct Page *page = alloc_page();
  1044c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1044ce:	e8 7a f8 ff ff       	call   103d4d <alloc_pages>
  1044d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	if(page == NULL)
  1044d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1044da:	75 0a                	jne    1044e6 <get_pte+0x5a>
    		return NULL;
  1044dc:	b8 00 00 00 00       	mov    $0x0,%eax
  1044e1:	e9 e6 00 00 00       	jmp    1045cc <get_pte+0x140>
                          // CAUTION: this page is used for page table, not for common data page
    	set_page_ref(page,1); // (4) set page reference
  1044e6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1044ed:	00 
  1044ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1044f1:	89 04 24             	mov    %eax,(%esp)
  1044f4:	e8 59 f6 ff ff       	call   103b52 <set_page_ref>

        uintptr_t pa = page2pa(page); // (5) get linear address of page
  1044f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1044fc:	89 04 24             	mov    %eax,(%esp)
  1044ff:	e8 35 f5 ff ff       	call   103a39 <page2pa>
  104504:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);  // (6) clear page content using memset
  104507:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10450a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10450d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104510:	c1 e8 0c             	shr    $0xc,%eax
  104513:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104516:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  10451b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10451e:	72 23                	jb     104543 <get_pte+0xb7>
  104520:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104523:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104527:	c7 44 24 08 d4 6a 10 	movl   $0x106ad4,0x8(%esp)
  10452e:	00 
  10452f:	c7 44 24 04 8a 01 00 	movl   $0x18a,0x4(%esp)
  104536:	00 
  104537:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  10453e:	e8 88 c7 ff ff       	call   100ccb <__panic>
  104543:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104546:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10454b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104552:	00 
  104553:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10455a:	00 
  10455b:	89 04 24             	mov    %eax,(%esp)
  10455e:	e8 e8 18 00 00       	call   105e4b <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P; // (7) set page directory entry's permission
  104563:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104566:	83 c8 07             	or     $0x7,%eax
  104569:	89 c2                	mov    %eax,%edx
  10456b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10456e:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];          // (8) return page table entry
  104570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104573:	8b 00                	mov    (%eax),%eax
  104575:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10457a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10457d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104580:	c1 e8 0c             	shr    $0xc,%eax
  104583:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104586:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  10458b:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  10458e:	72 23                	jb     1045b3 <get_pte+0x127>
  104590:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104593:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104597:	c7 44 24 08 d4 6a 10 	movl   $0x106ad4,0x8(%esp)
  10459e:	00 
  10459f:	c7 44 24 04 8d 01 00 	movl   $0x18d,0x4(%esp)
  1045a6:	00 
  1045a7:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  1045ae:	e8 18 c7 ff ff       	call   100ccb <__panic>
  1045b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1045b6:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1045bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  1045be:	c1 ea 0c             	shr    $0xc,%edx
  1045c1:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  1045c7:	c1 e2 02             	shl    $0x2,%edx
  1045ca:	01 d0                	add    %edx,%eax

}
  1045cc:	c9                   	leave  
  1045cd:	c3                   	ret    

001045ce <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  1045ce:	55                   	push   %ebp
  1045cf:	89 e5                	mov    %esp,%ebp
  1045d1:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1045d4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1045db:	00 
  1045dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1045df:	89 44 24 04          	mov    %eax,0x4(%esp)
  1045e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1045e6:	89 04 24             	mov    %eax,(%esp)
  1045e9:	e8 9e fe ff ff       	call   10448c <get_pte>
  1045ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  1045f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1045f5:	74 08                	je     1045ff <get_page+0x31>
        *ptep_store = ptep;
  1045f7:	8b 45 10             	mov    0x10(%ebp),%eax
  1045fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1045fd:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  1045ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104603:	74 1b                	je     104620 <get_page+0x52>
  104605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104608:	8b 00                	mov    (%eax),%eax
  10460a:	83 e0 01             	and    $0x1,%eax
  10460d:	85 c0                	test   %eax,%eax
  10460f:	74 0f                	je     104620 <get_page+0x52>
        return pte2page(*ptep);
  104611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104614:	8b 00                	mov    (%eax),%eax
  104616:	89 04 24             	mov    %eax,(%esp)
  104619:	e8 d4 f4 ff ff       	call   103af2 <pte2page>
  10461e:	eb 05                	jmp    104625 <get_page+0x57>
    }
    return NULL;
  104620:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104625:	c9                   	leave  
  104626:	c3                   	ret    

00104627 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  104627:	55                   	push   %ebp
  104628:	89 e5                	mov    %esp,%ebp
  10462a:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {                      //(1) check if this page table entry is present
  10462d:	8b 45 10             	mov    0x10(%ebp),%eax
  104630:	8b 00                	mov    (%eax),%eax
  104632:	83 e0 01             	and    $0x1,%eax
  104635:	85 c0                	test   %eax,%eax
  104637:	74 52                	je     10468b <page_remove_pte+0x64>
        struct Page *page = pte2page(*ptep); //(2) find corresponding page to pte
  104639:	8b 45 10             	mov    0x10(%ebp),%eax
  10463c:	8b 00                	mov    (%eax),%eax
  10463e:	89 04 24             	mov    %eax,(%esp)
  104641:	e8 ac f4 ff ff       	call   103af2 <pte2page>
  104646:	89 45 f4             	mov    %eax,-0xc(%ebp)
        page_ref_dec(page);                          //(3) decrease page reference
  104649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10464c:	89 04 24             	mov    %eax,(%esp)
  10464f:	e8 22 f5 ff ff       	call   103b76 <page_ref_dec>
        if(page->ref == 0)              //(4) and free this page when page reference reachs 0
  104654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104657:	8b 00                	mov    (%eax),%eax
  104659:	85 c0                	test   %eax,%eax
  10465b:	75 13                	jne    104670 <page_remove_pte+0x49>
        	free_page(page);
  10465d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104664:	00 
  104665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104668:	89 04 24             	mov    %eax,(%esp)
  10466b:	e8 15 f7 ff ff       	call   103d85 <free_pages>
        *ptep = 0;                      //(5) clear second page table entry
  104670:	8b 45 10             	mov    0x10(%ebp),%eax
  104673:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);     //(6) flush tlb
  104679:	8b 45 0c             	mov    0xc(%ebp),%eax
  10467c:	89 44 24 04          	mov    %eax,0x4(%esp)
  104680:	8b 45 08             	mov    0x8(%ebp),%eax
  104683:	89 04 24             	mov    %eax,(%esp)
  104686:	e8 ff 00 00 00       	call   10478a <tlb_invalidate>
    }
}
  10468b:	c9                   	leave  
  10468c:	c3                   	ret    

0010468d <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  10468d:	55                   	push   %ebp
  10468e:	89 e5                	mov    %esp,%ebp
  104690:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  104693:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10469a:	00 
  10469b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10469e:	89 44 24 04          	mov    %eax,0x4(%esp)
  1046a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1046a5:	89 04 24             	mov    %eax,(%esp)
  1046a8:	e8 df fd ff ff       	call   10448c <get_pte>
  1046ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  1046b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1046b4:	74 19                	je     1046cf <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  1046b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046b9:	89 44 24 08          	mov    %eax,0x8(%esp)
  1046bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1046c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1046c7:	89 04 24             	mov    %eax,(%esp)
  1046ca:	e8 58 ff ff ff       	call   104627 <page_remove_pte>
    }
}
  1046cf:	c9                   	leave  
  1046d0:	c3                   	ret    

001046d1 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  1046d1:	55                   	push   %ebp
  1046d2:	89 e5                	mov    %esp,%ebp
  1046d4:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  1046d7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1046de:	00 
  1046df:	8b 45 10             	mov    0x10(%ebp),%eax
  1046e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1046e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1046e9:	89 04 24             	mov    %eax,(%esp)
  1046ec:	e8 9b fd ff ff       	call   10448c <get_pte>
  1046f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  1046f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1046f8:	75 0a                	jne    104704 <page_insert+0x33>
        return -E_NO_MEM;
  1046fa:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  1046ff:	e9 84 00 00 00       	jmp    104788 <page_insert+0xb7>
    }
    page_ref_inc(page);
  104704:	8b 45 0c             	mov    0xc(%ebp),%eax
  104707:	89 04 24             	mov    %eax,(%esp)
  10470a:	e8 50 f4 ff ff       	call   103b5f <page_ref_inc>
    if (*ptep & PTE_P) {
  10470f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104712:	8b 00                	mov    (%eax),%eax
  104714:	83 e0 01             	and    $0x1,%eax
  104717:	85 c0                	test   %eax,%eax
  104719:	74 3e                	je     104759 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  10471b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10471e:	8b 00                	mov    (%eax),%eax
  104720:	89 04 24             	mov    %eax,(%esp)
  104723:	e8 ca f3 ff ff       	call   103af2 <pte2page>
  104728:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  10472b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10472e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104731:	75 0d                	jne    104740 <page_insert+0x6f>
            page_ref_dec(page);
  104733:	8b 45 0c             	mov    0xc(%ebp),%eax
  104736:	89 04 24             	mov    %eax,(%esp)
  104739:	e8 38 f4 ff ff       	call   103b76 <page_ref_dec>
  10473e:	eb 19                	jmp    104759 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  104740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104743:	89 44 24 08          	mov    %eax,0x8(%esp)
  104747:	8b 45 10             	mov    0x10(%ebp),%eax
  10474a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10474e:	8b 45 08             	mov    0x8(%ebp),%eax
  104751:	89 04 24             	mov    %eax,(%esp)
  104754:	e8 ce fe ff ff       	call   104627 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  104759:	8b 45 0c             	mov    0xc(%ebp),%eax
  10475c:	89 04 24             	mov    %eax,(%esp)
  10475f:	e8 d5 f2 ff ff       	call   103a39 <page2pa>
  104764:	0b 45 14             	or     0x14(%ebp),%eax
  104767:	83 c8 01             	or     $0x1,%eax
  10476a:	89 c2                	mov    %eax,%edx
  10476c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10476f:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  104771:	8b 45 10             	mov    0x10(%ebp),%eax
  104774:	89 44 24 04          	mov    %eax,0x4(%esp)
  104778:	8b 45 08             	mov    0x8(%ebp),%eax
  10477b:	89 04 24             	mov    %eax,(%esp)
  10477e:	e8 07 00 00 00       	call   10478a <tlb_invalidate>
    return 0;
  104783:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104788:	c9                   	leave  
  104789:	c3                   	ret    

0010478a <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  10478a:	55                   	push   %ebp
  10478b:	89 e5                	mov    %esp,%ebp
  10478d:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  104790:	0f 20 d8             	mov    %cr3,%eax
  104793:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  104796:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  104799:	89 c2                	mov    %eax,%edx
  10479b:	8b 45 08             	mov    0x8(%ebp),%eax
  10479e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1047a1:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1047a8:	77 23                	ja     1047cd <tlb_invalidate+0x43>
  1047aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047ad:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1047b1:	c7 44 24 08 78 6b 10 	movl   $0x106b78,0x8(%esp)
  1047b8:	00 
  1047b9:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
  1047c0:	00 
  1047c1:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  1047c8:	e8 fe c4 ff ff       	call   100ccb <__panic>
  1047cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047d0:	05 00 00 00 40       	add    $0x40000000,%eax
  1047d5:	39 c2                	cmp    %eax,%edx
  1047d7:	75 0c                	jne    1047e5 <tlb_invalidate+0x5b>
        invlpg((void *)la);
  1047d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  1047df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1047e2:	0f 01 38             	invlpg (%eax)
    }
}
  1047e5:	c9                   	leave  
  1047e6:	c3                   	ret    

001047e7 <check_alloc_page>:

static void
check_alloc_page(void) {
  1047e7:	55                   	push   %ebp
  1047e8:	89 e5                	mov    %esp,%ebp
  1047ea:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  1047ed:	a1 5c 89 11 00       	mov    0x11895c,%eax
  1047f2:	8b 40 18             	mov    0x18(%eax),%eax
  1047f5:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  1047f7:	c7 04 24 fc 6b 10 00 	movl   $0x106bfc,(%esp)
  1047fe:	e8 39 bb ff ff       	call   10033c <cprintf>
}
  104803:	c9                   	leave  
  104804:	c3                   	ret    

00104805 <check_pgdir>:

static void
check_pgdir(void) {
  104805:	55                   	push   %ebp
  104806:	89 e5                	mov    %esp,%ebp
  104808:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  10480b:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104810:	3d 00 80 03 00       	cmp    $0x38000,%eax
  104815:	76 24                	jbe    10483b <check_pgdir+0x36>
  104817:	c7 44 24 0c 1b 6c 10 	movl   $0x106c1b,0xc(%esp)
  10481e:	00 
  10481f:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104826:	00 
  104827:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
  10482e:	00 
  10482f:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104836:	e8 90 c4 ff ff       	call   100ccb <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  10483b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104840:	85 c0                	test   %eax,%eax
  104842:	74 0e                	je     104852 <check_pgdir+0x4d>
  104844:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104849:	25 ff 0f 00 00       	and    $0xfff,%eax
  10484e:	85 c0                	test   %eax,%eax
  104850:	74 24                	je     104876 <check_pgdir+0x71>
  104852:	c7 44 24 0c 38 6c 10 	movl   $0x106c38,0xc(%esp)
  104859:	00 
  10485a:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104861:	00 
  104862:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
  104869:	00 
  10486a:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104871:	e8 55 c4 ff ff       	call   100ccb <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  104876:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10487b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104882:	00 
  104883:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10488a:	00 
  10488b:	89 04 24             	mov    %eax,(%esp)
  10488e:	e8 3b fd ff ff       	call   1045ce <get_page>
  104893:	85 c0                	test   %eax,%eax
  104895:	74 24                	je     1048bb <check_pgdir+0xb6>
  104897:	c7 44 24 0c 70 6c 10 	movl   $0x106c70,0xc(%esp)
  10489e:	00 
  10489f:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  1048a6:	00 
  1048a7:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  1048ae:	00 
  1048af:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  1048b6:	e8 10 c4 ff ff       	call   100ccb <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  1048bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1048c2:	e8 86 f4 ff ff       	call   103d4d <alloc_pages>
  1048c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  1048ca:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1048cf:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1048d6:	00 
  1048d7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1048de:	00 
  1048df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1048e2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1048e6:	89 04 24             	mov    %eax,(%esp)
  1048e9:	e8 e3 fd ff ff       	call   1046d1 <page_insert>
  1048ee:	85 c0                	test   %eax,%eax
  1048f0:	74 24                	je     104916 <check_pgdir+0x111>
  1048f2:	c7 44 24 0c 98 6c 10 	movl   $0x106c98,0xc(%esp)
  1048f9:	00 
  1048fa:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104901:	00 
  104902:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  104909:	00 
  10490a:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104911:	e8 b5 c3 ff ff       	call   100ccb <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  104916:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10491b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104922:	00 
  104923:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10492a:	00 
  10492b:	89 04 24             	mov    %eax,(%esp)
  10492e:	e8 59 fb ff ff       	call   10448c <get_pte>
  104933:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104936:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10493a:	75 24                	jne    104960 <check_pgdir+0x15b>
  10493c:	c7 44 24 0c c4 6c 10 	movl   $0x106cc4,0xc(%esp)
  104943:	00 
  104944:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  10494b:	00 
  10494c:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
  104953:	00 
  104954:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  10495b:	e8 6b c3 ff ff       	call   100ccb <__panic>
    assert(pte2page(*ptep) == p1);
  104960:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104963:	8b 00                	mov    (%eax),%eax
  104965:	89 04 24             	mov    %eax,(%esp)
  104968:	e8 85 f1 ff ff       	call   103af2 <pte2page>
  10496d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104970:	74 24                	je     104996 <check_pgdir+0x191>
  104972:	c7 44 24 0c f1 6c 10 	movl   $0x106cf1,0xc(%esp)
  104979:	00 
  10497a:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104981:	00 
  104982:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  104989:	00 
  10498a:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104991:	e8 35 c3 ff ff       	call   100ccb <__panic>
    assert(page_ref(p1) == 1);
  104996:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104999:	89 04 24             	mov    %eax,(%esp)
  10499c:	e8 a7 f1 ff ff       	call   103b48 <page_ref>
  1049a1:	83 f8 01             	cmp    $0x1,%eax
  1049a4:	74 24                	je     1049ca <check_pgdir+0x1c5>
  1049a6:	c7 44 24 0c 07 6d 10 	movl   $0x106d07,0xc(%esp)
  1049ad:	00 
  1049ae:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  1049b5:	00 
  1049b6:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
  1049bd:	00 
  1049be:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  1049c5:	e8 01 c3 ff ff       	call   100ccb <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  1049ca:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1049cf:	8b 00                	mov    (%eax),%eax
  1049d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1049d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1049d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1049dc:	c1 e8 0c             	shr    $0xc,%eax
  1049df:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1049e2:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1049e7:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1049ea:	72 23                	jb     104a0f <check_pgdir+0x20a>
  1049ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1049ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1049f3:	c7 44 24 08 d4 6a 10 	movl   $0x106ad4,0x8(%esp)
  1049fa:	00 
  1049fb:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  104a02:	00 
  104a03:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104a0a:	e8 bc c2 ff ff       	call   100ccb <__panic>
  104a0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a12:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104a17:	83 c0 04             	add    $0x4,%eax
  104a1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  104a1d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a22:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a29:	00 
  104a2a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104a31:	00 
  104a32:	89 04 24             	mov    %eax,(%esp)
  104a35:	e8 52 fa ff ff       	call   10448c <get_pte>
  104a3a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104a3d:	74 24                	je     104a63 <check_pgdir+0x25e>
  104a3f:	c7 44 24 0c 1c 6d 10 	movl   $0x106d1c,0xc(%esp)
  104a46:	00 
  104a47:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104a4e:	00 
  104a4f:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  104a56:	00 
  104a57:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104a5e:	e8 68 c2 ff ff       	call   100ccb <__panic>

    p2 = alloc_page();
  104a63:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104a6a:	e8 de f2 ff ff       	call   103d4d <alloc_pages>
  104a6f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  104a72:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a77:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  104a7e:	00 
  104a7f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104a86:	00 
  104a87:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104a8a:	89 54 24 04          	mov    %edx,0x4(%esp)
  104a8e:	89 04 24             	mov    %eax,(%esp)
  104a91:	e8 3b fc ff ff       	call   1046d1 <page_insert>
  104a96:	85 c0                	test   %eax,%eax
  104a98:	74 24                	je     104abe <check_pgdir+0x2b9>
  104a9a:	c7 44 24 0c 44 6d 10 	movl   $0x106d44,0xc(%esp)
  104aa1:	00 
  104aa2:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104aa9:	00 
  104aaa:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  104ab1:	00 
  104ab2:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104ab9:	e8 0d c2 ff ff       	call   100ccb <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104abe:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104ac3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104aca:	00 
  104acb:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104ad2:	00 
  104ad3:	89 04 24             	mov    %eax,(%esp)
  104ad6:	e8 b1 f9 ff ff       	call   10448c <get_pte>
  104adb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104ade:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104ae2:	75 24                	jne    104b08 <check_pgdir+0x303>
  104ae4:	c7 44 24 0c 7c 6d 10 	movl   $0x106d7c,0xc(%esp)
  104aeb:	00 
  104aec:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104af3:	00 
  104af4:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  104afb:	00 
  104afc:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104b03:	e8 c3 c1 ff ff       	call   100ccb <__panic>
    assert(*ptep & PTE_U);
  104b08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b0b:	8b 00                	mov    (%eax),%eax
  104b0d:	83 e0 04             	and    $0x4,%eax
  104b10:	85 c0                	test   %eax,%eax
  104b12:	75 24                	jne    104b38 <check_pgdir+0x333>
  104b14:	c7 44 24 0c ac 6d 10 	movl   $0x106dac,0xc(%esp)
  104b1b:	00 
  104b1c:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104b23:	00 
  104b24:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  104b2b:	00 
  104b2c:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104b33:	e8 93 c1 ff ff       	call   100ccb <__panic>
    assert(*ptep & PTE_W);
  104b38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b3b:	8b 00                	mov    (%eax),%eax
  104b3d:	83 e0 02             	and    $0x2,%eax
  104b40:	85 c0                	test   %eax,%eax
  104b42:	75 24                	jne    104b68 <check_pgdir+0x363>
  104b44:	c7 44 24 0c ba 6d 10 	movl   $0x106dba,0xc(%esp)
  104b4b:	00 
  104b4c:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104b53:	00 
  104b54:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
  104b5b:	00 
  104b5c:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104b63:	e8 63 c1 ff ff       	call   100ccb <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104b68:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104b6d:	8b 00                	mov    (%eax),%eax
  104b6f:	83 e0 04             	and    $0x4,%eax
  104b72:	85 c0                	test   %eax,%eax
  104b74:	75 24                	jne    104b9a <check_pgdir+0x395>
  104b76:	c7 44 24 0c c8 6d 10 	movl   $0x106dc8,0xc(%esp)
  104b7d:	00 
  104b7e:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104b85:	00 
  104b86:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
  104b8d:	00 
  104b8e:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104b95:	e8 31 c1 ff ff       	call   100ccb <__panic>
    assert(page_ref(p2) == 1);
  104b9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b9d:	89 04 24             	mov    %eax,(%esp)
  104ba0:	e8 a3 ef ff ff       	call   103b48 <page_ref>
  104ba5:	83 f8 01             	cmp    $0x1,%eax
  104ba8:	74 24                	je     104bce <check_pgdir+0x3c9>
  104baa:	c7 44 24 0c de 6d 10 	movl   $0x106dde,0xc(%esp)
  104bb1:	00 
  104bb2:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104bb9:	00 
  104bba:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
  104bc1:	00 
  104bc2:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104bc9:	e8 fd c0 ff ff       	call   100ccb <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104bce:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104bd3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104bda:	00 
  104bdb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104be2:	00 
  104be3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104be6:	89 54 24 04          	mov    %edx,0x4(%esp)
  104bea:	89 04 24             	mov    %eax,(%esp)
  104bed:	e8 df fa ff ff       	call   1046d1 <page_insert>
  104bf2:	85 c0                	test   %eax,%eax
  104bf4:	74 24                	je     104c1a <check_pgdir+0x415>
  104bf6:	c7 44 24 0c f0 6d 10 	movl   $0x106df0,0xc(%esp)
  104bfd:	00 
  104bfe:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104c05:	00 
  104c06:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
  104c0d:	00 
  104c0e:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104c15:	e8 b1 c0 ff ff       	call   100ccb <__panic>
    assert(page_ref(p1) == 2);
  104c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c1d:	89 04 24             	mov    %eax,(%esp)
  104c20:	e8 23 ef ff ff       	call   103b48 <page_ref>
  104c25:	83 f8 02             	cmp    $0x2,%eax
  104c28:	74 24                	je     104c4e <check_pgdir+0x449>
  104c2a:	c7 44 24 0c 1c 6e 10 	movl   $0x106e1c,0xc(%esp)
  104c31:	00 
  104c32:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104c39:	00 
  104c3a:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
  104c41:	00 
  104c42:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104c49:	e8 7d c0 ff ff       	call   100ccb <__panic>
    assert(page_ref(p2) == 0);
  104c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c51:	89 04 24             	mov    %eax,(%esp)
  104c54:	e8 ef ee ff ff       	call   103b48 <page_ref>
  104c59:	85 c0                	test   %eax,%eax
  104c5b:	74 24                	je     104c81 <check_pgdir+0x47c>
  104c5d:	c7 44 24 0c 2e 6e 10 	movl   $0x106e2e,0xc(%esp)
  104c64:	00 
  104c65:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104c6c:	00 
  104c6d:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  104c74:	00 
  104c75:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104c7c:	e8 4a c0 ff ff       	call   100ccb <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104c81:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104c86:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104c8d:	00 
  104c8e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104c95:	00 
  104c96:	89 04 24             	mov    %eax,(%esp)
  104c99:	e8 ee f7 ff ff       	call   10448c <get_pte>
  104c9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104ca1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104ca5:	75 24                	jne    104ccb <check_pgdir+0x4c6>
  104ca7:	c7 44 24 0c 7c 6d 10 	movl   $0x106d7c,0xc(%esp)
  104cae:	00 
  104caf:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104cb6:	00 
  104cb7:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  104cbe:	00 
  104cbf:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104cc6:	e8 00 c0 ff ff       	call   100ccb <__panic>
    assert(pte2page(*ptep) == p1);
  104ccb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104cce:	8b 00                	mov    (%eax),%eax
  104cd0:	89 04 24             	mov    %eax,(%esp)
  104cd3:	e8 1a ee ff ff       	call   103af2 <pte2page>
  104cd8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104cdb:	74 24                	je     104d01 <check_pgdir+0x4fc>
  104cdd:	c7 44 24 0c f1 6c 10 	movl   $0x106cf1,0xc(%esp)
  104ce4:	00 
  104ce5:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104cec:	00 
  104ced:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  104cf4:	00 
  104cf5:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104cfc:	e8 ca bf ff ff       	call   100ccb <__panic>
    assert((*ptep & PTE_U) == 0);
  104d01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d04:	8b 00                	mov    (%eax),%eax
  104d06:	83 e0 04             	and    $0x4,%eax
  104d09:	85 c0                	test   %eax,%eax
  104d0b:	74 24                	je     104d31 <check_pgdir+0x52c>
  104d0d:	c7 44 24 0c 40 6e 10 	movl   $0x106e40,0xc(%esp)
  104d14:	00 
  104d15:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104d1c:	00 
  104d1d:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
  104d24:	00 
  104d25:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104d2c:	e8 9a bf ff ff       	call   100ccb <__panic>

    page_remove(boot_pgdir, 0x0);
  104d31:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104d36:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104d3d:	00 
  104d3e:	89 04 24             	mov    %eax,(%esp)
  104d41:	e8 47 f9 ff ff       	call   10468d <page_remove>
    assert(page_ref(p1) == 1);
  104d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d49:	89 04 24             	mov    %eax,(%esp)
  104d4c:	e8 f7 ed ff ff       	call   103b48 <page_ref>
  104d51:	83 f8 01             	cmp    $0x1,%eax
  104d54:	74 24                	je     104d7a <check_pgdir+0x575>
  104d56:	c7 44 24 0c 07 6d 10 	movl   $0x106d07,0xc(%esp)
  104d5d:	00 
  104d5e:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104d65:	00 
  104d66:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
  104d6d:	00 
  104d6e:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104d75:	e8 51 bf ff ff       	call   100ccb <__panic>
    assert(page_ref(p2) == 0);
  104d7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d7d:	89 04 24             	mov    %eax,(%esp)
  104d80:	e8 c3 ed ff ff       	call   103b48 <page_ref>
  104d85:	85 c0                	test   %eax,%eax
  104d87:	74 24                	je     104dad <check_pgdir+0x5a8>
  104d89:	c7 44 24 0c 2e 6e 10 	movl   $0x106e2e,0xc(%esp)
  104d90:	00 
  104d91:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104d98:	00 
  104d99:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
  104da0:	00 
  104da1:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104da8:	e8 1e bf ff ff       	call   100ccb <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104dad:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104db2:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104db9:	00 
  104dba:	89 04 24             	mov    %eax,(%esp)
  104dbd:	e8 cb f8 ff ff       	call   10468d <page_remove>
    assert(page_ref(p1) == 0);
  104dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104dc5:	89 04 24             	mov    %eax,(%esp)
  104dc8:	e8 7b ed ff ff       	call   103b48 <page_ref>
  104dcd:	85 c0                	test   %eax,%eax
  104dcf:	74 24                	je     104df5 <check_pgdir+0x5f0>
  104dd1:	c7 44 24 0c 55 6e 10 	movl   $0x106e55,0xc(%esp)
  104dd8:	00 
  104dd9:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104de0:	00 
  104de1:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
  104de8:	00 
  104de9:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104df0:	e8 d6 be ff ff       	call   100ccb <__panic>
    assert(page_ref(p2) == 0);
  104df5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104df8:	89 04 24             	mov    %eax,(%esp)
  104dfb:	e8 48 ed ff ff       	call   103b48 <page_ref>
  104e00:	85 c0                	test   %eax,%eax
  104e02:	74 24                	je     104e28 <check_pgdir+0x623>
  104e04:	c7 44 24 0c 2e 6e 10 	movl   $0x106e2e,0xc(%esp)
  104e0b:	00 
  104e0c:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104e13:	00 
  104e14:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
  104e1b:	00 
  104e1c:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104e23:	e8 a3 be ff ff       	call   100ccb <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  104e28:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e2d:	8b 00                	mov    (%eax),%eax
  104e2f:	89 04 24             	mov    %eax,(%esp)
  104e32:	e8 f9 ec ff ff       	call   103b30 <pde2page>
  104e37:	89 04 24             	mov    %eax,(%esp)
  104e3a:	e8 09 ed ff ff       	call   103b48 <page_ref>
  104e3f:	83 f8 01             	cmp    $0x1,%eax
  104e42:	74 24                	je     104e68 <check_pgdir+0x663>
  104e44:	c7 44 24 0c 68 6e 10 	movl   $0x106e68,0xc(%esp)
  104e4b:	00 
  104e4c:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104e53:	00 
  104e54:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
  104e5b:	00 
  104e5c:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104e63:	e8 63 be ff ff       	call   100ccb <__panic>
    free_page(pde2page(boot_pgdir[0]));
  104e68:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e6d:	8b 00                	mov    (%eax),%eax
  104e6f:	89 04 24             	mov    %eax,(%esp)
  104e72:	e8 b9 ec ff ff       	call   103b30 <pde2page>
  104e77:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104e7e:	00 
  104e7f:	89 04 24             	mov    %eax,(%esp)
  104e82:	e8 fe ee ff ff       	call   103d85 <free_pages>
    boot_pgdir[0] = 0;
  104e87:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104e92:	c7 04 24 8f 6e 10 00 	movl   $0x106e8f,(%esp)
  104e99:	e8 9e b4 ff ff       	call   10033c <cprintf>
}
  104e9e:	c9                   	leave  
  104e9f:	c3                   	ret    

00104ea0 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104ea0:	55                   	push   %ebp
  104ea1:	89 e5                	mov    %esp,%ebp
  104ea3:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104ea6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104ead:	e9 ca 00 00 00       	jmp    104f7c <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104eb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ebb:	c1 e8 0c             	shr    $0xc,%eax
  104ebe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104ec1:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104ec6:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104ec9:	72 23                	jb     104eee <check_boot_pgdir+0x4e>
  104ecb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ece:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104ed2:	c7 44 24 08 d4 6a 10 	movl   $0x106ad4,0x8(%esp)
  104ed9:	00 
  104eda:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
  104ee1:	00 
  104ee2:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104ee9:	e8 dd bd ff ff       	call   100ccb <__panic>
  104eee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ef1:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104ef6:	89 c2                	mov    %eax,%edx
  104ef8:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104efd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104f04:	00 
  104f05:	89 54 24 04          	mov    %edx,0x4(%esp)
  104f09:	89 04 24             	mov    %eax,(%esp)
  104f0c:	e8 7b f5 ff ff       	call   10448c <get_pte>
  104f11:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104f14:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104f18:	75 24                	jne    104f3e <check_boot_pgdir+0x9e>
  104f1a:	c7 44 24 0c ac 6e 10 	movl   $0x106eac,0xc(%esp)
  104f21:	00 
  104f22:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104f29:	00 
  104f2a:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
  104f31:	00 
  104f32:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104f39:	e8 8d bd ff ff       	call   100ccb <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104f3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104f41:	8b 00                	mov    (%eax),%eax
  104f43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104f48:	89 c2                	mov    %eax,%edx
  104f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f4d:	39 c2                	cmp    %eax,%edx
  104f4f:	74 24                	je     104f75 <check_boot_pgdir+0xd5>
  104f51:	c7 44 24 0c e9 6e 10 	movl   $0x106ee9,0xc(%esp)
  104f58:	00 
  104f59:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104f60:	00 
  104f61:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
  104f68:	00 
  104f69:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104f70:	e8 56 bd ff ff       	call   100ccb <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104f75:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104f7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104f7f:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104f84:	39 c2                	cmp    %eax,%edx
  104f86:	0f 82 26 ff ff ff    	jb     104eb2 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  104f8c:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f91:	05 ac 0f 00 00       	add    $0xfac,%eax
  104f96:	8b 00                	mov    (%eax),%eax
  104f98:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104f9d:	89 c2                	mov    %eax,%edx
  104f9f:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104fa4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104fa7:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  104fae:	77 23                	ja     104fd3 <check_boot_pgdir+0x133>
  104fb0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104fb3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104fb7:	c7 44 24 08 78 6b 10 	movl   $0x106b78,0x8(%esp)
  104fbe:	00 
  104fbf:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
  104fc6:	00 
  104fc7:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104fce:	e8 f8 bc ff ff       	call   100ccb <__panic>
  104fd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104fd6:	05 00 00 00 40       	add    $0x40000000,%eax
  104fdb:	39 c2                	cmp    %eax,%edx
  104fdd:	74 24                	je     105003 <check_boot_pgdir+0x163>
  104fdf:	c7 44 24 0c 00 6f 10 	movl   $0x106f00,0xc(%esp)
  104fe6:	00 
  104fe7:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104fee:	00 
  104fef:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
  104ff6:	00 
  104ff7:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104ffe:	e8 c8 bc ff ff       	call   100ccb <__panic>

    assert(boot_pgdir[0] == 0);
  105003:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105008:	8b 00                	mov    (%eax),%eax
  10500a:	85 c0                	test   %eax,%eax
  10500c:	74 24                	je     105032 <check_boot_pgdir+0x192>
  10500e:	c7 44 24 0c 34 6f 10 	movl   $0x106f34,0xc(%esp)
  105015:	00 
  105016:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  10501d:	00 
  10501e:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
  105025:	00 
  105026:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  10502d:	e8 99 bc ff ff       	call   100ccb <__panic>

    struct Page *p;
    p = alloc_page();
  105032:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105039:	e8 0f ed ff ff       	call   103d4d <alloc_pages>
  10503e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  105041:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105046:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  10504d:	00 
  10504e:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  105055:	00 
  105056:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105059:	89 54 24 04          	mov    %edx,0x4(%esp)
  10505d:	89 04 24             	mov    %eax,(%esp)
  105060:	e8 6c f6 ff ff       	call   1046d1 <page_insert>
  105065:	85 c0                	test   %eax,%eax
  105067:	74 24                	je     10508d <check_boot_pgdir+0x1ed>
  105069:	c7 44 24 0c 48 6f 10 	movl   $0x106f48,0xc(%esp)
  105070:	00 
  105071:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  105078:	00 
  105079:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
  105080:	00 
  105081:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  105088:	e8 3e bc ff ff       	call   100ccb <__panic>
    assert(page_ref(p) == 1);
  10508d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105090:	89 04 24             	mov    %eax,(%esp)
  105093:	e8 b0 ea ff ff       	call   103b48 <page_ref>
  105098:	83 f8 01             	cmp    $0x1,%eax
  10509b:	74 24                	je     1050c1 <check_boot_pgdir+0x221>
  10509d:	c7 44 24 0c 76 6f 10 	movl   $0x106f76,0xc(%esp)
  1050a4:	00 
  1050a5:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  1050ac:	00 
  1050ad:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
  1050b4:	00 
  1050b5:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  1050bc:	e8 0a bc ff ff       	call   100ccb <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  1050c1:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1050c6:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  1050cd:	00 
  1050ce:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  1050d5:	00 
  1050d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1050d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1050dd:	89 04 24             	mov    %eax,(%esp)
  1050e0:	e8 ec f5 ff ff       	call   1046d1 <page_insert>
  1050e5:	85 c0                	test   %eax,%eax
  1050e7:	74 24                	je     10510d <check_boot_pgdir+0x26d>
  1050e9:	c7 44 24 0c 88 6f 10 	movl   $0x106f88,0xc(%esp)
  1050f0:	00 
  1050f1:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  1050f8:	00 
  1050f9:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
  105100:	00 
  105101:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  105108:	e8 be bb ff ff       	call   100ccb <__panic>
    assert(page_ref(p) == 2);
  10510d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105110:	89 04 24             	mov    %eax,(%esp)
  105113:	e8 30 ea ff ff       	call   103b48 <page_ref>
  105118:	83 f8 02             	cmp    $0x2,%eax
  10511b:	74 24                	je     105141 <check_boot_pgdir+0x2a1>
  10511d:	c7 44 24 0c bf 6f 10 	movl   $0x106fbf,0xc(%esp)
  105124:	00 
  105125:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  10512c:	00 
  10512d:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
  105134:	00 
  105135:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  10513c:	e8 8a bb ff ff       	call   100ccb <__panic>

    const char *str = "ucore: Hello world!!";
  105141:	c7 45 dc d0 6f 10 00 	movl   $0x106fd0,-0x24(%ebp)
    strcpy((void *)0x100, str);
  105148:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10514b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10514f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105156:	e8 19 0a 00 00       	call   105b74 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  10515b:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  105162:	00 
  105163:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10516a:	e8 7e 0a 00 00       	call   105bed <strcmp>
  10516f:	85 c0                	test   %eax,%eax
  105171:	74 24                	je     105197 <check_boot_pgdir+0x2f7>
  105173:	c7 44 24 0c e8 6f 10 	movl   $0x106fe8,0xc(%esp)
  10517a:	00 
  10517b:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  105182:	00 
  105183:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
  10518a:	00 
  10518b:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  105192:	e8 34 bb ff ff       	call   100ccb <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  105197:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10519a:	89 04 24             	mov    %eax,(%esp)
  10519d:	e8 fc e8 ff ff       	call   103a9e <page2kva>
  1051a2:	05 00 01 00 00       	add    $0x100,%eax
  1051a7:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  1051aa:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1051b1:	e8 66 09 00 00       	call   105b1c <strlen>
  1051b6:	85 c0                	test   %eax,%eax
  1051b8:	74 24                	je     1051de <check_boot_pgdir+0x33e>
  1051ba:	c7 44 24 0c 20 70 10 	movl   $0x107020,0xc(%esp)
  1051c1:	00 
  1051c2:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  1051c9:	00 
  1051ca:	c7 44 24 04 44 02 00 	movl   $0x244,0x4(%esp)
  1051d1:	00 
  1051d2:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  1051d9:	e8 ed ba ff ff       	call   100ccb <__panic>

    free_page(p);
  1051de:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1051e5:	00 
  1051e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1051e9:	89 04 24             	mov    %eax,(%esp)
  1051ec:	e8 94 eb ff ff       	call   103d85 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  1051f1:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1051f6:	8b 00                	mov    (%eax),%eax
  1051f8:	89 04 24             	mov    %eax,(%esp)
  1051fb:	e8 30 e9 ff ff       	call   103b30 <pde2page>
  105200:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105207:	00 
  105208:	89 04 24             	mov    %eax,(%esp)
  10520b:	e8 75 eb ff ff       	call   103d85 <free_pages>
    boot_pgdir[0] = 0;
  105210:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105215:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  10521b:	c7 04 24 44 70 10 00 	movl   $0x107044,(%esp)
  105222:	e8 15 b1 ff ff       	call   10033c <cprintf>
}
  105227:	c9                   	leave  
  105228:	c3                   	ret    

00105229 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  105229:	55                   	push   %ebp
  10522a:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  10522c:	8b 45 08             	mov    0x8(%ebp),%eax
  10522f:	83 e0 04             	and    $0x4,%eax
  105232:	85 c0                	test   %eax,%eax
  105234:	74 07                	je     10523d <perm2str+0x14>
  105236:	b8 75 00 00 00       	mov    $0x75,%eax
  10523b:	eb 05                	jmp    105242 <perm2str+0x19>
  10523d:	b8 2d 00 00 00       	mov    $0x2d,%eax
  105242:	a2 48 89 11 00       	mov    %al,0x118948
    str[1] = 'r';
  105247:	c6 05 49 89 11 00 72 	movb   $0x72,0x118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  10524e:	8b 45 08             	mov    0x8(%ebp),%eax
  105251:	83 e0 02             	and    $0x2,%eax
  105254:	85 c0                	test   %eax,%eax
  105256:	74 07                	je     10525f <perm2str+0x36>
  105258:	b8 77 00 00 00       	mov    $0x77,%eax
  10525d:	eb 05                	jmp    105264 <perm2str+0x3b>
  10525f:	b8 2d 00 00 00       	mov    $0x2d,%eax
  105264:	a2 4a 89 11 00       	mov    %al,0x11894a
    str[3] = '\0';
  105269:	c6 05 4b 89 11 00 00 	movb   $0x0,0x11894b
    return str;
  105270:	b8 48 89 11 00       	mov    $0x118948,%eax
}
  105275:	5d                   	pop    %ebp
  105276:	c3                   	ret    

00105277 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  105277:	55                   	push   %ebp
  105278:	89 e5                	mov    %esp,%ebp
  10527a:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  10527d:	8b 45 10             	mov    0x10(%ebp),%eax
  105280:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105283:	72 0a                	jb     10528f <get_pgtable_items+0x18>
        return 0;
  105285:	b8 00 00 00 00       	mov    $0x0,%eax
  10528a:	e9 9c 00 00 00       	jmp    10532b <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  10528f:	eb 04                	jmp    105295 <get_pgtable_items+0x1e>
        start ++;
  105291:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  105295:	8b 45 10             	mov    0x10(%ebp),%eax
  105298:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10529b:	73 18                	jae    1052b5 <get_pgtable_items+0x3e>
  10529d:	8b 45 10             	mov    0x10(%ebp),%eax
  1052a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1052a7:	8b 45 14             	mov    0x14(%ebp),%eax
  1052aa:	01 d0                	add    %edx,%eax
  1052ac:	8b 00                	mov    (%eax),%eax
  1052ae:	83 e0 01             	and    $0x1,%eax
  1052b1:	85 c0                	test   %eax,%eax
  1052b3:	74 dc                	je     105291 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  1052b5:	8b 45 10             	mov    0x10(%ebp),%eax
  1052b8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1052bb:	73 69                	jae    105326 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  1052bd:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  1052c1:	74 08                	je     1052cb <get_pgtable_items+0x54>
            *left_store = start;
  1052c3:	8b 45 18             	mov    0x18(%ebp),%eax
  1052c6:	8b 55 10             	mov    0x10(%ebp),%edx
  1052c9:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  1052cb:	8b 45 10             	mov    0x10(%ebp),%eax
  1052ce:	8d 50 01             	lea    0x1(%eax),%edx
  1052d1:	89 55 10             	mov    %edx,0x10(%ebp)
  1052d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1052db:	8b 45 14             	mov    0x14(%ebp),%eax
  1052de:	01 d0                	add    %edx,%eax
  1052e0:	8b 00                	mov    (%eax),%eax
  1052e2:	83 e0 07             	and    $0x7,%eax
  1052e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1052e8:	eb 04                	jmp    1052ee <get_pgtable_items+0x77>
            start ++;
  1052ea:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  1052ee:	8b 45 10             	mov    0x10(%ebp),%eax
  1052f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1052f4:	73 1d                	jae    105313 <get_pgtable_items+0x9c>
  1052f6:	8b 45 10             	mov    0x10(%ebp),%eax
  1052f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105300:	8b 45 14             	mov    0x14(%ebp),%eax
  105303:	01 d0                	add    %edx,%eax
  105305:	8b 00                	mov    (%eax),%eax
  105307:	83 e0 07             	and    $0x7,%eax
  10530a:	89 c2                	mov    %eax,%edx
  10530c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10530f:	39 c2                	cmp    %eax,%edx
  105311:	74 d7                	je     1052ea <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
  105313:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105317:	74 08                	je     105321 <get_pgtable_items+0xaa>
            *right_store = start;
  105319:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10531c:	8b 55 10             	mov    0x10(%ebp),%edx
  10531f:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  105321:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105324:	eb 05                	jmp    10532b <get_pgtable_items+0xb4>
    }
    return 0;
  105326:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10532b:	c9                   	leave  
  10532c:	c3                   	ret    

0010532d <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  10532d:	55                   	push   %ebp
  10532e:	89 e5                	mov    %esp,%ebp
  105330:	57                   	push   %edi
  105331:	56                   	push   %esi
  105332:	53                   	push   %ebx
  105333:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  105336:	c7 04 24 64 70 10 00 	movl   $0x107064,(%esp)
  10533d:	e8 fa af ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
  105342:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105349:	e9 fa 00 00 00       	jmp    105448 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10534e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105351:	89 04 24             	mov    %eax,(%esp)
  105354:	e8 d0 fe ff ff       	call   105229 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  105359:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10535c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10535f:	29 d1                	sub    %edx,%ecx
  105361:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  105363:	89 d6                	mov    %edx,%esi
  105365:	c1 e6 16             	shl    $0x16,%esi
  105368:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10536b:	89 d3                	mov    %edx,%ebx
  10536d:	c1 e3 16             	shl    $0x16,%ebx
  105370:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105373:	89 d1                	mov    %edx,%ecx
  105375:	c1 e1 16             	shl    $0x16,%ecx
  105378:	8b 7d dc             	mov    -0x24(%ebp),%edi
  10537b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10537e:	29 d7                	sub    %edx,%edi
  105380:	89 fa                	mov    %edi,%edx
  105382:	89 44 24 14          	mov    %eax,0x14(%esp)
  105386:	89 74 24 10          	mov    %esi,0x10(%esp)
  10538a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10538e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105392:	89 54 24 04          	mov    %edx,0x4(%esp)
  105396:	c7 04 24 95 70 10 00 	movl   $0x107095,(%esp)
  10539d:	e8 9a af ff ff       	call   10033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  1053a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1053a5:	c1 e0 0a             	shl    $0xa,%eax
  1053a8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1053ab:	eb 54                	jmp    105401 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1053ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1053b0:	89 04 24             	mov    %eax,(%esp)
  1053b3:	e8 71 fe ff ff       	call   105229 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  1053b8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1053bb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1053be:	29 d1                	sub    %edx,%ecx
  1053c0:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1053c2:	89 d6                	mov    %edx,%esi
  1053c4:	c1 e6 0c             	shl    $0xc,%esi
  1053c7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1053ca:	89 d3                	mov    %edx,%ebx
  1053cc:	c1 e3 0c             	shl    $0xc,%ebx
  1053cf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1053d2:	c1 e2 0c             	shl    $0xc,%edx
  1053d5:	89 d1                	mov    %edx,%ecx
  1053d7:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  1053da:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1053dd:	29 d7                	sub    %edx,%edi
  1053df:	89 fa                	mov    %edi,%edx
  1053e1:	89 44 24 14          	mov    %eax,0x14(%esp)
  1053e5:	89 74 24 10          	mov    %esi,0x10(%esp)
  1053e9:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1053ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1053f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  1053f5:	c7 04 24 b4 70 10 00 	movl   $0x1070b4,(%esp)
  1053fc:	e8 3b af ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105401:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  105406:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105409:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10540c:	89 ce                	mov    %ecx,%esi
  10540e:	c1 e6 0a             	shl    $0xa,%esi
  105411:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  105414:	89 cb                	mov    %ecx,%ebx
  105416:	c1 e3 0a             	shl    $0xa,%ebx
  105419:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  10541c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  105420:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  105423:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  105427:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10542b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10542f:	89 74 24 04          	mov    %esi,0x4(%esp)
  105433:	89 1c 24             	mov    %ebx,(%esp)
  105436:	e8 3c fe ff ff       	call   105277 <get_pgtable_items>
  10543b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10543e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105442:	0f 85 65 ff ff ff    	jne    1053ad <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105448:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  10544d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105450:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  105453:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  105457:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  10545a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10545e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105462:	89 44 24 08          	mov    %eax,0x8(%esp)
  105466:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  10546d:	00 
  10546e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105475:	e8 fd fd ff ff       	call   105277 <get_pgtable_items>
  10547a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10547d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105481:	0f 85 c7 fe ff ff    	jne    10534e <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  105487:	c7 04 24 d8 70 10 00 	movl   $0x1070d8,(%esp)
  10548e:	e8 a9 ae ff ff       	call   10033c <cprintf>
}
  105493:	83 c4 4c             	add    $0x4c,%esp
  105496:	5b                   	pop    %ebx
  105497:	5e                   	pop    %esi
  105498:	5f                   	pop    %edi
  105499:	5d                   	pop    %ebp
  10549a:	c3                   	ret    

0010549b <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  10549b:	55                   	push   %ebp
  10549c:	89 e5                	mov    %esp,%ebp
  10549e:	83 ec 58             	sub    $0x58,%esp
  1054a1:	8b 45 10             	mov    0x10(%ebp),%eax
  1054a4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1054a7:	8b 45 14             	mov    0x14(%ebp),%eax
  1054aa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1054ad:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1054b0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1054b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1054b6:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1054b9:	8b 45 18             	mov    0x18(%ebp),%eax
  1054bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1054bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1054c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1054c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1054c8:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1054cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1054ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1054d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1054d5:	74 1c                	je     1054f3 <printnum+0x58>
  1054d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1054da:	ba 00 00 00 00       	mov    $0x0,%edx
  1054df:	f7 75 e4             	divl   -0x1c(%ebp)
  1054e2:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1054e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1054e8:	ba 00 00 00 00       	mov    $0x0,%edx
  1054ed:	f7 75 e4             	divl   -0x1c(%ebp)
  1054f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1054f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1054f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1054f9:	f7 75 e4             	divl   -0x1c(%ebp)
  1054fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1054ff:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105502:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105505:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105508:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10550b:	89 55 ec             	mov    %edx,-0x14(%ebp)
  10550e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105511:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  105514:	8b 45 18             	mov    0x18(%ebp),%eax
  105517:	ba 00 00 00 00       	mov    $0x0,%edx
  10551c:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10551f:	77 56                	ja     105577 <printnum+0xdc>
  105521:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  105524:	72 05                	jb     10552b <printnum+0x90>
  105526:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  105529:	77 4c                	ja     105577 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  10552b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10552e:	8d 50 ff             	lea    -0x1(%eax),%edx
  105531:	8b 45 20             	mov    0x20(%ebp),%eax
  105534:	89 44 24 18          	mov    %eax,0x18(%esp)
  105538:	89 54 24 14          	mov    %edx,0x14(%esp)
  10553c:	8b 45 18             	mov    0x18(%ebp),%eax
  10553f:	89 44 24 10          	mov    %eax,0x10(%esp)
  105543:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105546:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105549:	89 44 24 08          	mov    %eax,0x8(%esp)
  10554d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105551:	8b 45 0c             	mov    0xc(%ebp),%eax
  105554:	89 44 24 04          	mov    %eax,0x4(%esp)
  105558:	8b 45 08             	mov    0x8(%ebp),%eax
  10555b:	89 04 24             	mov    %eax,(%esp)
  10555e:	e8 38 ff ff ff       	call   10549b <printnum>
  105563:	eb 1c                	jmp    105581 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  105565:	8b 45 0c             	mov    0xc(%ebp),%eax
  105568:	89 44 24 04          	mov    %eax,0x4(%esp)
  10556c:	8b 45 20             	mov    0x20(%ebp),%eax
  10556f:	89 04 24             	mov    %eax,(%esp)
  105572:	8b 45 08             	mov    0x8(%ebp),%eax
  105575:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  105577:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  10557b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10557f:	7f e4                	jg     105565 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  105581:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105584:	05 8c 71 10 00       	add    $0x10718c,%eax
  105589:	0f b6 00             	movzbl (%eax),%eax
  10558c:	0f be c0             	movsbl %al,%eax
  10558f:	8b 55 0c             	mov    0xc(%ebp),%edx
  105592:	89 54 24 04          	mov    %edx,0x4(%esp)
  105596:	89 04 24             	mov    %eax,(%esp)
  105599:	8b 45 08             	mov    0x8(%ebp),%eax
  10559c:	ff d0                	call   *%eax
}
  10559e:	c9                   	leave  
  10559f:	c3                   	ret    

001055a0 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1055a0:	55                   	push   %ebp
  1055a1:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1055a3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1055a7:	7e 14                	jle    1055bd <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  1055a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1055ac:	8b 00                	mov    (%eax),%eax
  1055ae:	8d 48 08             	lea    0x8(%eax),%ecx
  1055b1:	8b 55 08             	mov    0x8(%ebp),%edx
  1055b4:	89 0a                	mov    %ecx,(%edx)
  1055b6:	8b 50 04             	mov    0x4(%eax),%edx
  1055b9:	8b 00                	mov    (%eax),%eax
  1055bb:	eb 30                	jmp    1055ed <getuint+0x4d>
    }
    else if (lflag) {
  1055bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1055c1:	74 16                	je     1055d9 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  1055c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1055c6:	8b 00                	mov    (%eax),%eax
  1055c8:	8d 48 04             	lea    0x4(%eax),%ecx
  1055cb:	8b 55 08             	mov    0x8(%ebp),%edx
  1055ce:	89 0a                	mov    %ecx,(%edx)
  1055d0:	8b 00                	mov    (%eax),%eax
  1055d2:	ba 00 00 00 00       	mov    $0x0,%edx
  1055d7:	eb 14                	jmp    1055ed <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  1055d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1055dc:	8b 00                	mov    (%eax),%eax
  1055de:	8d 48 04             	lea    0x4(%eax),%ecx
  1055e1:	8b 55 08             	mov    0x8(%ebp),%edx
  1055e4:	89 0a                	mov    %ecx,(%edx)
  1055e6:	8b 00                	mov    (%eax),%eax
  1055e8:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1055ed:	5d                   	pop    %ebp
  1055ee:	c3                   	ret    

001055ef <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1055ef:	55                   	push   %ebp
  1055f0:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1055f2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1055f6:	7e 14                	jle    10560c <getint+0x1d>
        return va_arg(*ap, long long);
  1055f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1055fb:	8b 00                	mov    (%eax),%eax
  1055fd:	8d 48 08             	lea    0x8(%eax),%ecx
  105600:	8b 55 08             	mov    0x8(%ebp),%edx
  105603:	89 0a                	mov    %ecx,(%edx)
  105605:	8b 50 04             	mov    0x4(%eax),%edx
  105608:	8b 00                	mov    (%eax),%eax
  10560a:	eb 28                	jmp    105634 <getint+0x45>
    }
    else if (lflag) {
  10560c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105610:	74 12                	je     105624 <getint+0x35>
        return va_arg(*ap, long);
  105612:	8b 45 08             	mov    0x8(%ebp),%eax
  105615:	8b 00                	mov    (%eax),%eax
  105617:	8d 48 04             	lea    0x4(%eax),%ecx
  10561a:	8b 55 08             	mov    0x8(%ebp),%edx
  10561d:	89 0a                	mov    %ecx,(%edx)
  10561f:	8b 00                	mov    (%eax),%eax
  105621:	99                   	cltd   
  105622:	eb 10                	jmp    105634 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  105624:	8b 45 08             	mov    0x8(%ebp),%eax
  105627:	8b 00                	mov    (%eax),%eax
  105629:	8d 48 04             	lea    0x4(%eax),%ecx
  10562c:	8b 55 08             	mov    0x8(%ebp),%edx
  10562f:	89 0a                	mov    %ecx,(%edx)
  105631:	8b 00                	mov    (%eax),%eax
  105633:	99                   	cltd   
    }
}
  105634:	5d                   	pop    %ebp
  105635:	c3                   	ret    

00105636 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  105636:	55                   	push   %ebp
  105637:	89 e5                	mov    %esp,%ebp
  105639:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  10563c:	8d 45 14             	lea    0x14(%ebp),%eax
  10563f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105645:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105649:	8b 45 10             	mov    0x10(%ebp),%eax
  10564c:	89 44 24 08          	mov    %eax,0x8(%esp)
  105650:	8b 45 0c             	mov    0xc(%ebp),%eax
  105653:	89 44 24 04          	mov    %eax,0x4(%esp)
  105657:	8b 45 08             	mov    0x8(%ebp),%eax
  10565a:	89 04 24             	mov    %eax,(%esp)
  10565d:	e8 02 00 00 00       	call   105664 <vprintfmt>
    va_end(ap);
}
  105662:	c9                   	leave  
  105663:	c3                   	ret    

00105664 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  105664:	55                   	push   %ebp
  105665:	89 e5                	mov    %esp,%ebp
  105667:	56                   	push   %esi
  105668:	53                   	push   %ebx
  105669:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10566c:	eb 18                	jmp    105686 <vprintfmt+0x22>
            if (ch == '\0') {
  10566e:	85 db                	test   %ebx,%ebx
  105670:	75 05                	jne    105677 <vprintfmt+0x13>
                return;
  105672:	e9 d1 03 00 00       	jmp    105a48 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  105677:	8b 45 0c             	mov    0xc(%ebp),%eax
  10567a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10567e:	89 1c 24             	mov    %ebx,(%esp)
  105681:	8b 45 08             	mov    0x8(%ebp),%eax
  105684:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105686:	8b 45 10             	mov    0x10(%ebp),%eax
  105689:	8d 50 01             	lea    0x1(%eax),%edx
  10568c:	89 55 10             	mov    %edx,0x10(%ebp)
  10568f:	0f b6 00             	movzbl (%eax),%eax
  105692:	0f b6 d8             	movzbl %al,%ebx
  105695:	83 fb 25             	cmp    $0x25,%ebx
  105698:	75 d4                	jne    10566e <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  10569a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  10569e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1056a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1056a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1056ab:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1056b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1056b5:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  1056b8:	8b 45 10             	mov    0x10(%ebp),%eax
  1056bb:	8d 50 01             	lea    0x1(%eax),%edx
  1056be:	89 55 10             	mov    %edx,0x10(%ebp)
  1056c1:	0f b6 00             	movzbl (%eax),%eax
  1056c4:	0f b6 d8             	movzbl %al,%ebx
  1056c7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  1056ca:	83 f8 55             	cmp    $0x55,%eax
  1056cd:	0f 87 44 03 00 00    	ja     105a17 <vprintfmt+0x3b3>
  1056d3:	8b 04 85 b0 71 10 00 	mov    0x1071b0(,%eax,4),%eax
  1056da:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  1056dc:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  1056e0:	eb d6                	jmp    1056b8 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1056e2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1056e6:	eb d0                	jmp    1056b8 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1056e8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1056ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1056f2:	89 d0                	mov    %edx,%eax
  1056f4:	c1 e0 02             	shl    $0x2,%eax
  1056f7:	01 d0                	add    %edx,%eax
  1056f9:	01 c0                	add    %eax,%eax
  1056fb:	01 d8                	add    %ebx,%eax
  1056fd:	83 e8 30             	sub    $0x30,%eax
  105700:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105703:	8b 45 10             	mov    0x10(%ebp),%eax
  105706:	0f b6 00             	movzbl (%eax),%eax
  105709:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  10570c:	83 fb 2f             	cmp    $0x2f,%ebx
  10570f:	7e 0b                	jle    10571c <vprintfmt+0xb8>
  105711:	83 fb 39             	cmp    $0x39,%ebx
  105714:	7f 06                	jg     10571c <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105716:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  10571a:	eb d3                	jmp    1056ef <vprintfmt+0x8b>
            goto process_precision;
  10571c:	eb 33                	jmp    105751 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  10571e:	8b 45 14             	mov    0x14(%ebp),%eax
  105721:	8d 50 04             	lea    0x4(%eax),%edx
  105724:	89 55 14             	mov    %edx,0x14(%ebp)
  105727:	8b 00                	mov    (%eax),%eax
  105729:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  10572c:	eb 23                	jmp    105751 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  10572e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105732:	79 0c                	jns    105740 <vprintfmt+0xdc>
                width = 0;
  105734:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  10573b:	e9 78 ff ff ff       	jmp    1056b8 <vprintfmt+0x54>
  105740:	e9 73 ff ff ff       	jmp    1056b8 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  105745:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  10574c:	e9 67 ff ff ff       	jmp    1056b8 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  105751:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105755:	79 12                	jns    105769 <vprintfmt+0x105>
                width = precision, precision = -1;
  105757:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10575a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10575d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  105764:	e9 4f ff ff ff       	jmp    1056b8 <vprintfmt+0x54>
  105769:	e9 4a ff ff ff       	jmp    1056b8 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  10576e:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  105772:	e9 41 ff ff ff       	jmp    1056b8 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  105777:	8b 45 14             	mov    0x14(%ebp),%eax
  10577a:	8d 50 04             	lea    0x4(%eax),%edx
  10577d:	89 55 14             	mov    %edx,0x14(%ebp)
  105780:	8b 00                	mov    (%eax),%eax
  105782:	8b 55 0c             	mov    0xc(%ebp),%edx
  105785:	89 54 24 04          	mov    %edx,0x4(%esp)
  105789:	89 04 24             	mov    %eax,(%esp)
  10578c:	8b 45 08             	mov    0x8(%ebp),%eax
  10578f:	ff d0                	call   *%eax
            break;
  105791:	e9 ac 02 00 00       	jmp    105a42 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  105796:	8b 45 14             	mov    0x14(%ebp),%eax
  105799:	8d 50 04             	lea    0x4(%eax),%edx
  10579c:	89 55 14             	mov    %edx,0x14(%ebp)
  10579f:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1057a1:	85 db                	test   %ebx,%ebx
  1057a3:	79 02                	jns    1057a7 <vprintfmt+0x143>
                err = -err;
  1057a5:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1057a7:	83 fb 06             	cmp    $0x6,%ebx
  1057aa:	7f 0b                	jg     1057b7 <vprintfmt+0x153>
  1057ac:	8b 34 9d 70 71 10 00 	mov    0x107170(,%ebx,4),%esi
  1057b3:	85 f6                	test   %esi,%esi
  1057b5:	75 23                	jne    1057da <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  1057b7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1057bb:	c7 44 24 08 9d 71 10 	movl   $0x10719d,0x8(%esp)
  1057c2:	00 
  1057c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1057cd:	89 04 24             	mov    %eax,(%esp)
  1057d0:	e8 61 fe ff ff       	call   105636 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  1057d5:	e9 68 02 00 00       	jmp    105a42 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  1057da:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1057de:	c7 44 24 08 a6 71 10 	movl   $0x1071a6,0x8(%esp)
  1057e5:	00 
  1057e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1057f0:	89 04 24             	mov    %eax,(%esp)
  1057f3:	e8 3e fe ff ff       	call   105636 <printfmt>
            }
            break;
  1057f8:	e9 45 02 00 00       	jmp    105a42 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1057fd:	8b 45 14             	mov    0x14(%ebp),%eax
  105800:	8d 50 04             	lea    0x4(%eax),%edx
  105803:	89 55 14             	mov    %edx,0x14(%ebp)
  105806:	8b 30                	mov    (%eax),%esi
  105808:	85 f6                	test   %esi,%esi
  10580a:	75 05                	jne    105811 <vprintfmt+0x1ad>
                p = "(null)";
  10580c:	be a9 71 10 00       	mov    $0x1071a9,%esi
            }
            if (width > 0 && padc != '-') {
  105811:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105815:	7e 3e                	jle    105855 <vprintfmt+0x1f1>
  105817:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  10581b:	74 38                	je     105855 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  10581d:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  105820:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105823:	89 44 24 04          	mov    %eax,0x4(%esp)
  105827:	89 34 24             	mov    %esi,(%esp)
  10582a:	e8 15 03 00 00       	call   105b44 <strnlen>
  10582f:	29 c3                	sub    %eax,%ebx
  105831:	89 d8                	mov    %ebx,%eax
  105833:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105836:	eb 17                	jmp    10584f <vprintfmt+0x1eb>
                    putch(padc, putdat);
  105838:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  10583c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10583f:	89 54 24 04          	mov    %edx,0x4(%esp)
  105843:	89 04 24             	mov    %eax,(%esp)
  105846:	8b 45 08             	mov    0x8(%ebp),%eax
  105849:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  10584b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10584f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105853:	7f e3                	jg     105838 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105855:	eb 38                	jmp    10588f <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  105857:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10585b:	74 1f                	je     10587c <vprintfmt+0x218>
  10585d:	83 fb 1f             	cmp    $0x1f,%ebx
  105860:	7e 05                	jle    105867 <vprintfmt+0x203>
  105862:	83 fb 7e             	cmp    $0x7e,%ebx
  105865:	7e 15                	jle    10587c <vprintfmt+0x218>
                    putch('?', putdat);
  105867:	8b 45 0c             	mov    0xc(%ebp),%eax
  10586a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10586e:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  105875:	8b 45 08             	mov    0x8(%ebp),%eax
  105878:	ff d0                	call   *%eax
  10587a:	eb 0f                	jmp    10588b <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  10587c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10587f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105883:	89 1c 24             	mov    %ebx,(%esp)
  105886:	8b 45 08             	mov    0x8(%ebp),%eax
  105889:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10588b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10588f:	89 f0                	mov    %esi,%eax
  105891:	8d 70 01             	lea    0x1(%eax),%esi
  105894:	0f b6 00             	movzbl (%eax),%eax
  105897:	0f be d8             	movsbl %al,%ebx
  10589a:	85 db                	test   %ebx,%ebx
  10589c:	74 10                	je     1058ae <vprintfmt+0x24a>
  10589e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1058a2:	78 b3                	js     105857 <vprintfmt+0x1f3>
  1058a4:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  1058a8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1058ac:	79 a9                	jns    105857 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1058ae:	eb 17                	jmp    1058c7 <vprintfmt+0x263>
                putch(' ', putdat);
  1058b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058b7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1058be:	8b 45 08             	mov    0x8(%ebp),%eax
  1058c1:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1058c3:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1058c7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1058cb:	7f e3                	jg     1058b0 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  1058cd:	e9 70 01 00 00       	jmp    105a42 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1058d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1058d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058d9:	8d 45 14             	lea    0x14(%ebp),%eax
  1058dc:	89 04 24             	mov    %eax,(%esp)
  1058df:	e8 0b fd ff ff       	call   1055ef <getint>
  1058e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058e7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1058ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1058f0:	85 d2                	test   %edx,%edx
  1058f2:	79 26                	jns    10591a <vprintfmt+0x2b6>
                putch('-', putdat);
  1058f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058fb:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105902:	8b 45 08             	mov    0x8(%ebp),%eax
  105905:	ff d0                	call   *%eax
                num = -(long long)num;
  105907:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10590a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10590d:	f7 d8                	neg    %eax
  10590f:	83 d2 00             	adc    $0x0,%edx
  105912:	f7 da                	neg    %edx
  105914:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105917:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  10591a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105921:	e9 a8 00 00 00       	jmp    1059ce <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105926:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105929:	89 44 24 04          	mov    %eax,0x4(%esp)
  10592d:	8d 45 14             	lea    0x14(%ebp),%eax
  105930:	89 04 24             	mov    %eax,(%esp)
  105933:	e8 68 fc ff ff       	call   1055a0 <getuint>
  105938:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10593b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  10593e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105945:	e9 84 00 00 00       	jmp    1059ce <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  10594a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10594d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105951:	8d 45 14             	lea    0x14(%ebp),%eax
  105954:	89 04 24             	mov    %eax,(%esp)
  105957:	e8 44 fc ff ff       	call   1055a0 <getuint>
  10595c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10595f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105962:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105969:	eb 63                	jmp    1059ce <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  10596b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10596e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105972:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105979:	8b 45 08             	mov    0x8(%ebp),%eax
  10597c:	ff d0                	call   *%eax
            putch('x', putdat);
  10597e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105981:	89 44 24 04          	mov    %eax,0x4(%esp)
  105985:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  10598c:	8b 45 08             	mov    0x8(%ebp),%eax
  10598f:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105991:	8b 45 14             	mov    0x14(%ebp),%eax
  105994:	8d 50 04             	lea    0x4(%eax),%edx
  105997:	89 55 14             	mov    %edx,0x14(%ebp)
  10599a:	8b 00                	mov    (%eax),%eax
  10599c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10599f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  1059a6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  1059ad:	eb 1f                	jmp    1059ce <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  1059af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1059b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059b6:	8d 45 14             	lea    0x14(%ebp),%eax
  1059b9:	89 04 24             	mov    %eax,(%esp)
  1059bc:	e8 df fb ff ff       	call   1055a0 <getuint>
  1059c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1059c4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  1059c7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  1059ce:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  1059d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1059d5:	89 54 24 18          	mov    %edx,0x18(%esp)
  1059d9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1059dc:	89 54 24 14          	mov    %edx,0x14(%esp)
  1059e0:	89 44 24 10          	mov    %eax,0x10(%esp)
  1059e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1059e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1059ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  1059ee:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1059f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1059fc:	89 04 24             	mov    %eax,(%esp)
  1059ff:	e8 97 fa ff ff       	call   10549b <printnum>
            break;
  105a04:	eb 3c                	jmp    105a42 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105a06:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a09:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a0d:	89 1c 24             	mov    %ebx,(%esp)
  105a10:	8b 45 08             	mov    0x8(%ebp),%eax
  105a13:	ff d0                	call   *%eax
            break;
  105a15:	eb 2b                	jmp    105a42 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105a17:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a1e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105a25:	8b 45 08             	mov    0x8(%ebp),%eax
  105a28:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105a2a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105a2e:	eb 04                	jmp    105a34 <vprintfmt+0x3d0>
  105a30:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105a34:	8b 45 10             	mov    0x10(%ebp),%eax
  105a37:	83 e8 01             	sub    $0x1,%eax
  105a3a:	0f b6 00             	movzbl (%eax),%eax
  105a3d:	3c 25                	cmp    $0x25,%al
  105a3f:	75 ef                	jne    105a30 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  105a41:	90                   	nop
        }
    }
  105a42:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105a43:	e9 3e fc ff ff       	jmp    105686 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  105a48:	83 c4 40             	add    $0x40,%esp
  105a4b:	5b                   	pop    %ebx
  105a4c:	5e                   	pop    %esi
  105a4d:	5d                   	pop    %ebp
  105a4e:	c3                   	ret    

00105a4f <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105a4f:	55                   	push   %ebp
  105a50:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105a52:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a55:	8b 40 08             	mov    0x8(%eax),%eax
  105a58:	8d 50 01             	lea    0x1(%eax),%edx
  105a5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a5e:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105a61:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a64:	8b 10                	mov    (%eax),%edx
  105a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a69:	8b 40 04             	mov    0x4(%eax),%eax
  105a6c:	39 c2                	cmp    %eax,%edx
  105a6e:	73 12                	jae    105a82 <sprintputch+0x33>
        *b->buf ++ = ch;
  105a70:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a73:	8b 00                	mov    (%eax),%eax
  105a75:	8d 48 01             	lea    0x1(%eax),%ecx
  105a78:	8b 55 0c             	mov    0xc(%ebp),%edx
  105a7b:	89 0a                	mov    %ecx,(%edx)
  105a7d:	8b 55 08             	mov    0x8(%ebp),%edx
  105a80:	88 10                	mov    %dl,(%eax)
    }
}
  105a82:	5d                   	pop    %ebp
  105a83:	c3                   	ret    

00105a84 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105a84:	55                   	push   %ebp
  105a85:	89 e5                	mov    %esp,%ebp
  105a87:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105a8a:	8d 45 14             	lea    0x14(%ebp),%eax
  105a8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105a90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a93:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105a97:	8b 45 10             	mov    0x10(%ebp),%eax
  105a9a:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105aa1:	89 44 24 04          	mov    %eax,0x4(%esp)
  105aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  105aa8:	89 04 24             	mov    %eax,(%esp)
  105aab:	e8 08 00 00 00       	call   105ab8 <vsnprintf>
  105ab0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105ab6:	c9                   	leave  
  105ab7:	c3                   	ret    

00105ab8 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105ab8:	55                   	push   %ebp
  105ab9:	89 e5                	mov    %esp,%ebp
  105abb:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105abe:	8b 45 08             	mov    0x8(%ebp),%eax
  105ac1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105ac4:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ac7:	8d 50 ff             	lea    -0x1(%eax),%edx
  105aca:	8b 45 08             	mov    0x8(%ebp),%eax
  105acd:	01 d0                	add    %edx,%eax
  105acf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ad2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105ad9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105add:	74 0a                	je     105ae9 <vsnprintf+0x31>
  105adf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105ae2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ae5:	39 c2                	cmp    %eax,%edx
  105ae7:	76 07                	jbe    105af0 <vsnprintf+0x38>
        return -E_INVAL;
  105ae9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105aee:	eb 2a                	jmp    105b1a <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105af0:	8b 45 14             	mov    0x14(%ebp),%eax
  105af3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105af7:	8b 45 10             	mov    0x10(%ebp),%eax
  105afa:	89 44 24 08          	mov    %eax,0x8(%esp)
  105afe:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105b01:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b05:	c7 04 24 4f 5a 10 00 	movl   $0x105a4f,(%esp)
  105b0c:	e8 53 fb ff ff       	call   105664 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105b11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105b14:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105b1a:	c9                   	leave  
  105b1b:	c3                   	ret    

00105b1c <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105b1c:	55                   	push   %ebp
  105b1d:	89 e5                	mov    %esp,%ebp
  105b1f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105b22:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105b29:	eb 04                	jmp    105b2f <strlen+0x13>
        cnt ++;
  105b2b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  105b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  105b32:	8d 50 01             	lea    0x1(%eax),%edx
  105b35:	89 55 08             	mov    %edx,0x8(%ebp)
  105b38:	0f b6 00             	movzbl (%eax),%eax
  105b3b:	84 c0                	test   %al,%al
  105b3d:	75 ec                	jne    105b2b <strlen+0xf>
        cnt ++;
    }
    return cnt;
  105b3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105b42:	c9                   	leave  
  105b43:	c3                   	ret    

00105b44 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105b44:	55                   	push   %ebp
  105b45:	89 e5                	mov    %esp,%ebp
  105b47:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105b4a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105b51:	eb 04                	jmp    105b57 <strnlen+0x13>
        cnt ++;
  105b53:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  105b57:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b5a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105b5d:	73 10                	jae    105b6f <strnlen+0x2b>
  105b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  105b62:	8d 50 01             	lea    0x1(%eax),%edx
  105b65:	89 55 08             	mov    %edx,0x8(%ebp)
  105b68:	0f b6 00             	movzbl (%eax),%eax
  105b6b:	84 c0                	test   %al,%al
  105b6d:	75 e4                	jne    105b53 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  105b6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105b72:	c9                   	leave  
  105b73:	c3                   	ret    

00105b74 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105b74:	55                   	push   %ebp
  105b75:	89 e5                	mov    %esp,%ebp
  105b77:	57                   	push   %edi
  105b78:	56                   	push   %esi
  105b79:	83 ec 20             	sub    $0x20,%esp
  105b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  105b7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105b82:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b85:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105b88:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105b8e:	89 d1                	mov    %edx,%ecx
  105b90:	89 c2                	mov    %eax,%edx
  105b92:	89 ce                	mov    %ecx,%esi
  105b94:	89 d7                	mov    %edx,%edi
  105b96:	ac                   	lods   %ds:(%esi),%al
  105b97:	aa                   	stos   %al,%es:(%edi)
  105b98:	84 c0                	test   %al,%al
  105b9a:	75 fa                	jne    105b96 <strcpy+0x22>
  105b9c:	89 fa                	mov    %edi,%edx
  105b9e:	89 f1                	mov    %esi,%ecx
  105ba0:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105ba3:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105ba6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105bac:	83 c4 20             	add    $0x20,%esp
  105baf:	5e                   	pop    %esi
  105bb0:	5f                   	pop    %edi
  105bb1:	5d                   	pop    %ebp
  105bb2:	c3                   	ret    

00105bb3 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105bb3:	55                   	push   %ebp
  105bb4:	89 e5                	mov    %esp,%ebp
  105bb6:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  105bbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105bbf:	eb 21                	jmp    105be2 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bc4:	0f b6 10             	movzbl (%eax),%edx
  105bc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105bca:	88 10                	mov    %dl,(%eax)
  105bcc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105bcf:	0f b6 00             	movzbl (%eax),%eax
  105bd2:	84 c0                	test   %al,%al
  105bd4:	74 04                	je     105bda <strncpy+0x27>
            src ++;
  105bd6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105bda:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105bde:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  105be2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105be6:	75 d9                	jne    105bc1 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105be8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105beb:	c9                   	leave  
  105bec:	c3                   	ret    

00105bed <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105bed:	55                   	push   %ebp
  105bee:	89 e5                	mov    %esp,%ebp
  105bf0:	57                   	push   %edi
  105bf1:	56                   	push   %esi
  105bf2:	83 ec 20             	sub    $0x20,%esp
  105bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  105bf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  105c01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105c04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c07:	89 d1                	mov    %edx,%ecx
  105c09:	89 c2                	mov    %eax,%edx
  105c0b:	89 ce                	mov    %ecx,%esi
  105c0d:	89 d7                	mov    %edx,%edi
  105c0f:	ac                   	lods   %ds:(%esi),%al
  105c10:	ae                   	scas   %es:(%edi),%al
  105c11:	75 08                	jne    105c1b <strcmp+0x2e>
  105c13:	84 c0                	test   %al,%al
  105c15:	75 f8                	jne    105c0f <strcmp+0x22>
  105c17:	31 c0                	xor    %eax,%eax
  105c19:	eb 04                	jmp    105c1f <strcmp+0x32>
  105c1b:	19 c0                	sbb    %eax,%eax
  105c1d:	0c 01                	or     $0x1,%al
  105c1f:	89 fa                	mov    %edi,%edx
  105c21:	89 f1                	mov    %esi,%ecx
  105c23:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105c26:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105c29:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105c2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105c2f:	83 c4 20             	add    $0x20,%esp
  105c32:	5e                   	pop    %esi
  105c33:	5f                   	pop    %edi
  105c34:	5d                   	pop    %ebp
  105c35:	c3                   	ret    

00105c36 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105c36:	55                   	push   %ebp
  105c37:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105c39:	eb 0c                	jmp    105c47 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105c3b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105c3f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105c43:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105c47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c4b:	74 1a                	je     105c67 <strncmp+0x31>
  105c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  105c50:	0f b6 00             	movzbl (%eax),%eax
  105c53:	84 c0                	test   %al,%al
  105c55:	74 10                	je     105c67 <strncmp+0x31>
  105c57:	8b 45 08             	mov    0x8(%ebp),%eax
  105c5a:	0f b6 10             	movzbl (%eax),%edx
  105c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c60:	0f b6 00             	movzbl (%eax),%eax
  105c63:	38 c2                	cmp    %al,%dl
  105c65:	74 d4                	je     105c3b <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105c67:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c6b:	74 18                	je     105c85 <strncmp+0x4f>
  105c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  105c70:	0f b6 00             	movzbl (%eax),%eax
  105c73:	0f b6 d0             	movzbl %al,%edx
  105c76:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c79:	0f b6 00             	movzbl (%eax),%eax
  105c7c:	0f b6 c0             	movzbl %al,%eax
  105c7f:	29 c2                	sub    %eax,%edx
  105c81:	89 d0                	mov    %edx,%eax
  105c83:	eb 05                	jmp    105c8a <strncmp+0x54>
  105c85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105c8a:	5d                   	pop    %ebp
  105c8b:	c3                   	ret    

00105c8c <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105c8c:	55                   	push   %ebp
  105c8d:	89 e5                	mov    %esp,%ebp
  105c8f:	83 ec 04             	sub    $0x4,%esp
  105c92:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c95:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105c98:	eb 14                	jmp    105cae <strchr+0x22>
        if (*s == c) {
  105c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  105c9d:	0f b6 00             	movzbl (%eax),%eax
  105ca0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105ca3:	75 05                	jne    105caa <strchr+0x1e>
            return (char *)s;
  105ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  105ca8:	eb 13                	jmp    105cbd <strchr+0x31>
        }
        s ++;
  105caa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105cae:	8b 45 08             	mov    0x8(%ebp),%eax
  105cb1:	0f b6 00             	movzbl (%eax),%eax
  105cb4:	84 c0                	test   %al,%al
  105cb6:	75 e2                	jne    105c9a <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105cb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105cbd:	c9                   	leave  
  105cbe:	c3                   	ret    

00105cbf <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105cbf:	55                   	push   %ebp
  105cc0:	89 e5                	mov    %esp,%ebp
  105cc2:	83 ec 04             	sub    $0x4,%esp
  105cc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cc8:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105ccb:	eb 11                	jmp    105cde <strfind+0x1f>
        if (*s == c) {
  105ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  105cd0:	0f b6 00             	movzbl (%eax),%eax
  105cd3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105cd6:	75 02                	jne    105cda <strfind+0x1b>
            break;
  105cd8:	eb 0e                	jmp    105ce8 <strfind+0x29>
        }
        s ++;
  105cda:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105cde:	8b 45 08             	mov    0x8(%ebp),%eax
  105ce1:	0f b6 00             	movzbl (%eax),%eax
  105ce4:	84 c0                	test   %al,%al
  105ce6:	75 e5                	jne    105ccd <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  105ce8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105ceb:	c9                   	leave  
  105cec:	c3                   	ret    

00105ced <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105ced:	55                   	push   %ebp
  105cee:	89 e5                	mov    %esp,%ebp
  105cf0:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105cf3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105cfa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105d01:	eb 04                	jmp    105d07 <strtol+0x1a>
        s ++;
  105d03:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105d07:	8b 45 08             	mov    0x8(%ebp),%eax
  105d0a:	0f b6 00             	movzbl (%eax),%eax
  105d0d:	3c 20                	cmp    $0x20,%al
  105d0f:	74 f2                	je     105d03 <strtol+0x16>
  105d11:	8b 45 08             	mov    0x8(%ebp),%eax
  105d14:	0f b6 00             	movzbl (%eax),%eax
  105d17:	3c 09                	cmp    $0x9,%al
  105d19:	74 e8                	je     105d03 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  105d1e:	0f b6 00             	movzbl (%eax),%eax
  105d21:	3c 2b                	cmp    $0x2b,%al
  105d23:	75 06                	jne    105d2b <strtol+0x3e>
        s ++;
  105d25:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105d29:	eb 15                	jmp    105d40 <strtol+0x53>
    }
    else if (*s == '-') {
  105d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  105d2e:	0f b6 00             	movzbl (%eax),%eax
  105d31:	3c 2d                	cmp    $0x2d,%al
  105d33:	75 0b                	jne    105d40 <strtol+0x53>
        s ++, neg = 1;
  105d35:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105d39:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105d40:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d44:	74 06                	je     105d4c <strtol+0x5f>
  105d46:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105d4a:	75 24                	jne    105d70 <strtol+0x83>
  105d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  105d4f:	0f b6 00             	movzbl (%eax),%eax
  105d52:	3c 30                	cmp    $0x30,%al
  105d54:	75 1a                	jne    105d70 <strtol+0x83>
  105d56:	8b 45 08             	mov    0x8(%ebp),%eax
  105d59:	83 c0 01             	add    $0x1,%eax
  105d5c:	0f b6 00             	movzbl (%eax),%eax
  105d5f:	3c 78                	cmp    $0x78,%al
  105d61:	75 0d                	jne    105d70 <strtol+0x83>
        s += 2, base = 16;
  105d63:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105d67:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105d6e:	eb 2a                	jmp    105d9a <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  105d70:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d74:	75 17                	jne    105d8d <strtol+0xa0>
  105d76:	8b 45 08             	mov    0x8(%ebp),%eax
  105d79:	0f b6 00             	movzbl (%eax),%eax
  105d7c:	3c 30                	cmp    $0x30,%al
  105d7e:	75 0d                	jne    105d8d <strtol+0xa0>
        s ++, base = 8;
  105d80:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105d84:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105d8b:	eb 0d                	jmp    105d9a <strtol+0xad>
    }
    else if (base == 0) {
  105d8d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d91:	75 07                	jne    105d9a <strtol+0xad>
        base = 10;
  105d93:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  105d9d:	0f b6 00             	movzbl (%eax),%eax
  105da0:	3c 2f                	cmp    $0x2f,%al
  105da2:	7e 1b                	jle    105dbf <strtol+0xd2>
  105da4:	8b 45 08             	mov    0x8(%ebp),%eax
  105da7:	0f b6 00             	movzbl (%eax),%eax
  105daa:	3c 39                	cmp    $0x39,%al
  105dac:	7f 11                	jg     105dbf <strtol+0xd2>
            dig = *s - '0';
  105dae:	8b 45 08             	mov    0x8(%ebp),%eax
  105db1:	0f b6 00             	movzbl (%eax),%eax
  105db4:	0f be c0             	movsbl %al,%eax
  105db7:	83 e8 30             	sub    $0x30,%eax
  105dba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105dbd:	eb 48                	jmp    105e07 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  105dc2:	0f b6 00             	movzbl (%eax),%eax
  105dc5:	3c 60                	cmp    $0x60,%al
  105dc7:	7e 1b                	jle    105de4 <strtol+0xf7>
  105dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  105dcc:	0f b6 00             	movzbl (%eax),%eax
  105dcf:	3c 7a                	cmp    $0x7a,%al
  105dd1:	7f 11                	jg     105de4 <strtol+0xf7>
            dig = *s - 'a' + 10;
  105dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  105dd6:	0f b6 00             	movzbl (%eax),%eax
  105dd9:	0f be c0             	movsbl %al,%eax
  105ddc:	83 e8 57             	sub    $0x57,%eax
  105ddf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105de2:	eb 23                	jmp    105e07 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105de4:	8b 45 08             	mov    0x8(%ebp),%eax
  105de7:	0f b6 00             	movzbl (%eax),%eax
  105dea:	3c 40                	cmp    $0x40,%al
  105dec:	7e 3d                	jle    105e2b <strtol+0x13e>
  105dee:	8b 45 08             	mov    0x8(%ebp),%eax
  105df1:	0f b6 00             	movzbl (%eax),%eax
  105df4:	3c 5a                	cmp    $0x5a,%al
  105df6:	7f 33                	jg     105e2b <strtol+0x13e>
            dig = *s - 'A' + 10;
  105df8:	8b 45 08             	mov    0x8(%ebp),%eax
  105dfb:	0f b6 00             	movzbl (%eax),%eax
  105dfe:	0f be c0             	movsbl %al,%eax
  105e01:	83 e8 37             	sub    $0x37,%eax
  105e04:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105e0a:	3b 45 10             	cmp    0x10(%ebp),%eax
  105e0d:	7c 02                	jl     105e11 <strtol+0x124>
            break;
  105e0f:	eb 1a                	jmp    105e2b <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  105e11:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105e15:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105e18:	0f af 45 10          	imul   0x10(%ebp),%eax
  105e1c:	89 c2                	mov    %eax,%edx
  105e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105e21:	01 d0                	add    %edx,%eax
  105e23:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105e26:	e9 6f ff ff ff       	jmp    105d9a <strtol+0xad>

    if (endptr) {
  105e2b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105e2f:	74 08                	je     105e39 <strtol+0x14c>
        *endptr = (char *) s;
  105e31:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e34:	8b 55 08             	mov    0x8(%ebp),%edx
  105e37:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105e39:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105e3d:	74 07                	je     105e46 <strtol+0x159>
  105e3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105e42:	f7 d8                	neg    %eax
  105e44:	eb 03                	jmp    105e49 <strtol+0x15c>
  105e46:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105e49:	c9                   	leave  
  105e4a:	c3                   	ret    

00105e4b <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105e4b:	55                   	push   %ebp
  105e4c:	89 e5                	mov    %esp,%ebp
  105e4e:	57                   	push   %edi
  105e4f:	83 ec 24             	sub    $0x24,%esp
  105e52:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e55:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105e58:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105e5c:	8b 55 08             	mov    0x8(%ebp),%edx
  105e5f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105e62:	88 45 f7             	mov    %al,-0x9(%ebp)
  105e65:	8b 45 10             	mov    0x10(%ebp),%eax
  105e68:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105e6b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105e6e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105e72:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105e75:	89 d7                	mov    %edx,%edi
  105e77:	f3 aa                	rep stos %al,%es:(%edi)
  105e79:	89 fa                	mov    %edi,%edx
  105e7b:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105e7e:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105e81:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105e84:	83 c4 24             	add    $0x24,%esp
  105e87:	5f                   	pop    %edi
  105e88:	5d                   	pop    %ebp
  105e89:	c3                   	ret    

00105e8a <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105e8a:	55                   	push   %ebp
  105e8b:	89 e5                	mov    %esp,%ebp
  105e8d:	57                   	push   %edi
  105e8e:	56                   	push   %esi
  105e8f:	53                   	push   %ebx
  105e90:	83 ec 30             	sub    $0x30,%esp
  105e93:	8b 45 08             	mov    0x8(%ebp),%eax
  105e96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105e99:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105e9f:	8b 45 10             	mov    0x10(%ebp),%eax
  105ea2:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105ea5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ea8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105eab:	73 42                	jae    105eef <memmove+0x65>
  105ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105eb0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105eb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105eb6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105eb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105ebc:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105ebf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105ec2:	c1 e8 02             	shr    $0x2,%eax
  105ec5:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105ec7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105eca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105ecd:	89 d7                	mov    %edx,%edi
  105ecf:	89 c6                	mov    %eax,%esi
  105ed1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105ed3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105ed6:	83 e1 03             	and    $0x3,%ecx
  105ed9:	74 02                	je     105edd <memmove+0x53>
  105edb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105edd:	89 f0                	mov    %esi,%eax
  105edf:	89 fa                	mov    %edi,%edx
  105ee1:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105ee4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105ee7:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105eea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105eed:	eb 36                	jmp    105f25 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105eef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105ef2:	8d 50 ff             	lea    -0x1(%eax),%edx
  105ef5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105ef8:	01 c2                	add    %eax,%edx
  105efa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105efd:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105f00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f03:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  105f06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105f09:	89 c1                	mov    %eax,%ecx
  105f0b:	89 d8                	mov    %ebx,%eax
  105f0d:	89 d6                	mov    %edx,%esi
  105f0f:	89 c7                	mov    %eax,%edi
  105f11:	fd                   	std    
  105f12:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105f14:	fc                   	cld    
  105f15:	89 f8                	mov    %edi,%eax
  105f17:	89 f2                	mov    %esi,%edx
  105f19:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105f1c:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105f1f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  105f22:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105f25:	83 c4 30             	add    $0x30,%esp
  105f28:	5b                   	pop    %ebx
  105f29:	5e                   	pop    %esi
  105f2a:	5f                   	pop    %edi
  105f2b:	5d                   	pop    %ebp
  105f2c:	c3                   	ret    

00105f2d <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105f2d:	55                   	push   %ebp
  105f2e:	89 e5                	mov    %esp,%ebp
  105f30:	57                   	push   %edi
  105f31:	56                   	push   %esi
  105f32:	83 ec 20             	sub    $0x20,%esp
  105f35:	8b 45 08             	mov    0x8(%ebp),%eax
  105f38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105f3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105f41:	8b 45 10             	mov    0x10(%ebp),%eax
  105f44:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105f47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105f4a:	c1 e8 02             	shr    $0x2,%eax
  105f4d:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105f4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105f52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f55:	89 d7                	mov    %edx,%edi
  105f57:	89 c6                	mov    %eax,%esi
  105f59:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105f5b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105f5e:	83 e1 03             	and    $0x3,%ecx
  105f61:	74 02                	je     105f65 <memcpy+0x38>
  105f63:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105f65:	89 f0                	mov    %esi,%eax
  105f67:	89 fa                	mov    %edi,%edx
  105f69:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105f6c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105f6f:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105f75:	83 c4 20             	add    $0x20,%esp
  105f78:	5e                   	pop    %esi
  105f79:	5f                   	pop    %edi
  105f7a:	5d                   	pop    %ebp
  105f7b:	c3                   	ret    

00105f7c <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105f7c:	55                   	push   %ebp
  105f7d:	89 e5                	mov    %esp,%ebp
  105f7f:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105f82:	8b 45 08             	mov    0x8(%ebp),%eax
  105f85:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105f88:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f8b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105f8e:	eb 30                	jmp    105fc0 <memcmp+0x44>
        if (*s1 != *s2) {
  105f90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105f93:	0f b6 10             	movzbl (%eax),%edx
  105f96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f99:	0f b6 00             	movzbl (%eax),%eax
  105f9c:	38 c2                	cmp    %al,%dl
  105f9e:	74 18                	je     105fb8 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105fa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105fa3:	0f b6 00             	movzbl (%eax),%eax
  105fa6:	0f b6 d0             	movzbl %al,%edx
  105fa9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105fac:	0f b6 00             	movzbl (%eax),%eax
  105faf:	0f b6 c0             	movzbl %al,%eax
  105fb2:	29 c2                	sub    %eax,%edx
  105fb4:	89 d0                	mov    %edx,%eax
  105fb6:	eb 1a                	jmp    105fd2 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  105fb8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105fbc:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  105fc0:	8b 45 10             	mov    0x10(%ebp),%eax
  105fc3:	8d 50 ff             	lea    -0x1(%eax),%edx
  105fc6:	89 55 10             	mov    %edx,0x10(%ebp)
  105fc9:	85 c0                	test   %eax,%eax
  105fcb:	75 c3                	jne    105f90 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  105fcd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105fd2:	c9                   	leave  
  105fd3:	c3                   	ret    
