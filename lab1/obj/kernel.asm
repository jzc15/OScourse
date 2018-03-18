
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 20 fd 10 00       	mov    $0x10fd20,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 ea 10 00 	movl   $0x10ea16,(%esp)
  100027:	e8 77 32 00 00       	call   1032a3 <memset>

    cons_init();                // init the console
  10002c:	e8 39 15 00 00       	call   10156a <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 40 34 10 00 	movl   $0x103440,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 5c 34 10 00 	movl   $0x10345c,(%esp)
  100046:	e8 c7 02 00 00       	call   100312 <cprintf>

    print_kerninfo();
  10004b:	e8 f6 07 00 00       	call   100846 <print_kerninfo>

    grade_backtrace();
  100050:	e8 86 00 00 00       	call   1000db <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 8f 28 00 00       	call   1028e9 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 4e 16 00 00       	call   1016ad <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 c6 17 00 00       	call   10182a <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 f4 0c 00 00       	call   100d5d <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 ad 15 00 00       	call   10161b <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  10006e:	eb fe                	jmp    10006e <kern_init+0x6e>

00100070 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100070:	55                   	push   %ebp
  100071:	89 e5                	mov    %esp,%ebp
  100073:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  100076:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10007d:	00 
  10007e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100085:	00 
  100086:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10008d:	e8 fd 0b 00 00       	call   100c8f <mon_backtrace>
}
  100092:	c9                   	leave  
  100093:	c3                   	ret    

00100094 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100094:	55                   	push   %ebp
  100095:	89 e5                	mov    %esp,%ebp
  100097:	53                   	push   %ebx
  100098:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  10009b:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  10009e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000a1:	8d 55 08             	lea    0x8(%ebp),%edx
  1000a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1000a7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000af:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000b3:	89 04 24             	mov    %eax,(%esp)
  1000b6:	e8 b5 ff ff ff       	call   100070 <grade_backtrace2>
}
  1000bb:	83 c4 14             	add    $0x14,%esp
  1000be:	5b                   	pop    %ebx
  1000bf:	5d                   	pop    %ebp
  1000c0:	c3                   	ret    

001000c1 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c1:	55                   	push   %ebp
  1000c2:	89 e5                	mov    %esp,%ebp
  1000c4:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000c7:	8b 45 10             	mov    0x10(%ebp),%eax
  1000ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 04 24             	mov    %eax,(%esp)
  1000d4:	e8 bb ff ff ff       	call   100094 <grade_backtrace1>
}
  1000d9:	c9                   	leave  
  1000da:	c3                   	ret    

001000db <grade_backtrace>:

void
grade_backtrace(void) {
  1000db:	55                   	push   %ebp
  1000dc:	89 e5                	mov    %esp,%ebp
  1000de:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e1:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000e6:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000ed:	ff 
  1000ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000f9:	e8 c3 ff ff ff       	call   1000c1 <grade_backtrace0>
}
  1000fe:	c9                   	leave  
  1000ff:	c3                   	ret    

00100100 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100100:	55                   	push   %ebp
  100101:	89 e5                	mov    %esp,%ebp
  100103:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100106:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100109:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10010c:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10010f:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100112:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100116:	0f b7 c0             	movzwl %ax,%eax
  100119:	83 e0 03             	and    $0x3,%eax
  10011c:	89 c2                	mov    %eax,%edx
  10011e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100123:	89 54 24 08          	mov    %edx,0x8(%esp)
  100127:	89 44 24 04          	mov    %eax,0x4(%esp)
  10012b:	c7 04 24 61 34 10 00 	movl   $0x103461,(%esp)
  100132:	e8 db 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100137:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10013b:	0f b7 d0             	movzwl %ax,%edx
  10013e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100143:	89 54 24 08          	mov    %edx,0x8(%esp)
  100147:	89 44 24 04          	mov    %eax,0x4(%esp)
  10014b:	c7 04 24 6f 34 10 00 	movl   $0x10346f,(%esp)
  100152:	e8 bb 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100157:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10015b:	0f b7 d0             	movzwl %ax,%edx
  10015e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100163:	89 54 24 08          	mov    %edx,0x8(%esp)
  100167:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016b:	c7 04 24 7d 34 10 00 	movl   $0x10347d,(%esp)
  100172:	e8 9b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  100177:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10017b:	0f b7 d0             	movzwl %ax,%edx
  10017e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100183:	89 54 24 08          	mov    %edx,0x8(%esp)
  100187:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018b:	c7 04 24 8b 34 10 00 	movl   $0x10348b,(%esp)
  100192:	e8 7b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  100197:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10019b:	0f b7 d0             	movzwl %ax,%edx
  10019e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a3:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001ab:	c7 04 24 99 34 10 00 	movl   $0x103499,(%esp)
  1001b2:	e8 5b 01 00 00       	call   100312 <cprintf>
    round ++;
  1001b7:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001bc:	83 c0 01             	add    $0x1,%eax
  1001bf:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001c4:	c9                   	leave  
  1001c5:	c3                   	ret    

001001c6 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001c6:	55                   	push   %ebp
  1001c7:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001c9:	5d                   	pop    %ebp
  1001ca:	c3                   	ret    

001001cb <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001cb:	55                   	push   %ebp
  1001cc:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001ce:	5d                   	pop    %ebp
  1001cf:	c3                   	ret    

001001d0 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001d0:	55                   	push   %ebp
  1001d1:	89 e5                	mov    %esp,%ebp
  1001d3:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001d6:	e8 25 ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001db:	c7 04 24 a8 34 10 00 	movl   $0x1034a8,(%esp)
  1001e2:	e8 2b 01 00 00       	call   100312 <cprintf>
    lab1_switch_to_user();
  1001e7:	e8 da ff ff ff       	call   1001c6 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001ec:	e8 0f ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001f1:	c7 04 24 c8 34 10 00 	movl   $0x1034c8,(%esp)
  1001f8:	e8 15 01 00 00       	call   100312 <cprintf>
    lab1_switch_to_kernel();
  1001fd:	e8 c9 ff ff ff       	call   1001cb <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100202:	e8 f9 fe ff ff       	call   100100 <lab1_print_cur_status>
}
  100207:	c9                   	leave  
  100208:	c3                   	ret    

00100209 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100209:	55                   	push   %ebp
  10020a:	89 e5                	mov    %esp,%ebp
  10020c:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  10020f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100213:	74 13                	je     100228 <readline+0x1f>
        cprintf("%s", prompt);
  100215:	8b 45 08             	mov    0x8(%ebp),%eax
  100218:	89 44 24 04          	mov    %eax,0x4(%esp)
  10021c:	c7 04 24 e7 34 10 00 	movl   $0x1034e7,(%esp)
  100223:	e8 ea 00 00 00       	call   100312 <cprintf>
    }
    int i = 0, c;
  100228:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10022f:	e8 66 01 00 00       	call   10039a <getchar>
  100234:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100237:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10023b:	79 07                	jns    100244 <readline+0x3b>
            return NULL;
  10023d:	b8 00 00 00 00       	mov    $0x0,%eax
  100242:	eb 79                	jmp    1002bd <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100244:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100248:	7e 28                	jle    100272 <readline+0x69>
  10024a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100251:	7f 1f                	jg     100272 <readline+0x69>
            cputchar(c);
  100253:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100256:	89 04 24             	mov    %eax,(%esp)
  100259:	e8 da 00 00 00       	call   100338 <cputchar>
            buf[i ++] = c;
  10025e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100261:	8d 50 01             	lea    0x1(%eax),%edx
  100264:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100267:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10026a:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100270:	eb 46                	jmp    1002b8 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  100272:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100276:	75 17                	jne    10028f <readline+0x86>
  100278:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10027c:	7e 11                	jle    10028f <readline+0x86>
            cputchar(c);
  10027e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100281:	89 04 24             	mov    %eax,(%esp)
  100284:	e8 af 00 00 00       	call   100338 <cputchar>
            i --;
  100289:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10028d:	eb 29                	jmp    1002b8 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  10028f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100293:	74 06                	je     10029b <readline+0x92>
  100295:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  100299:	75 1d                	jne    1002b8 <readline+0xaf>
            cputchar(c);
  10029b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10029e:	89 04 24             	mov    %eax,(%esp)
  1002a1:	e8 92 00 00 00       	call   100338 <cputchar>
            buf[i] = '\0';
  1002a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002a9:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1002ae:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002b1:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1002b6:	eb 05                	jmp    1002bd <readline+0xb4>
        }
    }
  1002b8:	e9 72 ff ff ff       	jmp    10022f <readline+0x26>
}
  1002bd:	c9                   	leave  
  1002be:	c3                   	ret    

001002bf <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002bf:	55                   	push   %ebp
  1002c0:	89 e5                	mov    %esp,%ebp
  1002c2:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 c6 12 00 00       	call   101596 <cons_putc>
    (*cnt) ++;
  1002d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002d3:	8b 00                	mov    (%eax),%eax
  1002d5:	8d 50 01             	lea    0x1(%eax),%edx
  1002d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002db:	89 10                	mov    %edx,(%eax)
}
  1002dd:	c9                   	leave  
  1002de:	c3                   	ret    

001002df <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002df:	55                   	push   %ebp
  1002e0:	89 e5                	mov    %esp,%ebp
  1002e2:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1002f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1002fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1002fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100301:	c7 04 24 bf 02 10 00 	movl   $0x1002bf,(%esp)
  100308:	e8 af 27 00 00       	call   102abc <vprintfmt>
    return cnt;
  10030d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100310:	c9                   	leave  
  100311:	c3                   	ret    

00100312 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100312:	55                   	push   %ebp
  100313:	89 e5                	mov    %esp,%ebp
  100315:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100318:	8d 45 0c             	lea    0xc(%ebp),%eax
  10031b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10031e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100321:	89 44 24 04          	mov    %eax,0x4(%esp)
  100325:	8b 45 08             	mov    0x8(%ebp),%eax
  100328:	89 04 24             	mov    %eax,(%esp)
  10032b:	e8 af ff ff ff       	call   1002df <vcprintf>
  100330:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100333:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100336:	c9                   	leave  
  100337:	c3                   	ret    

00100338 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100338:	55                   	push   %ebp
  100339:	89 e5                	mov    %esp,%ebp
  10033b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10033e:	8b 45 08             	mov    0x8(%ebp),%eax
  100341:	89 04 24             	mov    %eax,(%esp)
  100344:	e8 4d 12 00 00       	call   101596 <cons_putc>
}
  100349:	c9                   	leave  
  10034a:	c3                   	ret    

0010034b <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10034b:	55                   	push   %ebp
  10034c:	89 e5                	mov    %esp,%ebp
  10034e:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100351:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100358:	eb 13                	jmp    10036d <cputs+0x22>
        cputch(c, &cnt);
  10035a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10035e:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100361:	89 54 24 04          	mov    %edx,0x4(%esp)
  100365:	89 04 24             	mov    %eax,(%esp)
  100368:	e8 52 ff ff ff       	call   1002bf <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  10036d:	8b 45 08             	mov    0x8(%ebp),%eax
  100370:	8d 50 01             	lea    0x1(%eax),%edx
  100373:	89 55 08             	mov    %edx,0x8(%ebp)
  100376:	0f b6 00             	movzbl (%eax),%eax
  100379:	88 45 f7             	mov    %al,-0x9(%ebp)
  10037c:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100380:	75 d8                	jne    10035a <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  100382:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100385:	89 44 24 04          	mov    %eax,0x4(%esp)
  100389:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100390:	e8 2a ff ff ff       	call   1002bf <cputch>
    return cnt;
  100395:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100398:	c9                   	leave  
  100399:	c3                   	ret    

0010039a <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10039a:	55                   	push   %ebp
  10039b:	89 e5                	mov    %esp,%ebp
  10039d:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003a0:	e8 1a 12 00 00       	call   1015bf <cons_getc>
  1003a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003ac:	74 f2                	je     1003a0 <getchar+0x6>
        /* do nothing */;
    return c;
  1003ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003b1:	c9                   	leave  
  1003b2:	c3                   	ret    

001003b3 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003b3:	55                   	push   %ebp
  1003b4:	89 e5                	mov    %esp,%ebp
  1003b6:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003bc:	8b 00                	mov    (%eax),%eax
  1003be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1003c4:	8b 00                	mov    (%eax),%eax
  1003c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003d0:	e9 d2 00 00 00       	jmp    1004a7 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1003d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1003db:	01 d0                	add    %edx,%eax
  1003dd:	89 c2                	mov    %eax,%edx
  1003df:	c1 ea 1f             	shr    $0x1f,%edx
  1003e2:	01 d0                	add    %edx,%eax
  1003e4:	d1 f8                	sar    %eax
  1003e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1003e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1003ec:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003ef:	eb 04                	jmp    1003f5 <stab_binsearch+0x42>
            m --;
  1003f1:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1003fb:	7c 1f                	jl     10041c <stab_binsearch+0x69>
  1003fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100400:	89 d0                	mov    %edx,%eax
  100402:	01 c0                	add    %eax,%eax
  100404:	01 d0                	add    %edx,%eax
  100406:	c1 e0 02             	shl    $0x2,%eax
  100409:	89 c2                	mov    %eax,%edx
  10040b:	8b 45 08             	mov    0x8(%ebp),%eax
  10040e:	01 d0                	add    %edx,%eax
  100410:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100414:	0f b6 c0             	movzbl %al,%eax
  100417:	3b 45 14             	cmp    0x14(%ebp),%eax
  10041a:	75 d5                	jne    1003f1 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  10041c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10041f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100422:	7d 0b                	jge    10042f <stab_binsearch+0x7c>
            l = true_m + 1;
  100424:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100427:	83 c0 01             	add    $0x1,%eax
  10042a:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10042d:	eb 78                	jmp    1004a7 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  10042f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100436:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100439:	89 d0                	mov    %edx,%eax
  10043b:	01 c0                	add    %eax,%eax
  10043d:	01 d0                	add    %edx,%eax
  10043f:	c1 e0 02             	shl    $0x2,%eax
  100442:	89 c2                	mov    %eax,%edx
  100444:	8b 45 08             	mov    0x8(%ebp),%eax
  100447:	01 d0                	add    %edx,%eax
  100449:	8b 40 08             	mov    0x8(%eax),%eax
  10044c:	3b 45 18             	cmp    0x18(%ebp),%eax
  10044f:	73 13                	jae    100464 <stab_binsearch+0xb1>
            *region_left = m;
  100451:	8b 45 0c             	mov    0xc(%ebp),%eax
  100454:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100457:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100459:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10045c:	83 c0 01             	add    $0x1,%eax
  10045f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100462:	eb 43                	jmp    1004a7 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100464:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100467:	89 d0                	mov    %edx,%eax
  100469:	01 c0                	add    %eax,%eax
  10046b:	01 d0                	add    %edx,%eax
  10046d:	c1 e0 02             	shl    $0x2,%eax
  100470:	89 c2                	mov    %eax,%edx
  100472:	8b 45 08             	mov    0x8(%ebp),%eax
  100475:	01 d0                	add    %edx,%eax
  100477:	8b 40 08             	mov    0x8(%eax),%eax
  10047a:	3b 45 18             	cmp    0x18(%ebp),%eax
  10047d:	76 16                	jbe    100495 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10047f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100482:	8d 50 ff             	lea    -0x1(%eax),%edx
  100485:	8b 45 10             	mov    0x10(%ebp),%eax
  100488:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10048a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10048d:	83 e8 01             	sub    $0x1,%eax
  100490:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100493:	eb 12                	jmp    1004a7 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100495:	8b 45 0c             	mov    0xc(%ebp),%eax
  100498:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10049b:	89 10                	mov    %edx,(%eax)
            l = m;
  10049d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004a3:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004aa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004ad:	0f 8e 22 ff ff ff    	jle    1003d5 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004b7:	75 0f                	jne    1004c8 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004bc:	8b 00                	mov    (%eax),%eax
  1004be:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1004c4:	89 10                	mov    %edx,(%eax)
  1004c6:	eb 3f                	jmp    100507 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004c8:	8b 45 10             	mov    0x10(%ebp),%eax
  1004cb:	8b 00                	mov    (%eax),%eax
  1004cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004d0:	eb 04                	jmp    1004d6 <stab_binsearch+0x123>
  1004d2:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1004d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004d9:	8b 00                	mov    (%eax),%eax
  1004db:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004de:	7d 1f                	jge    1004ff <stab_binsearch+0x14c>
  1004e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004e3:	89 d0                	mov    %edx,%eax
  1004e5:	01 c0                	add    %eax,%eax
  1004e7:	01 d0                	add    %edx,%eax
  1004e9:	c1 e0 02             	shl    $0x2,%eax
  1004ec:	89 c2                	mov    %eax,%edx
  1004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1004f1:	01 d0                	add    %edx,%eax
  1004f3:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004f7:	0f b6 c0             	movzbl %al,%eax
  1004fa:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004fd:	75 d3                	jne    1004d2 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  100502:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100505:	89 10                	mov    %edx,(%eax)
    }
}
  100507:	c9                   	leave  
  100508:	c3                   	ret    

