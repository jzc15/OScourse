
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 70 11 00 	lgdtl  0x117018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba 68 89 11 c0       	mov    $0xc0118968,%edx
c0100035:	b8 36 7a 11 c0       	mov    $0xc0117a36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 36 7a 11 c0 	movl   $0xc0117a36,(%esp)
c0100051:	e8 f5 5d 00 00       	call   c0105e4b <memset>

    cons_init();                // init the console
c0100056:	e8 76 15 00 00       	call   c01015d1 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 e0 5f 10 c0 	movl   $0xc0105fe0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 fc 5f 10 c0 	movl   $0xc0105ffc,(%esp)
c0100070:	e8 c7 02 00 00       	call   c010033c <cprintf>

    print_kerninfo();
c0100075:	e8 f6 07 00 00       	call   c0100870 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 86 00 00 00       	call   c0100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 d9 42 00 00       	call   c010435d <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 b1 16 00 00       	call   c010173a <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 29 18 00 00       	call   c01018b7 <idt_init>

    clock_init();               // init clock interrupt
c010008e:	e8 f4 0c 00 00       	call   c0100d87 <clock_init>
    intr_enable();              // enable irq interrupt
c0100093:	e8 10 16 00 00       	call   c01016a8 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c0100098:	eb fe                	jmp    c0100098 <kern_init+0x6e>

c010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009a:	55                   	push   %ebp
c010009b:	89 e5                	mov    %esp,%ebp
c010009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000a7:	00 
c01000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000af:	00 
c01000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000b7:	e8 fd 0b 00 00       	call   c0100cb9 <mon_backtrace>
}
c01000bc:	c9                   	leave  
c01000bd:	c3                   	ret    

c01000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000be:	55                   	push   %ebp
c01000bf:	89 e5                	mov    %esp,%ebp
c01000c1:	53                   	push   %ebx
c01000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000cb:	8d 55 08             	lea    0x8(%ebp),%edx
c01000ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000dd:	89 04 24             	mov    %eax,(%esp)
c01000e0:	e8 b5 ff ff ff       	call   c010009a <grade_backtrace2>
}
c01000e5:	83 c4 14             	add    $0x14,%esp
c01000e8:	5b                   	pop    %ebx
c01000e9:	5d                   	pop    %ebp
c01000ea:	c3                   	ret    

c01000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000eb:	55                   	push   %ebp
c01000ec:	89 e5                	mov    %esp,%ebp
c01000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01000f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01000fb:	89 04 24             	mov    %eax,(%esp)
c01000fe:	e8 bb ff ff ff       	call   c01000be <grade_backtrace1>
}
c0100103:	c9                   	leave  
c0100104:	c3                   	ret    

c0100105 <grade_backtrace>:

void
grade_backtrace(void) {
c0100105:	55                   	push   %ebp
c0100106:	89 e5                	mov    %esp,%ebp
c0100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010010b:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100117:	ff 
c0100118:	89 44 24 04          	mov    %eax,0x4(%esp)
c010011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100123:	e8 c3 ff ff ff       	call   c01000eb <grade_backtrace0>
}
c0100128:	c9                   	leave  
c0100129:	c3                   	ret    

c010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012a:	55                   	push   %ebp
c010012b:	89 e5                	mov    %esp,%ebp
c010012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100140:	0f b7 c0             	movzwl %ax,%eax
c0100143:	83 e0 03             	and    $0x3,%eax
c0100146:	89 c2                	mov    %eax,%edx
c0100148:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010014d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100151:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100155:	c7 04 24 01 60 10 c0 	movl   $0xc0106001,(%esp)
c010015c:	e8 db 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100165:	0f b7 d0             	movzwl %ax,%edx
c0100168:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010016d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100171:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100175:	c7 04 24 0f 60 10 c0 	movl   $0xc010600f,(%esp)
c010017c:	e8 bb 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100185:	0f b7 d0             	movzwl %ax,%edx
c0100188:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 1d 60 10 c0 	movl   $0xc010601d,(%esp)
c010019c:	e8 9b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a5:	0f b7 d0             	movzwl %ax,%edx
c01001a8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b5:	c7 04 24 2b 60 10 c0 	movl   $0xc010602b,(%esp)
c01001bc:	e8 7b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c5:	0f b7 d0             	movzwl %ax,%edx
c01001c8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d5:	c7 04 24 39 60 10 c0 	movl   $0xc0106039,(%esp)
c01001dc:	e8 5b 01 00 00       	call   c010033c <cprintf>
    round ++;
c01001e1:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001e6:	83 c0 01             	add    $0x1,%eax
c01001e9:	a3 40 7a 11 c0       	mov    %eax,0xc0117a40
}
c01001ee:	c9                   	leave  
c01001ef:	c3                   	ret    

c01001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f0:	55                   	push   %ebp
c01001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001f3:	5d                   	pop    %ebp
c01001f4:	c3                   	ret    

c01001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001f5:	55                   	push   %ebp
c01001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001f8:	5d                   	pop    %ebp
c01001f9:	c3                   	ret    

c01001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001fa:	55                   	push   %ebp
c01001fb:	89 e5                	mov    %esp,%ebp
c01001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100200:	e8 25 ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100205:	c7 04 24 48 60 10 c0 	movl   $0xc0106048,(%esp)
c010020c:	e8 2b 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_user();
c0100211:	e8 da ff ff ff       	call   c01001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100216:	e8 0f ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010021b:	c7 04 24 68 60 10 c0 	movl   $0xc0106068,(%esp)
c0100222:	e8 15 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_kernel();
c0100227:	e8 c9 ff ff ff       	call   c01001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010022c:	e8 f9 fe ff ff       	call   c010012a <lab1_print_cur_status>
}
c0100231:	c9                   	leave  
c0100232:	c3                   	ret    

c0100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100233:	55                   	push   %ebp
c0100234:	89 e5                	mov    %esp,%ebp
c0100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010023d:	74 13                	je     c0100252 <readline+0x1f>
        cprintf("%s", prompt);
c010023f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100242:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100246:	c7 04 24 87 60 10 c0 	movl   $0xc0106087,(%esp)
c010024d:	e8 ea 00 00 00       	call   c010033c <cprintf>
    }
    int i = 0, c;
c0100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100259:	e8 66 01 00 00       	call   c01003c4 <getchar>
c010025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100265:	79 07                	jns    c010026e <readline+0x3b>
            return NULL;
c0100267:	b8 00 00 00 00       	mov    $0x0,%eax
c010026c:	eb 79                	jmp    c01002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100272:	7e 28                	jle    c010029c <readline+0x69>
c0100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010027b:	7f 1f                	jg     c010029c <readline+0x69>
            cputchar(c);
c010027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100280:	89 04 24             	mov    %eax,(%esp)
c0100283:	e8 da 00 00 00       	call   c0100362 <cputchar>
            buf[i ++] = c;
c0100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010028b:	8d 50 01             	lea    0x1(%eax),%edx
c010028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100294:	88 90 60 7a 11 c0    	mov    %dl,-0x3fee85a0(%eax)
c010029a:	eb 46                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c010029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002a0:	75 17                	jne    c01002b9 <readline+0x86>
c01002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002a6:	7e 11                	jle    c01002b9 <readline+0x86>
            cputchar(c);
c01002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ab:	89 04 24             	mov    %eax,(%esp)
c01002ae:	e8 af 00 00 00       	call   c0100362 <cputchar>
            i --;
c01002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002b7:	eb 29                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002bd:	74 06                	je     c01002c5 <readline+0x92>
c01002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002c3:	75 1d                	jne    c01002e2 <readline+0xaf>
            cputchar(c);
c01002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002c8:	89 04 24             	mov    %eax,(%esp)
c01002cb:	e8 92 00 00 00       	call   c0100362 <cputchar>
            buf[i] = '\0';
c01002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002d3:	05 60 7a 11 c0       	add    $0xc0117a60,%eax
c01002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002db:	b8 60 7a 11 c0       	mov    $0xc0117a60,%eax
c01002e0:	eb 05                	jmp    c01002e7 <readline+0xb4>
        }
    }
c01002e2:	e9 72 ff ff ff       	jmp    c0100259 <readline+0x26>
}
c01002e7:	c9                   	leave  
c01002e8:	c3                   	ret    

c01002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002e9:	55                   	push   %ebp
c01002ea:	89 e5                	mov    %esp,%ebp
c01002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01002f2:	89 04 24             	mov    %eax,(%esp)
c01002f5:	e8 03 13 00 00       	call   c01015fd <cons_putc>
    (*cnt) ++;
c01002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01002fd:	8b 00                	mov    (%eax),%eax
c01002ff:	8d 50 01             	lea    0x1(%eax),%edx
c0100302:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100305:	89 10                	mov    %edx,(%eax)
}
c0100307:	c9                   	leave  
c0100308:	c3                   	ret    

c0100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100309:	55                   	push   %ebp
c010030a:	89 e5                	mov    %esp,%ebp
c010030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100316:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010031d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100320:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100327:	89 44 24 04          	mov    %eax,0x4(%esp)
c010032b:	c7 04 24 e9 02 10 c0 	movl   $0xc01002e9,(%esp)
c0100332:	e8 2d 53 00 00       	call   c0105664 <vprintfmt>
    return cnt;
c0100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010033a:	c9                   	leave  
c010033b:	c3                   	ret    

c010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010033c:	55                   	push   %ebp
c010033d:	89 e5                	mov    %esp,%ebp
c010033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100342:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010034b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010034f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100352:	89 04 24             	mov    %eax,(%esp)
c0100355:	e8 af ff ff ff       	call   c0100309 <vcprintf>
c010035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100360:	c9                   	leave  
c0100361:	c3                   	ret    

c0100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100362:	55                   	push   %ebp
c0100363:	89 e5                	mov    %esp,%ebp
c0100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100368:	8b 45 08             	mov    0x8(%ebp),%eax
c010036b:	89 04 24             	mov    %eax,(%esp)
c010036e:	e8 8a 12 00 00       	call   c01015fd <cons_putc>
}
c0100373:	c9                   	leave  
c0100374:	c3                   	ret    

c0100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100375:	55                   	push   %ebp
c0100376:	89 e5                	mov    %esp,%ebp
c0100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100382:	eb 13                	jmp    c0100397 <cputs+0x22>
        cputch(c, &cnt);
c0100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
c010038b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010038f:	89 04 24             	mov    %eax,(%esp)
c0100392:	e8 52 ff ff ff       	call   c01002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c0100397:	8b 45 08             	mov    0x8(%ebp),%eax
c010039a:	8d 50 01             	lea    0x1(%eax),%edx
c010039d:	89 55 08             	mov    %edx,0x8(%ebp)
c01003a0:	0f b6 00             	movzbl (%eax),%eax
c01003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003aa:	75 d8                	jne    c0100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003ba:	e8 2a ff ff ff       	call   c01002e9 <cputch>
    return cnt;
c01003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003c2:	c9                   	leave  
c01003c3:	c3                   	ret    

c01003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003c4:	55                   	push   %ebp
c01003c5:	89 e5                	mov    %esp,%ebp
c01003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003ca:	e8 6a 12 00 00       	call   c0101639 <cons_getc>
c01003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003d6:	74 f2                	je     c01003ca <getchar+0x6>
        /* do nothing */;
    return c;
c01003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003db:	c9                   	leave  
c01003dc:	c3                   	ret    

c01003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003dd:	55                   	push   %ebp
c01003de:	89 e5                	mov    %esp,%ebp
c01003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003e6:	8b 00                	mov    (%eax),%eax
c01003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01003ee:	8b 00                	mov    (%eax),%eax
c01003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01003fa:	e9 d2 00 00 00       	jmp    c01004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100405:	01 d0                	add    %edx,%eax
c0100407:	89 c2                	mov    %eax,%edx
c0100409:	c1 ea 1f             	shr    $0x1f,%edx
c010040c:	01 d0                	add    %edx,%eax
c010040e:	d1 f8                	sar    %eax
c0100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100419:	eb 04                	jmp    c010041f <stab_binsearch+0x42>
            m --;
c010041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100425:	7c 1f                	jl     c0100446 <stab_binsearch+0x69>
c0100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010042a:	89 d0                	mov    %edx,%eax
c010042c:	01 c0                	add    %eax,%eax
c010042e:	01 d0                	add    %edx,%eax
c0100430:	c1 e0 02             	shl    $0x2,%eax
c0100433:	89 c2                	mov    %eax,%edx
c0100435:	8b 45 08             	mov    0x8(%ebp),%eax
c0100438:	01 d0                	add    %edx,%eax
c010043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010043e:	0f b6 c0             	movzbl %al,%eax
c0100441:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100444:	75 d5                	jne    c010041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010044c:	7d 0b                	jge    c0100459 <stab_binsearch+0x7c>
            l = true_m + 1;
c010044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100451:	83 c0 01             	add    $0x1,%eax
c0100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100457:	eb 78                	jmp    c01004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100463:	89 d0                	mov    %edx,%eax
c0100465:	01 c0                	add    %eax,%eax
c0100467:	01 d0                	add    %edx,%eax
c0100469:	c1 e0 02             	shl    $0x2,%eax
c010046c:	89 c2                	mov    %eax,%edx
c010046e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100471:	01 d0                	add    %edx,%eax
c0100473:	8b 40 08             	mov    0x8(%eax),%eax
c0100476:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100479:	73 13                	jae    c010048e <stab_binsearch+0xb1>
            *region_left = m;
c010047b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100486:	83 c0 01             	add    $0x1,%eax
c0100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010048c:	eb 43                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100491:	89 d0                	mov    %edx,%eax
c0100493:	01 c0                	add    %eax,%eax
c0100495:	01 d0                	add    %edx,%eax
c0100497:	c1 e0 02             	shl    $0x2,%eax
c010049a:	89 c2                	mov    %eax,%edx
c010049c:	8b 45 08             	mov    0x8(%ebp),%eax
c010049f:	01 d0                	add    %edx,%eax
c01004a1:	8b 40 08             	mov    0x8(%eax),%eax
c01004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004a7:	76 16                	jbe    c01004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004af:	8b 45 10             	mov    0x10(%ebp),%eax
c01004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b7:	83 e8 01             	sub    $0x1,%eax
c01004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004bd:	eb 12                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004c5:	89 10                	mov    %edx,(%eax)
            l = m;
c01004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004d7:	0f 8e 22 ff ff ff    	jle    c01003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004e1:	75 0f                	jne    c01004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004e6:	8b 00                	mov    (%eax),%eax
c01004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01004ee:	89 10                	mov    %edx,(%eax)
c01004f0:	eb 3f                	jmp    c0100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01004f2:	8b 45 10             	mov    0x10(%ebp),%eax
c01004f5:	8b 00                	mov    (%eax),%eax
c01004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01004fa:	eb 04                	jmp    c0100500 <stab_binsearch+0x123>
c01004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100500:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100503:	8b 00                	mov    (%eax),%eax
c0100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100508:	7d 1f                	jge    c0100529 <stab_binsearch+0x14c>
c010050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010050d:	89 d0                	mov    %edx,%eax
c010050f:	01 c0                	add    %eax,%eax
c0100511:	01 d0                	add    %edx,%eax
c0100513:	c1 e0 02             	shl    $0x2,%eax
c0100516:	89 c2                	mov    %eax,%edx
c0100518:	8b 45 08             	mov    0x8(%ebp),%eax
c010051b:	01 d0                	add    %edx,%eax
c010051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100521:	0f b6 c0             	movzbl %al,%eax
c0100524:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100527:	75 d3                	jne    c01004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100529:	8b 45 0c             	mov    0xc(%ebp),%eax
c010052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010052f:	89 10                	mov    %edx,(%eax)
    }
}
c0100531:	c9                   	leave  
c0100532:	c3                   	ret    

c0100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100533:	55                   	push   %ebp
c0100534:	89 e5                	mov    %esp,%ebp
c0100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100539:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053c:	c7 00 8c 60 10 c0    	movl   $0xc010608c,(%eax)
    info->eip_line = 0;
c0100542:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010054c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054f:	c7 40 08 8c 60 10 c0 	movl   $0xc010608c,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100556:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100560:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100563:	8b 55 08             	mov    0x8(%ebp),%edx
c0100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100569:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100573:	c7 45 f4 08 73 10 c0 	movl   $0xc0107308,-0xc(%ebp)
    stab_end = __STAB_END__;
c010057a:	c7 45 f0 00 20 11 c0 	movl   $0xc0112000,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100581:	c7 45 ec 01 20 11 c0 	movl   $0xc0112001,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100588:	c7 45 e8 57 4a 11 c0 	movl   $0xc0114a57,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100595:	76 0d                	jbe    c01005a4 <debuginfo_eip+0x71>
c0100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010059a:	83 e8 01             	sub    $0x1,%eax
c010059d:	0f b6 00             	movzbl (%eax),%eax
c01005a0:	84 c0                	test   %al,%al
c01005a2:	74 0a                	je     c01005ae <debuginfo_eip+0x7b>
        return -1;
c01005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005a9:	e9 c0 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005bb:	29 c2                	sub    %eax,%edx
c01005bd:	89 d0                	mov    %edx,%eax
c01005bf:	c1 f8 02             	sar    $0x2,%eax
c01005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005c8:	83 e8 01             	sub    $0x1,%eax
c01005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005dc:	00 
c01005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005ee:	89 04 24             	mov    %eax,(%esp)
c01005f1:	e8 e7 fd ff ff       	call   c01003dd <stab_binsearch>
    if (lfile == 0)
c01005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005f9:	85 c0                	test   %eax,%eax
c01005fb:	75 0a                	jne    c0100607 <debuginfo_eip+0xd4>
        return -1;
c01005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100602:	e9 67 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100613:	8b 45 08             	mov    0x8(%ebp),%eax
c0100616:	89 44 24 10          	mov    %eax,0x10(%esp)
c010061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100621:	00 
c0100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100625:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010062c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100633:	89 04 24             	mov    %eax,(%esp)
c0100636:	e8 a2 fd ff ff       	call   c01003dd <stab_binsearch>

    if (lfun <= rfun) {
c010063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100641:	39 c2                	cmp    %eax,%edx
c0100643:	7f 7c                	jg     c01006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100648:	89 c2                	mov    %eax,%edx
c010064a:	89 d0                	mov    %edx,%eax
c010064c:	01 c0                	add    %eax,%eax
c010064e:	01 d0                	add    %edx,%eax
c0100650:	c1 e0 02             	shl    $0x2,%eax
c0100653:	89 c2                	mov    %eax,%edx
c0100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100658:	01 d0                	add    %edx,%eax
c010065a:	8b 10                	mov    (%eax),%edx
c010065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100662:	29 c1                	sub    %eax,%ecx
c0100664:	89 c8                	mov    %ecx,%eax
c0100666:	39 c2                	cmp    %eax,%edx
c0100668:	73 22                	jae    c010068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010066d:	89 c2                	mov    %eax,%edx
c010066f:	89 d0                	mov    %edx,%eax
c0100671:	01 c0                	add    %eax,%eax
c0100673:	01 d0                	add    %edx,%eax
c0100675:	c1 e0 02             	shl    $0x2,%eax
c0100678:	89 c2                	mov    %eax,%edx
c010067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010067d:	01 d0                	add    %edx,%eax
c010067f:	8b 10                	mov    (%eax),%edx
c0100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100684:	01 c2                	add    %eax,%edx
c0100686:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010068f:	89 c2                	mov    %eax,%edx
c0100691:	89 d0                	mov    %edx,%eax
c0100693:	01 c0                	add    %eax,%eax
c0100695:	01 d0                	add    %edx,%eax
c0100697:	c1 e0 02             	shl    $0x2,%eax
c010069a:	89 c2                	mov    %eax,%edx
c010069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010069f:	01 d0                	add    %edx,%eax
c01006a1:	8b 50 08             	mov    0x8(%eax),%edx
c01006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006ad:	8b 40 10             	mov    0x10(%eax),%eax
c01006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006bf:	eb 15                	jmp    c01006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c4:	8b 55 08             	mov    0x8(%ebp),%edx
c01006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d9:	8b 40 08             	mov    0x8(%eax),%eax
c01006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006e3:	00 
c01006e4:	89 04 24             	mov    %eax,(%esp)
c01006e7:	e8 d3 55 00 00       	call   c0105cbf <strfind>
c01006ec:	89 c2                	mov    %eax,%edx
c01006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f1:	8b 40 08             	mov    0x8(%eax),%eax
c01006f4:	29 c2                	sub    %eax,%edx
c01006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01006fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010070a:	00 
c010070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010070e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100715:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010071c:	89 04 24             	mov    %eax,(%esp)
c010071f:	e8 b9 fc ff ff       	call   c01003dd <stab_binsearch>
    if (lline <= rline) {
c0100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010072a:	39 c2                	cmp    %eax,%edx
c010072c:	7f 24                	jg     c0100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100731:	89 c2                	mov    %eax,%edx
c0100733:	89 d0                	mov    %edx,%eax
c0100735:	01 c0                	add    %eax,%eax
c0100737:	01 d0                	add    %edx,%eax
c0100739:	c1 e0 02             	shl    $0x2,%eax
c010073c:	89 c2                	mov    %eax,%edx
c010073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100741:	01 d0                	add    %edx,%eax
c0100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100747:	0f b7 d0             	movzwl %ax,%edx
c010074a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100750:	eb 13                	jmp    c0100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100757:	e9 12 01 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010075f:	83 e8 01             	sub    $0x1,%eax
c0100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010076b:	39 c2                	cmp    %eax,%edx
c010076d:	7c 56                	jl     c01007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100772:	89 c2                	mov    %eax,%edx
c0100774:	89 d0                	mov    %edx,%eax
c0100776:	01 c0                	add    %eax,%eax
c0100778:	01 d0                	add    %edx,%eax
c010077a:	c1 e0 02             	shl    $0x2,%eax
c010077d:	89 c2                	mov    %eax,%edx
c010077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100782:	01 d0                	add    %edx,%eax
c0100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100788:	3c 84                	cmp    $0x84,%al
c010078a:	74 39                	je     c01007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010078f:	89 c2                	mov    %eax,%edx
c0100791:	89 d0                	mov    %edx,%eax
c0100793:	01 c0                	add    %eax,%eax
c0100795:	01 d0                	add    %edx,%eax
c0100797:	c1 e0 02             	shl    $0x2,%eax
c010079a:	89 c2                	mov    %eax,%edx
c010079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010079f:	01 d0                	add    %edx,%eax
c01007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007a5:	3c 64                	cmp    $0x64,%al
c01007a7:	75 b3                	jne    c010075c <debuginfo_eip+0x229>
c01007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007ac:	89 c2                	mov    %eax,%edx
c01007ae:	89 d0                	mov    %edx,%eax
c01007b0:	01 c0                	add    %eax,%eax
c01007b2:	01 d0                	add    %edx,%eax
c01007b4:	c1 e0 02             	shl    $0x2,%eax
c01007b7:	89 c2                	mov    %eax,%edx
c01007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007bc:	01 d0                	add    %edx,%eax
c01007be:	8b 40 08             	mov    0x8(%eax),%eax
c01007c1:	85 c0                	test   %eax,%eax
c01007c3:	74 97                	je     c010075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007cb:	39 c2                	cmp    %eax,%edx
c01007cd:	7c 46                	jl     c0100815 <debuginfo_eip+0x2e2>
c01007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007d2:	89 c2                	mov    %eax,%edx
c01007d4:	89 d0                	mov    %edx,%eax
c01007d6:	01 c0                	add    %eax,%eax
c01007d8:	01 d0                	add    %edx,%eax
c01007da:	c1 e0 02             	shl    $0x2,%eax
c01007dd:	89 c2                	mov    %eax,%edx
c01007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007e2:	01 d0                	add    %edx,%eax
c01007e4:	8b 10                	mov    (%eax),%edx
c01007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007ec:	29 c1                	sub    %eax,%ecx
c01007ee:	89 c8                	mov    %ecx,%eax
c01007f0:	39 c2                	cmp    %eax,%edx
c01007f2:	73 21                	jae    c0100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f7:	89 c2                	mov    %eax,%edx
c01007f9:	89 d0                	mov    %edx,%eax
c01007fb:	01 c0                	add    %eax,%eax
c01007fd:	01 d0                	add    %edx,%eax
c01007ff:	c1 e0 02             	shl    $0x2,%eax
c0100802:	89 c2                	mov    %eax,%edx
c0100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100807:	01 d0                	add    %edx,%eax
c0100809:	8b 10                	mov    (%eax),%edx
c010080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010080e:	01 c2                	add    %eax,%edx
c0100810:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010081b:	39 c2                	cmp    %eax,%edx
c010081d:	7d 4a                	jge    c0100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100822:	83 c0 01             	add    $0x1,%eax
c0100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100828:	eb 18                	jmp    c0100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c010082a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082d:	8b 40 14             	mov    0x14(%eax),%eax
c0100830:	8d 50 01             	lea    0x1(%eax),%edx
c0100833:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010083c:	83 c0 01             	add    $0x1,%eax
c010083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100848:	39 c2                	cmp    %eax,%edx
c010084a:	7d 1d                	jge    c0100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084f:	89 c2                	mov    %eax,%edx
c0100851:	89 d0                	mov    %edx,%eax
c0100853:	01 c0                	add    %eax,%eax
c0100855:	01 d0                	add    %edx,%eax
c0100857:	c1 e0 02             	shl    $0x2,%eax
c010085a:	89 c2                	mov    %eax,%edx
c010085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010085f:	01 d0                	add    %edx,%eax
c0100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100865:	3c a0                	cmp    $0xa0,%al
c0100867:	74 c1                	je     c010082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010086e:	c9                   	leave  
c010086f:	c3                   	ret    

c0100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100870:	55                   	push   %ebp
c0100871:	89 e5                	mov    %esp,%ebp
c0100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100876:	c7 04 24 96 60 10 c0 	movl   $0xc0106096,(%esp)
c010087d:	e8 ba fa ff ff       	call   c010033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100882:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100889:	c0 
c010088a:	c7 04 24 af 60 10 c0 	movl   $0xc01060af,(%esp)
c0100891:	e8 a6 fa ff ff       	call   c010033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100896:	c7 44 24 04 d4 5f 10 	movl   $0xc0105fd4,0x4(%esp)
c010089d:	c0 
c010089e:	c7 04 24 c7 60 10 c0 	movl   $0xc01060c7,(%esp)
c01008a5:	e8 92 fa ff ff       	call   c010033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008aa:	c7 44 24 04 36 7a 11 	movl   $0xc0117a36,0x4(%esp)
c01008b1:	c0 
c01008b2:	c7 04 24 df 60 10 c0 	movl   $0xc01060df,(%esp)
c01008b9:	e8 7e fa ff ff       	call   c010033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008be:	c7 44 24 04 68 89 11 	movl   $0xc0118968,0x4(%esp)
c01008c5:	c0 
c01008c6:	c7 04 24 f7 60 10 c0 	movl   $0xc01060f7,(%esp)
c01008cd:	e8 6a fa ff ff       	call   c010033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008d2:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c01008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008dd:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008e2:	29 c2                	sub    %eax,%edx
c01008e4:	89 d0                	mov    %edx,%eax
c01008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ec:	85 c0                	test   %eax,%eax
c01008ee:	0f 48 c2             	cmovs  %edx,%eax
c01008f1:	c1 f8 0a             	sar    $0xa,%eax
c01008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008f8:	c7 04 24 10 61 10 c0 	movl   $0xc0106110,(%esp)
c01008ff:	e8 38 fa ff ff       	call   c010033c <cprintf>
}
c0100904:	c9                   	leave  
c0100905:	c3                   	ret    

c0100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100906:	55                   	push   %ebp
c0100907:	89 e5                	mov    %esp,%ebp
c0100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100912:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100916:	8b 45 08             	mov    0x8(%ebp),%eax
c0100919:	89 04 24             	mov    %eax,(%esp)
c010091c:	e8 12 fc ff ff       	call   c0100533 <debuginfo_eip>
c0100921:	85 c0                	test   %eax,%eax
c0100923:	74 15                	je     c010093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100925:	8b 45 08             	mov    0x8(%ebp),%eax
c0100928:	89 44 24 04          	mov    %eax,0x4(%esp)
c010092c:	c7 04 24 3a 61 10 c0 	movl   $0xc010613a,(%esp)
c0100933:	e8 04 fa ff ff       	call   c010033c <cprintf>
c0100938:	eb 6d                	jmp    c01009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100941:	eb 1c                	jmp    c010095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100949:	01 d0                	add    %edx,%eax
c010094b:	0f b6 00             	movzbl (%eax),%eax
c010094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100957:	01 ca                	add    %ecx,%edx
c0100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100965:	7f dc                	jg     c0100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100970:	01 d0                	add    %edx,%eax
c0100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100978:	8b 55 08             	mov    0x8(%ebp),%edx
c010097b:	89 d1                	mov    %edx,%ecx
c010097d:	29 c1                	sub    %eax,%ecx
c010097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100993:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100997:	89 44 24 04          	mov    %eax,0x4(%esp)
c010099b:	c7 04 24 56 61 10 c0 	movl   $0xc0106156,(%esp)
c01009a2:	e8 95 f9 ff ff       	call   c010033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009a7:	c9                   	leave  
c01009a8:	c3                   	ret    

c01009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009a9:	55                   	push   %ebp
c01009aa:	89 e5                	mov    %esp,%ebp
c01009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009af:	8b 45 04             	mov    0x4(%ebp),%eax
c01009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009b8:	c9                   	leave  
c01009b9:	c3                   	ret    

c01009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009ba:	55                   	push   %ebp
c01009bb:	89 e5                	mov    %esp,%ebp
c01009bd:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009c0:	89 e8                	mov    %ebp,%eax
c01009c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
c01009c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
c01009cb:	e8 d9 ff ff ff       	call   c01009a9 <read_eip>
c01009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i, j;
	for(i = 0; i < STACKFRAME_DEPTH; i++)
c01009d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009da:	e9 93 00 00 00       	jmp    c0100a72 <print_stackframe+0xb8>
	{
		if(ebp == 0)
c01009df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01009e3:	75 05                	jne    c01009ea <print_stackframe+0x30>
			break;
c01009e5:	e9 92 00 00 00       	jmp    c0100a7c <print_stackframe+0xc2>
		 cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c01009ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009ed:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009f8:	c7 04 24 68 61 10 c0 	movl   $0xc0106168,(%esp)
c01009ff:	e8 38 f9 ff ff       	call   c010033c <cprintf>
		 uint32_t *args = (uint32_t *)ebp + 2;
c0100a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a07:	83 c0 08             	add    $0x8,%eax
c0100a0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		 for (j = 0; j < 4; j ++)
c0100a0d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a14:	eb 25                	jmp    c0100a3b <print_stackframe+0x81>
		      cprintf("0x%08x ", args[j]);
c0100a16:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a19:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a23:	01 d0                	add    %edx,%eax
c0100a25:	8b 00                	mov    (%eax),%eax
c0100a27:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a2b:	c7 04 24 84 61 10 c0 	movl   $0xc0106184,(%esp)
c0100a32:	e8 05 f9 ff ff       	call   c010033c <cprintf>
	{
		if(ebp == 0)
			break;
		 cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
		 uint32_t *args = (uint32_t *)ebp + 2;
		 for (j = 0; j < 4; j ++)
c0100a37:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a3b:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a3f:	7e d5                	jle    c0100a16 <print_stackframe+0x5c>
		      cprintf("0x%08x ", args[j]);

		 cprintf("\n");
c0100a41:	c7 04 24 8c 61 10 c0 	movl   $0xc010618c,(%esp)
c0100a48:	e8 ef f8 ff ff       	call   c010033c <cprintf>
		 print_debuginfo(eip - 1);
c0100a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a50:	83 e8 01             	sub    $0x1,%eax
c0100a53:	89 04 24             	mov    %eax,(%esp)
c0100a56:	e8 ab fe ff ff       	call   c0100906 <print_debuginfo>
		 eip = ((uint32_t *)ebp)[1];
c0100a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a5e:	83 c0 04             	add    $0x4,%eax
c0100a61:	8b 00                	mov    (%eax),%eax
c0100a63:	89 45 f0             	mov    %eax,-0x10(%ebp)
		 ebp = ((uint32_t *)ebp)[0];
c0100a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a69:	8b 00                	mov    (%eax),%eax
c0100a6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();
	int i, j;
	for(i = 0; i < STACKFRAME_DEPTH; i++)
c0100a6e:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a72:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a76:	0f 8e 63 ff ff ff    	jle    c01009df <print_stackframe+0x25>
		 print_debuginfo(eip - 1);
		 eip = ((uint32_t *)ebp)[1];
		 ebp = ((uint32_t *)ebp)[0];
	}

}
c0100a7c:	c9                   	leave  
c0100a7d:	c3                   	ret    

c0100a7e <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a7e:	55                   	push   %ebp
c0100a7f:	89 e5                	mov    %esp,%ebp
c0100a81:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a84:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a8b:	eb 0c                	jmp    c0100a99 <parse+0x1b>
            *buf ++ = '\0';
c0100a8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a90:	8d 50 01             	lea    0x1(%eax),%edx
c0100a93:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a96:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a99:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a9c:	0f b6 00             	movzbl (%eax),%eax
c0100a9f:	84 c0                	test   %al,%al
c0100aa1:	74 1d                	je     c0100ac0 <parse+0x42>
c0100aa3:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa6:	0f b6 00             	movzbl (%eax),%eax
c0100aa9:	0f be c0             	movsbl %al,%eax
c0100aac:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ab0:	c7 04 24 10 62 10 c0 	movl   $0xc0106210,(%esp)
c0100ab7:	e8 d0 51 00 00       	call   c0105c8c <strchr>
c0100abc:	85 c0                	test   %eax,%eax
c0100abe:	75 cd                	jne    c0100a8d <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100ac0:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ac3:	0f b6 00             	movzbl (%eax),%eax
c0100ac6:	84 c0                	test   %al,%al
c0100ac8:	75 02                	jne    c0100acc <parse+0x4e>
            break;
c0100aca:	eb 67                	jmp    c0100b33 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100acc:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ad0:	75 14                	jne    c0100ae6 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ad2:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ad9:	00 
c0100ada:	c7 04 24 15 62 10 c0 	movl   $0xc0106215,(%esp)
c0100ae1:	e8 56 f8 ff ff       	call   c010033c <cprintf>
        }
        argv[argc ++] = buf;
c0100ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ae9:	8d 50 01             	lea    0x1(%eax),%edx
c0100aec:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100aef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100af6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100af9:	01 c2                	add    %eax,%edx
c0100afb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100afe:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b00:	eb 04                	jmp    c0100b06 <parse+0x88>
            buf ++;
c0100b02:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b06:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b09:	0f b6 00             	movzbl (%eax),%eax
c0100b0c:	84 c0                	test   %al,%al
c0100b0e:	74 1d                	je     c0100b2d <parse+0xaf>
c0100b10:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b13:	0f b6 00             	movzbl (%eax),%eax
c0100b16:	0f be c0             	movsbl %al,%eax
c0100b19:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b1d:	c7 04 24 10 62 10 c0 	movl   $0xc0106210,(%esp)
c0100b24:	e8 63 51 00 00       	call   c0105c8c <strchr>
c0100b29:	85 c0                	test   %eax,%eax
c0100b2b:	74 d5                	je     c0100b02 <parse+0x84>
            buf ++;
        }
    }
c0100b2d:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b2e:	e9 66 ff ff ff       	jmp    c0100a99 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b36:	c9                   	leave  
c0100b37:	c3                   	ret    

c0100b38 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b38:	55                   	push   %ebp
c0100b39:	89 e5                	mov    %esp,%ebp
c0100b3b:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b3e:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b41:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b45:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b48:	89 04 24             	mov    %eax,(%esp)
c0100b4b:	e8 2e ff ff ff       	call   c0100a7e <parse>
c0100b50:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b53:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b57:	75 0a                	jne    c0100b63 <runcmd+0x2b>
        return 0;
c0100b59:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b5e:	e9 85 00 00 00       	jmp    c0100be8 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b6a:	eb 5c                	jmp    c0100bc8 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b6c:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b72:	89 d0                	mov    %edx,%eax
c0100b74:	01 c0                	add    %eax,%eax
c0100b76:	01 d0                	add    %edx,%eax
c0100b78:	c1 e0 02             	shl    $0x2,%eax
c0100b7b:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b80:	8b 00                	mov    (%eax),%eax
c0100b82:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b86:	89 04 24             	mov    %eax,(%esp)
c0100b89:	e8 5f 50 00 00       	call   c0105bed <strcmp>
c0100b8e:	85 c0                	test   %eax,%eax
c0100b90:	75 32                	jne    c0100bc4 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b92:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b95:	89 d0                	mov    %edx,%eax
c0100b97:	01 c0                	add    %eax,%eax
c0100b99:	01 d0                	add    %edx,%eax
c0100b9b:	c1 e0 02             	shl    $0x2,%eax
c0100b9e:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100ba3:	8b 40 08             	mov    0x8(%eax),%eax
c0100ba6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100ba9:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bac:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100baf:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bb3:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bb6:	83 c2 04             	add    $0x4,%edx
c0100bb9:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bbd:	89 0c 24             	mov    %ecx,(%esp)
c0100bc0:	ff d0                	call   *%eax
c0100bc2:	eb 24                	jmp    c0100be8 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bc4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bcb:	83 f8 02             	cmp    $0x2,%eax
c0100bce:	76 9c                	jbe    c0100b6c <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bd0:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bd3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bd7:	c7 04 24 33 62 10 c0 	movl   $0xc0106233,(%esp)
c0100bde:	e8 59 f7 ff ff       	call   c010033c <cprintf>
    return 0;
c0100be3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100be8:	c9                   	leave  
c0100be9:	c3                   	ret    

c0100bea <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bea:	55                   	push   %ebp
c0100beb:	89 e5                	mov    %esp,%ebp
c0100bed:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100bf0:	c7 04 24 4c 62 10 c0 	movl   $0xc010624c,(%esp)
c0100bf7:	e8 40 f7 ff ff       	call   c010033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100bfc:	c7 04 24 74 62 10 c0 	movl   $0xc0106274,(%esp)
c0100c03:	e8 34 f7 ff ff       	call   c010033c <cprintf>

    if (tf != NULL) {
c0100c08:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c0c:	74 0b                	je     c0100c19 <kmonitor+0x2f>
        print_trapframe(tf);
c0100c0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c11:	89 04 24             	mov    %eax,(%esp)
c0100c14:	e8 dc 0d 00 00       	call   c01019f5 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c19:	c7 04 24 99 62 10 c0 	movl   $0xc0106299,(%esp)
c0100c20:	e8 0e f6 ff ff       	call   c0100233 <readline>
c0100c25:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c2c:	74 18                	je     c0100c46 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c31:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c38:	89 04 24             	mov    %eax,(%esp)
c0100c3b:	e8 f8 fe ff ff       	call   c0100b38 <runcmd>
c0100c40:	85 c0                	test   %eax,%eax
c0100c42:	79 02                	jns    c0100c46 <kmonitor+0x5c>
                break;
c0100c44:	eb 02                	jmp    c0100c48 <kmonitor+0x5e>
            }
        }
    }
c0100c46:	eb d1                	jmp    c0100c19 <kmonitor+0x2f>
}
c0100c48:	c9                   	leave  
c0100c49:	c3                   	ret    

c0100c4a <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c4a:	55                   	push   %ebp
c0100c4b:	89 e5                	mov    %esp,%ebp
c0100c4d:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c57:	eb 3f                	jmp    c0100c98 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c59:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c5c:	89 d0                	mov    %edx,%eax
c0100c5e:	01 c0                	add    %eax,%eax
c0100c60:	01 d0                	add    %edx,%eax
c0100c62:	c1 e0 02             	shl    $0x2,%eax
c0100c65:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c6a:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c70:	89 d0                	mov    %edx,%eax
c0100c72:	01 c0                	add    %eax,%eax
c0100c74:	01 d0                	add    %edx,%eax
c0100c76:	c1 e0 02             	shl    $0x2,%eax
c0100c79:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c7e:	8b 00                	mov    (%eax),%eax
c0100c80:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c84:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c88:	c7 04 24 9d 62 10 c0 	movl   $0xc010629d,(%esp)
c0100c8f:	e8 a8 f6 ff ff       	call   c010033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c94:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c9b:	83 f8 02             	cmp    $0x2,%eax
c0100c9e:	76 b9                	jbe    c0100c59 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100ca0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ca5:	c9                   	leave  
c0100ca6:	c3                   	ret    

c0100ca7 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100ca7:	55                   	push   %ebp
c0100ca8:	89 e5                	mov    %esp,%ebp
c0100caa:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cad:	e8 be fb ff ff       	call   c0100870 <print_kerninfo>
    return 0;
c0100cb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cb7:	c9                   	leave  
c0100cb8:	c3                   	ret    

c0100cb9 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cb9:	55                   	push   %ebp
c0100cba:	89 e5                	mov    %esp,%ebp
c0100cbc:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cbf:	e8 f6 fc ff ff       	call   c01009ba <print_stackframe>
    return 0;
c0100cc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cc9:	c9                   	leave  
c0100cca:	c3                   	ret    

c0100ccb <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100ccb:	55                   	push   %ebp
c0100ccc:	89 e5                	mov    %esp,%ebp
c0100cce:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cd1:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
c0100cd6:	85 c0                	test   %eax,%eax
c0100cd8:	74 02                	je     c0100cdc <__panic+0x11>
        goto panic_dead;
c0100cda:	eb 48                	jmp    c0100d24 <__panic+0x59>
    }
    is_panic = 1;
c0100cdc:	c7 05 60 7e 11 c0 01 	movl   $0x1,0xc0117e60
c0100ce3:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100ce6:	8d 45 14             	lea    0x14(%ebp),%eax
c0100ce9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cec:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cef:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100cf3:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cf6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cfa:	c7 04 24 a6 62 10 c0 	movl   $0xc01062a6,(%esp)
c0100d01:	e8 36 f6 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d09:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d0d:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d10:	89 04 24             	mov    %eax,(%esp)
c0100d13:	e8 f1 f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d18:	c7 04 24 c2 62 10 c0 	movl   $0xc01062c2,(%esp)
c0100d1f:	e8 18 f6 ff ff       	call   c010033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d24:	e8 85 09 00 00       	call   c01016ae <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d29:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d30:	e8 b5 fe ff ff       	call   c0100bea <kmonitor>
    }
c0100d35:	eb f2                	jmp    c0100d29 <__panic+0x5e>

c0100d37 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d37:	55                   	push   %ebp
c0100d38:	89 e5                	mov    %esp,%ebp
c0100d3a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d3d:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d40:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d43:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d46:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d4d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d51:	c7 04 24 c4 62 10 c0 	movl   $0xc01062c4,(%esp)
c0100d58:	e8 df f5 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d60:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d64:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d67:	89 04 24             	mov    %eax,(%esp)
c0100d6a:	e8 9a f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d6f:	c7 04 24 c2 62 10 c0 	movl   $0xc01062c2,(%esp)
c0100d76:	e8 c1 f5 ff ff       	call   c010033c <cprintf>
    va_end(ap);
}
c0100d7b:	c9                   	leave  
c0100d7c:	c3                   	ret    

c0100d7d <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d7d:	55                   	push   %ebp
c0100d7e:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d80:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
}
c0100d85:	5d                   	pop    %ebp
c0100d86:	c3                   	ret    

c0100d87 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d87:	55                   	push   %ebp
c0100d88:	89 e5                	mov    %esp,%ebp
c0100d8a:	83 ec 28             	sub    $0x28,%esp
c0100d8d:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d93:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d97:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100d9b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100d9f:	ee                   	out    %al,(%dx)
c0100da0:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100da6:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100daa:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100dae:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100db2:	ee                   	out    %al,(%dx)
c0100db3:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100db9:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dbd:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dc1:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dc5:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dc6:	c7 05 4c 89 11 c0 00 	movl   $0x0,0xc011894c
c0100dcd:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dd0:	c7 04 24 e2 62 10 c0 	movl   $0xc01062e2,(%esp)
c0100dd7:	e8 60 f5 ff ff       	call   c010033c <cprintf>
    pic_enable(IRQ_TIMER);
c0100ddc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100de3:	e8 24 09 00 00       	call   c010170c <pic_enable>
}
c0100de8:	c9                   	leave  
c0100de9:	c3                   	ret    

c0100dea <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100dea:	55                   	push   %ebp
c0100deb:	89 e5                	mov    %esp,%ebp
c0100ded:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100df0:	9c                   	pushf  
c0100df1:	58                   	pop    %eax
c0100df2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100df8:	25 00 02 00 00       	and    $0x200,%eax
c0100dfd:	85 c0                	test   %eax,%eax
c0100dff:	74 0c                	je     c0100e0d <__intr_save+0x23>
        intr_disable();
c0100e01:	e8 a8 08 00 00       	call   c01016ae <intr_disable>
        return 1;
c0100e06:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e0b:	eb 05                	jmp    c0100e12 <__intr_save+0x28>
    }
    return 0;
c0100e0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e12:	c9                   	leave  
c0100e13:	c3                   	ret    

c0100e14 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e14:	55                   	push   %ebp
c0100e15:	89 e5                	mov    %esp,%ebp
c0100e17:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e1e:	74 05                	je     c0100e25 <__intr_restore+0x11>
        intr_enable();
c0100e20:	e8 83 08 00 00       	call   c01016a8 <intr_enable>
    }
}
c0100e25:	c9                   	leave  
c0100e26:	c3                   	ret    

c0100e27 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e27:	55                   	push   %ebp
c0100e28:	89 e5                	mov    %esp,%ebp
c0100e2a:	83 ec 10             	sub    $0x10,%esp
c0100e2d:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e33:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e37:	89 c2                	mov    %eax,%edx
c0100e39:	ec                   	in     (%dx),%al
c0100e3a:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e3d:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e43:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e47:	89 c2                	mov    %eax,%edx
c0100e49:	ec                   	in     (%dx),%al
c0100e4a:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e4d:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e53:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e57:	89 c2                	mov    %eax,%edx
c0100e59:	ec                   	in     (%dx),%al
c0100e5a:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e5d:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e63:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e67:	89 c2                	mov    %eax,%edx
c0100e69:	ec                   	in     (%dx),%al
c0100e6a:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e6d:	c9                   	leave  
c0100e6e:	c3                   	ret    

c0100e6f <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e6f:	55                   	push   %ebp
c0100e70:	89 e5                	mov    %esp,%ebp
c0100e72:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e75:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e7f:	0f b7 00             	movzwl (%eax),%eax
c0100e82:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e86:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e89:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e91:	0f b7 00             	movzwl (%eax),%eax
c0100e94:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e98:	74 12                	je     c0100eac <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e9a:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100ea1:	66 c7 05 86 7e 11 c0 	movw   $0x3b4,0xc0117e86
c0100ea8:	b4 03 
c0100eaa:	eb 13                	jmp    c0100ebf <cga_init+0x50>
    } else {
        *cp = was;
c0100eac:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eaf:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100eb3:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100eb6:	66 c7 05 86 7e 11 c0 	movw   $0x3d4,0xc0117e86
c0100ebd:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ebf:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ec6:	0f b7 c0             	movzwl %ax,%eax
c0100ec9:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ecd:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ed1:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ed5:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ed9:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100eda:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ee1:	83 c0 01             	add    $0x1,%eax
c0100ee4:	0f b7 c0             	movzwl %ax,%eax
c0100ee7:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100eeb:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100eef:	89 c2                	mov    %eax,%edx
c0100ef1:	ec                   	in     (%dx),%al
c0100ef2:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100ef5:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100ef9:	0f b6 c0             	movzbl %al,%eax
c0100efc:	c1 e0 08             	shl    $0x8,%eax
c0100eff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f02:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f09:	0f b7 c0             	movzwl %ax,%eax
c0100f0c:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f10:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f14:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f18:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f1c:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f1d:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f24:	83 c0 01             	add    $0x1,%eax
c0100f27:	0f b7 c0             	movzwl %ax,%eax
c0100f2a:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f2e:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f32:	89 c2                	mov    %eax,%edx
c0100f34:	ec                   	in     (%dx),%al
c0100f35:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f38:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f3c:	0f b6 c0             	movzbl %al,%eax
c0100f3f:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f42:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f45:	a3 80 7e 11 c0       	mov    %eax,0xc0117e80
    crt_pos = pos;
c0100f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f4d:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
}
c0100f53:	c9                   	leave  
c0100f54:	c3                   	ret    

c0100f55 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f55:	55                   	push   %ebp
c0100f56:	89 e5                	mov    %esp,%ebp
c0100f58:	83 ec 48             	sub    $0x48,%esp
c0100f5b:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f61:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f65:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f69:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f6d:	ee                   	out    %al,(%dx)
c0100f6e:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f74:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f78:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f7c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f80:	ee                   	out    %al,(%dx)
c0100f81:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f87:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f8b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f8f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f93:	ee                   	out    %al,(%dx)
c0100f94:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100f9a:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100f9e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fa2:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fa6:	ee                   	out    %al,(%dx)
c0100fa7:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fad:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fb1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fb5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fb9:	ee                   	out    %al,(%dx)
c0100fba:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fc0:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fc4:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fc8:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fcc:	ee                   	out    %al,(%dx)
c0100fcd:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fd3:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fd7:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fdb:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fdf:	ee                   	out    %al,(%dx)
c0100fe0:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fe6:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100fea:	89 c2                	mov    %eax,%edx
c0100fec:	ec                   	in     (%dx),%al
c0100fed:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100ff0:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100ff4:	3c ff                	cmp    $0xff,%al
c0100ff6:	0f 95 c0             	setne  %al
c0100ff9:	0f b6 c0             	movzbl %al,%eax
c0100ffc:	a3 88 7e 11 c0       	mov    %eax,0xc0117e88
c0101001:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101007:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c010100b:	89 c2                	mov    %eax,%edx
c010100d:	ec                   	in     (%dx),%al
c010100e:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0101011:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101017:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c010101b:	89 c2                	mov    %eax,%edx
c010101d:	ec                   	in     (%dx),%al
c010101e:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101021:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0101026:	85 c0                	test   %eax,%eax
c0101028:	74 0c                	je     c0101036 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c010102a:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101031:	e8 d6 06 00 00       	call   c010170c <pic_enable>
    }
}
c0101036:	c9                   	leave  
c0101037:	c3                   	ret    

c0101038 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101038:	55                   	push   %ebp
c0101039:	89 e5                	mov    %esp,%ebp
c010103b:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010103e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101045:	eb 09                	jmp    c0101050 <lpt_putc_sub+0x18>
        delay();
c0101047:	e8 db fd ff ff       	call   c0100e27 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010104c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101050:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101056:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010105a:	89 c2                	mov    %eax,%edx
c010105c:	ec                   	in     (%dx),%al
c010105d:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101060:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101064:	84 c0                	test   %al,%al
c0101066:	78 09                	js     c0101071 <lpt_putc_sub+0x39>
c0101068:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010106f:	7e d6                	jle    c0101047 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101071:	8b 45 08             	mov    0x8(%ebp),%eax
c0101074:	0f b6 c0             	movzbl %al,%eax
c0101077:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c010107d:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101080:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101084:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101088:	ee                   	out    %al,(%dx)
c0101089:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c010108f:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c0101093:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101097:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010109b:	ee                   	out    %al,(%dx)
c010109c:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010a2:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010a6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010aa:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010ae:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010af:	c9                   	leave  
c01010b0:	c3                   	ret    

c01010b1 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010b1:	55                   	push   %ebp
c01010b2:	89 e5                	mov    %esp,%ebp
c01010b4:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010b7:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010bb:	74 0d                	je     c01010ca <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01010c0:	89 04 24             	mov    %eax,(%esp)
c01010c3:	e8 70 ff ff ff       	call   c0101038 <lpt_putc_sub>
c01010c8:	eb 24                	jmp    c01010ee <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010d1:	e8 62 ff ff ff       	call   c0101038 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010d6:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010dd:	e8 56 ff ff ff       	call   c0101038 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010e2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010e9:	e8 4a ff ff ff       	call   c0101038 <lpt_putc_sub>
    }
}
c01010ee:	c9                   	leave  
c01010ef:	c3                   	ret    

c01010f0 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010f0:	55                   	push   %ebp
c01010f1:	89 e5                	mov    %esp,%ebp
c01010f3:	53                   	push   %ebx
c01010f4:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01010fa:	b0 00                	mov    $0x0,%al
c01010fc:	85 c0                	test   %eax,%eax
c01010fe:	75 07                	jne    c0101107 <cga_putc+0x17>
        c |= 0x0700;
c0101100:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101107:	8b 45 08             	mov    0x8(%ebp),%eax
c010110a:	0f b6 c0             	movzbl %al,%eax
c010110d:	83 f8 0a             	cmp    $0xa,%eax
c0101110:	74 4c                	je     c010115e <cga_putc+0x6e>
c0101112:	83 f8 0d             	cmp    $0xd,%eax
c0101115:	74 57                	je     c010116e <cga_putc+0x7e>
c0101117:	83 f8 08             	cmp    $0x8,%eax
c010111a:	0f 85 88 00 00 00    	jne    c01011a8 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101120:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101127:	66 85 c0             	test   %ax,%ax
c010112a:	74 30                	je     c010115c <cga_putc+0x6c>
            crt_pos --;
c010112c:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101133:	83 e8 01             	sub    $0x1,%eax
c0101136:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c010113c:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101141:	0f b7 15 84 7e 11 c0 	movzwl 0xc0117e84,%edx
c0101148:	0f b7 d2             	movzwl %dx,%edx
c010114b:	01 d2                	add    %edx,%edx
c010114d:	01 c2                	add    %eax,%edx
c010114f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101152:	b0 00                	mov    $0x0,%al
c0101154:	83 c8 20             	or     $0x20,%eax
c0101157:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c010115a:	eb 72                	jmp    c01011ce <cga_putc+0xde>
c010115c:	eb 70                	jmp    c01011ce <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c010115e:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101165:	83 c0 50             	add    $0x50,%eax
c0101168:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c010116e:	0f b7 1d 84 7e 11 c0 	movzwl 0xc0117e84,%ebx
c0101175:	0f b7 0d 84 7e 11 c0 	movzwl 0xc0117e84,%ecx
c010117c:	0f b7 c1             	movzwl %cx,%eax
c010117f:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101185:	c1 e8 10             	shr    $0x10,%eax
c0101188:	89 c2                	mov    %eax,%edx
c010118a:	66 c1 ea 06          	shr    $0x6,%dx
c010118e:	89 d0                	mov    %edx,%eax
c0101190:	c1 e0 02             	shl    $0x2,%eax
c0101193:	01 d0                	add    %edx,%eax
c0101195:	c1 e0 04             	shl    $0x4,%eax
c0101198:	29 c1                	sub    %eax,%ecx
c010119a:	89 ca                	mov    %ecx,%edx
c010119c:	89 d8                	mov    %ebx,%eax
c010119e:	29 d0                	sub    %edx,%eax
c01011a0:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
        break;
c01011a6:	eb 26                	jmp    c01011ce <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011a8:	8b 0d 80 7e 11 c0    	mov    0xc0117e80,%ecx
c01011ae:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011b5:	8d 50 01             	lea    0x1(%eax),%edx
c01011b8:	66 89 15 84 7e 11 c0 	mov    %dx,0xc0117e84
c01011bf:	0f b7 c0             	movzwl %ax,%eax
c01011c2:	01 c0                	add    %eax,%eax
c01011c4:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01011ca:	66 89 02             	mov    %ax,(%edx)
        break;
c01011cd:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011ce:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011d5:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011d9:	76 5b                	jbe    c0101236 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011db:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011e0:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011e6:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011eb:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011f2:	00 
c01011f3:	89 54 24 04          	mov    %edx,0x4(%esp)
c01011f7:	89 04 24             	mov    %eax,(%esp)
c01011fa:	e8 8b 4c 00 00       	call   c0105e8a <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011ff:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101206:	eb 15                	jmp    c010121d <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101208:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c010120d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101210:	01 d2                	add    %edx,%edx
c0101212:	01 d0                	add    %edx,%eax
c0101214:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101219:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010121d:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101224:	7e e2                	jle    c0101208 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101226:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010122d:	83 e8 50             	sub    $0x50,%eax
c0101230:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101236:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c010123d:	0f b7 c0             	movzwl %ax,%eax
c0101240:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101244:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101248:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010124c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101250:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101251:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101258:	66 c1 e8 08          	shr    $0x8,%ax
c010125c:	0f b6 c0             	movzbl %al,%eax
c010125f:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c0101266:	83 c2 01             	add    $0x1,%edx
c0101269:	0f b7 d2             	movzwl %dx,%edx
c010126c:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101270:	88 45 ed             	mov    %al,-0x13(%ebp)
c0101273:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101277:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010127b:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c010127c:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101283:	0f b7 c0             	movzwl %ax,%eax
c0101286:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c010128a:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c010128e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101292:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101296:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101297:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010129e:	0f b6 c0             	movzbl %al,%eax
c01012a1:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c01012a8:	83 c2 01             	add    $0x1,%edx
c01012ab:	0f b7 d2             	movzwl %dx,%edx
c01012ae:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012b2:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012b5:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012b9:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012bd:	ee                   	out    %al,(%dx)
}
c01012be:	83 c4 34             	add    $0x34,%esp
c01012c1:	5b                   	pop    %ebx
c01012c2:	5d                   	pop    %ebp
c01012c3:	c3                   	ret    

c01012c4 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012c4:	55                   	push   %ebp
c01012c5:	89 e5                	mov    %esp,%ebp
c01012c7:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012d1:	eb 09                	jmp    c01012dc <serial_putc_sub+0x18>
        delay();
c01012d3:	e8 4f fb ff ff       	call   c0100e27 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012d8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012dc:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012e2:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012e6:	89 c2                	mov    %eax,%edx
c01012e8:	ec                   	in     (%dx),%al
c01012e9:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012ec:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012f0:	0f b6 c0             	movzbl %al,%eax
c01012f3:	83 e0 20             	and    $0x20,%eax
c01012f6:	85 c0                	test   %eax,%eax
c01012f8:	75 09                	jne    c0101303 <serial_putc_sub+0x3f>
c01012fa:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101301:	7e d0                	jle    c01012d3 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101303:	8b 45 08             	mov    0x8(%ebp),%eax
c0101306:	0f b6 c0             	movzbl %al,%eax
c0101309:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c010130f:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101312:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101316:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010131a:	ee                   	out    %al,(%dx)
}
c010131b:	c9                   	leave  
c010131c:	c3                   	ret    

c010131d <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c010131d:	55                   	push   %ebp
c010131e:	89 e5                	mov    %esp,%ebp
c0101320:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101323:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101327:	74 0d                	je     c0101336 <serial_putc+0x19>
        serial_putc_sub(c);
c0101329:	8b 45 08             	mov    0x8(%ebp),%eax
c010132c:	89 04 24             	mov    %eax,(%esp)
c010132f:	e8 90 ff ff ff       	call   c01012c4 <serial_putc_sub>
c0101334:	eb 24                	jmp    c010135a <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101336:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010133d:	e8 82 ff ff ff       	call   c01012c4 <serial_putc_sub>
        serial_putc_sub(' ');
c0101342:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101349:	e8 76 ff ff ff       	call   c01012c4 <serial_putc_sub>
        serial_putc_sub('\b');
c010134e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101355:	e8 6a ff ff ff       	call   c01012c4 <serial_putc_sub>
    }
}
c010135a:	c9                   	leave  
c010135b:	c3                   	ret    

c010135c <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010135c:	55                   	push   %ebp
c010135d:	89 e5                	mov    %esp,%ebp
c010135f:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101362:	eb 33                	jmp    c0101397 <cons_intr+0x3b>
        if (c != 0) {
c0101364:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101368:	74 2d                	je     c0101397 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c010136a:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010136f:	8d 50 01             	lea    0x1(%eax),%edx
c0101372:	89 15 a4 80 11 c0    	mov    %edx,0xc01180a4
c0101378:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010137b:	88 90 a0 7e 11 c0    	mov    %dl,-0x3fee8160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101381:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101386:	3d 00 02 00 00       	cmp    $0x200,%eax
c010138b:	75 0a                	jne    c0101397 <cons_intr+0x3b>
                cons.wpos = 0;
c010138d:	c7 05 a4 80 11 c0 00 	movl   $0x0,0xc01180a4
c0101394:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c0101397:	8b 45 08             	mov    0x8(%ebp),%eax
c010139a:	ff d0                	call   *%eax
c010139c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010139f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013a3:	75 bf                	jne    c0101364 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013a5:	c9                   	leave  
c01013a6:	c3                   	ret    

c01013a7 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013a7:	55                   	push   %ebp
c01013a8:	89 e5                	mov    %esp,%ebp
c01013aa:	83 ec 10             	sub    $0x10,%esp
c01013ad:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013b3:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013b7:	89 c2                	mov    %eax,%edx
c01013b9:	ec                   	in     (%dx),%al
c01013ba:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013bd:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013c1:	0f b6 c0             	movzbl %al,%eax
c01013c4:	83 e0 01             	and    $0x1,%eax
c01013c7:	85 c0                	test   %eax,%eax
c01013c9:	75 07                	jne    c01013d2 <serial_proc_data+0x2b>
        return -1;
c01013cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013d0:	eb 2a                	jmp    c01013fc <serial_proc_data+0x55>
c01013d2:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013d8:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013dc:	89 c2                	mov    %eax,%edx
c01013de:	ec                   	in     (%dx),%al
c01013df:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013e2:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013e6:	0f b6 c0             	movzbl %al,%eax
c01013e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013ec:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013f0:	75 07                	jne    c01013f9 <serial_proc_data+0x52>
        c = '\b';
c01013f2:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01013fc:	c9                   	leave  
c01013fd:	c3                   	ret    

c01013fe <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01013fe:	55                   	push   %ebp
c01013ff:	89 e5                	mov    %esp,%ebp
c0101401:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101404:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0101409:	85 c0                	test   %eax,%eax
c010140b:	74 0c                	je     c0101419 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c010140d:	c7 04 24 a7 13 10 c0 	movl   $0xc01013a7,(%esp)
c0101414:	e8 43 ff ff ff       	call   c010135c <cons_intr>
    }
}
c0101419:	c9                   	leave  
c010141a:	c3                   	ret    

c010141b <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c010141b:	55                   	push   %ebp
c010141c:	89 e5                	mov    %esp,%ebp
c010141e:	83 ec 38             	sub    $0x38,%esp
c0101421:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101427:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c010142b:	89 c2                	mov    %eax,%edx
c010142d:	ec                   	in     (%dx),%al
c010142e:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101431:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101435:	0f b6 c0             	movzbl %al,%eax
c0101438:	83 e0 01             	and    $0x1,%eax
c010143b:	85 c0                	test   %eax,%eax
c010143d:	75 0a                	jne    c0101449 <kbd_proc_data+0x2e>
        return -1;
c010143f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101444:	e9 59 01 00 00       	jmp    c01015a2 <kbd_proc_data+0x187>
c0101449:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010144f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101453:	89 c2                	mov    %eax,%edx
c0101455:	ec                   	in     (%dx),%al
c0101456:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101459:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c010145d:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101460:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101464:	75 17                	jne    c010147d <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101466:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010146b:	83 c8 40             	or     $0x40,%eax
c010146e:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c0101473:	b8 00 00 00 00       	mov    $0x0,%eax
c0101478:	e9 25 01 00 00       	jmp    c01015a2 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c010147d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101481:	84 c0                	test   %al,%al
c0101483:	79 47                	jns    c01014cc <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101485:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010148a:	83 e0 40             	and    $0x40,%eax
c010148d:	85 c0                	test   %eax,%eax
c010148f:	75 09                	jne    c010149a <kbd_proc_data+0x7f>
c0101491:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101495:	83 e0 7f             	and    $0x7f,%eax
c0101498:	eb 04                	jmp    c010149e <kbd_proc_data+0x83>
c010149a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010149e:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014a1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a5:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014ac:	83 c8 40             	or     $0x40,%eax
c01014af:	0f b6 c0             	movzbl %al,%eax
c01014b2:	f7 d0                	not    %eax
c01014b4:	89 c2                	mov    %eax,%edx
c01014b6:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014bb:	21 d0                	and    %edx,%eax
c01014bd:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c01014c2:	b8 00 00 00 00       	mov    $0x0,%eax
c01014c7:	e9 d6 00 00 00       	jmp    c01015a2 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014cc:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014d1:	83 e0 40             	and    $0x40,%eax
c01014d4:	85 c0                	test   %eax,%eax
c01014d6:	74 11                	je     c01014e9 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014d8:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014dc:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014e1:	83 e0 bf             	and    $0xffffffbf,%eax
c01014e4:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    }

    shift |= shiftcode[data];
c01014e9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014ed:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014f4:	0f b6 d0             	movzbl %al,%edx
c01014f7:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014fc:	09 d0                	or     %edx,%eax
c01014fe:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    shift ^= togglecode[data];
c0101503:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101507:	0f b6 80 60 71 11 c0 	movzbl -0x3fee8ea0(%eax),%eax
c010150e:	0f b6 d0             	movzbl %al,%edx
c0101511:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101516:	31 d0                	xor    %edx,%eax
c0101518:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8

    c = charcode[shift & (CTL | SHIFT)][data];
c010151d:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101522:	83 e0 03             	and    $0x3,%eax
c0101525:	8b 14 85 60 75 11 c0 	mov    -0x3fee8aa0(,%eax,4),%edx
c010152c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101530:	01 d0                	add    %edx,%eax
c0101532:	0f b6 00             	movzbl (%eax),%eax
c0101535:	0f b6 c0             	movzbl %al,%eax
c0101538:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010153b:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101540:	83 e0 08             	and    $0x8,%eax
c0101543:	85 c0                	test   %eax,%eax
c0101545:	74 22                	je     c0101569 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101547:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010154b:	7e 0c                	jle    c0101559 <kbd_proc_data+0x13e>
c010154d:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101551:	7f 06                	jg     c0101559 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101553:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101557:	eb 10                	jmp    c0101569 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101559:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c010155d:	7e 0a                	jle    c0101569 <kbd_proc_data+0x14e>
c010155f:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101563:	7f 04                	jg     c0101569 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101565:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101569:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010156e:	f7 d0                	not    %eax
c0101570:	83 e0 06             	and    $0x6,%eax
c0101573:	85 c0                	test   %eax,%eax
c0101575:	75 28                	jne    c010159f <kbd_proc_data+0x184>
c0101577:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c010157e:	75 1f                	jne    c010159f <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101580:	c7 04 24 fd 62 10 c0 	movl   $0xc01062fd,(%esp)
c0101587:	e8 b0 ed ff ff       	call   c010033c <cprintf>
c010158c:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101592:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101596:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c010159a:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c010159e:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c010159f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015a2:	c9                   	leave  
c01015a3:	c3                   	ret    

c01015a4 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015a4:	55                   	push   %ebp
c01015a5:	89 e5                	mov    %esp,%ebp
c01015a7:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015aa:	c7 04 24 1b 14 10 c0 	movl   $0xc010141b,(%esp)
c01015b1:	e8 a6 fd ff ff       	call   c010135c <cons_intr>
}
c01015b6:	c9                   	leave  
c01015b7:	c3                   	ret    

c01015b8 <kbd_init>:

static void
kbd_init(void) {
c01015b8:	55                   	push   %ebp
c01015b9:	89 e5                	mov    %esp,%ebp
c01015bb:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015be:	e8 e1 ff ff ff       	call   c01015a4 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015c3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015ca:	e8 3d 01 00 00       	call   c010170c <pic_enable>
}
c01015cf:	c9                   	leave  
c01015d0:	c3                   	ret    

c01015d1 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015d1:	55                   	push   %ebp
c01015d2:	89 e5                	mov    %esp,%ebp
c01015d4:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015d7:	e8 93 f8 ff ff       	call   c0100e6f <cga_init>
    serial_init();
c01015dc:	e8 74 f9 ff ff       	call   c0100f55 <serial_init>
    kbd_init();
c01015e1:	e8 d2 ff ff ff       	call   c01015b8 <kbd_init>
    if (!serial_exists) {
c01015e6:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01015eb:	85 c0                	test   %eax,%eax
c01015ed:	75 0c                	jne    c01015fb <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015ef:	c7 04 24 09 63 10 c0 	movl   $0xc0106309,(%esp)
c01015f6:	e8 41 ed ff ff       	call   c010033c <cprintf>
    }
}
c01015fb:	c9                   	leave  
c01015fc:	c3                   	ret    

c01015fd <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01015fd:	55                   	push   %ebp
c01015fe:	89 e5                	mov    %esp,%ebp
c0101600:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101603:	e8 e2 f7 ff ff       	call   c0100dea <__intr_save>
c0101608:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c010160b:	8b 45 08             	mov    0x8(%ebp),%eax
c010160e:	89 04 24             	mov    %eax,(%esp)
c0101611:	e8 9b fa ff ff       	call   c01010b1 <lpt_putc>
        cga_putc(c);
c0101616:	8b 45 08             	mov    0x8(%ebp),%eax
c0101619:	89 04 24             	mov    %eax,(%esp)
c010161c:	e8 cf fa ff ff       	call   c01010f0 <cga_putc>
        serial_putc(c);
c0101621:	8b 45 08             	mov    0x8(%ebp),%eax
c0101624:	89 04 24             	mov    %eax,(%esp)
c0101627:	e8 f1 fc ff ff       	call   c010131d <serial_putc>
    }
    local_intr_restore(intr_flag);
c010162c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010162f:	89 04 24             	mov    %eax,(%esp)
c0101632:	e8 dd f7 ff ff       	call   c0100e14 <__intr_restore>
}
c0101637:	c9                   	leave  
c0101638:	c3                   	ret    

c0101639 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101639:	55                   	push   %ebp
c010163a:	89 e5                	mov    %esp,%ebp
c010163c:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c010163f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101646:	e8 9f f7 ff ff       	call   c0100dea <__intr_save>
c010164b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c010164e:	e8 ab fd ff ff       	call   c01013fe <serial_intr>
        kbd_intr();
c0101653:	e8 4c ff ff ff       	call   c01015a4 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101658:	8b 15 a0 80 11 c0    	mov    0xc01180a0,%edx
c010165e:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101663:	39 c2                	cmp    %eax,%edx
c0101665:	74 31                	je     c0101698 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101667:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c010166c:	8d 50 01             	lea    0x1(%eax),%edx
c010166f:	89 15 a0 80 11 c0    	mov    %edx,0xc01180a0
c0101675:	0f b6 80 a0 7e 11 c0 	movzbl -0x3fee8160(%eax),%eax
c010167c:	0f b6 c0             	movzbl %al,%eax
c010167f:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101682:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101687:	3d 00 02 00 00       	cmp    $0x200,%eax
c010168c:	75 0a                	jne    c0101698 <cons_getc+0x5f>
                cons.rpos = 0;
c010168e:	c7 05 a0 80 11 c0 00 	movl   $0x0,0xc01180a0
c0101695:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101698:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010169b:	89 04 24             	mov    %eax,(%esp)
c010169e:	e8 71 f7 ff ff       	call   c0100e14 <__intr_restore>
    return c;
c01016a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016a6:	c9                   	leave  
c01016a7:	c3                   	ret    

c01016a8 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01016a8:	55                   	push   %ebp
c01016a9:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01016ab:	fb                   	sti    
    sti();
}
c01016ac:	5d                   	pop    %ebp
c01016ad:	c3                   	ret    

c01016ae <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01016ae:	55                   	push   %ebp
c01016af:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01016b1:	fa                   	cli    
    cli();
}
c01016b2:	5d                   	pop    %ebp
c01016b3:	c3                   	ret    

c01016b4 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016b4:	55                   	push   %ebp
c01016b5:	89 e5                	mov    %esp,%ebp
c01016b7:	83 ec 14             	sub    $0x14,%esp
c01016ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01016bd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016c1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016c5:	66 a3 70 75 11 c0    	mov    %ax,0xc0117570
    if (did_init) {
c01016cb:	a1 ac 80 11 c0       	mov    0xc01180ac,%eax
c01016d0:	85 c0                	test   %eax,%eax
c01016d2:	74 36                	je     c010170a <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016d4:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016d8:	0f b6 c0             	movzbl %al,%eax
c01016db:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016e1:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016e4:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01016e8:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016ec:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016ed:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016f1:	66 c1 e8 08          	shr    $0x8,%ax
c01016f5:	0f b6 c0             	movzbl %al,%eax
c01016f8:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c01016fe:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101701:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101705:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101709:	ee                   	out    %al,(%dx)
    }
}
c010170a:	c9                   	leave  
c010170b:	c3                   	ret    

c010170c <pic_enable>:

void
pic_enable(unsigned int irq) {
c010170c:	55                   	push   %ebp
c010170d:	89 e5                	mov    %esp,%ebp
c010170f:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101712:	8b 45 08             	mov    0x8(%ebp),%eax
c0101715:	ba 01 00 00 00       	mov    $0x1,%edx
c010171a:	89 c1                	mov    %eax,%ecx
c010171c:	d3 e2                	shl    %cl,%edx
c010171e:	89 d0                	mov    %edx,%eax
c0101720:	f7 d0                	not    %eax
c0101722:	89 c2                	mov    %eax,%edx
c0101724:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010172b:	21 d0                	and    %edx,%eax
c010172d:	0f b7 c0             	movzwl %ax,%eax
c0101730:	89 04 24             	mov    %eax,(%esp)
c0101733:	e8 7c ff ff ff       	call   c01016b4 <pic_setmask>
}
c0101738:	c9                   	leave  
c0101739:	c3                   	ret    

c010173a <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c010173a:	55                   	push   %ebp
c010173b:	89 e5                	mov    %esp,%ebp
c010173d:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101740:	c7 05 ac 80 11 c0 01 	movl   $0x1,0xc01180ac
c0101747:	00 00 00 
c010174a:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101750:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101754:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101758:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010175c:	ee                   	out    %al,(%dx)
c010175d:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101763:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101767:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010176b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010176f:	ee                   	out    %al,(%dx)
c0101770:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101776:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c010177a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010177e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101782:	ee                   	out    %al,(%dx)
c0101783:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0101789:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c010178d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101791:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101795:	ee                   	out    %al,(%dx)
c0101796:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c010179c:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c01017a0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01017a4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017a8:	ee                   	out    %al,(%dx)
c01017a9:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01017af:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01017b3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017b7:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017bb:	ee                   	out    %al,(%dx)
c01017bc:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01017c2:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c01017c6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017ca:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017ce:	ee                   	out    %al,(%dx)
c01017cf:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c01017d5:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c01017d9:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017dd:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017e1:	ee                   	out    %al,(%dx)
c01017e2:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c01017e8:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c01017ec:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017f0:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017f4:	ee                   	out    %al,(%dx)
c01017f5:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c01017fb:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c01017ff:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101803:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101807:	ee                   	out    %al,(%dx)
c0101808:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c010180e:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0101812:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101816:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010181a:	ee                   	out    %al,(%dx)
c010181b:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101821:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c0101825:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101829:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010182d:	ee                   	out    %al,(%dx)
c010182e:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c0101834:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c0101838:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c010183c:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101840:	ee                   	out    %al,(%dx)
c0101841:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c0101847:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c010184b:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c010184f:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101853:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101854:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010185b:	66 83 f8 ff          	cmp    $0xffff,%ax
c010185f:	74 12                	je     c0101873 <pic_init+0x139>
        pic_setmask(irq_mask);
c0101861:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101868:	0f b7 c0             	movzwl %ax,%eax
c010186b:	89 04 24             	mov    %eax,(%esp)
c010186e:	e8 41 fe ff ff       	call   c01016b4 <pic_setmask>
    }
}
c0101873:	c9                   	leave  
c0101874:	c3                   	ret    

c0101875 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101875:	55                   	push   %ebp
c0101876:	89 e5                	mov    %esp,%ebp
c0101878:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c010187b:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0101882:	00 
c0101883:	c7 04 24 40 63 10 c0 	movl   $0xc0106340,(%esp)
c010188a:	e8 ad ea ff ff       	call   c010033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c010188f:	c7 04 24 4a 63 10 c0 	movl   $0xc010634a,(%esp)
c0101896:	e8 a1 ea ff ff       	call   c010033c <cprintf>
    panic("EOT: kernel seems ok.");
c010189b:	c7 44 24 08 58 63 10 	movl   $0xc0106358,0x8(%esp)
c01018a2:	c0 
c01018a3:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c01018aa:	00 
c01018ab:	c7 04 24 6e 63 10 c0 	movl   $0xc010636e,(%esp)
c01018b2:	e8 14 f4 ff ff       	call   c0100ccb <__panic>

c01018b7 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01018b7:	55                   	push   %ebp
c01018b8:	89 e5                	mov    %esp,%ebp
c01018ba:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int cnt_idt = sizeof(idt) / sizeof(struct gatedesc);
c01018bd:	c7 45 f8 00 01 00 00 	movl   $0x100,-0x8(%ebp)
	int i;
	for (i = 0; i < cnt_idt; i++)
c01018c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018cb:	e9 c3 00 00 00       	jmp    c0101993 <idt_init+0xdc>
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01018d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018d3:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c01018da:	89 c2                	mov    %eax,%edx
c01018dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018df:	66 89 14 c5 c0 80 11 	mov    %dx,-0x3fee7f40(,%eax,8)
c01018e6:	c0 
c01018e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ea:	66 c7 04 c5 c2 80 11 	movw   $0x8,-0x3fee7f3e(,%eax,8)
c01018f1:	c0 08 00 
c01018f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018f7:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018fe:	c0 
c01018ff:	83 e2 e0             	and    $0xffffffe0,%edx
c0101902:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c0101909:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010190c:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c0101913:	c0 
c0101914:	83 e2 1f             	and    $0x1f,%edx
c0101917:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c010191e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101921:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101928:	c0 
c0101929:	83 e2 f0             	and    $0xfffffff0,%edx
c010192c:	83 ca 0e             	or     $0xe,%edx
c010192f:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101936:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101939:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101940:	c0 
c0101941:	83 e2 ef             	and    $0xffffffef,%edx
c0101944:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010194b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010194e:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101955:	c0 
c0101956:	83 e2 9f             	and    $0xffffff9f,%edx
c0101959:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101960:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101963:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010196a:	c0 
c010196b:	83 ca 80             	or     $0xffffff80,%edx
c010196e:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101975:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101978:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c010197f:	c1 e8 10             	shr    $0x10,%eax
c0101982:	89 c2                	mov    %eax,%edx
c0101984:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101987:	66 89 14 c5 c6 80 11 	mov    %dx,-0x3fee7f3a(,%eax,8)
c010198e:	c0 
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int cnt_idt = sizeof(idt) / sizeof(struct gatedesc);
	int i;
	for (i = 0; i < cnt_idt; i++)
c010198f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101993:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101996:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0101999:	0f 8c 31 ff ff ff    	jl     c01018d0 <idt_init+0x19>
c010199f:	c7 45 f4 80 75 11 c0 	movl   $0xc0117580,-0xc(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c01019a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01019a9:	0f 01 18             	lidtl  (%eax)
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
	lidt(&idt_pd);
}
c01019ac:	c9                   	leave  
c01019ad:	c3                   	ret    

c01019ae <trapname>:

static const char *
trapname(int trapno) {
c01019ae:	55                   	push   %ebp
c01019af:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c01019b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01019b4:	83 f8 13             	cmp    $0x13,%eax
c01019b7:	77 0c                	ja     c01019c5 <trapname+0x17>
        return excnames[trapno];
c01019b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01019bc:	8b 04 85 c0 66 10 c0 	mov    -0x3fef9940(,%eax,4),%eax
c01019c3:	eb 18                	jmp    c01019dd <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c01019c5:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01019c9:	7e 0d                	jle    c01019d8 <trapname+0x2a>
c01019cb:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01019cf:	7f 07                	jg     c01019d8 <trapname+0x2a>
        return "Hardware Interrupt";
c01019d1:	b8 7f 63 10 c0       	mov    $0xc010637f,%eax
c01019d6:	eb 05                	jmp    c01019dd <trapname+0x2f>
    }
    return "(unknown trap)";
c01019d8:	b8 92 63 10 c0       	mov    $0xc0106392,%eax
}
c01019dd:	5d                   	pop    %ebp
c01019de:	c3                   	ret    

c01019df <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01019df:	55                   	push   %ebp
c01019e0:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01019e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01019e5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01019e9:	66 83 f8 08          	cmp    $0x8,%ax
c01019ed:	0f 94 c0             	sete   %al
c01019f0:	0f b6 c0             	movzbl %al,%eax
}
c01019f3:	5d                   	pop    %ebp
c01019f4:	c3                   	ret    

c01019f5 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c01019f5:	55                   	push   %ebp
c01019f6:	89 e5                	mov    %esp,%ebp
c01019f8:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c01019fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01019fe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a02:	c7 04 24 d3 63 10 c0 	movl   $0xc01063d3,(%esp)
c0101a09:	e8 2e e9 ff ff       	call   c010033c <cprintf>
    print_regs(&tf->tf_regs);
c0101a0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a11:	89 04 24             	mov    %eax,(%esp)
c0101a14:	e8 a1 01 00 00       	call   c0101bba <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a19:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a1c:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101a20:	0f b7 c0             	movzwl %ax,%eax
c0101a23:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a27:	c7 04 24 e4 63 10 c0 	movl   $0xc01063e4,(%esp)
c0101a2e:	e8 09 e9 ff ff       	call   c010033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101a33:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a36:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101a3a:	0f b7 c0             	movzwl %ax,%eax
c0101a3d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a41:	c7 04 24 f7 63 10 c0 	movl   $0xc01063f7,(%esp)
c0101a48:	e8 ef e8 ff ff       	call   c010033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101a4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a50:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101a54:	0f b7 c0             	movzwl %ax,%eax
c0101a57:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a5b:	c7 04 24 0a 64 10 c0 	movl   $0xc010640a,(%esp)
c0101a62:	e8 d5 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101a67:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a6a:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101a6e:	0f b7 c0             	movzwl %ax,%eax
c0101a71:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a75:	c7 04 24 1d 64 10 c0 	movl   $0xc010641d,(%esp)
c0101a7c:	e8 bb e8 ff ff       	call   c010033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101a81:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a84:	8b 40 30             	mov    0x30(%eax),%eax
c0101a87:	89 04 24             	mov    %eax,(%esp)
c0101a8a:	e8 1f ff ff ff       	call   c01019ae <trapname>
c0101a8f:	8b 55 08             	mov    0x8(%ebp),%edx
c0101a92:	8b 52 30             	mov    0x30(%edx),%edx
c0101a95:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101a99:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101a9d:	c7 04 24 30 64 10 c0 	movl   $0xc0106430,(%esp)
c0101aa4:	e8 93 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101aa9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aac:	8b 40 34             	mov    0x34(%eax),%eax
c0101aaf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ab3:	c7 04 24 42 64 10 c0 	movl   $0xc0106442,(%esp)
c0101aba:	e8 7d e8 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101abf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ac2:	8b 40 38             	mov    0x38(%eax),%eax
c0101ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ac9:	c7 04 24 51 64 10 c0 	movl   $0xc0106451,(%esp)
c0101ad0:	e8 67 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101ad5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ad8:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101adc:	0f b7 c0             	movzwl %ax,%eax
c0101adf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ae3:	c7 04 24 60 64 10 c0 	movl   $0xc0106460,(%esp)
c0101aea:	e8 4d e8 ff ff       	call   c010033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101aef:	8b 45 08             	mov    0x8(%ebp),%eax
c0101af2:	8b 40 40             	mov    0x40(%eax),%eax
c0101af5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101af9:	c7 04 24 73 64 10 c0 	movl   $0xc0106473,(%esp)
c0101b00:	e8 37 e8 ff ff       	call   c010033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b05:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b0c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b13:	eb 3e                	jmp    c0101b53 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b15:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b18:	8b 50 40             	mov    0x40(%eax),%edx
c0101b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101b1e:	21 d0                	and    %edx,%eax
c0101b20:	85 c0                	test   %eax,%eax
c0101b22:	74 28                	je     c0101b4c <print_trapframe+0x157>
c0101b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b27:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b2e:	85 c0                	test   %eax,%eax
c0101b30:	74 1a                	je     c0101b4c <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b35:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b3c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b40:	c7 04 24 82 64 10 c0 	movl   $0xc0106482,(%esp)
c0101b47:	e8 f0 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b4c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101b50:	d1 65 f0             	shll   -0x10(%ebp)
c0101b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b56:	83 f8 17             	cmp    $0x17,%eax
c0101b59:	76 ba                	jbe    c0101b15 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101b5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b5e:	8b 40 40             	mov    0x40(%eax),%eax
c0101b61:	25 00 30 00 00       	and    $0x3000,%eax
c0101b66:	c1 e8 0c             	shr    $0xc,%eax
c0101b69:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b6d:	c7 04 24 86 64 10 c0 	movl   $0xc0106486,(%esp)
c0101b74:	e8 c3 e7 ff ff       	call   c010033c <cprintf>

    if (!trap_in_kernel(tf)) {
c0101b79:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b7c:	89 04 24             	mov    %eax,(%esp)
c0101b7f:	e8 5b fe ff ff       	call   c01019df <trap_in_kernel>
c0101b84:	85 c0                	test   %eax,%eax
c0101b86:	75 30                	jne    c0101bb8 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101b88:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b8b:	8b 40 44             	mov    0x44(%eax),%eax
c0101b8e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b92:	c7 04 24 8f 64 10 c0 	movl   $0xc010648f,(%esp)
c0101b99:	e8 9e e7 ff ff       	call   c010033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101b9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ba1:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101ba5:	0f b7 c0             	movzwl %ax,%eax
c0101ba8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bac:	c7 04 24 9e 64 10 c0 	movl   $0xc010649e,(%esp)
c0101bb3:	e8 84 e7 ff ff       	call   c010033c <cprintf>
    }
}
c0101bb8:	c9                   	leave  
c0101bb9:	c3                   	ret    

c0101bba <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101bba:	55                   	push   %ebp
c0101bbb:	89 e5                	mov    %esp,%ebp
c0101bbd:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101bc0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bc3:	8b 00                	mov    (%eax),%eax
c0101bc5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bc9:	c7 04 24 b1 64 10 c0 	movl   $0xc01064b1,(%esp)
c0101bd0:	e8 67 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101bd5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bd8:	8b 40 04             	mov    0x4(%eax),%eax
c0101bdb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bdf:	c7 04 24 c0 64 10 c0 	movl   $0xc01064c0,(%esp)
c0101be6:	e8 51 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101beb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bee:	8b 40 08             	mov    0x8(%eax),%eax
c0101bf1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bf5:	c7 04 24 cf 64 10 c0 	movl   $0xc01064cf,(%esp)
c0101bfc:	e8 3b e7 ff ff       	call   c010033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c01:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c04:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c07:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c0b:	c7 04 24 de 64 10 c0 	movl   $0xc01064de,(%esp)
c0101c12:	e8 25 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c17:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c1a:	8b 40 10             	mov    0x10(%eax),%eax
c0101c1d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c21:	c7 04 24 ed 64 10 c0 	movl   $0xc01064ed,(%esp)
c0101c28:	e8 0f e7 ff ff       	call   c010033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101c2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c30:	8b 40 14             	mov    0x14(%eax),%eax
c0101c33:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c37:	c7 04 24 fc 64 10 c0 	movl   $0xc01064fc,(%esp)
c0101c3e:	e8 f9 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101c43:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c46:	8b 40 18             	mov    0x18(%eax),%eax
c0101c49:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c4d:	c7 04 24 0b 65 10 c0 	movl   $0xc010650b,(%esp)
c0101c54:	e8 e3 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101c59:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c5c:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101c5f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c63:	c7 04 24 1a 65 10 c0 	movl   $0xc010651a,(%esp)
c0101c6a:	e8 cd e6 ff ff       	call   c010033c <cprintf>
}
c0101c6f:	c9                   	leave  
c0101c70:	c3                   	ret    

c0101c71 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101c71:	55                   	push   %ebp
c0101c72:	89 e5                	mov    %esp,%ebp
c0101c74:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101c77:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c7a:	8b 40 30             	mov    0x30(%eax),%eax
c0101c7d:	83 f8 2f             	cmp    $0x2f,%eax
c0101c80:	77 21                	ja     c0101ca3 <trap_dispatch+0x32>
c0101c82:	83 f8 2e             	cmp    $0x2e,%eax
c0101c85:	0f 83 0e 01 00 00    	jae    c0101d99 <trap_dispatch+0x128>
c0101c8b:	83 f8 21             	cmp    $0x21,%eax
c0101c8e:	0f 84 8b 00 00 00    	je     c0101d1f <trap_dispatch+0xae>
c0101c94:	83 f8 24             	cmp    $0x24,%eax
c0101c97:	74 60                	je     c0101cf9 <trap_dispatch+0x88>
c0101c99:	83 f8 20             	cmp    $0x20,%eax
c0101c9c:	74 16                	je     c0101cb4 <trap_dispatch+0x43>
c0101c9e:	e9 be 00 00 00       	jmp    c0101d61 <trap_dispatch+0xf0>
c0101ca3:	83 e8 78             	sub    $0x78,%eax
c0101ca6:	83 f8 01             	cmp    $0x1,%eax
c0101ca9:	0f 87 b2 00 00 00    	ja     c0101d61 <trap_dispatch+0xf0>
c0101caf:	e9 91 00 00 00       	jmp    c0101d45 <trap_dispatch+0xd4>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
		ticks ++;
c0101cb4:	a1 4c 89 11 c0       	mov    0xc011894c,%eax
c0101cb9:	83 c0 01             	add    $0x1,%eax
c0101cbc:	a3 4c 89 11 c0       	mov    %eax,0xc011894c
		if (ticks % TICK_NUM == 0)
c0101cc1:	8b 0d 4c 89 11 c0    	mov    0xc011894c,%ecx
c0101cc7:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101ccc:	89 c8                	mov    %ecx,%eax
c0101cce:	f7 e2                	mul    %edx
c0101cd0:	89 d0                	mov    %edx,%eax
c0101cd2:	c1 e8 05             	shr    $0x5,%eax
c0101cd5:	6b c0 64             	imul   $0x64,%eax,%eax
c0101cd8:	29 c1                	sub    %eax,%ecx
c0101cda:	89 c8                	mov    %ecx,%eax
c0101cdc:	85 c0                	test   %eax,%eax
c0101cde:	75 14                	jne    c0101cf4 <trap_dispatch+0x83>
		{
			print_ticks();
c0101ce0:	e8 90 fb ff ff       	call   c0101875 <print_ticks>
			ticks = 0;
c0101ce5:	c7 05 4c 89 11 c0 00 	movl   $0x0,0xc011894c
c0101cec:	00 00 00 
		}
		break;
c0101cef:	e9 a6 00 00 00       	jmp    c0101d9a <trap_dispatch+0x129>
c0101cf4:	e9 a1 00 00 00       	jmp    c0101d9a <trap_dispatch+0x129>

    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101cf9:	e8 3b f9 ff ff       	call   c0101639 <cons_getc>
c0101cfe:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d01:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d05:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d09:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d0d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d11:	c7 04 24 29 65 10 c0 	movl   $0xc0106529,(%esp)
c0101d18:	e8 1f e6 ff ff       	call   c010033c <cprintf>
        break;
c0101d1d:	eb 7b                	jmp    c0101d9a <trap_dispatch+0x129>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101d1f:	e8 15 f9 ff ff       	call   c0101639 <cons_getc>
c0101d24:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101d27:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d2b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d2f:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d33:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d37:	c7 04 24 3b 65 10 c0 	movl   $0xc010653b,(%esp)
c0101d3e:	e8 f9 e5 ff ff       	call   c010033c <cprintf>
        break;
c0101d43:	eb 55                	jmp    c0101d9a <trap_dispatch+0x129>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101d45:	c7 44 24 08 4a 65 10 	movl   $0xc010654a,0x8(%esp)
c0101d4c:	c0 
c0101d4d:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
c0101d54:	00 
c0101d55:	c7 04 24 6e 63 10 c0 	movl   $0xc010636e,(%esp)
c0101d5c:	e8 6a ef ff ff       	call   c0100ccb <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101d61:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d64:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101d68:	0f b7 c0             	movzwl %ax,%eax
c0101d6b:	83 e0 03             	and    $0x3,%eax
c0101d6e:	85 c0                	test   %eax,%eax
c0101d70:	75 28                	jne    c0101d9a <trap_dispatch+0x129>
            print_trapframe(tf);
c0101d72:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d75:	89 04 24             	mov    %eax,(%esp)
c0101d78:	e8 78 fc ff ff       	call   c01019f5 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101d7d:	c7 44 24 08 5a 65 10 	movl   $0xc010655a,0x8(%esp)
c0101d84:	c0 
c0101d85:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0101d8c:	00 
c0101d8d:	c7 04 24 6e 63 10 c0 	movl   $0xc010636e,(%esp)
c0101d94:	e8 32 ef ff ff       	call   c0100ccb <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101d99:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101d9a:	c9                   	leave  
c0101d9b:	c3                   	ret    

c0101d9c <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101d9c:	55                   	push   %ebp
c0101d9d:	89 e5                	mov    %esp,%ebp
c0101d9f:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101da2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101da5:	89 04 24             	mov    %eax,(%esp)
c0101da8:	e8 c4 fe ff ff       	call   c0101c71 <trap_dispatch>
}
c0101dad:	c9                   	leave  
c0101dae:	c3                   	ret    

c0101daf <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101daf:	1e                   	push   %ds
    pushl %es
c0101db0:	06                   	push   %es
    pushl %fs
c0101db1:	0f a0                	push   %fs
    pushl %gs
c0101db3:	0f a8                	push   %gs
    pushal
c0101db5:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101db6:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101dbb:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101dbd:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101dbf:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101dc0:	e8 d7 ff ff ff       	call   c0101d9c <trap>

    # pop the pushed stack pointer
    popl %esp
c0101dc5:	5c                   	pop    %esp

c0101dc6 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101dc6:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101dc7:	0f a9                	pop    %gs
    popl %fs
c0101dc9:	0f a1                	pop    %fs
    popl %es
c0101dcb:	07                   	pop    %es
    popl %ds
c0101dcc:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101dcd:	83 c4 08             	add    $0x8,%esp
    iret
c0101dd0:	cf                   	iret   

c0101dd1 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101dd1:	6a 00                	push   $0x0
  pushl $0
c0101dd3:	6a 00                	push   $0x0
  jmp __alltraps
c0101dd5:	e9 d5 ff ff ff       	jmp    c0101daf <__alltraps>

c0101dda <vector1>:
.globl vector1
vector1:
  pushl $0
c0101dda:	6a 00                	push   $0x0
  pushl $1
c0101ddc:	6a 01                	push   $0x1
  jmp __alltraps
c0101dde:	e9 cc ff ff ff       	jmp    c0101daf <__alltraps>

c0101de3 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101de3:	6a 00                	push   $0x0
  pushl $2
c0101de5:	6a 02                	push   $0x2
  jmp __alltraps
c0101de7:	e9 c3 ff ff ff       	jmp    c0101daf <__alltraps>

c0101dec <vector3>:
.globl vector3
vector3:
  pushl $0
c0101dec:	6a 00                	push   $0x0
  pushl $3
c0101dee:	6a 03                	push   $0x3
  jmp __alltraps
c0101df0:	e9 ba ff ff ff       	jmp    c0101daf <__alltraps>

c0101df5 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101df5:	6a 00                	push   $0x0
  pushl $4
c0101df7:	6a 04                	push   $0x4
  jmp __alltraps
c0101df9:	e9 b1 ff ff ff       	jmp    c0101daf <__alltraps>

c0101dfe <vector5>:
.globl vector5
vector5:
  pushl $0
c0101dfe:	6a 00                	push   $0x0
  pushl $5
c0101e00:	6a 05                	push   $0x5
  jmp __alltraps
c0101e02:	e9 a8 ff ff ff       	jmp    c0101daf <__alltraps>

c0101e07 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101e07:	6a 00                	push   $0x0
  pushl $6
c0101e09:	6a 06                	push   $0x6
  jmp __alltraps
c0101e0b:	e9 9f ff ff ff       	jmp    c0101daf <__alltraps>

c0101e10 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101e10:	6a 00                	push   $0x0
  pushl $7
c0101e12:	6a 07                	push   $0x7
  jmp __alltraps
c0101e14:	e9 96 ff ff ff       	jmp    c0101daf <__alltraps>

c0101e19 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101e19:	6a 08                	push   $0x8
  jmp __alltraps
c0101e1b:	e9 8f ff ff ff       	jmp    c0101daf <__alltraps>

c0101e20 <vector9>:
.globl vector9
vector9:
  pushl $9
c0101e20:	6a 09                	push   $0x9
  jmp __alltraps
c0101e22:	e9 88 ff ff ff       	jmp    c0101daf <__alltraps>

c0101e27 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101e27:	6a 0a                	push   $0xa
  jmp __alltraps
c0101e29:	e9 81 ff ff ff       	jmp    c0101daf <__alltraps>

c0101e2e <vector11>:
.globl vector11
vector11:
  pushl $11
c0101e2e:	6a 0b                	push   $0xb
  jmp __alltraps
c0101e30:	e9 7a ff ff ff       	jmp    c0101daf <__alltraps>

c0101e35 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101e35:	6a 0c                	push   $0xc
  jmp __alltraps
c0101e37:	e9 73 ff ff ff       	jmp    c0101daf <__alltraps>

c0101e3c <vector13>:
.globl vector13
vector13:
  pushl $13
c0101e3c:	6a 0d                	push   $0xd
  jmp __alltraps
c0101e3e:	e9 6c ff ff ff       	jmp    c0101daf <__alltraps>

c0101e43 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101e43:	6a 0e                	push   $0xe
  jmp __alltraps
c0101e45:	e9 65 ff ff ff       	jmp    c0101daf <__alltraps>

c0101e4a <vector15>:
.globl vector15
vector15:
  pushl $0
c0101e4a:	6a 00                	push   $0x0
  pushl $15
c0101e4c:	6a 0f                	push   $0xf
  jmp __alltraps
c0101e4e:	e9 5c ff ff ff       	jmp    c0101daf <__alltraps>

c0101e53 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101e53:	6a 00                	push   $0x0
  pushl $16
c0101e55:	6a 10                	push   $0x10
  jmp __alltraps
c0101e57:	e9 53 ff ff ff       	jmp    c0101daf <__alltraps>

c0101e5c <vector17>:
.globl vector17
vector17:
  pushl $17
c0101e5c:	6a 11                	push   $0x11
  jmp __alltraps
c0101e5e:	e9 4c ff ff ff       	jmp    c0101daf <__alltraps>

c0101e63 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101e63:	6a 00                	push   $0x0
  pushl $18
c0101e65:	6a 12                	push   $0x12
  jmp __alltraps
c0101e67:	e9 43 ff ff ff       	jmp    c0101daf <__alltraps>

c0101e6c <vector19>:
.globl vector19
vector19:
  pushl $0
c0101e6c:	6a 00                	push   $0x0
  pushl $19
c0101e6e:	6a 13                	push   $0x13
  jmp __alltraps
c0101e70:	e9 3a ff ff ff       	jmp    c0101daf <__alltraps>

c0101e75 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101e75:	6a 00                	push   $0x0
  pushl $20
c0101e77:	6a 14                	push   $0x14
  jmp __alltraps
c0101e79:	e9 31 ff ff ff       	jmp    c0101daf <__alltraps>

c0101e7e <vector21>:
.globl vector21
vector21:
  pushl $0
c0101e7e:	6a 00                	push   $0x0
  pushl $21
c0101e80:	6a 15                	push   $0x15
  jmp __alltraps
c0101e82:	e9 28 ff ff ff       	jmp    c0101daf <__alltraps>

c0101e87 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101e87:	6a 00                	push   $0x0
  pushl $22
c0101e89:	6a 16                	push   $0x16
  jmp __alltraps
c0101e8b:	e9 1f ff ff ff       	jmp    c0101daf <__alltraps>

c0101e90 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101e90:	6a 00                	push   $0x0
  pushl $23
c0101e92:	6a 17                	push   $0x17
  jmp __alltraps
c0101e94:	e9 16 ff ff ff       	jmp    c0101daf <__alltraps>

c0101e99 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101e99:	6a 00                	push   $0x0
  pushl $24
c0101e9b:	6a 18                	push   $0x18
  jmp __alltraps
c0101e9d:	e9 0d ff ff ff       	jmp    c0101daf <__alltraps>

c0101ea2 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101ea2:	6a 00                	push   $0x0
  pushl $25
c0101ea4:	6a 19                	push   $0x19
  jmp __alltraps
c0101ea6:	e9 04 ff ff ff       	jmp    c0101daf <__alltraps>

c0101eab <vector26>:
.globl vector26
vector26:
  pushl $0
c0101eab:	6a 00                	push   $0x0
  pushl $26
c0101ead:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101eaf:	e9 fb fe ff ff       	jmp    c0101daf <__alltraps>

c0101eb4 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101eb4:	6a 00                	push   $0x0
  pushl $27
c0101eb6:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101eb8:	e9 f2 fe ff ff       	jmp    c0101daf <__alltraps>

c0101ebd <vector28>:
.globl vector28
vector28:
  pushl $0
c0101ebd:	6a 00                	push   $0x0
  pushl $28
c0101ebf:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101ec1:	e9 e9 fe ff ff       	jmp    c0101daf <__alltraps>

c0101ec6 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101ec6:	6a 00                	push   $0x0
  pushl $29
c0101ec8:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101eca:	e9 e0 fe ff ff       	jmp    c0101daf <__alltraps>

c0101ecf <vector30>:
.globl vector30
vector30:
  pushl $0
c0101ecf:	6a 00                	push   $0x0
  pushl $30
c0101ed1:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101ed3:	e9 d7 fe ff ff       	jmp    c0101daf <__alltraps>

c0101ed8 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101ed8:	6a 00                	push   $0x0
  pushl $31
c0101eda:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101edc:	e9 ce fe ff ff       	jmp    c0101daf <__alltraps>

c0101ee1 <vector32>:
.globl vector32
vector32:
  pushl $0
c0101ee1:	6a 00                	push   $0x0
  pushl $32
c0101ee3:	6a 20                	push   $0x20
  jmp __alltraps
c0101ee5:	e9 c5 fe ff ff       	jmp    c0101daf <__alltraps>

c0101eea <vector33>:
.globl vector33
vector33:
  pushl $0
c0101eea:	6a 00                	push   $0x0
  pushl $33
c0101eec:	6a 21                	push   $0x21
  jmp __alltraps
c0101eee:	e9 bc fe ff ff       	jmp    c0101daf <__alltraps>

c0101ef3 <vector34>:
.globl vector34
vector34:
  pushl $0
c0101ef3:	6a 00                	push   $0x0
  pushl $34
c0101ef5:	6a 22                	push   $0x22
  jmp __alltraps
c0101ef7:	e9 b3 fe ff ff       	jmp    c0101daf <__alltraps>

c0101efc <vector35>:
.globl vector35
vector35:
  pushl $0
c0101efc:	6a 00                	push   $0x0
  pushl $35
c0101efe:	6a 23                	push   $0x23
  jmp __alltraps
c0101f00:	e9 aa fe ff ff       	jmp    c0101daf <__alltraps>

c0101f05 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101f05:	6a 00                	push   $0x0
  pushl $36
c0101f07:	6a 24                	push   $0x24
  jmp __alltraps
c0101f09:	e9 a1 fe ff ff       	jmp    c0101daf <__alltraps>

c0101f0e <vector37>:
.globl vector37
vector37:
  pushl $0
c0101f0e:	6a 00                	push   $0x0
  pushl $37
c0101f10:	6a 25                	push   $0x25
  jmp __alltraps
c0101f12:	e9 98 fe ff ff       	jmp    c0101daf <__alltraps>

c0101f17 <vector38>:
.globl vector38
vector38:
  pushl $0
c0101f17:	6a 00                	push   $0x0
  pushl $38
c0101f19:	6a 26                	push   $0x26
  jmp __alltraps
c0101f1b:	e9 8f fe ff ff       	jmp    c0101daf <__alltraps>

c0101f20 <vector39>:
.globl vector39
vector39:
  pushl $0
c0101f20:	6a 00                	push   $0x0
  pushl $39
c0101f22:	6a 27                	push   $0x27
  jmp __alltraps
c0101f24:	e9 86 fe ff ff       	jmp    c0101daf <__alltraps>

c0101f29 <vector40>:
.globl vector40
vector40:
  pushl $0
c0101f29:	6a 00                	push   $0x0
  pushl $40
c0101f2b:	6a 28                	push   $0x28
  jmp __alltraps
c0101f2d:	e9 7d fe ff ff       	jmp    c0101daf <__alltraps>

c0101f32 <vector41>:
.globl vector41
vector41:
  pushl $0
c0101f32:	6a 00                	push   $0x0
  pushl $41
c0101f34:	6a 29                	push   $0x29
  jmp __alltraps
c0101f36:	e9 74 fe ff ff       	jmp    c0101daf <__alltraps>

c0101f3b <vector42>:
.globl vector42
vector42:
  pushl $0
c0101f3b:	6a 00                	push   $0x0
  pushl $42
c0101f3d:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101f3f:	e9 6b fe ff ff       	jmp    c0101daf <__alltraps>

c0101f44 <vector43>:
.globl vector43
vector43:
  pushl $0
c0101f44:	6a 00                	push   $0x0
  pushl $43
c0101f46:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101f48:	e9 62 fe ff ff       	jmp    c0101daf <__alltraps>

c0101f4d <vector44>:
.globl vector44
vector44:
  pushl $0
c0101f4d:	6a 00                	push   $0x0
  pushl $44
c0101f4f:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101f51:	e9 59 fe ff ff       	jmp    c0101daf <__alltraps>

c0101f56 <vector45>:
.globl vector45
vector45:
  pushl $0
c0101f56:	6a 00                	push   $0x0
  pushl $45
c0101f58:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101f5a:	e9 50 fe ff ff       	jmp    c0101daf <__alltraps>

c0101f5f <vector46>:
.globl vector46
vector46:
  pushl $0
c0101f5f:	6a 00                	push   $0x0
  pushl $46
c0101f61:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101f63:	e9 47 fe ff ff       	jmp    c0101daf <__alltraps>

c0101f68 <vector47>:
.globl vector47
vector47:
  pushl $0
c0101f68:	6a 00                	push   $0x0
  pushl $47
c0101f6a:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101f6c:	e9 3e fe ff ff       	jmp    c0101daf <__alltraps>

c0101f71 <vector48>:
.globl vector48
vector48:
  pushl $0
c0101f71:	6a 00                	push   $0x0
  pushl $48
c0101f73:	6a 30                	push   $0x30
  jmp __alltraps
c0101f75:	e9 35 fe ff ff       	jmp    c0101daf <__alltraps>

c0101f7a <vector49>:
.globl vector49
vector49:
  pushl $0
c0101f7a:	6a 00                	push   $0x0
  pushl $49
c0101f7c:	6a 31                	push   $0x31
  jmp __alltraps
c0101f7e:	e9 2c fe ff ff       	jmp    c0101daf <__alltraps>

c0101f83 <vector50>:
.globl vector50
vector50:
  pushl $0
c0101f83:	6a 00                	push   $0x0
  pushl $50
c0101f85:	6a 32                	push   $0x32
  jmp __alltraps
c0101f87:	e9 23 fe ff ff       	jmp    c0101daf <__alltraps>

c0101f8c <vector51>:
.globl vector51
vector51:
  pushl $0
c0101f8c:	6a 00                	push   $0x0
  pushl $51
c0101f8e:	6a 33                	push   $0x33
  jmp __alltraps
c0101f90:	e9 1a fe ff ff       	jmp    c0101daf <__alltraps>

c0101f95 <vector52>:
.globl vector52
vector52:
  pushl $0
c0101f95:	6a 00                	push   $0x0
  pushl $52
c0101f97:	6a 34                	push   $0x34
  jmp __alltraps
c0101f99:	e9 11 fe ff ff       	jmp    c0101daf <__alltraps>

c0101f9e <vector53>:
.globl vector53
vector53:
  pushl $0
c0101f9e:	6a 00                	push   $0x0
  pushl $53
c0101fa0:	6a 35                	push   $0x35
  jmp __alltraps
c0101fa2:	e9 08 fe ff ff       	jmp    c0101daf <__alltraps>

c0101fa7 <vector54>:
.globl vector54
vector54:
  pushl $0
c0101fa7:	6a 00                	push   $0x0
  pushl $54
c0101fa9:	6a 36                	push   $0x36
  jmp __alltraps
c0101fab:	e9 ff fd ff ff       	jmp    c0101daf <__alltraps>

c0101fb0 <vector55>:
.globl vector55
vector55:
  pushl $0
c0101fb0:	6a 00                	push   $0x0
  pushl $55
c0101fb2:	6a 37                	push   $0x37
  jmp __alltraps
c0101fb4:	e9 f6 fd ff ff       	jmp    c0101daf <__alltraps>

c0101fb9 <vector56>:
.globl vector56
vector56:
  pushl $0
c0101fb9:	6a 00                	push   $0x0
  pushl $56
c0101fbb:	6a 38                	push   $0x38
  jmp __alltraps
c0101fbd:	e9 ed fd ff ff       	jmp    c0101daf <__alltraps>

c0101fc2 <vector57>:
.globl vector57
vector57:
  pushl $0
c0101fc2:	6a 00                	push   $0x0
  pushl $57
c0101fc4:	6a 39                	push   $0x39
  jmp __alltraps
c0101fc6:	e9 e4 fd ff ff       	jmp    c0101daf <__alltraps>

c0101fcb <vector58>:
.globl vector58
vector58:
  pushl $0
c0101fcb:	6a 00                	push   $0x0
  pushl $58
c0101fcd:	6a 3a                	push   $0x3a
  jmp __alltraps
c0101fcf:	e9 db fd ff ff       	jmp    c0101daf <__alltraps>

c0101fd4 <vector59>:
.globl vector59
vector59:
  pushl $0
c0101fd4:	6a 00                	push   $0x0
  pushl $59
c0101fd6:	6a 3b                	push   $0x3b
  jmp __alltraps
c0101fd8:	e9 d2 fd ff ff       	jmp    c0101daf <__alltraps>

c0101fdd <vector60>:
.globl vector60
vector60:
  pushl $0
c0101fdd:	6a 00                	push   $0x0
  pushl $60
c0101fdf:	6a 3c                	push   $0x3c
  jmp __alltraps
c0101fe1:	e9 c9 fd ff ff       	jmp    c0101daf <__alltraps>

c0101fe6 <vector61>:
.globl vector61
vector61:
  pushl $0
c0101fe6:	6a 00                	push   $0x0
  pushl $61
c0101fe8:	6a 3d                	push   $0x3d
  jmp __alltraps
c0101fea:	e9 c0 fd ff ff       	jmp    c0101daf <__alltraps>

c0101fef <vector62>:
.globl vector62
vector62:
  pushl $0
c0101fef:	6a 00                	push   $0x0
  pushl $62
c0101ff1:	6a 3e                	push   $0x3e
  jmp __alltraps
c0101ff3:	e9 b7 fd ff ff       	jmp    c0101daf <__alltraps>

c0101ff8 <vector63>:
.globl vector63
vector63:
  pushl $0
c0101ff8:	6a 00                	push   $0x0
  pushl $63
c0101ffa:	6a 3f                	push   $0x3f
  jmp __alltraps
c0101ffc:	e9 ae fd ff ff       	jmp    c0101daf <__alltraps>

c0102001 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102001:	6a 00                	push   $0x0
  pushl $64
c0102003:	6a 40                	push   $0x40
  jmp __alltraps
c0102005:	e9 a5 fd ff ff       	jmp    c0101daf <__alltraps>

c010200a <vector65>:
.globl vector65
vector65:
  pushl $0
c010200a:	6a 00                	push   $0x0
  pushl $65
c010200c:	6a 41                	push   $0x41
  jmp __alltraps
c010200e:	e9 9c fd ff ff       	jmp    c0101daf <__alltraps>

c0102013 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102013:	6a 00                	push   $0x0
  pushl $66
c0102015:	6a 42                	push   $0x42
  jmp __alltraps
c0102017:	e9 93 fd ff ff       	jmp    c0101daf <__alltraps>

c010201c <vector67>:
.globl vector67
vector67:
  pushl $0
c010201c:	6a 00                	push   $0x0
  pushl $67
c010201e:	6a 43                	push   $0x43
  jmp __alltraps
c0102020:	e9 8a fd ff ff       	jmp    c0101daf <__alltraps>

c0102025 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102025:	6a 00                	push   $0x0
  pushl $68
c0102027:	6a 44                	push   $0x44
  jmp __alltraps
c0102029:	e9 81 fd ff ff       	jmp    c0101daf <__alltraps>

c010202e <vector69>:
.globl vector69
vector69:
  pushl $0
c010202e:	6a 00                	push   $0x0
  pushl $69
c0102030:	6a 45                	push   $0x45
  jmp __alltraps
c0102032:	e9 78 fd ff ff       	jmp    c0101daf <__alltraps>

c0102037 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102037:	6a 00                	push   $0x0
  pushl $70
c0102039:	6a 46                	push   $0x46
  jmp __alltraps
c010203b:	e9 6f fd ff ff       	jmp    c0101daf <__alltraps>

c0102040 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102040:	6a 00                	push   $0x0
  pushl $71
c0102042:	6a 47                	push   $0x47
  jmp __alltraps
c0102044:	e9 66 fd ff ff       	jmp    c0101daf <__alltraps>

c0102049 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102049:	6a 00                	push   $0x0
  pushl $72
c010204b:	6a 48                	push   $0x48
  jmp __alltraps
c010204d:	e9 5d fd ff ff       	jmp    c0101daf <__alltraps>

c0102052 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102052:	6a 00                	push   $0x0
  pushl $73
c0102054:	6a 49                	push   $0x49
  jmp __alltraps
c0102056:	e9 54 fd ff ff       	jmp    c0101daf <__alltraps>

c010205b <vector74>:
.globl vector74
vector74:
  pushl $0
c010205b:	6a 00                	push   $0x0
  pushl $74
c010205d:	6a 4a                	push   $0x4a
  jmp __alltraps
c010205f:	e9 4b fd ff ff       	jmp    c0101daf <__alltraps>

c0102064 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102064:	6a 00                	push   $0x0
  pushl $75
c0102066:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102068:	e9 42 fd ff ff       	jmp    c0101daf <__alltraps>

c010206d <vector76>:
.globl vector76
vector76:
  pushl $0
c010206d:	6a 00                	push   $0x0
  pushl $76
c010206f:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102071:	e9 39 fd ff ff       	jmp    c0101daf <__alltraps>

c0102076 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102076:	6a 00                	push   $0x0
  pushl $77
c0102078:	6a 4d                	push   $0x4d
  jmp __alltraps
c010207a:	e9 30 fd ff ff       	jmp    c0101daf <__alltraps>

c010207f <vector78>:
.globl vector78
vector78:
  pushl $0
c010207f:	6a 00                	push   $0x0
  pushl $78
c0102081:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102083:	e9 27 fd ff ff       	jmp    c0101daf <__alltraps>

c0102088 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102088:	6a 00                	push   $0x0
  pushl $79
c010208a:	6a 4f                	push   $0x4f
  jmp __alltraps
c010208c:	e9 1e fd ff ff       	jmp    c0101daf <__alltraps>

c0102091 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102091:	6a 00                	push   $0x0
  pushl $80
c0102093:	6a 50                	push   $0x50
  jmp __alltraps
c0102095:	e9 15 fd ff ff       	jmp    c0101daf <__alltraps>

c010209a <vector81>:
.globl vector81
vector81:
  pushl $0
c010209a:	6a 00                	push   $0x0
  pushl $81
c010209c:	6a 51                	push   $0x51
  jmp __alltraps
c010209e:	e9 0c fd ff ff       	jmp    c0101daf <__alltraps>

c01020a3 <vector82>:
.globl vector82
vector82:
  pushl $0
c01020a3:	6a 00                	push   $0x0
  pushl $82
c01020a5:	6a 52                	push   $0x52
  jmp __alltraps
c01020a7:	e9 03 fd ff ff       	jmp    c0101daf <__alltraps>

c01020ac <vector83>:
.globl vector83
vector83:
  pushl $0
c01020ac:	6a 00                	push   $0x0
  pushl $83
c01020ae:	6a 53                	push   $0x53
  jmp __alltraps
c01020b0:	e9 fa fc ff ff       	jmp    c0101daf <__alltraps>

c01020b5 <vector84>:
.globl vector84
vector84:
  pushl $0
c01020b5:	6a 00                	push   $0x0
  pushl $84
c01020b7:	6a 54                	push   $0x54
  jmp __alltraps
c01020b9:	e9 f1 fc ff ff       	jmp    c0101daf <__alltraps>

c01020be <vector85>:
.globl vector85
vector85:
  pushl $0
c01020be:	6a 00                	push   $0x0
  pushl $85
c01020c0:	6a 55                	push   $0x55
  jmp __alltraps
c01020c2:	e9 e8 fc ff ff       	jmp    c0101daf <__alltraps>

c01020c7 <vector86>:
.globl vector86
vector86:
  pushl $0
c01020c7:	6a 00                	push   $0x0
  pushl $86
c01020c9:	6a 56                	push   $0x56
  jmp __alltraps
c01020cb:	e9 df fc ff ff       	jmp    c0101daf <__alltraps>

c01020d0 <vector87>:
.globl vector87
vector87:
  pushl $0
c01020d0:	6a 00                	push   $0x0
  pushl $87
c01020d2:	6a 57                	push   $0x57
  jmp __alltraps
c01020d4:	e9 d6 fc ff ff       	jmp    c0101daf <__alltraps>

c01020d9 <vector88>:
.globl vector88
vector88:
  pushl $0
c01020d9:	6a 00                	push   $0x0
  pushl $88
c01020db:	6a 58                	push   $0x58
  jmp __alltraps
c01020dd:	e9 cd fc ff ff       	jmp    c0101daf <__alltraps>

c01020e2 <vector89>:
.globl vector89
vector89:
  pushl $0
c01020e2:	6a 00                	push   $0x0
  pushl $89
c01020e4:	6a 59                	push   $0x59
  jmp __alltraps
c01020e6:	e9 c4 fc ff ff       	jmp    c0101daf <__alltraps>

c01020eb <vector90>:
.globl vector90
vector90:
  pushl $0
c01020eb:	6a 00                	push   $0x0
  pushl $90
c01020ed:	6a 5a                	push   $0x5a
  jmp __alltraps
c01020ef:	e9 bb fc ff ff       	jmp    c0101daf <__alltraps>

c01020f4 <vector91>:
.globl vector91
vector91:
  pushl $0
c01020f4:	6a 00                	push   $0x0
  pushl $91
c01020f6:	6a 5b                	push   $0x5b
  jmp __alltraps
c01020f8:	e9 b2 fc ff ff       	jmp    c0101daf <__alltraps>

c01020fd <vector92>:
.globl vector92
vector92:
  pushl $0
c01020fd:	6a 00                	push   $0x0
  pushl $92
c01020ff:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102101:	e9 a9 fc ff ff       	jmp    c0101daf <__alltraps>

c0102106 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102106:	6a 00                	push   $0x0
  pushl $93
c0102108:	6a 5d                	push   $0x5d
  jmp __alltraps
c010210a:	e9 a0 fc ff ff       	jmp    c0101daf <__alltraps>

c010210f <vector94>:
.globl vector94
vector94:
  pushl $0
c010210f:	6a 00                	push   $0x0
  pushl $94
c0102111:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102113:	e9 97 fc ff ff       	jmp    c0101daf <__alltraps>

c0102118 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102118:	6a 00                	push   $0x0
  pushl $95
c010211a:	6a 5f                	push   $0x5f
  jmp __alltraps
c010211c:	e9 8e fc ff ff       	jmp    c0101daf <__alltraps>

c0102121 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102121:	6a 00                	push   $0x0
  pushl $96
c0102123:	6a 60                	push   $0x60
  jmp __alltraps
c0102125:	e9 85 fc ff ff       	jmp    c0101daf <__alltraps>

c010212a <vector97>:
.globl vector97
vector97:
  pushl $0
c010212a:	6a 00                	push   $0x0
  pushl $97
c010212c:	6a 61                	push   $0x61
  jmp __alltraps
c010212e:	e9 7c fc ff ff       	jmp    c0101daf <__alltraps>

c0102133 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102133:	6a 00                	push   $0x0
  pushl $98
c0102135:	6a 62                	push   $0x62
  jmp __alltraps
c0102137:	e9 73 fc ff ff       	jmp    c0101daf <__alltraps>

c010213c <vector99>:
.globl vector99
vector99:
  pushl $0
c010213c:	6a 00                	push   $0x0
  pushl $99
c010213e:	6a 63                	push   $0x63
  jmp __alltraps
c0102140:	e9 6a fc ff ff       	jmp    c0101daf <__alltraps>

c0102145 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102145:	6a 00                	push   $0x0
  pushl $100
c0102147:	6a 64                	push   $0x64
  jmp __alltraps
c0102149:	e9 61 fc ff ff       	jmp    c0101daf <__alltraps>

c010214e <vector101>:
.globl vector101
vector101:
  pushl $0
c010214e:	6a 00                	push   $0x0
  pushl $101
c0102150:	6a 65                	push   $0x65
  jmp __alltraps
c0102152:	e9 58 fc ff ff       	jmp    c0101daf <__alltraps>

c0102157 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102157:	6a 00                	push   $0x0
  pushl $102
c0102159:	6a 66                	push   $0x66
  jmp __alltraps
c010215b:	e9 4f fc ff ff       	jmp    c0101daf <__alltraps>

c0102160 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102160:	6a 00                	push   $0x0
  pushl $103
c0102162:	6a 67                	push   $0x67
  jmp __alltraps
c0102164:	e9 46 fc ff ff       	jmp    c0101daf <__alltraps>

c0102169 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102169:	6a 00                	push   $0x0
  pushl $104
c010216b:	6a 68                	push   $0x68
  jmp __alltraps
c010216d:	e9 3d fc ff ff       	jmp    c0101daf <__alltraps>

c0102172 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102172:	6a 00                	push   $0x0
  pushl $105
c0102174:	6a 69                	push   $0x69
  jmp __alltraps
c0102176:	e9 34 fc ff ff       	jmp    c0101daf <__alltraps>

c010217b <vector106>:
.globl vector106
vector106:
  pushl $0
c010217b:	6a 00                	push   $0x0
  pushl $106
c010217d:	6a 6a                	push   $0x6a
  jmp __alltraps
c010217f:	e9 2b fc ff ff       	jmp    c0101daf <__alltraps>

c0102184 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102184:	6a 00                	push   $0x0
  pushl $107
c0102186:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102188:	e9 22 fc ff ff       	jmp    c0101daf <__alltraps>

c010218d <vector108>:
.globl vector108
vector108:
  pushl $0
c010218d:	6a 00                	push   $0x0
  pushl $108
c010218f:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102191:	e9 19 fc ff ff       	jmp    c0101daf <__alltraps>

c0102196 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102196:	6a 00                	push   $0x0
  pushl $109
c0102198:	6a 6d                	push   $0x6d
  jmp __alltraps
c010219a:	e9 10 fc ff ff       	jmp    c0101daf <__alltraps>

c010219f <vector110>:
.globl vector110
vector110:
  pushl $0
c010219f:	6a 00                	push   $0x0
  pushl $110
c01021a1:	6a 6e                	push   $0x6e
  jmp __alltraps
c01021a3:	e9 07 fc ff ff       	jmp    c0101daf <__alltraps>

c01021a8 <vector111>:
.globl vector111
vector111:
  pushl $0
c01021a8:	6a 00                	push   $0x0
  pushl $111
c01021aa:	6a 6f                	push   $0x6f
  jmp __alltraps
c01021ac:	e9 fe fb ff ff       	jmp    c0101daf <__alltraps>

c01021b1 <vector112>:
.globl vector112
vector112:
  pushl $0
c01021b1:	6a 00                	push   $0x0
  pushl $112
c01021b3:	6a 70                	push   $0x70
  jmp __alltraps
c01021b5:	e9 f5 fb ff ff       	jmp    c0101daf <__alltraps>

c01021ba <vector113>:
.globl vector113
vector113:
  pushl $0
c01021ba:	6a 00                	push   $0x0
  pushl $113
c01021bc:	6a 71                	push   $0x71
  jmp __alltraps
c01021be:	e9 ec fb ff ff       	jmp    c0101daf <__alltraps>

c01021c3 <vector114>:
.globl vector114
vector114:
  pushl $0
c01021c3:	6a 00                	push   $0x0
  pushl $114
c01021c5:	6a 72                	push   $0x72
  jmp __alltraps
c01021c7:	e9 e3 fb ff ff       	jmp    c0101daf <__alltraps>

c01021cc <vector115>:
.globl vector115
vector115:
  pushl $0
c01021cc:	6a 00                	push   $0x0
  pushl $115
c01021ce:	6a 73                	push   $0x73
  jmp __alltraps
c01021d0:	e9 da fb ff ff       	jmp    c0101daf <__alltraps>

c01021d5 <vector116>:
.globl vector116
vector116:
  pushl $0
c01021d5:	6a 00                	push   $0x0
  pushl $116
c01021d7:	6a 74                	push   $0x74
  jmp __alltraps
c01021d9:	e9 d1 fb ff ff       	jmp    c0101daf <__alltraps>

c01021de <vector117>:
.globl vector117
vector117:
  pushl $0
c01021de:	6a 00                	push   $0x0
  pushl $117
c01021e0:	6a 75                	push   $0x75
  jmp __alltraps
c01021e2:	e9 c8 fb ff ff       	jmp    c0101daf <__alltraps>

c01021e7 <vector118>:
.globl vector118
vector118:
  pushl $0
c01021e7:	6a 00                	push   $0x0
  pushl $118
c01021e9:	6a 76                	push   $0x76
  jmp __alltraps
c01021eb:	e9 bf fb ff ff       	jmp    c0101daf <__alltraps>

c01021f0 <vector119>:
.globl vector119
vector119:
  pushl $0
c01021f0:	6a 00                	push   $0x0
  pushl $119
c01021f2:	6a 77                	push   $0x77
  jmp __alltraps
c01021f4:	e9 b6 fb ff ff       	jmp    c0101daf <__alltraps>

c01021f9 <vector120>:
.globl vector120
vector120:
  pushl $0
c01021f9:	6a 00                	push   $0x0
  pushl $120
c01021fb:	6a 78                	push   $0x78
  jmp __alltraps
c01021fd:	e9 ad fb ff ff       	jmp    c0101daf <__alltraps>

c0102202 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102202:	6a 00                	push   $0x0
  pushl $121
c0102204:	6a 79                	push   $0x79
  jmp __alltraps
c0102206:	e9 a4 fb ff ff       	jmp    c0101daf <__alltraps>

c010220b <vector122>:
.globl vector122
vector122:
  pushl $0
c010220b:	6a 00                	push   $0x0
  pushl $122
c010220d:	6a 7a                	push   $0x7a
  jmp __alltraps
c010220f:	e9 9b fb ff ff       	jmp    c0101daf <__alltraps>

c0102214 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102214:	6a 00                	push   $0x0
  pushl $123
c0102216:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102218:	e9 92 fb ff ff       	jmp    c0101daf <__alltraps>

c010221d <vector124>:
.globl vector124
vector124:
  pushl $0
c010221d:	6a 00                	push   $0x0
  pushl $124
c010221f:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102221:	e9 89 fb ff ff       	jmp    c0101daf <__alltraps>

c0102226 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102226:	6a 00                	push   $0x0
  pushl $125
c0102228:	6a 7d                	push   $0x7d
  jmp __alltraps
c010222a:	e9 80 fb ff ff       	jmp    c0101daf <__alltraps>

c010222f <vector126>:
.globl vector126
vector126:
  pushl $0
c010222f:	6a 00                	push   $0x0
  pushl $126
c0102231:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102233:	e9 77 fb ff ff       	jmp    c0101daf <__alltraps>

c0102238 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102238:	6a 00                	push   $0x0
  pushl $127
c010223a:	6a 7f                	push   $0x7f
  jmp __alltraps
c010223c:	e9 6e fb ff ff       	jmp    c0101daf <__alltraps>

c0102241 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102241:	6a 00                	push   $0x0
  pushl $128
c0102243:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102248:	e9 62 fb ff ff       	jmp    c0101daf <__alltraps>

c010224d <vector129>:
.globl vector129
vector129:
  pushl $0
c010224d:	6a 00                	push   $0x0
  pushl $129
c010224f:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102254:	e9 56 fb ff ff       	jmp    c0101daf <__alltraps>

c0102259 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102259:	6a 00                	push   $0x0
  pushl $130
c010225b:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102260:	e9 4a fb ff ff       	jmp    c0101daf <__alltraps>

c0102265 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102265:	6a 00                	push   $0x0
  pushl $131
c0102267:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c010226c:	e9 3e fb ff ff       	jmp    c0101daf <__alltraps>

c0102271 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102271:	6a 00                	push   $0x0
  pushl $132
c0102273:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102278:	e9 32 fb ff ff       	jmp    c0101daf <__alltraps>

c010227d <vector133>:
.globl vector133
vector133:
  pushl $0
c010227d:	6a 00                	push   $0x0
  pushl $133
c010227f:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102284:	e9 26 fb ff ff       	jmp    c0101daf <__alltraps>

c0102289 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102289:	6a 00                	push   $0x0
  pushl $134
c010228b:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102290:	e9 1a fb ff ff       	jmp    c0101daf <__alltraps>

c0102295 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102295:	6a 00                	push   $0x0
  pushl $135
c0102297:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c010229c:	e9 0e fb ff ff       	jmp    c0101daf <__alltraps>

c01022a1 <vector136>:
.globl vector136
vector136:
  pushl $0
c01022a1:	6a 00                	push   $0x0
  pushl $136
c01022a3:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c01022a8:	e9 02 fb ff ff       	jmp    c0101daf <__alltraps>

c01022ad <vector137>:
.globl vector137
vector137:
  pushl $0
c01022ad:	6a 00                	push   $0x0
  pushl $137
c01022af:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01022b4:	e9 f6 fa ff ff       	jmp    c0101daf <__alltraps>

c01022b9 <vector138>:
.globl vector138
vector138:
  pushl $0
c01022b9:	6a 00                	push   $0x0
  pushl $138
c01022bb:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c01022c0:	e9 ea fa ff ff       	jmp    c0101daf <__alltraps>

c01022c5 <vector139>:
.globl vector139
vector139:
  pushl $0
c01022c5:	6a 00                	push   $0x0
  pushl $139
c01022c7:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c01022cc:	e9 de fa ff ff       	jmp    c0101daf <__alltraps>

c01022d1 <vector140>:
.globl vector140
vector140:
  pushl $0
c01022d1:	6a 00                	push   $0x0
  pushl $140
c01022d3:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01022d8:	e9 d2 fa ff ff       	jmp    c0101daf <__alltraps>

c01022dd <vector141>:
.globl vector141
vector141:
  pushl $0
c01022dd:	6a 00                	push   $0x0
  pushl $141
c01022df:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01022e4:	e9 c6 fa ff ff       	jmp    c0101daf <__alltraps>

c01022e9 <vector142>:
.globl vector142
vector142:
  pushl $0
c01022e9:	6a 00                	push   $0x0
  pushl $142
c01022eb:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01022f0:	e9 ba fa ff ff       	jmp    c0101daf <__alltraps>

c01022f5 <vector143>:
.globl vector143
vector143:
  pushl $0
c01022f5:	6a 00                	push   $0x0
  pushl $143
c01022f7:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01022fc:	e9 ae fa ff ff       	jmp    c0101daf <__alltraps>

c0102301 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102301:	6a 00                	push   $0x0
  pushl $144
c0102303:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102308:	e9 a2 fa ff ff       	jmp    c0101daf <__alltraps>

c010230d <vector145>:
.globl vector145
vector145:
  pushl $0
c010230d:	6a 00                	push   $0x0
  pushl $145
c010230f:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102314:	e9 96 fa ff ff       	jmp    c0101daf <__alltraps>

c0102319 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102319:	6a 00                	push   $0x0
  pushl $146
c010231b:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102320:	e9 8a fa ff ff       	jmp    c0101daf <__alltraps>

c0102325 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102325:	6a 00                	push   $0x0
  pushl $147
c0102327:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c010232c:	e9 7e fa ff ff       	jmp    c0101daf <__alltraps>

c0102331 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102331:	6a 00                	push   $0x0
  pushl $148
c0102333:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102338:	e9 72 fa ff ff       	jmp    c0101daf <__alltraps>

c010233d <vector149>:
.globl vector149
vector149:
  pushl $0
c010233d:	6a 00                	push   $0x0
  pushl $149
c010233f:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102344:	e9 66 fa ff ff       	jmp    c0101daf <__alltraps>

c0102349 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102349:	6a 00                	push   $0x0
  pushl $150
c010234b:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102350:	e9 5a fa ff ff       	jmp    c0101daf <__alltraps>

c0102355 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102355:	6a 00                	push   $0x0
  pushl $151
c0102357:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c010235c:	e9 4e fa ff ff       	jmp    c0101daf <__alltraps>

c0102361 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102361:	6a 00                	push   $0x0
  pushl $152
c0102363:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102368:	e9 42 fa ff ff       	jmp    c0101daf <__alltraps>

c010236d <vector153>:
.globl vector153
vector153:
  pushl $0
c010236d:	6a 00                	push   $0x0
  pushl $153
c010236f:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102374:	e9 36 fa ff ff       	jmp    c0101daf <__alltraps>

c0102379 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102379:	6a 00                	push   $0x0
  pushl $154
c010237b:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102380:	e9 2a fa ff ff       	jmp    c0101daf <__alltraps>

c0102385 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102385:	6a 00                	push   $0x0
  pushl $155
c0102387:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c010238c:	e9 1e fa ff ff       	jmp    c0101daf <__alltraps>

c0102391 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102391:	6a 00                	push   $0x0
  pushl $156
c0102393:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102398:	e9 12 fa ff ff       	jmp    c0101daf <__alltraps>

c010239d <vector157>:
.globl vector157
vector157:
  pushl $0
c010239d:	6a 00                	push   $0x0
  pushl $157
c010239f:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c01023a4:	e9 06 fa ff ff       	jmp    c0101daf <__alltraps>

c01023a9 <vector158>:
.globl vector158
vector158:
  pushl $0
c01023a9:	6a 00                	push   $0x0
  pushl $158
c01023ab:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c01023b0:	e9 fa f9 ff ff       	jmp    c0101daf <__alltraps>

c01023b5 <vector159>:
.globl vector159
vector159:
  pushl $0
c01023b5:	6a 00                	push   $0x0
  pushl $159
c01023b7:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c01023bc:	e9 ee f9 ff ff       	jmp    c0101daf <__alltraps>

c01023c1 <vector160>:
.globl vector160
vector160:
  pushl $0
c01023c1:	6a 00                	push   $0x0
  pushl $160
c01023c3:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c01023c8:	e9 e2 f9 ff ff       	jmp    c0101daf <__alltraps>

c01023cd <vector161>:
.globl vector161
vector161:
  pushl $0
c01023cd:	6a 00                	push   $0x0
  pushl $161
c01023cf:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01023d4:	e9 d6 f9 ff ff       	jmp    c0101daf <__alltraps>

c01023d9 <vector162>:
.globl vector162
vector162:
  pushl $0
c01023d9:	6a 00                	push   $0x0
  pushl $162
c01023db:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01023e0:	e9 ca f9 ff ff       	jmp    c0101daf <__alltraps>

c01023e5 <vector163>:
.globl vector163
vector163:
  pushl $0
c01023e5:	6a 00                	push   $0x0
  pushl $163
c01023e7:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01023ec:	e9 be f9 ff ff       	jmp    c0101daf <__alltraps>

c01023f1 <vector164>:
.globl vector164
vector164:
  pushl $0
c01023f1:	6a 00                	push   $0x0
  pushl $164
c01023f3:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01023f8:	e9 b2 f9 ff ff       	jmp    c0101daf <__alltraps>

c01023fd <vector165>:
.globl vector165
vector165:
  pushl $0
c01023fd:	6a 00                	push   $0x0
  pushl $165
c01023ff:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102404:	e9 a6 f9 ff ff       	jmp    c0101daf <__alltraps>

c0102409 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102409:	6a 00                	push   $0x0
  pushl $166
c010240b:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102410:	e9 9a f9 ff ff       	jmp    c0101daf <__alltraps>

c0102415 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102415:	6a 00                	push   $0x0
  pushl $167
c0102417:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c010241c:	e9 8e f9 ff ff       	jmp    c0101daf <__alltraps>

c0102421 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102421:	6a 00                	push   $0x0
  pushl $168
c0102423:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102428:	e9 82 f9 ff ff       	jmp    c0101daf <__alltraps>

c010242d <vector169>:
.globl vector169
vector169:
  pushl $0
c010242d:	6a 00                	push   $0x0
  pushl $169
c010242f:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102434:	e9 76 f9 ff ff       	jmp    c0101daf <__alltraps>

c0102439 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102439:	6a 00                	push   $0x0
  pushl $170
c010243b:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102440:	e9 6a f9 ff ff       	jmp    c0101daf <__alltraps>

c0102445 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102445:	6a 00                	push   $0x0
  pushl $171
c0102447:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c010244c:	e9 5e f9 ff ff       	jmp    c0101daf <__alltraps>

c0102451 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102451:	6a 00                	push   $0x0
  pushl $172
c0102453:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102458:	e9 52 f9 ff ff       	jmp    c0101daf <__alltraps>

c010245d <vector173>:
.globl vector173
vector173:
  pushl $0
c010245d:	6a 00                	push   $0x0
  pushl $173
c010245f:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102464:	e9 46 f9 ff ff       	jmp    c0101daf <__alltraps>

c0102469 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102469:	6a 00                	push   $0x0
  pushl $174
c010246b:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102470:	e9 3a f9 ff ff       	jmp    c0101daf <__alltraps>

c0102475 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102475:	6a 00                	push   $0x0
  pushl $175
c0102477:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c010247c:	e9 2e f9 ff ff       	jmp    c0101daf <__alltraps>

c0102481 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102481:	6a 00                	push   $0x0
  pushl $176
c0102483:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102488:	e9 22 f9 ff ff       	jmp    c0101daf <__alltraps>

c010248d <vector177>:
.globl vector177
vector177:
  pushl $0
c010248d:	6a 00                	push   $0x0
  pushl $177
c010248f:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102494:	e9 16 f9 ff ff       	jmp    c0101daf <__alltraps>

c0102499 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102499:	6a 00                	push   $0x0
  pushl $178
c010249b:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c01024a0:	e9 0a f9 ff ff       	jmp    c0101daf <__alltraps>

c01024a5 <vector179>:
.globl vector179
vector179:
  pushl $0
c01024a5:	6a 00                	push   $0x0
  pushl $179
c01024a7:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c01024ac:	e9 fe f8 ff ff       	jmp    c0101daf <__alltraps>

c01024b1 <vector180>:
.globl vector180
vector180:
  pushl $0
c01024b1:	6a 00                	push   $0x0
  pushl $180
c01024b3:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01024b8:	e9 f2 f8 ff ff       	jmp    c0101daf <__alltraps>

c01024bd <vector181>:
.globl vector181
vector181:
  pushl $0
c01024bd:	6a 00                	push   $0x0
  pushl $181
c01024bf:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c01024c4:	e9 e6 f8 ff ff       	jmp    c0101daf <__alltraps>

c01024c9 <vector182>:
.globl vector182
vector182:
  pushl $0
c01024c9:	6a 00                	push   $0x0
  pushl $182
c01024cb:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c01024d0:	e9 da f8 ff ff       	jmp    c0101daf <__alltraps>

c01024d5 <vector183>:
.globl vector183
vector183:
  pushl $0
c01024d5:	6a 00                	push   $0x0
  pushl $183
c01024d7:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01024dc:	e9 ce f8 ff ff       	jmp    c0101daf <__alltraps>

c01024e1 <vector184>:
.globl vector184
vector184:
  pushl $0
c01024e1:	6a 00                	push   $0x0
  pushl $184
c01024e3:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01024e8:	e9 c2 f8 ff ff       	jmp    c0101daf <__alltraps>

c01024ed <vector185>:
.globl vector185
vector185:
  pushl $0
c01024ed:	6a 00                	push   $0x0
  pushl $185
c01024ef:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01024f4:	e9 b6 f8 ff ff       	jmp    c0101daf <__alltraps>

c01024f9 <vector186>:
.globl vector186
vector186:
  pushl $0
c01024f9:	6a 00                	push   $0x0
  pushl $186
c01024fb:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102500:	e9 aa f8 ff ff       	jmp    c0101daf <__alltraps>

c0102505 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102505:	6a 00                	push   $0x0
  pushl $187
c0102507:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c010250c:	e9 9e f8 ff ff       	jmp    c0101daf <__alltraps>

c0102511 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102511:	6a 00                	push   $0x0
  pushl $188
c0102513:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102518:	e9 92 f8 ff ff       	jmp    c0101daf <__alltraps>

c010251d <vector189>:
.globl vector189
vector189:
  pushl $0
c010251d:	6a 00                	push   $0x0
  pushl $189
c010251f:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102524:	e9 86 f8 ff ff       	jmp    c0101daf <__alltraps>

c0102529 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102529:	6a 00                	push   $0x0
  pushl $190
c010252b:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102530:	e9 7a f8 ff ff       	jmp    c0101daf <__alltraps>

c0102535 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102535:	6a 00                	push   $0x0
  pushl $191
c0102537:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c010253c:	e9 6e f8 ff ff       	jmp    c0101daf <__alltraps>

c0102541 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102541:	6a 00                	push   $0x0
  pushl $192
c0102543:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102548:	e9 62 f8 ff ff       	jmp    c0101daf <__alltraps>

c010254d <vector193>:
.globl vector193
vector193:
  pushl $0
c010254d:	6a 00                	push   $0x0
  pushl $193
c010254f:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102554:	e9 56 f8 ff ff       	jmp    c0101daf <__alltraps>

c0102559 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102559:	6a 00                	push   $0x0
  pushl $194
c010255b:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102560:	e9 4a f8 ff ff       	jmp    c0101daf <__alltraps>

c0102565 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102565:	6a 00                	push   $0x0
  pushl $195
c0102567:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c010256c:	e9 3e f8 ff ff       	jmp    c0101daf <__alltraps>

c0102571 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102571:	6a 00                	push   $0x0
  pushl $196
c0102573:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102578:	e9 32 f8 ff ff       	jmp    c0101daf <__alltraps>

c010257d <vector197>:
.globl vector197
vector197:
  pushl $0
c010257d:	6a 00                	push   $0x0
  pushl $197
c010257f:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102584:	e9 26 f8 ff ff       	jmp    c0101daf <__alltraps>

c0102589 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102589:	6a 00                	push   $0x0
  pushl $198
c010258b:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102590:	e9 1a f8 ff ff       	jmp    c0101daf <__alltraps>

c0102595 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102595:	6a 00                	push   $0x0
  pushl $199
c0102597:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c010259c:	e9 0e f8 ff ff       	jmp    c0101daf <__alltraps>

c01025a1 <vector200>:
.globl vector200
vector200:
  pushl $0
c01025a1:	6a 00                	push   $0x0
  pushl $200
c01025a3:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c01025a8:	e9 02 f8 ff ff       	jmp    c0101daf <__alltraps>

c01025ad <vector201>:
.globl vector201
vector201:
  pushl $0
c01025ad:	6a 00                	push   $0x0
  pushl $201
c01025af:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01025b4:	e9 f6 f7 ff ff       	jmp    c0101daf <__alltraps>

c01025b9 <vector202>:
.globl vector202
vector202:
  pushl $0
c01025b9:	6a 00                	push   $0x0
  pushl $202
c01025bb:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01025c0:	e9 ea f7 ff ff       	jmp    c0101daf <__alltraps>

c01025c5 <vector203>:
.globl vector203
vector203:
  pushl $0
c01025c5:	6a 00                	push   $0x0
  pushl $203
c01025c7:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01025cc:	e9 de f7 ff ff       	jmp    c0101daf <__alltraps>

c01025d1 <vector204>:
.globl vector204
vector204:
  pushl $0
c01025d1:	6a 00                	push   $0x0
  pushl $204
c01025d3:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01025d8:	e9 d2 f7 ff ff       	jmp    c0101daf <__alltraps>

c01025dd <vector205>:
.globl vector205
vector205:
  pushl $0
c01025dd:	6a 00                	push   $0x0
  pushl $205
c01025df:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01025e4:	e9 c6 f7 ff ff       	jmp    c0101daf <__alltraps>

c01025e9 <vector206>:
.globl vector206
vector206:
  pushl $0
c01025e9:	6a 00                	push   $0x0
  pushl $206
c01025eb:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01025f0:	e9 ba f7 ff ff       	jmp    c0101daf <__alltraps>

c01025f5 <vector207>:
.globl vector207
vector207:
  pushl $0
c01025f5:	6a 00                	push   $0x0
  pushl $207
c01025f7:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01025fc:	e9 ae f7 ff ff       	jmp    c0101daf <__alltraps>

c0102601 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102601:	6a 00                	push   $0x0
  pushl $208
c0102603:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102608:	e9 a2 f7 ff ff       	jmp    c0101daf <__alltraps>

c010260d <vector209>:
.globl vector209
vector209:
  pushl $0
c010260d:	6a 00                	push   $0x0
  pushl $209
c010260f:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102614:	e9 96 f7 ff ff       	jmp    c0101daf <__alltraps>

c0102619 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102619:	6a 00                	push   $0x0
  pushl $210
c010261b:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102620:	e9 8a f7 ff ff       	jmp    c0101daf <__alltraps>

c0102625 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102625:	6a 00                	push   $0x0
  pushl $211
c0102627:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c010262c:	e9 7e f7 ff ff       	jmp    c0101daf <__alltraps>

c0102631 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102631:	6a 00                	push   $0x0
  pushl $212
c0102633:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102638:	e9 72 f7 ff ff       	jmp    c0101daf <__alltraps>

c010263d <vector213>:
.globl vector213
vector213:
  pushl $0
c010263d:	6a 00                	push   $0x0
  pushl $213
c010263f:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102644:	e9 66 f7 ff ff       	jmp    c0101daf <__alltraps>

c0102649 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102649:	6a 00                	push   $0x0
  pushl $214
c010264b:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102650:	e9 5a f7 ff ff       	jmp    c0101daf <__alltraps>

c0102655 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102655:	6a 00                	push   $0x0
  pushl $215
c0102657:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c010265c:	e9 4e f7 ff ff       	jmp    c0101daf <__alltraps>

c0102661 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102661:	6a 00                	push   $0x0
  pushl $216
c0102663:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102668:	e9 42 f7 ff ff       	jmp    c0101daf <__alltraps>

c010266d <vector217>:
.globl vector217
vector217:
  pushl $0
c010266d:	6a 00                	push   $0x0
  pushl $217
c010266f:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102674:	e9 36 f7 ff ff       	jmp    c0101daf <__alltraps>

c0102679 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102679:	6a 00                	push   $0x0
  pushl $218
c010267b:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102680:	e9 2a f7 ff ff       	jmp    c0101daf <__alltraps>

c0102685 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102685:	6a 00                	push   $0x0
  pushl $219
c0102687:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010268c:	e9 1e f7 ff ff       	jmp    c0101daf <__alltraps>

c0102691 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102691:	6a 00                	push   $0x0
  pushl $220
c0102693:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102698:	e9 12 f7 ff ff       	jmp    c0101daf <__alltraps>

c010269d <vector221>:
.globl vector221
vector221:
  pushl $0
c010269d:	6a 00                	push   $0x0
  pushl $221
c010269f:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01026a4:	e9 06 f7 ff ff       	jmp    c0101daf <__alltraps>

c01026a9 <vector222>:
.globl vector222
vector222:
  pushl $0
c01026a9:	6a 00                	push   $0x0
  pushl $222
c01026ab:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01026b0:	e9 fa f6 ff ff       	jmp    c0101daf <__alltraps>

c01026b5 <vector223>:
.globl vector223
vector223:
  pushl $0
c01026b5:	6a 00                	push   $0x0
  pushl $223
c01026b7:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01026bc:	e9 ee f6 ff ff       	jmp    c0101daf <__alltraps>

c01026c1 <vector224>:
.globl vector224
vector224:
  pushl $0
c01026c1:	6a 00                	push   $0x0
  pushl $224
c01026c3:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01026c8:	e9 e2 f6 ff ff       	jmp    c0101daf <__alltraps>

c01026cd <vector225>:
.globl vector225
vector225:
  pushl $0
c01026cd:	6a 00                	push   $0x0
  pushl $225
c01026cf:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01026d4:	e9 d6 f6 ff ff       	jmp    c0101daf <__alltraps>

c01026d9 <vector226>:
.globl vector226
vector226:
  pushl $0
c01026d9:	6a 00                	push   $0x0
  pushl $226
c01026db:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01026e0:	e9 ca f6 ff ff       	jmp    c0101daf <__alltraps>

c01026e5 <vector227>:
.globl vector227
vector227:
  pushl $0
c01026e5:	6a 00                	push   $0x0
  pushl $227
c01026e7:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01026ec:	e9 be f6 ff ff       	jmp    c0101daf <__alltraps>

c01026f1 <vector228>:
.globl vector228
vector228:
  pushl $0
c01026f1:	6a 00                	push   $0x0
  pushl $228
c01026f3:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01026f8:	e9 b2 f6 ff ff       	jmp    c0101daf <__alltraps>

c01026fd <vector229>:
.globl vector229
vector229:
  pushl $0
c01026fd:	6a 00                	push   $0x0
  pushl $229
c01026ff:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102704:	e9 a6 f6 ff ff       	jmp    c0101daf <__alltraps>

c0102709 <vector230>:
.globl vector230
vector230:
  pushl $0
c0102709:	6a 00                	push   $0x0
  pushl $230
c010270b:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102710:	e9 9a f6 ff ff       	jmp    c0101daf <__alltraps>

c0102715 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102715:	6a 00                	push   $0x0
  pushl $231
c0102717:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010271c:	e9 8e f6 ff ff       	jmp    c0101daf <__alltraps>

c0102721 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102721:	6a 00                	push   $0x0
  pushl $232
c0102723:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102728:	e9 82 f6 ff ff       	jmp    c0101daf <__alltraps>

c010272d <vector233>:
.globl vector233
vector233:
  pushl $0
c010272d:	6a 00                	push   $0x0
  pushl $233
c010272f:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102734:	e9 76 f6 ff ff       	jmp    c0101daf <__alltraps>

c0102739 <vector234>:
.globl vector234
vector234:
  pushl $0
c0102739:	6a 00                	push   $0x0
  pushl $234
c010273b:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102740:	e9 6a f6 ff ff       	jmp    c0101daf <__alltraps>

c0102745 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102745:	6a 00                	push   $0x0
  pushl $235
c0102747:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c010274c:	e9 5e f6 ff ff       	jmp    c0101daf <__alltraps>

c0102751 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102751:	6a 00                	push   $0x0
  pushl $236
c0102753:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102758:	e9 52 f6 ff ff       	jmp    c0101daf <__alltraps>

c010275d <vector237>:
.globl vector237
vector237:
  pushl $0
c010275d:	6a 00                	push   $0x0
  pushl $237
c010275f:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102764:	e9 46 f6 ff ff       	jmp    c0101daf <__alltraps>

c0102769 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102769:	6a 00                	push   $0x0
  pushl $238
c010276b:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102770:	e9 3a f6 ff ff       	jmp    c0101daf <__alltraps>

c0102775 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102775:	6a 00                	push   $0x0
  pushl $239
c0102777:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010277c:	e9 2e f6 ff ff       	jmp    c0101daf <__alltraps>

c0102781 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102781:	6a 00                	push   $0x0
  pushl $240
c0102783:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102788:	e9 22 f6 ff ff       	jmp    c0101daf <__alltraps>

c010278d <vector241>:
.globl vector241
vector241:
  pushl $0
c010278d:	6a 00                	push   $0x0
  pushl $241
c010278f:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102794:	e9 16 f6 ff ff       	jmp    c0101daf <__alltraps>

c0102799 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102799:	6a 00                	push   $0x0
  pushl $242
c010279b:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01027a0:	e9 0a f6 ff ff       	jmp    c0101daf <__alltraps>

c01027a5 <vector243>:
.globl vector243
vector243:
  pushl $0
c01027a5:	6a 00                	push   $0x0
  pushl $243
c01027a7:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01027ac:	e9 fe f5 ff ff       	jmp    c0101daf <__alltraps>

c01027b1 <vector244>:
.globl vector244
vector244:
  pushl $0
c01027b1:	6a 00                	push   $0x0
  pushl $244
c01027b3:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01027b8:	e9 f2 f5 ff ff       	jmp    c0101daf <__alltraps>

c01027bd <vector245>:
.globl vector245
vector245:
  pushl $0
c01027bd:	6a 00                	push   $0x0
  pushl $245
c01027bf:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01027c4:	e9 e6 f5 ff ff       	jmp    c0101daf <__alltraps>

c01027c9 <vector246>:
.globl vector246
vector246:
  pushl $0
c01027c9:	6a 00                	push   $0x0
  pushl $246
c01027cb:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01027d0:	e9 da f5 ff ff       	jmp    c0101daf <__alltraps>

c01027d5 <vector247>:
.globl vector247
vector247:
  pushl $0
c01027d5:	6a 00                	push   $0x0
  pushl $247
c01027d7:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01027dc:	e9 ce f5 ff ff       	jmp    c0101daf <__alltraps>

c01027e1 <vector248>:
.globl vector248
vector248:
  pushl $0
c01027e1:	6a 00                	push   $0x0
  pushl $248
c01027e3:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01027e8:	e9 c2 f5 ff ff       	jmp    c0101daf <__alltraps>

c01027ed <vector249>:
.globl vector249
vector249:
  pushl $0
c01027ed:	6a 00                	push   $0x0
  pushl $249
c01027ef:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01027f4:	e9 b6 f5 ff ff       	jmp    c0101daf <__alltraps>

c01027f9 <vector250>:
.globl vector250
vector250:
  pushl $0
c01027f9:	6a 00                	push   $0x0
  pushl $250
c01027fb:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102800:	e9 aa f5 ff ff       	jmp    c0101daf <__alltraps>

c0102805 <vector251>:
.globl vector251
vector251:
  pushl $0
c0102805:	6a 00                	push   $0x0
  pushl $251
c0102807:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c010280c:	e9 9e f5 ff ff       	jmp    c0101daf <__alltraps>

c0102811 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102811:	6a 00                	push   $0x0
  pushl $252
c0102813:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102818:	e9 92 f5 ff ff       	jmp    c0101daf <__alltraps>

c010281d <vector253>:
.globl vector253
vector253:
  pushl $0
c010281d:	6a 00                	push   $0x0
  pushl $253
c010281f:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102824:	e9 86 f5 ff ff       	jmp    c0101daf <__alltraps>

c0102829 <vector254>:
.globl vector254
vector254:
  pushl $0
c0102829:	6a 00                	push   $0x0
  pushl $254
c010282b:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102830:	e9 7a f5 ff ff       	jmp    c0101daf <__alltraps>

c0102835 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102835:	6a 00                	push   $0x0
  pushl $255
c0102837:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c010283c:	e9 6e f5 ff ff       	jmp    c0101daf <__alltraps>

c0102841 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102841:	55                   	push   %ebp
c0102842:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102844:	8b 55 08             	mov    0x8(%ebp),%edx
c0102847:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c010284c:	29 c2                	sub    %eax,%edx
c010284e:	89 d0                	mov    %edx,%eax
c0102850:	c1 f8 02             	sar    $0x2,%eax
c0102853:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102859:	5d                   	pop    %ebp
c010285a:	c3                   	ret    

c010285b <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010285b:	55                   	push   %ebp
c010285c:	89 e5                	mov    %esp,%ebp
c010285e:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102861:	8b 45 08             	mov    0x8(%ebp),%eax
c0102864:	89 04 24             	mov    %eax,(%esp)
c0102867:	e8 d5 ff ff ff       	call   c0102841 <page2ppn>
c010286c:	c1 e0 0c             	shl    $0xc,%eax
}
c010286f:	c9                   	leave  
c0102870:	c3                   	ret    

c0102871 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0102871:	55                   	push   %ebp
c0102872:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102874:	8b 45 08             	mov    0x8(%ebp),%eax
c0102877:	8b 00                	mov    (%eax),%eax
}
c0102879:	5d                   	pop    %ebp
c010287a:	c3                   	ret    

c010287b <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c010287b:	55                   	push   %ebp
c010287c:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010287e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102881:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102884:	89 10                	mov    %edx,(%eax)
}
c0102886:	5d                   	pop    %ebp
c0102887:	c3                   	ret    

c0102888 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0102888:	55                   	push   %ebp
c0102889:	89 e5                	mov    %esp,%ebp
c010288b:	83 ec 10             	sub    $0x10,%esp
c010288e:	c7 45 fc 50 89 11 c0 	movl   $0xc0118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0102895:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102898:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010289b:	89 50 04             	mov    %edx,0x4(%eax)
c010289e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01028a1:	8b 50 04             	mov    0x4(%eax),%edx
c01028a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01028a7:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c01028a9:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c01028b0:	00 00 00 
}
c01028b3:	c9                   	leave  
c01028b4:	c3                   	ret    

c01028b5 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c01028b5:	55                   	push   %ebp
c01028b6:	89 e5                	mov    %esp,%ebp
c01028b8:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c01028bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01028bf:	75 24                	jne    c01028e5 <default_init_memmap+0x30>
c01028c1:	c7 44 24 0c 10 67 10 	movl   $0xc0106710,0xc(%esp)
c01028c8:	c0 
c01028c9:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c01028d0:	c0 
c01028d1:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c01028d8:	00 
c01028d9:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c01028e0:	e8 e6 e3 ff ff       	call   c0100ccb <__panic>
    struct Page *p = base;
c01028e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01028e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01028eb:	eb 7d                	jmp    c010296a <default_init_memmap+0xb5>
        assert(PageReserved(p));
c01028ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028f0:	83 c0 04             	add    $0x4,%eax
c01028f3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01028fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01028fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102900:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102903:	0f a3 10             	bt     %edx,(%eax)
c0102906:	19 c0                	sbb    %eax,%eax
c0102908:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c010290b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010290f:	0f 95 c0             	setne  %al
c0102912:	0f b6 c0             	movzbl %al,%eax
c0102915:	85 c0                	test   %eax,%eax
c0102917:	75 24                	jne    c010293d <default_init_memmap+0x88>
c0102919:	c7 44 24 0c 41 67 10 	movl   $0xc0106741,0xc(%esp)
c0102920:	c0 
c0102921:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0102928:	c0 
c0102929:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c0102930:	00 
c0102931:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0102938:	e8 8e e3 ff ff       	call   c0100ccb <__panic>
        p->flags = p->property = 0;
c010293d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102940:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0102947:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010294a:	8b 50 08             	mov    0x8(%eax),%edx
c010294d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102950:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c0102953:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010295a:	00 
c010295b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010295e:	89 04 24             	mov    %eax,(%esp)
c0102961:	e8 15 ff ff ff       	call   c010287b <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0102966:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c010296a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010296d:	89 d0                	mov    %edx,%eax
c010296f:	c1 e0 02             	shl    $0x2,%eax
c0102972:	01 d0                	add    %edx,%eax
c0102974:	c1 e0 02             	shl    $0x2,%eax
c0102977:	89 c2                	mov    %eax,%edx
c0102979:	8b 45 08             	mov    0x8(%ebp),%eax
c010297c:	01 d0                	add    %edx,%eax
c010297e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102981:	0f 85 66 ff ff ff    	jne    c01028ed <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0102987:	8b 45 08             	mov    0x8(%ebp),%eax
c010298a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010298d:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102990:	8b 45 08             	mov    0x8(%ebp),%eax
c0102993:	83 c0 04             	add    $0x4,%eax
c0102996:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c010299d:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01029a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01029a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01029a6:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c01029a9:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c01029af:	8b 45 0c             	mov    0xc(%ebp),%eax
c01029b2:	01 d0                	add    %edx,%eax
c01029b4:	a3 58 89 11 c0       	mov    %eax,0xc0118958
    list_add(&free_list, &(base->page_link));
c01029b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01029bc:	83 c0 0c             	add    $0xc,%eax
c01029bf:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
c01029c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01029c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01029cc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01029cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01029d2:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01029d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01029d8:	8b 40 04             	mov    0x4(%eax),%eax
c01029db:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01029de:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01029e1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01029e4:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01029e7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01029ea:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01029ed:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01029f0:	89 10                	mov    %edx,(%eax)
c01029f2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01029f5:	8b 10                	mov    (%eax),%edx
c01029f7:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01029fa:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01029fd:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a00:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102a03:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102a06:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a09:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102a0c:	89 10                	mov    %edx,(%eax)
}
c0102a0e:	c9                   	leave  
c0102a0f:	c3                   	ret    

c0102a10 <default_alloc_pages>:
static struct Page *
default_alloc_pages(size_t n) {
c0102a10:	55                   	push   %ebp
c0102a11:	89 e5                	mov    %esp,%ebp
c0102a13:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0102a16:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102a1a:	75 24                	jne    c0102a40 <default_alloc_pages+0x30>
c0102a1c:	c7 44 24 0c 10 67 10 	movl   $0xc0106710,0xc(%esp)
c0102a23:	c0 
c0102a24:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0102a2b:	c0 
c0102a2c:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
c0102a33:	00 
c0102a34:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0102a3b:	e8 8b e2 ff ff       	call   c0100ccb <__panic>
    if (n > nr_free) {
c0102a40:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102a45:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102a48:	73 0a                	jae    c0102a54 <default_alloc_pages+0x44>
        return NULL;
c0102a4a:	b8 00 00 00 00       	mov    $0x0,%eax
c0102a4f:	e9 3d 01 00 00       	jmp    c0102b91 <default_alloc_pages+0x181>
    }
    struct Page *page = NULL;
c0102a54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0102a5b:	c7 45 f0 50 89 11 c0 	movl   $0xc0118950,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0102a62:	eb 1c                	jmp    c0102a80 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c0102a64:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102a67:	83 e8 0c             	sub    $0xc,%eax
c0102a6a:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c0102a6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102a70:	8b 40 08             	mov    0x8(%eax),%eax
c0102a73:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102a76:	72 08                	jb     c0102a80 <default_alloc_pages+0x70>
            page = p;
c0102a78:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102a7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0102a7e:	eb 18                	jmp    c0102a98 <default_alloc_pages+0x88>
c0102a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102a83:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102a86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102a89:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0102a8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102a8f:	81 7d f0 50 89 11 c0 	cmpl   $0xc0118950,-0x10(%ebp)
c0102a96:	75 cc                	jne    c0102a64 <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
c0102a98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102a9c:	0f 84 ec 00 00 00    	je     c0102b8e <default_alloc_pages+0x17e>
        if (page->property > n) {
c0102aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102aa5:	8b 40 08             	mov    0x8(%eax),%eax
c0102aa8:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102aab:	0f 86 8c 00 00 00    	jbe    c0102b3d <default_alloc_pages+0x12d>
            struct Page *p = page + n;
c0102ab1:	8b 55 08             	mov    0x8(%ebp),%edx
c0102ab4:	89 d0                	mov    %edx,%eax
c0102ab6:	c1 e0 02             	shl    $0x2,%eax
c0102ab9:	01 d0                	add    %edx,%eax
c0102abb:	c1 e0 02             	shl    $0x2,%eax
c0102abe:	89 c2                	mov    %eax,%edx
c0102ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ac3:	01 d0                	add    %edx,%eax
c0102ac5:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c0102ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102acb:	8b 40 08             	mov    0x8(%eax),%eax
c0102ace:	2b 45 08             	sub    0x8(%ebp),%eax
c0102ad1:	89 c2                	mov    %eax,%edx
c0102ad3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102ad6:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c0102ad9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102adc:	83 c0 04             	add    $0x4,%eax
c0102adf:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102ae6:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0102ae9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102aec:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102aef:	0f ab 10             	bts    %edx,(%eax)
            list_add_after(&(page->page_link), &(p->page_link));
c0102af2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102af5:	83 c0 0c             	add    $0xc,%eax
c0102af8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102afb:	83 c2 0c             	add    $0xc,%edx
c0102afe:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0102b01:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102b04:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102b07:	8b 40 04             	mov    0x4(%eax),%eax
c0102b0a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102b0d:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0102b10:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102b13:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0102b16:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102b19:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102b1c:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102b1f:	89 10                	mov    %edx,(%eax)
c0102b21:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102b24:	8b 10                	mov    (%eax),%edx
c0102b26:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102b29:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102b2c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102b2f:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102b32:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102b35:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102b38:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102b3b:	89 10                	mov    %edx,(%eax)
        }
        list_del(&(page->page_link));
c0102b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b40:	83 c0 0c             	add    $0xc,%eax
c0102b43:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102b46:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102b49:	8b 40 04             	mov    0x4(%eax),%eax
c0102b4c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102b4f:	8b 12                	mov    (%edx),%edx
c0102b51:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0102b54:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102b57:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102b5a:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102b5d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102b60:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102b63:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102b66:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
c0102b68:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102b6d:	2b 45 08             	sub    0x8(%ebp),%eax
c0102b70:	a3 58 89 11 c0       	mov    %eax,0xc0118958
        ClearPageProperty(page);
c0102b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b78:	83 c0 04             	add    $0x4,%eax
c0102b7b:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0102b82:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102b85:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102b88:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102b8b:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0102b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102b91:	c9                   	leave  
c0102b92:	c3                   	ret    

c0102b93 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102b93:	55                   	push   %ebp
c0102b94:	89 e5                	mov    %esp,%ebp
c0102b96:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c0102b9c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102ba0:	75 24                	jne    c0102bc6 <default_free_pages+0x33>
c0102ba2:	c7 44 24 0c 10 67 10 	movl   $0xc0106710,0xc(%esp)
c0102ba9:	c0 
c0102baa:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0102bb1:	c0 
c0102bb2:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c0102bb9:	00 
c0102bba:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0102bc1:	e8 05 e1 ff ff       	call   c0100ccb <__panic>
    struct Page *p = base;
c0102bc6:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102bcc:	e9 9d 00 00 00       	jmp    c0102c6e <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c0102bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bd4:	83 c0 04             	add    $0x4,%eax
c0102bd7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102bde:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102be1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102be4:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102be7:	0f a3 10             	bt     %edx,(%eax)
c0102bea:	19 c0                	sbb    %eax,%eax
c0102bec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0102bef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102bf3:	0f 95 c0             	setne  %al
c0102bf6:	0f b6 c0             	movzbl %al,%eax
c0102bf9:	85 c0                	test   %eax,%eax
c0102bfb:	75 2c                	jne    c0102c29 <default_free_pages+0x96>
c0102bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c00:	83 c0 04             	add    $0x4,%eax
c0102c03:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102c0a:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102c0d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102c10:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102c13:	0f a3 10             	bt     %edx,(%eax)
c0102c16:	19 c0                	sbb    %eax,%eax
c0102c18:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0102c1b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0102c1f:	0f 95 c0             	setne  %al
c0102c22:	0f b6 c0             	movzbl %al,%eax
c0102c25:	85 c0                	test   %eax,%eax
c0102c27:	74 24                	je     c0102c4d <default_free_pages+0xba>
c0102c29:	c7 44 24 0c 54 67 10 	movl   $0xc0106754,0xc(%esp)
c0102c30:	c0 
c0102c31:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0102c38:	c0 
c0102c39:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
c0102c40:	00 
c0102c41:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0102c48:	e8 7e e0 ff ff       	call   c0100ccb <__panic>
        p->flags = 0;
c0102c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c50:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0102c57:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102c5e:	00 
c0102c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c62:	89 04 24             	mov    %eax,(%esp)
c0102c65:	e8 11 fc ff ff       	call   c010287b <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0102c6a:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102c6e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c71:	89 d0                	mov    %edx,%eax
c0102c73:	c1 e0 02             	shl    $0x2,%eax
c0102c76:	01 d0                	add    %edx,%eax
c0102c78:	c1 e0 02             	shl    $0x2,%eax
c0102c7b:	89 c2                	mov    %eax,%edx
c0102c7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c80:	01 d0                	add    %edx,%eax
c0102c82:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102c85:	0f 85 46 ff ff ff    	jne    c0102bd1 <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0102c8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c8e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c91:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102c94:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c97:	83 c0 04             	add    $0x4,%eax
c0102c9a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0102ca1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102ca4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102ca7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102caa:	0f ab 10             	bts    %edx,(%eax)
c0102cad:	c7 45 cc 50 89 11 c0 	movl   $0xc0118950,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102cb4:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102cb7:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0102cba:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0102cbd:	e9 08 01 00 00       	jmp    c0102dca <default_free_pages+0x237>
        p = le2page(le, page_link);
c0102cc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102cc5:	83 e8 0c             	sub    $0xc,%eax
c0102cc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102ccb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102cce:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102cd1:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102cd4:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0102cd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
c0102cda:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cdd:	8b 50 08             	mov    0x8(%eax),%edx
c0102ce0:	89 d0                	mov    %edx,%eax
c0102ce2:	c1 e0 02             	shl    $0x2,%eax
c0102ce5:	01 d0                	add    %edx,%eax
c0102ce7:	c1 e0 02             	shl    $0x2,%eax
c0102cea:	89 c2                	mov    %eax,%edx
c0102cec:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cef:	01 d0                	add    %edx,%eax
c0102cf1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102cf4:	75 5a                	jne    c0102d50 <default_free_pages+0x1bd>
            base->property += p->property;
c0102cf6:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cf9:	8b 50 08             	mov    0x8(%eax),%edx
c0102cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cff:	8b 40 08             	mov    0x8(%eax),%eax
c0102d02:	01 c2                	add    %eax,%edx
c0102d04:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d07:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0102d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d0d:	83 c0 04             	add    $0x4,%eax
c0102d10:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0102d17:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102d1a:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102d1d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102d20:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0102d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d26:	83 c0 0c             	add    $0xc,%eax
c0102d29:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102d2c:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102d2f:	8b 40 04             	mov    0x4(%eax),%eax
c0102d32:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102d35:	8b 12                	mov    (%edx),%edx
c0102d37:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0102d3a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102d3d:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102d40:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102d43:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102d46:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102d49:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102d4c:	89 10                	mov    %edx,(%eax)
c0102d4e:	eb 7a                	jmp    c0102dca <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
c0102d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d53:	8b 50 08             	mov    0x8(%eax),%edx
c0102d56:	89 d0                	mov    %edx,%eax
c0102d58:	c1 e0 02             	shl    $0x2,%eax
c0102d5b:	01 d0                	add    %edx,%eax
c0102d5d:	c1 e0 02             	shl    $0x2,%eax
c0102d60:	89 c2                	mov    %eax,%edx
c0102d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d65:	01 d0                	add    %edx,%eax
c0102d67:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102d6a:	75 5e                	jne    c0102dca <default_free_pages+0x237>
            p->property += base->property;
c0102d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d6f:	8b 50 08             	mov    0x8(%eax),%edx
c0102d72:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d75:	8b 40 08             	mov    0x8(%eax),%eax
c0102d78:	01 c2                	add    %eax,%edx
c0102d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d7d:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0102d80:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d83:	83 c0 04             	add    $0x4,%eax
c0102d86:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0102d8d:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0102d90:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102d93:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102d96:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c0102d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d9c:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0102d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102da2:	83 c0 0c             	add    $0xc,%eax
c0102da5:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102da8:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102dab:	8b 40 04             	mov    0x4(%eax),%eax
c0102dae:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102db1:	8b 12                	mov    (%edx),%edx
c0102db3:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0102db6:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102db9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102dbc:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0102dbf:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102dc2:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102dc5:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102dc8:	89 10                	mov    %edx,(%eax)
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
c0102dca:	81 7d f0 50 89 11 c0 	cmpl   $0xc0118950,-0x10(%ebp)
c0102dd1:	0f 85 eb fe ff ff    	jne    c0102cc2 <default_free_pages+0x12f>
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
c0102dd7:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c0102ddd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102de0:	01 d0                	add    %edx,%eax
c0102de2:	a3 58 89 11 c0       	mov    %eax,0xc0118958
c0102de7:	c7 45 9c 50 89 11 c0 	movl   $0xc0118950,-0x64(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102dee:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102df1:	8b 40 04             	mov    0x4(%eax),%eax

    le = list_next(&free_list);
c0102df4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0102df7:	eb 36                	jmp    c0102e2f <default_free_pages+0x29c>
        p = le2page(le, page_link);
c0102df9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102dfc:	83 e8 0c             	sub    $0xc,%eax
c0102dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if(base + base->property <= p)
c0102e02:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e05:	8b 50 08             	mov    0x8(%eax),%edx
c0102e08:	89 d0                	mov    %edx,%eax
c0102e0a:	c1 e0 02             	shl    $0x2,%eax
c0102e0d:	01 d0                	add    %edx,%eax
c0102e0f:	c1 e0 02             	shl    $0x2,%eax
c0102e12:	89 c2                	mov    %eax,%edx
c0102e14:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e17:	01 d0                	add    %edx,%eax
c0102e19:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102e1c:	77 02                	ja     c0102e20 <default_free_pages+0x28d>
        	break;
c0102e1e:	eb 18                	jmp    c0102e38 <default_free_pages+0x2a5>
c0102e20:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e23:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102e26:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102e29:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0102e2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
    }
    nr_free += n;

    le = list_next(&free_list);
    while (le != &free_list) {
c0102e2f:	81 7d f0 50 89 11 c0 	cmpl   $0xc0118950,-0x10(%ebp)
c0102e36:	75 c1                	jne    c0102df9 <default_free_pages+0x266>
        p = le2page(le, page_link);
        if(base + base->property <= p)
        	break;
        le = list_next(le);
    }
    list_add_before(le, &(base->page_link));
c0102e38:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e3b:	8d 50 0c             	lea    0xc(%eax),%edx
c0102e3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e41:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0102e44:	89 55 90             	mov    %edx,-0x70(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102e47:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102e4a:	8b 00                	mov    (%eax),%eax
c0102e4c:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102e4f:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0102e52:	89 45 88             	mov    %eax,-0x78(%ebp)
c0102e55:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102e58:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102e5b:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102e5e:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0102e61:	89 10                	mov    %edx,(%eax)
c0102e63:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102e66:	8b 10                	mov    (%eax),%edx
c0102e68:	8b 45 88             	mov    -0x78(%ebp),%eax
c0102e6b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102e6e:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102e71:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0102e74:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102e77:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102e7a:	8b 55 88             	mov    -0x78(%ebp),%edx
c0102e7d:	89 10                	mov    %edx,(%eax)
}
c0102e7f:	c9                   	leave  
c0102e80:	c3                   	ret    

c0102e81 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102e81:	55                   	push   %ebp
c0102e82:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102e84:	a1 58 89 11 c0       	mov    0xc0118958,%eax
}
c0102e89:	5d                   	pop    %ebp
c0102e8a:	c3                   	ret    

c0102e8b <basic_check>:

static void
basic_check(void) {
c0102e8b:	55                   	push   %ebp
c0102e8c:	89 e5                	mov    %esp,%ebp
c0102e8e:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102e91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102e9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ea1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102ea4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102eab:	e8 9d 0e 00 00       	call   c0103d4d <alloc_pages>
c0102eb0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102eb3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102eb7:	75 24                	jne    c0102edd <basic_check+0x52>
c0102eb9:	c7 44 24 0c 79 67 10 	movl   $0xc0106779,0xc(%esp)
c0102ec0:	c0 
c0102ec1:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0102ec8:	c0 
c0102ec9:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0102ed0:	00 
c0102ed1:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0102ed8:	e8 ee dd ff ff       	call   c0100ccb <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102edd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102ee4:	e8 64 0e 00 00       	call   c0103d4d <alloc_pages>
c0102ee9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102eec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102ef0:	75 24                	jne    c0102f16 <basic_check+0x8b>
c0102ef2:	c7 44 24 0c 95 67 10 	movl   $0xc0106795,0xc(%esp)
c0102ef9:	c0 
c0102efa:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0102f01:	c0 
c0102f02:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0102f09:	00 
c0102f0a:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0102f11:	e8 b5 dd ff ff       	call   c0100ccb <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102f16:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102f1d:	e8 2b 0e 00 00       	call   c0103d4d <alloc_pages>
c0102f22:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102f25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102f29:	75 24                	jne    c0102f4f <basic_check+0xc4>
c0102f2b:	c7 44 24 0c b1 67 10 	movl   $0xc01067b1,0xc(%esp)
c0102f32:	c0 
c0102f33:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0102f3a:	c0 
c0102f3b:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
c0102f42:	00 
c0102f43:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0102f4a:	e8 7c dd ff ff       	call   c0100ccb <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0102f4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f52:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102f55:	74 10                	je     c0102f67 <basic_check+0xdc>
c0102f57:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f5a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102f5d:	74 08                	je     c0102f67 <basic_check+0xdc>
c0102f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f62:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102f65:	75 24                	jne    c0102f8b <basic_check+0x100>
c0102f67:	c7 44 24 0c d0 67 10 	movl   $0xc01067d0,0xc(%esp)
c0102f6e:	c0 
c0102f6f:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0102f76:	c0 
c0102f77:	c7 44 24 04 a3 00 00 	movl   $0xa3,0x4(%esp)
c0102f7e:	00 
c0102f7f:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0102f86:	e8 40 dd ff ff       	call   c0100ccb <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0102f8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f8e:	89 04 24             	mov    %eax,(%esp)
c0102f91:	e8 db f8 ff ff       	call   c0102871 <page_ref>
c0102f96:	85 c0                	test   %eax,%eax
c0102f98:	75 1e                	jne    c0102fb8 <basic_check+0x12d>
c0102f9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f9d:	89 04 24             	mov    %eax,(%esp)
c0102fa0:	e8 cc f8 ff ff       	call   c0102871 <page_ref>
c0102fa5:	85 c0                	test   %eax,%eax
c0102fa7:	75 0f                	jne    c0102fb8 <basic_check+0x12d>
c0102fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fac:	89 04 24             	mov    %eax,(%esp)
c0102faf:	e8 bd f8 ff ff       	call   c0102871 <page_ref>
c0102fb4:	85 c0                	test   %eax,%eax
c0102fb6:	74 24                	je     c0102fdc <basic_check+0x151>
c0102fb8:	c7 44 24 0c f4 67 10 	movl   $0xc01067f4,0xc(%esp)
c0102fbf:	c0 
c0102fc0:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0102fc7:	c0 
c0102fc8:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
c0102fcf:	00 
c0102fd0:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0102fd7:	e8 ef dc ff ff       	call   c0100ccb <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0102fdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102fdf:	89 04 24             	mov    %eax,(%esp)
c0102fe2:	e8 74 f8 ff ff       	call   c010285b <page2pa>
c0102fe7:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102fed:	c1 e2 0c             	shl    $0xc,%edx
c0102ff0:	39 d0                	cmp    %edx,%eax
c0102ff2:	72 24                	jb     c0103018 <basic_check+0x18d>
c0102ff4:	c7 44 24 0c 30 68 10 	movl   $0xc0106830,0xc(%esp)
c0102ffb:	c0 
c0102ffc:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0103003:	c0 
c0103004:	c7 44 24 04 a6 00 00 	movl   $0xa6,0x4(%esp)
c010300b:	00 
c010300c:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0103013:	e8 b3 dc ff ff       	call   c0100ccb <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0103018:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010301b:	89 04 24             	mov    %eax,(%esp)
c010301e:	e8 38 f8 ff ff       	call   c010285b <page2pa>
c0103023:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0103029:	c1 e2 0c             	shl    $0xc,%edx
c010302c:	39 d0                	cmp    %edx,%eax
c010302e:	72 24                	jb     c0103054 <basic_check+0x1c9>
c0103030:	c7 44 24 0c 4d 68 10 	movl   $0xc010684d,0xc(%esp)
c0103037:	c0 
c0103038:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c010303f:	c0 
c0103040:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
c0103047:	00 
c0103048:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c010304f:	e8 77 dc ff ff       	call   c0100ccb <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103054:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103057:	89 04 24             	mov    %eax,(%esp)
c010305a:	e8 fc f7 ff ff       	call   c010285b <page2pa>
c010305f:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0103065:	c1 e2 0c             	shl    $0xc,%edx
c0103068:	39 d0                	cmp    %edx,%eax
c010306a:	72 24                	jb     c0103090 <basic_check+0x205>
c010306c:	c7 44 24 0c 6a 68 10 	movl   $0xc010686a,0xc(%esp)
c0103073:	c0 
c0103074:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c010307b:	c0 
c010307c:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
c0103083:	00 
c0103084:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c010308b:	e8 3b dc ff ff       	call   c0100ccb <__panic>

    list_entry_t free_list_store = free_list;
c0103090:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0103095:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c010309b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010309e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01030a1:	c7 45 e0 50 89 11 c0 	movl   $0xc0118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01030a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01030ab:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01030ae:	89 50 04             	mov    %edx,0x4(%eax)
c01030b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01030b4:	8b 50 04             	mov    0x4(%eax),%edx
c01030b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01030ba:	89 10                	mov    %edx,(%eax)
c01030bc:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01030c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01030c6:	8b 40 04             	mov    0x4(%eax),%eax
c01030c9:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01030cc:	0f 94 c0             	sete   %al
c01030cf:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01030d2:	85 c0                	test   %eax,%eax
c01030d4:	75 24                	jne    c01030fa <basic_check+0x26f>
c01030d6:	c7 44 24 0c 87 68 10 	movl   $0xc0106887,0xc(%esp)
c01030dd:	c0 
c01030de:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c01030e5:	c0 
c01030e6:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
c01030ed:	00 
c01030ee:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c01030f5:	e8 d1 db ff ff       	call   c0100ccb <__panic>

    unsigned int nr_free_store = nr_free;
c01030fa:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c01030ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103102:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c0103109:	00 00 00 

    assert(alloc_page() == NULL);
c010310c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103113:	e8 35 0c 00 00       	call   c0103d4d <alloc_pages>
c0103118:	85 c0                	test   %eax,%eax
c010311a:	74 24                	je     c0103140 <basic_check+0x2b5>
c010311c:	c7 44 24 0c 9e 68 10 	movl   $0xc010689e,0xc(%esp)
c0103123:	c0 
c0103124:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c010312b:	c0 
c010312c:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
c0103133:	00 
c0103134:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c010313b:	e8 8b db ff ff       	call   c0100ccb <__panic>

    free_page(p0);
c0103140:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103147:	00 
c0103148:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010314b:	89 04 24             	mov    %eax,(%esp)
c010314e:	e8 32 0c 00 00       	call   c0103d85 <free_pages>
    free_page(p1);
c0103153:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010315a:	00 
c010315b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010315e:	89 04 24             	mov    %eax,(%esp)
c0103161:	e8 1f 0c 00 00       	call   c0103d85 <free_pages>
    free_page(p2);
c0103166:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010316d:	00 
c010316e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103171:	89 04 24             	mov    %eax,(%esp)
c0103174:	e8 0c 0c 00 00       	call   c0103d85 <free_pages>
    assert(nr_free == 3);
c0103179:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c010317e:	83 f8 03             	cmp    $0x3,%eax
c0103181:	74 24                	je     c01031a7 <basic_check+0x31c>
c0103183:	c7 44 24 0c b3 68 10 	movl   $0xc01068b3,0xc(%esp)
c010318a:	c0 
c010318b:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0103192:	c0 
c0103193:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c010319a:	00 
c010319b:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c01031a2:	e8 24 db ff ff       	call   c0100ccb <__panic>

    assert((p0 = alloc_page()) != NULL);
c01031a7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031ae:	e8 9a 0b 00 00       	call   c0103d4d <alloc_pages>
c01031b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01031b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01031ba:	75 24                	jne    c01031e0 <basic_check+0x355>
c01031bc:	c7 44 24 0c 79 67 10 	movl   $0xc0106779,0xc(%esp)
c01031c3:	c0 
c01031c4:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c01031cb:	c0 
c01031cc:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
c01031d3:	00 
c01031d4:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c01031db:	e8 eb da ff ff       	call   c0100ccb <__panic>
    assert((p1 = alloc_page()) != NULL);
c01031e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031e7:	e8 61 0b 00 00       	call   c0103d4d <alloc_pages>
c01031ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01031ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01031f3:	75 24                	jne    c0103219 <basic_check+0x38e>
c01031f5:	c7 44 24 0c 95 67 10 	movl   $0xc0106795,0xc(%esp)
c01031fc:	c0 
c01031fd:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0103204:	c0 
c0103205:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c010320c:	00 
c010320d:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0103214:	e8 b2 da ff ff       	call   c0100ccb <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103219:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103220:	e8 28 0b 00 00       	call   c0103d4d <alloc_pages>
c0103225:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103228:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010322c:	75 24                	jne    c0103252 <basic_check+0x3c7>
c010322e:	c7 44 24 0c b1 67 10 	movl   $0xc01067b1,0xc(%esp)
c0103235:	c0 
c0103236:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c010323d:	c0 
c010323e:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c0103245:	00 
c0103246:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c010324d:	e8 79 da ff ff       	call   c0100ccb <__panic>

    assert(alloc_page() == NULL);
c0103252:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103259:	e8 ef 0a 00 00       	call   c0103d4d <alloc_pages>
c010325e:	85 c0                	test   %eax,%eax
c0103260:	74 24                	je     c0103286 <basic_check+0x3fb>
c0103262:	c7 44 24 0c 9e 68 10 	movl   $0xc010689e,0xc(%esp)
c0103269:	c0 
c010326a:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0103271:	c0 
c0103272:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0103279:	00 
c010327a:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0103281:	e8 45 da ff ff       	call   c0100ccb <__panic>

    free_page(p0);
c0103286:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010328d:	00 
c010328e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103291:	89 04 24             	mov    %eax,(%esp)
c0103294:	e8 ec 0a 00 00       	call   c0103d85 <free_pages>
c0103299:	c7 45 d8 50 89 11 c0 	movl   $0xc0118950,-0x28(%ebp)
c01032a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01032a3:	8b 40 04             	mov    0x4(%eax),%eax
c01032a6:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01032a9:	0f 94 c0             	sete   %al
c01032ac:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c01032af:	85 c0                	test   %eax,%eax
c01032b1:	74 24                	je     c01032d7 <basic_check+0x44c>
c01032b3:	c7 44 24 0c c0 68 10 	movl   $0xc01068c0,0xc(%esp)
c01032ba:	c0 
c01032bb:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c01032c2:	c0 
c01032c3:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c01032ca:	00 
c01032cb:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c01032d2:	e8 f4 d9 ff ff       	call   c0100ccb <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c01032d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032de:	e8 6a 0a 00 00       	call   c0103d4d <alloc_pages>
c01032e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01032e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01032e9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01032ec:	74 24                	je     c0103312 <basic_check+0x487>
c01032ee:	c7 44 24 0c d8 68 10 	movl   $0xc01068d8,0xc(%esp)
c01032f5:	c0 
c01032f6:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c01032fd:	c0 
c01032fe:	c7 44 24 04 c2 00 00 	movl   $0xc2,0x4(%esp)
c0103305:	00 
c0103306:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c010330d:	e8 b9 d9 ff ff       	call   c0100ccb <__panic>
    assert(alloc_page() == NULL);
c0103312:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103319:	e8 2f 0a 00 00       	call   c0103d4d <alloc_pages>
c010331e:	85 c0                	test   %eax,%eax
c0103320:	74 24                	je     c0103346 <basic_check+0x4bb>
c0103322:	c7 44 24 0c 9e 68 10 	movl   $0xc010689e,0xc(%esp)
c0103329:	c0 
c010332a:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0103331:	c0 
c0103332:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c0103339:	00 
c010333a:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0103341:	e8 85 d9 ff ff       	call   c0100ccb <__panic>

    assert(nr_free == 0);
c0103346:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c010334b:	85 c0                	test   %eax,%eax
c010334d:	74 24                	je     c0103373 <basic_check+0x4e8>
c010334f:	c7 44 24 0c f1 68 10 	movl   $0xc01068f1,0xc(%esp)
c0103356:	c0 
c0103357:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c010335e:	c0 
c010335f:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
c0103366:	00 
c0103367:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c010336e:	e8 58 d9 ff ff       	call   c0100ccb <__panic>
    free_list = free_list_store;
c0103373:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103376:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103379:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c010337e:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    nr_free = nr_free_store;
c0103384:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103387:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_page(p);
c010338c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103393:	00 
c0103394:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103397:	89 04 24             	mov    %eax,(%esp)
c010339a:	e8 e6 09 00 00       	call   c0103d85 <free_pages>
    free_page(p1);
c010339f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01033a6:	00 
c01033a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033aa:	89 04 24             	mov    %eax,(%esp)
c01033ad:	e8 d3 09 00 00       	call   c0103d85 <free_pages>
    free_page(p2);
c01033b2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01033b9:	00 
c01033ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033bd:	89 04 24             	mov    %eax,(%esp)
c01033c0:	e8 c0 09 00 00       	call   c0103d85 <free_pages>
}
c01033c5:	c9                   	leave  
c01033c6:	c3                   	ret    

c01033c7 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c01033c7:	55                   	push   %ebp
c01033c8:	89 e5                	mov    %esp,%ebp
c01033ca:	53                   	push   %ebx
c01033cb:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c01033d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01033d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c01033df:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01033e6:	eb 6b                	jmp    c0103453 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c01033e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033eb:	83 e8 0c             	sub    $0xc,%eax
c01033ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c01033f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033f4:	83 c0 04             	add    $0x4,%eax
c01033f7:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01033fe:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103401:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103404:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103407:	0f a3 10             	bt     %edx,(%eax)
c010340a:	19 c0                	sbb    %eax,%eax
c010340c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c010340f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103413:	0f 95 c0             	setne  %al
c0103416:	0f b6 c0             	movzbl %al,%eax
c0103419:	85 c0                	test   %eax,%eax
c010341b:	75 24                	jne    c0103441 <default_check+0x7a>
c010341d:	c7 44 24 0c fe 68 10 	movl   $0xc01068fe,0xc(%esp)
c0103424:	c0 
c0103425:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c010342c:	c0 
c010342d:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0103434:	00 
c0103435:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c010343c:	e8 8a d8 ff ff       	call   c0100ccb <__panic>
        count ++, total += p->property;
c0103441:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103445:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103448:	8b 50 08             	mov    0x8(%eax),%edx
c010344b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010344e:	01 d0                	add    %edx,%eax
c0103450:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103453:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103456:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103459:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010345c:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010345f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103462:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c0103469:	0f 85 79 ff ff ff    	jne    c01033e8 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c010346f:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103472:	e8 40 09 00 00       	call   c0103db7 <nr_free_pages>
c0103477:	39 c3                	cmp    %eax,%ebx
c0103479:	74 24                	je     c010349f <default_check+0xd8>
c010347b:	c7 44 24 0c 0e 69 10 	movl   $0xc010690e,0xc(%esp)
c0103482:	c0 
c0103483:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c010348a:	c0 
c010348b:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0103492:	00 
c0103493:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c010349a:	e8 2c d8 ff ff       	call   c0100ccb <__panic>

    basic_check();
c010349f:	e8 e7 f9 ff ff       	call   c0102e8b <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c01034a4:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01034ab:	e8 9d 08 00 00       	call   c0103d4d <alloc_pages>
c01034b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c01034b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01034b7:	75 24                	jne    c01034dd <default_check+0x116>
c01034b9:	c7 44 24 0c 27 69 10 	movl   $0xc0106927,0xc(%esp)
c01034c0:	c0 
c01034c1:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c01034c8:	c0 
c01034c9:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c01034d0:	00 
c01034d1:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c01034d8:	e8 ee d7 ff ff       	call   c0100ccb <__panic>
    assert(!PageProperty(p0));
c01034dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01034e0:	83 c0 04             	add    $0x4,%eax
c01034e3:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01034ea:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01034ed:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01034f0:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01034f3:	0f a3 10             	bt     %edx,(%eax)
c01034f6:	19 c0                	sbb    %eax,%eax
c01034f8:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01034fb:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01034ff:	0f 95 c0             	setne  %al
c0103502:	0f b6 c0             	movzbl %al,%eax
c0103505:	85 c0                	test   %eax,%eax
c0103507:	74 24                	je     c010352d <default_check+0x166>
c0103509:	c7 44 24 0c 32 69 10 	movl   $0xc0106932,0xc(%esp)
c0103510:	c0 
c0103511:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0103518:	c0 
c0103519:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
c0103520:	00 
c0103521:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0103528:	e8 9e d7 ff ff       	call   c0100ccb <__panic>

    list_entry_t free_list_store = free_list;
c010352d:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0103532:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c0103538:	89 45 80             	mov    %eax,-0x80(%ebp)
c010353b:	89 55 84             	mov    %edx,-0x7c(%ebp)
c010353e:	c7 45 b4 50 89 11 c0 	movl   $0xc0118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103545:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103548:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010354b:	89 50 04             	mov    %edx,0x4(%eax)
c010354e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103551:	8b 50 04             	mov    0x4(%eax),%edx
c0103554:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103557:	89 10                	mov    %edx,(%eax)
c0103559:	c7 45 b0 50 89 11 c0 	movl   $0xc0118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103560:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103563:	8b 40 04             	mov    0x4(%eax),%eax
c0103566:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103569:	0f 94 c0             	sete   %al
c010356c:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010356f:	85 c0                	test   %eax,%eax
c0103571:	75 24                	jne    c0103597 <default_check+0x1d0>
c0103573:	c7 44 24 0c 87 68 10 	movl   $0xc0106887,0xc(%esp)
c010357a:	c0 
c010357b:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0103582:	c0 
c0103583:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c010358a:	00 
c010358b:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0103592:	e8 34 d7 ff ff       	call   c0100ccb <__panic>
    assert(alloc_page() == NULL);
c0103597:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010359e:	e8 aa 07 00 00       	call   c0103d4d <alloc_pages>
c01035a3:	85 c0                	test   %eax,%eax
c01035a5:	74 24                	je     c01035cb <default_check+0x204>
c01035a7:	c7 44 24 0c 9e 68 10 	movl   $0xc010689e,0xc(%esp)
c01035ae:	c0 
c01035af:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c01035b6:	c0 
c01035b7:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c01035be:	00 
c01035bf:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c01035c6:	e8 00 d7 ff ff       	call   c0100ccb <__panic>

    unsigned int nr_free_store = nr_free;
c01035cb:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c01035d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c01035d3:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c01035da:	00 00 00 

    free_pages(p0 + 2, 3);
c01035dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035e0:	83 c0 28             	add    $0x28,%eax
c01035e3:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01035ea:	00 
c01035eb:	89 04 24             	mov    %eax,(%esp)
c01035ee:	e8 92 07 00 00       	call   c0103d85 <free_pages>
    assert(alloc_pages(4) == NULL);
c01035f3:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01035fa:	e8 4e 07 00 00       	call   c0103d4d <alloc_pages>
c01035ff:	85 c0                	test   %eax,%eax
c0103601:	74 24                	je     c0103627 <default_check+0x260>
c0103603:	c7 44 24 0c 44 69 10 	movl   $0xc0106944,0xc(%esp)
c010360a:	c0 
c010360b:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0103612:	c0 
c0103613:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c010361a:	00 
c010361b:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0103622:	e8 a4 d6 ff ff       	call   c0100ccb <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103627:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010362a:	83 c0 28             	add    $0x28,%eax
c010362d:	83 c0 04             	add    $0x4,%eax
c0103630:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103637:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010363a:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010363d:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103640:	0f a3 10             	bt     %edx,(%eax)
c0103643:	19 c0                	sbb    %eax,%eax
c0103645:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103648:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c010364c:	0f 95 c0             	setne  %al
c010364f:	0f b6 c0             	movzbl %al,%eax
c0103652:	85 c0                	test   %eax,%eax
c0103654:	74 0e                	je     c0103664 <default_check+0x29d>
c0103656:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103659:	83 c0 28             	add    $0x28,%eax
c010365c:	8b 40 08             	mov    0x8(%eax),%eax
c010365f:	83 f8 03             	cmp    $0x3,%eax
c0103662:	74 24                	je     c0103688 <default_check+0x2c1>
c0103664:	c7 44 24 0c 5c 69 10 	movl   $0xc010695c,0xc(%esp)
c010366b:	c0 
c010366c:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0103673:	c0 
c0103674:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c010367b:	00 
c010367c:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0103683:	e8 43 d6 ff ff       	call   c0100ccb <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103688:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c010368f:	e8 b9 06 00 00       	call   c0103d4d <alloc_pages>
c0103694:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103697:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010369b:	75 24                	jne    c01036c1 <default_check+0x2fa>
c010369d:	c7 44 24 0c 88 69 10 	movl   $0xc0106988,0xc(%esp)
c01036a4:	c0 
c01036a5:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c01036ac:	c0 
c01036ad:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c01036b4:	00 
c01036b5:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c01036bc:	e8 0a d6 ff ff       	call   c0100ccb <__panic>
    assert(alloc_page() == NULL);
c01036c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01036c8:	e8 80 06 00 00       	call   c0103d4d <alloc_pages>
c01036cd:	85 c0                	test   %eax,%eax
c01036cf:	74 24                	je     c01036f5 <default_check+0x32e>
c01036d1:	c7 44 24 0c 9e 68 10 	movl   $0xc010689e,0xc(%esp)
c01036d8:	c0 
c01036d9:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c01036e0:	c0 
c01036e1:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c01036e8:	00 
c01036e9:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c01036f0:	e8 d6 d5 ff ff       	call   c0100ccb <__panic>
    assert(p0 + 2 == p1);
c01036f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036f8:	83 c0 28             	add    $0x28,%eax
c01036fb:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01036fe:	74 24                	je     c0103724 <default_check+0x35d>
c0103700:	c7 44 24 0c a6 69 10 	movl   $0xc01069a6,0xc(%esp)
c0103707:	c0 
c0103708:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c010370f:	c0 
c0103710:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c0103717:	00 
c0103718:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c010371f:	e8 a7 d5 ff ff       	call   c0100ccb <__panic>

    p2 = p0 + 1;
c0103724:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103727:	83 c0 14             	add    $0x14,%eax
c010372a:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c010372d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103734:	00 
c0103735:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103738:	89 04 24             	mov    %eax,(%esp)
c010373b:	e8 45 06 00 00       	call   c0103d85 <free_pages>
    free_pages(p1, 3);
c0103740:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103747:	00 
c0103748:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010374b:	89 04 24             	mov    %eax,(%esp)
c010374e:	e8 32 06 00 00       	call   c0103d85 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0103753:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103756:	83 c0 04             	add    $0x4,%eax
c0103759:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0103760:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103763:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103766:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103769:	0f a3 10             	bt     %edx,(%eax)
c010376c:	19 c0                	sbb    %eax,%eax
c010376e:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0103771:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0103775:	0f 95 c0             	setne  %al
c0103778:	0f b6 c0             	movzbl %al,%eax
c010377b:	85 c0                	test   %eax,%eax
c010377d:	74 0b                	je     c010378a <default_check+0x3c3>
c010377f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103782:	8b 40 08             	mov    0x8(%eax),%eax
c0103785:	83 f8 01             	cmp    $0x1,%eax
c0103788:	74 24                	je     c01037ae <default_check+0x3e7>
c010378a:	c7 44 24 0c b4 69 10 	movl   $0xc01069b4,0xc(%esp)
c0103791:	c0 
c0103792:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0103799:	c0 
c010379a:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
c01037a1:	00 
c01037a2:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c01037a9:	e8 1d d5 ff ff       	call   c0100ccb <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01037ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01037b1:	83 c0 04             	add    $0x4,%eax
c01037b4:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01037bb:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01037be:	8b 45 90             	mov    -0x70(%ebp),%eax
c01037c1:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01037c4:	0f a3 10             	bt     %edx,(%eax)
c01037c7:	19 c0                	sbb    %eax,%eax
c01037c9:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01037cc:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01037d0:	0f 95 c0             	setne  %al
c01037d3:	0f b6 c0             	movzbl %al,%eax
c01037d6:	85 c0                	test   %eax,%eax
c01037d8:	74 0b                	je     c01037e5 <default_check+0x41e>
c01037da:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01037dd:	8b 40 08             	mov    0x8(%eax),%eax
c01037e0:	83 f8 03             	cmp    $0x3,%eax
c01037e3:	74 24                	je     c0103809 <default_check+0x442>
c01037e5:	c7 44 24 0c dc 69 10 	movl   $0xc01069dc,0xc(%esp)
c01037ec:	c0 
c01037ed:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c01037f4:	c0 
c01037f5:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c01037fc:	00 
c01037fd:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0103804:	e8 c2 d4 ff ff       	call   c0100ccb <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0103809:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103810:	e8 38 05 00 00       	call   c0103d4d <alloc_pages>
c0103815:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103818:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010381b:	83 e8 14             	sub    $0x14,%eax
c010381e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103821:	74 24                	je     c0103847 <default_check+0x480>
c0103823:	c7 44 24 0c 02 6a 10 	movl   $0xc0106a02,0xc(%esp)
c010382a:	c0 
c010382b:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0103832:	c0 
c0103833:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
c010383a:	00 
c010383b:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0103842:	e8 84 d4 ff ff       	call   c0100ccb <__panic>
    free_page(p0);
c0103847:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010384e:	00 
c010384f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103852:	89 04 24             	mov    %eax,(%esp)
c0103855:	e8 2b 05 00 00       	call   c0103d85 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c010385a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0103861:	e8 e7 04 00 00       	call   c0103d4d <alloc_pages>
c0103866:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103869:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010386c:	83 c0 14             	add    $0x14,%eax
c010386f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103872:	74 24                	je     c0103898 <default_check+0x4d1>
c0103874:	c7 44 24 0c 20 6a 10 	movl   $0xc0106a20,0xc(%esp)
c010387b:	c0 
c010387c:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0103883:	c0 
c0103884:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c010388b:	00 
c010388c:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0103893:	e8 33 d4 ff ff       	call   c0100ccb <__panic>

    free_pages(p0, 2);
c0103898:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c010389f:	00 
c01038a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01038a3:	89 04 24             	mov    %eax,(%esp)
c01038a6:	e8 da 04 00 00       	call   c0103d85 <free_pages>
    free_page(p2);
c01038ab:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01038b2:	00 
c01038b3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01038b6:	89 04 24             	mov    %eax,(%esp)
c01038b9:	e8 c7 04 00 00       	call   c0103d85 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c01038be:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01038c5:	e8 83 04 00 00       	call   c0103d4d <alloc_pages>
c01038ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01038cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01038d1:	75 24                	jne    c01038f7 <default_check+0x530>
c01038d3:	c7 44 24 0c 40 6a 10 	movl   $0xc0106a40,0xc(%esp)
c01038da:	c0 
c01038db:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c01038e2:	c0 
c01038e3:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c01038ea:	00 
c01038eb:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c01038f2:	e8 d4 d3 ff ff       	call   c0100ccb <__panic>
    assert(alloc_page() == NULL);
c01038f7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01038fe:	e8 4a 04 00 00       	call   c0103d4d <alloc_pages>
c0103903:	85 c0                	test   %eax,%eax
c0103905:	74 24                	je     c010392b <default_check+0x564>
c0103907:	c7 44 24 0c 9e 68 10 	movl   $0xc010689e,0xc(%esp)
c010390e:	c0 
c010390f:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0103916:	c0 
c0103917:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c010391e:	00 
c010391f:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0103926:	e8 a0 d3 ff ff       	call   c0100ccb <__panic>

    assert(nr_free == 0);
c010392b:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103930:	85 c0                	test   %eax,%eax
c0103932:	74 24                	je     c0103958 <default_check+0x591>
c0103934:	c7 44 24 0c f1 68 10 	movl   $0xc01068f1,0xc(%esp)
c010393b:	c0 
c010393c:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0103943:	c0 
c0103944:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c010394b:	00 
c010394c:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0103953:	e8 73 d3 ff ff       	call   c0100ccb <__panic>
    nr_free = nr_free_store;
c0103958:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010395b:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_list = free_list_store;
c0103960:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103963:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103966:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c010396b:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    free_pages(p0, 5);
c0103971:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0103978:	00 
c0103979:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010397c:	89 04 24             	mov    %eax,(%esp)
c010397f:	e8 01 04 00 00       	call   c0103d85 <free_pages>

    le = &free_list;
c0103984:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010398b:	eb 1d                	jmp    c01039aa <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c010398d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103990:	83 e8 0c             	sub    $0xc,%eax
c0103993:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0103996:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010399a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010399d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01039a0:	8b 40 08             	mov    0x8(%eax),%eax
c01039a3:	29 c2                	sub    %eax,%edx
c01039a5:	89 d0                	mov    %edx,%eax
c01039a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01039aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039ad:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01039b0:	8b 45 88             	mov    -0x78(%ebp),%eax
c01039b3:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01039b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01039b9:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c01039c0:	75 cb                	jne    c010398d <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c01039c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01039c6:	74 24                	je     c01039ec <default_check+0x625>
c01039c8:	c7 44 24 0c 5e 6a 10 	movl   $0xc0106a5e,0xc(%esp)
c01039cf:	c0 
c01039d0:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c01039d7:	c0 
c01039d8:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c01039df:	00 
c01039e0:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c01039e7:	e8 df d2 ff ff       	call   c0100ccb <__panic>
    assert(total == 0);
c01039ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01039f0:	74 24                	je     c0103a16 <default_check+0x64f>
c01039f2:	c7 44 24 0c 69 6a 10 	movl   $0xc0106a69,0xc(%esp)
c01039f9:	c0 
c01039fa:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0103a01:	c0 
c0103a02:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c0103a09:	00 
c0103a0a:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0103a11:	e8 b5 d2 ff ff       	call   c0100ccb <__panic>
}
c0103a16:	81 c4 94 00 00 00    	add    $0x94,%esp
c0103a1c:	5b                   	pop    %ebx
c0103a1d:	5d                   	pop    %ebp
c0103a1e:	c3                   	ret    

c0103a1f <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103a1f:	55                   	push   %ebp
c0103a20:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103a22:	8b 55 08             	mov    0x8(%ebp),%edx
c0103a25:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0103a2a:	29 c2                	sub    %eax,%edx
c0103a2c:	89 d0                	mov    %edx,%eax
c0103a2e:	c1 f8 02             	sar    $0x2,%eax
c0103a31:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103a37:	5d                   	pop    %ebp
c0103a38:	c3                   	ret    

c0103a39 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103a39:	55                   	push   %ebp
c0103a3a:	89 e5                	mov    %esp,%ebp
c0103a3c:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103a3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a42:	89 04 24             	mov    %eax,(%esp)
c0103a45:	e8 d5 ff ff ff       	call   c0103a1f <page2ppn>
c0103a4a:	c1 e0 0c             	shl    $0xc,%eax
}
c0103a4d:	c9                   	leave  
c0103a4e:	c3                   	ret    

c0103a4f <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0103a4f:	55                   	push   %ebp
c0103a50:	89 e5                	mov    %esp,%ebp
c0103a52:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103a55:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a58:	c1 e8 0c             	shr    $0xc,%eax
c0103a5b:	89 c2                	mov    %eax,%edx
c0103a5d:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103a62:	39 c2                	cmp    %eax,%edx
c0103a64:	72 1c                	jb     c0103a82 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103a66:	c7 44 24 08 a4 6a 10 	movl   $0xc0106aa4,0x8(%esp)
c0103a6d:	c0 
c0103a6e:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103a75:	00 
c0103a76:	c7 04 24 c3 6a 10 c0 	movl   $0xc0106ac3,(%esp)
c0103a7d:	e8 49 d2 ff ff       	call   c0100ccb <__panic>
    }
    return &pages[PPN(pa)];
c0103a82:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0103a88:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a8b:	c1 e8 0c             	shr    $0xc,%eax
c0103a8e:	89 c2                	mov    %eax,%edx
c0103a90:	89 d0                	mov    %edx,%eax
c0103a92:	c1 e0 02             	shl    $0x2,%eax
c0103a95:	01 d0                	add    %edx,%eax
c0103a97:	c1 e0 02             	shl    $0x2,%eax
c0103a9a:	01 c8                	add    %ecx,%eax
}
c0103a9c:	c9                   	leave  
c0103a9d:	c3                   	ret    

c0103a9e <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0103a9e:	55                   	push   %ebp
c0103a9f:	89 e5                	mov    %esp,%ebp
c0103aa1:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103aa4:	8b 45 08             	mov    0x8(%ebp),%eax
c0103aa7:	89 04 24             	mov    %eax,(%esp)
c0103aaa:	e8 8a ff ff ff       	call   c0103a39 <page2pa>
c0103aaf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ab5:	c1 e8 0c             	shr    $0xc,%eax
c0103ab8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103abb:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103ac0:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103ac3:	72 23                	jb     c0103ae8 <page2kva+0x4a>
c0103ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ac8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103acc:	c7 44 24 08 d4 6a 10 	movl   $0xc0106ad4,0x8(%esp)
c0103ad3:	c0 
c0103ad4:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103adb:	00 
c0103adc:	c7 04 24 c3 6a 10 c0 	movl   $0xc0106ac3,(%esp)
c0103ae3:	e8 e3 d1 ff ff       	call   c0100ccb <__panic>
c0103ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103aeb:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103af0:	c9                   	leave  
c0103af1:	c3                   	ret    

c0103af2 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0103af2:	55                   	push   %ebp
c0103af3:	89 e5                	mov    %esp,%ebp
c0103af5:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103af8:	8b 45 08             	mov    0x8(%ebp),%eax
c0103afb:	83 e0 01             	and    $0x1,%eax
c0103afe:	85 c0                	test   %eax,%eax
c0103b00:	75 1c                	jne    c0103b1e <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103b02:	c7 44 24 08 f8 6a 10 	movl   $0xc0106af8,0x8(%esp)
c0103b09:	c0 
c0103b0a:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103b11:	00 
c0103b12:	c7 04 24 c3 6a 10 c0 	movl   $0xc0106ac3,(%esp)
c0103b19:	e8 ad d1 ff ff       	call   c0100ccb <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103b1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b21:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103b26:	89 04 24             	mov    %eax,(%esp)
c0103b29:	e8 21 ff ff ff       	call   c0103a4f <pa2page>
}
c0103b2e:	c9                   	leave  
c0103b2f:	c3                   	ret    

c0103b30 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0103b30:	55                   	push   %ebp
c0103b31:	89 e5                	mov    %esp,%ebp
c0103b33:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0103b36:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b39:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103b3e:	89 04 24             	mov    %eax,(%esp)
c0103b41:	e8 09 ff ff ff       	call   c0103a4f <pa2page>
}
c0103b46:	c9                   	leave  
c0103b47:	c3                   	ret    

c0103b48 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0103b48:	55                   	push   %ebp
c0103b49:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103b4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b4e:	8b 00                	mov    (%eax),%eax
}
c0103b50:	5d                   	pop    %ebp
c0103b51:	c3                   	ret    

c0103b52 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103b52:	55                   	push   %ebp
c0103b53:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103b55:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b58:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103b5b:	89 10                	mov    %edx,(%eax)
}
c0103b5d:	5d                   	pop    %ebp
c0103b5e:	c3                   	ret    

c0103b5f <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103b5f:	55                   	push   %ebp
c0103b60:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103b62:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b65:	8b 00                	mov    (%eax),%eax
c0103b67:	8d 50 01             	lea    0x1(%eax),%edx
c0103b6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b6d:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103b6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b72:	8b 00                	mov    (%eax),%eax
}
c0103b74:	5d                   	pop    %ebp
c0103b75:	c3                   	ret    

c0103b76 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103b76:	55                   	push   %ebp
c0103b77:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103b79:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b7c:	8b 00                	mov    (%eax),%eax
c0103b7e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103b81:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b84:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103b86:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b89:	8b 00                	mov    (%eax),%eax
}
c0103b8b:	5d                   	pop    %ebp
c0103b8c:	c3                   	ret    

c0103b8d <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103b8d:	55                   	push   %ebp
c0103b8e:	89 e5                	mov    %esp,%ebp
c0103b90:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103b93:	9c                   	pushf  
c0103b94:	58                   	pop    %eax
c0103b95:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103b9b:	25 00 02 00 00       	and    $0x200,%eax
c0103ba0:	85 c0                	test   %eax,%eax
c0103ba2:	74 0c                	je     c0103bb0 <__intr_save+0x23>
        intr_disable();
c0103ba4:	e8 05 db ff ff       	call   c01016ae <intr_disable>
        return 1;
c0103ba9:	b8 01 00 00 00       	mov    $0x1,%eax
c0103bae:	eb 05                	jmp    c0103bb5 <__intr_save+0x28>
    }
    return 0;
c0103bb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103bb5:	c9                   	leave  
c0103bb6:	c3                   	ret    

c0103bb7 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103bb7:	55                   	push   %ebp
c0103bb8:	89 e5                	mov    %esp,%ebp
c0103bba:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103bbd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103bc1:	74 05                	je     c0103bc8 <__intr_restore+0x11>
        intr_enable();
c0103bc3:	e8 e0 da ff ff       	call   c01016a8 <intr_enable>
    }
}
c0103bc8:	c9                   	leave  
c0103bc9:	c3                   	ret    

c0103bca <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103bca:	55                   	push   %ebp
c0103bcb:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103bcd:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bd0:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103bd3:	b8 23 00 00 00       	mov    $0x23,%eax
c0103bd8:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103bda:	b8 23 00 00 00       	mov    $0x23,%eax
c0103bdf:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103be1:	b8 10 00 00 00       	mov    $0x10,%eax
c0103be6:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103be8:	b8 10 00 00 00       	mov    $0x10,%eax
c0103bed:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103bef:	b8 10 00 00 00       	mov    $0x10,%eax
c0103bf4:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103bf6:	ea fd 3b 10 c0 08 00 	ljmp   $0x8,$0xc0103bfd
}
c0103bfd:	5d                   	pop    %ebp
c0103bfe:	c3                   	ret    

c0103bff <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103bff:	55                   	push   %ebp
c0103c00:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103c02:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c05:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
}
c0103c0a:	5d                   	pop    %ebp
c0103c0b:	c3                   	ret    

c0103c0c <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103c0c:	55                   	push   %ebp
c0103c0d:	89 e5                	mov    %esp,%ebp
c0103c0f:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103c12:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0103c17:	89 04 24             	mov    %eax,(%esp)
c0103c1a:	e8 e0 ff ff ff       	call   c0103bff <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103c1f:	66 c7 05 e8 88 11 c0 	movw   $0x10,0xc01188e8
c0103c26:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103c28:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0103c2f:	68 00 
c0103c31:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103c36:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0103c3c:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103c41:	c1 e8 10             	shr    $0x10,%eax
c0103c44:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0103c49:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c50:	83 e0 f0             	and    $0xfffffff0,%eax
c0103c53:	83 c8 09             	or     $0x9,%eax
c0103c56:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c5b:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c62:	83 e0 ef             	and    $0xffffffef,%eax
c0103c65:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c6a:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c71:	83 e0 9f             	and    $0xffffff9f,%eax
c0103c74:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c79:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c80:	83 c8 80             	or     $0xffffff80,%eax
c0103c83:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c88:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c8f:	83 e0 f0             	and    $0xfffffff0,%eax
c0103c92:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c97:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c9e:	83 e0 ef             	and    $0xffffffef,%eax
c0103ca1:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103ca6:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103cad:	83 e0 df             	and    $0xffffffdf,%eax
c0103cb0:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103cb5:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103cbc:	83 c8 40             	or     $0x40,%eax
c0103cbf:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103cc4:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103ccb:	83 e0 7f             	and    $0x7f,%eax
c0103cce:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103cd3:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103cd8:	c1 e8 18             	shr    $0x18,%eax
c0103cdb:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103ce0:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0103ce7:	e8 de fe ff ff       	call   c0103bca <lgdt>
c0103cec:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103cf2:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103cf6:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103cf9:	c9                   	leave  
c0103cfa:	c3                   	ret    

c0103cfb <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103cfb:	55                   	push   %ebp
c0103cfc:	89 e5                	mov    %esp,%ebp
c0103cfe:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103d01:	c7 05 5c 89 11 c0 88 	movl   $0xc0106a88,0xc011895c
c0103d08:	6a 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103d0b:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d10:	8b 00                	mov    (%eax),%eax
c0103d12:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103d16:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c0103d1d:	e8 1a c6 ff ff       	call   c010033c <cprintf>
    pmm_manager->init();
c0103d22:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d27:	8b 40 04             	mov    0x4(%eax),%eax
c0103d2a:	ff d0                	call   *%eax
}
c0103d2c:	c9                   	leave  
c0103d2d:	c3                   	ret    

c0103d2e <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103d2e:	55                   	push   %ebp
c0103d2f:	89 e5                	mov    %esp,%ebp
c0103d31:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103d34:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d39:	8b 40 08             	mov    0x8(%eax),%eax
c0103d3c:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d3f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103d43:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d46:	89 14 24             	mov    %edx,(%esp)
c0103d49:	ff d0                	call   *%eax
}
c0103d4b:	c9                   	leave  
c0103d4c:	c3                   	ret    

c0103d4d <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103d4d:	55                   	push   %ebp
c0103d4e:	89 e5                	mov    %esp,%ebp
c0103d50:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103d53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d5a:	e8 2e fe ff ff       	call   c0103b8d <__intr_save>
c0103d5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103d62:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d67:	8b 40 0c             	mov    0xc(%eax),%eax
c0103d6a:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d6d:	89 14 24             	mov    %edx,(%esp)
c0103d70:	ff d0                	call   *%eax
c0103d72:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103d75:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d78:	89 04 24             	mov    %eax,(%esp)
c0103d7b:	e8 37 fe ff ff       	call   c0103bb7 <__intr_restore>
    return page;
c0103d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103d83:	c9                   	leave  
c0103d84:	c3                   	ret    

c0103d85 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103d85:	55                   	push   %ebp
c0103d86:	89 e5                	mov    %esp,%ebp
c0103d88:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d8b:	e8 fd fd ff ff       	call   c0103b8d <__intr_save>
c0103d90:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103d93:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d98:	8b 40 10             	mov    0x10(%eax),%eax
c0103d9b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d9e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103da2:	8b 55 08             	mov    0x8(%ebp),%edx
c0103da5:	89 14 24             	mov    %edx,(%esp)
c0103da8:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103dad:	89 04 24             	mov    %eax,(%esp)
c0103db0:	e8 02 fe ff ff       	call   c0103bb7 <__intr_restore>
}
c0103db5:	c9                   	leave  
c0103db6:	c3                   	ret    

c0103db7 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103db7:	55                   	push   %ebp
c0103db8:	89 e5                	mov    %esp,%ebp
c0103dba:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103dbd:	e8 cb fd ff ff       	call   c0103b8d <__intr_save>
c0103dc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103dc5:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103dca:	8b 40 14             	mov    0x14(%eax),%eax
c0103dcd:	ff d0                	call   *%eax
c0103dcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103dd5:	89 04 24             	mov    %eax,(%esp)
c0103dd8:	e8 da fd ff ff       	call   c0103bb7 <__intr_restore>
    return ret;
c0103ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103de0:	c9                   	leave  
c0103de1:	c3                   	ret    

c0103de2 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103de2:	55                   	push   %ebp
c0103de3:	89 e5                	mov    %esp,%ebp
c0103de5:	57                   	push   %edi
c0103de6:	56                   	push   %esi
c0103de7:	53                   	push   %ebx
c0103de8:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103dee:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103df5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103dfc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103e03:	c7 04 24 3b 6b 10 c0 	movl   $0xc0106b3b,(%esp)
c0103e0a:	e8 2d c5 ff ff       	call   c010033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103e0f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103e16:	e9 15 01 00 00       	jmp    c0103f30 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103e1b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e1e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e21:	89 d0                	mov    %edx,%eax
c0103e23:	c1 e0 02             	shl    $0x2,%eax
c0103e26:	01 d0                	add    %edx,%eax
c0103e28:	c1 e0 02             	shl    $0x2,%eax
c0103e2b:	01 c8                	add    %ecx,%eax
c0103e2d:	8b 50 08             	mov    0x8(%eax),%edx
c0103e30:	8b 40 04             	mov    0x4(%eax),%eax
c0103e33:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103e36:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103e39:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e3f:	89 d0                	mov    %edx,%eax
c0103e41:	c1 e0 02             	shl    $0x2,%eax
c0103e44:	01 d0                	add    %edx,%eax
c0103e46:	c1 e0 02             	shl    $0x2,%eax
c0103e49:	01 c8                	add    %ecx,%eax
c0103e4b:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103e4e:	8b 58 10             	mov    0x10(%eax),%ebx
c0103e51:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103e54:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103e57:	01 c8                	add    %ecx,%eax
c0103e59:	11 da                	adc    %ebx,%edx
c0103e5b:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103e5e:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103e61:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e64:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e67:	89 d0                	mov    %edx,%eax
c0103e69:	c1 e0 02             	shl    $0x2,%eax
c0103e6c:	01 d0                	add    %edx,%eax
c0103e6e:	c1 e0 02             	shl    $0x2,%eax
c0103e71:	01 c8                	add    %ecx,%eax
c0103e73:	83 c0 14             	add    $0x14,%eax
c0103e76:	8b 00                	mov    (%eax),%eax
c0103e78:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0103e7e:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103e81:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103e84:	83 c0 ff             	add    $0xffffffff,%eax
c0103e87:	83 d2 ff             	adc    $0xffffffff,%edx
c0103e8a:	89 c6                	mov    %eax,%esi
c0103e8c:	89 d7                	mov    %edx,%edi
c0103e8e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e91:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e94:	89 d0                	mov    %edx,%eax
c0103e96:	c1 e0 02             	shl    $0x2,%eax
c0103e99:	01 d0                	add    %edx,%eax
c0103e9b:	c1 e0 02             	shl    $0x2,%eax
c0103e9e:	01 c8                	add    %ecx,%eax
c0103ea0:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103ea3:	8b 58 10             	mov    0x10(%eax),%ebx
c0103ea6:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103eac:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103eb0:	89 74 24 14          	mov    %esi,0x14(%esp)
c0103eb4:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0103eb8:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103ebb:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103ebe:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103ec2:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103ec6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103eca:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0103ece:	c7 04 24 48 6b 10 c0 	movl   $0xc0106b48,(%esp)
c0103ed5:	e8 62 c4 ff ff       	call   c010033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103eda:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103edd:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ee0:	89 d0                	mov    %edx,%eax
c0103ee2:	c1 e0 02             	shl    $0x2,%eax
c0103ee5:	01 d0                	add    %edx,%eax
c0103ee7:	c1 e0 02             	shl    $0x2,%eax
c0103eea:	01 c8                	add    %ecx,%eax
c0103eec:	83 c0 14             	add    $0x14,%eax
c0103eef:	8b 00                	mov    (%eax),%eax
c0103ef1:	83 f8 01             	cmp    $0x1,%eax
c0103ef4:	75 36                	jne    c0103f2c <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0103ef6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103ef9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103efc:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103eff:	77 2b                	ja     c0103f2c <page_init+0x14a>
c0103f01:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103f04:	72 05                	jb     c0103f0b <page_init+0x129>
c0103f06:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0103f09:	73 21                	jae    c0103f2c <page_init+0x14a>
c0103f0b:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103f0f:	77 1b                	ja     c0103f2c <page_init+0x14a>
c0103f11:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103f15:	72 09                	jb     c0103f20 <page_init+0x13e>
c0103f17:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0103f1e:	77 0c                	ja     c0103f2c <page_init+0x14a>
                maxpa = end;
c0103f20:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103f23:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103f26:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103f29:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103f2c:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103f30:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103f33:	8b 00                	mov    (%eax),%eax
c0103f35:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103f38:	0f 8f dd fe ff ff    	jg     c0103e1b <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103f3e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103f42:	72 1d                	jb     c0103f61 <page_init+0x17f>
c0103f44:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103f48:	77 09                	ja     c0103f53 <page_init+0x171>
c0103f4a:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0103f51:	76 0e                	jbe    c0103f61 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0103f53:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103f5a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0103f61:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103f64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103f67:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103f6b:	c1 ea 0c             	shr    $0xc,%edx
c0103f6e:	a3 c0 88 11 c0       	mov    %eax,0xc01188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103f73:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0103f7a:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c0103f7f:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103f82:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103f85:	01 d0                	add    %edx,%eax
c0103f87:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103f8a:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103f8d:	ba 00 00 00 00       	mov    $0x0,%edx
c0103f92:	f7 75 ac             	divl   -0x54(%ebp)
c0103f95:	89 d0                	mov    %edx,%eax
c0103f97:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103f9a:	29 c2                	sub    %eax,%edx
c0103f9c:	89 d0                	mov    %edx,%eax
c0103f9e:	a3 64 89 11 c0       	mov    %eax,0xc0118964

    for (i = 0; i < npage; i ++) {
c0103fa3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103faa:	eb 2f                	jmp    c0103fdb <page_init+0x1f9>
        SetPageReserved(pages + i);
c0103fac:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0103fb2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fb5:	89 d0                	mov    %edx,%eax
c0103fb7:	c1 e0 02             	shl    $0x2,%eax
c0103fba:	01 d0                	add    %edx,%eax
c0103fbc:	c1 e0 02             	shl    $0x2,%eax
c0103fbf:	01 c8                	add    %ecx,%eax
c0103fc1:	83 c0 04             	add    $0x4,%eax
c0103fc4:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0103fcb:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103fce:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103fd1:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103fd4:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0103fd7:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103fdb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fde:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103fe3:	39 c2                	cmp    %eax,%edx
c0103fe5:	72 c5                	jb     c0103fac <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0103fe7:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0103fed:	89 d0                	mov    %edx,%eax
c0103fef:	c1 e0 02             	shl    $0x2,%eax
c0103ff2:	01 d0                	add    %edx,%eax
c0103ff4:	c1 e0 02             	shl    $0x2,%eax
c0103ff7:	89 c2                	mov    %eax,%edx
c0103ff9:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0103ffe:	01 d0                	add    %edx,%eax
c0104000:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0104003:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c010400a:	77 23                	ja     c010402f <page_init+0x24d>
c010400c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010400f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104013:	c7 44 24 08 78 6b 10 	movl   $0xc0106b78,0x8(%esp)
c010401a:	c0 
c010401b:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0104022:	00 
c0104023:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c010402a:	e8 9c cc ff ff       	call   c0100ccb <__panic>
c010402f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104032:	05 00 00 00 40       	add    $0x40000000,%eax
c0104037:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c010403a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104041:	e9 74 01 00 00       	jmp    c01041ba <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104046:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104049:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010404c:	89 d0                	mov    %edx,%eax
c010404e:	c1 e0 02             	shl    $0x2,%eax
c0104051:	01 d0                	add    %edx,%eax
c0104053:	c1 e0 02             	shl    $0x2,%eax
c0104056:	01 c8                	add    %ecx,%eax
c0104058:	8b 50 08             	mov    0x8(%eax),%edx
c010405b:	8b 40 04             	mov    0x4(%eax),%eax
c010405e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104061:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104064:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104067:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010406a:	89 d0                	mov    %edx,%eax
c010406c:	c1 e0 02             	shl    $0x2,%eax
c010406f:	01 d0                	add    %edx,%eax
c0104071:	c1 e0 02             	shl    $0x2,%eax
c0104074:	01 c8                	add    %ecx,%eax
c0104076:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104079:	8b 58 10             	mov    0x10(%eax),%ebx
c010407c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010407f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104082:	01 c8                	add    %ecx,%eax
c0104084:	11 da                	adc    %ebx,%edx
c0104086:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104089:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c010408c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010408f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104092:	89 d0                	mov    %edx,%eax
c0104094:	c1 e0 02             	shl    $0x2,%eax
c0104097:	01 d0                	add    %edx,%eax
c0104099:	c1 e0 02             	shl    $0x2,%eax
c010409c:	01 c8                	add    %ecx,%eax
c010409e:	83 c0 14             	add    $0x14,%eax
c01040a1:	8b 00                	mov    (%eax),%eax
c01040a3:	83 f8 01             	cmp    $0x1,%eax
c01040a6:	0f 85 0a 01 00 00    	jne    c01041b6 <page_init+0x3d4>
            if (begin < freemem) {
c01040ac:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01040af:	ba 00 00 00 00       	mov    $0x0,%edx
c01040b4:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01040b7:	72 17                	jb     c01040d0 <page_init+0x2ee>
c01040b9:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01040bc:	77 05                	ja     c01040c3 <page_init+0x2e1>
c01040be:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01040c1:	76 0d                	jbe    c01040d0 <page_init+0x2ee>
                begin = freemem;
c01040c3:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01040c6:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01040c9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c01040d0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01040d4:	72 1d                	jb     c01040f3 <page_init+0x311>
c01040d6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01040da:	77 09                	ja     c01040e5 <page_init+0x303>
c01040dc:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c01040e3:	76 0e                	jbe    c01040f3 <page_init+0x311>
                end = KMEMSIZE;
c01040e5:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01040ec:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01040f3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01040f6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01040f9:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01040fc:	0f 87 b4 00 00 00    	ja     c01041b6 <page_init+0x3d4>
c0104102:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104105:	72 09                	jb     c0104110 <page_init+0x32e>
c0104107:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010410a:	0f 83 a6 00 00 00    	jae    c01041b6 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c0104110:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0104117:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010411a:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010411d:	01 d0                	add    %edx,%eax
c010411f:	83 e8 01             	sub    $0x1,%eax
c0104122:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104125:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104128:	ba 00 00 00 00       	mov    $0x0,%edx
c010412d:	f7 75 9c             	divl   -0x64(%ebp)
c0104130:	89 d0                	mov    %edx,%eax
c0104132:	8b 55 98             	mov    -0x68(%ebp),%edx
c0104135:	29 c2                	sub    %eax,%edx
c0104137:	89 d0                	mov    %edx,%eax
c0104139:	ba 00 00 00 00       	mov    $0x0,%edx
c010413e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104141:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104144:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104147:	89 45 94             	mov    %eax,-0x6c(%ebp)
c010414a:	8b 45 94             	mov    -0x6c(%ebp),%eax
c010414d:	ba 00 00 00 00       	mov    $0x0,%edx
c0104152:	89 c7                	mov    %eax,%edi
c0104154:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c010415a:	89 7d 80             	mov    %edi,-0x80(%ebp)
c010415d:	89 d0                	mov    %edx,%eax
c010415f:	83 e0 00             	and    $0x0,%eax
c0104162:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104165:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104168:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010416b:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010416e:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0104171:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104174:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104177:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010417a:	77 3a                	ja     c01041b6 <page_init+0x3d4>
c010417c:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010417f:	72 05                	jb     c0104186 <page_init+0x3a4>
c0104181:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104184:	73 30                	jae    c01041b6 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0104186:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0104189:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c010418c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010418f:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104192:	29 c8                	sub    %ecx,%eax
c0104194:	19 da                	sbb    %ebx,%edx
c0104196:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010419a:	c1 ea 0c             	shr    $0xc,%edx
c010419d:	89 c3                	mov    %eax,%ebx
c010419f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01041a2:	89 04 24             	mov    %eax,(%esp)
c01041a5:	e8 a5 f8 ff ff       	call   c0103a4f <pa2page>
c01041aa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01041ae:	89 04 24             	mov    %eax,(%esp)
c01041b1:	e8 78 fb ff ff       	call   c0103d2e <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c01041b6:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01041ba:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01041bd:	8b 00                	mov    (%eax),%eax
c01041bf:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01041c2:	0f 8f 7e fe ff ff    	jg     c0104046 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c01041c8:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c01041ce:	5b                   	pop    %ebx
c01041cf:	5e                   	pop    %esi
c01041d0:	5f                   	pop    %edi
c01041d1:	5d                   	pop    %ebp
c01041d2:	c3                   	ret    

c01041d3 <enable_paging>:

static void
enable_paging(void) {
c01041d3:	55                   	push   %ebp
c01041d4:	89 e5                	mov    %esp,%ebp
c01041d6:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c01041d9:	a1 60 89 11 c0       	mov    0xc0118960,%eax
c01041de:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c01041e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01041e4:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c01041e7:	0f 20 c0             	mov    %cr0,%eax
c01041ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c01041ed:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c01041f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c01041f3:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c01041fa:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c01041fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104201:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c0104204:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104207:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c010420a:	c9                   	leave  
c010420b:	c3                   	ret    

c010420c <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c010420c:	55                   	push   %ebp
c010420d:	89 e5                	mov    %esp,%ebp
c010420f:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0104212:	8b 45 14             	mov    0x14(%ebp),%eax
c0104215:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104218:	31 d0                	xor    %edx,%eax
c010421a:	25 ff 0f 00 00       	and    $0xfff,%eax
c010421f:	85 c0                	test   %eax,%eax
c0104221:	74 24                	je     c0104247 <boot_map_segment+0x3b>
c0104223:	c7 44 24 0c aa 6b 10 	movl   $0xc0106baa,0xc(%esp)
c010422a:	c0 
c010422b:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104232:	c0 
c0104233:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c010423a:	00 
c010423b:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104242:	e8 84 ca ff ff       	call   c0100ccb <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0104247:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c010424e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104251:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104256:	89 c2                	mov    %eax,%edx
c0104258:	8b 45 10             	mov    0x10(%ebp),%eax
c010425b:	01 c2                	add    %eax,%edx
c010425d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104260:	01 d0                	add    %edx,%eax
c0104262:	83 e8 01             	sub    $0x1,%eax
c0104265:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104268:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010426b:	ba 00 00 00 00       	mov    $0x0,%edx
c0104270:	f7 75 f0             	divl   -0x10(%ebp)
c0104273:	89 d0                	mov    %edx,%eax
c0104275:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104278:	29 c2                	sub    %eax,%edx
c010427a:	89 d0                	mov    %edx,%eax
c010427c:	c1 e8 0c             	shr    $0xc,%eax
c010427f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104282:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104285:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104288:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010428b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104290:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104293:	8b 45 14             	mov    0x14(%ebp),%eax
c0104296:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104299:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010429c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01042a1:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01042a4:	eb 6b                	jmp    c0104311 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01042a6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01042ad:	00 
c01042ae:	8b 45 0c             	mov    0xc(%ebp),%eax
c01042b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01042b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01042b8:	89 04 24             	mov    %eax,(%esp)
c01042bb:	e8 cc 01 00 00       	call   c010448c <get_pte>
c01042c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01042c3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01042c7:	75 24                	jne    c01042ed <boot_map_segment+0xe1>
c01042c9:	c7 44 24 0c d6 6b 10 	movl   $0xc0106bd6,0xc(%esp)
c01042d0:	c0 
c01042d1:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c01042d8:	c0 
c01042d9:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c01042e0:	00 
c01042e1:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c01042e8:	e8 de c9 ff ff       	call   c0100ccb <__panic>
        *ptep = pa | PTE_P | perm;
c01042ed:	8b 45 18             	mov    0x18(%ebp),%eax
c01042f0:	8b 55 14             	mov    0x14(%ebp),%edx
c01042f3:	09 d0                	or     %edx,%eax
c01042f5:	83 c8 01             	or     $0x1,%eax
c01042f8:	89 c2                	mov    %eax,%edx
c01042fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01042fd:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01042ff:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104303:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c010430a:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104311:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104315:	75 8f                	jne    c01042a6 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0104317:	c9                   	leave  
c0104318:	c3                   	ret    

c0104319 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0104319:	55                   	push   %ebp
c010431a:	89 e5                	mov    %esp,%ebp
c010431c:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c010431f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104326:	e8 22 fa ff ff       	call   c0103d4d <alloc_pages>
c010432b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c010432e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104332:	75 1c                	jne    c0104350 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104334:	c7 44 24 08 e3 6b 10 	movl   $0xc0106be3,0x8(%esp)
c010433b:	c0 
c010433c:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0104343:	00 
c0104344:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c010434b:	e8 7b c9 ff ff       	call   c0100ccb <__panic>
    }
    return page2kva(p);
c0104350:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104353:	89 04 24             	mov    %eax,(%esp)
c0104356:	e8 43 f7 ff ff       	call   c0103a9e <page2kva>
}
c010435b:	c9                   	leave  
c010435c:	c3                   	ret    

c010435d <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c010435d:	55                   	push   %ebp
c010435e:	89 e5                	mov    %esp,%ebp
c0104360:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104363:	e8 93 f9 ff ff       	call   c0103cfb <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0104368:	e8 75 fa ff ff       	call   c0103de2 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c010436d:	e8 75 04 00 00       	call   c01047e7 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0104372:	e8 a2 ff ff ff       	call   c0104319 <boot_alloc_page>
c0104377:	a3 c4 88 11 c0       	mov    %eax,0xc01188c4
    memset(boot_pgdir, 0, PGSIZE);
c010437c:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104381:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104388:	00 
c0104389:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104390:	00 
c0104391:	89 04 24             	mov    %eax,(%esp)
c0104394:	e8 b2 1a 00 00       	call   c0105e4b <memset>
    boot_cr3 = PADDR(boot_pgdir);
c0104399:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010439e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01043a1:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01043a8:	77 23                	ja     c01043cd <pmm_init+0x70>
c01043aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043ad:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01043b1:	c7 44 24 08 78 6b 10 	movl   $0xc0106b78,0x8(%esp)
c01043b8:	c0 
c01043b9:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c01043c0:	00 
c01043c1:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c01043c8:	e8 fe c8 ff ff       	call   c0100ccb <__panic>
c01043cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043d0:	05 00 00 00 40       	add    $0x40000000,%eax
c01043d5:	a3 60 89 11 c0       	mov    %eax,0xc0118960

    check_pgdir();
c01043da:	e8 26 04 00 00       	call   c0104805 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01043df:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043e4:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01043ea:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01043f2:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01043f9:	77 23                	ja     c010441e <pmm_init+0xc1>
c01043fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043fe:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104402:	c7 44 24 08 78 6b 10 	movl   $0xc0106b78,0x8(%esp)
c0104409:	c0 
c010440a:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c0104411:	00 
c0104412:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104419:	e8 ad c8 ff ff       	call   c0100ccb <__panic>
c010441e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104421:	05 00 00 00 40       	add    $0x40000000,%eax
c0104426:	83 c8 03             	or     $0x3,%eax
c0104429:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010442b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104430:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0104437:	00 
c0104438:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010443f:	00 
c0104440:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0104447:	38 
c0104448:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c010444f:	c0 
c0104450:	89 04 24             	mov    %eax,(%esp)
c0104453:	e8 b4 fd ff ff       	call   c010420c <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c0104458:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010445d:	8b 15 c4 88 11 c0    	mov    0xc01188c4,%edx
c0104463:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c0104469:	89 10                	mov    %edx,(%eax)

    enable_paging();
c010446b:	e8 63 fd ff ff       	call   c01041d3 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104470:	e8 97 f7 ff ff       	call   c0103c0c <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0104475:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010447a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104480:	e8 1b 0a 00 00       	call   c0104ea0 <check_boot_pgdir>

    print_pgdir();
c0104485:	e8 a3 0e 00 00       	call   c010532d <print_pgdir>

}
c010448a:	c9                   	leave  
c010448b:	c3                   	ret    

c010448c <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c010448c:	55                   	push   %ebp
c010448d:	89 e5                	mov    %esp,%ebp
c010448f:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];   // (1) find page directory entry
c0104492:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104495:	c1 e8 16             	shr    $0x16,%eax
c0104498:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010449f:	8b 45 08             	mov    0x8(%ebp),%eax
c01044a2:	01 d0                	add    %edx,%eax
c01044a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if ((PTE_P & *pdep) == 0) {              // (2) check if entry is not present
c01044a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044aa:	8b 00                	mov    (%eax),%eax
c01044ac:	83 e0 01             	and    $0x1,%eax
c01044af:	85 c0                	test   %eax,%eax
c01044b1:	0f 85 b9 00 00 00    	jne    c0104570 <get_pte+0xe4>
    	if(!create)        // (3) check if creating is needed, then alloc page for page table
c01044b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01044bb:	75 0a                	jne    c01044c7 <get_pte+0x3b>
    		return NULL;
c01044bd:	b8 00 00 00 00       	mov    $0x0,%eax
c01044c2:	e9 05 01 00 00       	jmp    c01045cc <get_pte+0x140>
    	struct Page *page = alloc_page();
c01044c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01044ce:	e8 7a f8 ff ff       	call   c0103d4d <alloc_pages>
c01044d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	if(page == NULL)
c01044d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01044da:	75 0a                	jne    c01044e6 <get_pte+0x5a>
    		return NULL;
c01044dc:	b8 00 00 00 00       	mov    $0x0,%eax
c01044e1:	e9 e6 00 00 00       	jmp    c01045cc <get_pte+0x140>
                          // CAUTION: this page is used for page table, not for common data page
    	set_page_ref(page,1); // (4) set page reference
c01044e6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01044ed:	00 
c01044ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01044f1:	89 04 24             	mov    %eax,(%esp)
c01044f4:	e8 59 f6 ff ff       	call   c0103b52 <set_page_ref>

        uintptr_t pa = page2pa(page); // (5) get linear address of page
c01044f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01044fc:	89 04 24             	mov    %eax,(%esp)
c01044ff:	e8 35 f5 ff ff       	call   c0103a39 <page2pa>
c0104504:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);  // (6) clear page content using memset
c0104507:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010450a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010450d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104510:	c1 e8 0c             	shr    $0xc,%eax
c0104513:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104516:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c010451b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010451e:	72 23                	jb     c0104543 <get_pte+0xb7>
c0104520:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104523:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104527:	c7 44 24 08 d4 6a 10 	movl   $0xc0106ad4,0x8(%esp)
c010452e:	c0 
c010452f:	c7 44 24 04 8a 01 00 	movl   $0x18a,0x4(%esp)
c0104536:	00 
c0104537:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c010453e:	e8 88 c7 ff ff       	call   c0100ccb <__panic>
c0104543:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104546:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010454b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104552:	00 
c0104553:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010455a:	00 
c010455b:	89 04 24             	mov    %eax,(%esp)
c010455e:	e8 e8 18 00 00       	call   c0105e4b <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P; // (7) set page directory entry's permission
c0104563:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104566:	83 c8 07             	or     $0x7,%eax
c0104569:	89 c2                	mov    %eax,%edx
c010456b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010456e:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];          // (8) return page table entry
c0104570:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104573:	8b 00                	mov    (%eax),%eax
c0104575:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010457a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010457d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104580:	c1 e8 0c             	shr    $0xc,%eax
c0104583:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104586:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c010458b:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010458e:	72 23                	jb     c01045b3 <get_pte+0x127>
c0104590:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104593:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104597:	c7 44 24 08 d4 6a 10 	movl   $0xc0106ad4,0x8(%esp)
c010459e:	c0 
c010459f:	c7 44 24 04 8d 01 00 	movl   $0x18d,0x4(%esp)
c01045a6:	00 
c01045a7:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c01045ae:	e8 18 c7 ff ff       	call   c0100ccb <__panic>
c01045b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01045b6:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01045bb:	8b 55 0c             	mov    0xc(%ebp),%edx
c01045be:	c1 ea 0c             	shr    $0xc,%edx
c01045c1:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c01045c7:	c1 e2 02             	shl    $0x2,%edx
c01045ca:	01 d0                	add    %edx,%eax

}
c01045cc:	c9                   	leave  
c01045cd:	c3                   	ret    

c01045ce <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01045ce:	55                   	push   %ebp
c01045cf:	89 e5                	mov    %esp,%ebp
c01045d1:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01045d4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01045db:	00 
c01045dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045df:	89 44 24 04          	mov    %eax,0x4(%esp)
c01045e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01045e6:	89 04 24             	mov    %eax,(%esp)
c01045e9:	e8 9e fe ff ff       	call   c010448c <get_pte>
c01045ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01045f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01045f5:	74 08                	je     c01045ff <get_page+0x31>
        *ptep_store = ptep;
c01045f7:	8b 45 10             	mov    0x10(%ebp),%eax
c01045fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01045fd:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01045ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104603:	74 1b                	je     c0104620 <get_page+0x52>
c0104605:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104608:	8b 00                	mov    (%eax),%eax
c010460a:	83 e0 01             	and    $0x1,%eax
c010460d:	85 c0                	test   %eax,%eax
c010460f:	74 0f                	je     c0104620 <get_page+0x52>
        return pte2page(*ptep);
c0104611:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104614:	8b 00                	mov    (%eax),%eax
c0104616:	89 04 24             	mov    %eax,(%esp)
c0104619:	e8 d4 f4 ff ff       	call   c0103af2 <pte2page>
c010461e:	eb 05                	jmp    c0104625 <get_page+0x57>
    }
    return NULL;
c0104620:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104625:	c9                   	leave  
c0104626:	c3                   	ret    

c0104627 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0104627:	55                   	push   %ebp
c0104628:	89 e5                	mov    %esp,%ebp
c010462a:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {                      //(1) check if this page table entry is present
c010462d:	8b 45 10             	mov    0x10(%ebp),%eax
c0104630:	8b 00                	mov    (%eax),%eax
c0104632:	83 e0 01             	and    $0x1,%eax
c0104635:	85 c0                	test   %eax,%eax
c0104637:	74 52                	je     c010468b <page_remove_pte+0x64>
        struct Page *page = pte2page(*ptep); //(2) find corresponding page to pte
c0104639:	8b 45 10             	mov    0x10(%ebp),%eax
c010463c:	8b 00                	mov    (%eax),%eax
c010463e:	89 04 24             	mov    %eax,(%esp)
c0104641:	e8 ac f4 ff ff       	call   c0103af2 <pte2page>
c0104646:	89 45 f4             	mov    %eax,-0xc(%ebp)
        page_ref_dec(page);                          //(3) decrease page reference
c0104649:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010464c:	89 04 24             	mov    %eax,(%esp)
c010464f:	e8 22 f5 ff ff       	call   c0103b76 <page_ref_dec>
        if(page->ref == 0)              //(4) and free this page when page reference reachs 0
c0104654:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104657:	8b 00                	mov    (%eax),%eax
c0104659:	85 c0                	test   %eax,%eax
c010465b:	75 13                	jne    c0104670 <page_remove_pte+0x49>
        	free_page(page);
c010465d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104664:	00 
c0104665:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104668:	89 04 24             	mov    %eax,(%esp)
c010466b:	e8 15 f7 ff ff       	call   c0103d85 <free_pages>
        *ptep = 0;                      //(5) clear second page table entry
c0104670:	8b 45 10             	mov    0x10(%ebp),%eax
c0104673:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);     //(6) flush tlb
c0104679:	8b 45 0c             	mov    0xc(%ebp),%eax
c010467c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104680:	8b 45 08             	mov    0x8(%ebp),%eax
c0104683:	89 04 24             	mov    %eax,(%esp)
c0104686:	e8 ff 00 00 00       	call   c010478a <tlb_invalidate>
    }
}
c010468b:	c9                   	leave  
c010468c:	c3                   	ret    

c010468d <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c010468d:	55                   	push   %ebp
c010468e:	89 e5                	mov    %esp,%ebp
c0104690:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104693:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010469a:	00 
c010469b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010469e:	89 44 24 04          	mov    %eax,0x4(%esp)
c01046a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01046a5:	89 04 24             	mov    %eax,(%esp)
c01046a8:	e8 df fd ff ff       	call   c010448c <get_pte>
c01046ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c01046b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01046b4:	74 19                	je     c01046cf <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c01046b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046b9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01046bd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01046c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01046c7:	89 04 24             	mov    %eax,(%esp)
c01046ca:	e8 58 ff ff ff       	call   c0104627 <page_remove_pte>
    }
}
c01046cf:	c9                   	leave  
c01046d0:	c3                   	ret    

c01046d1 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01046d1:	55                   	push   %ebp
c01046d2:	89 e5                	mov    %esp,%ebp
c01046d4:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01046d7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01046de:	00 
c01046df:	8b 45 10             	mov    0x10(%ebp),%eax
c01046e2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01046e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01046e9:	89 04 24             	mov    %eax,(%esp)
c01046ec:	e8 9b fd ff ff       	call   c010448c <get_pte>
c01046f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01046f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01046f8:	75 0a                	jne    c0104704 <page_insert+0x33>
        return -E_NO_MEM;
c01046fa:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01046ff:	e9 84 00 00 00       	jmp    c0104788 <page_insert+0xb7>
    }
    page_ref_inc(page);
c0104704:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104707:	89 04 24             	mov    %eax,(%esp)
c010470a:	e8 50 f4 ff ff       	call   c0103b5f <page_ref_inc>
    if (*ptep & PTE_P) {
c010470f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104712:	8b 00                	mov    (%eax),%eax
c0104714:	83 e0 01             	and    $0x1,%eax
c0104717:	85 c0                	test   %eax,%eax
c0104719:	74 3e                	je     c0104759 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c010471b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010471e:	8b 00                	mov    (%eax),%eax
c0104720:	89 04 24             	mov    %eax,(%esp)
c0104723:	e8 ca f3 ff ff       	call   c0103af2 <pte2page>
c0104728:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c010472b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010472e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104731:	75 0d                	jne    c0104740 <page_insert+0x6f>
            page_ref_dec(page);
c0104733:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104736:	89 04 24             	mov    %eax,(%esp)
c0104739:	e8 38 f4 ff ff       	call   c0103b76 <page_ref_dec>
c010473e:	eb 19                	jmp    c0104759 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0104740:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104743:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104747:	8b 45 10             	mov    0x10(%ebp),%eax
c010474a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010474e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104751:	89 04 24             	mov    %eax,(%esp)
c0104754:	e8 ce fe ff ff       	call   c0104627 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0104759:	8b 45 0c             	mov    0xc(%ebp),%eax
c010475c:	89 04 24             	mov    %eax,(%esp)
c010475f:	e8 d5 f2 ff ff       	call   c0103a39 <page2pa>
c0104764:	0b 45 14             	or     0x14(%ebp),%eax
c0104767:	83 c8 01             	or     $0x1,%eax
c010476a:	89 c2                	mov    %eax,%edx
c010476c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010476f:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0104771:	8b 45 10             	mov    0x10(%ebp),%eax
c0104774:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104778:	8b 45 08             	mov    0x8(%ebp),%eax
c010477b:	89 04 24             	mov    %eax,(%esp)
c010477e:	e8 07 00 00 00       	call   c010478a <tlb_invalidate>
    return 0;
c0104783:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104788:	c9                   	leave  
c0104789:	c3                   	ret    

c010478a <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c010478a:	55                   	push   %ebp
c010478b:	89 e5                	mov    %esp,%ebp
c010478d:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0104790:	0f 20 d8             	mov    %cr3,%eax
c0104793:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0104796:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0104799:	89 c2                	mov    %eax,%edx
c010479b:	8b 45 08             	mov    0x8(%ebp),%eax
c010479e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01047a1:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01047a8:	77 23                	ja     c01047cd <tlb_invalidate+0x43>
c01047aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047ad:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01047b1:	c7 44 24 08 78 6b 10 	movl   $0xc0106b78,0x8(%esp)
c01047b8:	c0 
c01047b9:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
c01047c0:	00 
c01047c1:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c01047c8:	e8 fe c4 ff ff       	call   c0100ccb <__panic>
c01047cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047d0:	05 00 00 00 40       	add    $0x40000000,%eax
c01047d5:	39 c2                	cmp    %eax,%edx
c01047d7:	75 0c                	jne    c01047e5 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c01047d9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01047df:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047e2:	0f 01 38             	invlpg (%eax)
    }
}
c01047e5:	c9                   	leave  
c01047e6:	c3                   	ret    

c01047e7 <check_alloc_page>:

static void
check_alloc_page(void) {
c01047e7:	55                   	push   %ebp
c01047e8:	89 e5                	mov    %esp,%ebp
c01047ea:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01047ed:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c01047f2:	8b 40 18             	mov    0x18(%eax),%eax
c01047f5:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01047f7:	c7 04 24 fc 6b 10 c0 	movl   $0xc0106bfc,(%esp)
c01047fe:	e8 39 bb ff ff       	call   c010033c <cprintf>
}
c0104803:	c9                   	leave  
c0104804:	c3                   	ret    

c0104805 <check_pgdir>:

static void
check_pgdir(void) {
c0104805:	55                   	push   %ebp
c0104806:	89 e5                	mov    %esp,%ebp
c0104808:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c010480b:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104810:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0104815:	76 24                	jbe    c010483b <check_pgdir+0x36>
c0104817:	c7 44 24 0c 1b 6c 10 	movl   $0xc0106c1b,0xc(%esp)
c010481e:	c0 
c010481f:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104826:	c0 
c0104827:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c010482e:	00 
c010482f:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104836:	e8 90 c4 ff ff       	call   c0100ccb <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010483b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104840:	85 c0                	test   %eax,%eax
c0104842:	74 0e                	je     c0104852 <check_pgdir+0x4d>
c0104844:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104849:	25 ff 0f 00 00       	and    $0xfff,%eax
c010484e:	85 c0                	test   %eax,%eax
c0104850:	74 24                	je     c0104876 <check_pgdir+0x71>
c0104852:	c7 44 24 0c 38 6c 10 	movl   $0xc0106c38,0xc(%esp)
c0104859:	c0 
c010485a:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104861:	c0 
c0104862:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c0104869:	00 
c010486a:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104871:	e8 55 c4 ff ff       	call   c0100ccb <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0104876:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010487b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104882:	00 
c0104883:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010488a:	00 
c010488b:	89 04 24             	mov    %eax,(%esp)
c010488e:	e8 3b fd ff ff       	call   c01045ce <get_page>
c0104893:	85 c0                	test   %eax,%eax
c0104895:	74 24                	je     c01048bb <check_pgdir+0xb6>
c0104897:	c7 44 24 0c 70 6c 10 	movl   $0xc0106c70,0xc(%esp)
c010489e:	c0 
c010489f:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c01048a6:	c0 
c01048a7:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c01048ae:	00 
c01048af:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c01048b6:	e8 10 c4 ff ff       	call   c0100ccb <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01048bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01048c2:	e8 86 f4 ff ff       	call   c0103d4d <alloc_pages>
c01048c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01048ca:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01048cf:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01048d6:	00 
c01048d7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01048de:	00 
c01048df:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01048e2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01048e6:	89 04 24             	mov    %eax,(%esp)
c01048e9:	e8 e3 fd ff ff       	call   c01046d1 <page_insert>
c01048ee:	85 c0                	test   %eax,%eax
c01048f0:	74 24                	je     c0104916 <check_pgdir+0x111>
c01048f2:	c7 44 24 0c 98 6c 10 	movl   $0xc0106c98,0xc(%esp)
c01048f9:	c0 
c01048fa:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104901:	c0 
c0104902:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0104909:	00 
c010490a:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104911:	e8 b5 c3 ff ff       	call   c0100ccb <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0104916:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010491b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104922:	00 
c0104923:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010492a:	00 
c010492b:	89 04 24             	mov    %eax,(%esp)
c010492e:	e8 59 fb ff ff       	call   c010448c <get_pte>
c0104933:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104936:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010493a:	75 24                	jne    c0104960 <check_pgdir+0x15b>
c010493c:	c7 44 24 0c c4 6c 10 	movl   $0xc0106cc4,0xc(%esp)
c0104943:	c0 
c0104944:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c010494b:	c0 
c010494c:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
c0104953:	00 
c0104954:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c010495b:	e8 6b c3 ff ff       	call   c0100ccb <__panic>
    assert(pte2page(*ptep) == p1);
c0104960:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104963:	8b 00                	mov    (%eax),%eax
c0104965:	89 04 24             	mov    %eax,(%esp)
c0104968:	e8 85 f1 ff ff       	call   c0103af2 <pte2page>
c010496d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104970:	74 24                	je     c0104996 <check_pgdir+0x191>
c0104972:	c7 44 24 0c f1 6c 10 	movl   $0xc0106cf1,0xc(%esp)
c0104979:	c0 
c010497a:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104981:	c0 
c0104982:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0104989:	00 
c010498a:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104991:	e8 35 c3 ff ff       	call   c0100ccb <__panic>
    assert(page_ref(p1) == 1);
c0104996:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104999:	89 04 24             	mov    %eax,(%esp)
c010499c:	e8 a7 f1 ff ff       	call   c0103b48 <page_ref>
c01049a1:	83 f8 01             	cmp    $0x1,%eax
c01049a4:	74 24                	je     c01049ca <check_pgdir+0x1c5>
c01049a6:	c7 44 24 0c 07 6d 10 	movl   $0xc0106d07,0xc(%esp)
c01049ad:	c0 
c01049ae:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c01049b5:	c0 
c01049b6:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c01049bd:	00 
c01049be:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c01049c5:	e8 01 c3 ff ff       	call   c0100ccb <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01049ca:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01049cf:	8b 00                	mov    (%eax),%eax
c01049d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01049d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01049d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049dc:	c1 e8 0c             	shr    $0xc,%eax
c01049df:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01049e2:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01049e7:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01049ea:	72 23                	jb     c0104a0f <check_pgdir+0x20a>
c01049ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01049f3:	c7 44 24 08 d4 6a 10 	movl   $0xc0106ad4,0x8(%esp)
c01049fa:	c0 
c01049fb:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c0104a02:	00 
c0104a03:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104a0a:	e8 bc c2 ff ff       	call   c0100ccb <__panic>
c0104a0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a12:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104a17:	83 c0 04             	add    $0x4,%eax
c0104a1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0104a1d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a22:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a29:	00 
c0104a2a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104a31:	00 
c0104a32:	89 04 24             	mov    %eax,(%esp)
c0104a35:	e8 52 fa ff ff       	call   c010448c <get_pte>
c0104a3a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104a3d:	74 24                	je     c0104a63 <check_pgdir+0x25e>
c0104a3f:	c7 44 24 0c 1c 6d 10 	movl   $0xc0106d1c,0xc(%esp)
c0104a46:	c0 
c0104a47:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104a4e:	c0 
c0104a4f:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c0104a56:	00 
c0104a57:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104a5e:	e8 68 c2 ff ff       	call   c0100ccb <__panic>

    p2 = alloc_page();
c0104a63:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104a6a:	e8 de f2 ff ff       	call   c0103d4d <alloc_pages>
c0104a6f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0104a72:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a77:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104a7e:	00 
c0104a7f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104a86:	00 
c0104a87:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104a8a:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104a8e:	89 04 24             	mov    %eax,(%esp)
c0104a91:	e8 3b fc ff ff       	call   c01046d1 <page_insert>
c0104a96:	85 c0                	test   %eax,%eax
c0104a98:	74 24                	je     c0104abe <check_pgdir+0x2b9>
c0104a9a:	c7 44 24 0c 44 6d 10 	movl   $0xc0106d44,0xc(%esp)
c0104aa1:	c0 
c0104aa2:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104aa9:	c0 
c0104aaa:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0104ab1:	00 
c0104ab2:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104ab9:	e8 0d c2 ff ff       	call   c0100ccb <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104abe:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104ac3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104aca:	00 
c0104acb:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104ad2:	00 
c0104ad3:	89 04 24             	mov    %eax,(%esp)
c0104ad6:	e8 b1 f9 ff ff       	call   c010448c <get_pte>
c0104adb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ade:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104ae2:	75 24                	jne    c0104b08 <check_pgdir+0x303>
c0104ae4:	c7 44 24 0c 7c 6d 10 	movl   $0xc0106d7c,0xc(%esp)
c0104aeb:	c0 
c0104aec:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104af3:	c0 
c0104af4:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0104afb:	00 
c0104afc:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104b03:	e8 c3 c1 ff ff       	call   c0100ccb <__panic>
    assert(*ptep & PTE_U);
c0104b08:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b0b:	8b 00                	mov    (%eax),%eax
c0104b0d:	83 e0 04             	and    $0x4,%eax
c0104b10:	85 c0                	test   %eax,%eax
c0104b12:	75 24                	jne    c0104b38 <check_pgdir+0x333>
c0104b14:	c7 44 24 0c ac 6d 10 	movl   $0xc0106dac,0xc(%esp)
c0104b1b:	c0 
c0104b1c:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104b23:	c0 
c0104b24:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0104b2b:	00 
c0104b2c:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104b33:	e8 93 c1 ff ff       	call   c0100ccb <__panic>
    assert(*ptep & PTE_W);
c0104b38:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b3b:	8b 00                	mov    (%eax),%eax
c0104b3d:	83 e0 02             	and    $0x2,%eax
c0104b40:	85 c0                	test   %eax,%eax
c0104b42:	75 24                	jne    c0104b68 <check_pgdir+0x363>
c0104b44:	c7 44 24 0c ba 6d 10 	movl   $0xc0106dba,0xc(%esp)
c0104b4b:	c0 
c0104b4c:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104b53:	c0 
c0104b54:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c0104b5b:	00 
c0104b5c:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104b63:	e8 63 c1 ff ff       	call   c0100ccb <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104b68:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104b6d:	8b 00                	mov    (%eax),%eax
c0104b6f:	83 e0 04             	and    $0x4,%eax
c0104b72:	85 c0                	test   %eax,%eax
c0104b74:	75 24                	jne    c0104b9a <check_pgdir+0x395>
c0104b76:	c7 44 24 0c c8 6d 10 	movl   $0xc0106dc8,0xc(%esp)
c0104b7d:	c0 
c0104b7e:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104b85:	c0 
c0104b86:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0104b8d:	00 
c0104b8e:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104b95:	e8 31 c1 ff ff       	call   c0100ccb <__panic>
    assert(page_ref(p2) == 1);
c0104b9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b9d:	89 04 24             	mov    %eax,(%esp)
c0104ba0:	e8 a3 ef ff ff       	call   c0103b48 <page_ref>
c0104ba5:	83 f8 01             	cmp    $0x1,%eax
c0104ba8:	74 24                	je     c0104bce <check_pgdir+0x3c9>
c0104baa:	c7 44 24 0c de 6d 10 	movl   $0xc0106dde,0xc(%esp)
c0104bb1:	c0 
c0104bb2:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104bb9:	c0 
c0104bba:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c0104bc1:	00 
c0104bc2:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104bc9:	e8 fd c0 ff ff       	call   c0100ccb <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104bce:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104bd3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104bda:	00 
c0104bdb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104be2:	00 
c0104be3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104be6:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104bea:	89 04 24             	mov    %eax,(%esp)
c0104bed:	e8 df fa ff ff       	call   c01046d1 <page_insert>
c0104bf2:	85 c0                	test   %eax,%eax
c0104bf4:	74 24                	je     c0104c1a <check_pgdir+0x415>
c0104bf6:	c7 44 24 0c f0 6d 10 	movl   $0xc0106df0,0xc(%esp)
c0104bfd:	c0 
c0104bfe:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104c05:	c0 
c0104c06:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
c0104c0d:	00 
c0104c0e:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104c15:	e8 b1 c0 ff ff       	call   c0100ccb <__panic>
    assert(page_ref(p1) == 2);
c0104c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c1d:	89 04 24             	mov    %eax,(%esp)
c0104c20:	e8 23 ef ff ff       	call   c0103b48 <page_ref>
c0104c25:	83 f8 02             	cmp    $0x2,%eax
c0104c28:	74 24                	je     c0104c4e <check_pgdir+0x449>
c0104c2a:	c7 44 24 0c 1c 6e 10 	movl   $0xc0106e1c,0xc(%esp)
c0104c31:	c0 
c0104c32:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104c39:	c0 
c0104c3a:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c0104c41:	00 
c0104c42:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104c49:	e8 7d c0 ff ff       	call   c0100ccb <__panic>
    assert(page_ref(p2) == 0);
c0104c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c51:	89 04 24             	mov    %eax,(%esp)
c0104c54:	e8 ef ee ff ff       	call   c0103b48 <page_ref>
c0104c59:	85 c0                	test   %eax,%eax
c0104c5b:	74 24                	je     c0104c81 <check_pgdir+0x47c>
c0104c5d:	c7 44 24 0c 2e 6e 10 	movl   $0xc0106e2e,0xc(%esp)
c0104c64:	c0 
c0104c65:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104c6c:	c0 
c0104c6d:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0104c74:	00 
c0104c75:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104c7c:	e8 4a c0 ff ff       	call   c0100ccb <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104c81:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104c86:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104c8d:	00 
c0104c8e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104c95:	00 
c0104c96:	89 04 24             	mov    %eax,(%esp)
c0104c99:	e8 ee f7 ff ff       	call   c010448c <get_pte>
c0104c9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ca1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104ca5:	75 24                	jne    c0104ccb <check_pgdir+0x4c6>
c0104ca7:	c7 44 24 0c 7c 6d 10 	movl   $0xc0106d7c,0xc(%esp)
c0104cae:	c0 
c0104caf:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104cb6:	c0 
c0104cb7:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0104cbe:	00 
c0104cbf:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104cc6:	e8 00 c0 ff ff       	call   c0100ccb <__panic>
    assert(pte2page(*ptep) == p1);
c0104ccb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cce:	8b 00                	mov    (%eax),%eax
c0104cd0:	89 04 24             	mov    %eax,(%esp)
c0104cd3:	e8 1a ee ff ff       	call   c0103af2 <pte2page>
c0104cd8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104cdb:	74 24                	je     c0104d01 <check_pgdir+0x4fc>
c0104cdd:	c7 44 24 0c f1 6c 10 	movl   $0xc0106cf1,0xc(%esp)
c0104ce4:	c0 
c0104ce5:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104cec:	c0 
c0104ced:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0104cf4:	00 
c0104cf5:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104cfc:	e8 ca bf ff ff       	call   c0100ccb <__panic>
    assert((*ptep & PTE_U) == 0);
c0104d01:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d04:	8b 00                	mov    (%eax),%eax
c0104d06:	83 e0 04             	and    $0x4,%eax
c0104d09:	85 c0                	test   %eax,%eax
c0104d0b:	74 24                	je     c0104d31 <check_pgdir+0x52c>
c0104d0d:	c7 44 24 0c 40 6e 10 	movl   $0xc0106e40,0xc(%esp)
c0104d14:	c0 
c0104d15:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104d1c:	c0 
c0104d1d:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
c0104d24:	00 
c0104d25:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104d2c:	e8 9a bf ff ff       	call   c0100ccb <__panic>

    page_remove(boot_pgdir, 0x0);
c0104d31:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104d36:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104d3d:	00 
c0104d3e:	89 04 24             	mov    %eax,(%esp)
c0104d41:	e8 47 f9 ff ff       	call   c010468d <page_remove>
    assert(page_ref(p1) == 1);
c0104d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d49:	89 04 24             	mov    %eax,(%esp)
c0104d4c:	e8 f7 ed ff ff       	call   c0103b48 <page_ref>
c0104d51:	83 f8 01             	cmp    $0x1,%eax
c0104d54:	74 24                	je     c0104d7a <check_pgdir+0x575>
c0104d56:	c7 44 24 0c 07 6d 10 	movl   $0xc0106d07,0xc(%esp)
c0104d5d:	c0 
c0104d5e:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104d65:	c0 
c0104d66:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c0104d6d:	00 
c0104d6e:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104d75:	e8 51 bf ff ff       	call   c0100ccb <__panic>
    assert(page_ref(p2) == 0);
c0104d7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d7d:	89 04 24             	mov    %eax,(%esp)
c0104d80:	e8 c3 ed ff ff       	call   c0103b48 <page_ref>
c0104d85:	85 c0                	test   %eax,%eax
c0104d87:	74 24                	je     c0104dad <check_pgdir+0x5a8>
c0104d89:	c7 44 24 0c 2e 6e 10 	movl   $0xc0106e2e,0xc(%esp)
c0104d90:	c0 
c0104d91:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104d98:	c0 
c0104d99:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c0104da0:	00 
c0104da1:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104da8:	e8 1e bf ff ff       	call   c0100ccb <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104dad:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104db2:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104db9:	00 
c0104dba:	89 04 24             	mov    %eax,(%esp)
c0104dbd:	e8 cb f8 ff ff       	call   c010468d <page_remove>
    assert(page_ref(p1) == 0);
c0104dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104dc5:	89 04 24             	mov    %eax,(%esp)
c0104dc8:	e8 7b ed ff ff       	call   c0103b48 <page_ref>
c0104dcd:	85 c0                	test   %eax,%eax
c0104dcf:	74 24                	je     c0104df5 <check_pgdir+0x5f0>
c0104dd1:	c7 44 24 0c 55 6e 10 	movl   $0xc0106e55,0xc(%esp)
c0104dd8:	c0 
c0104dd9:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104de0:	c0 
c0104de1:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
c0104de8:	00 
c0104de9:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104df0:	e8 d6 be ff ff       	call   c0100ccb <__panic>
    assert(page_ref(p2) == 0);
c0104df5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104df8:	89 04 24             	mov    %eax,(%esp)
c0104dfb:	e8 48 ed ff ff       	call   c0103b48 <page_ref>
c0104e00:	85 c0                	test   %eax,%eax
c0104e02:	74 24                	je     c0104e28 <check_pgdir+0x623>
c0104e04:	c7 44 24 0c 2e 6e 10 	movl   $0xc0106e2e,0xc(%esp)
c0104e0b:	c0 
c0104e0c:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104e13:	c0 
c0104e14:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c0104e1b:	00 
c0104e1c:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104e23:	e8 a3 be ff ff       	call   c0100ccb <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0104e28:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e2d:	8b 00                	mov    (%eax),%eax
c0104e2f:	89 04 24             	mov    %eax,(%esp)
c0104e32:	e8 f9 ec ff ff       	call   c0103b30 <pde2page>
c0104e37:	89 04 24             	mov    %eax,(%esp)
c0104e3a:	e8 09 ed ff ff       	call   c0103b48 <page_ref>
c0104e3f:	83 f8 01             	cmp    $0x1,%eax
c0104e42:	74 24                	je     c0104e68 <check_pgdir+0x663>
c0104e44:	c7 44 24 0c 68 6e 10 	movl   $0xc0106e68,0xc(%esp)
c0104e4b:	c0 
c0104e4c:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104e53:	c0 
c0104e54:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c0104e5b:	00 
c0104e5c:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104e63:	e8 63 be ff ff       	call   c0100ccb <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0104e68:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e6d:	8b 00                	mov    (%eax),%eax
c0104e6f:	89 04 24             	mov    %eax,(%esp)
c0104e72:	e8 b9 ec ff ff       	call   c0103b30 <pde2page>
c0104e77:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104e7e:	00 
c0104e7f:	89 04 24             	mov    %eax,(%esp)
c0104e82:	e8 fe ee ff ff       	call   c0103d85 <free_pages>
    boot_pgdir[0] = 0;
c0104e87:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104e92:	c7 04 24 8f 6e 10 c0 	movl   $0xc0106e8f,(%esp)
c0104e99:	e8 9e b4 ff ff       	call   c010033c <cprintf>
}
c0104e9e:	c9                   	leave  
c0104e9f:	c3                   	ret    

c0104ea0 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104ea0:	55                   	push   %ebp
c0104ea1:	89 e5                	mov    %esp,%ebp
c0104ea3:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104ea6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104ead:	e9 ca 00 00 00       	jmp    c0104f7c <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104eb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ebb:	c1 e8 0c             	shr    $0xc,%eax
c0104ebe:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104ec1:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104ec6:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104ec9:	72 23                	jb     c0104eee <check_boot_pgdir+0x4e>
c0104ecb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ece:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104ed2:	c7 44 24 08 d4 6a 10 	movl   $0xc0106ad4,0x8(%esp)
c0104ed9:	c0 
c0104eda:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c0104ee1:	00 
c0104ee2:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104ee9:	e8 dd bd ff ff       	call   c0100ccb <__panic>
c0104eee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ef1:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104ef6:	89 c2                	mov    %eax,%edx
c0104ef8:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104efd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104f04:	00 
c0104f05:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104f09:	89 04 24             	mov    %eax,(%esp)
c0104f0c:	e8 7b f5 ff ff       	call   c010448c <get_pte>
c0104f11:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104f14:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104f18:	75 24                	jne    c0104f3e <check_boot_pgdir+0x9e>
c0104f1a:	c7 44 24 0c ac 6e 10 	movl   $0xc0106eac,0xc(%esp)
c0104f21:	c0 
c0104f22:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104f29:	c0 
c0104f2a:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c0104f31:	00 
c0104f32:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104f39:	e8 8d bd ff ff       	call   c0100ccb <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104f3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104f41:	8b 00                	mov    (%eax),%eax
c0104f43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104f48:	89 c2                	mov    %eax,%edx
c0104f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f4d:	39 c2                	cmp    %eax,%edx
c0104f4f:	74 24                	je     c0104f75 <check_boot_pgdir+0xd5>
c0104f51:	c7 44 24 0c e9 6e 10 	movl   $0xc0106ee9,0xc(%esp)
c0104f58:	c0 
c0104f59:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104f60:	c0 
c0104f61:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
c0104f68:	00 
c0104f69:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104f70:	e8 56 bd ff ff       	call   c0100ccb <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104f75:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104f7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104f7f:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104f84:	39 c2                	cmp    %eax,%edx
c0104f86:	0f 82 26 ff ff ff    	jb     c0104eb2 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104f8c:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104f91:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104f96:	8b 00                	mov    (%eax),%eax
c0104f98:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104f9d:	89 c2                	mov    %eax,%edx
c0104f9f:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104fa4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104fa7:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0104fae:	77 23                	ja     c0104fd3 <check_boot_pgdir+0x133>
c0104fb0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104fb3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104fb7:	c7 44 24 08 78 6b 10 	movl   $0xc0106b78,0x8(%esp)
c0104fbe:	c0 
c0104fbf:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
c0104fc6:	00 
c0104fc7:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104fce:	e8 f8 bc ff ff       	call   c0100ccb <__panic>
c0104fd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104fd6:	05 00 00 00 40       	add    $0x40000000,%eax
c0104fdb:	39 c2                	cmp    %eax,%edx
c0104fdd:	74 24                	je     c0105003 <check_boot_pgdir+0x163>
c0104fdf:	c7 44 24 0c 00 6f 10 	movl   $0xc0106f00,0xc(%esp)
c0104fe6:	c0 
c0104fe7:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104fee:	c0 
c0104fef:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
c0104ff6:	00 
c0104ff7:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104ffe:	e8 c8 bc ff ff       	call   c0100ccb <__panic>

    assert(boot_pgdir[0] == 0);
c0105003:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105008:	8b 00                	mov    (%eax),%eax
c010500a:	85 c0                	test   %eax,%eax
c010500c:	74 24                	je     c0105032 <check_boot_pgdir+0x192>
c010500e:	c7 44 24 0c 34 6f 10 	movl   $0xc0106f34,0xc(%esp)
c0105015:	c0 
c0105016:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c010501d:	c0 
c010501e:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c0105025:	00 
c0105026:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c010502d:	e8 99 bc ff ff       	call   c0100ccb <__panic>

    struct Page *p;
    p = alloc_page();
c0105032:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105039:	e8 0f ed ff ff       	call   c0103d4d <alloc_pages>
c010503e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0105041:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105046:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c010504d:	00 
c010504e:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0105055:	00 
c0105056:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105059:	89 54 24 04          	mov    %edx,0x4(%esp)
c010505d:	89 04 24             	mov    %eax,(%esp)
c0105060:	e8 6c f6 ff ff       	call   c01046d1 <page_insert>
c0105065:	85 c0                	test   %eax,%eax
c0105067:	74 24                	je     c010508d <check_boot_pgdir+0x1ed>
c0105069:	c7 44 24 0c 48 6f 10 	movl   $0xc0106f48,0xc(%esp)
c0105070:	c0 
c0105071:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0105078:	c0 
c0105079:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
c0105080:	00 
c0105081:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0105088:	e8 3e bc ff ff       	call   c0100ccb <__panic>
    assert(page_ref(p) == 1);
c010508d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105090:	89 04 24             	mov    %eax,(%esp)
c0105093:	e8 b0 ea ff ff       	call   c0103b48 <page_ref>
c0105098:	83 f8 01             	cmp    $0x1,%eax
c010509b:	74 24                	je     c01050c1 <check_boot_pgdir+0x221>
c010509d:	c7 44 24 0c 76 6f 10 	movl   $0xc0106f76,0xc(%esp)
c01050a4:	c0 
c01050a5:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c01050ac:	c0 
c01050ad:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c01050b4:	00 
c01050b5:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c01050bc:	e8 0a bc ff ff       	call   c0100ccb <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c01050c1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01050c6:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01050cd:	00 
c01050ce:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c01050d5:	00 
c01050d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01050d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01050dd:	89 04 24             	mov    %eax,(%esp)
c01050e0:	e8 ec f5 ff ff       	call   c01046d1 <page_insert>
c01050e5:	85 c0                	test   %eax,%eax
c01050e7:	74 24                	je     c010510d <check_boot_pgdir+0x26d>
c01050e9:	c7 44 24 0c 88 6f 10 	movl   $0xc0106f88,0xc(%esp)
c01050f0:	c0 
c01050f1:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c01050f8:	c0 
c01050f9:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c0105100:	00 
c0105101:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0105108:	e8 be bb ff ff       	call   c0100ccb <__panic>
    assert(page_ref(p) == 2);
c010510d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105110:	89 04 24             	mov    %eax,(%esp)
c0105113:	e8 30 ea ff ff       	call   c0103b48 <page_ref>
c0105118:	83 f8 02             	cmp    $0x2,%eax
c010511b:	74 24                	je     c0105141 <check_boot_pgdir+0x2a1>
c010511d:	c7 44 24 0c bf 6f 10 	movl   $0xc0106fbf,0xc(%esp)
c0105124:	c0 
c0105125:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c010512c:	c0 
c010512d:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
c0105134:	00 
c0105135:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c010513c:	e8 8a bb ff ff       	call   c0100ccb <__panic>

    const char *str = "ucore: Hello world!!";
c0105141:	c7 45 dc d0 6f 10 c0 	movl   $0xc0106fd0,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0105148:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010514b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010514f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105156:	e8 19 0a 00 00       	call   c0105b74 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c010515b:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0105162:	00 
c0105163:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010516a:	e8 7e 0a 00 00       	call   c0105bed <strcmp>
c010516f:	85 c0                	test   %eax,%eax
c0105171:	74 24                	je     c0105197 <check_boot_pgdir+0x2f7>
c0105173:	c7 44 24 0c e8 6f 10 	movl   $0xc0106fe8,0xc(%esp)
c010517a:	c0 
c010517b:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0105182:	c0 
c0105183:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
c010518a:	00 
c010518b:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0105192:	e8 34 bb ff ff       	call   c0100ccb <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0105197:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010519a:	89 04 24             	mov    %eax,(%esp)
c010519d:	e8 fc e8 ff ff       	call   c0103a9e <page2kva>
c01051a2:	05 00 01 00 00       	add    $0x100,%eax
c01051a7:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c01051aa:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01051b1:	e8 66 09 00 00       	call   c0105b1c <strlen>
c01051b6:	85 c0                	test   %eax,%eax
c01051b8:	74 24                	je     c01051de <check_boot_pgdir+0x33e>
c01051ba:	c7 44 24 0c 20 70 10 	movl   $0xc0107020,0xc(%esp)
c01051c1:	c0 
c01051c2:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c01051c9:	c0 
c01051ca:	c7 44 24 04 44 02 00 	movl   $0x244,0x4(%esp)
c01051d1:	00 
c01051d2:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c01051d9:	e8 ed ba ff ff       	call   c0100ccb <__panic>

    free_page(p);
c01051de:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01051e5:	00 
c01051e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01051e9:	89 04 24             	mov    %eax,(%esp)
c01051ec:	e8 94 eb ff ff       	call   c0103d85 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c01051f1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01051f6:	8b 00                	mov    (%eax),%eax
c01051f8:	89 04 24             	mov    %eax,(%esp)
c01051fb:	e8 30 e9 ff ff       	call   c0103b30 <pde2page>
c0105200:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105207:	00 
c0105208:	89 04 24             	mov    %eax,(%esp)
c010520b:	e8 75 eb ff ff       	call   c0103d85 <free_pages>
    boot_pgdir[0] = 0;
c0105210:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105215:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c010521b:	c7 04 24 44 70 10 c0 	movl   $0xc0107044,(%esp)
c0105222:	e8 15 b1 ff ff       	call   c010033c <cprintf>
}
c0105227:	c9                   	leave  
c0105228:	c3                   	ret    

c0105229 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0105229:	55                   	push   %ebp
c010522a:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c010522c:	8b 45 08             	mov    0x8(%ebp),%eax
c010522f:	83 e0 04             	and    $0x4,%eax
c0105232:	85 c0                	test   %eax,%eax
c0105234:	74 07                	je     c010523d <perm2str+0x14>
c0105236:	b8 75 00 00 00       	mov    $0x75,%eax
c010523b:	eb 05                	jmp    c0105242 <perm2str+0x19>
c010523d:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105242:	a2 48 89 11 c0       	mov    %al,0xc0118948
    str[1] = 'r';
c0105247:	c6 05 49 89 11 c0 72 	movb   $0x72,0xc0118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c010524e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105251:	83 e0 02             	and    $0x2,%eax
c0105254:	85 c0                	test   %eax,%eax
c0105256:	74 07                	je     c010525f <perm2str+0x36>
c0105258:	b8 77 00 00 00       	mov    $0x77,%eax
c010525d:	eb 05                	jmp    c0105264 <perm2str+0x3b>
c010525f:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105264:	a2 4a 89 11 c0       	mov    %al,0xc011894a
    str[3] = '\0';
c0105269:	c6 05 4b 89 11 c0 00 	movb   $0x0,0xc011894b
    return str;
c0105270:	b8 48 89 11 c0       	mov    $0xc0118948,%eax
}
c0105275:	5d                   	pop    %ebp
c0105276:	c3                   	ret    

c0105277 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0105277:	55                   	push   %ebp
c0105278:	89 e5                	mov    %esp,%ebp
c010527a:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c010527d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105280:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105283:	72 0a                	jb     c010528f <get_pgtable_items+0x18>
        return 0;
c0105285:	b8 00 00 00 00       	mov    $0x0,%eax
c010528a:	e9 9c 00 00 00       	jmp    c010532b <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c010528f:	eb 04                	jmp    c0105295 <get_pgtable_items+0x1e>
        start ++;
c0105291:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105295:	8b 45 10             	mov    0x10(%ebp),%eax
c0105298:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010529b:	73 18                	jae    c01052b5 <get_pgtable_items+0x3e>
c010529d:	8b 45 10             	mov    0x10(%ebp),%eax
c01052a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01052a7:	8b 45 14             	mov    0x14(%ebp),%eax
c01052aa:	01 d0                	add    %edx,%eax
c01052ac:	8b 00                	mov    (%eax),%eax
c01052ae:	83 e0 01             	and    $0x1,%eax
c01052b1:	85 c0                	test   %eax,%eax
c01052b3:	74 dc                	je     c0105291 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c01052b5:	8b 45 10             	mov    0x10(%ebp),%eax
c01052b8:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01052bb:	73 69                	jae    c0105326 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c01052bd:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c01052c1:	74 08                	je     c01052cb <get_pgtable_items+0x54>
            *left_store = start;
c01052c3:	8b 45 18             	mov    0x18(%ebp),%eax
c01052c6:	8b 55 10             	mov    0x10(%ebp),%edx
c01052c9:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c01052cb:	8b 45 10             	mov    0x10(%ebp),%eax
c01052ce:	8d 50 01             	lea    0x1(%eax),%edx
c01052d1:	89 55 10             	mov    %edx,0x10(%ebp)
c01052d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01052db:	8b 45 14             	mov    0x14(%ebp),%eax
c01052de:	01 d0                	add    %edx,%eax
c01052e0:	8b 00                	mov    (%eax),%eax
c01052e2:	83 e0 07             	and    $0x7,%eax
c01052e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01052e8:	eb 04                	jmp    c01052ee <get_pgtable_items+0x77>
            start ++;
c01052ea:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c01052ee:	8b 45 10             	mov    0x10(%ebp),%eax
c01052f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01052f4:	73 1d                	jae    c0105313 <get_pgtable_items+0x9c>
c01052f6:	8b 45 10             	mov    0x10(%ebp),%eax
c01052f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105300:	8b 45 14             	mov    0x14(%ebp),%eax
c0105303:	01 d0                	add    %edx,%eax
c0105305:	8b 00                	mov    (%eax),%eax
c0105307:	83 e0 07             	and    $0x7,%eax
c010530a:	89 c2                	mov    %eax,%edx
c010530c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010530f:	39 c2                	cmp    %eax,%edx
c0105311:	74 d7                	je     c01052ea <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c0105313:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105317:	74 08                	je     c0105321 <get_pgtable_items+0xaa>
            *right_store = start;
c0105319:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010531c:	8b 55 10             	mov    0x10(%ebp),%edx
c010531f:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0105321:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105324:	eb 05                	jmp    c010532b <get_pgtable_items+0xb4>
    }
    return 0;
c0105326:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010532b:	c9                   	leave  
c010532c:	c3                   	ret    

c010532d <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c010532d:	55                   	push   %ebp
c010532e:	89 e5                	mov    %esp,%ebp
c0105330:	57                   	push   %edi
c0105331:	56                   	push   %esi
c0105332:	53                   	push   %ebx
c0105333:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0105336:	c7 04 24 64 70 10 c0 	movl   $0xc0107064,(%esp)
c010533d:	e8 fa af ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
c0105342:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105349:	e9 fa 00 00 00       	jmp    c0105448 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010534e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105351:	89 04 24             	mov    %eax,(%esp)
c0105354:	e8 d0 fe ff ff       	call   c0105229 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105359:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010535c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010535f:	29 d1                	sub    %edx,%ecx
c0105361:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105363:	89 d6                	mov    %edx,%esi
c0105365:	c1 e6 16             	shl    $0x16,%esi
c0105368:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010536b:	89 d3                	mov    %edx,%ebx
c010536d:	c1 e3 16             	shl    $0x16,%ebx
c0105370:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105373:	89 d1                	mov    %edx,%ecx
c0105375:	c1 e1 16             	shl    $0x16,%ecx
c0105378:	8b 7d dc             	mov    -0x24(%ebp),%edi
c010537b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010537e:	29 d7                	sub    %edx,%edi
c0105380:	89 fa                	mov    %edi,%edx
c0105382:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105386:	89 74 24 10          	mov    %esi,0x10(%esp)
c010538a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010538e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105392:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105396:	c7 04 24 95 70 10 c0 	movl   $0xc0107095,(%esp)
c010539d:	e8 9a af ff ff       	call   c010033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c01053a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01053a5:	c1 e0 0a             	shl    $0xa,%eax
c01053a8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01053ab:	eb 54                	jmp    c0105401 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01053ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01053b0:	89 04 24             	mov    %eax,(%esp)
c01053b3:	e8 71 fe ff ff       	call   c0105229 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01053b8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01053bb:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01053be:	29 d1                	sub    %edx,%ecx
c01053c0:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01053c2:	89 d6                	mov    %edx,%esi
c01053c4:	c1 e6 0c             	shl    $0xc,%esi
c01053c7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01053ca:	89 d3                	mov    %edx,%ebx
c01053cc:	c1 e3 0c             	shl    $0xc,%ebx
c01053cf:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01053d2:	c1 e2 0c             	shl    $0xc,%edx
c01053d5:	89 d1                	mov    %edx,%ecx
c01053d7:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c01053da:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01053dd:	29 d7                	sub    %edx,%edi
c01053df:	89 fa                	mov    %edi,%edx
c01053e1:	89 44 24 14          	mov    %eax,0x14(%esp)
c01053e5:	89 74 24 10          	mov    %esi,0x10(%esp)
c01053e9:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01053ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01053f1:	89 54 24 04          	mov    %edx,0x4(%esp)
c01053f5:	c7 04 24 b4 70 10 c0 	movl   $0xc01070b4,(%esp)
c01053fc:	e8 3b af ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105401:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c0105406:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105409:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010540c:	89 ce                	mov    %ecx,%esi
c010540e:	c1 e6 0a             	shl    $0xa,%esi
c0105411:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0105414:	89 cb                	mov    %ecx,%ebx
c0105416:	c1 e3 0a             	shl    $0xa,%ebx
c0105419:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c010541c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105420:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0105423:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105427:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010542b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010542f:	89 74 24 04          	mov    %esi,0x4(%esp)
c0105433:	89 1c 24             	mov    %ebx,(%esp)
c0105436:	e8 3c fe ff ff       	call   c0105277 <get_pgtable_items>
c010543b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010543e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105442:	0f 85 65 ff ff ff    	jne    c01053ad <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105448:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c010544d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105450:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0105453:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105457:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c010545a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010545e:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105462:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105466:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c010546d:	00 
c010546e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0105475:	e8 fd fd ff ff       	call   c0105277 <get_pgtable_items>
c010547a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010547d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105481:	0f 85 c7 fe ff ff    	jne    c010534e <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0105487:	c7 04 24 d8 70 10 c0 	movl   $0xc01070d8,(%esp)
c010548e:	e8 a9 ae ff ff       	call   c010033c <cprintf>
}
c0105493:	83 c4 4c             	add    $0x4c,%esp
c0105496:	5b                   	pop    %ebx
c0105497:	5e                   	pop    %esi
c0105498:	5f                   	pop    %edi
c0105499:	5d                   	pop    %ebp
c010549a:	c3                   	ret    

c010549b <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c010549b:	55                   	push   %ebp
c010549c:	89 e5                	mov    %esp,%ebp
c010549e:	83 ec 58             	sub    $0x58,%esp
c01054a1:	8b 45 10             	mov    0x10(%ebp),%eax
c01054a4:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01054a7:	8b 45 14             	mov    0x14(%ebp),%eax
c01054aa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01054ad:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01054b0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01054b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01054b6:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01054b9:	8b 45 18             	mov    0x18(%ebp),%eax
c01054bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01054bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01054c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01054c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01054c8:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01054cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01054d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01054d5:	74 1c                	je     c01054f3 <printnum+0x58>
c01054d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054da:	ba 00 00 00 00       	mov    $0x0,%edx
c01054df:	f7 75 e4             	divl   -0x1c(%ebp)
c01054e2:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01054e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054e8:	ba 00 00 00 00       	mov    $0x0,%edx
c01054ed:	f7 75 e4             	divl   -0x1c(%ebp)
c01054f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01054f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01054f9:	f7 75 e4             	divl   -0x1c(%ebp)
c01054fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01054ff:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105502:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105505:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105508:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010550b:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010550e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105511:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105514:	8b 45 18             	mov    0x18(%ebp),%eax
c0105517:	ba 00 00 00 00       	mov    $0x0,%edx
c010551c:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010551f:	77 56                	ja     c0105577 <printnum+0xdc>
c0105521:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105524:	72 05                	jb     c010552b <printnum+0x90>
c0105526:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0105529:	77 4c                	ja     c0105577 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c010552b:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010552e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105531:	8b 45 20             	mov    0x20(%ebp),%eax
c0105534:	89 44 24 18          	mov    %eax,0x18(%esp)
c0105538:	89 54 24 14          	mov    %edx,0x14(%esp)
c010553c:	8b 45 18             	mov    0x18(%ebp),%eax
c010553f:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105543:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105546:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105549:	89 44 24 08          	mov    %eax,0x8(%esp)
c010554d:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105551:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105554:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105558:	8b 45 08             	mov    0x8(%ebp),%eax
c010555b:	89 04 24             	mov    %eax,(%esp)
c010555e:	e8 38 ff ff ff       	call   c010549b <printnum>
c0105563:	eb 1c                	jmp    c0105581 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105565:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105568:	89 44 24 04          	mov    %eax,0x4(%esp)
c010556c:	8b 45 20             	mov    0x20(%ebp),%eax
c010556f:	89 04 24             	mov    %eax,(%esp)
c0105572:	8b 45 08             	mov    0x8(%ebp),%eax
c0105575:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0105577:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c010557b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010557f:	7f e4                	jg     c0105565 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105581:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105584:	05 8c 71 10 c0       	add    $0xc010718c,%eax
c0105589:	0f b6 00             	movzbl (%eax),%eax
c010558c:	0f be c0             	movsbl %al,%eax
c010558f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105592:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105596:	89 04 24             	mov    %eax,(%esp)
c0105599:	8b 45 08             	mov    0x8(%ebp),%eax
c010559c:	ff d0                	call   *%eax
}
c010559e:	c9                   	leave  
c010559f:	c3                   	ret    

c01055a0 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01055a0:	55                   	push   %ebp
c01055a1:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01055a3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01055a7:	7e 14                	jle    c01055bd <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01055a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01055ac:	8b 00                	mov    (%eax),%eax
c01055ae:	8d 48 08             	lea    0x8(%eax),%ecx
c01055b1:	8b 55 08             	mov    0x8(%ebp),%edx
c01055b4:	89 0a                	mov    %ecx,(%edx)
c01055b6:	8b 50 04             	mov    0x4(%eax),%edx
c01055b9:	8b 00                	mov    (%eax),%eax
c01055bb:	eb 30                	jmp    c01055ed <getuint+0x4d>
    }
    else if (lflag) {
c01055bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01055c1:	74 16                	je     c01055d9 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c01055c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01055c6:	8b 00                	mov    (%eax),%eax
c01055c8:	8d 48 04             	lea    0x4(%eax),%ecx
c01055cb:	8b 55 08             	mov    0x8(%ebp),%edx
c01055ce:	89 0a                	mov    %ecx,(%edx)
c01055d0:	8b 00                	mov    (%eax),%eax
c01055d2:	ba 00 00 00 00       	mov    $0x0,%edx
c01055d7:	eb 14                	jmp    c01055ed <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c01055d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01055dc:	8b 00                	mov    (%eax),%eax
c01055de:	8d 48 04             	lea    0x4(%eax),%ecx
c01055e1:	8b 55 08             	mov    0x8(%ebp),%edx
c01055e4:	89 0a                	mov    %ecx,(%edx)
c01055e6:	8b 00                	mov    (%eax),%eax
c01055e8:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01055ed:	5d                   	pop    %ebp
c01055ee:	c3                   	ret    

c01055ef <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01055ef:	55                   	push   %ebp
c01055f0:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01055f2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01055f6:	7e 14                	jle    c010560c <getint+0x1d>
        return va_arg(*ap, long long);
c01055f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01055fb:	8b 00                	mov    (%eax),%eax
c01055fd:	8d 48 08             	lea    0x8(%eax),%ecx
c0105600:	8b 55 08             	mov    0x8(%ebp),%edx
c0105603:	89 0a                	mov    %ecx,(%edx)
c0105605:	8b 50 04             	mov    0x4(%eax),%edx
c0105608:	8b 00                	mov    (%eax),%eax
c010560a:	eb 28                	jmp    c0105634 <getint+0x45>
    }
    else if (lflag) {
c010560c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105610:	74 12                	je     c0105624 <getint+0x35>
        return va_arg(*ap, long);
c0105612:	8b 45 08             	mov    0x8(%ebp),%eax
c0105615:	8b 00                	mov    (%eax),%eax
c0105617:	8d 48 04             	lea    0x4(%eax),%ecx
c010561a:	8b 55 08             	mov    0x8(%ebp),%edx
c010561d:	89 0a                	mov    %ecx,(%edx)
c010561f:	8b 00                	mov    (%eax),%eax
c0105621:	99                   	cltd   
c0105622:	eb 10                	jmp    c0105634 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0105624:	8b 45 08             	mov    0x8(%ebp),%eax
c0105627:	8b 00                	mov    (%eax),%eax
c0105629:	8d 48 04             	lea    0x4(%eax),%ecx
c010562c:	8b 55 08             	mov    0x8(%ebp),%edx
c010562f:	89 0a                	mov    %ecx,(%edx)
c0105631:	8b 00                	mov    (%eax),%eax
c0105633:	99                   	cltd   
    }
}
c0105634:	5d                   	pop    %ebp
c0105635:	c3                   	ret    

c0105636 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105636:	55                   	push   %ebp
c0105637:	89 e5                	mov    %esp,%ebp
c0105639:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c010563c:	8d 45 14             	lea    0x14(%ebp),%eax
c010563f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105642:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105645:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105649:	8b 45 10             	mov    0x10(%ebp),%eax
c010564c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105650:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105653:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105657:	8b 45 08             	mov    0x8(%ebp),%eax
c010565a:	89 04 24             	mov    %eax,(%esp)
c010565d:	e8 02 00 00 00       	call   c0105664 <vprintfmt>
    va_end(ap);
}
c0105662:	c9                   	leave  
c0105663:	c3                   	ret    

c0105664 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105664:	55                   	push   %ebp
c0105665:	89 e5                	mov    %esp,%ebp
c0105667:	56                   	push   %esi
c0105668:	53                   	push   %ebx
c0105669:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010566c:	eb 18                	jmp    c0105686 <vprintfmt+0x22>
            if (ch == '\0') {
c010566e:	85 db                	test   %ebx,%ebx
c0105670:	75 05                	jne    c0105677 <vprintfmt+0x13>
                return;
c0105672:	e9 d1 03 00 00       	jmp    c0105a48 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c0105677:	8b 45 0c             	mov    0xc(%ebp),%eax
c010567a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010567e:	89 1c 24             	mov    %ebx,(%esp)
c0105681:	8b 45 08             	mov    0x8(%ebp),%eax
c0105684:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105686:	8b 45 10             	mov    0x10(%ebp),%eax
c0105689:	8d 50 01             	lea    0x1(%eax),%edx
c010568c:	89 55 10             	mov    %edx,0x10(%ebp)
c010568f:	0f b6 00             	movzbl (%eax),%eax
c0105692:	0f b6 d8             	movzbl %al,%ebx
c0105695:	83 fb 25             	cmp    $0x25,%ebx
c0105698:	75 d4                	jne    c010566e <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c010569a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010569e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01056a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01056a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01056ab:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01056b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01056b5:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01056b8:	8b 45 10             	mov    0x10(%ebp),%eax
c01056bb:	8d 50 01             	lea    0x1(%eax),%edx
c01056be:	89 55 10             	mov    %edx,0x10(%ebp)
c01056c1:	0f b6 00             	movzbl (%eax),%eax
c01056c4:	0f b6 d8             	movzbl %al,%ebx
c01056c7:	8d 43 dd             	lea    -0x23(%ebx),%eax
c01056ca:	83 f8 55             	cmp    $0x55,%eax
c01056cd:	0f 87 44 03 00 00    	ja     c0105a17 <vprintfmt+0x3b3>
c01056d3:	8b 04 85 b0 71 10 c0 	mov    -0x3fef8e50(,%eax,4),%eax
c01056da:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c01056dc:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01056e0:	eb d6                	jmp    c01056b8 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01056e2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01056e6:	eb d0                	jmp    c01056b8 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01056e8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01056ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01056f2:	89 d0                	mov    %edx,%eax
c01056f4:	c1 e0 02             	shl    $0x2,%eax
c01056f7:	01 d0                	add    %edx,%eax
c01056f9:	01 c0                	add    %eax,%eax
c01056fb:	01 d8                	add    %ebx,%eax
c01056fd:	83 e8 30             	sub    $0x30,%eax
c0105700:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105703:	8b 45 10             	mov    0x10(%ebp),%eax
c0105706:	0f b6 00             	movzbl (%eax),%eax
c0105709:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c010570c:	83 fb 2f             	cmp    $0x2f,%ebx
c010570f:	7e 0b                	jle    c010571c <vprintfmt+0xb8>
c0105711:	83 fb 39             	cmp    $0x39,%ebx
c0105714:	7f 06                	jg     c010571c <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105716:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c010571a:	eb d3                	jmp    c01056ef <vprintfmt+0x8b>
            goto process_precision;
c010571c:	eb 33                	jmp    c0105751 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c010571e:	8b 45 14             	mov    0x14(%ebp),%eax
c0105721:	8d 50 04             	lea    0x4(%eax),%edx
c0105724:	89 55 14             	mov    %edx,0x14(%ebp)
c0105727:	8b 00                	mov    (%eax),%eax
c0105729:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c010572c:	eb 23                	jmp    c0105751 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c010572e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105732:	79 0c                	jns    c0105740 <vprintfmt+0xdc>
                width = 0;
c0105734:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c010573b:	e9 78 ff ff ff       	jmp    c01056b8 <vprintfmt+0x54>
c0105740:	e9 73 ff ff ff       	jmp    c01056b8 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c0105745:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c010574c:	e9 67 ff ff ff       	jmp    c01056b8 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c0105751:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105755:	79 12                	jns    c0105769 <vprintfmt+0x105>
                width = precision, precision = -1;
c0105757:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010575a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010575d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105764:	e9 4f ff ff ff       	jmp    c01056b8 <vprintfmt+0x54>
c0105769:	e9 4a ff ff ff       	jmp    c01056b8 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c010576e:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0105772:	e9 41 ff ff ff       	jmp    c01056b8 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105777:	8b 45 14             	mov    0x14(%ebp),%eax
c010577a:	8d 50 04             	lea    0x4(%eax),%edx
c010577d:	89 55 14             	mov    %edx,0x14(%ebp)
c0105780:	8b 00                	mov    (%eax),%eax
c0105782:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105785:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105789:	89 04 24             	mov    %eax,(%esp)
c010578c:	8b 45 08             	mov    0x8(%ebp),%eax
c010578f:	ff d0                	call   *%eax
            break;
c0105791:	e9 ac 02 00 00       	jmp    c0105a42 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0105796:	8b 45 14             	mov    0x14(%ebp),%eax
c0105799:	8d 50 04             	lea    0x4(%eax),%edx
c010579c:	89 55 14             	mov    %edx,0x14(%ebp)
c010579f:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01057a1:	85 db                	test   %ebx,%ebx
c01057a3:	79 02                	jns    c01057a7 <vprintfmt+0x143>
                err = -err;
c01057a5:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01057a7:	83 fb 06             	cmp    $0x6,%ebx
c01057aa:	7f 0b                	jg     c01057b7 <vprintfmt+0x153>
c01057ac:	8b 34 9d 70 71 10 c0 	mov    -0x3fef8e90(,%ebx,4),%esi
c01057b3:	85 f6                	test   %esi,%esi
c01057b5:	75 23                	jne    c01057da <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c01057b7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01057bb:	c7 44 24 08 9d 71 10 	movl   $0xc010719d,0x8(%esp)
c01057c2:	c0 
c01057c3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057c6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01057cd:	89 04 24             	mov    %eax,(%esp)
c01057d0:	e8 61 fe ff ff       	call   c0105636 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01057d5:	e9 68 02 00 00       	jmp    c0105a42 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c01057da:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01057de:	c7 44 24 08 a6 71 10 	movl   $0xc01071a6,0x8(%esp)
c01057e5:	c0 
c01057e6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057e9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01057f0:	89 04 24             	mov    %eax,(%esp)
c01057f3:	e8 3e fe ff ff       	call   c0105636 <printfmt>
            }
            break;
c01057f8:	e9 45 02 00 00       	jmp    c0105a42 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01057fd:	8b 45 14             	mov    0x14(%ebp),%eax
c0105800:	8d 50 04             	lea    0x4(%eax),%edx
c0105803:	89 55 14             	mov    %edx,0x14(%ebp)
c0105806:	8b 30                	mov    (%eax),%esi
c0105808:	85 f6                	test   %esi,%esi
c010580a:	75 05                	jne    c0105811 <vprintfmt+0x1ad>
                p = "(null)";
c010580c:	be a9 71 10 c0       	mov    $0xc01071a9,%esi
            }
            if (width > 0 && padc != '-') {
c0105811:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105815:	7e 3e                	jle    c0105855 <vprintfmt+0x1f1>
c0105817:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c010581b:	74 38                	je     c0105855 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c010581d:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c0105820:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105823:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105827:	89 34 24             	mov    %esi,(%esp)
c010582a:	e8 15 03 00 00       	call   c0105b44 <strnlen>
c010582f:	29 c3                	sub    %eax,%ebx
c0105831:	89 d8                	mov    %ebx,%eax
c0105833:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105836:	eb 17                	jmp    c010584f <vprintfmt+0x1eb>
                    putch(padc, putdat);
c0105838:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c010583c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010583f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105843:	89 04 24             	mov    %eax,(%esp)
c0105846:	8b 45 08             	mov    0x8(%ebp),%eax
c0105849:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c010584b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010584f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105853:	7f e3                	jg     c0105838 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105855:	eb 38                	jmp    c010588f <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105857:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010585b:	74 1f                	je     c010587c <vprintfmt+0x218>
c010585d:	83 fb 1f             	cmp    $0x1f,%ebx
c0105860:	7e 05                	jle    c0105867 <vprintfmt+0x203>
c0105862:	83 fb 7e             	cmp    $0x7e,%ebx
c0105865:	7e 15                	jle    c010587c <vprintfmt+0x218>
                    putch('?', putdat);
c0105867:	8b 45 0c             	mov    0xc(%ebp),%eax
c010586a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010586e:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0105875:	8b 45 08             	mov    0x8(%ebp),%eax
c0105878:	ff d0                	call   *%eax
c010587a:	eb 0f                	jmp    c010588b <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c010587c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010587f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105883:	89 1c 24             	mov    %ebx,(%esp)
c0105886:	8b 45 08             	mov    0x8(%ebp),%eax
c0105889:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010588b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010588f:	89 f0                	mov    %esi,%eax
c0105891:	8d 70 01             	lea    0x1(%eax),%esi
c0105894:	0f b6 00             	movzbl (%eax),%eax
c0105897:	0f be d8             	movsbl %al,%ebx
c010589a:	85 db                	test   %ebx,%ebx
c010589c:	74 10                	je     c01058ae <vprintfmt+0x24a>
c010589e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01058a2:	78 b3                	js     c0105857 <vprintfmt+0x1f3>
c01058a4:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c01058a8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01058ac:	79 a9                	jns    c0105857 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01058ae:	eb 17                	jmp    c01058c7 <vprintfmt+0x263>
                putch(' ', putdat);
c01058b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058b3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058b7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01058be:	8b 45 08             	mov    0x8(%ebp),%eax
c01058c1:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01058c3:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01058c7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01058cb:	7f e3                	jg     c01058b0 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c01058cd:	e9 70 01 00 00       	jmp    c0105a42 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01058d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058d5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058d9:	8d 45 14             	lea    0x14(%ebp),%eax
c01058dc:	89 04 24             	mov    %eax,(%esp)
c01058df:	e8 0b fd ff ff       	call   c01055ef <getint>
c01058e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058e7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c01058ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01058f0:	85 d2                	test   %edx,%edx
c01058f2:	79 26                	jns    c010591a <vprintfmt+0x2b6>
                putch('-', putdat);
c01058f4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058f7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058fb:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105902:	8b 45 08             	mov    0x8(%ebp),%eax
c0105905:	ff d0                	call   *%eax
                num = -(long long)num;
c0105907:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010590a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010590d:	f7 d8                	neg    %eax
c010590f:	83 d2 00             	adc    $0x0,%edx
c0105912:	f7 da                	neg    %edx
c0105914:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105917:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c010591a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105921:	e9 a8 00 00 00       	jmp    c01059ce <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105926:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105929:	89 44 24 04          	mov    %eax,0x4(%esp)
c010592d:	8d 45 14             	lea    0x14(%ebp),%eax
c0105930:	89 04 24             	mov    %eax,(%esp)
c0105933:	e8 68 fc ff ff       	call   c01055a0 <getuint>
c0105938:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010593b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c010593e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105945:	e9 84 00 00 00       	jmp    c01059ce <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c010594a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010594d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105951:	8d 45 14             	lea    0x14(%ebp),%eax
c0105954:	89 04 24             	mov    %eax,(%esp)
c0105957:	e8 44 fc ff ff       	call   c01055a0 <getuint>
c010595c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010595f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105962:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105969:	eb 63                	jmp    c01059ce <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c010596b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010596e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105972:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105979:	8b 45 08             	mov    0x8(%ebp),%eax
c010597c:	ff d0                	call   *%eax
            putch('x', putdat);
c010597e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105981:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105985:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c010598c:	8b 45 08             	mov    0x8(%ebp),%eax
c010598f:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105991:	8b 45 14             	mov    0x14(%ebp),%eax
c0105994:	8d 50 04             	lea    0x4(%eax),%edx
c0105997:	89 55 14             	mov    %edx,0x14(%ebp)
c010599a:	8b 00                	mov    (%eax),%eax
c010599c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010599f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c01059a6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c01059ad:	eb 1f                	jmp    c01059ce <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c01059af:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01059b2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059b6:	8d 45 14             	lea    0x14(%ebp),%eax
c01059b9:	89 04 24             	mov    %eax,(%esp)
c01059bc:	e8 df fb ff ff       	call   c01055a0 <getuint>
c01059c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059c4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c01059c7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c01059ce:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c01059d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01059d5:	89 54 24 18          	mov    %edx,0x18(%esp)
c01059d9:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01059dc:	89 54 24 14          	mov    %edx,0x14(%esp)
c01059e0:	89 44 24 10          	mov    %eax,0x10(%esp)
c01059e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01059ea:	89 44 24 08          	mov    %eax,0x8(%esp)
c01059ee:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01059f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059f5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01059fc:	89 04 24             	mov    %eax,(%esp)
c01059ff:	e8 97 fa ff ff       	call   c010549b <printnum>
            break;
c0105a04:	eb 3c                	jmp    c0105a42 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105a06:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a09:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a0d:	89 1c 24             	mov    %ebx,(%esp)
c0105a10:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a13:	ff d0                	call   *%eax
            break;
c0105a15:	eb 2b                	jmp    c0105a42 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105a17:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a1a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a1e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0105a25:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a28:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105a2a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105a2e:	eb 04                	jmp    c0105a34 <vprintfmt+0x3d0>
c0105a30:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105a34:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a37:	83 e8 01             	sub    $0x1,%eax
c0105a3a:	0f b6 00             	movzbl (%eax),%eax
c0105a3d:	3c 25                	cmp    $0x25,%al
c0105a3f:	75 ef                	jne    c0105a30 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c0105a41:	90                   	nop
        }
    }
c0105a42:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105a43:	e9 3e fc ff ff       	jmp    c0105686 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0105a48:	83 c4 40             	add    $0x40,%esp
c0105a4b:	5b                   	pop    %ebx
c0105a4c:	5e                   	pop    %esi
c0105a4d:	5d                   	pop    %ebp
c0105a4e:	c3                   	ret    

c0105a4f <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105a4f:	55                   	push   %ebp
c0105a50:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105a52:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a55:	8b 40 08             	mov    0x8(%eax),%eax
c0105a58:	8d 50 01             	lea    0x1(%eax),%edx
c0105a5b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a5e:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105a61:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a64:	8b 10                	mov    (%eax),%edx
c0105a66:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a69:	8b 40 04             	mov    0x4(%eax),%eax
c0105a6c:	39 c2                	cmp    %eax,%edx
c0105a6e:	73 12                	jae    c0105a82 <sprintputch+0x33>
        *b->buf ++ = ch;
c0105a70:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a73:	8b 00                	mov    (%eax),%eax
c0105a75:	8d 48 01             	lea    0x1(%eax),%ecx
c0105a78:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105a7b:	89 0a                	mov    %ecx,(%edx)
c0105a7d:	8b 55 08             	mov    0x8(%ebp),%edx
c0105a80:	88 10                	mov    %dl,(%eax)
    }
}
c0105a82:	5d                   	pop    %ebp
c0105a83:	c3                   	ret    

c0105a84 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105a84:	55                   	push   %ebp
c0105a85:	89 e5                	mov    %esp,%ebp
c0105a87:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105a8a:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105a90:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a93:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105a97:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a9a:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a9e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105aa1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105aa5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aa8:	89 04 24             	mov    %eax,(%esp)
c0105aab:	e8 08 00 00 00       	call   c0105ab8 <vsnprintf>
c0105ab0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105ab6:	c9                   	leave  
c0105ab7:	c3                   	ret    

c0105ab8 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105ab8:	55                   	push   %ebp
c0105ab9:	89 e5                	mov    %esp,%ebp
c0105abb:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105abe:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ac1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105ac4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ac7:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105aca:	8b 45 08             	mov    0x8(%ebp),%eax
c0105acd:	01 d0                	add    %edx,%eax
c0105acf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ad2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105ad9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105add:	74 0a                	je     c0105ae9 <vsnprintf+0x31>
c0105adf:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105ae2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ae5:	39 c2                	cmp    %eax,%edx
c0105ae7:	76 07                	jbe    c0105af0 <vsnprintf+0x38>
        return -E_INVAL;
c0105ae9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105aee:	eb 2a                	jmp    c0105b1a <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105af0:	8b 45 14             	mov    0x14(%ebp),%eax
c0105af3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105af7:	8b 45 10             	mov    0x10(%ebp),%eax
c0105afa:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105afe:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105b01:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b05:	c7 04 24 4f 5a 10 c0 	movl   $0xc0105a4f,(%esp)
c0105b0c:	e8 53 fb ff ff       	call   c0105664 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105b11:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b14:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105b1a:	c9                   	leave  
c0105b1b:	c3                   	ret    

c0105b1c <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105b1c:	55                   	push   %ebp
c0105b1d:	89 e5                	mov    %esp,%ebp
c0105b1f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105b22:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105b29:	eb 04                	jmp    c0105b2f <strlen+0x13>
        cnt ++;
c0105b2b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0105b2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b32:	8d 50 01             	lea    0x1(%eax),%edx
c0105b35:	89 55 08             	mov    %edx,0x8(%ebp)
c0105b38:	0f b6 00             	movzbl (%eax),%eax
c0105b3b:	84 c0                	test   %al,%al
c0105b3d:	75 ec                	jne    c0105b2b <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0105b3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105b42:	c9                   	leave  
c0105b43:	c3                   	ret    

c0105b44 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105b44:	55                   	push   %ebp
c0105b45:	89 e5                	mov    %esp,%ebp
c0105b47:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105b4a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105b51:	eb 04                	jmp    c0105b57 <strnlen+0x13>
        cnt ++;
c0105b53:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0105b57:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b5a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105b5d:	73 10                	jae    c0105b6f <strnlen+0x2b>
c0105b5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b62:	8d 50 01             	lea    0x1(%eax),%edx
c0105b65:	89 55 08             	mov    %edx,0x8(%ebp)
c0105b68:	0f b6 00             	movzbl (%eax),%eax
c0105b6b:	84 c0                	test   %al,%al
c0105b6d:	75 e4                	jne    c0105b53 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105b6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105b72:	c9                   	leave  
c0105b73:	c3                   	ret    

c0105b74 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105b74:	55                   	push   %ebp
c0105b75:	89 e5                	mov    %esp,%ebp
c0105b77:	57                   	push   %edi
c0105b78:	56                   	push   %esi
c0105b79:	83 ec 20             	sub    $0x20,%esp
c0105b7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b82:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b85:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105b88:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b8e:	89 d1                	mov    %edx,%ecx
c0105b90:	89 c2                	mov    %eax,%edx
c0105b92:	89 ce                	mov    %ecx,%esi
c0105b94:	89 d7                	mov    %edx,%edi
c0105b96:	ac                   	lods   %ds:(%esi),%al
c0105b97:	aa                   	stos   %al,%es:(%edi)
c0105b98:	84 c0                	test   %al,%al
c0105b9a:	75 fa                	jne    c0105b96 <strcpy+0x22>
c0105b9c:	89 fa                	mov    %edi,%edx
c0105b9e:	89 f1                	mov    %esi,%ecx
c0105ba0:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105ba3:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105ba6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105bac:	83 c4 20             	add    $0x20,%esp
c0105baf:	5e                   	pop    %esi
c0105bb0:	5f                   	pop    %edi
c0105bb1:	5d                   	pop    %ebp
c0105bb2:	c3                   	ret    

c0105bb3 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105bb3:	55                   	push   %ebp
c0105bb4:	89 e5                	mov    %esp,%ebp
c0105bb6:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105bb9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105bbf:	eb 21                	jmp    c0105be2 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bc4:	0f b6 10             	movzbl (%eax),%edx
c0105bc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105bca:	88 10                	mov    %dl,(%eax)
c0105bcc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105bcf:	0f b6 00             	movzbl (%eax),%eax
c0105bd2:	84 c0                	test   %al,%al
c0105bd4:	74 04                	je     c0105bda <strncpy+0x27>
            src ++;
c0105bd6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105bda:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105bde:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105be2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105be6:	75 d9                	jne    c0105bc1 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105be8:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105beb:	c9                   	leave  
c0105bec:	c3                   	ret    

c0105bed <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105bed:	55                   	push   %ebp
c0105bee:	89 e5                	mov    %esp,%ebp
c0105bf0:	57                   	push   %edi
c0105bf1:	56                   	push   %esi
c0105bf2:	83 ec 20             	sub    $0x20,%esp
c0105bf5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105c01:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105c04:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c07:	89 d1                	mov    %edx,%ecx
c0105c09:	89 c2                	mov    %eax,%edx
c0105c0b:	89 ce                	mov    %ecx,%esi
c0105c0d:	89 d7                	mov    %edx,%edi
c0105c0f:	ac                   	lods   %ds:(%esi),%al
c0105c10:	ae                   	scas   %es:(%edi),%al
c0105c11:	75 08                	jne    c0105c1b <strcmp+0x2e>
c0105c13:	84 c0                	test   %al,%al
c0105c15:	75 f8                	jne    c0105c0f <strcmp+0x22>
c0105c17:	31 c0                	xor    %eax,%eax
c0105c19:	eb 04                	jmp    c0105c1f <strcmp+0x32>
c0105c1b:	19 c0                	sbb    %eax,%eax
c0105c1d:	0c 01                	or     $0x1,%al
c0105c1f:	89 fa                	mov    %edi,%edx
c0105c21:	89 f1                	mov    %esi,%ecx
c0105c23:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105c26:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105c29:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105c2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105c2f:	83 c4 20             	add    $0x20,%esp
c0105c32:	5e                   	pop    %esi
c0105c33:	5f                   	pop    %edi
c0105c34:	5d                   	pop    %ebp
c0105c35:	c3                   	ret    

c0105c36 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105c36:	55                   	push   %ebp
c0105c37:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105c39:	eb 0c                	jmp    c0105c47 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105c3b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105c3f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105c43:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105c47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c4b:	74 1a                	je     c0105c67 <strncmp+0x31>
c0105c4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c50:	0f b6 00             	movzbl (%eax),%eax
c0105c53:	84 c0                	test   %al,%al
c0105c55:	74 10                	je     c0105c67 <strncmp+0x31>
c0105c57:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c5a:	0f b6 10             	movzbl (%eax),%edx
c0105c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c60:	0f b6 00             	movzbl (%eax),%eax
c0105c63:	38 c2                	cmp    %al,%dl
c0105c65:	74 d4                	je     c0105c3b <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105c67:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c6b:	74 18                	je     c0105c85 <strncmp+0x4f>
c0105c6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c70:	0f b6 00             	movzbl (%eax),%eax
c0105c73:	0f b6 d0             	movzbl %al,%edx
c0105c76:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c79:	0f b6 00             	movzbl (%eax),%eax
c0105c7c:	0f b6 c0             	movzbl %al,%eax
c0105c7f:	29 c2                	sub    %eax,%edx
c0105c81:	89 d0                	mov    %edx,%eax
c0105c83:	eb 05                	jmp    c0105c8a <strncmp+0x54>
c0105c85:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105c8a:	5d                   	pop    %ebp
c0105c8b:	c3                   	ret    

c0105c8c <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105c8c:	55                   	push   %ebp
c0105c8d:	89 e5                	mov    %esp,%ebp
c0105c8f:	83 ec 04             	sub    $0x4,%esp
c0105c92:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c95:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105c98:	eb 14                	jmp    c0105cae <strchr+0x22>
        if (*s == c) {
c0105c9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c9d:	0f b6 00             	movzbl (%eax),%eax
c0105ca0:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105ca3:	75 05                	jne    c0105caa <strchr+0x1e>
            return (char *)s;
c0105ca5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ca8:	eb 13                	jmp    c0105cbd <strchr+0x31>
        }
        s ++;
c0105caa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105cae:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cb1:	0f b6 00             	movzbl (%eax),%eax
c0105cb4:	84 c0                	test   %al,%al
c0105cb6:	75 e2                	jne    c0105c9a <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105cb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105cbd:	c9                   	leave  
c0105cbe:	c3                   	ret    

c0105cbf <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105cbf:	55                   	push   %ebp
c0105cc0:	89 e5                	mov    %esp,%ebp
c0105cc2:	83 ec 04             	sub    $0x4,%esp
c0105cc5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cc8:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105ccb:	eb 11                	jmp    c0105cde <strfind+0x1f>
        if (*s == c) {
c0105ccd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cd0:	0f b6 00             	movzbl (%eax),%eax
c0105cd3:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105cd6:	75 02                	jne    c0105cda <strfind+0x1b>
            break;
c0105cd8:	eb 0e                	jmp    c0105ce8 <strfind+0x29>
        }
        s ++;
c0105cda:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105cde:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ce1:	0f b6 00             	movzbl (%eax),%eax
c0105ce4:	84 c0                	test   %al,%al
c0105ce6:	75 e5                	jne    c0105ccd <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0105ce8:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105ceb:	c9                   	leave  
c0105cec:	c3                   	ret    

c0105ced <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105ced:	55                   	push   %ebp
c0105cee:	89 e5                	mov    %esp,%ebp
c0105cf0:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105cf3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105cfa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105d01:	eb 04                	jmp    c0105d07 <strtol+0x1a>
        s ++;
c0105d03:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105d07:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d0a:	0f b6 00             	movzbl (%eax),%eax
c0105d0d:	3c 20                	cmp    $0x20,%al
c0105d0f:	74 f2                	je     c0105d03 <strtol+0x16>
c0105d11:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d14:	0f b6 00             	movzbl (%eax),%eax
c0105d17:	3c 09                	cmp    $0x9,%al
c0105d19:	74 e8                	je     c0105d03 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105d1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d1e:	0f b6 00             	movzbl (%eax),%eax
c0105d21:	3c 2b                	cmp    $0x2b,%al
c0105d23:	75 06                	jne    c0105d2b <strtol+0x3e>
        s ++;
c0105d25:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105d29:	eb 15                	jmp    c0105d40 <strtol+0x53>
    }
    else if (*s == '-') {
c0105d2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d2e:	0f b6 00             	movzbl (%eax),%eax
c0105d31:	3c 2d                	cmp    $0x2d,%al
c0105d33:	75 0b                	jne    c0105d40 <strtol+0x53>
        s ++, neg = 1;
c0105d35:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105d39:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105d40:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d44:	74 06                	je     c0105d4c <strtol+0x5f>
c0105d46:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105d4a:	75 24                	jne    c0105d70 <strtol+0x83>
c0105d4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d4f:	0f b6 00             	movzbl (%eax),%eax
c0105d52:	3c 30                	cmp    $0x30,%al
c0105d54:	75 1a                	jne    c0105d70 <strtol+0x83>
c0105d56:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d59:	83 c0 01             	add    $0x1,%eax
c0105d5c:	0f b6 00             	movzbl (%eax),%eax
c0105d5f:	3c 78                	cmp    $0x78,%al
c0105d61:	75 0d                	jne    c0105d70 <strtol+0x83>
        s += 2, base = 16;
c0105d63:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105d67:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105d6e:	eb 2a                	jmp    c0105d9a <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105d70:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d74:	75 17                	jne    c0105d8d <strtol+0xa0>
c0105d76:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d79:	0f b6 00             	movzbl (%eax),%eax
c0105d7c:	3c 30                	cmp    $0x30,%al
c0105d7e:	75 0d                	jne    c0105d8d <strtol+0xa0>
        s ++, base = 8;
c0105d80:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105d84:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105d8b:	eb 0d                	jmp    c0105d9a <strtol+0xad>
    }
    else if (base == 0) {
c0105d8d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d91:	75 07                	jne    c0105d9a <strtol+0xad>
        base = 10;
c0105d93:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105d9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d9d:	0f b6 00             	movzbl (%eax),%eax
c0105da0:	3c 2f                	cmp    $0x2f,%al
c0105da2:	7e 1b                	jle    c0105dbf <strtol+0xd2>
c0105da4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105da7:	0f b6 00             	movzbl (%eax),%eax
c0105daa:	3c 39                	cmp    $0x39,%al
c0105dac:	7f 11                	jg     c0105dbf <strtol+0xd2>
            dig = *s - '0';
c0105dae:	8b 45 08             	mov    0x8(%ebp),%eax
c0105db1:	0f b6 00             	movzbl (%eax),%eax
c0105db4:	0f be c0             	movsbl %al,%eax
c0105db7:	83 e8 30             	sub    $0x30,%eax
c0105dba:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105dbd:	eb 48                	jmp    c0105e07 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105dbf:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dc2:	0f b6 00             	movzbl (%eax),%eax
c0105dc5:	3c 60                	cmp    $0x60,%al
c0105dc7:	7e 1b                	jle    c0105de4 <strtol+0xf7>
c0105dc9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dcc:	0f b6 00             	movzbl (%eax),%eax
c0105dcf:	3c 7a                	cmp    $0x7a,%al
c0105dd1:	7f 11                	jg     c0105de4 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105dd3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dd6:	0f b6 00             	movzbl (%eax),%eax
c0105dd9:	0f be c0             	movsbl %al,%eax
c0105ddc:	83 e8 57             	sub    $0x57,%eax
c0105ddf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105de2:	eb 23                	jmp    c0105e07 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105de4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105de7:	0f b6 00             	movzbl (%eax),%eax
c0105dea:	3c 40                	cmp    $0x40,%al
c0105dec:	7e 3d                	jle    c0105e2b <strtol+0x13e>
c0105dee:	8b 45 08             	mov    0x8(%ebp),%eax
c0105df1:	0f b6 00             	movzbl (%eax),%eax
c0105df4:	3c 5a                	cmp    $0x5a,%al
c0105df6:	7f 33                	jg     c0105e2b <strtol+0x13e>
            dig = *s - 'A' + 10;
c0105df8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dfb:	0f b6 00             	movzbl (%eax),%eax
c0105dfe:	0f be c0             	movsbl %al,%eax
c0105e01:	83 e8 37             	sub    $0x37,%eax
c0105e04:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e0a:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105e0d:	7c 02                	jl     c0105e11 <strtol+0x124>
            break;
c0105e0f:	eb 1a                	jmp    c0105e2b <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0105e11:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105e15:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105e18:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105e1c:	89 c2                	mov    %eax,%edx
c0105e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e21:	01 d0                	add    %edx,%eax
c0105e23:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105e26:	e9 6f ff ff ff       	jmp    c0105d9a <strtol+0xad>

    if (endptr) {
c0105e2b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105e2f:	74 08                	je     c0105e39 <strtol+0x14c>
        *endptr = (char *) s;
c0105e31:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e34:	8b 55 08             	mov    0x8(%ebp),%edx
c0105e37:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105e39:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105e3d:	74 07                	je     c0105e46 <strtol+0x159>
c0105e3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105e42:	f7 d8                	neg    %eax
c0105e44:	eb 03                	jmp    c0105e49 <strtol+0x15c>
c0105e46:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105e49:	c9                   	leave  
c0105e4a:	c3                   	ret    

c0105e4b <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105e4b:	55                   	push   %ebp
c0105e4c:	89 e5                	mov    %esp,%ebp
c0105e4e:	57                   	push   %edi
c0105e4f:	83 ec 24             	sub    $0x24,%esp
c0105e52:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e55:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105e58:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105e5c:	8b 55 08             	mov    0x8(%ebp),%edx
c0105e5f:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105e62:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105e65:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e68:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105e6b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105e6e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105e72:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105e75:	89 d7                	mov    %edx,%edi
c0105e77:	f3 aa                	rep stos %al,%es:(%edi)
c0105e79:	89 fa                	mov    %edi,%edx
c0105e7b:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105e7e:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105e81:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105e84:	83 c4 24             	add    $0x24,%esp
c0105e87:	5f                   	pop    %edi
c0105e88:	5d                   	pop    %ebp
c0105e89:	c3                   	ret    

c0105e8a <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105e8a:	55                   	push   %ebp
c0105e8b:	89 e5                	mov    %esp,%ebp
c0105e8d:	57                   	push   %edi
c0105e8e:	56                   	push   %esi
c0105e8f:	53                   	push   %ebx
c0105e90:	83 ec 30             	sub    $0x30,%esp
c0105e93:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e96:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e99:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105e9f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ea2:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105ea5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ea8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105eab:	73 42                	jae    c0105eef <memmove+0x65>
c0105ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105eb0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105eb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105eb6:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105eb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105ebc:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105ebf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105ec2:	c1 e8 02             	shr    $0x2,%eax
c0105ec5:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105ec7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105eca:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105ecd:	89 d7                	mov    %edx,%edi
c0105ecf:	89 c6                	mov    %eax,%esi
c0105ed1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105ed3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105ed6:	83 e1 03             	and    $0x3,%ecx
c0105ed9:	74 02                	je     c0105edd <memmove+0x53>
c0105edb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105edd:	89 f0                	mov    %esi,%eax
c0105edf:	89 fa                	mov    %edi,%edx
c0105ee1:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105ee4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105ee7:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105eea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105eed:	eb 36                	jmp    c0105f25 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105eef:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105ef2:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105ef5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ef8:	01 c2                	add    %eax,%edx
c0105efa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105efd:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105f00:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f03:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105f06:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105f09:	89 c1                	mov    %eax,%ecx
c0105f0b:	89 d8                	mov    %ebx,%eax
c0105f0d:	89 d6                	mov    %edx,%esi
c0105f0f:	89 c7                	mov    %eax,%edi
c0105f11:	fd                   	std    
c0105f12:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105f14:	fc                   	cld    
c0105f15:	89 f8                	mov    %edi,%eax
c0105f17:	89 f2                	mov    %esi,%edx
c0105f19:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105f1c:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105f1f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0105f22:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105f25:	83 c4 30             	add    $0x30,%esp
c0105f28:	5b                   	pop    %ebx
c0105f29:	5e                   	pop    %esi
c0105f2a:	5f                   	pop    %edi
c0105f2b:	5d                   	pop    %ebp
c0105f2c:	c3                   	ret    

c0105f2d <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105f2d:	55                   	push   %ebp
c0105f2e:	89 e5                	mov    %esp,%ebp
c0105f30:	57                   	push   %edi
c0105f31:	56                   	push   %esi
c0105f32:	83 ec 20             	sub    $0x20,%esp
c0105f35:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f38:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105f3b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105f41:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f44:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105f47:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f4a:	c1 e8 02             	shr    $0x2,%eax
c0105f4d:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105f4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105f52:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f55:	89 d7                	mov    %edx,%edi
c0105f57:	89 c6                	mov    %eax,%esi
c0105f59:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105f5b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105f5e:	83 e1 03             	and    $0x3,%ecx
c0105f61:	74 02                	je     c0105f65 <memcpy+0x38>
c0105f63:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105f65:	89 f0                	mov    %esi,%eax
c0105f67:	89 fa                	mov    %edi,%edx
c0105f69:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105f6c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105f6f:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105f75:	83 c4 20             	add    $0x20,%esp
c0105f78:	5e                   	pop    %esi
c0105f79:	5f                   	pop    %edi
c0105f7a:	5d                   	pop    %ebp
c0105f7b:	c3                   	ret    

c0105f7c <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105f7c:	55                   	push   %ebp
c0105f7d:	89 e5                	mov    %esp,%ebp
c0105f7f:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105f82:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f85:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105f88:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f8b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105f8e:	eb 30                	jmp    c0105fc0 <memcmp+0x44>
        if (*s1 != *s2) {
c0105f90:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105f93:	0f b6 10             	movzbl (%eax),%edx
c0105f96:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f99:	0f b6 00             	movzbl (%eax),%eax
c0105f9c:	38 c2                	cmp    %al,%dl
c0105f9e:	74 18                	je     c0105fb8 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105fa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105fa3:	0f b6 00             	movzbl (%eax),%eax
c0105fa6:	0f b6 d0             	movzbl %al,%edx
c0105fa9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105fac:	0f b6 00             	movzbl (%eax),%eax
c0105faf:	0f b6 c0             	movzbl %al,%eax
c0105fb2:	29 c2                	sub    %eax,%edx
c0105fb4:	89 d0                	mov    %edx,%eax
c0105fb6:	eb 1a                	jmp    c0105fd2 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105fb8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105fbc:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0105fc0:	8b 45 10             	mov    0x10(%ebp),%eax
c0105fc3:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105fc6:	89 55 10             	mov    %edx,0x10(%ebp)
c0105fc9:	85 c0                	test   %eax,%eax
c0105fcb:	75 c3                	jne    c0105f90 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0105fcd:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105fd2:	c9                   	leave  
c0105fd3:	c3                   	ret    