00100509 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100509:	55                   	push   %ebp
  10050a:	89 e5                	mov    %esp,%ebp
  10050c:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10050f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100512:	c7 00 ec 34 10 00    	movl   $0x1034ec,(%eax)
    info->eip_line = 0;
  100518:	8b 45 0c             	mov    0xc(%ebp),%eax
  10051b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100522:	8b 45 0c             	mov    0xc(%ebp),%eax
  100525:	c7 40 08 ec 34 10 00 	movl   $0x1034ec,0x8(%eax)
    info->eip_fn_namelen = 9;
  10052c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052f:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100536:	8b 45 0c             	mov    0xc(%ebp),%eax
  100539:	8b 55 08             	mov    0x8(%ebp),%edx
  10053c:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10053f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100542:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100549:	c7 45 f4 6c 3d 10 00 	movl   $0x103d6c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100550:	c7 45 f0 c4 b4 10 00 	movl   $0x10b4c4,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100557:	c7 45 ec c5 b4 10 00 	movl   $0x10b4c5,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10055e:	c7 45 e8 be d4 10 00 	movl   $0x10d4be,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100565:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100568:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10056b:	76 0d                	jbe    10057a <debuginfo_eip+0x71>
  10056d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100570:	83 e8 01             	sub    $0x1,%eax
  100573:	0f b6 00             	movzbl (%eax),%eax
  100576:	84 c0                	test   %al,%al
  100578:	74 0a                	je     100584 <debuginfo_eip+0x7b>
        return -1;
  10057a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10057f:	e9 c0 02 00 00       	jmp    100844 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100584:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10058b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10058e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100591:	29 c2                	sub    %eax,%edx
  100593:	89 d0                	mov    %edx,%eax
  100595:	c1 f8 02             	sar    $0x2,%eax
  100598:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10059e:	83 e8 01             	sub    $0x1,%eax
  1005a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005a7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005ab:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005b2:	00 
  1005b3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ba:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005c4:	89 04 24             	mov    %eax,(%esp)
  1005c7:	e8 e7 fd ff ff       	call   1003b3 <stab_binsearch>
    if (lfile == 0)
  1005cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005cf:	85 c0                	test   %eax,%eax
  1005d1:	75 0a                	jne    1005dd <debuginfo_eip+0xd4>
        return -1;
  1005d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005d8:	e9 67 02 00 00       	jmp    100844 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1005e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1005e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1005ec:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005f0:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1005f7:	00 
  1005f8:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1005fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ff:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100602:	89 44 24 04          	mov    %eax,0x4(%esp)
  100606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100609:	89 04 24             	mov    %eax,(%esp)
  10060c:	e8 a2 fd ff ff       	call   1003b3 <stab_binsearch>

    if (lfun <= rfun) {
  100611:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100614:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100617:	39 c2                	cmp    %eax,%edx
  100619:	7f 7c                	jg     100697 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10061b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10061e:	89 c2                	mov    %eax,%edx
  100620:	89 d0                	mov    %edx,%eax
  100622:	01 c0                	add    %eax,%eax
  100624:	01 d0                	add    %edx,%eax
  100626:	c1 e0 02             	shl    $0x2,%eax
  100629:	89 c2                	mov    %eax,%edx
  10062b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10062e:	01 d0                	add    %edx,%eax
  100630:	8b 10                	mov    (%eax),%edx
  100632:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100635:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100638:	29 c1                	sub    %eax,%ecx
  10063a:	89 c8                	mov    %ecx,%eax
  10063c:	39 c2                	cmp    %eax,%edx
  10063e:	73 22                	jae    100662 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100640:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100643:	89 c2                	mov    %eax,%edx
  100645:	89 d0                	mov    %edx,%eax
  100647:	01 c0                	add    %eax,%eax
  100649:	01 d0                	add    %edx,%eax
  10064b:	c1 e0 02             	shl    $0x2,%eax
  10064e:	89 c2                	mov    %eax,%edx
  100650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100653:	01 d0                	add    %edx,%eax
  100655:	8b 10                	mov    (%eax),%edx
  100657:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10065a:	01 c2                	add    %eax,%edx
  10065c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10065f:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100662:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100665:	89 c2                	mov    %eax,%edx
  100667:	89 d0                	mov    %edx,%eax
  100669:	01 c0                	add    %eax,%eax
  10066b:	01 d0                	add    %edx,%eax
  10066d:	c1 e0 02             	shl    $0x2,%eax
  100670:	89 c2                	mov    %eax,%edx
  100672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100675:	01 d0                	add    %edx,%eax
  100677:	8b 50 08             	mov    0x8(%eax),%edx
  10067a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10067d:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100680:	8b 45 0c             	mov    0xc(%ebp),%eax
  100683:	8b 40 10             	mov    0x10(%eax),%eax
  100686:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100689:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10068f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100692:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100695:	eb 15                	jmp    1006ac <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100697:	8b 45 0c             	mov    0xc(%ebp),%eax
  10069a:	8b 55 08             	mov    0x8(%ebp),%edx
  10069d:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006a9:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006af:	8b 40 08             	mov    0x8(%eax),%eax
  1006b2:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006b9:	00 
  1006ba:	89 04 24             	mov    %eax,(%esp)
  1006bd:	e8 55 2a 00 00       	call   103117 <strfind>
  1006c2:	89 c2                	mov    %eax,%edx
  1006c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c7:	8b 40 08             	mov    0x8(%eax),%eax
  1006ca:	29 c2                	sub    %eax,%edx
  1006cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006cf:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1006d5:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006d9:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1006e0:	00 
  1006e1:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006e8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1006eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f2:	89 04 24             	mov    %eax,(%esp)
  1006f5:	e8 b9 fc ff ff       	call   1003b3 <stab_binsearch>
    if (lline <= rline) {
  1006fa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1006fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100700:	39 c2                	cmp    %eax,%edx
  100702:	7f 24                	jg     100728 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  100704:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100707:	89 c2                	mov    %eax,%edx
  100709:	89 d0                	mov    %edx,%eax
  10070b:	01 c0                	add    %eax,%eax
  10070d:	01 d0                	add    %edx,%eax
  10070f:	c1 e0 02             	shl    $0x2,%eax
  100712:	89 c2                	mov    %eax,%edx
  100714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100717:	01 d0                	add    %edx,%eax
  100719:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10071d:	0f b7 d0             	movzwl %ax,%edx
  100720:	8b 45 0c             	mov    0xc(%ebp),%eax
  100723:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100726:	eb 13                	jmp    10073b <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100728:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10072d:	e9 12 01 00 00       	jmp    100844 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100732:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100735:	83 e8 01             	sub    $0x1,%eax
  100738:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10073b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10073e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100741:	39 c2                	cmp    %eax,%edx
  100743:	7c 56                	jl     10079b <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  100745:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100748:	89 c2                	mov    %eax,%edx
  10074a:	89 d0                	mov    %edx,%eax
  10074c:	01 c0                	add    %eax,%eax
  10074e:	01 d0                	add    %edx,%eax
  100750:	c1 e0 02             	shl    $0x2,%eax
  100753:	89 c2                	mov    %eax,%edx
  100755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100758:	01 d0                	add    %edx,%eax
  10075a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10075e:	3c 84                	cmp    $0x84,%al
  100760:	74 39                	je     10079b <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100762:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100765:	89 c2                	mov    %eax,%edx
  100767:	89 d0                	mov    %edx,%eax
  100769:	01 c0                	add    %eax,%eax
  10076b:	01 d0                	add    %edx,%eax
  10076d:	c1 e0 02             	shl    $0x2,%eax
  100770:	89 c2                	mov    %eax,%edx
  100772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100775:	01 d0                	add    %edx,%eax
  100777:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10077b:	3c 64                	cmp    $0x64,%al
  10077d:	75 b3                	jne    100732 <debuginfo_eip+0x229>
  10077f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100782:	89 c2                	mov    %eax,%edx
  100784:	89 d0                	mov    %edx,%eax
  100786:	01 c0                	add    %eax,%eax
  100788:	01 d0                	add    %edx,%eax
  10078a:	c1 e0 02             	shl    $0x2,%eax
  10078d:	89 c2                	mov    %eax,%edx
  10078f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100792:	01 d0                	add    %edx,%eax
  100794:	8b 40 08             	mov    0x8(%eax),%eax
  100797:	85 c0                	test   %eax,%eax
  100799:	74 97                	je     100732 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10079b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10079e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007a1:	39 c2                	cmp    %eax,%edx
  1007a3:	7c 46                	jl     1007eb <debuginfo_eip+0x2e2>
  1007a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007a8:	89 c2                	mov    %eax,%edx
  1007aa:	89 d0                	mov    %edx,%eax
  1007ac:	01 c0                	add    %eax,%eax
  1007ae:	01 d0                	add    %edx,%eax
  1007b0:	c1 e0 02             	shl    $0x2,%eax
  1007b3:	89 c2                	mov    %eax,%edx
  1007b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007b8:	01 d0                	add    %edx,%eax
  1007ba:	8b 10                	mov    (%eax),%edx
  1007bc:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007c2:	29 c1                	sub    %eax,%ecx
  1007c4:	89 c8                	mov    %ecx,%eax
  1007c6:	39 c2                	cmp    %eax,%edx
  1007c8:	73 21                	jae    1007eb <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007cd:	89 c2                	mov    %eax,%edx
  1007cf:	89 d0                	mov    %edx,%eax
  1007d1:	01 c0                	add    %eax,%eax
  1007d3:	01 d0                	add    %edx,%eax
  1007d5:	c1 e0 02             	shl    $0x2,%eax
  1007d8:	89 c2                	mov    %eax,%edx
  1007da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007dd:	01 d0                	add    %edx,%eax
  1007df:	8b 10                	mov    (%eax),%edx
  1007e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007e4:	01 c2                	add    %eax,%edx
  1007e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007e9:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007eb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007f1:	39 c2                	cmp    %eax,%edx
  1007f3:	7d 4a                	jge    10083f <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  1007f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007f8:	83 c0 01             	add    $0x1,%eax
  1007fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1007fe:	eb 18                	jmp    100818 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100800:	8b 45 0c             	mov    0xc(%ebp),%eax
  100803:	8b 40 14             	mov    0x14(%eax),%eax
  100806:	8d 50 01             	lea    0x1(%eax),%edx
  100809:	8b 45 0c             	mov    0xc(%ebp),%eax
  10080c:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  10080f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100812:	83 c0 01             	add    $0x1,%eax
  100815:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100818:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10081b:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  10081e:	39 c2                	cmp    %eax,%edx
  100820:	7d 1d                	jge    10083f <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100822:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100825:	89 c2                	mov    %eax,%edx
  100827:	89 d0                	mov    %edx,%eax
  100829:	01 c0                	add    %eax,%eax
  10082b:	01 d0                	add    %edx,%eax
  10082d:	c1 e0 02             	shl    $0x2,%eax
  100830:	89 c2                	mov    %eax,%edx
  100832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100835:	01 d0                	add    %edx,%eax
  100837:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10083b:	3c a0                	cmp    $0xa0,%al
  10083d:	74 c1                	je     100800 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  10083f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100844:	c9                   	leave  
  100845:	c3                   	ret    

00100846 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100846:	55                   	push   %ebp
  100847:	89 e5                	mov    %esp,%ebp
  100849:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10084c:	c7 04 24 f6 34 10 00 	movl   $0x1034f6,(%esp)
  100853:	e8 ba fa ff ff       	call   100312 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100858:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10085f:	00 
  100860:	c7 04 24 0f 35 10 00 	movl   $0x10350f,(%esp)
  100867:	e8 a6 fa ff ff       	call   100312 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10086c:	c7 44 24 04 2c 34 10 	movl   $0x10342c,0x4(%esp)
  100873:	00 
  100874:	c7 04 24 27 35 10 00 	movl   $0x103527,(%esp)
  10087b:	e8 92 fa ff ff       	call   100312 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100880:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100887:	00 
  100888:	c7 04 24 3f 35 10 00 	movl   $0x10353f,(%esp)
  10088f:	e8 7e fa ff ff       	call   100312 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100894:	c7 44 24 04 20 fd 10 	movl   $0x10fd20,0x4(%esp)
  10089b:	00 
  10089c:	c7 04 24 57 35 10 00 	movl   $0x103557,(%esp)
  1008a3:	e8 6a fa ff ff       	call   100312 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008a8:	b8 20 fd 10 00       	mov    $0x10fd20,%eax
  1008ad:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008b3:	b8 00 00 10 00       	mov    $0x100000,%eax
  1008b8:	29 c2                	sub    %eax,%edx
  1008ba:	89 d0                	mov    %edx,%eax
  1008bc:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008c2:	85 c0                	test   %eax,%eax
  1008c4:	0f 48 c2             	cmovs  %edx,%eax
  1008c7:	c1 f8 0a             	sar    $0xa,%eax
  1008ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008ce:	c7 04 24 70 35 10 00 	movl   $0x103570,(%esp)
  1008d5:	e8 38 fa ff ff       	call   100312 <cprintf>
}
  1008da:	c9                   	leave  
  1008db:	c3                   	ret    

001008dc <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008dc:	55                   	push   %ebp
  1008dd:	89 e5                	mov    %esp,%ebp
  1008df:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008e5:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1008ef:	89 04 24             	mov    %eax,(%esp)
  1008f2:	e8 12 fc ff ff       	call   100509 <debuginfo_eip>
  1008f7:	85 c0                	test   %eax,%eax
  1008f9:	74 15                	je     100910 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1008fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  100902:	c7 04 24 9a 35 10 00 	movl   $0x10359a,(%esp)
  100909:	e8 04 fa ff ff       	call   100312 <cprintf>
  10090e:	eb 6d                	jmp    10097d <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100910:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100917:	eb 1c                	jmp    100935 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100919:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10091c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10091f:	01 d0                	add    %edx,%eax
  100921:	0f b6 00             	movzbl (%eax),%eax
  100924:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10092a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10092d:	01 ca                	add    %ecx,%edx
  10092f:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100931:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100935:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100938:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10093b:	7f dc                	jg     100919 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  10093d:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100946:	01 d0                	add    %edx,%eax
  100948:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  10094b:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  10094e:	8b 55 08             	mov    0x8(%ebp),%edx
  100951:	89 d1                	mov    %edx,%ecx
  100953:	29 c1                	sub    %eax,%ecx
  100955:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100958:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10095b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10095f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100965:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100969:	89 54 24 08          	mov    %edx,0x8(%esp)
  10096d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100971:	c7 04 24 b6 35 10 00 	movl   $0x1035b6,(%esp)
  100978:	e8 95 f9 ff ff       	call   100312 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  10097d:	c9                   	leave  
  10097e:	c3                   	ret    

0010097f <read_eip>:

static __noinline uint32_t
read_eip(void) {
  10097f:	55                   	push   %ebp
  100980:	89 e5                	mov    %esp,%ebp
  100982:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100985:	8b 45 04             	mov    0x4(%ebp),%eax
  100988:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  10098b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10098e:	c9                   	leave  
  10098f:	c3                   	ret    

00100990 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100990:	55                   	push   %ebp
  100991:	89 e5                	mov    %esp,%ebp
  100993:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100996:	89 e8                	mov    %ebp,%eax
  100998:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  10099b:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
  10099e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
  1009a1:	e8 d9 ff ff ff       	call   10097f <read_eip>
  1009a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i, j;
	for(i = 0; i < STACKFRAME_DEPTH; i++)
  1009a9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009b0:	e9 93 00 00 00       	jmp    100a48 <print_stackframe+0xb8>
	{
		if(ebp == 0)
  1009b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1009b9:	75 05                	jne    1009c0 <print_stackframe+0x30>
			break;
  1009bb:	e9 92 00 00 00       	jmp    100a52 <print_stackframe+0xc2>
		 cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  1009c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009ce:	c7 04 24 c8 35 10 00 	movl   $0x1035c8,(%esp)
  1009d5:	e8 38 f9 ff ff       	call   100312 <cprintf>
		 uint32_t *args = (uint32_t *)ebp + 2;
  1009da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009dd:	83 c0 08             	add    $0x8,%eax
  1009e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		 for (j = 0; j < 4; j ++)
  1009e3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  1009ea:	eb 25                	jmp    100a11 <print_stackframe+0x81>
		      cprintf("0x%08x ", args[j]);
  1009ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1009f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1009f9:	01 d0                	add    %edx,%eax
  1009fb:	8b 00                	mov    (%eax),%eax
  1009fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a01:	c7 04 24 e4 35 10 00 	movl   $0x1035e4,(%esp)
  100a08:	e8 05 f9 ff ff       	call   100312 <cprintf>
	{
		if(ebp == 0)
			break;
		 cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
		 uint32_t *args = (uint32_t *)ebp + 2;
		 for (j = 0; j < 4; j ++)
  100a0d:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a11:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a15:	7e d5                	jle    1009ec <print_stackframe+0x5c>
		      cprintf("0x%08x ", args[j]);

		 cprintf("\n");
  100a17:	c7 04 24 ec 35 10 00 	movl   $0x1035ec,(%esp)
  100a1e:	e8 ef f8 ff ff       	call   100312 <cprintf>
		 print_debuginfo(eip - 1);
  100a23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a26:	83 e8 01             	sub    $0x1,%eax
  100a29:	89 04 24             	mov    %eax,(%esp)
  100a2c:	e8 ab fe ff ff       	call   1008dc <print_debuginfo>
		 eip = ((uint32_t *)ebp)[1];
  100a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a34:	83 c0 04             	add    $0x4,%eax
  100a37:	8b 00                	mov    (%eax),%eax
  100a39:	89 45 f0             	mov    %eax,-0x10(%ebp)
		 ebp = ((uint32_t *)ebp)[0];
  100a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a3f:	8b 00                	mov    (%eax),%eax
  100a41:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();
	int i, j;
	for(i = 0; i < STACKFRAME_DEPTH; i++)
  100a44:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a48:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a4c:	0f 8e 63 ff ff ff    	jle    1009b5 <print_stackframe+0x25>
		 print_debuginfo(eip - 1);
		 eip = ((uint32_t *)ebp)[1];
		 ebp = ((uint32_t *)ebp)[0];
	}

}
  100a52:	c9                   	leave  
  100a53:	c3                   	ret    

00100a54 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a54:	55                   	push   %ebp
  100a55:	89 e5                	mov    %esp,%ebp
  100a57:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a5a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a61:	eb 0c                	jmp    100a6f <parse+0x1b>
            *buf ++ = '\0';
  100a63:	8b 45 08             	mov    0x8(%ebp),%eax
  100a66:	8d 50 01             	lea    0x1(%eax),%edx
  100a69:	89 55 08             	mov    %edx,0x8(%ebp)
  100a6c:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  100a72:	0f b6 00             	movzbl (%eax),%eax
  100a75:	84 c0                	test   %al,%al
  100a77:	74 1d                	je     100a96 <parse+0x42>
  100a79:	8b 45 08             	mov    0x8(%ebp),%eax
  100a7c:	0f b6 00             	movzbl (%eax),%eax
  100a7f:	0f be c0             	movsbl %al,%eax
  100a82:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a86:	c7 04 24 70 36 10 00 	movl   $0x103670,(%esp)
  100a8d:	e8 52 26 00 00       	call   1030e4 <strchr>
  100a92:	85 c0                	test   %eax,%eax
  100a94:	75 cd                	jne    100a63 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100a96:	8b 45 08             	mov    0x8(%ebp),%eax
  100a99:	0f b6 00             	movzbl (%eax),%eax
  100a9c:	84 c0                	test   %al,%al
  100a9e:	75 02                	jne    100aa2 <parse+0x4e>
            break;
  100aa0:	eb 67                	jmp    100b09 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100aa2:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100aa6:	75 14                	jne    100abc <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100aa8:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100aaf:	00 
  100ab0:	c7 04 24 75 36 10 00 	movl   $0x103675,(%esp)
  100ab7:	e8 56 f8 ff ff       	call   100312 <cprintf>
        }
        argv[argc ++] = buf;
  100abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100abf:	8d 50 01             	lea    0x1(%eax),%edx
  100ac2:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100ac5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100acc:	8b 45 0c             	mov    0xc(%ebp),%eax
  100acf:	01 c2                	add    %eax,%edx
  100ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  100ad4:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ad6:	eb 04                	jmp    100adc <parse+0x88>
            buf ++;
  100ad8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100adc:	8b 45 08             	mov    0x8(%ebp),%eax
  100adf:	0f b6 00             	movzbl (%eax),%eax
  100ae2:	84 c0                	test   %al,%al
  100ae4:	74 1d                	je     100b03 <parse+0xaf>
  100ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  100ae9:	0f b6 00             	movzbl (%eax),%eax
  100aec:	0f be c0             	movsbl %al,%eax
  100aef:	89 44 24 04          	mov    %eax,0x4(%esp)
  100af3:	c7 04 24 70 36 10 00 	movl   $0x103670,(%esp)
  100afa:	e8 e5 25 00 00       	call   1030e4 <strchr>
  100aff:	85 c0                	test   %eax,%eax
  100b01:	74 d5                	je     100ad8 <parse+0x84>
            buf ++;
        }
    }
  100b03:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b04:	e9 66 ff ff ff       	jmp    100a6f <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b0c:	c9                   	leave  
  100b0d:	c3                   	ret    

00100b0e <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b0e:	55                   	push   %ebp
  100b0f:	89 e5                	mov    %esp,%ebp
  100b11:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b14:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b17:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b1e:	89 04 24             	mov    %eax,(%esp)
  100b21:	e8 2e ff ff ff       	call   100a54 <parse>
  100b26:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b29:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b2d:	75 0a                	jne    100b39 <runcmd+0x2b>
        return 0;
  100b2f:	b8 00 00 00 00       	mov    $0x0,%eax
  100b34:	e9 85 00 00 00       	jmp    100bbe <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b40:	eb 5c                	jmp    100b9e <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b42:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b48:	89 d0                	mov    %edx,%eax
  100b4a:	01 c0                	add    %eax,%eax
  100b4c:	01 d0                	add    %edx,%eax
  100b4e:	c1 e0 02             	shl    $0x2,%eax
  100b51:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b56:	8b 00                	mov    (%eax),%eax
  100b58:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b5c:	89 04 24             	mov    %eax,(%esp)
  100b5f:	e8 e1 24 00 00       	call   103045 <strcmp>
  100b64:	85 c0                	test   %eax,%eax
  100b66:	75 32                	jne    100b9a <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b6b:	89 d0                	mov    %edx,%eax
  100b6d:	01 c0                	add    %eax,%eax
  100b6f:	01 d0                	add    %edx,%eax
  100b71:	c1 e0 02             	shl    $0x2,%eax
  100b74:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b79:	8b 40 08             	mov    0x8(%eax),%eax
  100b7c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100b7f:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100b82:	8b 55 0c             	mov    0xc(%ebp),%edx
  100b85:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b89:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100b8c:	83 c2 04             	add    $0x4,%edx
  100b8f:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b93:	89 0c 24             	mov    %ecx,(%esp)
  100b96:	ff d0                	call   *%eax
  100b98:	eb 24                	jmp    100bbe <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b9a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ba1:	83 f8 02             	cmp    $0x2,%eax
  100ba4:	76 9c                	jbe    100b42 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100ba6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100ba9:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bad:	c7 04 24 93 36 10 00 	movl   $0x103693,(%esp)
  100bb4:	e8 59 f7 ff ff       	call   100312 <cprintf>
    return 0;
  100bb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bbe:	c9                   	leave  
  100bbf:	c3                   	ret    

00100bc0 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bc0:	55                   	push   %ebp
  100bc1:	89 e5                	mov    %esp,%ebp
  100bc3:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bc6:	c7 04 24 ac 36 10 00 	movl   $0x1036ac,(%esp)
  100bcd:	e8 40 f7 ff ff       	call   100312 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bd2:	c7 04 24 d4 36 10 00 	movl   $0x1036d4,(%esp)
  100bd9:	e8 34 f7 ff ff       	call   100312 <cprintf>

    if (tf != NULL) {
  100bde:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100be2:	74 0b                	je     100bef <kmonitor+0x2f>
        print_trapframe(tf);
  100be4:	8b 45 08             	mov    0x8(%ebp),%eax
  100be7:	89 04 24             	mov    %eax,(%esp)
  100bea:	e8 79 0d 00 00       	call   101968 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100bef:	c7 04 24 f9 36 10 00 	movl   $0x1036f9,(%esp)
  100bf6:	e8 0e f6 ff ff       	call   100209 <readline>
  100bfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100bfe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c02:	74 18                	je     100c1c <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c04:	8b 45 08             	mov    0x8(%ebp),%eax
  100c07:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c0e:	89 04 24             	mov    %eax,(%esp)
  100c11:	e8 f8 fe ff ff       	call   100b0e <runcmd>
  100c16:	85 c0                	test   %eax,%eax
  100c18:	79 02                	jns    100c1c <kmonitor+0x5c>
                break;
  100c1a:	eb 02                	jmp    100c1e <kmonitor+0x5e>
            }
        }
    }
  100c1c:	eb d1                	jmp    100bef <kmonitor+0x2f>
}
  100c1e:	c9                   	leave  
  100c1f:	c3                   	ret    

00100c20 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c20:	55                   	push   %ebp
  100c21:	89 e5                	mov    %esp,%ebp
  100c23:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c2d:	eb 3f                	jmp    100c6e <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c32:	89 d0                	mov    %edx,%eax
  100c34:	01 c0                	add    %eax,%eax
  100c36:	01 d0                	add    %edx,%eax
  100c38:	c1 e0 02             	shl    $0x2,%eax
  100c3b:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c40:	8b 48 04             	mov    0x4(%eax),%ecx
  100c43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c46:	89 d0                	mov    %edx,%eax
  100c48:	01 c0                	add    %eax,%eax
  100c4a:	01 d0                	add    %edx,%eax
  100c4c:	c1 e0 02             	shl    $0x2,%eax
  100c4f:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c54:	8b 00                	mov    (%eax),%eax
  100c56:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c5e:	c7 04 24 fd 36 10 00 	movl   $0x1036fd,(%esp)
  100c65:	e8 a8 f6 ff ff       	call   100312 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c6a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c71:	83 f8 02             	cmp    $0x2,%eax
  100c74:	76 b9                	jbe    100c2f <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c7b:	c9                   	leave  
  100c7c:	c3                   	ret    

00100c7d <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c7d:	55                   	push   %ebp
  100c7e:	89 e5                	mov    %esp,%ebp
  100c80:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c83:	e8 be fb ff ff       	call   100846 <print_kerninfo>
    return 0;
  100c88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c8d:	c9                   	leave  
  100c8e:	c3                   	ret    

00100c8f <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c8f:	55                   	push   %ebp
  100c90:	89 e5                	mov    %esp,%ebp
  100c92:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100c95:	e8 f6 fc ff ff       	call   100990 <print_stackframe>
    return 0;
  100c9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c9f:	c9                   	leave  
  100ca0:	c3                   	ret    

00100ca1 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100ca1:	55                   	push   %ebp
  100ca2:	89 e5                	mov    %esp,%ebp
  100ca4:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100ca7:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  100cac:	85 c0                	test   %eax,%eax
  100cae:	74 02                	je     100cb2 <__panic+0x11>
        goto panic_dead;
  100cb0:	eb 48                	jmp    100cfa <__panic+0x59>
    }
    is_panic = 1;
  100cb2:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  100cb9:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cbc:	8d 45 14             	lea    0x14(%ebp),%eax
  100cbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cc5:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  100ccc:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cd0:	c7 04 24 06 37 10 00 	movl   $0x103706,(%esp)
  100cd7:	e8 36 f6 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cdf:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ce3:	8b 45 10             	mov    0x10(%ebp),%eax
  100ce6:	89 04 24             	mov    %eax,(%esp)
  100ce9:	e8 f1 f5 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100cee:	c7 04 24 22 37 10 00 	movl   $0x103722,(%esp)
  100cf5:	e8 18 f6 ff ff       	call   100312 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100cfa:	e8 22 09 00 00       	call   101621 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100cff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d06:	e8 b5 fe ff ff       	call   100bc0 <kmonitor>
    }
  100d0b:	eb f2                	jmp    100cff <__panic+0x5e>

00100d0d <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d0d:	55                   	push   %ebp
  100d0e:	89 e5                	mov    %esp,%ebp
  100d10:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d13:	8d 45 14             	lea    0x14(%ebp),%eax
  100d16:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d19:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d1c:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d20:	8b 45 08             	mov    0x8(%ebp),%eax
  100d23:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d27:	c7 04 24 24 37 10 00 	movl   $0x103724,(%esp)
  100d2e:	e8 df f5 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d36:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d3a:	8b 45 10             	mov    0x10(%ebp),%eax
  100d3d:	89 04 24             	mov    %eax,(%esp)
  100d40:	e8 9a f5 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100d45:	c7 04 24 22 37 10 00 	movl   $0x103722,(%esp)
  100d4c:	e8 c1 f5 ff ff       	call   100312 <cprintf>
    va_end(ap);
}
  100d51:	c9                   	leave  
  100d52:	c3                   	ret    

00100d53 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d53:	55                   	push   %ebp
  100d54:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d56:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100d5b:	5d                   	pop    %ebp
  100d5c:	c3                   	ret    

00100d5d <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d5d:	55                   	push   %ebp
  100d5e:	89 e5                	mov    %esp,%ebp
  100d60:	83 ec 28             	sub    $0x28,%esp
  100d63:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d69:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d6d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d71:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d75:	ee                   	out    %al,(%dx)
  100d76:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d7c:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d80:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d84:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d88:	ee                   	out    %al,(%dx)
  100d89:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100d8f:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100d93:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d97:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d9b:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d9c:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100da3:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100da6:	c7 04 24 42 37 10 00 	movl   $0x103742,(%esp)
  100dad:	e8 60 f5 ff ff       	call   100312 <cprintf>
    pic_enable(IRQ_TIMER);
  100db2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100db9:	e8 c1 08 00 00       	call   10167f <pic_enable>
}
  100dbe:	c9                   	leave  
  100dbf:	c3                   	ret    

00100dc0 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100dc0:	55                   	push   %ebp
  100dc1:	89 e5                	mov    %esp,%ebp
  100dc3:	83 ec 10             	sub    $0x10,%esp
  100dc6:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100dcc:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100dd0:	89 c2                	mov    %eax,%edx
  100dd2:	ec                   	in     (%dx),%al
  100dd3:	88 45 fd             	mov    %al,-0x3(%ebp)
  100dd6:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100ddc:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100de0:	89 c2                	mov    %eax,%edx
  100de2:	ec                   	in     (%dx),%al
  100de3:	88 45 f9             	mov    %al,-0x7(%ebp)
  100de6:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100dec:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100df0:	89 c2                	mov    %eax,%edx
  100df2:	ec                   	in     (%dx),%al
  100df3:	88 45 f5             	mov    %al,-0xb(%ebp)
  100df6:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100dfc:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e00:	89 c2                	mov    %eax,%edx
  100e02:	ec                   	in     (%dx),%al
  100e03:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e06:	c9                   	leave  
  100e07:	c3                   	ret    

00100e08 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e08:	55                   	push   %ebp
  100e09:	89 e5                	mov    %esp,%ebp
  100e0b:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e0e:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e15:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e18:	0f b7 00             	movzwl (%eax),%eax
  100e1b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e22:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e27:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e2a:	0f b7 00             	movzwl (%eax),%eax
  100e2d:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e31:	74 12                	je     100e45 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e33:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e3a:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e41:	b4 03 
  100e43:	eb 13                	jmp    100e58 <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e45:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e48:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e4c:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e4f:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e56:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e58:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e5f:	0f b7 c0             	movzwl %ax,%eax
  100e62:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100e66:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e6a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e6e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e72:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e73:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e7a:	83 c0 01             	add    $0x1,%eax
  100e7d:	0f b7 c0             	movzwl %ax,%eax
  100e80:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e84:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100e88:	89 c2                	mov    %eax,%edx
  100e8a:	ec                   	in     (%dx),%al
  100e8b:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100e8e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e92:	0f b6 c0             	movzbl %al,%eax
  100e95:	c1 e0 08             	shl    $0x8,%eax
  100e98:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e9b:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ea2:	0f b7 c0             	movzwl %ax,%eax
  100ea5:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100ea9:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ead:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100eb1:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100eb5:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100eb6:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ebd:	83 c0 01             	add    $0x1,%eax
  100ec0:	0f b7 c0             	movzwl %ax,%eax
  100ec3:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ec7:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100ecb:	89 c2                	mov    %eax,%edx
  100ecd:	ec                   	in     (%dx),%al
  100ece:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100ed1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ed5:	0f b6 c0             	movzbl %al,%eax
  100ed8:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100edb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ede:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ee6:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100eec:	c9                   	leave  
  100eed:	c3                   	ret    

00100eee <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100eee:	55                   	push   %ebp
  100eef:	89 e5                	mov    %esp,%ebp
  100ef1:	83 ec 48             	sub    $0x48,%esp
  100ef4:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100efa:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100efe:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f02:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f06:	ee                   	out    %al,(%dx)
  100f07:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f0d:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f11:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f15:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f19:	ee                   	out    %al,(%dx)
  100f1a:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f20:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f24:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f28:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f2c:	ee                   	out    %al,(%dx)
  100f2d:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f33:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f37:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f3b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f3f:	ee                   	out    %al,(%dx)
  100f40:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100f46:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f4a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f4e:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f52:	ee                   	out    %al,(%dx)
  100f53:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f59:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f5d:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f61:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f65:	ee                   	out    %al,(%dx)
  100f66:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f6c:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f70:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f74:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f78:	ee                   	out    %al,(%dx)
  100f79:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f7f:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100f83:	89 c2                	mov    %eax,%edx
  100f85:	ec                   	in     (%dx),%al
  100f86:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100f89:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f8d:	3c ff                	cmp    $0xff,%al
  100f8f:	0f 95 c0             	setne  %al
  100f92:	0f b6 c0             	movzbl %al,%eax
  100f95:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100f9a:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fa0:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100fa4:	89 c2                	mov    %eax,%edx
  100fa6:	ec                   	in     (%dx),%al
  100fa7:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100faa:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100fb0:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100fb4:	89 c2                	mov    %eax,%edx
  100fb6:	ec                   	in     (%dx),%al
  100fb7:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fba:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fbf:	85 c0                	test   %eax,%eax
  100fc1:	74 0c                	je     100fcf <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100fc3:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100fca:	e8 b0 06 00 00       	call   10167f <pic_enable>
    }
}
  100fcf:	c9                   	leave  
  100fd0:	c3                   	ret    

00100fd1 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fd1:	55                   	push   %ebp
  100fd2:	89 e5                	mov    %esp,%ebp
  100fd4:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fd7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fde:	eb 09                	jmp    100fe9 <lpt_putc_sub+0x18>
        delay();
  100fe0:	e8 db fd ff ff       	call   100dc0 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fe5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fe9:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100fef:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100ff3:	89 c2                	mov    %eax,%edx
  100ff5:	ec                   	in     (%dx),%al
  100ff6:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100ff9:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  100ffd:	84 c0                	test   %al,%al
  100fff:	78 09                	js     10100a <lpt_putc_sub+0x39>
  101001:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101008:	7e d6                	jle    100fe0 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  10100a:	8b 45 08             	mov    0x8(%ebp),%eax
  10100d:	0f b6 c0             	movzbl %al,%eax
  101010:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101016:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101019:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10101d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101021:	ee                   	out    %al,(%dx)
  101022:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101028:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10102c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101030:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101034:	ee                   	out    %al,(%dx)
  101035:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  10103b:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  10103f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101043:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101047:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101048:	c9                   	leave  
  101049:	c3                   	ret    

0010104a <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10104a:	55                   	push   %ebp
  10104b:	89 e5                	mov    %esp,%ebp
  10104d:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101050:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101054:	74 0d                	je     101063 <lpt_putc+0x19>
        lpt_putc_sub(c);
  101056:	8b 45 08             	mov    0x8(%ebp),%eax
  101059:	89 04 24             	mov    %eax,(%esp)
  10105c:	e8 70 ff ff ff       	call   100fd1 <lpt_putc_sub>
  101061:	eb 24                	jmp    101087 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  101063:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10106a:	e8 62 ff ff ff       	call   100fd1 <lpt_putc_sub>
        lpt_putc_sub(' ');
  10106f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101076:	e8 56 ff ff ff       	call   100fd1 <lpt_putc_sub>
        lpt_putc_sub('\b');
  10107b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101082:	e8 4a ff ff ff       	call   100fd1 <lpt_putc_sub>
    }
}
  101087:	c9                   	leave  
  101088:	c3                   	ret    

00101089 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101089:	55                   	push   %ebp
  10108a:	89 e5                	mov    %esp,%ebp
  10108c:	53                   	push   %ebx
  10108d:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101090:	8b 45 08             	mov    0x8(%ebp),%eax
  101093:	b0 00                	mov    $0x0,%al
  101095:	85 c0                	test   %eax,%eax
  101097:	75 07                	jne    1010a0 <cga_putc+0x17>
        c |= 0x0700;
  101099:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1010a3:	0f b6 c0             	movzbl %al,%eax
  1010a6:	83 f8 0a             	cmp    $0xa,%eax
  1010a9:	74 4c                	je     1010f7 <cga_putc+0x6e>
  1010ab:	83 f8 0d             	cmp    $0xd,%eax
  1010ae:	74 57                	je     101107 <cga_putc+0x7e>
  1010b0:	83 f8 08             	cmp    $0x8,%eax
  1010b3:	0f 85 88 00 00 00    	jne    101141 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  1010b9:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010c0:	66 85 c0             	test   %ax,%ax
  1010c3:	74 30                	je     1010f5 <cga_putc+0x6c>
            crt_pos --;
  1010c5:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010cc:	83 e8 01             	sub    $0x1,%eax
  1010cf:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010d5:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010da:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010e1:	0f b7 d2             	movzwl %dx,%edx
  1010e4:	01 d2                	add    %edx,%edx
  1010e6:	01 c2                	add    %eax,%edx
  1010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1010eb:	b0 00                	mov    $0x0,%al
  1010ed:	83 c8 20             	or     $0x20,%eax
  1010f0:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1010f3:	eb 72                	jmp    101167 <cga_putc+0xde>
  1010f5:	eb 70                	jmp    101167 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  1010f7:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010fe:	83 c0 50             	add    $0x50,%eax
  101101:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101107:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  10110e:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  101115:	0f b7 c1             	movzwl %cx,%eax
  101118:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  10111e:	c1 e8 10             	shr    $0x10,%eax
  101121:	89 c2                	mov    %eax,%edx
  101123:	66 c1 ea 06          	shr    $0x6,%dx
  101127:	89 d0                	mov    %edx,%eax
  101129:	c1 e0 02             	shl    $0x2,%eax
  10112c:	01 d0                	add    %edx,%eax
  10112e:	c1 e0 04             	shl    $0x4,%eax
  101131:	29 c1                	sub    %eax,%ecx
  101133:	89 ca                	mov    %ecx,%edx
  101135:	89 d8                	mov    %ebx,%eax
  101137:	29 d0                	sub    %edx,%eax
  101139:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  10113f:	eb 26                	jmp    101167 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101141:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  101147:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10114e:	8d 50 01             	lea    0x1(%eax),%edx
  101151:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101158:	0f b7 c0             	movzwl %ax,%eax
  10115b:	01 c0                	add    %eax,%eax
  10115d:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101160:	8b 45 08             	mov    0x8(%ebp),%eax
  101163:	66 89 02             	mov    %ax,(%edx)
        break;
  101166:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101167:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10116e:	66 3d cf 07          	cmp    $0x7cf,%ax
  101172:	76 5b                	jbe    1011cf <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101174:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101179:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10117f:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101184:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  10118b:	00 
  10118c:	89 54 24 04          	mov    %edx,0x4(%esp)
  101190:	89 04 24             	mov    %eax,(%esp)
  101193:	e8 4a 21 00 00       	call   1032e2 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101198:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10119f:	eb 15                	jmp    1011b6 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  1011a1:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011a9:	01 d2                	add    %edx,%edx
  1011ab:	01 d0                	add    %edx,%eax
  1011ad:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011b2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011b6:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011bd:	7e e2                	jle    1011a1 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1011bf:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011c6:	83 e8 50             	sub    $0x50,%eax
  1011c9:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011cf:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011d6:	0f b7 c0             	movzwl %ax,%eax
  1011d9:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011dd:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  1011e1:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1011e5:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011e9:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011ea:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011f1:	66 c1 e8 08          	shr    $0x8,%ax
  1011f5:	0f b6 c0             	movzbl %al,%eax
  1011f8:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  1011ff:	83 c2 01             	add    $0x1,%edx
  101202:	0f b7 d2             	movzwl %dx,%edx
  101205:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101209:	88 45 ed             	mov    %al,-0x13(%ebp)
  10120c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101210:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101214:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101215:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  10121c:	0f b7 c0             	movzwl %ax,%eax
  10121f:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101223:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101227:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10122b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10122f:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101230:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101237:	0f b6 c0             	movzbl %al,%eax
  10123a:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101241:	83 c2 01             	add    $0x1,%edx
  101244:	0f b7 d2             	movzwl %dx,%edx
  101247:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  10124b:	88 45 e5             	mov    %al,-0x1b(%ebp)
  10124e:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101252:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101256:	ee                   	out    %al,(%dx)
}
  101257:	83 c4 34             	add    $0x34,%esp
  10125a:	5b                   	pop    %ebx
  10125b:	5d                   	pop    %ebp
  10125c:	c3                   	ret    

0010125d <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  10125d:	55                   	push   %ebp
  10125e:	89 e5                	mov    %esp,%ebp
  101260:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101263:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10126a:	eb 09                	jmp    101275 <serial_putc_sub+0x18>
        delay();
  10126c:	e8 4f fb ff ff       	call   100dc0 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101271:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101275:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10127b:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10127f:	89 c2                	mov    %eax,%edx
  101281:	ec                   	in     (%dx),%al
  101282:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101285:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101289:	0f b6 c0             	movzbl %al,%eax
  10128c:	83 e0 20             	and    $0x20,%eax
  10128f:	85 c0                	test   %eax,%eax
  101291:	75 09                	jne    10129c <serial_putc_sub+0x3f>
  101293:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10129a:	7e d0                	jle    10126c <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  10129c:	8b 45 08             	mov    0x8(%ebp),%eax
  10129f:	0f b6 c0             	movzbl %al,%eax
  1012a2:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012a8:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012ab:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012af:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012b3:	ee                   	out    %al,(%dx)
}
  1012b4:	c9                   	leave  
  1012b5:	c3                   	ret    

001012b6 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012b6:	55                   	push   %ebp
  1012b7:	89 e5                	mov    %esp,%ebp
  1012b9:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012bc:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012c0:	74 0d                	je     1012cf <serial_putc+0x19>
        serial_putc_sub(c);
  1012c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1012c5:	89 04 24             	mov    %eax,(%esp)
  1012c8:	e8 90 ff ff ff       	call   10125d <serial_putc_sub>
  1012cd:	eb 24                	jmp    1012f3 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  1012cf:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012d6:	e8 82 ff ff ff       	call   10125d <serial_putc_sub>
        serial_putc_sub(' ');
  1012db:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1012e2:	e8 76 ff ff ff       	call   10125d <serial_putc_sub>
        serial_putc_sub('\b');
  1012e7:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012ee:	e8 6a ff ff ff       	call   10125d <serial_putc_sub>
    }
}
  1012f3:	c9                   	leave  
  1012f4:	c3                   	ret    

001012f5 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012f5:	55                   	push   %ebp
  1012f6:	89 e5                	mov    %esp,%ebp
  1012f8:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012fb:	eb 33                	jmp    101330 <cons_intr+0x3b>
        if (c != 0) {
  1012fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101301:	74 2d                	je     101330 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101303:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101308:	8d 50 01             	lea    0x1(%eax),%edx
  10130b:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  101311:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101314:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10131a:	a1 84 f0 10 00       	mov    0x10f084,%eax
  10131f:	3d 00 02 00 00       	cmp    $0x200,%eax
  101324:	75 0a                	jne    101330 <cons_intr+0x3b>
                cons.wpos = 0;
  101326:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  10132d:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101330:	8b 45 08             	mov    0x8(%ebp),%eax
  101333:	ff d0                	call   *%eax
  101335:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101338:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10133c:	75 bf                	jne    1012fd <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  10133e:	c9                   	leave  
  10133f:	c3                   	ret    

00101340 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101340:	55                   	push   %ebp
  101341:	89 e5                	mov    %esp,%ebp
  101343:	83 ec 10             	sub    $0x10,%esp
  101346:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10134c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101350:	89 c2                	mov    %eax,%edx
  101352:	ec                   	in     (%dx),%al
  101353:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101356:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10135a:	0f b6 c0             	movzbl %al,%eax
  10135d:	83 e0 01             	and    $0x1,%eax
  101360:	85 c0                	test   %eax,%eax
  101362:	75 07                	jne    10136b <serial_proc_data+0x2b>
        return -1;
  101364:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101369:	eb 2a                	jmp    101395 <serial_proc_data+0x55>
  10136b:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101371:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101375:	89 c2                	mov    %eax,%edx
  101377:	ec                   	in     (%dx),%al
  101378:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  10137b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10137f:	0f b6 c0             	movzbl %al,%eax
  101382:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101385:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101389:	75 07                	jne    101392 <serial_proc_data+0x52>
        c = '\b';
  10138b:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101392:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101395:	c9                   	leave  
  101396:	c3                   	ret    

00101397 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101397:	55                   	push   %ebp
  101398:	89 e5                	mov    %esp,%ebp
  10139a:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  10139d:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1013a2:	85 c0                	test   %eax,%eax
  1013a4:	74 0c                	je     1013b2 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  1013a6:	c7 04 24 40 13 10 00 	movl   $0x101340,(%esp)
  1013ad:	e8 43 ff ff ff       	call   1012f5 <cons_intr>
    }
}
  1013b2:	c9                   	leave  
  1013b3:	c3                   	ret    

001013b4 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013b4:	55                   	push   %ebp
  1013b5:	89 e5                	mov    %esp,%ebp
  1013b7:	83 ec 38             	sub    $0x38,%esp
  1013ba:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013c0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013c4:	89 c2                	mov    %eax,%edx
  1013c6:	ec                   	in     (%dx),%al
  1013c7:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013ca:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013ce:	0f b6 c0             	movzbl %al,%eax
  1013d1:	83 e0 01             	and    $0x1,%eax
  1013d4:	85 c0                	test   %eax,%eax
  1013d6:	75 0a                	jne    1013e2 <kbd_proc_data+0x2e>
        return -1;
  1013d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013dd:	e9 59 01 00 00       	jmp    10153b <kbd_proc_data+0x187>
  1013e2:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013e8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013ec:	89 c2                	mov    %eax,%edx
  1013ee:	ec                   	in     (%dx),%al
  1013ef:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013f2:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013f6:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013f9:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013fd:	75 17                	jne    101416 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  1013ff:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101404:	83 c8 40             	or     $0x40,%eax
  101407:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  10140c:	b8 00 00 00 00       	mov    $0x0,%eax
  101411:	e9 25 01 00 00       	jmp    10153b <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101416:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10141a:	84 c0                	test   %al,%al
  10141c:	79 47                	jns    101465 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10141e:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101423:	83 e0 40             	and    $0x40,%eax
  101426:	85 c0                	test   %eax,%eax
  101428:	75 09                	jne    101433 <kbd_proc_data+0x7f>
  10142a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10142e:	83 e0 7f             	and    $0x7f,%eax
  101431:	eb 04                	jmp    101437 <kbd_proc_data+0x83>
  101433:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101437:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10143a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10143e:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101445:	83 c8 40             	or     $0x40,%eax
  101448:	0f b6 c0             	movzbl %al,%eax
  10144b:	f7 d0                	not    %eax
  10144d:	89 c2                	mov    %eax,%edx
  10144f:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101454:	21 d0                	and    %edx,%eax
  101456:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  10145b:	b8 00 00 00 00       	mov    $0x0,%eax
  101460:	e9 d6 00 00 00       	jmp    10153b <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  101465:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10146a:	83 e0 40             	and    $0x40,%eax
  10146d:	85 c0                	test   %eax,%eax
  10146f:	74 11                	je     101482 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101471:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101475:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10147a:	83 e0 bf             	and    $0xffffffbf,%eax
  10147d:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  101482:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101486:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10148d:	0f b6 d0             	movzbl %al,%edx
  101490:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101495:	09 d0                	or     %edx,%eax
  101497:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  10149c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a0:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  1014a7:	0f b6 d0             	movzbl %al,%edx
  1014aa:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014af:	31 d0                	xor    %edx,%eax
  1014b1:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014b6:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014bb:	83 e0 03             	and    $0x3,%eax
  1014be:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014c5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014c9:	01 d0                	add    %edx,%eax
  1014cb:	0f b6 00             	movzbl (%eax),%eax
  1014ce:	0f b6 c0             	movzbl %al,%eax
  1014d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014d4:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014d9:	83 e0 08             	and    $0x8,%eax
  1014dc:	85 c0                	test   %eax,%eax
  1014de:	74 22                	je     101502 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014e0:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014e4:	7e 0c                	jle    1014f2 <kbd_proc_data+0x13e>
  1014e6:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014ea:	7f 06                	jg     1014f2 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014ec:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014f0:	eb 10                	jmp    101502 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014f2:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014f6:	7e 0a                	jle    101502 <kbd_proc_data+0x14e>
  1014f8:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014fc:	7f 04                	jg     101502 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1014fe:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101502:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101507:	f7 d0                	not    %eax
  101509:	83 e0 06             	and    $0x6,%eax
  10150c:	85 c0                	test   %eax,%eax
  10150e:	75 28                	jne    101538 <kbd_proc_data+0x184>
  101510:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101517:	75 1f                	jne    101538 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101519:	c7 04 24 5d 37 10 00 	movl   $0x10375d,(%esp)
  101520:	e8 ed ed ff ff       	call   100312 <cprintf>
  101525:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10152b:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10152f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101533:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101537:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101538:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10153b:	c9                   	leave  
  10153c:	c3                   	ret    

0010153d <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10153d:	55                   	push   %ebp
  10153e:	89 e5                	mov    %esp,%ebp
  101540:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101543:	c7 04 24 b4 13 10 00 	movl   $0x1013b4,(%esp)
  10154a:	e8 a6 fd ff ff       	call   1012f5 <cons_intr>
}
  10154f:	c9                   	leave  
  101550:	c3                   	ret    

00101551 <kbd_init>:

static void
kbd_init(void) {
  101551:	55                   	push   %ebp
  101552:	89 e5                	mov    %esp,%ebp
  101554:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101557:	e8 e1 ff ff ff       	call   10153d <kbd_intr>
    pic_enable(IRQ_KBD);
  10155c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101563:	e8 17 01 00 00       	call   10167f <pic_enable>
}
  101568:	c9                   	leave  
  101569:	c3                   	ret    

0010156a <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10156a:	55                   	push   %ebp
  10156b:	89 e5                	mov    %esp,%ebp
  10156d:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101570:	e8 93 f8 ff ff       	call   100e08 <cga_init>
    serial_init();
  101575:	e8 74 f9 ff ff       	call   100eee <serial_init>
    kbd_init();
  10157a:	e8 d2 ff ff ff       	call   101551 <kbd_init>
    if (!serial_exists) {
  10157f:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101584:	85 c0                	test   %eax,%eax
  101586:	75 0c                	jne    101594 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101588:	c7 04 24 69 37 10 00 	movl   $0x103769,(%esp)
  10158f:	e8 7e ed ff ff       	call   100312 <cprintf>
    }
}
  101594:	c9                   	leave  
  101595:	c3                   	ret    

00101596 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101596:	55                   	push   %ebp
  101597:	89 e5                	mov    %esp,%ebp
  101599:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  10159c:	8b 45 08             	mov    0x8(%ebp),%eax
  10159f:	89 04 24             	mov    %eax,(%esp)
  1015a2:	e8 a3 fa ff ff       	call   10104a <lpt_putc>
    cga_putc(c);
  1015a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1015aa:	89 04 24             	mov    %eax,(%esp)
  1015ad:	e8 d7 fa ff ff       	call   101089 <cga_putc>
    serial_putc(c);
  1015b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1015b5:	89 04 24             	mov    %eax,(%esp)
  1015b8:	e8 f9 fc ff ff       	call   1012b6 <serial_putc>
}
  1015bd:	c9                   	leave  
  1015be:	c3                   	ret    

001015bf <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015bf:	55                   	push   %ebp
  1015c0:	89 e5                	mov    %esp,%ebp
  1015c2:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015c5:	e8 cd fd ff ff       	call   101397 <serial_intr>
    kbd_intr();
  1015ca:	e8 6e ff ff ff       	call   10153d <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015cf:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015d5:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015da:	39 c2                	cmp    %eax,%edx
  1015dc:	74 36                	je     101614 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015de:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015e3:	8d 50 01             	lea    0x1(%eax),%edx
  1015e6:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015ec:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  1015f3:	0f b6 c0             	movzbl %al,%eax
  1015f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1015f9:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015fe:	3d 00 02 00 00       	cmp    $0x200,%eax
  101603:	75 0a                	jne    10160f <cons_getc+0x50>
            cons.rpos = 0;
  101605:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  10160c:	00 00 00 
        }
        return c;
  10160f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101612:	eb 05                	jmp    101619 <cons_getc+0x5a>
    }
    return 0;
  101614:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101619:	c9                   	leave  
  10161a:	c3                   	ret    

0010161b <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  10161b:	55                   	push   %ebp
  10161c:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  10161e:	fb                   	sti    
    sti();
}
  10161f:	5d                   	pop    %ebp
  101620:	c3                   	ret    

00101621 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101621:	55                   	push   %ebp
  101622:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  101624:	fa                   	cli    
    cli();
}
  101625:	5d                   	pop    %ebp
  101626:	c3                   	ret    

00101627 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101627:	55                   	push   %ebp
  101628:	89 e5                	mov    %esp,%ebp
  10162a:	83 ec 14             	sub    $0x14,%esp
  10162d:	8b 45 08             	mov    0x8(%ebp),%eax
  101630:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101634:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101638:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  10163e:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101643:	85 c0                	test   %eax,%eax
  101645:	74 36                	je     10167d <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101647:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10164b:	0f b6 c0             	movzbl %al,%eax
  10164e:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101654:	88 45 fd             	mov    %al,-0x3(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101657:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10165b:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10165f:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101660:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101664:	66 c1 e8 08          	shr    $0x8,%ax
  101668:	0f b6 c0             	movzbl %al,%eax
  10166b:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101671:	88 45 f9             	mov    %al,-0x7(%ebp)
  101674:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101678:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10167c:	ee                   	out    %al,(%dx)
    }
}
  10167d:	c9                   	leave  
  10167e:	c3                   	ret    

0010167f <pic_enable>:

void
pic_enable(unsigned int irq) {
  10167f:	55                   	push   %ebp
  101680:	89 e5                	mov    %esp,%ebp
  101682:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101685:	8b 45 08             	mov    0x8(%ebp),%eax
  101688:	ba 01 00 00 00       	mov    $0x1,%edx
  10168d:	89 c1                	mov    %eax,%ecx
  10168f:	d3 e2                	shl    %cl,%edx
  101691:	89 d0                	mov    %edx,%eax
  101693:	f7 d0                	not    %eax
  101695:	89 c2                	mov    %eax,%edx
  101697:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  10169e:	21 d0                	and    %edx,%eax
  1016a0:	0f b7 c0             	movzwl %ax,%eax
  1016a3:	89 04 24             	mov    %eax,(%esp)
  1016a6:	e8 7c ff ff ff       	call   101627 <pic_setmask>
}
  1016ab:	c9                   	leave  
  1016ac:	c3                   	ret    

001016ad <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016ad:	55                   	push   %ebp
  1016ae:	89 e5                	mov    %esp,%ebp
  1016b0:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1016b3:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016ba:	00 00 00 
  1016bd:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016c3:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  1016c7:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016cb:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016cf:	ee                   	out    %al,(%dx)
  1016d0:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016d6:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1016da:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016de:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016e2:	ee                   	out    %al,(%dx)
  1016e3:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1016e9:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  1016ed:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1016f1:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1016f5:	ee                   	out    %al,(%dx)
  1016f6:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  1016fc:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  101700:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101704:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101708:	ee                   	out    %al,(%dx)
  101709:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  10170f:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  101713:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101717:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10171b:	ee                   	out    %al,(%dx)
  10171c:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  101722:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  101726:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10172a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10172e:	ee                   	out    %al,(%dx)
  10172f:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101735:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  101739:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10173d:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101741:	ee                   	out    %al,(%dx)
  101742:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  101748:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  10174c:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101750:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101754:	ee                   	out    %al,(%dx)
  101755:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  10175b:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  10175f:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101763:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101767:	ee                   	out    %al,(%dx)
  101768:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  10176e:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101772:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101776:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10177a:	ee                   	out    %al,(%dx)
  10177b:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101781:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101785:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101789:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10178d:	ee                   	out    %al,(%dx)
  10178e:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101794:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101798:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  10179c:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1017a0:	ee                   	out    %al,(%dx)
  1017a1:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  1017a7:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  1017ab:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017af:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017b3:	ee                   	out    %al,(%dx)
  1017b4:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  1017ba:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  1017be:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017c2:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017c6:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017c7:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017ce:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017d2:	74 12                	je     1017e6 <pic_init+0x139>
        pic_setmask(irq_mask);
  1017d4:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017db:	0f b7 c0             	movzwl %ax,%eax
  1017de:	89 04 24             	mov    %eax,(%esp)
  1017e1:	e8 41 fe ff ff       	call   101627 <pic_setmask>
    }
}
  1017e6:	c9                   	leave  
  1017e7:	c3                   	ret    

001017e8 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017e8:	55                   	push   %ebp
  1017e9:	89 e5                	mov    %esp,%ebp
  1017eb:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017ee:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1017f5:	00 
  1017f6:	c7 04 24 a0 37 10 00 	movl   $0x1037a0,(%esp)
  1017fd:	e8 10 eb ff ff       	call   100312 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101802:	c7 04 24 aa 37 10 00 	movl   $0x1037aa,(%esp)
  101809:	e8 04 eb ff ff       	call   100312 <cprintf>
    panic("EOT: kernel seems ok.");
  10180e:	c7 44 24 08 b8 37 10 	movl   $0x1037b8,0x8(%esp)
  101815:	00 
  101816:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  10181d:	00 
  10181e:	c7 04 24 ce 37 10 00 	movl   $0x1037ce,(%esp)
  101825:	e8 77 f4 ff ff       	call   100ca1 <__panic>

0010182a <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  10182a:	55                   	push   %ebp
  10182b:	89 e5                	mov    %esp,%ebp
  10182d:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int cnt_idt = sizeof(idt) / sizeof(struct gatedesc);
  101830:	c7 45 f8 00 01 00 00 	movl   $0x100,-0x8(%ebp)
	int i;
	for (i = 0; i < cnt_idt; i++)
  101837:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10183e:	e9 c3 00 00 00       	jmp    101906 <idt_init+0xdc>
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101843:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101846:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  10184d:	89 c2                	mov    %eax,%edx
  10184f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101852:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  101859:	00 
  10185a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10185d:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  101864:	00 08 00 
  101867:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10186a:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101871:	00 
  101872:	83 e2 e0             	and    $0xffffffe0,%edx
  101875:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  10187c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10187f:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101886:	00 
  101887:	83 e2 1f             	and    $0x1f,%edx
  10188a:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101891:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101894:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10189b:	00 
  10189c:	83 e2 f0             	and    $0xfffffff0,%edx
  10189f:	83 ca 0e             	or     $0xe,%edx
  1018a2:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ac:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018b3:	00 
  1018b4:	83 e2 ef             	and    $0xffffffef,%edx
  1018b7:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c1:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018c8:	00 
  1018c9:	83 e2 9f             	and    $0xffffff9f,%edx
  1018cc:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d6:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018dd:	00 
  1018de:	83 ca 80             	or     $0xffffff80,%edx
  1018e1:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018eb:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018f2:	c1 e8 10             	shr    $0x10,%eax
  1018f5:	89 c2                	mov    %eax,%edx
  1018f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018fa:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  101901:	00 
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int cnt_idt = sizeof(idt) / sizeof(struct gatedesc);
	int i;
	for (i = 0; i < cnt_idt; i++)
  101902:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101906:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101909:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  10190c:	0f 8c 31 ff ff ff    	jl     101843 <idt_init+0x19>
  101912:	c7 45 f4 60 e5 10 00 	movl   $0x10e560,-0xc(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  101919:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10191c:	0f 01 18             	lidtl  (%eax)
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
	lidt(&idt_pd);
}
  10191f:	c9                   	leave  
  101920:	c3                   	ret    

00101921 <trapname>:

static const char *
trapname(int trapno) {
  101921:	55                   	push   %ebp
  101922:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101924:	8b 45 08             	mov    0x8(%ebp),%eax
  101927:	83 f8 13             	cmp    $0x13,%eax
  10192a:	77 0c                	ja     101938 <trapname+0x17>
        return excnames[trapno];
  10192c:	8b 45 08             	mov    0x8(%ebp),%eax
  10192f:	8b 04 85 20 3b 10 00 	mov    0x103b20(,%eax,4),%eax
  101936:	eb 18                	jmp    101950 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101938:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  10193c:	7e 0d                	jle    10194b <trapname+0x2a>
  10193e:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101942:	7f 07                	jg     10194b <trapname+0x2a>
        return "Hardware Interrupt";
  101944:	b8 df 37 10 00       	mov    $0x1037df,%eax
  101949:	eb 05                	jmp    101950 <trapname+0x2f>
    }
    return "(unknown trap)";
  10194b:	b8 f2 37 10 00       	mov    $0x1037f2,%eax
}
  101950:	5d                   	pop    %ebp
  101951:	c3                   	ret    

00101952 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101952:	55                   	push   %ebp
  101953:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101955:	8b 45 08             	mov    0x8(%ebp),%eax
  101958:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  10195c:	66 83 f8 08          	cmp    $0x8,%ax
  101960:	0f 94 c0             	sete   %al
  101963:	0f b6 c0             	movzbl %al,%eax
}
  101966:	5d                   	pop    %ebp
  101967:	c3                   	ret    

00101968 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101968:	55                   	push   %ebp
  101969:	89 e5                	mov    %esp,%ebp
  10196b:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  10196e:	8b 45 08             	mov    0x8(%ebp),%eax
  101971:	89 44 24 04          	mov    %eax,0x4(%esp)
  101975:	c7 04 24 33 38 10 00 	movl   $0x103833,(%esp)
  10197c:	e8 91 e9 ff ff       	call   100312 <cprintf>
    print_regs(&tf->tf_regs);
  101981:	8b 45 08             	mov    0x8(%ebp),%eax
  101984:	89 04 24             	mov    %eax,(%esp)
  101987:	e8 a1 01 00 00       	call   101b2d <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  10198c:	8b 45 08             	mov    0x8(%ebp),%eax
  10198f:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101993:	0f b7 c0             	movzwl %ax,%eax
  101996:	89 44 24 04          	mov    %eax,0x4(%esp)
  10199a:	c7 04 24 44 38 10 00 	movl   $0x103844,(%esp)
  1019a1:	e8 6c e9 ff ff       	call   100312 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  1019a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1019a9:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  1019ad:	0f b7 c0             	movzwl %ax,%eax
  1019b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019b4:	c7 04 24 57 38 10 00 	movl   $0x103857,(%esp)
  1019bb:	e8 52 e9 ff ff       	call   100312 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  1019c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1019c3:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  1019c7:	0f b7 c0             	movzwl %ax,%eax
  1019ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019ce:	c7 04 24 6a 38 10 00 	movl   $0x10386a,(%esp)
  1019d5:	e8 38 e9 ff ff       	call   100312 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  1019da:	8b 45 08             	mov    0x8(%ebp),%eax
  1019dd:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  1019e1:	0f b7 c0             	movzwl %ax,%eax
  1019e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019e8:	c7 04 24 7d 38 10 00 	movl   $0x10387d,(%esp)
  1019ef:	e8 1e e9 ff ff       	call   100312 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  1019f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1019f7:	8b 40 30             	mov    0x30(%eax),%eax
  1019fa:	89 04 24             	mov    %eax,(%esp)
  1019fd:	e8 1f ff ff ff       	call   101921 <trapname>
  101a02:	8b 55 08             	mov    0x8(%ebp),%edx
  101a05:	8b 52 30             	mov    0x30(%edx),%edx
  101a08:	89 44 24 08          	mov    %eax,0x8(%esp)
  101a0c:	89 54 24 04          	mov    %edx,0x4(%esp)
  101a10:	c7 04 24 90 38 10 00 	movl   $0x103890,(%esp)
  101a17:	e8 f6 e8 ff ff       	call   100312 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a1f:	8b 40 34             	mov    0x34(%eax),%eax
  101a22:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a26:	c7 04 24 a2 38 10 00 	movl   $0x1038a2,(%esp)
  101a2d:	e8 e0 e8 ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101a32:	8b 45 08             	mov    0x8(%ebp),%eax
  101a35:	8b 40 38             	mov    0x38(%eax),%eax
  101a38:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a3c:	c7 04 24 b1 38 10 00 	movl   $0x1038b1,(%esp)
  101a43:	e8 ca e8 ff ff       	call   100312 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101a48:	8b 45 08             	mov    0x8(%ebp),%eax
  101a4b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a4f:	0f b7 c0             	movzwl %ax,%eax
  101a52:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a56:	c7 04 24 c0 38 10 00 	movl   $0x1038c0,(%esp)
  101a5d:	e8 b0 e8 ff ff       	call   100312 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101a62:	8b 45 08             	mov    0x8(%ebp),%eax
  101a65:	8b 40 40             	mov    0x40(%eax),%eax
  101a68:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a6c:	c7 04 24 d3 38 10 00 	movl   $0x1038d3,(%esp)
  101a73:	e8 9a e8 ff ff       	call   100312 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101a78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101a7f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101a86:	eb 3e                	jmp    101ac6 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101a88:	8b 45 08             	mov    0x8(%ebp),%eax
  101a8b:	8b 50 40             	mov    0x40(%eax),%edx
  101a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101a91:	21 d0                	and    %edx,%eax
  101a93:	85 c0                	test   %eax,%eax
  101a95:	74 28                	je     101abf <print_trapframe+0x157>
  101a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101a9a:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101aa1:	85 c0                	test   %eax,%eax
  101aa3:	74 1a                	je     101abf <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101aa8:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101aaf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ab3:	c7 04 24 e2 38 10 00 	movl   $0x1038e2,(%esp)
  101aba:	e8 53 e8 ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101abf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101ac3:	d1 65 f0             	shll   -0x10(%ebp)
  101ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ac9:	83 f8 17             	cmp    $0x17,%eax
  101acc:	76 ba                	jbe    101a88 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101ace:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad1:	8b 40 40             	mov    0x40(%eax),%eax
  101ad4:	25 00 30 00 00       	and    $0x3000,%eax
  101ad9:	c1 e8 0c             	shr    $0xc,%eax
  101adc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ae0:	c7 04 24 e6 38 10 00 	movl   $0x1038e6,(%esp)
  101ae7:	e8 26 e8 ff ff       	call   100312 <cprintf>

    if (!trap_in_kernel(tf)) {
  101aec:	8b 45 08             	mov    0x8(%ebp),%eax
  101aef:	89 04 24             	mov    %eax,(%esp)
  101af2:	e8 5b fe ff ff       	call   101952 <trap_in_kernel>
  101af7:	85 c0                	test   %eax,%eax
  101af9:	75 30                	jne    101b2b <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101afb:	8b 45 08             	mov    0x8(%ebp),%eax
  101afe:	8b 40 44             	mov    0x44(%eax),%eax
  101b01:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b05:	c7 04 24 ef 38 10 00 	movl   $0x1038ef,(%esp)
  101b0c:	e8 01 e8 ff ff       	call   100312 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b11:	8b 45 08             	mov    0x8(%ebp),%eax
  101b14:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101b18:	0f b7 c0             	movzwl %ax,%eax
  101b1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b1f:	c7 04 24 fe 38 10 00 	movl   $0x1038fe,(%esp)
  101b26:	e8 e7 e7 ff ff       	call   100312 <cprintf>
    }
}
  101b2b:	c9                   	leave  
  101b2c:	c3                   	ret    

00101b2d <print_regs>:

void
print_regs(struct pushregs *regs) {
  101b2d:	55                   	push   %ebp
  101b2e:	89 e5                	mov    %esp,%ebp
  101b30:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101b33:	8b 45 08             	mov    0x8(%ebp),%eax
  101b36:	8b 00                	mov    (%eax),%eax
  101b38:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b3c:	c7 04 24 11 39 10 00 	movl   $0x103911,(%esp)
  101b43:	e8 ca e7 ff ff       	call   100312 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101b48:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4b:	8b 40 04             	mov    0x4(%eax),%eax
  101b4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b52:	c7 04 24 20 39 10 00 	movl   $0x103920,(%esp)
  101b59:	e8 b4 e7 ff ff       	call   100312 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b61:	8b 40 08             	mov    0x8(%eax),%eax
  101b64:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b68:	c7 04 24 2f 39 10 00 	movl   $0x10392f,(%esp)
  101b6f:	e8 9e e7 ff ff       	call   100312 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101b74:	8b 45 08             	mov    0x8(%ebp),%eax
  101b77:	8b 40 0c             	mov    0xc(%eax),%eax
  101b7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b7e:	c7 04 24 3e 39 10 00 	movl   $0x10393e,(%esp)
  101b85:	e8 88 e7 ff ff       	call   100312 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b8d:	8b 40 10             	mov    0x10(%eax),%eax
  101b90:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b94:	c7 04 24 4d 39 10 00 	movl   $0x10394d,(%esp)
  101b9b:	e8 72 e7 ff ff       	call   100312 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba3:	8b 40 14             	mov    0x14(%eax),%eax
  101ba6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101baa:	c7 04 24 5c 39 10 00 	movl   $0x10395c,(%esp)
  101bb1:	e8 5c e7 ff ff       	call   100312 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb9:	8b 40 18             	mov    0x18(%eax),%eax
  101bbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc0:	c7 04 24 6b 39 10 00 	movl   $0x10396b,(%esp)
  101bc7:	e8 46 e7 ff ff       	call   100312 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  101bcf:	8b 40 1c             	mov    0x1c(%eax),%eax
  101bd2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bd6:	c7 04 24 7a 39 10 00 	movl   $0x10397a,(%esp)
  101bdd:	e8 30 e7 ff ff       	call   100312 <cprintf>
}
  101be2:	c9                   	leave  
  101be3:	c3                   	ret    

00101be4 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101be4:	55                   	push   %ebp
  101be5:	89 e5                	mov    %esp,%ebp
  101be7:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101bea:	8b 45 08             	mov    0x8(%ebp),%eax
  101bed:	8b 40 30             	mov    0x30(%eax),%eax
  101bf0:	83 f8 2f             	cmp    $0x2f,%eax
  101bf3:	77 21                	ja     101c16 <trap_dispatch+0x32>
  101bf5:	83 f8 2e             	cmp    $0x2e,%eax
  101bf8:	0f 83 0e 01 00 00    	jae    101d0c <trap_dispatch+0x128>
  101bfe:	83 f8 21             	cmp    $0x21,%eax
  101c01:	0f 84 8b 00 00 00    	je     101c92 <trap_dispatch+0xae>
  101c07:	83 f8 24             	cmp    $0x24,%eax
  101c0a:	74 60                	je     101c6c <trap_dispatch+0x88>
  101c0c:	83 f8 20             	cmp    $0x20,%eax
  101c0f:	74 16                	je     101c27 <trap_dispatch+0x43>
  101c11:	e9 be 00 00 00       	jmp    101cd4 <trap_dispatch+0xf0>
  101c16:	83 e8 78             	sub    $0x78,%eax
  101c19:	83 f8 01             	cmp    $0x1,%eax
  101c1c:	0f 87 b2 00 00 00    	ja     101cd4 <trap_dispatch+0xf0>
  101c22:	e9 91 00 00 00       	jmp    101cb8 <trap_dispatch+0xd4>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
    	ticks ++;
  101c27:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101c2c:	83 c0 01             	add    $0x1,%eax
  101c2f:	a3 08 f9 10 00       	mov    %eax,0x10f908
        if (ticks % TICK_NUM == 0)
  101c34:	8b 0d 08 f9 10 00    	mov    0x10f908,%ecx
  101c3a:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101c3f:	89 c8                	mov    %ecx,%eax
  101c41:	f7 e2                	mul    %edx
  101c43:	89 d0                	mov    %edx,%eax
  101c45:	c1 e8 05             	shr    $0x5,%eax
  101c48:	6b c0 64             	imul   $0x64,%eax,%eax
  101c4b:	29 c1                	sub    %eax,%ecx
  101c4d:	89 c8                	mov    %ecx,%eax
  101c4f:	85 c0                	test   %eax,%eax
  101c51:	75 14                	jne    101c67 <trap_dispatch+0x83>
        {
        	print_ticks();
  101c53:	e8 90 fb ff ff       	call   1017e8 <print_ticks>
        	ticks = 0;
  101c58:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  101c5f:	00 00 00 
        }
        break;
  101c62:	e9 a6 00 00 00       	jmp    101d0d <trap_dispatch+0x129>
  101c67:	e9 a1 00 00 00       	jmp    101d0d <trap_dispatch+0x129>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101c6c:	e8 4e f9 ff ff       	call   1015bf <cons_getc>
  101c71:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101c74:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101c78:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101c7c:	89 54 24 08          	mov    %edx,0x8(%esp)
  101c80:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c84:	c7 04 24 89 39 10 00 	movl   $0x103989,(%esp)
  101c8b:	e8 82 e6 ff ff       	call   100312 <cprintf>
        break;
  101c90:	eb 7b                	jmp    101d0d <trap_dispatch+0x129>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101c92:	e8 28 f9 ff ff       	call   1015bf <cons_getc>
  101c97:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101c9a:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101c9e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101ca2:	89 54 24 08          	mov    %edx,0x8(%esp)
  101ca6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101caa:	c7 04 24 9b 39 10 00 	movl   $0x10399b,(%esp)
  101cb1:	e8 5c e6 ff ff       	call   100312 <cprintf>
        break;
  101cb6:	eb 55                	jmp    101d0d <trap_dispatch+0x129>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101cb8:	c7 44 24 08 aa 39 10 	movl   $0x1039aa,0x8(%esp)
  101cbf:	00 
  101cc0:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
  101cc7:	00 
  101cc8:	c7 04 24 ce 37 10 00 	movl   $0x1037ce,(%esp)
  101ccf:	e8 cd ef ff ff       	call   100ca1 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101cdb:	0f b7 c0             	movzwl %ax,%eax
  101cde:	83 e0 03             	and    $0x3,%eax
  101ce1:	85 c0                	test   %eax,%eax
  101ce3:	75 28                	jne    101d0d <trap_dispatch+0x129>
            print_trapframe(tf);
  101ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce8:	89 04 24             	mov    %eax,(%esp)
  101ceb:	e8 78 fc ff ff       	call   101968 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101cf0:	c7 44 24 08 ba 39 10 	movl   $0x1039ba,0x8(%esp)
  101cf7:	00 
  101cf8:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
  101cff:	00 
  101d00:	c7 04 24 ce 37 10 00 	movl   $0x1037ce,(%esp)
  101d07:	e8 95 ef ff ff       	call   100ca1 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101d0c:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101d0d:	c9                   	leave  
  101d0e:	c3                   	ret    

00101d0f <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101d0f:	55                   	push   %ebp
  101d10:	89 e5                	mov    %esp,%ebp
  101d12:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101d15:	8b 45 08             	mov    0x8(%ebp),%eax
  101d18:	89 04 24             	mov    %eax,(%esp)
  101d1b:	e8 c4 fe ff ff       	call   101be4 <trap_dispatch>
}
  101d20:	c9                   	leave  
  101d21:	c3                   	ret    

00101d22 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101d22:	1e                   	push   %ds
    pushl %es
  101d23:	06                   	push   %es
    pushl %fs
  101d24:	0f a0                	push   %fs
    pushl %gs
  101d26:	0f a8                	push   %gs
    pushal
  101d28:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101d29:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101d2e:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101d30:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101d32:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101d33:	e8 d7 ff ff ff       	call   101d0f <trap>

    # pop the pushed stack pointer
    popl %esp
  101d38:	5c                   	pop    %esp

00101d39 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101d39:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101d3a:	0f a9                	pop    %gs
    popl %fs
  101d3c:	0f a1                	pop    %fs
    popl %es
  101d3e:	07                   	pop    %es
    popl %ds
  101d3f:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101d40:	83 c4 08             	add    $0x8,%esp
    iret
  101d43:	cf                   	iret   

00101d44 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101d44:	6a 00                	push   $0x0
  pushl $0
  101d46:	6a 00                	push   $0x0
  jmp __alltraps
  101d48:	e9 d5 ff ff ff       	jmp    101d22 <__alltraps>

00101d4d <vector1>:
.globl vector1
vector1:
  pushl $0
  101d4d:	6a 00                	push   $0x0
  pushl $1
  101d4f:	6a 01                	push   $0x1
  jmp __alltraps
  101d51:	e9 cc ff ff ff       	jmp    101d22 <__alltraps>

00101d56 <vector2>:
.globl vector2
vector2:
  pushl $0
  101d56:	6a 00                	push   $0x0
  pushl $2
  101d58:	6a 02                	push   $0x2
  jmp __alltraps
  101d5a:	e9 c3 ff ff ff       	jmp    101d22 <__alltraps>

00101d5f <vector3>:
.globl vector3
vector3:
  pushl $0
  101d5f:	6a 00                	push   $0x0
  pushl $3
  101d61:	6a 03                	push   $0x3
  jmp __alltraps
  101d63:	e9 ba ff ff ff       	jmp    101d22 <__alltraps>

00101d68 <vector4>:
.globl vector4
vector4:
  pushl $0
  101d68:	6a 00                	push   $0x0
  pushl $4
  101d6a:	6a 04                	push   $0x4
  jmp __alltraps
  101d6c:	e9 b1 ff ff ff       	jmp    101d22 <__alltraps>

00101d71 <vector5>:
.globl vector5
vector5:
  pushl $0
  101d71:	6a 00                	push   $0x0
  pushl $5
  101d73:	6a 05                	push   $0x5
  jmp __alltraps
  101d75:	e9 a8 ff ff ff       	jmp    101d22 <__alltraps>

00101d7a <vector6>:
.globl vector6
vector6:
  pushl $0
  101d7a:	6a 00                	push   $0x0
  pushl $6
  101d7c:	6a 06                	push   $0x6
  jmp __alltraps
  101d7e:	e9 9f ff ff ff       	jmp    101d22 <__alltraps>

00101d83 <vector7>:
.globl vector7
vector7:
  pushl $0
  101d83:	6a 00                	push   $0x0
  pushl $7
  101d85:	6a 07                	push   $0x7
  jmp __alltraps
  101d87:	e9 96 ff ff ff       	jmp    101d22 <__alltraps>

00101d8c <vector8>:
.globl vector8
vector8:
  pushl $8
  101d8c:	6a 08                	push   $0x8
  jmp __alltraps
  101d8e:	e9 8f ff ff ff       	jmp    101d22 <__alltraps>

00101d93 <vector9>:
.globl vector9
vector9:
  pushl $9
  101d93:	6a 09                	push   $0x9
  jmp __alltraps
  101d95:	e9 88 ff ff ff       	jmp    101d22 <__alltraps>

00101d9a <vector10>:
.globl vector10
vector10:
  pushl $10
  101d9a:	6a 0a                	push   $0xa
  jmp __alltraps
  101d9c:	e9 81 ff ff ff       	jmp    101d22 <__alltraps>

00101da1 <vector11>:
.globl vector11
vector11:
  pushl $11
  101da1:	6a 0b                	push   $0xb
  jmp __alltraps
  101da3:	e9 7a ff ff ff       	jmp    101d22 <__alltraps>

00101da8 <vector12>:
.globl vector12
vector12:
  pushl $12
  101da8:	6a 0c                	push   $0xc
  jmp __alltraps
  101daa:	e9 73 ff ff ff       	jmp    101d22 <__alltraps>

00101daf <vector13>:
.globl vector13
vector13:
  pushl $13
  101daf:	6a 0d                	push   $0xd
  jmp __alltraps
  101db1:	e9 6c ff ff ff       	jmp    101d22 <__alltraps>

00101db6 <vector14>:
.globl vector14
vector14:
  pushl $14
  101db6:	6a 0e                	push   $0xe
  jmp __alltraps
  101db8:	e9 65 ff ff ff       	jmp    101d22 <__alltraps>

00101dbd <vector15>:
.globl vector15
vector15:
  pushl $0
  101dbd:	6a 00                	push   $0x0
  pushl $15
  101dbf:	6a 0f                	push   $0xf
  jmp __alltraps
  101dc1:	e9 5c ff ff ff       	jmp    101d22 <__alltraps>

00101dc6 <vector16>:
.globl vector16
vector16:
  pushl $0
  101dc6:	6a 00                	push   $0x0
  pushl $16
  101dc8:	6a 10                	push   $0x10
  jmp __alltraps
  101dca:	e9 53 ff ff ff       	jmp    101d22 <__alltraps>

00101dcf <vector17>:
.globl vector17
vector17:
  pushl $17
  101dcf:	6a 11                	push   $0x11
  jmp __alltraps
  101dd1:	e9 4c ff ff ff       	jmp    101d22 <__alltraps>

00101dd6 <vector18>:
.globl vector18
vector18:
  pushl $0
  101dd6:	6a 00                	push   $0x0
  pushl $18
  101dd8:	6a 12                	push   $0x12
  jmp __alltraps
  101dda:	e9 43 ff ff ff       	jmp    101d22 <__alltraps>

00101ddf <vector19>:
.globl vector19
vector19:
  pushl $0
  101ddf:	6a 00                	push   $0x0
  pushl $19
  101de1:	6a 13                	push   $0x13
  jmp __alltraps
  101de3:	e9 3a ff ff ff       	jmp    101d22 <__alltraps>

00101de8 <vector20>:
.globl vector20
vector20:
  pushl $0
  101de8:	6a 00                	push   $0x0
  pushl $20
  101dea:	6a 14                	push   $0x14
  jmp __alltraps
  101dec:	e9 31 ff ff ff       	jmp    101d22 <__alltraps>

00101df1 <vector21>:
.globl vector21
vector21:
  pushl $0
  101df1:	6a 00                	push   $0x0
  pushl $21
  101df3:	6a 15                	push   $0x15
  jmp __alltraps
  101df5:	e9 28 ff ff ff       	jmp    101d22 <__alltraps>

00101dfa <vector22>:
.globl vector22
vector22:
  pushl $0
  101dfa:	6a 00                	push   $0x0
  pushl $22
  101dfc:	6a 16                	push   $0x16
  jmp __alltraps
  101dfe:	e9 1f ff ff ff       	jmp    101d22 <__alltraps>

00101e03 <vector23>:
.globl vector23
vector23:
  pushl $0
  101e03:	6a 00                	push   $0x0
  pushl $23
  101e05:	6a 17                	push   $0x17
  jmp __alltraps
  101e07:	e9 16 ff ff ff       	jmp    101d22 <__alltraps>

00101e0c <vector24>:
.globl vector24
vector24:
  pushl $0
  101e0c:	6a 00                	push   $0x0
  pushl $24
  101e0e:	6a 18                	push   $0x18
  jmp __alltraps
  101e10:	e9 0d ff ff ff       	jmp    101d22 <__alltraps>

00101e15 <vector25>:
.globl vector25
vector25:
  pushl $0
  101e15:	6a 00                	push   $0x0
  pushl $25
  101e17:	6a 19                	push   $0x19
  jmp __alltraps
  101e19:	e9 04 ff ff ff       	jmp    101d22 <__alltraps>

00101e1e <vector26>:
.globl vector26
vector26:
  pushl $0
  101e1e:	6a 00                	push   $0x0
  pushl $26
  101e20:	6a 1a                	push   $0x1a
  jmp __alltraps
  101e22:	e9 fb fe ff ff       	jmp    101d22 <__alltraps>

00101e27 <vector27>:
.globl vector27
vector27:
  pushl $0
  101e27:	6a 00                	push   $0x0
  pushl $27
  101e29:	6a 1b                	push   $0x1b
  jmp __alltraps
  101e2b:	e9 f2 fe ff ff       	jmp    101d22 <__alltraps>

00101e30 <vector28>:
.globl vector28
vector28:
  pushl $0
  101e30:	6a 00                	push   $0x0
  pushl $28
  101e32:	6a 1c                	push   $0x1c
  jmp __alltraps
  101e34:	e9 e9 fe ff ff       	jmp    101d22 <__alltraps>

00101e39 <vector29>:
.globl vector29
vector29:
  pushl $0
  101e39:	6a 00                	push   $0x0
  pushl $29
  101e3b:	6a 1d                	push   $0x1d
  jmp __alltraps
  101e3d:	e9 e0 fe ff ff       	jmp    101d22 <__alltraps>

00101e42 <vector30>:
.globl vector30
vector30:
  pushl $0
  101e42:	6a 00                	push   $0x0
  pushl $30
  101e44:	6a 1e                	push   $0x1e
  jmp __alltraps
  101e46:	e9 d7 fe ff ff       	jmp    101d22 <__alltraps>

00101e4b <vector31>:
.globl vector31
vector31:
  pushl $0
  101e4b:	6a 00                	push   $0x0
  pushl $31
  101e4d:	6a 1f                	push   $0x1f
  jmp __alltraps
  101e4f:	e9 ce fe ff ff       	jmp    101d22 <__alltraps>

00101e54 <vector32>:
.globl vector32
vector32:
  pushl $0
  101e54:	6a 00                	push   $0x0
  pushl $32
  101e56:	6a 20                	push   $0x20
  jmp __alltraps
  101e58:	e9 c5 fe ff ff       	jmp    101d22 <__alltraps>

00101e5d <vector33>:
.globl vector33
vector33:
  pushl $0
  101e5d:	6a 00                	push   $0x0
  pushl $33
  101e5f:	6a 21                	push   $0x21
  jmp __alltraps
  101e61:	e9 bc fe ff ff       	jmp    101d22 <__alltraps>

00101e66 <vector34>:
.globl vector34
vector34:
  pushl $0
  101e66:	6a 00                	push   $0x0
  pushl $34
  101e68:	6a 22                	push   $0x22
  jmp __alltraps
  101e6a:	e9 b3 fe ff ff       	jmp    101d22 <__alltraps>

00101e6f <vector35>:
.globl vector35
vector35:
  pushl $0
  101e6f:	6a 00                	push   $0x0
  pushl $35
  101e71:	6a 23                	push   $0x23
  jmp __alltraps
  101e73:	e9 aa fe ff ff       	jmp    101d22 <__alltraps>

00101e78 <vector36>:
.globl vector36
vector36:
  pushl $0
  101e78:	6a 00                	push   $0x0
  pushl $36
  101e7a:	6a 24                	push   $0x24
  jmp __alltraps
  101e7c:	e9 a1 fe ff ff       	jmp    101d22 <__alltraps>

00101e81 <vector37>:
.globl vector37
vector37:
  pushl $0
  101e81:	6a 00                	push   $0x0
  pushl $37
  101e83:	6a 25                	push   $0x25
  jmp __alltraps
  101e85:	e9 98 fe ff ff       	jmp    101d22 <__alltraps>

00101e8a <vector38>:
.globl vector38
vector38:
  pushl $0
  101e8a:	6a 00                	push   $0x0
  pushl $38
  101e8c:	6a 26                	push   $0x26
  jmp __alltraps
  101e8e:	e9 8f fe ff ff       	jmp    101d22 <__alltraps>

00101e93 <vector39>:
.globl vector39
vector39:
  pushl $0
  101e93:	6a 00                	push   $0x0
  pushl $39
  101e95:	6a 27                	push   $0x27
  jmp __alltraps
  101e97:	e9 86 fe ff ff       	jmp    101d22 <__alltraps>

00101e9c <vector40>:
.globl vector40
vector40:
  pushl $0
  101e9c:	6a 00                	push   $0x0
  pushl $40
  101e9e:	6a 28                	push   $0x28
  jmp __alltraps
  101ea0:	e9 7d fe ff ff       	jmp    101d22 <__alltraps>

00101ea5 <vector41>:
.globl vector41
vector41:
  pushl $0
  101ea5:	6a 00                	push   $0x0
  pushl $41
  101ea7:	6a 29                	push   $0x29
  jmp __alltraps
  101ea9:	e9 74 fe ff ff       	jmp    101d22 <__alltraps>

00101eae <vector42>:
.globl vector42
vector42:
  pushl $0
  101eae:	6a 00                	push   $0x0
  pushl $42
  101eb0:	6a 2a                	push   $0x2a
  jmp __alltraps
  101eb2:	e9 6b fe ff ff       	jmp    101d22 <__alltraps>

00101eb7 <vector43>:
.globl vector43
vector43:
  pushl $0
  101eb7:	6a 00                	push   $0x0
  pushl $43
  101eb9:	6a 2b                	push   $0x2b
  jmp __alltraps
  101ebb:	e9 62 fe ff ff       	jmp    101d22 <__alltraps>

00101ec0 <vector44>:
.globl vector44
vector44:
  pushl $0
  101ec0:	6a 00                	push   $0x0
  pushl $44
  101ec2:	6a 2c                	push   $0x2c
  jmp __alltraps
  101ec4:	e9 59 fe ff ff       	jmp    101d22 <__alltraps>

00101ec9 <vector45>:
.globl vector45
vector45:
  pushl $0
  101ec9:	6a 00                	push   $0x0
  pushl $45
  101ecb:	6a 2d                	push   $0x2d
  jmp __alltraps
  101ecd:	e9 50 fe ff ff       	jmp    101d22 <__alltraps>

00101ed2 <vector46>:
.globl vector46
vector46:
  pushl $0
  101ed2:	6a 00                	push   $0x0
  pushl $46
  101ed4:	6a 2e                	push   $0x2e
  jmp __alltraps
  101ed6:	e9 47 fe ff ff       	jmp    101d22 <__alltraps>

00101edb <vector47>:
.globl vector47
vector47:
  pushl $0
  101edb:	6a 00                	push   $0x0
  pushl $47
  101edd:	6a 2f                	push   $0x2f
  jmp __alltraps
  101edf:	e9 3e fe ff ff       	jmp    101d22 <__alltraps>

00101ee4 <vector48>:
.globl vector48
vector48:
  pushl $0
  101ee4:	6a 00                	push   $0x0
  pushl $48
  101ee6:	6a 30                	push   $0x30
  jmp __alltraps
  101ee8:	e9 35 fe ff ff       	jmp    101d22 <__alltraps>

00101eed <vector49>:
.globl vector49
vector49:
  pushl $0
  101eed:	6a 00                	push   $0x0
  pushl $49
  101eef:	6a 31                	push   $0x31
  jmp __alltraps
  101ef1:	e9 2c fe ff ff       	jmp    101d22 <__alltraps>

00101ef6 <vector50>:
.globl vector50
vector50:
  pushl $0
  101ef6:	6a 00                	push   $0x0
  pushl $50
  101ef8:	6a 32                	push   $0x32
  jmp __alltraps
  101efa:	e9 23 fe ff ff       	jmp    101d22 <__alltraps>

00101eff <vector51>:
.globl vector51
vector51:
  pushl $0
  101eff:	6a 00                	push   $0x0
  pushl $51
  101f01:	6a 33                	push   $0x33
  jmp __alltraps
  101f03:	e9 1a fe ff ff       	jmp    101d22 <__alltraps>

00101f08 <vector52>:
.globl vector52
vector52:
  pushl $0
  101f08:	6a 00                	push   $0x0
  pushl $52
  101f0a:	6a 34                	push   $0x34
  jmp __alltraps
  101f0c:	e9 11 fe ff ff       	jmp    101d22 <__alltraps>

00101f11 <vector53>:
.globl vector53
vector53:
  pushl $0
  101f11:	6a 00                	push   $0x0
  pushl $53
  101f13:	6a 35                	push   $0x35
  jmp __alltraps
  101f15:	e9 08 fe ff ff       	jmp    101d22 <__alltraps>

00101f1a <vector54>:
.globl vector54
vector54:
  pushl $0
  101f1a:	6a 00                	push   $0x0
  pushl $54
  101f1c:	6a 36                	push   $0x36
  jmp __alltraps
  101f1e:	e9 ff fd ff ff       	jmp    101d22 <__alltraps>

00101f23 <vector55>:
.globl vector55
vector55:
  pushl $0
  101f23:	6a 00                	push   $0x0
  pushl $55
  101f25:	6a 37                	push   $0x37
  jmp __alltraps
  101f27:	e9 f6 fd ff ff       	jmp    101d22 <__alltraps>

00101f2c <vector56>:
.globl vector56
vector56:
  pushl $0
  101f2c:	6a 00                	push   $0x0
  pushl $56
  101f2e:	6a 38                	push   $0x38
  jmp __alltraps
  101f30:	e9 ed fd ff ff       	jmp    101d22 <__alltraps>

00101f35 <vector57>:
.globl vector57
vector57:
  pushl $0
  101f35:	6a 00                	push   $0x0
  pushl $57
  101f37:	6a 39                	push   $0x39
  jmp __alltraps
  101f39:	e9 e4 fd ff ff       	jmp    101d22 <__alltraps>

00101f3e <vector58>:
.globl vector58
vector58:
  pushl $0
  101f3e:	6a 00                	push   $0x0
  pushl $58
  101f40:	6a 3a                	push   $0x3a
  jmp __alltraps
  101f42:	e9 db fd ff ff       	jmp    101d22 <__alltraps>

00101f47 <vector59>:
.globl vector59
vector59:
  pushl $0
  101f47:	6a 00                	push   $0x0
  pushl $59
  101f49:	6a 3b                	push   $0x3b
  jmp __alltraps
  101f4b:	e9 d2 fd ff ff       	jmp    101d22 <__alltraps>

00101f50 <vector60>:
.globl vector60
vector60:
  pushl $0
  101f50:	6a 00                	push   $0x0
  pushl $60
  101f52:	6a 3c                	push   $0x3c
  jmp __alltraps
  101f54:	e9 c9 fd ff ff       	jmp    101d22 <__alltraps>

00101f59 <vector61>:
.globl vector61
vector61:
  pushl $0
  101f59:	6a 00                	push   $0x0
  pushl $61
  101f5b:	6a 3d                	push   $0x3d
  jmp __alltraps
  101f5d:	e9 c0 fd ff ff       	jmp    101d22 <__alltraps>

00101f62 <vector62>:
.globl vector62
vector62:
  pushl $0
  101f62:	6a 00                	push   $0x0
  pushl $62
  101f64:	6a 3e                	push   $0x3e
  jmp __alltraps
  101f66:	e9 b7 fd ff ff       	jmp    101d22 <__alltraps>

00101f6b <vector63>:
.globl vector63
vector63:
  pushl $0
  101f6b:	6a 00                	push   $0x0
  pushl $63
  101f6d:	6a 3f                	push   $0x3f
  jmp __alltraps
  101f6f:	e9 ae fd ff ff       	jmp    101d22 <__alltraps>

00101f74 <vector64>:
.globl vector64
vector64:
  pushl $0
  101f74:	6a 00                	push   $0x0
  pushl $64
  101f76:	6a 40                	push   $0x40
  jmp __alltraps
  101f78:	e9 a5 fd ff ff       	jmp    101d22 <__alltraps>

00101f7d <vector65>:
.globl vector65
vector65:
  pushl $0
  101f7d:	6a 00                	push   $0x0
  pushl $65
  101f7f:	6a 41                	push   $0x41
  jmp __alltraps
  101f81:	e9 9c fd ff ff       	jmp    101d22 <__alltraps>

00101f86 <vector66>:
.globl vector66
vector66:
  pushl $0
  101f86:	6a 00                	push   $0x0
  pushl $66
  101f88:	6a 42                	push   $0x42
  jmp __alltraps
  101f8a:	e9 93 fd ff ff       	jmp    101d22 <__alltraps>

00101f8f <vector67>:
.globl vector67
vector67:
  pushl $0
  101f8f:	6a 00                	push   $0x0
  pushl $67
  101f91:	6a 43                	push   $0x43
  jmp __alltraps
  101f93:	e9 8a fd ff ff       	jmp    101d22 <__alltraps>

00101f98 <vector68>:
.globl vector68
vector68:
  pushl $0
  101f98:	6a 00                	push   $0x0
  pushl $68
  101f9a:	6a 44                	push   $0x44
  jmp __alltraps
  101f9c:	e9 81 fd ff ff       	jmp    101d22 <__alltraps>

00101fa1 <vector69>:
.globl vector69
vector69:
  pushl $0
  101fa1:	6a 00                	push   $0x0
  pushl $69
  101fa3:	6a 45                	push   $0x45
  jmp __alltraps
  101fa5:	e9 78 fd ff ff       	jmp    101d22 <__alltraps>

00101faa <vector70>:
.globl vector70
vector70:
  pushl $0
  101faa:	6a 00                	push   $0x0
  pushl $70
  101fac:	6a 46                	push   $0x46
  jmp __alltraps
  101fae:	e9 6f fd ff ff       	jmp    101d22 <__alltraps>

00101fb3 <vector71>:
.globl vector71
vector71:
  pushl $0
  101fb3:	6a 00                	push   $0x0
  pushl $71
  101fb5:	6a 47                	push   $0x47
  jmp __alltraps
  101fb7:	e9 66 fd ff ff       	jmp    101d22 <__alltraps>

00101fbc <vector72>:
.globl vector72
vector72:
  pushl $0
  101fbc:	6a 00                	push   $0x0
  pushl $72
  101fbe:	6a 48                	push   $0x48
  jmp __alltraps
  101fc0:	e9 5d fd ff ff       	jmp    101d22 <__alltraps>

00101fc5 <vector73>:
.globl vector73
vector73:
  pushl $0
  101fc5:	6a 00                	push   $0x0
  pushl $73
  101fc7:	6a 49                	push   $0x49
  jmp __alltraps
  101fc9:	e9 54 fd ff ff       	jmp    101d22 <__alltraps>

00101fce <vector74>:
.globl vector74
vector74:
  pushl $0
  101fce:	6a 00                	push   $0x0
  pushl $74
  101fd0:	6a 4a                	push   $0x4a
  jmp __alltraps
  101fd2:	e9 4b fd ff ff       	jmp    101d22 <__alltraps>

00101fd7 <vector75>:
.globl vector75
vector75:
  pushl $0
  101fd7:	6a 00                	push   $0x0
  pushl $75
  101fd9:	6a 4b                	push   $0x4b
  jmp __alltraps
  101fdb:	e9 42 fd ff ff       	jmp    101d22 <__alltraps>

00101fe0 <vector76>:
.globl vector76
vector76:
  pushl $0
  101fe0:	6a 00                	push   $0x0
  pushl $76
  101fe2:	6a 4c                	push   $0x4c
  jmp __alltraps
  101fe4:	e9 39 fd ff ff       	jmp    101d22 <__alltraps>

00101fe9 <vector77>:
.globl vector77
vector77:
  pushl $0
  101fe9:	6a 00                	push   $0x0
  pushl $77
  101feb:	6a 4d                	push   $0x4d
  jmp __alltraps
  101fed:	e9 30 fd ff ff       	jmp    101d22 <__alltraps>

00101ff2 <vector78>:
.globl vector78
vector78:
  pushl $0
  101ff2:	6a 00                	push   $0x0
  pushl $78
  101ff4:	6a 4e                	push   $0x4e
  jmp __alltraps
  101ff6:	e9 27 fd ff ff       	jmp    101d22 <__alltraps>

00101ffb <vector79>:
.globl vector79
vector79:
  pushl $0
  101ffb:	6a 00                	push   $0x0
  pushl $79
  101ffd:	6a 4f                	push   $0x4f
  jmp __alltraps
  101fff:	e9 1e fd ff ff       	jmp    101d22 <__alltraps>

00102004 <vector80>:
.globl vector80
vector80:
  pushl $0
  102004:	6a 00                	push   $0x0
  pushl $80
  102006:	6a 50                	push   $0x50
  jmp __alltraps
  102008:	e9 15 fd ff ff       	jmp    101d22 <__alltraps>

0010200d <vector81>:
.globl vector81
vector81:
  pushl $0
  10200d:	6a 00                	push   $0x0
  pushl $81
  10200f:	6a 51                	push   $0x51
  jmp __alltraps
  102011:	e9 0c fd ff ff       	jmp    101d22 <__alltraps>

00102016 <vector82>:
.globl vector82
vector82:
  pushl $0
  102016:	6a 00                	push   $0x0
  pushl $82
  102018:	6a 52                	push   $0x52
  jmp __alltraps
  10201a:	e9 03 fd ff ff       	jmp    101d22 <__alltraps>

0010201f <vector83>:
.globl vector83
vector83:
  pushl $0
  10201f:	6a 00                	push   $0x0
  pushl $83
  102021:	6a 53                	push   $0x53
  jmp __alltraps
  102023:	e9 fa fc ff ff       	jmp    101d22 <__alltraps>

00102028 <vector84>:
.globl vector84
vector84:
  pushl $0
  102028:	6a 00                	push   $0x0
  pushl $84
  10202a:	6a 54                	push   $0x54
  jmp __alltraps
  10202c:	e9 f1 fc ff ff       	jmp    101d22 <__alltraps>

00102031 <vector85>:
.globl vector85
vector85:
  pushl $0
  102031:	6a 00                	push   $0x0
  pushl $85
  102033:	6a 55                	push   $0x55
  jmp __alltraps
  102035:	e9 e8 fc ff ff       	jmp    101d22 <__alltraps>

0010203a <vector86>:
.globl vector86
vector86:
  pushl $0
  10203a:	6a 00                	push   $0x0
  pushl $86
  10203c:	6a 56                	push   $0x56
  jmp __alltraps
  10203e:	e9 df fc ff ff       	jmp    101d22 <__alltraps>

00102043 <vector87>:
.globl vector87
vector87:
  pushl $0
  102043:	6a 00                	push   $0x0
  pushl $87
  102045:	6a 57                	push   $0x57
  jmp __alltraps
  102047:	e9 d6 fc ff ff       	jmp    101d22 <__alltraps>

0010204c <vector88>:
.globl vector88
vector88:
  pushl $0
  10204c:	6a 00                	push   $0x0
  pushl $88
  10204e:	6a 58                	push   $0x58
  jmp __alltraps
  102050:	e9 cd fc ff ff       	jmp    101d22 <__alltraps>

00102055 <vector89>:
.globl vector89
vector89:
  pushl $0
  102055:	6a 00                	push   $0x0
  pushl $89
  102057:	6a 59                	push   $0x59
  jmp __alltraps
  102059:	e9 c4 fc ff ff       	jmp    101d22 <__alltraps>

0010205e <vector90>:
.globl vector90
vector90:
  pushl $0
  10205e:	6a 00                	push   $0x0
  pushl $90
  102060:	6a 5a                	push   $0x5a
  jmp __alltraps
  102062:	e9 bb fc ff ff       	jmp    101d22 <__alltraps>

00102067 <vector91>:
.globl vector91
vector91:
  pushl $0
  102067:	6a 00                	push   $0x0
  pushl $91
  102069:	6a 5b                	push   $0x5b
  jmp __alltraps
  10206b:	e9 b2 fc ff ff       	jmp    101d22 <__alltraps>

00102070 <vector92>:
.globl vector92
vector92:
  pushl $0
  102070:	6a 00                	push   $0x0
  pushl $92
  102072:	6a 5c                	push   $0x5c
  jmp __alltraps
  102074:	e9 a9 fc ff ff       	jmp    101d22 <__alltraps>

00102079 <vector93>:
.globl vector93
vector93:
  pushl $0
  102079:	6a 00                	push   $0x0
  pushl $93
  10207b:	6a 5d                	push   $0x5d
  jmp __alltraps
  10207d:	e9 a0 fc ff ff       	jmp    101d22 <__alltraps>

00102082 <vector94>:
.globl vector94
vector94:
  pushl $0
  102082:	6a 00                	push   $0x0
  pushl $94
  102084:	6a 5e                	push   $0x5e
  jmp __alltraps
  102086:	e9 97 fc ff ff       	jmp    101d22 <__alltraps>

0010208b <vector95>:
.globl vector95
vector95:
  pushl $0
  10208b:	6a 00                	push   $0x0
  pushl $95
  10208d:	6a 5f                	push   $0x5f
  jmp __alltraps
  10208f:	e9 8e fc ff ff       	jmp    101d22 <__alltraps>

00102094 <vector96>:
.globl vector96
vector96:
  pushl $0
  102094:	6a 00                	push   $0x0
  pushl $96
  102096:	6a 60                	push   $0x60
  jmp __alltraps
  102098:	e9 85 fc ff ff       	jmp    101d22 <__alltraps>

0010209d <vector97>:
.globl vector97
vector97:
  pushl $0
  10209d:	6a 00                	push   $0x0
  pushl $97
  10209f:	6a 61                	push   $0x61
  jmp __alltraps
  1020a1:	e9 7c fc ff ff       	jmp    101d22 <__alltraps>

001020a6 <vector98>:
.globl vector98
vector98:
  pushl $0
  1020a6:	6a 00                	push   $0x0
  pushl $98
  1020a8:	6a 62                	push   $0x62
  jmp __alltraps
  1020aa:	e9 73 fc ff ff       	jmp    101d22 <__alltraps>

001020af <vector99>:
.globl vector99
vector99:
  pushl $0
  1020af:	6a 00                	push   $0x0
  pushl $99
  1020b1:	6a 63                	push   $0x63
  jmp __alltraps
  1020b3:	e9 6a fc ff ff       	jmp    101d22 <__alltraps>

001020b8 <vector100>:
.globl vector100
vector100:
  pushl $0
  1020b8:	6a 00                	push   $0x0
  pushl $100
  1020ba:	6a 64                	push   $0x64
  jmp __alltraps
  1020bc:	e9 61 fc ff ff       	jmp    101d22 <__alltraps>

001020c1 <vector101>:
.globl vector101
vector101:
  pushl $0
  1020c1:	6a 00                	push   $0x0
  pushl $101
  1020c3:	6a 65                	push   $0x65
  jmp __alltraps
  1020c5:	e9 58 fc ff ff       	jmp    101d22 <__alltraps>

001020ca <vector102>:
.globl vector102
vector102:
  pushl $0
  1020ca:	6a 00                	push   $0x0
  pushl $102
  1020cc:	6a 66                	push   $0x66
  jmp __alltraps
  1020ce:	e9 4f fc ff ff       	jmp    101d22 <__alltraps>

001020d3 <vector103>:
.globl vector103
vector103:
  pushl $0
  1020d3:	6a 00                	push   $0x0
  pushl $103
  1020d5:	6a 67                	push   $0x67
  jmp __alltraps
  1020d7:	e9 46 fc ff ff       	jmp    101d22 <__alltraps>

001020dc <vector104>:
.globl vector104
vector104:
  pushl $0
  1020dc:	6a 00                	push   $0x0
  pushl $104
  1020de:	6a 68                	push   $0x68
  jmp __alltraps
  1020e0:	e9 3d fc ff ff       	jmp    101d22 <__alltraps>

001020e5 <vector105>:
.globl vector105
vector105:
  pushl $0
  1020e5:	6a 00                	push   $0x0
  pushl $105
  1020e7:	6a 69                	push   $0x69
  jmp __alltraps
  1020e9:	e9 34 fc ff ff       	jmp    101d22 <__alltraps>

001020ee <vector106>:
.globl vector106
vector106:
  pushl $0
  1020ee:	6a 00                	push   $0x0
  pushl $106
  1020f0:	6a 6a                	push   $0x6a
  jmp __alltraps
  1020f2:	e9 2b fc ff ff       	jmp    101d22 <__alltraps>

001020f7 <vector107>:
.globl vector107
vector107:
  pushl $0
  1020f7:	6a 00                	push   $0x0
  pushl $107
  1020f9:	6a 6b                	push   $0x6b
  jmp __alltraps
  1020fb:	e9 22 fc ff ff       	jmp    101d22 <__alltraps>

00102100 <vector108>:
.globl vector108
vector108:
  pushl $0
  102100:	6a 00                	push   $0x0
  pushl $108
  102102:	6a 6c                	push   $0x6c
  jmp __alltraps
  102104:	e9 19 fc ff ff       	jmp    101d22 <__alltraps>

00102109 <vector109>:
.globl vector109
vector109:
  pushl $0
  102109:	6a 00                	push   $0x0
  pushl $109
  10210b:	6a 6d                	push   $0x6d
  jmp __alltraps
  10210d:	e9 10 fc ff ff       	jmp    101d22 <__alltraps>

00102112 <vector110>:
.globl vector110
vector110:
  pushl $0
  102112:	6a 00                	push   $0x0
  pushl $110
  102114:	6a 6e                	push   $0x6e
  jmp __alltraps
  102116:	e9 07 fc ff ff       	jmp    101d22 <__alltraps>

0010211b <vector111>:
.globl vector111
vector111:
  pushl $0
  10211b:	6a 00                	push   $0x0
  pushl $111
  10211d:	6a 6f                	push   $0x6f
  jmp __alltraps
  10211f:	e9 fe fb ff ff       	jmp    101d22 <__alltraps>

00102124 <vector112>:
.globl vector112
vector112:
  pushl $0
  102124:	6a 00                	push   $0x0
  pushl $112
  102126:	6a 70                	push   $0x70
  jmp __alltraps
  102128:	e9 f5 fb ff ff       	jmp    101d22 <__alltraps>

0010212d <vector113>:
.globl vector113
vector113:
  pushl $0
  10212d:	6a 00                	push   $0x0
  pushl $113
  10212f:	6a 71                	push   $0x71
  jmp __alltraps
  102131:	e9 ec fb ff ff       	jmp    101d22 <__alltraps>

00102136 <vector114>:
.globl vector114
vector114:
  pushl $0
  102136:	6a 00                	push   $0x0
  pushl $114
  102138:	6a 72                	push   $0x72
  jmp __alltraps
  10213a:	e9 e3 fb ff ff       	jmp    101d22 <__alltraps>

0010213f <vector115>:
.globl vector115
vector115:
  pushl $0
  10213f:	6a 00                	push   $0x0
  pushl $115
  102141:	6a 73                	push   $0x73
  jmp __alltraps
  102143:	e9 da fb ff ff       	jmp    101d22 <__alltraps>

00102148 <vector116>:
.globl vector116
vector116:
  pushl $0
  102148:	6a 00                	push   $0x0
  pushl $116
  10214a:	6a 74                	push   $0x74
  jmp __alltraps
  10214c:	e9 d1 fb ff ff       	jmp    101d22 <__alltraps>

00102151 <vector117>:
.globl vector117
vector117:
  pushl $0
  102151:	6a 00                	push   $0x0
  pushl $117
  102153:	6a 75                	push   $0x75
  jmp __alltraps
  102155:	e9 c8 fb ff ff       	jmp    101d22 <__alltraps>

0010215a <vector118>:
.globl vector118
vector118:
  pushl $0
  10215a:	6a 00                	push   $0x0
  pushl $118
  10215c:	6a 76                	push   $0x76
  jmp __alltraps
  10215e:	e9 bf fb ff ff       	jmp    101d22 <__alltraps>

00102163 <vector119>:
.globl vector119
vector119:
  pushl $0
  102163:	6a 00                	push   $0x0
  pushl $119
  102165:	6a 77                	push   $0x77
  jmp __alltraps
  102167:	e9 b6 fb ff ff       	jmp    101d22 <__alltraps>

0010216c <vector120>:
.globl vector120
vector120:
  pushl $0
  10216c:	6a 00                	push   $0x0
  pushl $120
  10216e:	6a 78                	push   $0x78
  jmp __alltraps
  102170:	e9 ad fb ff ff       	jmp    101d22 <__alltraps>

00102175 <vector121>:
.globl vector121
vector121:
  pushl $0
  102175:	6a 00                	push   $0x0
  pushl $121
  102177:	6a 79                	push   $0x79
  jmp __alltraps
  102179:	e9 a4 fb ff ff       	jmp    101d22 <__alltraps>

0010217e <vector122>:
.globl vector122
vector122:
  pushl $0
  10217e:	6a 00                	push   $0x0
  pushl $122
  102180:	6a 7a                	push   $0x7a
  jmp __alltraps
  102182:	e9 9b fb ff ff       	jmp    101d22 <__alltraps>

00102187 <vector123>:
.globl vector123
vector123:
  pushl $0
  102187:	6a 00                	push   $0x0
  pushl $123
  102189:	6a 7b                	push   $0x7b
  jmp __alltraps
  10218b:	e9 92 fb ff ff       	jmp    101d22 <__alltraps>

00102190 <vector124>:
.globl vector124
vector124:
  pushl $0
  102190:	6a 00                	push   $0x0
  pushl $124
  102192:	6a 7c                	push   $0x7c
  jmp __alltraps
  102194:	e9 89 fb ff ff       	jmp    101d22 <__alltraps>

00102199 <vector125>:
.globl vector125
vector125:
  pushl $0
  102199:	6a 00                	push   $0x0
  pushl $125
  10219b:	6a 7d                	push   $0x7d
  jmp __alltraps
  10219d:	e9 80 fb ff ff       	jmp    101d22 <__alltraps>

001021a2 <vector126>:
.globl vector126
vector126:
  pushl $0
  1021a2:	6a 00                	push   $0x0
  pushl $126
  1021a4:	6a 7e                	push   $0x7e
  jmp __alltraps
  1021a6:	e9 77 fb ff ff       	jmp    101d22 <__alltraps>

001021ab <vector127>:
.globl vector127
vector127:
  pushl $0
  1021ab:	6a 00                	push   $0x0
  pushl $127
  1021ad:	6a 7f                	push   $0x7f
  jmp __alltraps
  1021af:	e9 6e fb ff ff       	jmp    101d22 <__alltraps>

001021b4 <vector128>:
.globl vector128
vector128:
  pushl $0
  1021b4:	6a 00                	push   $0x0
  pushl $128
  1021b6:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1021bb:	e9 62 fb ff ff       	jmp    101d22 <__alltraps>

001021c0 <vector129>:
.globl vector129
vector129:
  pushl $0
  1021c0:	6a 00                	push   $0x0
  pushl $129
  1021c2:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1021c7:	e9 56 fb ff ff       	jmp    101d22 <__alltraps>

001021cc <vector130>:
.globl vector130
vector130:
  pushl $0
  1021cc:	6a 00                	push   $0x0
  pushl $130
  1021ce:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1021d3:	e9 4a fb ff ff       	jmp    101d22 <__alltraps>

001021d8 <vector131>:
.globl vector131
vector131:
  pushl $0
  1021d8:	6a 00                	push   $0x0
  pushl $131
  1021da:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1021df:	e9 3e fb ff ff       	jmp    101d22 <__alltraps>

001021e4 <vector132>:
.globl vector132
vector132:
  pushl $0
  1021e4:	6a 00                	push   $0x0
  pushl $132
  1021e6:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1021eb:	e9 32 fb ff ff       	jmp    101d22 <__alltraps>

001021f0 <vector133>:
.globl vector133
vector133:
  pushl $0
  1021f0:	6a 00                	push   $0x0
  pushl $133
  1021f2:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1021f7:	e9 26 fb ff ff       	jmp    101d22 <__alltraps>

001021fc <vector134>:
.globl vector134
vector134:
  pushl $0
  1021fc:	6a 00                	push   $0x0
  pushl $134
  1021fe:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102203:	e9 1a fb ff ff       	jmp    101d22 <__alltraps>

00102208 <vector135>:
.globl vector135
vector135:
  pushl $0
  102208:	6a 00                	push   $0x0
  pushl $135
  10220a:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10220f:	e9 0e fb ff ff       	jmp    101d22 <__alltraps>

00102214 <vector136>:
.globl vector136
vector136:
  pushl $0
  102214:	6a 00                	push   $0x0
  pushl $136
  102216:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10221b:	e9 02 fb ff ff       	jmp    101d22 <__alltraps>

00102220 <vector137>:
.globl vector137
vector137:
  pushl $0
  102220:	6a 00                	push   $0x0
  pushl $137
  102222:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102227:	e9 f6 fa ff ff       	jmp    101d22 <__alltraps>

0010222c <vector138>:
.globl vector138
vector138:
  pushl $0
  10222c:	6a 00                	push   $0x0
  pushl $138
  10222e:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102233:	e9 ea fa ff ff       	jmp    101d22 <__alltraps>

00102238 <vector139>:
.globl vector139
vector139:
  pushl $0
  102238:	6a 00                	push   $0x0
  pushl $139
  10223a:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  10223f:	e9 de fa ff ff       	jmp    101d22 <__alltraps>

00102244 <vector140>:
.globl vector140
vector140:
  pushl $0
  102244:	6a 00                	push   $0x0
  pushl $140
  102246:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10224b:	e9 d2 fa ff ff       	jmp    101d22 <__alltraps>

00102250 <vector141>:
.globl vector141
vector141:
  pushl $0
  102250:	6a 00                	push   $0x0
  pushl $141
  102252:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102257:	e9 c6 fa ff ff       	jmp    101d22 <__alltraps>

0010225c <vector142>:
.globl vector142
vector142:
  pushl $0
  10225c:	6a 00                	push   $0x0
  pushl $142
  10225e:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102263:	e9 ba fa ff ff       	jmp    101d22 <__alltraps>

00102268 <vector143>:
.globl vector143
vector143:
  pushl $0
  102268:	6a 00                	push   $0x0
  pushl $143
  10226a:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10226f:	e9 ae fa ff ff       	jmp    101d22 <__alltraps>

00102274 <vector144>:
.globl vector144
vector144:
  pushl $0
  102274:	6a 00                	push   $0x0
  pushl $144
  102276:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10227b:	e9 a2 fa ff ff       	jmp    101d22 <__alltraps>

00102280 <vector145>:
.globl vector145
vector145:
  pushl $0
  102280:	6a 00                	push   $0x0
  pushl $145
  102282:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102287:	e9 96 fa ff ff       	jmp    101d22 <__alltraps>

0010228c <vector146>:
.globl vector146
vector146:
  pushl $0
  10228c:	6a 00                	push   $0x0
  pushl $146
  10228e:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102293:	e9 8a fa ff ff       	jmp    101d22 <__alltraps>

00102298 <vector147>:
.globl vector147
vector147:
  pushl $0
  102298:	6a 00                	push   $0x0
  pushl $147
  10229a:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10229f:	e9 7e fa ff ff       	jmp    101d22 <__alltraps>

001022a4 <vector148>:
.globl vector148
vector148:
  pushl $0
  1022a4:	6a 00                	push   $0x0
  pushl $148
  1022a6:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1022ab:	e9 72 fa ff ff       	jmp    101d22 <__alltraps>

001022b0 <vector149>:
.globl vector149
vector149:
  pushl $0
  1022b0:	6a 00                	push   $0x0
  pushl $149
  1022b2:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1022b7:	e9 66 fa ff ff       	jmp    101d22 <__alltraps>

001022bc <vector150>:
.globl vector150
vector150:
  pushl $0
  1022bc:	6a 00                	push   $0x0
  pushl $150
  1022be:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1022c3:	e9 5a fa ff ff       	jmp    101d22 <__alltraps>

001022c8 <vector151>:
.globl vector151
vector151:
  pushl $0
  1022c8:	6a 00                	push   $0x0
  pushl $151
  1022ca:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1022cf:	e9 4e fa ff ff       	jmp    101d22 <__alltraps>

001022d4 <vector152>:
.globl vector152
vector152:
  pushl $0
  1022d4:	6a 00                	push   $0x0
  pushl $152
  1022d6:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1022db:	e9 42 fa ff ff       	jmp    101d22 <__alltraps>

001022e0 <vector153>:
.globl vector153
vector153:
  pushl $0
  1022e0:	6a 00                	push   $0x0
  pushl $153
  1022e2:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1022e7:	e9 36 fa ff ff       	jmp    101d22 <__alltraps>

001022ec <vector154>:
.globl vector154
vector154:
  pushl $0
  1022ec:	6a 00                	push   $0x0
  pushl $154
  1022ee:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1022f3:	e9 2a fa ff ff       	jmp    101d22 <__alltraps>

001022f8 <vector155>:
.globl vector155
vector155:
  pushl $0
  1022f8:	6a 00                	push   $0x0
  pushl $155
  1022fa:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1022ff:	e9 1e fa ff ff       	jmp    101d22 <__alltraps>

00102304 <vector156>:
.globl vector156
vector156:
  pushl $0
  102304:	6a 00                	push   $0x0
  pushl $156
  102306:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10230b:	e9 12 fa ff ff       	jmp    101d22 <__alltraps>

00102310 <vector157>:
.globl vector157
vector157:
  pushl $0
  102310:	6a 00                	push   $0x0
  pushl $157
  102312:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102317:	e9 06 fa ff ff       	jmp    101d22 <__alltraps>

0010231c <vector158>:
.globl vector158
vector158:
  pushl $0
  10231c:	6a 00                	push   $0x0
  pushl $158
  10231e:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102323:	e9 fa f9 ff ff       	jmp    101d22 <__alltraps>

00102328 <vector159>:
.globl vector159
vector159:
  pushl $0
  102328:	6a 00                	push   $0x0
  pushl $159
  10232a:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10232f:	e9 ee f9 ff ff       	jmp    101d22 <__alltraps>

00102334 <vector160>:
.globl vector160
vector160:
  pushl $0
  102334:	6a 00                	push   $0x0
  pushl $160
  102336:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10233b:	e9 e2 f9 ff ff       	jmp    101d22 <__alltraps>

00102340 <vector161>:
.globl vector161
vector161:
  pushl $0
  102340:	6a 00                	push   $0x0
  pushl $161
  102342:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102347:	e9 d6 f9 ff ff       	jmp    101d22 <__alltraps>

0010234c <vector162>:
.globl vector162
vector162:
  pushl $0
  10234c:	6a 00                	push   $0x0
  pushl $162
  10234e:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102353:	e9 ca f9 ff ff       	jmp    101d22 <__alltraps>

00102358 <vector163>:
.globl vector163
vector163:
  pushl $0
  102358:	6a 00                	push   $0x0
  pushl $163
  10235a:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  10235f:	e9 be f9 ff ff       	jmp    101d22 <__alltraps>

00102364 <vector164>:
.globl vector164
vector164:
  pushl $0
  102364:	6a 00                	push   $0x0
  pushl $164
  102366:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10236b:	e9 b2 f9 ff ff       	jmp    101d22 <__alltraps>

00102370 <vector165>:
.globl vector165
vector165:
  pushl $0
  102370:	6a 00                	push   $0x0
  pushl $165
  102372:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102377:	e9 a6 f9 ff ff       	jmp    101d22 <__alltraps>

0010237c <vector166>:
.globl vector166
vector166:
  pushl $0
  10237c:	6a 00                	push   $0x0
  pushl $166
  10237e:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102383:	e9 9a f9 ff ff       	jmp    101d22 <__alltraps>

00102388 <vector167>:
.globl vector167
vector167:
  pushl $0
  102388:	6a 00                	push   $0x0
  pushl $167
  10238a:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10238f:	e9 8e f9 ff ff       	jmp    101d22 <__alltraps>

00102394 <vector168>:
.globl vector168
vector168:
  pushl $0
  102394:	6a 00                	push   $0x0
  pushl $168
  102396:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10239b:	e9 82 f9 ff ff       	jmp    101d22 <__alltraps>

001023a0 <vector169>:
.globl vector169
vector169:
  pushl $0
  1023a0:	6a 00                	push   $0x0
  pushl $169
  1023a2:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1023a7:	e9 76 f9 ff ff       	jmp    101d22 <__alltraps>

001023ac <vector170>:
.globl vector170
vector170:
  pushl $0
  1023ac:	6a 00                	push   $0x0
  pushl $170
  1023ae:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1023b3:	e9 6a f9 ff ff       	jmp    101d22 <__alltraps>

001023b8 <vector171>:
.globl vector171
vector171:
  pushl $0
  1023b8:	6a 00                	push   $0x0
  pushl $171
  1023ba:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1023bf:	e9 5e f9 ff ff       	jmp    101d22 <__alltraps>

001023c4 <vector172>:
.globl vector172
vector172:
  pushl $0
  1023c4:	6a 00                	push   $0x0
  pushl $172
  1023c6:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1023cb:	e9 52 f9 ff ff       	jmp    101d22 <__alltraps>

001023d0 <vector173>:
.globl vector173
vector173:
  pushl $0
  1023d0:	6a 00                	push   $0x0
  pushl $173
  1023d2:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1023d7:	e9 46 f9 ff ff       	jmp    101d22 <__alltraps>

001023dc <vector174>:
.globl vector174
vector174:
  pushl $0
  1023dc:	6a 00                	push   $0x0
  pushl $174
  1023de:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1023e3:	e9 3a f9 ff ff       	jmp    101d22 <__alltraps>

001023e8 <vector175>:
.globl vector175
vector175:
  pushl $0
  1023e8:	6a 00                	push   $0x0
  pushl $175
  1023ea:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1023ef:	e9 2e f9 ff ff       	jmp    101d22 <__alltraps>

001023f4 <vector176>:
.globl vector176
vector176:
  pushl $0
  1023f4:	6a 00                	push   $0x0
  pushl $176
  1023f6:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1023fb:	e9 22 f9 ff ff       	jmp    101d22 <__alltraps>

00102400 <vector177>:
.globl vector177
vector177:
  pushl $0
  102400:	6a 00                	push   $0x0
  pushl $177
  102402:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102407:	e9 16 f9 ff ff       	jmp    101d22 <__alltraps>

0010240c <vector178>:
.globl vector178
vector178:
  pushl $0
  10240c:	6a 00                	push   $0x0
  pushl $178
  10240e:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102413:	e9 0a f9 ff ff       	jmp    101d22 <__alltraps>

00102418 <vector179>:
.globl vector179
vector179:
  pushl $0
  102418:	6a 00                	push   $0x0
  pushl $179
  10241a:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10241f:	e9 fe f8 ff ff       	jmp    101d22 <__alltraps>

00102424 <vector180>:
.globl vector180
vector180:
  pushl $0
  102424:	6a 00                	push   $0x0
  pushl $180
  102426:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10242b:	e9 f2 f8 ff ff       	jmp    101d22 <__alltraps>

00102430 <vector181>:
.globl vector181
vector181:
  pushl $0
  102430:	6a 00                	push   $0x0
  pushl $181
  102432:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102437:	e9 e6 f8 ff ff       	jmp    101d22 <__alltraps>

0010243c <vector182>:
.globl vector182
vector182:
  pushl $0
  10243c:	6a 00                	push   $0x0
  pushl $182
  10243e:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102443:	e9 da f8 ff ff       	jmp    101d22 <__alltraps>

00102448 <vector183>:
.globl vector183
vector183:
  pushl $0
  102448:	6a 00                	push   $0x0
  pushl $183
  10244a:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  10244f:	e9 ce f8 ff ff       	jmp    101d22 <__alltraps>

00102454 <vector184>:
.globl vector184
vector184:
  pushl $0
  102454:	6a 00                	push   $0x0
  pushl $184
  102456:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10245b:	e9 c2 f8 ff ff       	jmp    101d22 <__alltraps>

00102460 <vector185>:
.globl vector185
vector185:
  pushl $0
  102460:	6a 00                	push   $0x0
  pushl $185
  102462:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102467:	e9 b6 f8 ff ff       	jmp    101d22 <__alltraps>

0010246c <vector186>:
.globl vector186
vector186:
  pushl $0
  10246c:	6a 00                	push   $0x0
  pushl $186
  10246e:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102473:	e9 aa f8 ff ff       	jmp    101d22 <__alltraps>

00102478 <vector187>:
.globl vector187
vector187:
  pushl $0
  102478:	6a 00                	push   $0x0
  pushl $187
  10247a:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10247f:	e9 9e f8 ff ff       	jmp    101d22 <__alltraps>

00102484 <vector188>:
.globl vector188
vector188:
  pushl $0
  102484:	6a 00                	push   $0x0
  pushl $188
  102486:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10248b:	e9 92 f8 ff ff       	jmp    101d22 <__alltraps>

00102490 <vector189>:
.globl vector189
vector189:
  pushl $0
  102490:	6a 00                	push   $0x0
  pushl $189
  102492:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102497:	e9 86 f8 ff ff       	jmp    101d22 <__alltraps>

0010249c <vector190>:
.globl vector190
vector190:
  pushl $0
  10249c:	6a 00                	push   $0x0
  pushl $190
  10249e:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1024a3:	e9 7a f8 ff ff       	jmp    101d22 <__alltraps>

001024a8 <vector191>:
.globl vector191
vector191:
  pushl $0
  1024a8:	6a 00                	push   $0x0
  pushl $191
  1024aa:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1024af:	e9 6e f8 ff ff       	jmp    101d22 <__alltraps>

001024b4 <vector192>:
.globl vector192
vector192:
  pushl $0
  1024b4:	6a 00                	push   $0x0
  pushl $192
  1024b6:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1024bb:	e9 62 f8 ff ff       	jmp    101d22 <__alltraps>

001024c0 <vector193>:
.globl vector193
vector193:
  pushl $0
  1024c0:	6a 00                	push   $0x0
  pushl $193
  1024c2:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1024c7:	e9 56 f8 ff ff       	jmp    101d22 <__alltraps>

001024cc <vector194>:
.globl vector194
vector194:
  pushl $0
  1024cc:	6a 00                	push   $0x0
  pushl $194
  1024ce:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1024d3:	e9 4a f8 ff ff       	jmp    101d22 <__alltraps>

001024d8 <vector195>:
.globl vector195
vector195:
  pushl $0
  1024d8:	6a 00                	push   $0x0
  pushl $195
  1024da:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1024df:	e9 3e f8 ff ff       	jmp    101d22 <__alltraps>

001024e4 <vector196>:
.globl vector196
vector196:
  pushl $0
  1024e4:	6a 00                	push   $0x0
  pushl $196
  1024e6:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1024eb:	e9 32 f8 ff ff       	jmp    101d22 <__alltraps>

001024f0 <vector197>:
.globl vector197
vector197:
  pushl $0
  1024f0:	6a 00                	push   $0x0
  pushl $197
  1024f2:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1024f7:	e9 26 f8 ff ff       	jmp    101d22 <__alltraps>

001024fc <vector198>:
.globl vector198
vector198:
  pushl $0
  1024fc:	6a 00                	push   $0x0
  pushl $198
  1024fe:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102503:	e9 1a f8 ff ff       	jmp    101d22 <__alltraps>

00102508 <vector199>:
.globl vector199
vector199:
  pushl $0
  102508:	6a 00                	push   $0x0
  pushl $199
  10250a:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10250f:	e9 0e f8 ff ff       	jmp    101d22 <__alltraps>

00102514 <vector200>:
.globl vector200
vector200:
  pushl $0
  102514:	6a 00                	push   $0x0
  pushl $200
  102516:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10251b:	e9 02 f8 ff ff       	jmp    101d22 <__alltraps>

00102520 <vector201>:
.globl vector201
vector201:
  pushl $0
  102520:	6a 00                	push   $0x0
  pushl $201
  102522:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102527:	e9 f6 f7 ff ff       	jmp    101d22 <__alltraps>

0010252c <vector202>:
.globl vector202
vector202:
  pushl $0
  10252c:	6a 00                	push   $0x0
  pushl $202
  10252e:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102533:	e9 ea f7 ff ff       	jmp    101d22 <__alltraps>

00102538 <vector203>:
.globl vector203
vector203:
  pushl $0
  102538:	6a 00                	push   $0x0
  pushl $203
  10253a:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  10253f:	e9 de f7 ff ff       	jmp    101d22 <__alltraps>

00102544 <vector204>:
.globl vector204
vector204:
  pushl $0
  102544:	6a 00                	push   $0x0
  pushl $204
  102546:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10254b:	e9 d2 f7 ff ff       	jmp    101d22 <__alltraps>

00102550 <vector205>:
.globl vector205
vector205:
  pushl $0
  102550:	6a 00                	push   $0x0
  pushl $205
  102552:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102557:	e9 c6 f7 ff ff       	jmp    101d22 <__alltraps>

0010255c <vector206>:
.globl vector206
vector206:
  pushl $0
  10255c:	6a 00                	push   $0x0
  pushl $206
  10255e:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102563:	e9 ba f7 ff ff       	jmp    101d22 <__alltraps>

00102568 <vector207>:
.globl vector207
vector207:
  pushl $0
  102568:	6a 00                	push   $0x0
  pushl $207
  10256a:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10256f:	e9 ae f7 ff ff       	jmp    101d22 <__alltraps>

00102574 <vector208>:
.globl vector208
vector208:
  pushl $0
  102574:	6a 00                	push   $0x0
  pushl $208
  102576:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10257b:	e9 a2 f7 ff ff       	jmp    101d22 <__alltraps>

00102580 <vector209>:
.globl vector209
vector209:
  pushl $0
  102580:	6a 00                	push   $0x0
  pushl $209
  102582:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102587:	e9 96 f7 ff ff       	jmp    101d22 <__alltraps>

0010258c <vector210>:
.globl vector210
vector210:
  pushl $0
  10258c:	6a 00                	push   $0x0
  pushl $210
  10258e:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102593:	e9 8a f7 ff ff       	jmp    101d22 <__alltraps>

00102598 <vector211>:
.globl vector211
vector211:
  pushl $0
  102598:	6a 00                	push   $0x0
  pushl $211
  10259a:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10259f:	e9 7e f7 ff ff       	jmp    101d22 <__alltraps>

001025a4 <vector212>:
.globl vector212
vector212:
  pushl $0
  1025a4:	6a 00                	push   $0x0
  pushl $212
  1025a6:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1025ab:	e9 72 f7 ff ff       	jmp    101d22 <__alltraps>

001025b0 <vector213>:
.globl vector213
vector213:
  pushl $0
  1025b0:	6a 00                	push   $0x0
  pushl $213
  1025b2:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1025b7:	e9 66 f7 ff ff       	jmp    101d22 <__alltraps>

001025bc <vector214>:
.globl vector214
vector214:
  pushl $0
  1025bc:	6a 00                	push   $0x0
  pushl $214
  1025be:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1025c3:	e9 5a f7 ff ff       	jmp    101d22 <__alltraps>

001025c8 <vector215>:
.globl vector215
vector215:
  pushl $0
  1025c8:	6a 00                	push   $0x0
  pushl $215
  1025ca:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1025cf:	e9 4e f7 ff ff       	jmp    101d22 <__alltraps>

001025d4 <vector216>:
.globl vector216
vector216:
  pushl $0
  1025d4:	6a 00                	push   $0x0
  pushl $216
  1025d6:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1025db:	e9 42 f7 ff ff       	jmp    101d22 <__alltraps>

001025e0 <vector217>:
.globl vector217
vector217:
  pushl $0
  1025e0:	6a 00                	push   $0x0
  pushl $217
  1025e2:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1025e7:	e9 36 f7 ff ff       	jmp    101d22 <__alltraps>

001025ec <vector218>:
.globl vector218
vector218:
  pushl $0
  1025ec:	6a 00                	push   $0x0
  pushl $218
  1025ee:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1025f3:	e9 2a f7 ff ff       	jmp    101d22 <__alltraps>

001025f8 <vector219>:
.globl vector219
vector219:
  pushl $0
  1025f8:	6a 00                	push   $0x0
  pushl $219
  1025fa:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1025ff:	e9 1e f7 ff ff       	jmp    101d22 <__alltraps>

00102604 <vector220>:
.globl vector220
vector220:
  pushl $0
  102604:	6a 00                	push   $0x0
  pushl $220
  102606:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10260b:	e9 12 f7 ff ff       	jmp    101d22 <__alltraps>

00102610 <vector221>:
.globl vector221
vector221:
  pushl $0
  102610:	6a 00                	push   $0x0
  pushl $221
  102612:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102617:	e9 06 f7 ff ff       	jmp    101d22 <__alltraps>

0010261c <vector222>:
.globl vector222
vector222:
  pushl $0
  10261c:	6a 00                	push   $0x0
  pushl $222
  10261e:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102623:	e9 fa f6 ff ff       	jmp    101d22 <__alltraps>

00102628 <vector223>:
.globl vector223
vector223:
  pushl $0
  102628:	6a 00                	push   $0x0
  pushl $223
  10262a:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  10262f:	e9 ee f6 ff ff       	jmp    101d22 <__alltraps>

00102634 <vector224>:
.globl vector224
vector224:
  pushl $0
  102634:	6a 00                	push   $0x0
  pushl $224
  102636:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10263b:	e9 e2 f6 ff ff       	jmp    101d22 <__alltraps>

00102640 <vector225>:
.globl vector225
vector225:
  pushl $0
  102640:	6a 00                	push   $0x0
  pushl $225
  102642:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102647:	e9 d6 f6 ff ff       	jmp    101d22 <__alltraps>

0010264c <vector226>:
.globl vector226
vector226:
  pushl $0
  10264c:	6a 00                	push   $0x0
  pushl $226
  10264e:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102653:	e9 ca f6 ff ff       	jmp    101d22 <__alltraps>

00102658 <vector227>:
.globl vector227
vector227:
  pushl $0
  102658:	6a 00                	push   $0x0
  pushl $227
  10265a:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  10265f:	e9 be f6 ff ff       	jmp    101d22 <__alltraps>

00102664 <vector228>:
.globl vector228
vector228:
  pushl $0
  102664:	6a 00                	push   $0x0
  pushl $228
  102666:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10266b:	e9 b2 f6 ff ff       	jmp    101d22 <__alltraps>

00102670 <vector229>:
.globl vector229
vector229:
  pushl $0
  102670:	6a 00                	push   $0x0
  pushl $229
  102672:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102677:	e9 a6 f6 ff ff       	jmp    101d22 <__alltraps>

0010267c <vector230>:
.globl vector230
vector230:
  pushl $0
  10267c:	6a 00                	push   $0x0
  pushl $230
  10267e:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102683:	e9 9a f6 ff ff       	jmp    101d22 <__alltraps>

00102688 <vector231>:
.globl vector231
vector231:
  pushl $0
  102688:	6a 00                	push   $0x0
  pushl $231
  10268a:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10268f:	e9 8e f6 ff ff       	jmp    101d22 <__alltraps>

00102694 <vector232>:
.globl vector232
vector232:
  pushl $0
  102694:	6a 00                	push   $0x0
  pushl $232
  102696:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  10269b:	e9 82 f6 ff ff       	jmp    101d22 <__alltraps>

001026a0 <vector233>:
.globl vector233
vector233:
  pushl $0
  1026a0:	6a 00                	push   $0x0
  pushl $233
  1026a2:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1026a7:	e9 76 f6 ff ff       	jmp    101d22 <__alltraps>

001026ac <vector234>:
.globl vector234
vector234:
  pushl $0
  1026ac:	6a 00                	push   $0x0
  pushl $234
  1026ae:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1026b3:	e9 6a f6 ff ff       	jmp    101d22 <__alltraps>

001026b8 <vector235>:
.globl vector235
vector235:
  pushl $0
  1026b8:	6a 00                	push   $0x0
  pushl $235
  1026ba:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1026bf:	e9 5e f6 ff ff       	jmp    101d22 <__alltraps>

001026c4 <vector236>:
.globl vector236
vector236:
  pushl $0
  1026c4:	6a 00                	push   $0x0
  pushl $236
  1026c6:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1026cb:	e9 52 f6 ff ff       	jmp    101d22 <__alltraps>

001026d0 <vector237>:
.globl vector237
vector237:
  pushl $0
  1026d0:	6a 00                	push   $0x0
  pushl $237
  1026d2:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1026d7:	e9 46 f6 ff ff       	jmp    101d22 <__alltraps>

001026dc <vector238>:
.globl vector238
vector238:
  pushl $0
  1026dc:	6a 00                	push   $0x0
  pushl $238
  1026de:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1026e3:	e9 3a f6 ff ff       	jmp    101d22 <__alltraps>

001026e8 <vector239>:
.globl vector239
vector239:
  pushl $0
  1026e8:	6a 00                	push   $0x0
  pushl $239
  1026ea:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1026ef:	e9 2e f6 ff ff       	jmp    101d22 <__alltraps>

001026f4 <vector240>:
.globl vector240
vector240:
  pushl $0
  1026f4:	6a 00                	push   $0x0
  pushl $240
  1026f6:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1026fb:	e9 22 f6 ff ff       	jmp    101d22 <__alltraps>

00102700 <vector241>:
.globl vector241
vector241:
  pushl $0
  102700:	6a 00                	push   $0x0
  pushl $241
  102702:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102707:	e9 16 f6 ff ff       	jmp    101d22 <__alltraps>

0010270c <vector242>:
.globl vector242
vector242:
  pushl $0
  10270c:	6a 00                	push   $0x0
  pushl $242
  10270e:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102713:	e9 0a f6 ff ff       	jmp    101d22 <__alltraps>

00102718 <vector243>:
.globl vector243
vector243:
  pushl $0
  102718:	6a 00                	push   $0x0
  pushl $243
  10271a:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10271f:	e9 fe f5 ff ff       	jmp    101d22 <__alltraps>

00102724 <vector244>:
.globl vector244
vector244:
  pushl $0
  102724:	6a 00                	push   $0x0
  pushl $244
  102726:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10272b:	e9 f2 f5 ff ff       	jmp    101d22 <__alltraps>

00102730 <vector245>:
.globl vector245
vector245:
  pushl $0
  102730:	6a 00                	push   $0x0
  pushl $245
  102732:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102737:	e9 e6 f5 ff ff       	jmp    101d22 <__alltraps>

0010273c <vector246>:
.globl vector246
vector246:
  pushl $0
  10273c:	6a 00                	push   $0x0
  pushl $246
  10273e:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102743:	e9 da f5 ff ff       	jmp    101d22 <__alltraps>

00102748 <vector247>:
.globl vector247
vector247:
  pushl $0
  102748:	6a 00                	push   $0x0
  pushl $247
  10274a:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  10274f:	e9 ce f5 ff ff       	jmp    101d22 <__alltraps>

00102754 <vector248>:
.globl vector248
vector248:
  pushl $0
  102754:	6a 00                	push   $0x0
  pushl $248
  102756:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10275b:	e9 c2 f5 ff ff       	jmp    101d22 <__alltraps>

00102760 <vector249>:
.globl vector249
vector249:
  pushl $0
  102760:	6a 00                	push   $0x0
  pushl $249
  102762:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102767:	e9 b6 f5 ff ff       	jmp    101d22 <__alltraps>

0010276c <vector250>:
.globl vector250
vector250:
  pushl $0
  10276c:	6a 00                	push   $0x0
  pushl $250
  10276e:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102773:	e9 aa f5 ff ff       	jmp    101d22 <__alltraps>

00102778 <vector251>:
.globl vector251
vector251:
  pushl $0
  102778:	6a 00                	push   $0x0
  pushl $251
  10277a:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  10277f:	e9 9e f5 ff ff       	jmp    101d22 <__alltraps>

00102784 <vector252>:
.globl vector252
vector252:
  pushl $0
  102784:	6a 00                	push   $0x0
  pushl $252
  102786:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  10278b:	e9 92 f5 ff ff       	jmp    101d22 <__alltraps>

00102790 <vector253>:
.globl vector253
vector253:
  pushl $0
  102790:	6a 00                	push   $0x0
  pushl $253
  102792:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102797:	e9 86 f5 ff ff       	jmp    101d22 <__alltraps>

0010279c <vector254>:
.globl vector254
vector254:
  pushl $0
  10279c:	6a 00                	push   $0x0
  pushl $254
  10279e:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1027a3:	e9 7a f5 ff ff       	jmp    101d22 <__alltraps>

001027a8 <vector255>:
.globl vector255
vector255:
  pushl $0
  1027a8:	6a 00                	push   $0x0
  pushl $255
  1027aa:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1027af:	e9 6e f5 ff ff       	jmp    101d22 <__alltraps>

001027b4 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  1027b4:	55                   	push   %ebp
  1027b5:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  1027b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1027ba:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  1027bd:	b8 23 00 00 00       	mov    $0x23,%eax
  1027c2:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  1027c4:	b8 23 00 00 00       	mov    $0x23,%eax
  1027c9:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  1027cb:	b8 10 00 00 00       	mov    $0x10,%eax
  1027d0:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  1027d2:	b8 10 00 00 00       	mov    $0x10,%eax
  1027d7:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  1027d9:	b8 10 00 00 00       	mov    $0x10,%eax
  1027de:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  1027e0:	ea e7 27 10 00 08 00 	ljmp   $0x8,$0x1027e7
}
  1027e7:	5d                   	pop    %ebp
  1027e8:	c3                   	ret    

001027e9 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  1027e9:	55                   	push   %ebp
  1027ea:	89 e5                	mov    %esp,%ebp
  1027ec:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  1027ef:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  1027f4:	05 00 04 00 00       	add    $0x400,%eax
  1027f9:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  1027fe:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  102805:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102807:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  10280e:	68 00 
  102810:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102815:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  10281b:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102820:	c1 e8 10             	shr    $0x10,%eax
  102823:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  102828:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  10282f:	83 e0 f0             	and    $0xfffffff0,%eax
  102832:	83 c8 09             	or     $0x9,%eax
  102835:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10283a:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102841:	83 c8 10             	or     $0x10,%eax
  102844:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102849:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102850:	83 e0 9f             	and    $0xffffff9f,%eax
  102853:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102858:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  10285f:	83 c8 80             	or     $0xffffff80,%eax
  102862:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102867:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  10286e:	83 e0 f0             	and    $0xfffffff0,%eax
  102871:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102876:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  10287d:	83 e0 ef             	and    $0xffffffef,%eax
  102880:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102885:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  10288c:	83 e0 df             	and    $0xffffffdf,%eax
  10288f:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102894:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  10289b:	83 c8 40             	or     $0x40,%eax
  10289e:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028a3:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028aa:	83 e0 7f             	and    $0x7f,%eax
  1028ad:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028b2:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1028b7:	c1 e8 18             	shr    $0x18,%eax
  1028ba:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  1028bf:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1028c6:	83 e0 ef             	and    $0xffffffef,%eax
  1028c9:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  1028ce:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  1028d5:	e8 da fe ff ff       	call   1027b4 <lgdt>
  1028da:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  1028e0:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  1028e4:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  1028e7:	c9                   	leave  
  1028e8:	c3                   	ret    

001028e9 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  1028e9:	55                   	push   %ebp
  1028ea:	89 e5                	mov    %esp,%ebp
    gdt_init();
  1028ec:	e8 f8 fe ff ff       	call   1027e9 <gdt_init>
}
  1028f1:	5d                   	pop    %ebp
  1028f2:	c3                   	ret    

001028f3 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1028f3:	55                   	push   %ebp
  1028f4:	89 e5                	mov    %esp,%ebp
  1028f6:	83 ec 58             	sub    $0x58,%esp
  1028f9:	8b 45 10             	mov    0x10(%ebp),%eax
  1028fc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1028ff:	8b 45 14             	mov    0x14(%ebp),%eax
  102902:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102905:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102908:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10290b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10290e:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102911:	8b 45 18             	mov    0x18(%ebp),%eax
  102914:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102917:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10291a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10291d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102920:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102923:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102926:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102929:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10292d:	74 1c                	je     10294b <printnum+0x58>
  10292f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102932:	ba 00 00 00 00       	mov    $0x0,%edx
  102937:	f7 75 e4             	divl   -0x1c(%ebp)
  10293a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10293d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102940:	ba 00 00 00 00       	mov    $0x0,%edx
  102945:	f7 75 e4             	divl   -0x1c(%ebp)
  102948:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10294b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10294e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102951:	f7 75 e4             	divl   -0x1c(%ebp)
  102954:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102957:	89 55 dc             	mov    %edx,-0x24(%ebp)
  10295a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10295d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102960:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102963:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102966:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102969:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  10296c:	8b 45 18             	mov    0x18(%ebp),%eax
  10296f:	ba 00 00 00 00       	mov    $0x0,%edx
  102974:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102977:	77 56                	ja     1029cf <printnum+0xdc>
  102979:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10297c:	72 05                	jb     102983 <printnum+0x90>
  10297e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102981:	77 4c                	ja     1029cf <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  102983:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102986:	8d 50 ff             	lea    -0x1(%eax),%edx
  102989:	8b 45 20             	mov    0x20(%ebp),%eax
  10298c:	89 44 24 18          	mov    %eax,0x18(%esp)
  102990:	89 54 24 14          	mov    %edx,0x14(%esp)
  102994:	8b 45 18             	mov    0x18(%ebp),%eax
  102997:	89 44 24 10          	mov    %eax,0x10(%esp)
  10299b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10299e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1029a1:	89 44 24 08          	mov    %eax,0x8(%esp)
  1029a5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1029a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1029ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  1029b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1029b3:	89 04 24             	mov    %eax,(%esp)
  1029b6:	e8 38 ff ff ff       	call   1028f3 <printnum>
  1029bb:	eb 1c                	jmp    1029d9 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1029bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1029c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1029c4:	8b 45 20             	mov    0x20(%ebp),%eax
  1029c7:	89 04 24             	mov    %eax,(%esp)
  1029ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1029cd:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  1029cf:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  1029d3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1029d7:	7f e4                	jg     1029bd <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1029d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1029dc:	05 f0 3b 10 00       	add    $0x103bf0,%eax
  1029e1:	0f b6 00             	movzbl (%eax),%eax
  1029e4:	0f be c0             	movsbl %al,%eax
  1029e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  1029ea:	89 54 24 04          	mov    %edx,0x4(%esp)
  1029ee:	89 04 24             	mov    %eax,(%esp)
  1029f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1029f4:	ff d0                	call   *%eax
}
  1029f6:	c9                   	leave  
  1029f7:	c3                   	ret    

001029f8 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1029f8:	55                   	push   %ebp
  1029f9:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1029fb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1029ff:	7e 14                	jle    102a15 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102a01:	8b 45 08             	mov    0x8(%ebp),%eax
  102a04:	8b 00                	mov    (%eax),%eax
  102a06:	8d 48 08             	lea    0x8(%eax),%ecx
  102a09:	8b 55 08             	mov    0x8(%ebp),%edx
  102a0c:	89 0a                	mov    %ecx,(%edx)
  102a0e:	8b 50 04             	mov    0x4(%eax),%edx
  102a11:	8b 00                	mov    (%eax),%eax
  102a13:	eb 30                	jmp    102a45 <getuint+0x4d>
    }
    else if (lflag) {
  102a15:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102a19:	74 16                	je     102a31 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  102a1e:	8b 00                	mov    (%eax),%eax
  102a20:	8d 48 04             	lea    0x4(%eax),%ecx
  102a23:	8b 55 08             	mov    0x8(%ebp),%edx
  102a26:	89 0a                	mov    %ecx,(%edx)
  102a28:	8b 00                	mov    (%eax),%eax
  102a2a:	ba 00 00 00 00       	mov    $0x0,%edx
  102a2f:	eb 14                	jmp    102a45 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102a31:	8b 45 08             	mov    0x8(%ebp),%eax
  102a34:	8b 00                	mov    (%eax),%eax
  102a36:	8d 48 04             	lea    0x4(%eax),%ecx
  102a39:	8b 55 08             	mov    0x8(%ebp),%edx
  102a3c:	89 0a                	mov    %ecx,(%edx)
  102a3e:	8b 00                	mov    (%eax),%eax
  102a40:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102a45:	5d                   	pop    %ebp
  102a46:	c3                   	ret    

00102a47 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102a47:	55                   	push   %ebp
  102a48:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102a4a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102a4e:	7e 14                	jle    102a64 <getint+0x1d>
        return va_arg(*ap, long long);
  102a50:	8b 45 08             	mov    0x8(%ebp),%eax
  102a53:	8b 00                	mov    (%eax),%eax
  102a55:	8d 48 08             	lea    0x8(%eax),%ecx
  102a58:	8b 55 08             	mov    0x8(%ebp),%edx
  102a5b:	89 0a                	mov    %ecx,(%edx)
  102a5d:	8b 50 04             	mov    0x4(%eax),%edx
  102a60:	8b 00                	mov    (%eax),%eax
  102a62:	eb 28                	jmp    102a8c <getint+0x45>
    }
    else if (lflag) {
  102a64:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102a68:	74 12                	je     102a7c <getint+0x35>
        return va_arg(*ap, long);
  102a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  102a6d:	8b 00                	mov    (%eax),%eax
  102a6f:	8d 48 04             	lea    0x4(%eax),%ecx
  102a72:	8b 55 08             	mov    0x8(%ebp),%edx
  102a75:	89 0a                	mov    %ecx,(%edx)
  102a77:	8b 00                	mov    (%eax),%eax
  102a79:	99                   	cltd   
  102a7a:	eb 10                	jmp    102a8c <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  102a7f:	8b 00                	mov    (%eax),%eax
  102a81:	8d 48 04             	lea    0x4(%eax),%ecx
  102a84:	8b 55 08             	mov    0x8(%ebp),%edx
  102a87:	89 0a                	mov    %ecx,(%edx)
  102a89:	8b 00                	mov    (%eax),%eax
  102a8b:	99                   	cltd   
    }
}
  102a8c:	5d                   	pop    %ebp
  102a8d:	c3                   	ret    

00102a8e <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102a8e:	55                   	push   %ebp
  102a8f:	89 e5                	mov    %esp,%ebp
  102a91:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102a94:	8d 45 14             	lea    0x14(%ebp),%eax
  102a97:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a9d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102aa1:	8b 45 10             	mov    0x10(%ebp),%eax
  102aa4:	89 44 24 08          	mov    %eax,0x8(%esp)
  102aa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  102aab:	89 44 24 04          	mov    %eax,0x4(%esp)
  102aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  102ab2:	89 04 24             	mov    %eax,(%esp)
  102ab5:	e8 02 00 00 00       	call   102abc <vprintfmt>
    va_end(ap);
}
  102aba:	c9                   	leave  
  102abb:	c3                   	ret    

00102abc <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102abc:	55                   	push   %ebp
  102abd:	89 e5                	mov    %esp,%ebp
  102abf:	56                   	push   %esi
  102ac0:	53                   	push   %ebx
  102ac1:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102ac4:	eb 18                	jmp    102ade <vprintfmt+0x22>
            if (ch == '\0') {
  102ac6:	85 db                	test   %ebx,%ebx
  102ac8:	75 05                	jne    102acf <vprintfmt+0x13>
                return;
  102aca:	e9 d1 03 00 00       	jmp    102ea0 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  102acf:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ad2:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ad6:	89 1c 24             	mov    %ebx,(%esp)
  102ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  102adc:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102ade:	8b 45 10             	mov    0x10(%ebp),%eax
  102ae1:	8d 50 01             	lea    0x1(%eax),%edx
  102ae4:	89 55 10             	mov    %edx,0x10(%ebp)
  102ae7:	0f b6 00             	movzbl (%eax),%eax
  102aea:	0f b6 d8             	movzbl %al,%ebx
  102aed:	83 fb 25             	cmp    $0x25,%ebx
  102af0:	75 d4                	jne    102ac6 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  102af2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102af6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102afd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b00:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102b03:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102b0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b0d:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102b10:	8b 45 10             	mov    0x10(%ebp),%eax
  102b13:	8d 50 01             	lea    0x1(%eax),%edx
  102b16:	89 55 10             	mov    %edx,0x10(%ebp)
  102b19:	0f b6 00             	movzbl (%eax),%eax
  102b1c:	0f b6 d8             	movzbl %al,%ebx
  102b1f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102b22:	83 f8 55             	cmp    $0x55,%eax
  102b25:	0f 87 44 03 00 00    	ja     102e6f <vprintfmt+0x3b3>
  102b2b:	8b 04 85 14 3c 10 00 	mov    0x103c14(,%eax,4),%eax
  102b32:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102b34:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102b38:	eb d6                	jmp    102b10 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102b3a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102b3e:	eb d0                	jmp    102b10 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102b40:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102b47:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102b4a:	89 d0                	mov    %edx,%eax
  102b4c:	c1 e0 02             	shl    $0x2,%eax
  102b4f:	01 d0                	add    %edx,%eax
  102b51:	01 c0                	add    %eax,%eax
  102b53:	01 d8                	add    %ebx,%eax
  102b55:	83 e8 30             	sub    $0x30,%eax
  102b58:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102b5b:	8b 45 10             	mov    0x10(%ebp),%eax
  102b5e:	0f b6 00             	movzbl (%eax),%eax
  102b61:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102b64:	83 fb 2f             	cmp    $0x2f,%ebx
  102b67:	7e 0b                	jle    102b74 <vprintfmt+0xb8>
  102b69:	83 fb 39             	cmp    $0x39,%ebx
  102b6c:	7f 06                	jg     102b74 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102b6e:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  102b72:	eb d3                	jmp    102b47 <vprintfmt+0x8b>
            goto process_precision;
  102b74:	eb 33                	jmp    102ba9 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  102b76:	8b 45 14             	mov    0x14(%ebp),%eax
  102b79:	8d 50 04             	lea    0x4(%eax),%edx
  102b7c:	89 55 14             	mov    %edx,0x14(%ebp)
  102b7f:	8b 00                	mov    (%eax),%eax
  102b81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102b84:	eb 23                	jmp    102ba9 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  102b86:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102b8a:	79 0c                	jns    102b98 <vprintfmt+0xdc>
                width = 0;
  102b8c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102b93:	e9 78 ff ff ff       	jmp    102b10 <vprintfmt+0x54>
  102b98:	e9 73 ff ff ff       	jmp    102b10 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  102b9d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102ba4:	e9 67 ff ff ff       	jmp    102b10 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  102ba9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102bad:	79 12                	jns    102bc1 <vprintfmt+0x105>
                width = precision, precision = -1;
  102baf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102bb2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102bb5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102bbc:	e9 4f ff ff ff       	jmp    102b10 <vprintfmt+0x54>
  102bc1:	e9 4a ff ff ff       	jmp    102b10 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102bc6:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  102bca:	e9 41 ff ff ff       	jmp    102b10 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102bcf:	8b 45 14             	mov    0x14(%ebp),%eax
  102bd2:	8d 50 04             	lea    0x4(%eax),%edx
  102bd5:	89 55 14             	mov    %edx,0x14(%ebp)
  102bd8:	8b 00                	mov    (%eax),%eax
  102bda:	8b 55 0c             	mov    0xc(%ebp),%edx
  102bdd:	89 54 24 04          	mov    %edx,0x4(%esp)
  102be1:	89 04 24             	mov    %eax,(%esp)
  102be4:	8b 45 08             	mov    0x8(%ebp),%eax
  102be7:	ff d0                	call   *%eax
            break;
  102be9:	e9 ac 02 00 00       	jmp    102e9a <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102bee:	8b 45 14             	mov    0x14(%ebp),%eax
  102bf1:	8d 50 04             	lea    0x4(%eax),%edx
  102bf4:	89 55 14             	mov    %edx,0x14(%ebp)
  102bf7:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102bf9:	85 db                	test   %ebx,%ebx
  102bfb:	79 02                	jns    102bff <vprintfmt+0x143>
                err = -err;
  102bfd:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102bff:	83 fb 06             	cmp    $0x6,%ebx
  102c02:	7f 0b                	jg     102c0f <vprintfmt+0x153>
  102c04:	8b 34 9d d4 3b 10 00 	mov    0x103bd4(,%ebx,4),%esi
  102c0b:	85 f6                	test   %esi,%esi
  102c0d:	75 23                	jne    102c32 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  102c0f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102c13:	c7 44 24 08 01 3c 10 	movl   $0x103c01,0x8(%esp)
  102c1a:	00 
  102c1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c22:	8b 45 08             	mov    0x8(%ebp),%eax
  102c25:	89 04 24             	mov    %eax,(%esp)
  102c28:	e8 61 fe ff ff       	call   102a8e <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102c2d:	e9 68 02 00 00       	jmp    102e9a <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  102c32:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102c36:	c7 44 24 08 0a 3c 10 	movl   $0x103c0a,0x8(%esp)
  102c3d:	00 
  102c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c41:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c45:	8b 45 08             	mov    0x8(%ebp),%eax
  102c48:	89 04 24             	mov    %eax,(%esp)
  102c4b:	e8 3e fe ff ff       	call   102a8e <printfmt>
            }
            break;
  102c50:	e9 45 02 00 00       	jmp    102e9a <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102c55:	8b 45 14             	mov    0x14(%ebp),%eax
  102c58:	8d 50 04             	lea    0x4(%eax),%edx
  102c5b:	89 55 14             	mov    %edx,0x14(%ebp)
  102c5e:	8b 30                	mov    (%eax),%esi
  102c60:	85 f6                	test   %esi,%esi
  102c62:	75 05                	jne    102c69 <vprintfmt+0x1ad>
                p = "(null)";
  102c64:	be 0d 3c 10 00       	mov    $0x103c0d,%esi
            }
            if (width > 0 && padc != '-') {
  102c69:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102c6d:	7e 3e                	jle    102cad <vprintfmt+0x1f1>
  102c6f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102c73:	74 38                	je     102cad <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102c75:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  102c78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c7f:	89 34 24             	mov    %esi,(%esp)
  102c82:	e8 15 03 00 00       	call   102f9c <strnlen>
  102c87:	29 c3                	sub    %eax,%ebx
  102c89:	89 d8                	mov    %ebx,%eax
  102c8b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102c8e:	eb 17                	jmp    102ca7 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  102c90:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102c94:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c97:	89 54 24 04          	mov    %edx,0x4(%esp)
  102c9b:	89 04 24             	mov    %eax,(%esp)
  102c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  102ca1:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  102ca3:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102ca7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102cab:	7f e3                	jg     102c90 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102cad:	eb 38                	jmp    102ce7 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  102caf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102cb3:	74 1f                	je     102cd4 <vprintfmt+0x218>
  102cb5:	83 fb 1f             	cmp    $0x1f,%ebx
  102cb8:	7e 05                	jle    102cbf <vprintfmt+0x203>
  102cba:	83 fb 7e             	cmp    $0x7e,%ebx
  102cbd:	7e 15                	jle    102cd4 <vprintfmt+0x218>
                    putch('?', putdat);
  102cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cc2:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cc6:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  102cd0:	ff d0                	call   *%eax
  102cd2:	eb 0f                	jmp    102ce3 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  102cd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cd7:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cdb:	89 1c 24             	mov    %ebx,(%esp)
  102cde:	8b 45 08             	mov    0x8(%ebp),%eax
  102ce1:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102ce3:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102ce7:	89 f0                	mov    %esi,%eax
  102ce9:	8d 70 01             	lea    0x1(%eax),%esi
  102cec:	0f b6 00             	movzbl (%eax),%eax
  102cef:	0f be d8             	movsbl %al,%ebx
  102cf2:	85 db                	test   %ebx,%ebx
  102cf4:	74 10                	je     102d06 <vprintfmt+0x24a>
  102cf6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102cfa:	78 b3                	js     102caf <vprintfmt+0x1f3>
  102cfc:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  102d00:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d04:	79 a9                	jns    102caf <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102d06:	eb 17                	jmp    102d1f <vprintfmt+0x263>
                putch(' ', putdat);
  102d08:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d0f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102d16:	8b 45 08             	mov    0x8(%ebp),%eax
  102d19:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102d1b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102d1f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d23:	7f e3                	jg     102d08 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  102d25:	e9 70 01 00 00       	jmp    102e9a <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102d2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d31:	8d 45 14             	lea    0x14(%ebp),%eax
  102d34:	89 04 24             	mov    %eax,(%esp)
  102d37:	e8 0b fd ff ff       	call   102a47 <getint>
  102d3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d3f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102d42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d48:	85 d2                	test   %edx,%edx
  102d4a:	79 26                	jns    102d72 <vprintfmt+0x2b6>
                putch('-', putdat);
  102d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d53:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  102d5d:	ff d0                	call   *%eax
                num = -(long long)num;
  102d5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d65:	f7 d8                	neg    %eax
  102d67:	83 d2 00             	adc    $0x0,%edx
  102d6a:	f7 da                	neg    %edx
  102d6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d6f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102d72:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102d79:	e9 a8 00 00 00       	jmp    102e26 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102d7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d81:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d85:	8d 45 14             	lea    0x14(%ebp),%eax
  102d88:	89 04 24             	mov    %eax,(%esp)
  102d8b:	e8 68 fc ff ff       	call   1029f8 <getuint>
  102d90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d93:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102d96:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102d9d:	e9 84 00 00 00       	jmp    102e26 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102da2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102da5:	89 44 24 04          	mov    %eax,0x4(%esp)
  102da9:	8d 45 14             	lea    0x14(%ebp),%eax
  102dac:	89 04 24             	mov    %eax,(%esp)
  102daf:	e8 44 fc ff ff       	call   1029f8 <getuint>
  102db4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102db7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102dba:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102dc1:	eb 63                	jmp    102e26 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  102dc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dc6:	89 44 24 04          	mov    %eax,0x4(%esp)
  102dca:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  102dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  102dd4:	ff d0                	call   *%eax
            putch('x', putdat);
  102dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ddd:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  102de4:	8b 45 08             	mov    0x8(%ebp),%eax
  102de7:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102de9:	8b 45 14             	mov    0x14(%ebp),%eax
  102dec:	8d 50 04             	lea    0x4(%eax),%edx
  102def:	89 55 14             	mov    %edx,0x14(%ebp)
  102df2:	8b 00                	mov    (%eax),%eax
  102df4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102df7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102dfe:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102e05:	eb 1f                	jmp    102e26 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102e07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e0e:	8d 45 14             	lea    0x14(%ebp),%eax
  102e11:	89 04 24             	mov    %eax,(%esp)
  102e14:	e8 df fb ff ff       	call   1029f8 <getuint>
  102e19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e1c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102e1f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102e26:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102e2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e2d:	89 54 24 18          	mov    %edx,0x18(%esp)
  102e31:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102e34:	89 54 24 14          	mov    %edx,0x14(%esp)
  102e38:	89 44 24 10          	mov    %eax,0x10(%esp)
  102e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102e42:	89 44 24 08          	mov    %eax,0x8(%esp)
  102e46:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e51:	8b 45 08             	mov    0x8(%ebp),%eax
  102e54:	89 04 24             	mov    %eax,(%esp)
  102e57:	e8 97 fa ff ff       	call   1028f3 <printnum>
            break;
  102e5c:	eb 3c                	jmp    102e9a <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  102e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e61:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e65:	89 1c 24             	mov    %ebx,(%esp)
  102e68:	8b 45 08             	mov    0x8(%ebp),%eax
  102e6b:	ff d0                	call   *%eax
            break;
  102e6d:	eb 2b                	jmp    102e9a <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  102e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e72:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e76:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  102e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  102e80:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  102e82:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102e86:	eb 04                	jmp    102e8c <vprintfmt+0x3d0>
  102e88:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102e8c:	8b 45 10             	mov    0x10(%ebp),%eax
  102e8f:	83 e8 01             	sub    $0x1,%eax
  102e92:	0f b6 00             	movzbl (%eax),%eax
  102e95:	3c 25                	cmp    $0x25,%al
  102e97:	75 ef                	jne    102e88 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  102e99:	90                   	nop
        }
    }
  102e9a:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102e9b:	e9 3e fc ff ff       	jmp    102ade <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  102ea0:	83 c4 40             	add    $0x40,%esp
  102ea3:	5b                   	pop    %ebx
  102ea4:	5e                   	pop    %esi
  102ea5:	5d                   	pop    %ebp
  102ea6:	c3                   	ret    

00102ea7 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  102ea7:	55                   	push   %ebp
  102ea8:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  102eaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ead:	8b 40 08             	mov    0x8(%eax),%eax
  102eb0:	8d 50 01             	lea    0x1(%eax),%edx
  102eb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  102eb6:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  102eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ebc:	8b 10                	mov    (%eax),%edx
  102ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ec1:	8b 40 04             	mov    0x4(%eax),%eax
  102ec4:	39 c2                	cmp    %eax,%edx
  102ec6:	73 12                	jae    102eda <sprintputch+0x33>
        *b->buf ++ = ch;
  102ec8:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ecb:	8b 00                	mov    (%eax),%eax
  102ecd:	8d 48 01             	lea    0x1(%eax),%ecx
  102ed0:	8b 55 0c             	mov    0xc(%ebp),%edx
  102ed3:	89 0a                	mov    %ecx,(%edx)
  102ed5:	8b 55 08             	mov    0x8(%ebp),%edx
  102ed8:	88 10                	mov    %dl,(%eax)
    }
}
  102eda:	5d                   	pop    %ebp
  102edb:	c3                   	ret    

00102edc <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  102edc:	55                   	push   %ebp
  102edd:	89 e5                	mov    %esp,%ebp
  102edf:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  102ee2:	8d 45 14             	lea    0x14(%ebp),%eax
  102ee5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  102ee8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102eeb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102eef:	8b 45 10             	mov    0x10(%ebp),%eax
  102ef2:	89 44 24 08          	mov    %eax,0x8(%esp)
  102ef6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ef9:	89 44 24 04          	mov    %eax,0x4(%esp)
  102efd:	8b 45 08             	mov    0x8(%ebp),%eax
  102f00:	89 04 24             	mov    %eax,(%esp)
  102f03:	e8 08 00 00 00       	call   102f10 <vsnprintf>
  102f08:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  102f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102f0e:	c9                   	leave  
  102f0f:	c3                   	ret    

00102f10 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  102f10:	55                   	push   %ebp
  102f11:	89 e5                	mov    %esp,%ebp
  102f13:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  102f16:	8b 45 08             	mov    0x8(%ebp),%eax
  102f19:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f1f:	8d 50 ff             	lea    -0x1(%eax),%edx
  102f22:	8b 45 08             	mov    0x8(%ebp),%eax
  102f25:	01 d0                	add    %edx,%eax
  102f27:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  102f31:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102f35:	74 0a                	je     102f41 <vsnprintf+0x31>
  102f37:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102f3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f3d:	39 c2                	cmp    %eax,%edx
  102f3f:	76 07                	jbe    102f48 <vsnprintf+0x38>
        return -E_INVAL;
  102f41:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  102f46:	eb 2a                	jmp    102f72 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  102f48:	8b 45 14             	mov    0x14(%ebp),%eax
  102f4b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102f4f:	8b 45 10             	mov    0x10(%ebp),%eax
  102f52:	89 44 24 08          	mov    %eax,0x8(%esp)
  102f56:	8d 45 ec             	lea    -0x14(%ebp),%eax
  102f59:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f5d:	c7 04 24 a7 2e 10 00 	movl   $0x102ea7,(%esp)
  102f64:	e8 53 fb ff ff       	call   102abc <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  102f69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f6c:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  102f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102f72:	c9                   	leave  
  102f73:	c3                   	ret    

00102f74 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102f74:	55                   	push   %ebp
  102f75:	89 e5                	mov    %esp,%ebp
  102f77:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102f7a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102f81:	eb 04                	jmp    102f87 <strlen+0x13>
        cnt ++;
  102f83:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  102f87:	8b 45 08             	mov    0x8(%ebp),%eax
  102f8a:	8d 50 01             	lea    0x1(%eax),%edx
  102f8d:	89 55 08             	mov    %edx,0x8(%ebp)
  102f90:	0f b6 00             	movzbl (%eax),%eax
  102f93:	84 c0                	test   %al,%al
  102f95:	75 ec                	jne    102f83 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  102f97:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102f9a:	c9                   	leave  
  102f9b:	c3                   	ret    

00102f9c <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102f9c:	55                   	push   %ebp
  102f9d:	89 e5                	mov    %esp,%ebp
  102f9f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102fa2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102fa9:	eb 04                	jmp    102faf <strnlen+0x13>
        cnt ++;
  102fab:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  102faf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102fb2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102fb5:	73 10                	jae    102fc7 <strnlen+0x2b>
  102fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  102fba:	8d 50 01             	lea    0x1(%eax),%edx
  102fbd:	89 55 08             	mov    %edx,0x8(%ebp)
  102fc0:	0f b6 00             	movzbl (%eax),%eax
  102fc3:	84 c0                	test   %al,%al
  102fc5:	75 e4                	jne    102fab <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  102fc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102fca:	c9                   	leave  
  102fcb:	c3                   	ret    

00102fcc <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102fcc:	55                   	push   %ebp
  102fcd:	89 e5                	mov    %esp,%ebp
  102fcf:	57                   	push   %edi
  102fd0:	56                   	push   %esi
  102fd1:	83 ec 20             	sub    $0x20,%esp
  102fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  102fd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102fda:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fdd:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102fe0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102fe6:	89 d1                	mov    %edx,%ecx
  102fe8:	89 c2                	mov    %eax,%edx
  102fea:	89 ce                	mov    %ecx,%esi
  102fec:	89 d7                	mov    %edx,%edi
  102fee:	ac                   	lods   %ds:(%esi),%al
  102fef:	aa                   	stos   %al,%es:(%edi)
  102ff0:	84 c0                	test   %al,%al
  102ff2:	75 fa                	jne    102fee <strcpy+0x22>
  102ff4:	89 fa                	mov    %edi,%edx
  102ff6:	89 f1                	mov    %esi,%ecx
  102ff8:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102ffb:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102ffe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  103001:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  103004:	83 c4 20             	add    $0x20,%esp
  103007:	5e                   	pop    %esi
  103008:	5f                   	pop    %edi
  103009:	5d                   	pop    %ebp
  10300a:	c3                   	ret    

0010300b <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  10300b:	55                   	push   %ebp
  10300c:	89 e5                	mov    %esp,%ebp
  10300e:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  103011:	8b 45 08             	mov    0x8(%ebp),%eax
  103014:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  103017:	eb 21                	jmp    10303a <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  103019:	8b 45 0c             	mov    0xc(%ebp),%eax
  10301c:	0f b6 10             	movzbl (%eax),%edx
  10301f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103022:	88 10                	mov    %dl,(%eax)
  103024:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103027:	0f b6 00             	movzbl (%eax),%eax
  10302a:	84 c0                	test   %al,%al
  10302c:	74 04                	je     103032 <strncpy+0x27>
            src ++;
  10302e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  103032:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  103036:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  10303a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10303e:	75 d9                	jne    103019 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  103040:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103043:	c9                   	leave  
  103044:	c3                   	ret    

00103045 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  103045:	55                   	push   %ebp
  103046:	89 e5                	mov    %esp,%ebp
  103048:	57                   	push   %edi
  103049:	56                   	push   %esi
  10304a:	83 ec 20             	sub    $0x20,%esp
  10304d:	8b 45 08             	mov    0x8(%ebp),%eax
  103050:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103053:	8b 45 0c             	mov    0xc(%ebp),%eax
  103056:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  103059:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10305c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10305f:	89 d1                	mov    %edx,%ecx
  103061:	89 c2                	mov    %eax,%edx
  103063:	89 ce                	mov    %ecx,%esi
  103065:	89 d7                	mov    %edx,%edi
  103067:	ac                   	lods   %ds:(%esi),%al
  103068:	ae                   	scas   %es:(%edi),%al
  103069:	75 08                	jne    103073 <strcmp+0x2e>
  10306b:	84 c0                	test   %al,%al
  10306d:	75 f8                	jne    103067 <strcmp+0x22>
  10306f:	31 c0                	xor    %eax,%eax
  103071:	eb 04                	jmp    103077 <strcmp+0x32>
  103073:	19 c0                	sbb    %eax,%eax
  103075:	0c 01                	or     $0x1,%al
  103077:	89 fa                	mov    %edi,%edx
  103079:	89 f1                	mov    %esi,%ecx
  10307b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10307e:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  103081:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  103084:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  103087:	83 c4 20             	add    $0x20,%esp
  10308a:	5e                   	pop    %esi
  10308b:	5f                   	pop    %edi
  10308c:	5d                   	pop    %ebp
  10308d:	c3                   	ret    

0010308e <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  10308e:	55                   	push   %ebp
  10308f:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  103091:	eb 0c                	jmp    10309f <strncmp+0x11>
        n --, s1 ++, s2 ++;
  103093:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103097:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10309b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  10309f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1030a3:	74 1a                	je     1030bf <strncmp+0x31>
  1030a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1030a8:	0f b6 00             	movzbl (%eax),%eax
  1030ab:	84 c0                	test   %al,%al
  1030ad:	74 10                	je     1030bf <strncmp+0x31>
  1030af:	8b 45 08             	mov    0x8(%ebp),%eax
  1030b2:	0f b6 10             	movzbl (%eax),%edx
  1030b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030b8:	0f b6 00             	movzbl (%eax),%eax
  1030bb:	38 c2                	cmp    %al,%dl
  1030bd:	74 d4                	je     103093 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  1030bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1030c3:	74 18                	je     1030dd <strncmp+0x4f>
  1030c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1030c8:	0f b6 00             	movzbl (%eax),%eax
  1030cb:	0f b6 d0             	movzbl %al,%edx
  1030ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030d1:	0f b6 00             	movzbl (%eax),%eax
  1030d4:	0f b6 c0             	movzbl %al,%eax
  1030d7:	29 c2                	sub    %eax,%edx
  1030d9:	89 d0                	mov    %edx,%eax
  1030db:	eb 05                	jmp    1030e2 <strncmp+0x54>
  1030dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1030e2:	5d                   	pop    %ebp
  1030e3:	c3                   	ret    

001030e4 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  1030e4:	55                   	push   %ebp
  1030e5:	89 e5                	mov    %esp,%ebp
  1030e7:	83 ec 04             	sub    $0x4,%esp
  1030ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030ed:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1030f0:	eb 14                	jmp    103106 <strchr+0x22>
        if (*s == c) {
  1030f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1030f5:	0f b6 00             	movzbl (%eax),%eax
  1030f8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  1030fb:	75 05                	jne    103102 <strchr+0x1e>
            return (char *)s;
  1030fd:	8b 45 08             	mov    0x8(%ebp),%eax
  103100:	eb 13                	jmp    103115 <strchr+0x31>
        }
        s ++;
  103102:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  103106:	8b 45 08             	mov    0x8(%ebp),%eax
  103109:	0f b6 00             	movzbl (%eax),%eax
  10310c:	84 c0                	test   %al,%al
  10310e:	75 e2                	jne    1030f2 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  103110:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103115:	c9                   	leave  
  103116:	c3                   	ret    

00103117 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  103117:	55                   	push   %ebp
  103118:	89 e5                	mov    %esp,%ebp
  10311a:	83 ec 04             	sub    $0x4,%esp
  10311d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103120:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103123:	eb 11                	jmp    103136 <strfind+0x1f>
        if (*s == c) {
  103125:	8b 45 08             	mov    0x8(%ebp),%eax
  103128:	0f b6 00             	movzbl (%eax),%eax
  10312b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  10312e:	75 02                	jne    103132 <strfind+0x1b>
            break;
  103130:	eb 0e                	jmp    103140 <strfind+0x29>
        }
        s ++;
  103132:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  103136:	8b 45 08             	mov    0x8(%ebp),%eax
  103139:	0f b6 00             	movzbl (%eax),%eax
  10313c:	84 c0                	test   %al,%al
  10313e:	75 e5                	jne    103125 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  103140:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103143:	c9                   	leave  
  103144:	c3                   	ret    

00103145 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  103145:	55                   	push   %ebp
  103146:	89 e5                	mov    %esp,%ebp
  103148:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  10314b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  103152:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  103159:	eb 04                	jmp    10315f <strtol+0x1a>
        s ++;
  10315b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  10315f:	8b 45 08             	mov    0x8(%ebp),%eax
  103162:	0f b6 00             	movzbl (%eax),%eax
  103165:	3c 20                	cmp    $0x20,%al
  103167:	74 f2                	je     10315b <strtol+0x16>
  103169:	8b 45 08             	mov    0x8(%ebp),%eax
  10316c:	0f b6 00             	movzbl (%eax),%eax
  10316f:	3c 09                	cmp    $0x9,%al
  103171:	74 e8                	je     10315b <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  103173:	8b 45 08             	mov    0x8(%ebp),%eax
  103176:	0f b6 00             	movzbl (%eax),%eax
  103179:	3c 2b                	cmp    $0x2b,%al
  10317b:	75 06                	jne    103183 <strtol+0x3e>
        s ++;
  10317d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103181:	eb 15                	jmp    103198 <strtol+0x53>
    }
    else if (*s == '-') {
  103183:	8b 45 08             	mov    0x8(%ebp),%eax
  103186:	0f b6 00             	movzbl (%eax),%eax
  103189:	3c 2d                	cmp    $0x2d,%al
  10318b:	75 0b                	jne    103198 <strtol+0x53>
        s ++, neg = 1;
  10318d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103191:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  103198:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10319c:	74 06                	je     1031a4 <strtol+0x5f>
  10319e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  1031a2:	75 24                	jne    1031c8 <strtol+0x83>
  1031a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1031a7:	0f b6 00             	movzbl (%eax),%eax
  1031aa:	3c 30                	cmp    $0x30,%al
  1031ac:	75 1a                	jne    1031c8 <strtol+0x83>
  1031ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1031b1:	83 c0 01             	add    $0x1,%eax
  1031b4:	0f b6 00             	movzbl (%eax),%eax
  1031b7:	3c 78                	cmp    $0x78,%al
  1031b9:	75 0d                	jne    1031c8 <strtol+0x83>
        s += 2, base = 16;
  1031bb:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  1031bf:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  1031c6:	eb 2a                	jmp    1031f2 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  1031c8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1031cc:	75 17                	jne    1031e5 <strtol+0xa0>
  1031ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1031d1:	0f b6 00             	movzbl (%eax),%eax
  1031d4:	3c 30                	cmp    $0x30,%al
  1031d6:	75 0d                	jne    1031e5 <strtol+0xa0>
        s ++, base = 8;
  1031d8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1031dc:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  1031e3:	eb 0d                	jmp    1031f2 <strtol+0xad>
    }
    else if (base == 0) {
  1031e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1031e9:	75 07                	jne    1031f2 <strtol+0xad>
        base = 10;
  1031eb:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  1031f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1031f5:	0f b6 00             	movzbl (%eax),%eax
  1031f8:	3c 2f                	cmp    $0x2f,%al
  1031fa:	7e 1b                	jle    103217 <strtol+0xd2>
  1031fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1031ff:	0f b6 00             	movzbl (%eax),%eax
  103202:	3c 39                	cmp    $0x39,%al
  103204:	7f 11                	jg     103217 <strtol+0xd2>
            dig = *s - '0';
  103206:	8b 45 08             	mov    0x8(%ebp),%eax
  103209:	0f b6 00             	movzbl (%eax),%eax
  10320c:	0f be c0             	movsbl %al,%eax
  10320f:	83 e8 30             	sub    $0x30,%eax
  103212:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103215:	eb 48                	jmp    10325f <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  103217:	8b 45 08             	mov    0x8(%ebp),%eax
  10321a:	0f b6 00             	movzbl (%eax),%eax
  10321d:	3c 60                	cmp    $0x60,%al
  10321f:	7e 1b                	jle    10323c <strtol+0xf7>
  103221:	8b 45 08             	mov    0x8(%ebp),%eax
  103224:	0f b6 00             	movzbl (%eax),%eax
  103227:	3c 7a                	cmp    $0x7a,%al
  103229:	7f 11                	jg     10323c <strtol+0xf7>
            dig = *s - 'a' + 10;
  10322b:	8b 45 08             	mov    0x8(%ebp),%eax
  10322e:	0f b6 00             	movzbl (%eax),%eax
  103231:	0f be c0             	movsbl %al,%eax
  103234:	83 e8 57             	sub    $0x57,%eax
  103237:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10323a:	eb 23                	jmp    10325f <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  10323c:	8b 45 08             	mov    0x8(%ebp),%eax
  10323f:	0f b6 00             	movzbl (%eax),%eax
  103242:	3c 40                	cmp    $0x40,%al
  103244:	7e 3d                	jle    103283 <strtol+0x13e>
  103246:	8b 45 08             	mov    0x8(%ebp),%eax
  103249:	0f b6 00             	movzbl (%eax),%eax
  10324c:	3c 5a                	cmp    $0x5a,%al
  10324e:	7f 33                	jg     103283 <strtol+0x13e>
            dig = *s - 'A' + 10;
  103250:	8b 45 08             	mov    0x8(%ebp),%eax
  103253:	0f b6 00             	movzbl (%eax),%eax
  103256:	0f be c0             	movsbl %al,%eax
  103259:	83 e8 37             	sub    $0x37,%eax
  10325c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  10325f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103262:	3b 45 10             	cmp    0x10(%ebp),%eax
  103265:	7c 02                	jl     103269 <strtol+0x124>
            break;
  103267:	eb 1a                	jmp    103283 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  103269:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10326d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103270:	0f af 45 10          	imul   0x10(%ebp),%eax
  103274:	89 c2                	mov    %eax,%edx
  103276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103279:	01 d0                	add    %edx,%eax
  10327b:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  10327e:	e9 6f ff ff ff       	jmp    1031f2 <strtol+0xad>

    if (endptr) {
  103283:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103287:	74 08                	je     103291 <strtol+0x14c>
        *endptr = (char *) s;
  103289:	8b 45 0c             	mov    0xc(%ebp),%eax
  10328c:	8b 55 08             	mov    0x8(%ebp),%edx
  10328f:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  103291:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  103295:	74 07                	je     10329e <strtol+0x159>
  103297:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10329a:	f7 d8                	neg    %eax
  10329c:	eb 03                	jmp    1032a1 <strtol+0x15c>
  10329e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  1032a1:	c9                   	leave  
  1032a2:	c3                   	ret    

001032a3 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  1032a3:	55                   	push   %ebp
  1032a4:	89 e5                	mov    %esp,%ebp
  1032a6:	57                   	push   %edi
  1032a7:	83 ec 24             	sub    $0x24,%esp
  1032aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032ad:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  1032b0:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  1032b4:	8b 55 08             	mov    0x8(%ebp),%edx
  1032b7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  1032ba:	88 45 f7             	mov    %al,-0x9(%ebp)
  1032bd:	8b 45 10             	mov    0x10(%ebp),%eax
  1032c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  1032c3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1032c6:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1032ca:	8b 55 f8             	mov    -0x8(%ebp),%edx
  1032cd:	89 d7                	mov    %edx,%edi
  1032cf:	f3 aa                	rep stos %al,%es:(%edi)
  1032d1:	89 fa                	mov    %edi,%edx
  1032d3:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1032d6:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  1032d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  1032dc:	83 c4 24             	add    $0x24,%esp
  1032df:	5f                   	pop    %edi
  1032e0:	5d                   	pop    %ebp
  1032e1:	c3                   	ret    

001032e2 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  1032e2:	55                   	push   %ebp
  1032e3:	89 e5                	mov    %esp,%ebp
  1032e5:	57                   	push   %edi
  1032e6:	56                   	push   %esi
  1032e7:	53                   	push   %ebx
  1032e8:	83 ec 30             	sub    $0x30,%esp
  1032eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1032ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1032f7:	8b 45 10             	mov    0x10(%ebp),%eax
  1032fa:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  1032fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103300:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103303:	73 42                	jae    103347 <memmove+0x65>
  103305:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103308:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10330b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10330e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103311:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103314:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103317:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10331a:	c1 e8 02             	shr    $0x2,%eax
  10331d:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  10331f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103322:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103325:	89 d7                	mov    %edx,%edi
  103327:	89 c6                	mov    %eax,%esi
  103329:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10332b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10332e:	83 e1 03             	and    $0x3,%ecx
  103331:	74 02                	je     103335 <memmove+0x53>
  103333:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103335:	89 f0                	mov    %esi,%eax
  103337:	89 fa                	mov    %edi,%edx
  103339:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  10333c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10333f:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  103342:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103345:	eb 36                	jmp    10337d <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  103347:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10334a:	8d 50 ff             	lea    -0x1(%eax),%edx
  10334d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103350:	01 c2                	add    %eax,%edx
  103352:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103355:	8d 48 ff             	lea    -0x1(%eax),%ecx
  103358:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10335b:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  10335e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103361:	89 c1                	mov    %eax,%ecx
  103363:	89 d8                	mov    %ebx,%eax
  103365:	89 d6                	mov    %edx,%esi
  103367:	89 c7                	mov    %eax,%edi
  103369:	fd                   	std    
  10336a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10336c:	fc                   	cld    
  10336d:	89 f8                	mov    %edi,%eax
  10336f:	89 f2                	mov    %esi,%edx
  103371:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  103374:	89 55 c8             	mov    %edx,-0x38(%ebp)
  103377:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  10337a:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  10337d:	83 c4 30             	add    $0x30,%esp
  103380:	5b                   	pop    %ebx
  103381:	5e                   	pop    %esi
  103382:	5f                   	pop    %edi
  103383:	5d                   	pop    %ebp
  103384:	c3                   	ret    

00103385 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  103385:	55                   	push   %ebp
  103386:	89 e5                	mov    %esp,%ebp
  103388:	57                   	push   %edi
  103389:	56                   	push   %esi
  10338a:	83 ec 20             	sub    $0x20,%esp
  10338d:	8b 45 08             	mov    0x8(%ebp),%eax
  103390:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103393:	8b 45 0c             	mov    0xc(%ebp),%eax
  103396:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103399:	8b 45 10             	mov    0x10(%ebp),%eax
  10339c:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10339f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033a2:	c1 e8 02             	shr    $0x2,%eax
  1033a5:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  1033a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1033aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033ad:	89 d7                	mov    %edx,%edi
  1033af:	89 c6                	mov    %eax,%esi
  1033b1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1033b3:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1033b6:	83 e1 03             	and    $0x3,%ecx
  1033b9:	74 02                	je     1033bd <memcpy+0x38>
  1033bb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1033bd:	89 f0                	mov    %esi,%eax
  1033bf:	89 fa                	mov    %edi,%edx
  1033c1:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1033c4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1033c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  1033ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  1033cd:	83 c4 20             	add    $0x20,%esp
  1033d0:	5e                   	pop    %esi
  1033d1:	5f                   	pop    %edi
  1033d2:	5d                   	pop    %ebp
  1033d3:	c3                   	ret    

001033d4 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  1033d4:	55                   	push   %ebp
  1033d5:	89 e5                	mov    %esp,%ebp
  1033d7:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  1033da:	8b 45 08             	mov    0x8(%ebp),%eax
  1033dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  1033e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1033e6:	eb 30                	jmp    103418 <memcmp+0x44>
        if (*s1 != *s2) {
  1033e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1033eb:	0f b6 10             	movzbl (%eax),%edx
  1033ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1033f1:	0f b6 00             	movzbl (%eax),%eax
  1033f4:	38 c2                	cmp    %al,%dl
  1033f6:	74 18                	je     103410 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  1033f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1033fb:	0f b6 00             	movzbl (%eax),%eax
  1033fe:	0f b6 d0             	movzbl %al,%edx
  103401:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103404:	0f b6 00             	movzbl (%eax),%eax
  103407:	0f b6 c0             	movzbl %al,%eax
  10340a:	29 c2                	sub    %eax,%edx
  10340c:	89 d0                	mov    %edx,%eax
  10340e:	eb 1a                	jmp    10342a <memcmp+0x56>
        }
        s1 ++, s2 ++;
  103410:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  103414:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  103418:	8b 45 10             	mov    0x10(%ebp),%eax
  10341b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10341e:	89 55 10             	mov    %edx,0x10(%ebp)
  103421:	85 c0                	test   %eax,%eax
  103423:	75 c3                	jne    1033e8 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  103425:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10342a:	c9                   	leave  
  10342b:	c3                   	ret    
