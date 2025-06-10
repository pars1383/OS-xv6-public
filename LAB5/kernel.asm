
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 70 55 11 80       	mov    $0x80115570,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 60 33 10 80       	mov    $0x80103360,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 a0 74 10 80       	push   $0x801074a0
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 75 46 00 00       	call   801046d0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c ec 10 80       	mov    $0x8010ec1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010006a:	ec 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100074:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 a7 74 10 80       	push   $0x801074a7
80100097:	50                   	push   %eax
80100098:	e8 03 45 00 00       	call   801045a0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 e9 10 80    	cmp    $0x8010e9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 a5 10 80       	push   $0x8010a520
801000e4:	e8 b7 47 00 00       	call   801048a0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100126:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 a5 10 80       	push   $0x8010a520
80100162:	e8 d9 46 00 00       	call   80104840 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 6e 44 00 00       	call   801045e0 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 4f 24 00 00       	call   801025e0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 ae 74 10 80       	push   $0x801074ae
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 bd 44 00 00       	call   80104680 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 07 24 00 00       	jmp    801025e0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 bf 74 10 80       	push   $0x801074bf
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 7c 44 00 00       	call   80104680 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 2c 44 00 00       	call   80104640 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021b:	e8 80 46 00 00       	call   801048a0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 cf 45 00 00       	jmp    80104840 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 c6 74 10 80       	push   $0x801074c6
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 c7 18 00 00       	call   80101b60 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801002a0:	e8 fb 45 00 00       	call   801048a0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002b5:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ef 10 80       	push   $0x8010ef20
801002c8:	68 00 ef 10 80       	push   $0x8010ef00
801002cd:	e8 6e 40 00 00       	call   80104340 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 89 39 00 00       	call   80103c70 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ef 10 80       	push   $0x8010ef20
801002f6:	e8 45 45 00 00       	call   80104840 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 7c 17 00 00       	call   80101a80 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 ee 10 80 	movsbl -0x7fef1180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ef 10 80       	push   $0x8010ef20
8010034c:	e8 ef 44 00 00       	call   80104840 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 26 17 00 00       	call   80101a80 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 52 28 00 00       	call   80102bf0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 cd 74 10 80       	push   $0x801074cd
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 57 7e 10 80 	movl   $0x80107e57,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 23 43 00 00       	call   801046f0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 e1 74 10 80       	push   $0x801074e1
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 91 5b 00 00       	call   80105fb0 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 a6 5a 00 00       	call   80105fb0 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 9a 5a 00 00       	call   80105fb0 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 8e 5a 00 00       	call   80105fb0 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 aa 44 00 00       	call   80104a00 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 f5 43 00 00       	call   80104960 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 e5 74 10 80       	push   $0x801074e5
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 bc 15 00 00       	call   80101b60 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801005ab:	e8 f0 42 00 00       	call   801048a0 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 20 ef 10 80       	push   $0x8010ef20
801005e4:	e8 57 42 00 00       	call   80104840 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 8e 14 00 00       	call   80101a80 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 60 75 10 80 	movzbl -0x7fef8aa0(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 54 ef 10 80       	mov    0x8010ef54,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 20 ef 10 80       	push   $0x8010ef20
801007e8:	e8 b3 40 00 00       	call   801048a0 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf f8 74 10 80       	mov    $0x801074f8,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ef 10 80       	push   $0x8010ef20
8010085b:	e8 e0 3f 00 00       	call   80104840 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 ff 74 10 80       	push   $0x801074ff
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
80100885:	53                   	push   %ebx
80100886:	83 ec 38             	sub    $0x38,%esp
80100889:	8b 45 08             	mov    0x8(%ebp),%eax
  acquire(&cons.lock);
8010088c:	68 20 ef 10 80       	push   $0x8010ef20
{
80100891:	89 45 dc             	mov    %eax,-0x24(%ebp)
  acquire(&cons.lock);
80100894:	e8 07 40 00 00       	call   801048a0 <acquire>
  int c, doprocdump = 0;
80100899:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  while((c = getc()) >= 0){
801008a0:	83 c4 10             	add    $0x10,%esp
801008a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
801008a6:	ff d0                	call   *%eax
801008a8:	89 c6                	mov    %eax,%esi
801008aa:	85 c0                	test   %eax,%eax
801008ac:	78 72                	js     80100920 <consoleintr+0xa0>
    switch(c){
801008ae:	83 fe 16             	cmp    $0x16,%esi
801008b1:	7f 1d                	jg     801008d0 <consoleintr+0x50>
801008b3:	83 fe 02             	cmp    $0x2,%esi
801008b6:	0f 8e d4 02 00 00    	jle    80100b90 <consoleintr+0x310>
801008bc:	8d 46 fd             	lea    -0x3(%esi),%eax
801008bf:	83 f8 13             	cmp    $0x13,%eax
801008c2:	0f 87 c8 02 00 00    	ja     80100b90 <consoleintr+0x310>
801008c8:	ff 24 85 10 75 10 80 	jmp    *-0x7fef8af0(,%eax,4)
801008cf:	90                   	nop
801008d0:	81 fe e4 00 00 00    	cmp    $0xe4,%esi
801008d6:	0f 85 c4 02 00 00    	jne    80100ba0 <consoleintr+0x320>
      select_buffer[saved_index++] = input.buf[(input.e-1) %INPUT_BUF];
801008dc:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
    if (selecting){
801008e1:	8b 0d 60 ef 10 80    	mov    0x8010ef60,%ecx
      select_buffer[saved_index++] = input.buf[(input.e-1) %INPUT_BUF];
801008e7:	83 e8 01             	sub    $0x1,%eax
    if (selecting){
801008ea:	85 c9                	test   %ecx,%ecx
801008ec:	74 21                	je     8010090f <consoleintr+0x8f>
      select_buffer[saved_index++] = input.buf[(input.e-1) %INPUT_BUF];
801008ee:	8b 15 5c ef 10 80    	mov    0x8010ef5c,%edx
801008f4:	8d 4a 01             	lea    0x1(%edx),%ecx
801008f7:	89 0d 5c ef 10 80    	mov    %ecx,0x8010ef5c
801008fd:	89 c1                	mov    %eax,%ecx
801008ff:	83 e1 7f             	and    $0x7f,%ecx
80100902:	0f b6 89 80 ee 10 80 	movzbl -0x7fef1180(%ecx),%ecx
80100909:	88 8a 80 ef 10 80    	mov    %cl,-0x7fef1080(%edx)
    input.e--;
8010090f:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  while((c = getc()) >= 0){
80100914:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100917:	ff d0                	call   *%eax
80100919:	89 c6                	mov    %eax,%esi
8010091b:	85 c0                	test   %eax,%eax
8010091d:	79 8f                	jns    801008ae <consoleintr+0x2e>
8010091f:	90                   	nop
  release(&cons.lock);
80100920:	83 ec 0c             	sub    $0xc,%esp
80100923:	68 20 ef 10 80       	push   $0x8010ef20
80100928:	e8 13 3f 00 00       	call   80104840 <release>
  if(doprocdump) {
8010092d:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100930:	83 c4 10             	add    $0x10,%esp
80100933:	85 c0                	test   %eax,%eax
80100935:	0f 85 a4 03 00 00    	jne    80100cdf <consoleintr+0x45f>
}
8010093b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010093e:	5b                   	pop    %ebx
8010093f:	5e                   	pop    %esi
80100940:	5f                   	pop    %edi
80100941:	5d                   	pop    %ebp
80100942:	c3                   	ret    
    for (int i= saved_index-1; i>=0; i--) {
80100943:	8b 1d 5c ef 10 80    	mov    0x8010ef5c,%ebx
80100949:	83 eb 01             	sub    $0x1,%ebx
8010094c:	0f 88 51 ff ff ff    	js     801008a3 <consoleintr+0x23>
  if(panicked){
80100952:	8b 35 58 ef 10 80    	mov    0x8010ef58,%esi
        consputc(select_buffer[i]);
80100958:	0f be 83 80 ef 10 80 	movsbl -0x7fef1080(%ebx),%eax
  if(panicked){
8010095f:	85 f6                	test   %esi,%esi
80100961:	0f 84 11 02 00 00    	je     80100b78 <consoleintr+0x2f8>
80100967:	fa                   	cli    
    for(;;)
80100968:	eb fe                	jmp    80100968 <consoleintr+0xe8>
8010096a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100970:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100975:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
8010097b:	0f 84 22 ff ff ff    	je     801008a3 <consoleintr+0x23>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100981:	83 e8 01             	sub    $0x1,%eax
80100984:	89 c2                	mov    %eax,%edx
80100986:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100989:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
80100990:	0f 84 0d ff ff ff    	je     801008a3 <consoleintr+0x23>
        input.e--;
80100996:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
8010099b:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
801009a0:	85 c0                	test   %eax,%eax
801009a2:	0f 84 aa 01 00 00    	je     80100b52 <consoleintr+0x2d2>
801009a8:	fa                   	cli    
    for(;;)
801009a9:	eb fe                	jmp    801009a9 <consoleintr+0x129>
801009ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801009af:	90                   	nop
  if (input.buf[input.r] == '!')
801009b0:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801009b5:	80 b8 80 ee 10 80 21 	cmpb   $0x21,-0x7fef1180(%eax)
801009bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
801009bf:	0f 84 de fe ff ff    	je     801008a3 <consoleintr+0x23>
    for (int i = command_history.count -1 ; i >= 0; i--)
801009c5:	8b 3d 78 85 10 80    	mov    0x80108578,%edi
801009cb:	83 ef 01             	sub    $0x1,%edi
801009ce:	89 7d e0             	mov    %edi,-0x20(%ebp)
801009d1:	0f 88 cc fe ff ff    	js     801008a3 <consoleintr+0x23>
801009d7:	69 ff 8c 00 00 00    	imul   $0x8c,%edi,%edi
    for(j = input.r ; j < input.e; j++, k++){
801009dd:	8b 0d 08 ef 10 80    	mov    0x8010ef08,%ecx
801009e3:	89 ce                	mov    %ecx,%esi
801009e5:	29 c6                	sub    %eax,%esi
801009e7:	29 c7                	sub    %eax,%edi
    int k = command_history.commands[i].r;
801009e9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801009ec:	89 75 d4             	mov    %esi,-0x2c(%ebp)
801009ef:	8b b4 38 80 80 10 80 	mov    -0x7fef7f80(%eax,%edi,1),%esi
801009f6:	89 f3                	mov    %esi,%ebx
    for(j = input.r ; j < input.e; j++, k++){
801009f8:	39 c8                	cmp    %ecx,%eax
801009fa:	73 65                	jae    80100a61 <consoleintr+0x1e1>
801009fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    int flag = 1;
80100a00:	ba 01 00 00 00       	mov    $0x1,%edx
80100a05:	8d 1c 3e             	lea    (%esi,%edi,1),%ebx
80100a08:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100a0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100a0f:	90                   	nop
        flag = 0;
80100a10:	0f b6 94 18 00 80 10 	movzbl -0x7fef8000(%eax,%ebx,1),%edx
80100a17:	80 
80100a18:	38 90 80 ee 10 80    	cmp    %dl,-0x7fef1180(%eax)
80100a1e:	ba 00 00 00 00       	mov    $0x0,%edx
80100a23:	0f 44 55 e4          	cmove  -0x1c(%ebp),%edx
    for(j = input.r ; j < input.e; j++, k++){
80100a27:	83 c0 01             	add    $0x1,%eax
        flag = 0;
80100a2a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for(j = input.r ; j < input.e; j++, k++){
80100a2d:	39 c8                	cmp    %ecx,%eax
80100a2f:	75 df                	jne    80100a10 <consoleintr+0x190>
80100a31:	03 75 d4             	add    -0x2c(%ebp),%esi
80100a34:	89 f3                	mov    %esi,%ebx
    if(flag == 1){
80100a36:	83 fa 01             	cmp    $0x1,%edx
80100a39:	74 26                	je     80100a61 <consoleintr+0x1e1>
    for (int i = command_history.count -1 ; i >= 0; i--)
80100a3b:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
80100a3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100a42:	81 ef 8c 00 00 00    	sub    $0x8c,%edi
80100a48:	83 f8 ff             	cmp    $0xffffffff,%eax
80100a4b:	0f 84 52 fe ff ff    	je     801008a3 <consoleintr+0x23>
    int k = command_history.commands[i].r;
80100a51:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100a54:	8b b4 38 80 80 10 80 	mov    -0x7fef7f80(%eax,%edi,1),%esi
80100a5b:	89 f3                	mov    %esi,%ebx
    for(j = input.r ; j < input.e; j++, k++){
80100a5d:	39 c8                	cmp    %ecx,%eax
80100a5f:	72 9f                	jb     80100a00 <consoleintr+0x180>
      for(; k < command_history.commands[i].e - 1; j++, k++){
80100a61:	69 7d e0 8c 00 00 00 	imul   $0x8c,-0x20(%ebp),%edi
80100a68:	8b 87 88 80 10 80    	mov    -0x7fef7f78(%edi),%eax
80100a6e:	8d 97 00 80 10 80    	lea    -0x7fef8000(%edi),%edx
80100a74:	83 e8 01             	sub    $0x1,%eax
80100a77:	39 f0                	cmp    %esi,%eax
80100a79:	0f 86 24 fe ff ff    	jbe    801008a3 <consoleintr+0x23>
80100a7f:	89 d6                	mov    %edx,%esi
        input.buf[input.e++ % INPUT_BUF] = command_history.commands[i].buf[k];
80100a81:	8d 41 01             	lea    0x1(%ecx),%eax
  if(panicked){
80100a84:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.buf[input.e++ % INPUT_BUF] = command_history.commands[i].buf[k];
80100a8a:	83 e1 7f             	and    $0x7f,%ecx
80100a8d:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
80100a92:	0f be 84 1f 00 80 10 	movsbl -0x7fef8000(%edi,%ebx,1),%eax
80100a99:	80 
80100a9a:	88 81 80 ee 10 80    	mov    %al,-0x7fef1180(%ecx)
  if(panicked){
80100aa0:	85 d2                	test   %edx,%edx
80100aa2:	0f 84 43 02 00 00    	je     80100ceb <consoleintr+0x46b>
80100aa8:	fa                   	cli    
    for(;;)
80100aa9:	eb fe                	jmp    80100aa9 <consoleintr+0x229>
80100aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100aaf:	90                   	nop
    release(&cons.lock);
80100ab0:	83 ec 0c             	sub    $0xc,%esp
80100ab3:	68 20 ef 10 80       	push   $0x8010ef20
80100ab8:	e8 83 3d 00 00       	call   80104840 <release>
    if(command_history.count < 5)
80100abd:	8b 35 78 85 10 80    	mov    0x80108578,%esi
80100ac3:	83 c4 10             	add    $0x10,%esp
80100ac6:	83 fe 04             	cmp    $0x4,%esi
80100ac9:	0f 8f c7 01 00 00    	jg     80100c96 <consoleintr+0x416>
      for (int i = 0; i < command_history.count; i++)
80100acf:	31 db                	xor    %ebx,%ebx
80100ad1:	31 ff                	xor    %edi,%edi
80100ad3:	85 f6                	test   %esi,%esi
80100ad5:	7e 33                	jle    80100b0a <consoleintr+0x28a>
80100ad7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100ade:	66 90                	xchg   %ax,%ax
        cprintf(&command_history.commands[i].buf[command_history.commands[i].r]);
80100ae0:	8b 83 80 80 10 80    	mov    -0x7fef7f80(%ebx),%eax
80100ae6:	83 ec 0c             	sub    $0xc,%esp
      for (int i = 0; i < command_history.count; i++)
80100ae9:	83 c7 01             	add    $0x1,%edi
        cprintf(&command_history.commands[i].buf[command_history.commands[i].r]);
80100aec:	01 d8                	add    %ebx,%eax
      for (int i = 0; i < command_history.count; i++)
80100aee:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
        cprintf(&command_history.commands[i].buf[command_history.commands[i].r]);
80100af4:	05 00 80 10 80       	add    $0x80108000,%eax
80100af9:	50                   	push   %eax
80100afa:	e8 a1 fb ff ff       	call   801006a0 <cprintf>
      for (int i = 0; i < command_history.count; i++)
80100aff:	83 c4 10             	add    $0x10,%esp
80100b02:	3b 3d 78 85 10 80    	cmp    0x80108578,%edi
80100b08:	7c d6                	jl     80100ae0 <consoleintr+0x260>
    acquire(&cons.lock);
80100b0a:	83 ec 0c             	sub    $0xc,%esp
80100b0d:	68 20 ef 10 80       	push   $0x8010ef20
80100b12:	e8 89 3d 00 00       	call   801048a0 <acquire>
}
80100b17:	83 c4 10             	add    $0x10,%esp
80100b1a:	e9 84 fd ff ff       	jmp    801008a3 <consoleintr+0x23>
    if (!selecting) {
80100b1f:	8b 3d 60 ef 10 80    	mov    0x8010ef60,%edi
80100b25:	85 ff                	test   %edi,%edi
80100b27:	0f 85 5a 01 00 00    	jne    80100c87 <consoleintr+0x407>
      selecting = 1;
80100b2d:	c7 05 60 ef 10 80 01 	movl   $0x1,0x8010ef60
80100b34:	00 00 00 
      saved_index =0;
80100b37:	c7 05 5c ef 10 80 00 	movl   $0x0,0x8010ef5c
80100b3e:	00 00 00 
80100b41:	e9 5d fd ff ff       	jmp    801008a3 <consoleintr+0x23>
    switch(c){
80100b46:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
80100b4d:	e9 51 fd ff ff       	jmp    801008a3 <consoleintr+0x23>
80100b52:	b8 00 01 00 00       	mov    $0x100,%eax
80100b57:	e8 a4 f8 ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
80100b5c:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100b61:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100b67:	0f 85 14 fe ff ff    	jne    80100981 <consoleintr+0x101>
80100b6d:	e9 31 fd ff ff       	jmp    801008a3 <consoleintr+0x23>
80100b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100b78:	e8 83 f8 ff ff       	call   80100400 <consputc.part.0>
    for (int i= saved_index-1; i>=0; i--) {
80100b7d:	83 eb 01             	sub    $0x1,%ebx
80100b80:	0f 83 cc fd ff ff    	jae    80100952 <consoleintr+0xd2>
80100b86:	e9 18 fd ff ff       	jmp    801008a3 <consoleintr+0x23>
80100b8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b8f:	90                   	nop
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100b90:	85 f6                	test   %esi,%esi
80100b92:	0f 84 0b fd ff ff    	je     801008a3 <consoleintr+0x23>
80100b98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b9f:	90                   	nop
80100ba0:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100ba5:	bb 80 ee 10 80       	mov    $0x8010ee80,%ebx
80100baa:	89 c2                	mov    %eax,%edx
80100bac:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
80100bb2:	83 fa 7f             	cmp    $0x7f,%edx
80100bb5:	0f 87 e8 fc ff ff    	ja     801008a3 <consoleintr+0x23>
        input_buf[input_pos++] = c;
80100bbb:	8b 3d 0c ef 10 80    	mov    0x8010ef0c,%edi
  if(panicked){
80100bc1:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
        input_buf[input_pos++] = c;
80100bc7:	8d 57 01             	lea    0x1(%edi),%edx
        input.buf[input.e++ % INPUT_BUF] = c;
80100bca:	8d 78 01             	lea    0x1(%eax),%edi
80100bcd:	83 e0 7f             	and    $0x7f,%eax
        input_buf[input_pos++] = c;
80100bd0:	89 15 0c ef 10 80    	mov    %edx,0x8010ef0c
        input.buf[input.e++ % INPUT_BUF] = c;
80100bd6:	89 3d 08 ef 10 80    	mov    %edi,0x8010ef08
        c = (c == '\r') ? '\n' : c;
80100bdc:	83 fe 0d             	cmp    $0xd,%esi
80100bdf:	0f 84 33 01 00 00    	je     80100d18 <consoleintr+0x498>
        input_buf[input_pos++] = c;
80100be5:	89 f2                	mov    %esi,%edx
80100be7:	88 90 80 ee 10 80    	mov    %dl,-0x7fef1180(%eax)
  if(panicked){
80100bed:	85 c9                	test   %ecx,%ecx
80100bef:	0f 85 1a 01 00 00    	jne    80100d0f <consoleintr+0x48f>
80100bf5:	89 f0                	mov    %esi,%eax
80100bf7:	e8 04 f8 ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100bfc:	83 fe 0a             	cmp    $0xa,%esi
80100bff:	0f 84 28 01 00 00    	je     80100d2d <consoleintr+0x4ad>
80100c05:	83 fe 04             	cmp    $0x4,%esi
80100c08:	0f 84 1f 01 00 00    	je     80100d2d <consoleintr+0x4ad>
80100c0e:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
80100c13:	8d 90 80 00 00 00    	lea    0x80(%eax),%edx
80100c19:	39 15 08 ef 10 80    	cmp    %edx,0x8010ef08
80100c1f:	0f 85 7e fc ff ff    	jne    801008a3 <consoleintr+0x23>
             command_history.index ++ ;
80100c25:	8b 3d 7c 85 10 80    	mov    0x8010857c,%edi
          if (command_history.count == 10)
80100c2b:	a1 78 85 10 80       	mov    0x80108578,%eax
             command_history.index ++ ;
80100c30:	89 7d e4             	mov    %edi,-0x1c(%ebp)
          if (command_history.count == 10)
80100c33:	83 f8 0a             	cmp    $0xa,%eax
80100c36:	0f 84 fc 00 00 00    	je     80100d38 <consoleintr+0x4b8>
          if(command_history.count < 10){
80100c3c:	83 f8 09             	cmp    $0x9,%eax
80100c3f:	7f 14                	jg     80100c55 <consoleintr+0x3d5>
             command_history.count ++;
80100c41:	83 c0 01             	add    $0x1,%eax
             command_history.index ++ ;
80100c44:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
             command_history.count ++;
80100c48:	a3 78 85 10 80       	mov    %eax,0x80108578
             command_history.index ++ ;
80100c4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100c50:	a3 7c 85 10 80       	mov    %eax,0x8010857c
          command_history.commands[command_history.index] = input;
80100c55:	69 45 e4 8c 00 00 00 	imul   $0x8c,-0x1c(%ebp),%eax
80100c5c:	b9 23 00 00 00       	mov    $0x23,%ecx
80100c61:	89 de                	mov    %ebx,%esi
          wakeup(&input.r);
80100c63:	83 ec 0c             	sub    $0xc,%esp
          command_history.commands[command_history.index] = input;
80100c66:	05 00 80 10 80       	add    $0x80108000,%eax
80100c6b:	89 c7                	mov    %eax,%edi
80100c6d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
          wakeup(&input.r);
80100c6f:	68 00 ef 10 80       	push   $0x8010ef00
          input.w = input.e;
80100c74:	89 15 04 ef 10 80    	mov    %edx,0x8010ef04
          wakeup(&input.r);
80100c7a:	e8 81 37 00 00       	call   80104400 <wakeup>
80100c7f:	83 c4 10             	add    $0x10,%esp
80100c82:	e9 1c fc ff ff       	jmp    801008a3 <consoleintr+0x23>
      selecting = 0;
80100c87:	c7 05 60 ef 10 80 00 	movl   $0x0,0x8010ef60
80100c8e:	00 00 00 
80100c91:	e9 0d fc ff ff       	jmp    801008a3 <consoleintr+0x23>
      for (int i = command_history.count - 5; i < command_history.count; i++)
80100c96:	83 ee 05             	sub    $0x5,%esi
80100c99:	69 de 8c 00 00 00    	imul   $0x8c,%esi,%ebx
80100c9f:	90                   	nop
        cprintf(&command_history.commands[i].buf[command_history.commands[i].r]);
80100ca0:	8b 83 80 80 10 80    	mov    -0x7fef7f80(%ebx),%eax
80100ca6:	83 ec 0c             	sub    $0xc,%esp
      for (int i = command_history.count - 5; i < command_history.count; i++)
80100ca9:	83 c6 01             	add    $0x1,%esi
        cprintf(&command_history.commands[i].buf[command_history.commands[i].r]);
80100cac:	01 d8                	add    %ebx,%eax
      for (int i = command_history.count - 5; i < command_history.count; i++)
80100cae:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
        cprintf(&command_history.commands[i].buf[command_history.commands[i].r]);
80100cb4:	05 00 80 10 80       	add    $0x80108000,%eax
80100cb9:	50                   	push   %eax
80100cba:	e8 e1 f9 ff ff       	call   801006a0 <cprintf>
      for (int i = command_history.count - 5; i < command_history.count; i++)
80100cbf:	83 c4 10             	add    $0x10,%esp
80100cc2:	3b 35 78 85 10 80    	cmp    0x80108578,%esi
80100cc8:	7c d6                	jl     80100ca0 <consoleintr+0x420>
    acquire(&cons.lock);
80100cca:	83 ec 0c             	sub    $0xc,%esp
80100ccd:	68 20 ef 10 80       	push   $0x8010ef20
80100cd2:	e8 c9 3b 00 00       	call   801048a0 <acquire>
}
80100cd7:	83 c4 10             	add    $0x10,%esp
80100cda:	e9 c4 fb ff ff       	jmp    801008a3 <consoleintr+0x23>
}
80100cdf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ce2:	5b                   	pop    %ebx
80100ce3:	5e                   	pop    %esi
80100ce4:	5f                   	pop    %edi
80100ce5:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100ce6:	e9 f5 37 00 00       	jmp    801044e0 <procdump>
80100ceb:	e8 10 f7 ff ff       	call   80100400 <consputc.part.0>
      for(; k < command_history.commands[i].e - 1; j++, k++){
80100cf0:	8b 86 88 00 00 00    	mov    0x88(%esi),%eax
80100cf6:	83 c3 01             	add    $0x1,%ebx
80100cf9:	83 e8 01             	sub    $0x1,%eax
80100cfc:	39 d8                	cmp    %ebx,%eax
80100cfe:	0f 86 9f fb ff ff    	jbe    801008a3 <consoleintr+0x23>
        input.buf[input.e++ % INPUT_BUF] = command_history.commands[i].buf[k];
80100d04:	8b 0d 08 ef 10 80    	mov    0x8010ef08,%ecx
80100d0a:	e9 72 fd ff ff       	jmp    80100a81 <consoleintr+0x201>
80100d0f:	fa                   	cli    
    for(;;)
80100d10:	eb fe                	jmp    80100d10 <consoleintr+0x490>
80100d12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
80100d18:	c6 80 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%eax)
  if(panicked){
80100d1f:	85 c9                	test   %ecx,%ecx
80100d21:	75 ec                	jne    80100d0f <consoleintr+0x48f>
80100d23:	b8 0a 00 00 00       	mov    $0xa,%eax
80100d28:	e8 d3 f6 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100d2d:	8b 15 08 ef 10 80    	mov    0x8010ef08,%edx
80100d33:	e9 ed fe ff ff       	jmp    80100c25 <consoleintr+0x3a5>
80100d38:	b8 00 80 10 80       	mov    $0x80108000,%eax
    command_history.commands[i] =  command_history.commands[i+1]; 
80100d3d:	8d b0 8c 00 00 00    	lea    0x8c(%eax),%esi
80100d43:	89 c7                	mov    %eax,%edi
80100d45:	b9 23 00 00 00       	mov    $0x23,%ecx
  for (int i = 0; i < 9; i++) {
80100d4a:	05 8c 00 00 00       	add    $0x8c,%eax
    command_history.commands[i] =  command_history.commands[i+1]; 
80100d4f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for (int i = 0; i < 9; i++) {
80100d51:	bf ec 84 10 80       	mov    $0x801084ec,%edi
80100d56:	39 c7                	cmp    %eax,%edi
80100d58:	75 e3                	jne    80100d3d <consoleintr+0x4bd>
80100d5a:	e9 f6 fe ff ff       	jmp    80100c55 <consoleintr+0x3d5>
80100d5f:	90                   	nop

80100d60 <consoleinit>:

void
consoleinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100d66:	68 08 75 10 80       	push   $0x80107508
80100d6b:	68 20 ef 10 80       	push   $0x8010ef20
80100d70:	e8 5b 39 00 00       	call   801046d0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100d75:	58                   	pop    %eax
80100d76:	5a                   	pop    %edx
80100d77:	6a 00                	push   $0x0
80100d79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100d7b:	c7 05 ac f9 10 80 90 	movl   $0x80100590,0x8010f9ac
80100d82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100d85:	c7 05 a8 f9 10 80 80 	movl   $0x80100280,0x8010f9a8
80100d8c:	02 10 80 
  cons.locking = 1;
80100d8f:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100d96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100d99:	e8 e2 19 00 00       	call   80102780 <ioapicenable>
80100d9e:	83 c4 10             	add    $0x10,%esp
80100da1:	c9                   	leave  
80100da2:	c3                   	ret    
80100da3:	66 90                	xchg   %ax,%ax
80100da5:	66 90                	xchg   %ax,%ax
80100da7:	66 90                	xchg   %ax,%ax
80100da9:	66 90                	xchg   %ax,%ax
80100dab:	66 90                	xchg   %ax,%ax
80100dad:	66 90                	xchg   %ax,%ax
80100daf:	90                   	nop

80100db0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100db0:	55                   	push   %ebp
80100db1:	89 e5                	mov    %esp,%ebp
80100db3:	57                   	push   %edi
80100db4:	56                   	push   %esi
80100db5:	53                   	push   %ebx
80100db6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100dbc:	e8 af 2e 00 00       	call   80103c70 <myproc>
80100dc1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100dc7:	e8 94 22 00 00       	call   80103060 <begin_op>

  if((ip = namei(path)) == 0){
80100dcc:	83 ec 0c             	sub    $0xc,%esp
80100dcf:	ff 75 08             	push   0x8(%ebp)
80100dd2:	e8 c9 15 00 00       	call   801023a0 <namei>
80100dd7:	83 c4 10             	add    $0x10,%esp
80100dda:	85 c0                	test   %eax,%eax
80100ddc:	0f 84 02 03 00 00    	je     801010e4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100de2:	83 ec 0c             	sub    $0xc,%esp
80100de5:	89 c3                	mov    %eax,%ebx
80100de7:	50                   	push   %eax
80100de8:	e8 93 0c 00 00       	call   80101a80 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ded:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100df3:	6a 34                	push   $0x34
80100df5:	6a 00                	push   $0x0
80100df7:	50                   	push   %eax
80100df8:	53                   	push   %ebx
80100df9:	e8 92 0f 00 00       	call   80101d90 <readi>
80100dfe:	83 c4 20             	add    $0x20,%esp
80100e01:	83 f8 34             	cmp    $0x34,%eax
80100e04:	74 22                	je     80100e28 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100e06:	83 ec 0c             	sub    $0xc,%esp
80100e09:	53                   	push   %ebx
80100e0a:	e8 01 0f 00 00       	call   80101d10 <iunlockput>
    end_op();
80100e0f:	e8 bc 22 00 00       	call   801030d0 <end_op>
80100e14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100e17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100e1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e1f:	5b                   	pop    %ebx
80100e20:	5e                   	pop    %esi
80100e21:	5f                   	pop    %edi
80100e22:	5d                   	pop    %ebp
80100e23:	c3                   	ret    
80100e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100e28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100e2f:	45 4c 46 
80100e32:	75 d2                	jne    80100e06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100e34:	e8 07 63 00 00       	call   80107140 <setupkvm>
80100e39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100e3f:	85 c0                	test   %eax,%eax
80100e41:	74 c3                	je     80100e06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100e4a:	00 
80100e4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100e51:	0f 84 ac 02 00 00    	je     80101103 <exec+0x353>
  sz = 0;
80100e57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100e5e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e61:	31 ff                	xor    %edi,%edi
80100e63:	e9 8e 00 00 00       	jmp    80100ef6 <exec+0x146>
80100e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100e6f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100e70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100e77:	75 6c                	jne    80100ee5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100e79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100e7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100e85:	0f 82 87 00 00 00    	jb     80100f12 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100e8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100e91:	72 7f                	jb     80100f12 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100e93:	83 ec 04             	sub    $0x4,%esp
80100e96:	50                   	push   %eax
80100e97:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100e9d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ea3:	e8 b8 60 00 00       	call   80106f60 <allocuvm>
80100ea8:	83 c4 10             	add    $0x10,%esp
80100eab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100eb1:	85 c0                	test   %eax,%eax
80100eb3:	74 5d                	je     80100f12 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100eb5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ebb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100ec0:	75 50                	jne    80100f12 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100ec2:	83 ec 0c             	sub    $0xc,%esp
80100ec5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100ecb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100ed1:	53                   	push   %ebx
80100ed2:	50                   	push   %eax
80100ed3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ed9:	e8 92 5f 00 00       	call   80106e70 <loaduvm>
80100ede:	83 c4 20             	add    $0x20,%esp
80100ee1:	85 c0                	test   %eax,%eax
80100ee3:	78 2d                	js     80100f12 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ee5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100eec:	83 c7 01             	add    $0x1,%edi
80100eef:	83 c6 20             	add    $0x20,%esi
80100ef2:	39 f8                	cmp    %edi,%eax
80100ef4:	7e 3a                	jle    80100f30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100ef6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100efc:	6a 20                	push   $0x20
80100efe:	56                   	push   %esi
80100eff:	50                   	push   %eax
80100f00:	53                   	push   %ebx
80100f01:	e8 8a 0e 00 00       	call   80101d90 <readi>
80100f06:	83 c4 10             	add    $0x10,%esp
80100f09:	83 f8 20             	cmp    $0x20,%eax
80100f0c:	0f 84 5e ff ff ff    	je     80100e70 <exec+0xc0>
    freevm(pgdir);
80100f12:	83 ec 0c             	sub    $0xc,%esp
80100f15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100f1b:	e8 a0 61 00 00       	call   801070c0 <freevm>
  if(ip){
80100f20:	83 c4 10             	add    $0x10,%esp
80100f23:	e9 de fe ff ff       	jmp    80100e06 <exec+0x56>
80100f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f2f:	90                   	nop
  sz = PGROUNDUP(sz);
80100f30:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100f36:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100f3c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100f42:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100f48:	83 ec 0c             	sub    $0xc,%esp
80100f4b:	53                   	push   %ebx
80100f4c:	e8 bf 0d 00 00       	call   80101d10 <iunlockput>
  end_op();
80100f51:	e8 7a 21 00 00       	call   801030d0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100f56:	83 c4 0c             	add    $0xc,%esp
80100f59:	56                   	push   %esi
80100f5a:	57                   	push   %edi
80100f5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100f61:	57                   	push   %edi
80100f62:	e8 f9 5f 00 00       	call   80106f60 <allocuvm>
80100f67:	83 c4 10             	add    $0x10,%esp
80100f6a:	89 c6                	mov    %eax,%esi
80100f6c:	85 c0                	test   %eax,%eax
80100f6e:	0f 84 94 00 00 00    	je     80101008 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100f74:	83 ec 08             	sub    $0x8,%esp
80100f77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100f7d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100f7f:	50                   	push   %eax
80100f80:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100f81:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100f83:	e8 58 62 00 00       	call   801071e0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100f88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f8b:	83 c4 10             	add    $0x10,%esp
80100f8e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100f94:	8b 00                	mov    (%eax),%eax
80100f96:	85 c0                	test   %eax,%eax
80100f98:	0f 84 8b 00 00 00    	je     80101029 <exec+0x279>
80100f9e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100fa4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100faa:	eb 23                	jmp    80100fcf <exec+0x21f>
80100fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100fb3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100fba:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100fbd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100fc3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100fc6:	85 c0                	test   %eax,%eax
80100fc8:	74 59                	je     80101023 <exec+0x273>
    if(argc >= MAXARG)
80100fca:	83 ff 20             	cmp    $0x20,%edi
80100fcd:	74 39                	je     80101008 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100fcf:	83 ec 0c             	sub    $0xc,%esp
80100fd2:	50                   	push   %eax
80100fd3:	e8 88 3b 00 00       	call   80104b60 <strlen>
80100fd8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100fda:	58                   	pop    %eax
80100fdb:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100fde:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100fe1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100fe4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100fe7:	e8 74 3b 00 00       	call   80104b60 <strlen>
80100fec:	83 c0 01             	add    $0x1,%eax
80100fef:	50                   	push   %eax
80100ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ff3:	ff 34 b8             	push   (%eax,%edi,4)
80100ff6:	53                   	push   %ebx
80100ff7:	56                   	push   %esi
80100ff8:	e8 b3 63 00 00       	call   801073b0 <copyout>
80100ffd:	83 c4 20             	add    $0x20,%esp
80101000:	85 c0                	test   %eax,%eax
80101002:	79 ac                	jns    80100fb0 <exec+0x200>
80101004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80101008:	83 ec 0c             	sub    $0xc,%esp
8010100b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101011:	e8 aa 60 00 00       	call   801070c0 <freevm>
80101016:	83 c4 10             	add    $0x10,%esp
  return -1;
80101019:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010101e:	e9 f9 fd ff ff       	jmp    80100e1c <exec+0x6c>
80101023:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101029:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80101030:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80101032:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80101039:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010103d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
8010103f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80101042:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80101048:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
8010104a:	50                   	push   %eax
8010104b:	52                   	push   %edx
8010104c:	53                   	push   %ebx
8010104d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80101053:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
8010105a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010105d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101063:	e8 48 63 00 00       	call   801073b0 <copyout>
80101068:	83 c4 10             	add    $0x10,%esp
8010106b:	85 c0                	test   %eax,%eax
8010106d:	78 99                	js     80101008 <exec+0x258>
  for(last=s=path; *s; s++)
8010106f:	8b 45 08             	mov    0x8(%ebp),%eax
80101072:	8b 55 08             	mov    0x8(%ebp),%edx
80101075:	0f b6 00             	movzbl (%eax),%eax
80101078:	84 c0                	test   %al,%al
8010107a:	74 13                	je     8010108f <exec+0x2df>
8010107c:	89 d1                	mov    %edx,%ecx
8010107e:	66 90                	xchg   %ax,%ax
      last = s+1;
80101080:	83 c1 01             	add    $0x1,%ecx
80101083:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80101085:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80101088:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
8010108b:	84 c0                	test   %al,%al
8010108d:	75 f1                	jne    80101080 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
8010108f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80101095:	83 ec 04             	sub    $0x4,%esp
80101098:	6a 10                	push   $0x10
8010109a:	89 f8                	mov    %edi,%eax
8010109c:	52                   	push   %edx
8010109d:	83 c0 6c             	add    $0x6c,%eax
801010a0:	50                   	push   %eax
801010a1:	e8 7a 3a 00 00       	call   80104b20 <safestrcpy>
  curproc->pgdir = pgdir;
801010a6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
801010ac:	89 f8                	mov    %edi,%eax
801010ae:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
801010b1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
801010b3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
801010b6:	89 c1                	mov    %eax,%ecx
801010b8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
801010be:	8b 40 18             	mov    0x18(%eax),%eax
801010c1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
801010c4:	8b 41 18             	mov    0x18(%ecx),%eax
801010c7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
801010ca:	89 0c 24             	mov    %ecx,(%esp)
801010cd:	e8 0e 5c 00 00       	call   80106ce0 <switchuvm>
  freevm(oldpgdir);
801010d2:	89 3c 24             	mov    %edi,(%esp)
801010d5:	e8 e6 5f 00 00       	call   801070c0 <freevm>
  return 0;
801010da:	83 c4 10             	add    $0x10,%esp
801010dd:	31 c0                	xor    %eax,%eax
801010df:	e9 38 fd ff ff       	jmp    80100e1c <exec+0x6c>
    end_op();
801010e4:	e8 e7 1f 00 00       	call   801030d0 <end_op>
    cprintf("exec: fail\n");
801010e9:	83 ec 0c             	sub    $0xc,%esp
801010ec:	68 71 75 10 80       	push   $0x80107571
801010f1:	e8 aa f5 ff ff       	call   801006a0 <cprintf>
    return -1;
801010f6:	83 c4 10             	add    $0x10,%esp
801010f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801010fe:	e9 19 fd ff ff       	jmp    80100e1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101103:	be 00 20 00 00       	mov    $0x2000,%esi
80101108:	31 ff                	xor    %edi,%edi
8010110a:	e9 39 fe ff ff       	jmp    80100f48 <exec+0x198>
8010110f:	90                   	nop

80101110 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80101116:	68 7d 75 10 80       	push   $0x8010757d
8010111b:	68 00 f0 10 80       	push   $0x8010f000
80101120:	e8 ab 35 00 00       	call   801046d0 <initlock>
}
80101125:	83 c4 10             	add    $0x10,%esp
80101128:	c9                   	leave  
80101129:	c3                   	ret    
8010112a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101130 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101130:	55                   	push   %ebp
80101131:	89 e5                	mov    %esp,%ebp
80101133:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101134:	bb 34 f0 10 80       	mov    $0x8010f034,%ebx
{
80101139:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
8010113c:	68 00 f0 10 80       	push   $0x8010f000
80101141:	e8 5a 37 00 00       	call   801048a0 <acquire>
80101146:	83 c4 10             	add    $0x10,%esp
80101149:	eb 10                	jmp    8010115b <filealloc+0x2b>
8010114b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010114f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101150:	83 c3 18             	add    $0x18,%ebx
80101153:	81 fb 94 f9 10 80    	cmp    $0x8010f994,%ebx
80101159:	74 25                	je     80101180 <filealloc+0x50>
    if(f->ref == 0){
8010115b:	8b 43 04             	mov    0x4(%ebx),%eax
8010115e:	85 c0                	test   %eax,%eax
80101160:	75 ee                	jne    80101150 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101162:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101165:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010116c:	68 00 f0 10 80       	push   $0x8010f000
80101171:	e8 ca 36 00 00       	call   80104840 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101176:	89 d8                	mov    %ebx,%eax
      return f;
80101178:	83 c4 10             	add    $0x10,%esp
}
8010117b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010117e:	c9                   	leave  
8010117f:	c3                   	ret    
  release(&ftable.lock);
80101180:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101183:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101185:	68 00 f0 10 80       	push   $0x8010f000
8010118a:	e8 b1 36 00 00       	call   80104840 <release>
}
8010118f:	89 d8                	mov    %ebx,%eax
  return 0;
80101191:	83 c4 10             	add    $0x10,%esp
}
80101194:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101197:	c9                   	leave  
80101198:	c3                   	ret    
80101199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801011a0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801011a0:	55                   	push   %ebp
801011a1:	89 e5                	mov    %esp,%ebp
801011a3:	53                   	push   %ebx
801011a4:	83 ec 10             	sub    $0x10,%esp
801011a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
801011aa:	68 00 f0 10 80       	push   $0x8010f000
801011af:	e8 ec 36 00 00       	call   801048a0 <acquire>
  if(f->ref < 1)
801011b4:	8b 43 04             	mov    0x4(%ebx),%eax
801011b7:	83 c4 10             	add    $0x10,%esp
801011ba:	85 c0                	test   %eax,%eax
801011bc:	7e 1a                	jle    801011d8 <filedup+0x38>
    panic("filedup");
  f->ref++;
801011be:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
801011c1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
801011c4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
801011c7:	68 00 f0 10 80       	push   $0x8010f000
801011cc:	e8 6f 36 00 00       	call   80104840 <release>
  return f;
}
801011d1:	89 d8                	mov    %ebx,%eax
801011d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801011d6:	c9                   	leave  
801011d7:	c3                   	ret    
    panic("filedup");
801011d8:	83 ec 0c             	sub    $0xc,%esp
801011db:	68 84 75 10 80       	push   $0x80107584
801011e0:	e8 9b f1 ff ff       	call   80100380 <panic>
801011e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801011ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801011f0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801011f0:	55                   	push   %ebp
801011f1:	89 e5                	mov    %esp,%ebp
801011f3:	57                   	push   %edi
801011f4:	56                   	push   %esi
801011f5:	53                   	push   %ebx
801011f6:	83 ec 28             	sub    $0x28,%esp
801011f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
801011fc:	68 00 f0 10 80       	push   $0x8010f000
80101201:	e8 9a 36 00 00       	call   801048a0 <acquire>
  if(f->ref < 1)
80101206:	8b 53 04             	mov    0x4(%ebx),%edx
80101209:	83 c4 10             	add    $0x10,%esp
8010120c:	85 d2                	test   %edx,%edx
8010120e:	0f 8e a5 00 00 00    	jle    801012b9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101214:	83 ea 01             	sub    $0x1,%edx
80101217:	89 53 04             	mov    %edx,0x4(%ebx)
8010121a:	75 44                	jne    80101260 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
8010121c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101220:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101223:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101225:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010122b:	8b 73 0c             	mov    0xc(%ebx),%esi
8010122e:	88 45 e7             	mov    %al,-0x19(%ebp)
80101231:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101234:	68 00 f0 10 80       	push   $0x8010f000
  ff = *f;
80101239:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
8010123c:	e8 ff 35 00 00       	call   80104840 <release>

  if(ff.type == FD_PIPE)
80101241:	83 c4 10             	add    $0x10,%esp
80101244:	83 ff 01             	cmp    $0x1,%edi
80101247:	74 57                	je     801012a0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80101249:	83 ff 02             	cmp    $0x2,%edi
8010124c:	74 2a                	je     80101278 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010124e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101251:	5b                   	pop    %ebx
80101252:	5e                   	pop    %esi
80101253:	5f                   	pop    %edi
80101254:	5d                   	pop    %ebp
80101255:	c3                   	ret    
80101256:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010125d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80101260:	c7 45 08 00 f0 10 80 	movl   $0x8010f000,0x8(%ebp)
}
80101267:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010126a:	5b                   	pop    %ebx
8010126b:	5e                   	pop    %esi
8010126c:	5f                   	pop    %edi
8010126d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010126e:	e9 cd 35 00 00       	jmp    80104840 <release>
80101273:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101277:	90                   	nop
    begin_op();
80101278:	e8 e3 1d 00 00       	call   80103060 <begin_op>
    iput(ff.ip);
8010127d:	83 ec 0c             	sub    $0xc,%esp
80101280:	ff 75 e0             	push   -0x20(%ebp)
80101283:	e8 28 09 00 00       	call   80101bb0 <iput>
    end_op();
80101288:	83 c4 10             	add    $0x10,%esp
}
8010128b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010128e:	5b                   	pop    %ebx
8010128f:	5e                   	pop    %esi
80101290:	5f                   	pop    %edi
80101291:	5d                   	pop    %ebp
    end_op();
80101292:	e9 39 1e 00 00       	jmp    801030d0 <end_op>
80101297:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010129e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
801012a0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801012a4:	83 ec 08             	sub    $0x8,%esp
801012a7:	53                   	push   %ebx
801012a8:	56                   	push   %esi
801012a9:	e8 82 25 00 00       	call   80103830 <pipeclose>
801012ae:	83 c4 10             	add    $0x10,%esp
}
801012b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012b4:	5b                   	pop    %ebx
801012b5:	5e                   	pop    %esi
801012b6:	5f                   	pop    %edi
801012b7:	5d                   	pop    %ebp
801012b8:	c3                   	ret    
    panic("fileclose");
801012b9:	83 ec 0c             	sub    $0xc,%esp
801012bc:	68 8c 75 10 80       	push   $0x8010758c
801012c1:	e8 ba f0 ff ff       	call   80100380 <panic>
801012c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012cd:	8d 76 00             	lea    0x0(%esi),%esi

801012d0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801012d0:	55                   	push   %ebp
801012d1:	89 e5                	mov    %esp,%ebp
801012d3:	53                   	push   %ebx
801012d4:	83 ec 04             	sub    $0x4,%esp
801012d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801012da:	83 3b 02             	cmpl   $0x2,(%ebx)
801012dd:	75 31                	jne    80101310 <filestat+0x40>
    ilock(f->ip);
801012df:	83 ec 0c             	sub    $0xc,%esp
801012e2:	ff 73 10             	push   0x10(%ebx)
801012e5:	e8 96 07 00 00       	call   80101a80 <ilock>
    stati(f->ip, st);
801012ea:	58                   	pop    %eax
801012eb:	5a                   	pop    %edx
801012ec:	ff 75 0c             	push   0xc(%ebp)
801012ef:	ff 73 10             	push   0x10(%ebx)
801012f2:	e8 69 0a 00 00       	call   80101d60 <stati>
    iunlock(f->ip);
801012f7:	59                   	pop    %ecx
801012f8:	ff 73 10             	push   0x10(%ebx)
801012fb:	e8 60 08 00 00       	call   80101b60 <iunlock>
    return 0;
  }
  return -1;
}
80101300:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101303:	83 c4 10             	add    $0x10,%esp
80101306:	31 c0                	xor    %eax,%eax
}
80101308:	c9                   	leave  
80101309:	c3                   	ret    
8010130a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101310:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101313:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101318:	c9                   	leave  
80101319:	c3                   	ret    
8010131a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101320 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101320:	55                   	push   %ebp
80101321:	89 e5                	mov    %esp,%ebp
80101323:	57                   	push   %edi
80101324:	56                   	push   %esi
80101325:	53                   	push   %ebx
80101326:	83 ec 0c             	sub    $0xc,%esp
80101329:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010132c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010132f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101332:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101336:	74 60                	je     80101398 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101338:	8b 03                	mov    (%ebx),%eax
8010133a:	83 f8 01             	cmp    $0x1,%eax
8010133d:	74 41                	je     80101380 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010133f:	83 f8 02             	cmp    $0x2,%eax
80101342:	75 5b                	jne    8010139f <fileread+0x7f>
    ilock(f->ip);
80101344:	83 ec 0c             	sub    $0xc,%esp
80101347:	ff 73 10             	push   0x10(%ebx)
8010134a:	e8 31 07 00 00       	call   80101a80 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010134f:	57                   	push   %edi
80101350:	ff 73 14             	push   0x14(%ebx)
80101353:	56                   	push   %esi
80101354:	ff 73 10             	push   0x10(%ebx)
80101357:	e8 34 0a 00 00       	call   80101d90 <readi>
8010135c:	83 c4 20             	add    $0x20,%esp
8010135f:	89 c6                	mov    %eax,%esi
80101361:	85 c0                	test   %eax,%eax
80101363:	7e 03                	jle    80101368 <fileread+0x48>
      f->off += r;
80101365:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101368:	83 ec 0c             	sub    $0xc,%esp
8010136b:	ff 73 10             	push   0x10(%ebx)
8010136e:	e8 ed 07 00 00       	call   80101b60 <iunlock>
    return r;
80101373:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101376:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101379:	89 f0                	mov    %esi,%eax
8010137b:	5b                   	pop    %ebx
8010137c:	5e                   	pop    %esi
8010137d:	5f                   	pop    %edi
8010137e:	5d                   	pop    %ebp
8010137f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101380:	8b 43 0c             	mov    0xc(%ebx),%eax
80101383:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101386:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101389:	5b                   	pop    %ebx
8010138a:	5e                   	pop    %esi
8010138b:	5f                   	pop    %edi
8010138c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010138d:	e9 3e 26 00 00       	jmp    801039d0 <piperead>
80101392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101398:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010139d:	eb d7                	jmp    80101376 <fileread+0x56>
  panic("fileread");
8010139f:	83 ec 0c             	sub    $0xc,%esp
801013a2:	68 96 75 10 80       	push   $0x80107596
801013a7:	e8 d4 ef ff ff       	call   80100380 <panic>
801013ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801013b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801013b0:	55                   	push   %ebp
801013b1:	89 e5                	mov    %esp,%ebp
801013b3:	57                   	push   %edi
801013b4:	56                   	push   %esi
801013b5:	53                   	push   %ebx
801013b6:	83 ec 1c             	sub    $0x1c,%esp
801013b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801013bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801013bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801013c2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801013c5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801013c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801013cc:	0f 84 bd 00 00 00    	je     8010148f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801013d2:	8b 03                	mov    (%ebx),%eax
801013d4:	83 f8 01             	cmp    $0x1,%eax
801013d7:	0f 84 bf 00 00 00    	je     8010149c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801013dd:	83 f8 02             	cmp    $0x2,%eax
801013e0:	0f 85 c8 00 00 00    	jne    801014ae <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801013e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801013e9:	31 f6                	xor    %esi,%esi
    while(i < n){
801013eb:	85 c0                	test   %eax,%eax
801013ed:	7f 30                	jg     8010141f <filewrite+0x6f>
801013ef:	e9 94 00 00 00       	jmp    80101488 <filewrite+0xd8>
801013f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801013f8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801013fb:	83 ec 0c             	sub    $0xc,%esp
801013fe:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101401:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101404:	e8 57 07 00 00       	call   80101b60 <iunlock>
      end_op();
80101409:	e8 c2 1c 00 00       	call   801030d0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010140e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101411:	83 c4 10             	add    $0x10,%esp
80101414:	39 c7                	cmp    %eax,%edi
80101416:	75 5c                	jne    80101474 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101418:	01 fe                	add    %edi,%esi
    while(i < n){
8010141a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010141d:	7e 69                	jle    80101488 <filewrite+0xd8>
      int n1 = n - i;
8010141f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101422:	b8 00 06 00 00       	mov    $0x600,%eax
80101427:	29 f7                	sub    %esi,%edi
80101429:	39 c7                	cmp    %eax,%edi
8010142b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010142e:	e8 2d 1c 00 00       	call   80103060 <begin_op>
      ilock(f->ip);
80101433:	83 ec 0c             	sub    $0xc,%esp
80101436:	ff 73 10             	push   0x10(%ebx)
80101439:	e8 42 06 00 00       	call   80101a80 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010143e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101441:	57                   	push   %edi
80101442:	ff 73 14             	push   0x14(%ebx)
80101445:	01 f0                	add    %esi,%eax
80101447:	50                   	push   %eax
80101448:	ff 73 10             	push   0x10(%ebx)
8010144b:	e8 40 0a 00 00       	call   80101e90 <writei>
80101450:	83 c4 20             	add    $0x20,%esp
80101453:	85 c0                	test   %eax,%eax
80101455:	7f a1                	jg     801013f8 <filewrite+0x48>
      iunlock(f->ip);
80101457:	83 ec 0c             	sub    $0xc,%esp
8010145a:	ff 73 10             	push   0x10(%ebx)
8010145d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101460:	e8 fb 06 00 00       	call   80101b60 <iunlock>
      end_op();
80101465:	e8 66 1c 00 00       	call   801030d0 <end_op>
      if(r < 0)
8010146a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010146d:	83 c4 10             	add    $0x10,%esp
80101470:	85 c0                	test   %eax,%eax
80101472:	75 1b                	jne    8010148f <filewrite+0xdf>
        panic("short filewrite");
80101474:	83 ec 0c             	sub    $0xc,%esp
80101477:	68 9f 75 10 80       	push   $0x8010759f
8010147c:	e8 ff ee ff ff       	call   80100380 <panic>
80101481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101488:	89 f0                	mov    %esi,%eax
8010148a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010148d:	74 05                	je     80101494 <filewrite+0xe4>
8010148f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101494:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101497:	5b                   	pop    %ebx
80101498:	5e                   	pop    %esi
80101499:	5f                   	pop    %edi
8010149a:	5d                   	pop    %ebp
8010149b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010149c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010149f:	89 45 08             	mov    %eax,0x8(%ebp)
}
801014a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a5:	5b                   	pop    %ebx
801014a6:	5e                   	pop    %esi
801014a7:	5f                   	pop    %edi
801014a8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801014a9:	e9 22 24 00 00       	jmp    801038d0 <pipewrite>
  panic("filewrite");
801014ae:	83 ec 0c             	sub    $0xc,%esp
801014b1:	68 a5 75 10 80       	push   $0x801075a5
801014b6:	e8 c5 ee ff ff       	call   80100380 <panic>
801014bb:	66 90                	xchg   %ax,%ax
801014bd:	66 90                	xchg   %ax,%ax
801014bf:	90                   	nop

801014c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014c0:	55                   	push   %ebp
801014c1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801014c3:	89 d0                	mov    %edx,%eax
801014c5:	c1 e8 0c             	shr    $0xc,%eax
801014c8:	03 05 6c 16 11 80    	add    0x8011166c,%eax
{
801014ce:	89 e5                	mov    %esp,%ebp
801014d0:	56                   	push   %esi
801014d1:	53                   	push   %ebx
801014d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801014d4:	83 ec 08             	sub    $0x8,%esp
801014d7:	50                   	push   %eax
801014d8:	51                   	push   %ecx
801014d9:	e8 f2 eb ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801014de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801014e0:	c1 fb 03             	sar    $0x3,%ebx
801014e3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801014e6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801014e8:	83 e1 07             	and    $0x7,%ecx
801014eb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801014f0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801014f6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801014f8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801014fd:	85 c1                	test   %eax,%ecx
801014ff:	74 23                	je     80101524 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101501:	f7 d0                	not    %eax
  log_write(bp);
80101503:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101506:	21 c8                	and    %ecx,%eax
80101508:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010150c:	56                   	push   %esi
8010150d:	e8 2e 1d 00 00       	call   80103240 <log_write>
  brelse(bp);
80101512:	89 34 24             	mov    %esi,(%esp)
80101515:	e8 d6 ec ff ff       	call   801001f0 <brelse>
}
8010151a:	83 c4 10             	add    $0x10,%esp
8010151d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101520:	5b                   	pop    %ebx
80101521:	5e                   	pop    %esi
80101522:	5d                   	pop    %ebp
80101523:	c3                   	ret    
    panic("freeing free block");
80101524:	83 ec 0c             	sub    $0xc,%esp
80101527:	68 af 75 10 80       	push   $0x801075af
8010152c:	e8 4f ee ff ff       	call   80100380 <panic>
80101531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101538:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010153f:	90                   	nop

80101540 <balloc>:
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	57                   	push   %edi
80101544:	56                   	push   %esi
80101545:	53                   	push   %ebx
80101546:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101549:	8b 0d 54 16 11 80    	mov    0x80111654,%ecx
{
8010154f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101552:	85 c9                	test   %ecx,%ecx
80101554:	0f 84 87 00 00 00    	je     801015e1 <balloc+0xa1>
8010155a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101561:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101564:	83 ec 08             	sub    $0x8,%esp
80101567:	89 f0                	mov    %esi,%eax
80101569:	c1 f8 0c             	sar    $0xc,%eax
8010156c:	03 05 6c 16 11 80    	add    0x8011166c,%eax
80101572:	50                   	push   %eax
80101573:	ff 75 d8             	push   -0x28(%ebp)
80101576:	e8 55 eb ff ff       	call   801000d0 <bread>
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101581:	a1 54 16 11 80       	mov    0x80111654,%eax
80101586:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101589:	31 c0                	xor    %eax,%eax
8010158b:	eb 2f                	jmp    801015bc <balloc+0x7c>
8010158d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101590:	89 c1                	mov    %eax,%ecx
80101592:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101597:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010159a:	83 e1 07             	and    $0x7,%ecx
8010159d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010159f:	89 c1                	mov    %eax,%ecx
801015a1:	c1 f9 03             	sar    $0x3,%ecx
801015a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801015a9:	89 fa                	mov    %edi,%edx
801015ab:	85 df                	test   %ebx,%edi
801015ad:	74 41                	je     801015f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015af:	83 c0 01             	add    $0x1,%eax
801015b2:	83 c6 01             	add    $0x1,%esi
801015b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801015ba:	74 05                	je     801015c1 <balloc+0x81>
801015bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801015bf:	77 cf                	ja     80101590 <balloc+0x50>
    brelse(bp);
801015c1:	83 ec 0c             	sub    $0xc,%esp
801015c4:	ff 75 e4             	push   -0x1c(%ebp)
801015c7:	e8 24 ec ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801015cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801015d3:	83 c4 10             	add    $0x10,%esp
801015d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801015d9:	39 05 54 16 11 80    	cmp    %eax,0x80111654
801015df:	77 80                	ja     80101561 <balloc+0x21>
  panic("balloc: out of blocks");
801015e1:	83 ec 0c             	sub    $0xc,%esp
801015e4:	68 c2 75 10 80       	push   $0x801075c2
801015e9:	e8 92 ed ff ff       	call   80100380 <panic>
801015ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801015f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801015f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801015f6:	09 da                	or     %ebx,%edx
801015f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801015fc:	57                   	push   %edi
801015fd:	e8 3e 1c 00 00       	call   80103240 <log_write>
        brelse(bp);
80101602:	89 3c 24             	mov    %edi,(%esp)
80101605:	e8 e6 eb ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010160a:	58                   	pop    %eax
8010160b:	5a                   	pop    %edx
8010160c:	56                   	push   %esi
8010160d:	ff 75 d8             	push   -0x28(%ebp)
80101610:	e8 bb ea ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101615:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101618:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010161a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010161d:	68 00 02 00 00       	push   $0x200
80101622:	6a 00                	push   $0x0
80101624:	50                   	push   %eax
80101625:	e8 36 33 00 00       	call   80104960 <memset>
  log_write(bp);
8010162a:	89 1c 24             	mov    %ebx,(%esp)
8010162d:	e8 0e 1c 00 00       	call   80103240 <log_write>
  brelse(bp);
80101632:	89 1c 24             	mov    %ebx,(%esp)
80101635:	e8 b6 eb ff ff       	call   801001f0 <brelse>
}
8010163a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010163d:	89 f0                	mov    %esi,%eax
8010163f:	5b                   	pop    %ebx
80101640:	5e                   	pop    %esi
80101641:	5f                   	pop    %edi
80101642:	5d                   	pop    %ebp
80101643:	c3                   	ret    
80101644:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010164b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010164f:	90                   	nop

80101650 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	57                   	push   %edi
80101654:	89 c7                	mov    %eax,%edi
80101656:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101657:	31 f6                	xor    %esi,%esi
{
80101659:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010165a:	bb 34 fa 10 80       	mov    $0x8010fa34,%ebx
{
8010165f:	83 ec 28             	sub    $0x28,%esp
80101662:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101665:	68 00 fa 10 80       	push   $0x8010fa00
8010166a:	e8 31 32 00 00       	call   801048a0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010166f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101672:	83 c4 10             	add    $0x10,%esp
80101675:	eb 1b                	jmp    80101692 <iget+0x42>
80101677:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010167e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101680:	39 3b                	cmp    %edi,(%ebx)
80101682:	74 6c                	je     801016f0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101684:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010168a:	81 fb 54 16 11 80    	cmp    $0x80111654,%ebx
80101690:	73 26                	jae    801016b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101692:	8b 43 08             	mov    0x8(%ebx),%eax
80101695:	85 c0                	test   %eax,%eax
80101697:	7f e7                	jg     80101680 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101699:	85 f6                	test   %esi,%esi
8010169b:	75 e7                	jne    80101684 <iget+0x34>
8010169d:	85 c0                	test   %eax,%eax
8010169f:	75 76                	jne    80101717 <iget+0xc7>
801016a1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801016a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801016a9:	81 fb 54 16 11 80    	cmp    $0x80111654,%ebx
801016af:	72 e1                	jb     80101692 <iget+0x42>
801016b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801016b8:	85 f6                	test   %esi,%esi
801016ba:	74 79                	je     80101735 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801016bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801016bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801016c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801016c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801016cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801016d2:	68 00 fa 10 80       	push   $0x8010fa00
801016d7:	e8 64 31 00 00       	call   80104840 <release>

  return ip;
801016dc:	83 c4 10             	add    $0x10,%esp
}
801016df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016e2:	89 f0                	mov    %esi,%eax
801016e4:	5b                   	pop    %ebx
801016e5:	5e                   	pop    %esi
801016e6:	5f                   	pop    %edi
801016e7:	5d                   	pop    %ebp
801016e8:	c3                   	ret    
801016e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801016f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801016f3:	75 8f                	jne    80101684 <iget+0x34>
      release(&icache.lock);
801016f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801016f8:	83 c0 01             	add    $0x1,%eax
      return ip;
801016fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801016fd:	68 00 fa 10 80       	push   $0x8010fa00
      ip->ref++;
80101702:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101705:	e8 36 31 00 00       	call   80104840 <release>
      return ip;
8010170a:	83 c4 10             	add    $0x10,%esp
}
8010170d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101710:	89 f0                	mov    %esi,%eax
80101712:	5b                   	pop    %ebx
80101713:	5e                   	pop    %esi
80101714:	5f                   	pop    %edi
80101715:	5d                   	pop    %ebp
80101716:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101717:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010171d:	81 fb 54 16 11 80    	cmp    $0x80111654,%ebx
80101723:	73 10                	jae    80101735 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101725:	8b 43 08             	mov    0x8(%ebx),%eax
80101728:	85 c0                	test   %eax,%eax
8010172a:	0f 8f 50 ff ff ff    	jg     80101680 <iget+0x30>
80101730:	e9 68 ff ff ff       	jmp    8010169d <iget+0x4d>
    panic("iget: no inodes");
80101735:	83 ec 0c             	sub    $0xc,%esp
80101738:	68 d8 75 10 80       	push   $0x801075d8
8010173d:	e8 3e ec ff ff       	call   80100380 <panic>
80101742:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101750 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	57                   	push   %edi
80101754:	56                   	push   %esi
80101755:	89 c6                	mov    %eax,%esi
80101757:	53                   	push   %ebx
80101758:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010175b:	83 fa 0b             	cmp    $0xb,%edx
8010175e:	0f 86 8c 00 00 00    	jbe    801017f0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101764:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101767:	83 fb 7f             	cmp    $0x7f,%ebx
8010176a:	0f 87 a2 00 00 00    	ja     80101812 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101770:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101776:	85 c0                	test   %eax,%eax
80101778:	74 5e                	je     801017d8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010177a:	83 ec 08             	sub    $0x8,%esp
8010177d:	50                   	push   %eax
8010177e:	ff 36                	push   (%esi)
80101780:	e8 4b e9 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101785:	83 c4 10             	add    $0x10,%esp
80101788:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010178c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010178e:	8b 3b                	mov    (%ebx),%edi
80101790:	85 ff                	test   %edi,%edi
80101792:	74 1c                	je     801017b0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101794:	83 ec 0c             	sub    $0xc,%esp
80101797:	52                   	push   %edx
80101798:	e8 53 ea ff ff       	call   801001f0 <brelse>
8010179d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801017a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017a3:	89 f8                	mov    %edi,%eax
801017a5:	5b                   	pop    %ebx
801017a6:	5e                   	pop    %esi
801017a7:	5f                   	pop    %edi
801017a8:	5d                   	pop    %ebp
801017a9:	c3                   	ret    
801017aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801017b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801017b3:	8b 06                	mov    (%esi),%eax
801017b5:	e8 86 fd ff ff       	call   80101540 <balloc>
      log_write(bp);
801017ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801017bd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801017c0:	89 03                	mov    %eax,(%ebx)
801017c2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801017c4:	52                   	push   %edx
801017c5:	e8 76 1a 00 00       	call   80103240 <log_write>
801017ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801017cd:	83 c4 10             	add    $0x10,%esp
801017d0:	eb c2                	jmp    80101794 <bmap+0x44>
801017d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801017d8:	8b 06                	mov    (%esi),%eax
801017da:	e8 61 fd ff ff       	call   80101540 <balloc>
801017df:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801017e5:	eb 93                	jmp    8010177a <bmap+0x2a>
801017e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017ee:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801017f0:	8d 5a 14             	lea    0x14(%edx),%ebx
801017f3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801017f7:	85 ff                	test   %edi,%edi
801017f9:	75 a5                	jne    801017a0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801017fb:	8b 00                	mov    (%eax),%eax
801017fd:	e8 3e fd ff ff       	call   80101540 <balloc>
80101802:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101806:	89 c7                	mov    %eax,%edi
}
80101808:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010180b:	5b                   	pop    %ebx
8010180c:	89 f8                	mov    %edi,%eax
8010180e:	5e                   	pop    %esi
8010180f:	5f                   	pop    %edi
80101810:	5d                   	pop    %ebp
80101811:	c3                   	ret    
  panic("bmap: out of range");
80101812:	83 ec 0c             	sub    $0xc,%esp
80101815:	68 e8 75 10 80       	push   $0x801075e8
8010181a:	e8 61 eb ff ff       	call   80100380 <panic>
8010181f:	90                   	nop

80101820 <readsb>:
{
80101820:	55                   	push   %ebp
80101821:	89 e5                	mov    %esp,%ebp
80101823:	56                   	push   %esi
80101824:	53                   	push   %ebx
80101825:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101828:	83 ec 08             	sub    $0x8,%esp
8010182b:	6a 01                	push   $0x1
8010182d:	ff 75 08             	push   0x8(%ebp)
80101830:	e8 9b e8 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101835:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101838:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010183a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010183d:	6a 1c                	push   $0x1c
8010183f:	50                   	push   %eax
80101840:	56                   	push   %esi
80101841:	e8 ba 31 00 00       	call   80104a00 <memmove>
  brelse(bp);
80101846:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101849:	83 c4 10             	add    $0x10,%esp
}
8010184c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010184f:	5b                   	pop    %ebx
80101850:	5e                   	pop    %esi
80101851:	5d                   	pop    %ebp
  brelse(bp);
80101852:	e9 99 e9 ff ff       	jmp    801001f0 <brelse>
80101857:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010185e:	66 90                	xchg   %ax,%ax

80101860 <iinit>:
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	53                   	push   %ebx
80101864:	bb 40 fa 10 80       	mov    $0x8010fa40,%ebx
80101869:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010186c:	68 fb 75 10 80       	push   $0x801075fb
80101871:	68 00 fa 10 80       	push   $0x8010fa00
80101876:	e8 55 2e 00 00       	call   801046d0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010187b:	83 c4 10             	add    $0x10,%esp
8010187e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101880:	83 ec 08             	sub    $0x8,%esp
80101883:	68 02 76 10 80       	push   $0x80107602
80101888:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101889:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010188f:	e8 0c 2d 00 00       	call   801045a0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101894:	83 c4 10             	add    $0x10,%esp
80101897:	81 fb 60 16 11 80    	cmp    $0x80111660,%ebx
8010189d:	75 e1                	jne    80101880 <iinit+0x20>
  bp = bread(dev, 1);
8010189f:	83 ec 08             	sub    $0x8,%esp
801018a2:	6a 01                	push   $0x1
801018a4:	ff 75 08             	push   0x8(%ebp)
801018a7:	e8 24 e8 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801018ac:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801018af:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801018b1:	8d 40 5c             	lea    0x5c(%eax),%eax
801018b4:	6a 1c                	push   $0x1c
801018b6:	50                   	push   %eax
801018b7:	68 54 16 11 80       	push   $0x80111654
801018bc:	e8 3f 31 00 00       	call   80104a00 <memmove>
  brelse(bp);
801018c1:	89 1c 24             	mov    %ebx,(%esp)
801018c4:	e8 27 e9 ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801018c9:	ff 35 6c 16 11 80    	push   0x8011166c
801018cf:	ff 35 68 16 11 80    	push   0x80111668
801018d5:	ff 35 64 16 11 80    	push   0x80111664
801018db:	ff 35 60 16 11 80    	push   0x80111660
801018e1:	ff 35 5c 16 11 80    	push   0x8011165c
801018e7:	ff 35 58 16 11 80    	push   0x80111658
801018ed:	ff 35 54 16 11 80    	push   0x80111654
801018f3:	68 68 76 10 80       	push   $0x80107668
801018f8:	e8 a3 ed ff ff       	call   801006a0 <cprintf>
}
801018fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101900:	83 c4 30             	add    $0x30,%esp
80101903:	c9                   	leave  
80101904:	c3                   	ret    
80101905:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010190c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101910 <ialloc>:
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	57                   	push   %edi
80101914:	56                   	push   %esi
80101915:	53                   	push   %ebx
80101916:	83 ec 1c             	sub    $0x1c,%esp
80101919:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010191c:	83 3d 5c 16 11 80 01 	cmpl   $0x1,0x8011165c
{
80101923:	8b 75 08             	mov    0x8(%ebp),%esi
80101926:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101929:	0f 86 91 00 00 00    	jbe    801019c0 <ialloc+0xb0>
8010192f:	bf 01 00 00 00       	mov    $0x1,%edi
80101934:	eb 21                	jmp    80101957 <ialloc+0x47>
80101936:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010193d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101940:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101943:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101946:	53                   	push   %ebx
80101947:	e8 a4 e8 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010194c:	83 c4 10             	add    $0x10,%esp
8010194f:	3b 3d 5c 16 11 80    	cmp    0x8011165c,%edi
80101955:	73 69                	jae    801019c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101957:	89 f8                	mov    %edi,%eax
80101959:	83 ec 08             	sub    $0x8,%esp
8010195c:	c1 e8 03             	shr    $0x3,%eax
8010195f:	03 05 68 16 11 80    	add    0x80111668,%eax
80101965:	50                   	push   %eax
80101966:	56                   	push   %esi
80101967:	e8 64 e7 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010196c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010196f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101971:	89 f8                	mov    %edi,%eax
80101973:	83 e0 07             	and    $0x7,%eax
80101976:	c1 e0 06             	shl    $0x6,%eax
80101979:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010197d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101981:	75 bd                	jne    80101940 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101983:	83 ec 04             	sub    $0x4,%esp
80101986:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101989:	6a 40                	push   $0x40
8010198b:	6a 00                	push   $0x0
8010198d:	51                   	push   %ecx
8010198e:	e8 cd 2f 00 00       	call   80104960 <memset>
      dip->type = type;
80101993:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101997:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010199a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010199d:	89 1c 24             	mov    %ebx,(%esp)
801019a0:	e8 9b 18 00 00       	call   80103240 <log_write>
      brelse(bp);
801019a5:	89 1c 24             	mov    %ebx,(%esp)
801019a8:	e8 43 e8 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801019ad:	83 c4 10             	add    $0x10,%esp
}
801019b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801019b3:	89 fa                	mov    %edi,%edx
}
801019b5:	5b                   	pop    %ebx
      return iget(dev, inum);
801019b6:	89 f0                	mov    %esi,%eax
}
801019b8:	5e                   	pop    %esi
801019b9:	5f                   	pop    %edi
801019ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801019bb:	e9 90 fc ff ff       	jmp    80101650 <iget>
  panic("ialloc: no inodes");
801019c0:	83 ec 0c             	sub    $0xc,%esp
801019c3:	68 08 76 10 80       	push   $0x80107608
801019c8:	e8 b3 e9 ff ff       	call   80100380 <panic>
801019cd:	8d 76 00             	lea    0x0(%esi),%esi

801019d0 <iupdate>:
{
801019d0:	55                   	push   %ebp
801019d1:	89 e5                	mov    %esp,%ebp
801019d3:	56                   	push   %esi
801019d4:	53                   	push   %ebx
801019d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801019d8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801019db:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801019de:	83 ec 08             	sub    $0x8,%esp
801019e1:	c1 e8 03             	shr    $0x3,%eax
801019e4:	03 05 68 16 11 80    	add    0x80111668,%eax
801019ea:	50                   	push   %eax
801019eb:	ff 73 a4             	push   -0x5c(%ebx)
801019ee:	e8 dd e6 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801019f3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801019f7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801019fa:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801019fc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801019ff:	83 e0 07             	and    $0x7,%eax
80101a02:	c1 e0 06             	shl    $0x6,%eax
80101a05:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101a09:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101a0c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a10:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101a13:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101a17:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101a1b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101a1f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101a23:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101a27:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101a2a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a2d:	6a 34                	push   $0x34
80101a2f:	53                   	push   %ebx
80101a30:	50                   	push   %eax
80101a31:	e8 ca 2f 00 00       	call   80104a00 <memmove>
  log_write(bp);
80101a36:	89 34 24             	mov    %esi,(%esp)
80101a39:	e8 02 18 00 00       	call   80103240 <log_write>
  brelse(bp);
80101a3e:	89 75 08             	mov    %esi,0x8(%ebp)
80101a41:	83 c4 10             	add    $0x10,%esp
}
80101a44:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a47:	5b                   	pop    %ebx
80101a48:	5e                   	pop    %esi
80101a49:	5d                   	pop    %ebp
  brelse(bp);
80101a4a:	e9 a1 e7 ff ff       	jmp    801001f0 <brelse>
80101a4f:	90                   	nop

80101a50 <idup>:
{
80101a50:	55                   	push   %ebp
80101a51:	89 e5                	mov    %esp,%ebp
80101a53:	53                   	push   %ebx
80101a54:	83 ec 10             	sub    $0x10,%esp
80101a57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101a5a:	68 00 fa 10 80       	push   $0x8010fa00
80101a5f:	e8 3c 2e 00 00       	call   801048a0 <acquire>
  ip->ref++;
80101a64:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101a68:	c7 04 24 00 fa 10 80 	movl   $0x8010fa00,(%esp)
80101a6f:	e8 cc 2d 00 00       	call   80104840 <release>
}
80101a74:	89 d8                	mov    %ebx,%eax
80101a76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a79:	c9                   	leave  
80101a7a:	c3                   	ret    
80101a7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a7f:	90                   	nop

80101a80 <ilock>:
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	56                   	push   %esi
80101a84:	53                   	push   %ebx
80101a85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101a88:	85 db                	test   %ebx,%ebx
80101a8a:	0f 84 b7 00 00 00    	je     80101b47 <ilock+0xc7>
80101a90:	8b 53 08             	mov    0x8(%ebx),%edx
80101a93:	85 d2                	test   %edx,%edx
80101a95:	0f 8e ac 00 00 00    	jle    80101b47 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101a9b:	83 ec 0c             	sub    $0xc,%esp
80101a9e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101aa1:	50                   	push   %eax
80101aa2:	e8 39 2b 00 00       	call   801045e0 <acquiresleep>
  if(ip->valid == 0){
80101aa7:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101aaa:	83 c4 10             	add    $0x10,%esp
80101aad:	85 c0                	test   %eax,%eax
80101aaf:	74 0f                	je     80101ac0 <ilock+0x40>
}
80101ab1:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ab4:	5b                   	pop    %ebx
80101ab5:	5e                   	pop    %esi
80101ab6:	5d                   	pop    %ebp
80101ab7:	c3                   	ret    
80101ab8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101abf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101ac0:	8b 43 04             	mov    0x4(%ebx),%eax
80101ac3:	83 ec 08             	sub    $0x8,%esp
80101ac6:	c1 e8 03             	shr    $0x3,%eax
80101ac9:	03 05 68 16 11 80    	add    0x80111668,%eax
80101acf:	50                   	push   %eax
80101ad0:	ff 33                	push   (%ebx)
80101ad2:	e8 f9 e5 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101ad7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101ada:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101adc:	8b 43 04             	mov    0x4(%ebx),%eax
80101adf:	83 e0 07             	and    $0x7,%eax
80101ae2:	c1 e0 06             	shl    $0x6,%eax
80101ae5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101ae9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101aec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101aef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101af3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101af7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101afb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101aff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101b03:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101b07:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101b0b:	8b 50 fc             	mov    -0x4(%eax),%edx
80101b0e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b11:	6a 34                	push   $0x34
80101b13:	50                   	push   %eax
80101b14:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101b17:	50                   	push   %eax
80101b18:	e8 e3 2e 00 00       	call   80104a00 <memmove>
    brelse(bp);
80101b1d:	89 34 24             	mov    %esi,(%esp)
80101b20:	e8 cb e6 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101b25:	83 c4 10             	add    $0x10,%esp
80101b28:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101b2d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101b34:	0f 85 77 ff ff ff    	jne    80101ab1 <ilock+0x31>
      panic("ilock: no type");
80101b3a:	83 ec 0c             	sub    $0xc,%esp
80101b3d:	68 20 76 10 80       	push   $0x80107620
80101b42:	e8 39 e8 ff ff       	call   80100380 <panic>
    panic("ilock");
80101b47:	83 ec 0c             	sub    $0xc,%esp
80101b4a:	68 1a 76 10 80       	push   $0x8010761a
80101b4f:	e8 2c e8 ff ff       	call   80100380 <panic>
80101b54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b5f:	90                   	nop

80101b60 <iunlock>:
{
80101b60:	55                   	push   %ebp
80101b61:	89 e5                	mov    %esp,%ebp
80101b63:	56                   	push   %esi
80101b64:	53                   	push   %ebx
80101b65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b68:	85 db                	test   %ebx,%ebx
80101b6a:	74 28                	je     80101b94 <iunlock+0x34>
80101b6c:	83 ec 0c             	sub    $0xc,%esp
80101b6f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101b72:	56                   	push   %esi
80101b73:	e8 08 2b 00 00       	call   80104680 <holdingsleep>
80101b78:	83 c4 10             	add    $0x10,%esp
80101b7b:	85 c0                	test   %eax,%eax
80101b7d:	74 15                	je     80101b94 <iunlock+0x34>
80101b7f:	8b 43 08             	mov    0x8(%ebx),%eax
80101b82:	85 c0                	test   %eax,%eax
80101b84:	7e 0e                	jle    80101b94 <iunlock+0x34>
  releasesleep(&ip->lock);
80101b86:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101b89:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b8c:	5b                   	pop    %ebx
80101b8d:	5e                   	pop    %esi
80101b8e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101b8f:	e9 ac 2a 00 00       	jmp    80104640 <releasesleep>
    panic("iunlock");
80101b94:	83 ec 0c             	sub    $0xc,%esp
80101b97:	68 2f 76 10 80       	push   $0x8010762f
80101b9c:	e8 df e7 ff ff       	call   80100380 <panic>
80101ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ba8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101baf:	90                   	nop

80101bb0 <iput>:
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 28             	sub    $0x28,%esp
80101bb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101bbc:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101bbf:	57                   	push   %edi
80101bc0:	e8 1b 2a 00 00       	call   801045e0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101bc5:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101bc8:	83 c4 10             	add    $0x10,%esp
80101bcb:	85 d2                	test   %edx,%edx
80101bcd:	74 07                	je     80101bd6 <iput+0x26>
80101bcf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101bd4:	74 32                	je     80101c08 <iput+0x58>
  releasesleep(&ip->lock);
80101bd6:	83 ec 0c             	sub    $0xc,%esp
80101bd9:	57                   	push   %edi
80101bda:	e8 61 2a 00 00       	call   80104640 <releasesleep>
  acquire(&icache.lock);
80101bdf:	c7 04 24 00 fa 10 80 	movl   $0x8010fa00,(%esp)
80101be6:	e8 b5 2c 00 00       	call   801048a0 <acquire>
  ip->ref--;
80101beb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101bef:	83 c4 10             	add    $0x10,%esp
80101bf2:	c7 45 08 00 fa 10 80 	movl   $0x8010fa00,0x8(%ebp)
}
80101bf9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bfc:	5b                   	pop    %ebx
80101bfd:	5e                   	pop    %esi
80101bfe:	5f                   	pop    %edi
80101bff:	5d                   	pop    %ebp
  release(&icache.lock);
80101c00:	e9 3b 2c 00 00       	jmp    80104840 <release>
80101c05:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101c08:	83 ec 0c             	sub    $0xc,%esp
80101c0b:	68 00 fa 10 80       	push   $0x8010fa00
80101c10:	e8 8b 2c 00 00       	call   801048a0 <acquire>
    int r = ip->ref;
80101c15:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101c18:	c7 04 24 00 fa 10 80 	movl   $0x8010fa00,(%esp)
80101c1f:	e8 1c 2c 00 00       	call   80104840 <release>
    if(r == 1){
80101c24:	83 c4 10             	add    $0x10,%esp
80101c27:	83 fe 01             	cmp    $0x1,%esi
80101c2a:	75 aa                	jne    80101bd6 <iput+0x26>
80101c2c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101c32:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101c35:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101c38:	89 cf                	mov    %ecx,%edi
80101c3a:	eb 0b                	jmp    80101c47 <iput+0x97>
80101c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c40:	83 c6 04             	add    $0x4,%esi
80101c43:	39 fe                	cmp    %edi,%esi
80101c45:	74 19                	je     80101c60 <iput+0xb0>
    if(ip->addrs[i]){
80101c47:	8b 16                	mov    (%esi),%edx
80101c49:	85 d2                	test   %edx,%edx
80101c4b:	74 f3                	je     80101c40 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101c4d:	8b 03                	mov    (%ebx),%eax
80101c4f:	e8 6c f8 ff ff       	call   801014c0 <bfree>
      ip->addrs[i] = 0;
80101c54:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101c5a:	eb e4                	jmp    80101c40 <iput+0x90>
80101c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101c60:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101c66:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101c69:	85 c0                	test   %eax,%eax
80101c6b:	75 2d                	jne    80101c9a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101c6d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101c70:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101c77:	53                   	push   %ebx
80101c78:	e8 53 fd ff ff       	call   801019d0 <iupdate>
      ip->type = 0;
80101c7d:	31 c0                	xor    %eax,%eax
80101c7f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101c83:	89 1c 24             	mov    %ebx,(%esp)
80101c86:	e8 45 fd ff ff       	call   801019d0 <iupdate>
      ip->valid = 0;
80101c8b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101c92:	83 c4 10             	add    $0x10,%esp
80101c95:	e9 3c ff ff ff       	jmp    80101bd6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101c9a:	83 ec 08             	sub    $0x8,%esp
80101c9d:	50                   	push   %eax
80101c9e:	ff 33                	push   (%ebx)
80101ca0:	e8 2b e4 ff ff       	call   801000d0 <bread>
80101ca5:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101ca8:	83 c4 10             	add    $0x10,%esp
80101cab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101cb1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101cb4:	8d 70 5c             	lea    0x5c(%eax),%esi
80101cb7:	89 cf                	mov    %ecx,%edi
80101cb9:	eb 0c                	jmp    80101cc7 <iput+0x117>
80101cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101cbf:	90                   	nop
80101cc0:	83 c6 04             	add    $0x4,%esi
80101cc3:	39 f7                	cmp    %esi,%edi
80101cc5:	74 0f                	je     80101cd6 <iput+0x126>
      if(a[j])
80101cc7:	8b 16                	mov    (%esi),%edx
80101cc9:	85 d2                	test   %edx,%edx
80101ccb:	74 f3                	je     80101cc0 <iput+0x110>
        bfree(ip->dev, a[j]);
80101ccd:	8b 03                	mov    (%ebx),%eax
80101ccf:	e8 ec f7 ff ff       	call   801014c0 <bfree>
80101cd4:	eb ea                	jmp    80101cc0 <iput+0x110>
    brelse(bp);
80101cd6:	83 ec 0c             	sub    $0xc,%esp
80101cd9:	ff 75 e4             	push   -0x1c(%ebp)
80101cdc:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101cdf:	e8 0c e5 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101ce4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101cea:	8b 03                	mov    (%ebx),%eax
80101cec:	e8 cf f7 ff ff       	call   801014c0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101cf1:	83 c4 10             	add    $0x10,%esp
80101cf4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101cfb:	00 00 00 
80101cfe:	e9 6a ff ff ff       	jmp    80101c6d <iput+0xbd>
80101d03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101d10 <iunlockput>:
{
80101d10:	55                   	push   %ebp
80101d11:	89 e5                	mov    %esp,%ebp
80101d13:	56                   	push   %esi
80101d14:	53                   	push   %ebx
80101d15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101d18:	85 db                	test   %ebx,%ebx
80101d1a:	74 34                	je     80101d50 <iunlockput+0x40>
80101d1c:	83 ec 0c             	sub    $0xc,%esp
80101d1f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101d22:	56                   	push   %esi
80101d23:	e8 58 29 00 00       	call   80104680 <holdingsleep>
80101d28:	83 c4 10             	add    $0x10,%esp
80101d2b:	85 c0                	test   %eax,%eax
80101d2d:	74 21                	je     80101d50 <iunlockput+0x40>
80101d2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101d32:	85 c0                	test   %eax,%eax
80101d34:	7e 1a                	jle    80101d50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101d36:	83 ec 0c             	sub    $0xc,%esp
80101d39:	56                   	push   %esi
80101d3a:	e8 01 29 00 00       	call   80104640 <releasesleep>
  iput(ip);
80101d3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101d42:	83 c4 10             	add    $0x10,%esp
}
80101d45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d48:	5b                   	pop    %ebx
80101d49:	5e                   	pop    %esi
80101d4a:	5d                   	pop    %ebp
  iput(ip);
80101d4b:	e9 60 fe ff ff       	jmp    80101bb0 <iput>
    panic("iunlock");
80101d50:	83 ec 0c             	sub    $0xc,%esp
80101d53:	68 2f 76 10 80       	push   $0x8010762f
80101d58:	e8 23 e6 ff ff       	call   80100380 <panic>
80101d5d:	8d 76 00             	lea    0x0(%esi),%esi

80101d60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101d60:	55                   	push   %ebp
80101d61:	89 e5                	mov    %esp,%ebp
80101d63:	8b 55 08             	mov    0x8(%ebp),%edx
80101d66:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101d69:	8b 0a                	mov    (%edx),%ecx
80101d6b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101d6e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101d71:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101d74:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101d78:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101d7b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101d7f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101d83:	8b 52 58             	mov    0x58(%edx),%edx
80101d86:	89 50 10             	mov    %edx,0x10(%eax)
}
80101d89:	5d                   	pop    %ebp
80101d8a:	c3                   	ret    
80101d8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d8f:	90                   	nop

80101d90 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	56                   	push   %esi
80101d95:	53                   	push   %ebx
80101d96:	83 ec 1c             	sub    $0x1c,%esp
80101d99:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101d9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d9f:	8b 75 10             	mov    0x10(%ebp),%esi
80101da2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101da5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101da8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101dad:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101db0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101db3:	0f 84 a7 00 00 00    	je     80101e60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101db9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101dbc:	8b 40 58             	mov    0x58(%eax),%eax
80101dbf:	39 c6                	cmp    %eax,%esi
80101dc1:	0f 87 ba 00 00 00    	ja     80101e81 <readi+0xf1>
80101dc7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101dca:	31 c9                	xor    %ecx,%ecx
80101dcc:	89 da                	mov    %ebx,%edx
80101dce:	01 f2                	add    %esi,%edx
80101dd0:	0f 92 c1             	setb   %cl
80101dd3:	89 cf                	mov    %ecx,%edi
80101dd5:	0f 82 a6 00 00 00    	jb     80101e81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101ddb:	89 c1                	mov    %eax,%ecx
80101ddd:	29 f1                	sub    %esi,%ecx
80101ddf:	39 d0                	cmp    %edx,%eax
80101de1:	0f 43 cb             	cmovae %ebx,%ecx
80101de4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101de7:	85 c9                	test   %ecx,%ecx
80101de9:	74 67                	je     80101e52 <readi+0xc2>
80101deb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101def:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101df0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101df3:	89 f2                	mov    %esi,%edx
80101df5:	c1 ea 09             	shr    $0x9,%edx
80101df8:	89 d8                	mov    %ebx,%eax
80101dfa:	e8 51 f9 ff ff       	call   80101750 <bmap>
80101dff:	83 ec 08             	sub    $0x8,%esp
80101e02:	50                   	push   %eax
80101e03:	ff 33                	push   (%ebx)
80101e05:	e8 c6 e2 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101e0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101e0d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e12:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101e14:	89 f0                	mov    %esi,%eax
80101e16:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e1b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101e1d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101e20:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101e22:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101e26:	39 d9                	cmp    %ebx,%ecx
80101e28:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101e2b:	83 c4 0c             	add    $0xc,%esp
80101e2e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e2f:	01 df                	add    %ebx,%edi
80101e31:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101e33:	50                   	push   %eax
80101e34:	ff 75 e0             	push   -0x20(%ebp)
80101e37:	e8 c4 2b 00 00       	call   80104a00 <memmove>
    brelse(bp);
80101e3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e3f:	89 14 24             	mov    %edx,(%esp)
80101e42:	e8 a9 e3 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101e4a:	83 c4 10             	add    $0x10,%esp
80101e4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101e50:	77 9e                	ja     80101df0 <readi+0x60>
  }
  return n;
80101e52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101e55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e58:	5b                   	pop    %ebx
80101e59:	5e                   	pop    %esi
80101e5a:	5f                   	pop    %edi
80101e5b:	5d                   	pop    %ebp
80101e5c:	c3                   	ret    
80101e5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101e60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101e64:	66 83 f8 09          	cmp    $0x9,%ax
80101e68:	77 17                	ja     80101e81 <readi+0xf1>
80101e6a:	8b 04 c5 a0 f9 10 80 	mov    -0x7fef0660(,%eax,8),%eax
80101e71:	85 c0                	test   %eax,%eax
80101e73:	74 0c                	je     80101e81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101e75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101e78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e7b:	5b                   	pop    %ebx
80101e7c:	5e                   	pop    %esi
80101e7d:	5f                   	pop    %edi
80101e7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101e7f:	ff e0                	jmp    *%eax
      return -1;
80101e81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e86:	eb cd                	jmp    80101e55 <readi+0xc5>
80101e88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e8f:	90                   	nop

80101e90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101e90:	55                   	push   %ebp
80101e91:	89 e5                	mov    %esp,%ebp
80101e93:	57                   	push   %edi
80101e94:	56                   	push   %esi
80101e95:	53                   	push   %ebx
80101e96:	83 ec 1c             	sub    $0x1c,%esp
80101e99:	8b 45 08             	mov    0x8(%ebp),%eax
80101e9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101e9f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ea2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ea7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101eaa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ead:	8b 75 10             	mov    0x10(%ebp),%esi
80101eb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101eb3:	0f 84 b7 00 00 00    	je     80101f70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101eb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ebc:	3b 70 58             	cmp    0x58(%eax),%esi
80101ebf:	0f 87 e7 00 00 00    	ja     80101fac <writei+0x11c>
80101ec5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101ec8:	31 d2                	xor    %edx,%edx
80101eca:	89 f8                	mov    %edi,%eax
80101ecc:	01 f0                	add    %esi,%eax
80101ece:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ed1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ed6:	0f 87 d0 00 00 00    	ja     80101fac <writei+0x11c>
80101edc:	85 d2                	test   %edx,%edx
80101ede:	0f 85 c8 00 00 00    	jne    80101fac <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ee4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101eeb:	85 ff                	test   %edi,%edi
80101eed:	74 72                	je     80101f61 <writei+0xd1>
80101eef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ef0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ef3:	89 f2                	mov    %esi,%edx
80101ef5:	c1 ea 09             	shr    $0x9,%edx
80101ef8:	89 f8                	mov    %edi,%eax
80101efa:	e8 51 f8 ff ff       	call   80101750 <bmap>
80101eff:	83 ec 08             	sub    $0x8,%esp
80101f02:	50                   	push   %eax
80101f03:	ff 37                	push   (%edi)
80101f05:	e8 c6 e1 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101f0a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101f0f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101f12:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f15:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101f17:	89 f0                	mov    %esi,%eax
80101f19:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f1e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101f20:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101f24:	39 d9                	cmp    %ebx,%ecx
80101f26:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101f29:	83 c4 0c             	add    $0xc,%esp
80101f2c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f2d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101f2f:	ff 75 dc             	push   -0x24(%ebp)
80101f32:	50                   	push   %eax
80101f33:	e8 c8 2a 00 00       	call   80104a00 <memmove>
    log_write(bp);
80101f38:	89 3c 24             	mov    %edi,(%esp)
80101f3b:	e8 00 13 00 00       	call   80103240 <log_write>
    brelse(bp);
80101f40:	89 3c 24             	mov    %edi,(%esp)
80101f43:	e8 a8 e2 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101f4b:	83 c4 10             	add    $0x10,%esp
80101f4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101f51:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101f54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101f57:	77 97                	ja     80101ef0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101f59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101f5c:	3b 70 58             	cmp    0x58(%eax),%esi
80101f5f:	77 37                	ja     80101f98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101f61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101f64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f67:	5b                   	pop    %ebx
80101f68:	5e                   	pop    %esi
80101f69:	5f                   	pop    %edi
80101f6a:	5d                   	pop    %ebp
80101f6b:	c3                   	ret    
80101f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101f70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101f74:	66 83 f8 09          	cmp    $0x9,%ax
80101f78:	77 32                	ja     80101fac <writei+0x11c>
80101f7a:	8b 04 c5 a4 f9 10 80 	mov    -0x7fef065c(,%eax,8),%eax
80101f81:	85 c0                	test   %eax,%eax
80101f83:	74 27                	je     80101fac <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101f85:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101f88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f8b:	5b                   	pop    %ebx
80101f8c:	5e                   	pop    %esi
80101f8d:	5f                   	pop    %edi
80101f8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101f8f:	ff e0                	jmp    *%eax
80101f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101f98:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101f9b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101f9e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101fa1:	50                   	push   %eax
80101fa2:	e8 29 fa ff ff       	call   801019d0 <iupdate>
80101fa7:	83 c4 10             	add    $0x10,%esp
80101faa:	eb b5                	jmp    80101f61 <writei+0xd1>
      return -1;
80101fac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fb1:	eb b1                	jmp    80101f64 <writei+0xd4>
80101fb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101fc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101fc0:	55                   	push   %ebp
80101fc1:	89 e5                	mov    %esp,%ebp
80101fc3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101fc6:	6a 0e                	push   $0xe
80101fc8:	ff 75 0c             	push   0xc(%ebp)
80101fcb:	ff 75 08             	push   0x8(%ebp)
80101fce:	e8 9d 2a 00 00       	call   80104a70 <strncmp>
}
80101fd3:	c9                   	leave  
80101fd4:	c3                   	ret    
80101fd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101fe0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	57                   	push   %edi
80101fe4:	56                   	push   %esi
80101fe5:	53                   	push   %ebx
80101fe6:	83 ec 1c             	sub    $0x1c,%esp
80101fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101fec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101ff1:	0f 85 85 00 00 00    	jne    8010207c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101ff7:	8b 53 58             	mov    0x58(%ebx),%edx
80101ffa:	31 ff                	xor    %edi,%edi
80101ffc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fff:	85 d2                	test   %edx,%edx
80102001:	74 3e                	je     80102041 <dirlookup+0x61>
80102003:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102007:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102008:	6a 10                	push   $0x10
8010200a:	57                   	push   %edi
8010200b:	56                   	push   %esi
8010200c:	53                   	push   %ebx
8010200d:	e8 7e fd ff ff       	call   80101d90 <readi>
80102012:	83 c4 10             	add    $0x10,%esp
80102015:	83 f8 10             	cmp    $0x10,%eax
80102018:	75 55                	jne    8010206f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
8010201a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010201f:	74 18                	je     80102039 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80102021:	83 ec 04             	sub    $0x4,%esp
80102024:	8d 45 da             	lea    -0x26(%ebp),%eax
80102027:	6a 0e                	push   $0xe
80102029:	50                   	push   %eax
8010202a:	ff 75 0c             	push   0xc(%ebp)
8010202d:	e8 3e 2a 00 00       	call   80104a70 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80102032:	83 c4 10             	add    $0x10,%esp
80102035:	85 c0                	test   %eax,%eax
80102037:	74 17                	je     80102050 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102039:	83 c7 10             	add    $0x10,%edi
8010203c:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010203f:	72 c7                	jb     80102008 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80102041:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80102044:	31 c0                	xor    %eax,%eax
}
80102046:	5b                   	pop    %ebx
80102047:	5e                   	pop    %esi
80102048:	5f                   	pop    %edi
80102049:	5d                   	pop    %ebp
8010204a:	c3                   	ret    
8010204b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010204f:	90                   	nop
      if(poff)
80102050:	8b 45 10             	mov    0x10(%ebp),%eax
80102053:	85 c0                	test   %eax,%eax
80102055:	74 05                	je     8010205c <dirlookup+0x7c>
        *poff = off;
80102057:	8b 45 10             	mov    0x10(%ebp),%eax
8010205a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
8010205c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80102060:	8b 03                	mov    (%ebx),%eax
80102062:	e8 e9 f5 ff ff       	call   80101650 <iget>
}
80102067:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010206a:	5b                   	pop    %ebx
8010206b:	5e                   	pop    %esi
8010206c:	5f                   	pop    %edi
8010206d:	5d                   	pop    %ebp
8010206e:	c3                   	ret    
      panic("dirlookup read");
8010206f:	83 ec 0c             	sub    $0xc,%esp
80102072:	68 49 76 10 80       	push   $0x80107649
80102077:	e8 04 e3 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
8010207c:	83 ec 0c             	sub    $0xc,%esp
8010207f:	68 37 76 10 80       	push   $0x80107637
80102084:	e8 f7 e2 ff ff       	call   80100380 <panic>
80102089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102090 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102090:	55                   	push   %ebp
80102091:	89 e5                	mov    %esp,%ebp
80102093:	57                   	push   %edi
80102094:	56                   	push   %esi
80102095:	53                   	push   %ebx
80102096:	89 c3                	mov    %eax,%ebx
80102098:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010209b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
8010209e:	89 55 dc             	mov    %edx,-0x24(%ebp)
801020a1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
801020a4:	0f 84 64 01 00 00    	je     8010220e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
801020aa:	e8 c1 1b 00 00       	call   80103c70 <myproc>
  acquire(&icache.lock);
801020af:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
801020b2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
801020b5:	68 00 fa 10 80       	push   $0x8010fa00
801020ba:	e8 e1 27 00 00       	call   801048a0 <acquire>
  ip->ref++;
801020bf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
801020c3:	c7 04 24 00 fa 10 80 	movl   $0x8010fa00,(%esp)
801020ca:	e8 71 27 00 00       	call   80104840 <release>
801020cf:	83 c4 10             	add    $0x10,%esp
801020d2:	eb 07                	jmp    801020db <namex+0x4b>
801020d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801020d8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
801020db:	0f b6 03             	movzbl (%ebx),%eax
801020de:	3c 2f                	cmp    $0x2f,%al
801020e0:	74 f6                	je     801020d8 <namex+0x48>
  if(*path == 0)
801020e2:	84 c0                	test   %al,%al
801020e4:	0f 84 06 01 00 00    	je     801021f0 <namex+0x160>
  while(*path != '/' && *path != 0)
801020ea:	0f b6 03             	movzbl (%ebx),%eax
801020ed:	84 c0                	test   %al,%al
801020ef:	0f 84 10 01 00 00    	je     80102205 <namex+0x175>
801020f5:	89 df                	mov    %ebx,%edi
801020f7:	3c 2f                	cmp    $0x2f,%al
801020f9:	0f 84 06 01 00 00    	je     80102205 <namex+0x175>
801020ff:	90                   	nop
80102100:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80102104:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80102107:	3c 2f                	cmp    $0x2f,%al
80102109:	74 04                	je     8010210f <namex+0x7f>
8010210b:	84 c0                	test   %al,%al
8010210d:	75 f1                	jne    80102100 <namex+0x70>
  len = path - s;
8010210f:	89 f8                	mov    %edi,%eax
80102111:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80102113:	83 f8 0d             	cmp    $0xd,%eax
80102116:	0f 8e ac 00 00 00    	jle    801021c8 <namex+0x138>
    memmove(name, s, DIRSIZ);
8010211c:	83 ec 04             	sub    $0x4,%esp
8010211f:	6a 0e                	push   $0xe
80102121:	53                   	push   %ebx
    path++;
80102122:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80102124:	ff 75 e4             	push   -0x1c(%ebp)
80102127:	e8 d4 28 00 00       	call   80104a00 <memmove>
8010212c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
8010212f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80102132:	75 0c                	jne    80102140 <namex+0xb0>
80102134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102138:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010213b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
8010213e:	74 f8                	je     80102138 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102140:	83 ec 0c             	sub    $0xc,%esp
80102143:	56                   	push   %esi
80102144:	e8 37 f9 ff ff       	call   80101a80 <ilock>
    if(ip->type != T_DIR){
80102149:	83 c4 10             	add    $0x10,%esp
8010214c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102151:	0f 85 cd 00 00 00    	jne    80102224 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80102157:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010215a:	85 c0                	test   %eax,%eax
8010215c:	74 09                	je     80102167 <namex+0xd7>
8010215e:	80 3b 00             	cmpb   $0x0,(%ebx)
80102161:	0f 84 22 01 00 00    	je     80102289 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102167:	83 ec 04             	sub    $0x4,%esp
8010216a:	6a 00                	push   $0x0
8010216c:	ff 75 e4             	push   -0x1c(%ebp)
8010216f:	56                   	push   %esi
80102170:	e8 6b fe ff ff       	call   80101fe0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102175:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80102178:	83 c4 10             	add    $0x10,%esp
8010217b:	89 c7                	mov    %eax,%edi
8010217d:	85 c0                	test   %eax,%eax
8010217f:	0f 84 e1 00 00 00    	je     80102266 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102185:	83 ec 0c             	sub    $0xc,%esp
80102188:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010218b:	52                   	push   %edx
8010218c:	e8 ef 24 00 00       	call   80104680 <holdingsleep>
80102191:	83 c4 10             	add    $0x10,%esp
80102194:	85 c0                	test   %eax,%eax
80102196:	0f 84 30 01 00 00    	je     801022cc <namex+0x23c>
8010219c:	8b 56 08             	mov    0x8(%esi),%edx
8010219f:	85 d2                	test   %edx,%edx
801021a1:	0f 8e 25 01 00 00    	jle    801022cc <namex+0x23c>
  releasesleep(&ip->lock);
801021a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801021aa:	83 ec 0c             	sub    $0xc,%esp
801021ad:	52                   	push   %edx
801021ae:	e8 8d 24 00 00       	call   80104640 <releasesleep>
  iput(ip);
801021b3:	89 34 24             	mov    %esi,(%esp)
801021b6:	89 fe                	mov    %edi,%esi
801021b8:	e8 f3 f9 ff ff       	call   80101bb0 <iput>
801021bd:	83 c4 10             	add    $0x10,%esp
801021c0:	e9 16 ff ff ff       	jmp    801020db <namex+0x4b>
801021c5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
801021c8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801021cb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
801021ce:	83 ec 04             	sub    $0x4,%esp
801021d1:	89 55 e0             	mov    %edx,-0x20(%ebp)
801021d4:	50                   	push   %eax
801021d5:	53                   	push   %ebx
    name[len] = 0;
801021d6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
801021d8:	ff 75 e4             	push   -0x1c(%ebp)
801021db:	e8 20 28 00 00       	call   80104a00 <memmove>
    name[len] = 0;
801021e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
801021e3:	83 c4 10             	add    $0x10,%esp
801021e6:	c6 02 00             	movb   $0x0,(%edx)
801021e9:	e9 41 ff ff ff       	jmp    8010212f <namex+0x9f>
801021ee:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801021f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801021f3:	85 c0                	test   %eax,%eax
801021f5:	0f 85 be 00 00 00    	jne    801022b9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
801021fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021fe:	89 f0                	mov    %esi,%eax
80102200:	5b                   	pop    %ebx
80102201:	5e                   	pop    %esi
80102202:	5f                   	pop    %edi
80102203:	5d                   	pop    %ebp
80102204:	c3                   	ret    
  while(*path != '/' && *path != 0)
80102205:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102208:	89 df                	mov    %ebx,%edi
8010220a:	31 c0                	xor    %eax,%eax
8010220c:	eb c0                	jmp    801021ce <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
8010220e:	ba 01 00 00 00       	mov    $0x1,%edx
80102213:	b8 01 00 00 00       	mov    $0x1,%eax
80102218:	e8 33 f4 ff ff       	call   80101650 <iget>
8010221d:	89 c6                	mov    %eax,%esi
8010221f:	e9 b7 fe ff ff       	jmp    801020db <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102224:	83 ec 0c             	sub    $0xc,%esp
80102227:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010222a:	53                   	push   %ebx
8010222b:	e8 50 24 00 00       	call   80104680 <holdingsleep>
80102230:	83 c4 10             	add    $0x10,%esp
80102233:	85 c0                	test   %eax,%eax
80102235:	0f 84 91 00 00 00    	je     801022cc <namex+0x23c>
8010223b:	8b 46 08             	mov    0x8(%esi),%eax
8010223e:	85 c0                	test   %eax,%eax
80102240:	0f 8e 86 00 00 00    	jle    801022cc <namex+0x23c>
  releasesleep(&ip->lock);
80102246:	83 ec 0c             	sub    $0xc,%esp
80102249:	53                   	push   %ebx
8010224a:	e8 f1 23 00 00       	call   80104640 <releasesleep>
  iput(ip);
8010224f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102252:	31 f6                	xor    %esi,%esi
  iput(ip);
80102254:	e8 57 f9 ff ff       	call   80101bb0 <iput>
      return 0;
80102259:	83 c4 10             	add    $0x10,%esp
}
8010225c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010225f:	89 f0                	mov    %esi,%eax
80102261:	5b                   	pop    %ebx
80102262:	5e                   	pop    %esi
80102263:	5f                   	pop    %edi
80102264:	5d                   	pop    %ebp
80102265:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102266:	83 ec 0c             	sub    $0xc,%esp
80102269:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010226c:	52                   	push   %edx
8010226d:	e8 0e 24 00 00       	call   80104680 <holdingsleep>
80102272:	83 c4 10             	add    $0x10,%esp
80102275:	85 c0                	test   %eax,%eax
80102277:	74 53                	je     801022cc <namex+0x23c>
80102279:	8b 4e 08             	mov    0x8(%esi),%ecx
8010227c:	85 c9                	test   %ecx,%ecx
8010227e:	7e 4c                	jle    801022cc <namex+0x23c>
  releasesleep(&ip->lock);
80102280:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102283:	83 ec 0c             	sub    $0xc,%esp
80102286:	52                   	push   %edx
80102287:	eb c1                	jmp    8010224a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102289:	83 ec 0c             	sub    $0xc,%esp
8010228c:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010228f:	53                   	push   %ebx
80102290:	e8 eb 23 00 00       	call   80104680 <holdingsleep>
80102295:	83 c4 10             	add    $0x10,%esp
80102298:	85 c0                	test   %eax,%eax
8010229a:	74 30                	je     801022cc <namex+0x23c>
8010229c:	8b 7e 08             	mov    0x8(%esi),%edi
8010229f:	85 ff                	test   %edi,%edi
801022a1:	7e 29                	jle    801022cc <namex+0x23c>
  releasesleep(&ip->lock);
801022a3:	83 ec 0c             	sub    $0xc,%esp
801022a6:	53                   	push   %ebx
801022a7:	e8 94 23 00 00       	call   80104640 <releasesleep>
}
801022ac:	83 c4 10             	add    $0x10,%esp
}
801022af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022b2:	89 f0                	mov    %esi,%eax
801022b4:	5b                   	pop    %ebx
801022b5:	5e                   	pop    %esi
801022b6:	5f                   	pop    %edi
801022b7:	5d                   	pop    %ebp
801022b8:	c3                   	ret    
    iput(ip);
801022b9:	83 ec 0c             	sub    $0xc,%esp
801022bc:	56                   	push   %esi
    return 0;
801022bd:	31 f6                	xor    %esi,%esi
    iput(ip);
801022bf:	e8 ec f8 ff ff       	call   80101bb0 <iput>
    return 0;
801022c4:	83 c4 10             	add    $0x10,%esp
801022c7:	e9 2f ff ff ff       	jmp    801021fb <namex+0x16b>
    panic("iunlock");
801022cc:	83 ec 0c             	sub    $0xc,%esp
801022cf:	68 2f 76 10 80       	push   $0x8010762f
801022d4:	e8 a7 e0 ff ff       	call   80100380 <panic>
801022d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801022e0 <dirlink>:
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	57                   	push   %edi
801022e4:	56                   	push   %esi
801022e5:	53                   	push   %ebx
801022e6:	83 ec 20             	sub    $0x20,%esp
801022e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801022ec:	6a 00                	push   $0x0
801022ee:	ff 75 0c             	push   0xc(%ebp)
801022f1:	53                   	push   %ebx
801022f2:	e8 e9 fc ff ff       	call   80101fe0 <dirlookup>
801022f7:	83 c4 10             	add    $0x10,%esp
801022fa:	85 c0                	test   %eax,%eax
801022fc:	75 67                	jne    80102365 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
801022fe:	8b 7b 58             	mov    0x58(%ebx),%edi
80102301:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102304:	85 ff                	test   %edi,%edi
80102306:	74 29                	je     80102331 <dirlink+0x51>
80102308:	31 ff                	xor    %edi,%edi
8010230a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010230d:	eb 09                	jmp    80102318 <dirlink+0x38>
8010230f:	90                   	nop
80102310:	83 c7 10             	add    $0x10,%edi
80102313:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102316:	73 19                	jae    80102331 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102318:	6a 10                	push   $0x10
8010231a:	57                   	push   %edi
8010231b:	56                   	push   %esi
8010231c:	53                   	push   %ebx
8010231d:	e8 6e fa ff ff       	call   80101d90 <readi>
80102322:	83 c4 10             	add    $0x10,%esp
80102325:	83 f8 10             	cmp    $0x10,%eax
80102328:	75 4e                	jne    80102378 <dirlink+0x98>
    if(de.inum == 0)
8010232a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010232f:	75 df                	jne    80102310 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102331:	83 ec 04             	sub    $0x4,%esp
80102334:	8d 45 da             	lea    -0x26(%ebp),%eax
80102337:	6a 0e                	push   $0xe
80102339:	ff 75 0c             	push   0xc(%ebp)
8010233c:	50                   	push   %eax
8010233d:	e8 7e 27 00 00       	call   80104ac0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102342:	6a 10                	push   $0x10
  de.inum = inum;
80102344:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102347:	57                   	push   %edi
80102348:	56                   	push   %esi
80102349:	53                   	push   %ebx
  de.inum = inum;
8010234a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010234e:	e8 3d fb ff ff       	call   80101e90 <writei>
80102353:	83 c4 20             	add    $0x20,%esp
80102356:	83 f8 10             	cmp    $0x10,%eax
80102359:	75 2a                	jne    80102385 <dirlink+0xa5>
  return 0;
8010235b:	31 c0                	xor    %eax,%eax
}
8010235d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102360:	5b                   	pop    %ebx
80102361:	5e                   	pop    %esi
80102362:	5f                   	pop    %edi
80102363:	5d                   	pop    %ebp
80102364:	c3                   	ret    
    iput(ip);
80102365:	83 ec 0c             	sub    $0xc,%esp
80102368:	50                   	push   %eax
80102369:	e8 42 f8 ff ff       	call   80101bb0 <iput>
    return -1;
8010236e:	83 c4 10             	add    $0x10,%esp
80102371:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102376:	eb e5                	jmp    8010235d <dirlink+0x7d>
      panic("dirlink read");
80102378:	83 ec 0c             	sub    $0xc,%esp
8010237b:	68 58 76 10 80       	push   $0x80107658
80102380:	e8 fb df ff ff       	call   80100380 <panic>
    panic("dirlink");
80102385:	83 ec 0c             	sub    $0xc,%esp
80102388:	68 3e 7c 10 80       	push   $0x80107c3e
8010238d:	e8 ee df ff ff       	call   80100380 <panic>
80102392:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801023a0 <namei>:

struct inode*
namei(char *path)
{
801023a0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801023a1:	31 d2                	xor    %edx,%edx
{
801023a3:	89 e5                	mov    %esp,%ebp
801023a5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801023a8:	8b 45 08             	mov    0x8(%ebp),%eax
801023ab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801023ae:	e8 dd fc ff ff       	call   80102090 <namex>
}
801023b3:	c9                   	leave  
801023b4:	c3                   	ret    
801023b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801023c0:	55                   	push   %ebp
  return namex(path, 1, name);
801023c1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801023c6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801023c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801023cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801023ce:	5d                   	pop    %ebp
  return namex(path, 1, name);
801023cf:	e9 bc fc ff ff       	jmp    80102090 <namex>
801023d4:	66 90                	xchg   %ax,%ax
801023d6:	66 90                	xchg   %ax,%ax
801023d8:	66 90                	xchg   %ax,%ax
801023da:	66 90                	xchg   %ax,%ax
801023dc:	66 90                	xchg   %ax,%ax
801023de:	66 90                	xchg   %ax,%ax

801023e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801023e0:	55                   	push   %ebp
801023e1:	89 e5                	mov    %esp,%ebp
801023e3:	57                   	push   %edi
801023e4:	56                   	push   %esi
801023e5:	53                   	push   %ebx
801023e6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801023e9:	85 c0                	test   %eax,%eax
801023eb:	0f 84 b4 00 00 00    	je     801024a5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801023f1:	8b 70 08             	mov    0x8(%eax),%esi
801023f4:	89 c3                	mov    %eax,%ebx
801023f6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801023fc:	0f 87 96 00 00 00    	ja     80102498 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102402:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102407:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010240e:	66 90                	xchg   %ax,%ax
80102410:	89 ca                	mov    %ecx,%edx
80102412:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102413:	83 e0 c0             	and    $0xffffffc0,%eax
80102416:	3c 40                	cmp    $0x40,%al
80102418:	75 f6                	jne    80102410 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010241a:	31 ff                	xor    %edi,%edi
8010241c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102421:	89 f8                	mov    %edi,%eax
80102423:	ee                   	out    %al,(%dx)
80102424:	b8 01 00 00 00       	mov    $0x1,%eax
80102429:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010242e:	ee                   	out    %al,(%dx)
8010242f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102434:	89 f0                	mov    %esi,%eax
80102436:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102437:	89 f0                	mov    %esi,%eax
80102439:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010243e:	c1 f8 08             	sar    $0x8,%eax
80102441:	ee                   	out    %al,(%dx)
80102442:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102447:	89 f8                	mov    %edi,%eax
80102449:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010244a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010244e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102453:	c1 e0 04             	shl    $0x4,%eax
80102456:	83 e0 10             	and    $0x10,%eax
80102459:	83 c8 e0             	or     $0xffffffe0,%eax
8010245c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010245d:	f6 03 04             	testb  $0x4,(%ebx)
80102460:	75 16                	jne    80102478 <idestart+0x98>
80102462:	b8 20 00 00 00       	mov    $0x20,%eax
80102467:	89 ca                	mov    %ecx,%edx
80102469:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010246a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010246d:	5b                   	pop    %ebx
8010246e:	5e                   	pop    %esi
8010246f:	5f                   	pop    %edi
80102470:	5d                   	pop    %ebp
80102471:	c3                   	ret    
80102472:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102478:	b8 30 00 00 00       	mov    $0x30,%eax
8010247d:	89 ca                	mov    %ecx,%edx
8010247f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102480:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102485:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102488:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010248d:	fc                   	cld    
8010248e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102490:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102493:	5b                   	pop    %ebx
80102494:	5e                   	pop    %esi
80102495:	5f                   	pop    %edi
80102496:	5d                   	pop    %ebp
80102497:	c3                   	ret    
    panic("incorrect blockno");
80102498:	83 ec 0c             	sub    $0xc,%esp
8010249b:	68 c4 76 10 80       	push   $0x801076c4
801024a0:	e8 db de ff ff       	call   80100380 <panic>
    panic("idestart");
801024a5:	83 ec 0c             	sub    $0xc,%esp
801024a8:	68 bb 76 10 80       	push   $0x801076bb
801024ad:	e8 ce de ff ff       	call   80100380 <panic>
801024b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801024c0 <ideinit>:
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801024c6:	68 d6 76 10 80       	push   $0x801076d6
801024cb:	68 a0 16 11 80       	push   $0x801116a0
801024d0:	e8 fb 21 00 00       	call   801046d0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801024d5:	58                   	pop    %eax
801024d6:	a1 24 18 11 80       	mov    0x80111824,%eax
801024db:	5a                   	pop    %edx
801024dc:	83 e8 01             	sub    $0x1,%eax
801024df:	50                   	push   %eax
801024e0:	6a 0e                	push   $0xe
801024e2:	e8 99 02 00 00       	call   80102780 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801024e7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024ea:	ba f7 01 00 00       	mov    $0x1f7,%edx
801024ef:	90                   	nop
801024f0:	ec                   	in     (%dx),%al
801024f1:	83 e0 c0             	and    $0xffffffc0,%eax
801024f4:	3c 40                	cmp    $0x40,%al
801024f6:	75 f8                	jne    801024f0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801024fd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102502:	ee                   	out    %al,(%dx)
80102503:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102508:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010250d:	eb 06                	jmp    80102515 <ideinit+0x55>
8010250f:	90                   	nop
  for(i=0; i<1000; i++){
80102510:	83 e9 01             	sub    $0x1,%ecx
80102513:	74 0f                	je     80102524 <ideinit+0x64>
80102515:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102516:	84 c0                	test   %al,%al
80102518:	74 f6                	je     80102510 <ideinit+0x50>
      havedisk1 = 1;
8010251a:	c7 05 80 16 11 80 01 	movl   $0x1,0x80111680
80102521:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102524:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102529:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010252e:	ee                   	out    %al,(%dx)
}
8010252f:	c9                   	leave  
80102530:	c3                   	ret    
80102531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102538:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010253f:	90                   	nop

80102540 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102540:	55                   	push   %ebp
80102541:	89 e5                	mov    %esp,%ebp
80102543:	57                   	push   %edi
80102544:	56                   	push   %esi
80102545:	53                   	push   %ebx
80102546:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102549:	68 a0 16 11 80       	push   $0x801116a0
8010254e:	e8 4d 23 00 00       	call   801048a0 <acquire>

  if((b = idequeue) == 0){
80102553:	8b 1d 84 16 11 80    	mov    0x80111684,%ebx
80102559:	83 c4 10             	add    $0x10,%esp
8010255c:	85 db                	test   %ebx,%ebx
8010255e:	74 63                	je     801025c3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102560:	8b 43 58             	mov    0x58(%ebx),%eax
80102563:	a3 84 16 11 80       	mov    %eax,0x80111684

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102568:	8b 33                	mov    (%ebx),%esi
8010256a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102570:	75 2f                	jne    801025a1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102572:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102577:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010257e:	66 90                	xchg   %ax,%ax
80102580:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102581:	89 c1                	mov    %eax,%ecx
80102583:	83 e1 c0             	and    $0xffffffc0,%ecx
80102586:	80 f9 40             	cmp    $0x40,%cl
80102589:	75 f5                	jne    80102580 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010258b:	a8 21                	test   $0x21,%al
8010258d:	75 12                	jne    801025a1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010258f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102592:	b9 80 00 00 00       	mov    $0x80,%ecx
80102597:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010259c:	fc                   	cld    
8010259d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010259f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801025a1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801025a4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801025a7:	83 ce 02             	or     $0x2,%esi
801025aa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801025ac:	53                   	push   %ebx
801025ad:	e8 4e 1e 00 00       	call   80104400 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801025b2:	a1 84 16 11 80       	mov    0x80111684,%eax
801025b7:	83 c4 10             	add    $0x10,%esp
801025ba:	85 c0                	test   %eax,%eax
801025bc:	74 05                	je     801025c3 <ideintr+0x83>
    idestart(idequeue);
801025be:	e8 1d fe ff ff       	call   801023e0 <idestart>
    release(&idelock);
801025c3:	83 ec 0c             	sub    $0xc,%esp
801025c6:	68 a0 16 11 80       	push   $0x801116a0
801025cb:	e8 70 22 00 00       	call   80104840 <release>

  release(&idelock);
}
801025d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025d3:	5b                   	pop    %ebx
801025d4:	5e                   	pop    %esi
801025d5:	5f                   	pop    %edi
801025d6:	5d                   	pop    %ebp
801025d7:	c3                   	ret    
801025d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025df:	90                   	nop

801025e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	53                   	push   %ebx
801025e4:	83 ec 10             	sub    $0x10,%esp
801025e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801025ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801025ed:	50                   	push   %eax
801025ee:	e8 8d 20 00 00       	call   80104680 <holdingsleep>
801025f3:	83 c4 10             	add    $0x10,%esp
801025f6:	85 c0                	test   %eax,%eax
801025f8:	0f 84 c3 00 00 00    	je     801026c1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801025fe:	8b 03                	mov    (%ebx),%eax
80102600:	83 e0 06             	and    $0x6,%eax
80102603:	83 f8 02             	cmp    $0x2,%eax
80102606:	0f 84 a8 00 00 00    	je     801026b4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010260c:	8b 53 04             	mov    0x4(%ebx),%edx
8010260f:	85 d2                	test   %edx,%edx
80102611:	74 0d                	je     80102620 <iderw+0x40>
80102613:	a1 80 16 11 80       	mov    0x80111680,%eax
80102618:	85 c0                	test   %eax,%eax
8010261a:	0f 84 87 00 00 00    	je     801026a7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102620:	83 ec 0c             	sub    $0xc,%esp
80102623:	68 a0 16 11 80       	push   $0x801116a0
80102628:	e8 73 22 00 00       	call   801048a0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010262d:	a1 84 16 11 80       	mov    0x80111684,%eax
  b->qnext = 0;
80102632:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102639:	83 c4 10             	add    $0x10,%esp
8010263c:	85 c0                	test   %eax,%eax
8010263e:	74 60                	je     801026a0 <iderw+0xc0>
80102640:	89 c2                	mov    %eax,%edx
80102642:	8b 40 58             	mov    0x58(%eax),%eax
80102645:	85 c0                	test   %eax,%eax
80102647:	75 f7                	jne    80102640 <iderw+0x60>
80102649:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010264c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010264e:	39 1d 84 16 11 80    	cmp    %ebx,0x80111684
80102654:	74 3a                	je     80102690 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102656:	8b 03                	mov    (%ebx),%eax
80102658:	83 e0 06             	and    $0x6,%eax
8010265b:	83 f8 02             	cmp    $0x2,%eax
8010265e:	74 1b                	je     8010267b <iderw+0x9b>
    sleep(b, &idelock);
80102660:	83 ec 08             	sub    $0x8,%esp
80102663:	68 a0 16 11 80       	push   $0x801116a0
80102668:	53                   	push   %ebx
80102669:	e8 d2 1c 00 00       	call   80104340 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010266e:	8b 03                	mov    (%ebx),%eax
80102670:	83 c4 10             	add    $0x10,%esp
80102673:	83 e0 06             	and    $0x6,%eax
80102676:	83 f8 02             	cmp    $0x2,%eax
80102679:	75 e5                	jne    80102660 <iderw+0x80>
  }


  release(&idelock);
8010267b:	c7 45 08 a0 16 11 80 	movl   $0x801116a0,0x8(%ebp)
}
80102682:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102685:	c9                   	leave  
  release(&idelock);
80102686:	e9 b5 21 00 00       	jmp    80104840 <release>
8010268b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010268f:	90                   	nop
    idestart(b);
80102690:	89 d8                	mov    %ebx,%eax
80102692:	e8 49 fd ff ff       	call   801023e0 <idestart>
80102697:	eb bd                	jmp    80102656 <iderw+0x76>
80102699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801026a0:	ba 84 16 11 80       	mov    $0x80111684,%edx
801026a5:	eb a5                	jmp    8010264c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801026a7:	83 ec 0c             	sub    $0xc,%esp
801026aa:	68 05 77 10 80       	push   $0x80107705
801026af:	e8 cc dc ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801026b4:	83 ec 0c             	sub    $0xc,%esp
801026b7:	68 f0 76 10 80       	push   $0x801076f0
801026bc:	e8 bf dc ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801026c1:	83 ec 0c             	sub    $0xc,%esp
801026c4:	68 da 76 10 80       	push   $0x801076da
801026c9:	e8 b2 dc ff ff       	call   80100380 <panic>
801026ce:	66 90                	xchg   %ax,%ax

801026d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801026d0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801026d1:	c7 05 d4 16 11 80 00 	movl   $0xfec00000,0x801116d4
801026d8:	00 c0 fe 
{
801026db:	89 e5                	mov    %esp,%ebp
801026dd:	56                   	push   %esi
801026de:	53                   	push   %ebx
  ioapic->reg = reg;
801026df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801026e6:	00 00 00 
  return ioapic->data;
801026e9:	8b 15 d4 16 11 80    	mov    0x801116d4,%edx
801026ef:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801026f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801026f8:	8b 0d d4 16 11 80    	mov    0x801116d4,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801026fe:	0f b6 15 20 18 11 80 	movzbl 0x80111820,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102705:	c1 ee 10             	shr    $0x10,%esi
80102708:	89 f0                	mov    %esi,%eax
8010270a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010270d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102710:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102713:	39 c2                	cmp    %eax,%edx
80102715:	74 16                	je     8010272d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102717:	83 ec 0c             	sub    $0xc,%esp
8010271a:	68 24 77 10 80       	push   $0x80107724
8010271f:	e8 7c df ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102724:	8b 0d d4 16 11 80    	mov    0x801116d4,%ecx
8010272a:	83 c4 10             	add    $0x10,%esp
8010272d:	83 c6 21             	add    $0x21,%esi
{
80102730:	ba 10 00 00 00       	mov    $0x10,%edx
80102735:	b8 20 00 00 00       	mov    $0x20,%eax
8010273a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102740:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102742:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102744:	8b 0d d4 16 11 80    	mov    0x801116d4,%ecx
  for(i = 0; i <= maxintr; i++){
8010274a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010274d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102753:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102756:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102759:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010275c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010275e:	8b 0d d4 16 11 80    	mov    0x801116d4,%ecx
80102764:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010276b:	39 f0                	cmp    %esi,%eax
8010276d:	75 d1                	jne    80102740 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010276f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102772:	5b                   	pop    %ebx
80102773:	5e                   	pop    %esi
80102774:	5d                   	pop    %ebp
80102775:	c3                   	ret    
80102776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277d:	8d 76 00             	lea    0x0(%esi),%esi

80102780 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102780:	55                   	push   %ebp
  ioapic->reg = reg;
80102781:	8b 0d d4 16 11 80    	mov    0x801116d4,%ecx
{
80102787:	89 e5                	mov    %esp,%ebp
80102789:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010278c:	8d 50 20             	lea    0x20(%eax),%edx
8010278f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102793:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102795:	8b 0d d4 16 11 80    	mov    0x801116d4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010279b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010279e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801027a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801027a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801027a6:	a1 d4 16 11 80       	mov    0x801116d4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801027ab:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801027ae:	89 50 10             	mov    %edx,0x10(%eax)
}
801027b1:	5d                   	pop    %ebp
801027b2:	c3                   	ret    
801027b3:	66 90                	xchg   %ax,%ax
801027b5:	66 90                	xchg   %ax,%ax
801027b7:	66 90                	xchg   %ax,%ax
801027b9:	66 90                	xchg   %ax,%ax
801027bb:	66 90                	xchg   %ax,%ax
801027bd:	66 90                	xchg   %ax,%ax
801027bf:	90                   	nop

801027c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801027c0:	55                   	push   %ebp
801027c1:	89 e5                	mov    %esp,%ebp
801027c3:	53                   	push   %ebx
801027c4:	83 ec 04             	sub    $0x4,%esp
801027c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801027ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801027d0:	75 76                	jne    80102848 <kfree+0x88>
801027d2:	81 fb 70 55 11 80    	cmp    $0x80115570,%ebx
801027d8:	72 6e                	jb     80102848 <kfree+0x88>
801027da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801027e0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801027e5:	77 61                	ja     80102848 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801027e7:	83 ec 04             	sub    $0x4,%esp
801027ea:	68 00 10 00 00       	push   $0x1000
801027ef:	6a 01                	push   $0x1
801027f1:	53                   	push   %ebx
801027f2:	e8 69 21 00 00       	call   80104960 <memset>

  if(kmem.use_lock)
801027f7:	8b 15 14 17 11 80    	mov    0x80111714,%edx
801027fd:	83 c4 10             	add    $0x10,%esp
80102800:	85 d2                	test   %edx,%edx
80102802:	75 1c                	jne    80102820 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102804:	a1 18 17 11 80       	mov    0x80111718,%eax
80102809:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010280b:	a1 14 17 11 80       	mov    0x80111714,%eax
  kmem.freelist = r;
80102810:	89 1d 18 17 11 80    	mov    %ebx,0x80111718
  if(kmem.use_lock)
80102816:	85 c0                	test   %eax,%eax
80102818:	75 1e                	jne    80102838 <kfree+0x78>
    release(&kmem.lock);
}
8010281a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010281d:	c9                   	leave  
8010281e:	c3                   	ret    
8010281f:	90                   	nop
    acquire(&kmem.lock);
80102820:	83 ec 0c             	sub    $0xc,%esp
80102823:	68 e0 16 11 80       	push   $0x801116e0
80102828:	e8 73 20 00 00       	call   801048a0 <acquire>
8010282d:	83 c4 10             	add    $0x10,%esp
80102830:	eb d2                	jmp    80102804 <kfree+0x44>
80102832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102838:	c7 45 08 e0 16 11 80 	movl   $0x801116e0,0x8(%ebp)
}
8010283f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102842:	c9                   	leave  
    release(&kmem.lock);
80102843:	e9 f8 1f 00 00       	jmp    80104840 <release>
    panic("kfree");
80102848:	83 ec 0c             	sub    $0xc,%esp
8010284b:	68 56 77 10 80       	push   $0x80107756
80102850:	e8 2b db ff ff       	call   80100380 <panic>
80102855:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010285c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102860 <freerange>:
{
80102860:	55                   	push   %ebp
80102861:	89 e5                	mov    %esp,%ebp
80102863:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102864:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102867:	8b 75 0c             	mov    0xc(%ebp),%esi
8010286a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010286b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102871:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102877:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010287d:	39 de                	cmp    %ebx,%esi
8010287f:	72 23                	jb     801028a4 <freerange+0x44>
80102881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102888:	83 ec 0c             	sub    $0xc,%esp
8010288b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102891:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102897:	50                   	push   %eax
80102898:	e8 23 ff ff ff       	call   801027c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010289d:	83 c4 10             	add    $0x10,%esp
801028a0:	39 f3                	cmp    %esi,%ebx
801028a2:	76 e4                	jbe    80102888 <freerange+0x28>
}
801028a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028a7:	5b                   	pop    %ebx
801028a8:	5e                   	pop    %esi
801028a9:	5d                   	pop    %ebp
801028aa:	c3                   	ret    
801028ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028af:	90                   	nop

801028b0 <kinit2>:
{
801028b0:	55                   	push   %ebp
801028b1:	89 e5                	mov    %esp,%ebp
801028b3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801028b4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801028b7:	8b 75 0c             	mov    0xc(%ebp),%esi
801028ba:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801028bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801028c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801028cd:	39 de                	cmp    %ebx,%esi
801028cf:	72 23                	jb     801028f4 <kinit2+0x44>
801028d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801028d8:	83 ec 0c             	sub    $0xc,%esp
801028db:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801028e7:	50                   	push   %eax
801028e8:	e8 d3 fe ff ff       	call   801027c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028ed:	83 c4 10             	add    $0x10,%esp
801028f0:	39 de                	cmp    %ebx,%esi
801028f2:	73 e4                	jae    801028d8 <kinit2+0x28>
  kmem.use_lock = 1;
801028f4:	c7 05 14 17 11 80 01 	movl   $0x1,0x80111714
801028fb:	00 00 00 
}
801028fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102901:	5b                   	pop    %ebx
80102902:	5e                   	pop    %esi
80102903:	5d                   	pop    %ebp
80102904:	c3                   	ret    
80102905:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010290c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102910 <kinit1>:
{
80102910:	55                   	push   %ebp
80102911:	89 e5                	mov    %esp,%ebp
80102913:	56                   	push   %esi
80102914:	53                   	push   %ebx
80102915:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102918:	83 ec 08             	sub    $0x8,%esp
8010291b:	68 5c 77 10 80       	push   $0x8010775c
80102920:	68 e0 16 11 80       	push   $0x801116e0
80102925:	e8 a6 1d 00 00       	call   801046d0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010292a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010292d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102930:	c7 05 14 17 11 80 00 	movl   $0x0,0x80111714
80102937:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010293a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102940:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102946:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010294c:	39 de                	cmp    %ebx,%esi
8010294e:	72 1c                	jb     8010296c <kinit1+0x5c>
    kfree(p);
80102950:	83 ec 0c             	sub    $0xc,%esp
80102953:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102959:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010295f:	50                   	push   %eax
80102960:	e8 5b fe ff ff       	call   801027c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102965:	83 c4 10             	add    $0x10,%esp
80102968:	39 de                	cmp    %ebx,%esi
8010296a:	73 e4                	jae    80102950 <kinit1+0x40>
}
8010296c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010296f:	5b                   	pop    %ebx
80102970:	5e                   	pop    %esi
80102971:	5d                   	pop    %ebp
80102972:	c3                   	ret    
80102973:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010297a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102980 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102980:	a1 14 17 11 80       	mov    0x80111714,%eax
80102985:	85 c0                	test   %eax,%eax
80102987:	75 1f                	jne    801029a8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102989:	a1 18 17 11 80       	mov    0x80111718,%eax
  if(r)
8010298e:	85 c0                	test   %eax,%eax
80102990:	74 0e                	je     801029a0 <kalloc+0x20>
    kmem.freelist = r->next;
80102992:	8b 10                	mov    (%eax),%edx
80102994:	89 15 18 17 11 80    	mov    %edx,0x80111718
  if(kmem.use_lock)
8010299a:	c3                   	ret    
8010299b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010299f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801029a0:	c3                   	ret    
801029a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801029a8:	55                   	push   %ebp
801029a9:	89 e5                	mov    %esp,%ebp
801029ab:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801029ae:	68 e0 16 11 80       	push   $0x801116e0
801029b3:	e8 e8 1e 00 00       	call   801048a0 <acquire>
  r = kmem.freelist;
801029b8:	a1 18 17 11 80       	mov    0x80111718,%eax
  if(kmem.use_lock)
801029bd:	8b 15 14 17 11 80    	mov    0x80111714,%edx
  if(r)
801029c3:	83 c4 10             	add    $0x10,%esp
801029c6:	85 c0                	test   %eax,%eax
801029c8:	74 08                	je     801029d2 <kalloc+0x52>
    kmem.freelist = r->next;
801029ca:	8b 08                	mov    (%eax),%ecx
801029cc:	89 0d 18 17 11 80    	mov    %ecx,0x80111718
  if(kmem.use_lock)
801029d2:	85 d2                	test   %edx,%edx
801029d4:	74 16                	je     801029ec <kalloc+0x6c>
    release(&kmem.lock);
801029d6:	83 ec 0c             	sub    $0xc,%esp
801029d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801029dc:	68 e0 16 11 80       	push   $0x801116e0
801029e1:	e8 5a 1e 00 00       	call   80104840 <release>
  return (char*)r;
801029e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801029e9:	83 c4 10             	add    $0x10,%esp
}
801029ec:	c9                   	leave  
801029ed:	c3                   	ret    
801029ee:	66 90                	xchg   %ax,%ax

801029f0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f0:	ba 64 00 00 00       	mov    $0x64,%edx
801029f5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801029f6:	a8 01                	test   $0x1,%al
801029f8:	0f 84 c2 00 00 00    	je     80102ac0 <kbdgetc+0xd0>
{
801029fe:	55                   	push   %ebp
801029ff:	ba 60 00 00 00       	mov    $0x60,%edx
80102a04:	89 e5                	mov    %esp,%ebp
80102a06:	53                   	push   %ebx
80102a07:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102a08:	8b 1d 1c 17 11 80    	mov    0x8011171c,%ebx
  data = inb(KBDATAP);
80102a0e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102a11:	3c e0                	cmp    $0xe0,%al
80102a13:	74 5b                	je     80102a70 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102a15:	89 da                	mov    %ebx,%edx
80102a17:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
80102a1a:	84 c0                	test   %al,%al
80102a1c:	78 62                	js     80102a80 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102a1e:	85 d2                	test   %edx,%edx
80102a20:	74 09                	je     80102a2b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102a22:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102a25:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102a28:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80102a2b:	0f b6 91 a0 78 10 80 	movzbl -0x7fef8760(%ecx),%edx
  shift ^= togglecode[data];
80102a32:	0f b6 81 a0 77 10 80 	movzbl -0x7fef8860(%ecx),%eax
  shift |= shiftcode[data];
80102a39:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102a3b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102a3d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
80102a3f:	89 15 1c 17 11 80    	mov    %edx,0x8011171c
  c = charcode[shift & (CTL | SHIFT)][data];
80102a45:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102a48:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102a4b:	8b 04 85 80 77 10 80 	mov    -0x7fef8880(,%eax,4),%eax
80102a52:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102a56:	74 0b                	je     80102a63 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102a58:	8d 50 9f             	lea    -0x61(%eax),%edx
80102a5b:	83 fa 19             	cmp    $0x19,%edx
80102a5e:	77 48                	ja     80102aa8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102a60:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102a63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a66:	c9                   	leave  
80102a67:	c3                   	ret    
80102a68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a6f:	90                   	nop
    shift |= E0ESC;
80102a70:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102a73:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102a75:	89 1d 1c 17 11 80    	mov    %ebx,0x8011171c
}
80102a7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a7e:	c9                   	leave  
80102a7f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102a80:	83 e0 7f             	and    $0x7f,%eax
80102a83:	85 d2                	test   %edx,%edx
80102a85:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102a88:	0f b6 81 a0 78 10 80 	movzbl -0x7fef8760(%ecx),%eax
80102a8f:	83 c8 40             	or     $0x40,%eax
80102a92:	0f b6 c0             	movzbl %al,%eax
80102a95:	f7 d0                	not    %eax
80102a97:	21 d8                	and    %ebx,%eax
}
80102a99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
80102a9c:	a3 1c 17 11 80       	mov    %eax,0x8011171c
    return 0;
80102aa1:	31 c0                	xor    %eax,%eax
}
80102aa3:	c9                   	leave  
80102aa4:	c3                   	ret    
80102aa5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102aa8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102aab:	8d 50 20             	lea    0x20(%eax),%edx
}
80102aae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ab1:	c9                   	leave  
      c += 'a' - 'A';
80102ab2:	83 f9 1a             	cmp    $0x1a,%ecx
80102ab5:	0f 42 c2             	cmovb  %edx,%eax
}
80102ab8:	c3                   	ret    
80102ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102ac0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102ac5:	c3                   	ret    
80102ac6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102acd:	8d 76 00             	lea    0x0(%esi),%esi

80102ad0 <kbdintr>:

void
kbdintr(void)
{
80102ad0:	55                   	push   %ebp
80102ad1:	89 e5                	mov    %esp,%ebp
80102ad3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102ad6:	68 f0 29 10 80       	push   $0x801029f0
80102adb:	e8 a0 dd ff ff       	call   80100880 <consoleintr>
}
80102ae0:	83 c4 10             	add    $0x10,%esp
80102ae3:	c9                   	leave  
80102ae4:	c3                   	ret    
80102ae5:	66 90                	xchg   %ax,%ax
80102ae7:	66 90                	xchg   %ax,%ax
80102ae9:	66 90                	xchg   %ax,%ax
80102aeb:	66 90                	xchg   %ax,%ax
80102aed:	66 90                	xchg   %ax,%ax
80102aef:	90                   	nop

80102af0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102af0:	a1 20 17 11 80       	mov    0x80111720,%eax
80102af5:	85 c0                	test   %eax,%eax
80102af7:	0f 84 cb 00 00 00    	je     80102bc8 <lapicinit+0xd8>
  lapic[index] = value;
80102afd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102b04:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b07:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b0a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102b11:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b14:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b17:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102b1e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102b21:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b24:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102b2b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102b2e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b31:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102b38:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b3b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b3e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102b45:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b48:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102b4b:	8b 50 30             	mov    0x30(%eax),%edx
80102b4e:	c1 ea 10             	shr    $0x10,%edx
80102b51:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102b57:	75 77                	jne    80102bd0 <lapicinit+0xe0>
  lapic[index] = value;
80102b59:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102b60:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b63:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b66:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102b6d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b70:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b73:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102b7a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b7d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b80:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b87:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b8a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b8d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102b94:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b97:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b9a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102ba1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102ba4:	8b 50 20             	mov    0x20(%eax),%edx
80102ba7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102bae:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102bb0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102bb6:	80 e6 10             	and    $0x10,%dh
80102bb9:	75 f5                	jne    80102bb0 <lapicinit+0xc0>
  lapic[index] = value;
80102bbb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102bc2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bc5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102bc8:	c3                   	ret    
80102bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102bd0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102bd7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102bda:	8b 50 20             	mov    0x20(%eax),%edx
}
80102bdd:	e9 77 ff ff ff       	jmp    80102b59 <lapicinit+0x69>
80102be2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102bf0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102bf0:	a1 20 17 11 80       	mov    0x80111720,%eax
80102bf5:	85 c0                	test   %eax,%eax
80102bf7:	74 07                	je     80102c00 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102bf9:	8b 40 20             	mov    0x20(%eax),%eax
80102bfc:	c1 e8 18             	shr    $0x18,%eax
80102bff:	c3                   	ret    
    return 0;
80102c00:	31 c0                	xor    %eax,%eax
}
80102c02:	c3                   	ret    
80102c03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102c10 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102c10:	a1 20 17 11 80       	mov    0x80111720,%eax
80102c15:	85 c0                	test   %eax,%eax
80102c17:	74 0d                	je     80102c26 <lapiceoi+0x16>
  lapic[index] = value;
80102c19:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102c20:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c23:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102c26:	c3                   	ret    
80102c27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c2e:	66 90                	xchg   %ax,%ax

80102c30 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102c30:	c3                   	ret    
80102c31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c3f:	90                   	nop

80102c40 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102c40:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c41:	b8 0f 00 00 00       	mov    $0xf,%eax
80102c46:	ba 70 00 00 00       	mov    $0x70,%edx
80102c4b:	89 e5                	mov    %esp,%ebp
80102c4d:	53                   	push   %ebx
80102c4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102c51:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102c54:	ee                   	out    %al,(%dx)
80102c55:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c5a:	ba 71 00 00 00       	mov    $0x71,%edx
80102c5f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102c60:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102c62:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102c65:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102c6b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102c6d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102c70:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102c72:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102c75:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102c78:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102c7e:	a1 20 17 11 80       	mov    0x80111720,%eax
80102c83:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c89:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c8c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102c93:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c96:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c99:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102ca0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ca3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ca6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cac:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102caf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cb5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cb8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cbe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cc1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cc7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102cca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ccd:	c9                   	leave  
80102cce:	c3                   	ret    
80102ccf:	90                   	nop

80102cd0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102cd0:	55                   	push   %ebp
80102cd1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102cd6:	ba 70 00 00 00       	mov    $0x70,%edx
80102cdb:	89 e5                	mov    %esp,%ebp
80102cdd:	57                   	push   %edi
80102cde:	56                   	push   %esi
80102cdf:	53                   	push   %ebx
80102ce0:	83 ec 4c             	sub    $0x4c,%esp
80102ce3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ce4:	ba 71 00 00 00       	mov    $0x71,%edx
80102ce9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102cea:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ced:	bb 70 00 00 00       	mov    $0x70,%ebx
80102cf2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102cf5:	8d 76 00             	lea    0x0(%esi),%esi
80102cf8:	31 c0                	xor    %eax,%eax
80102cfa:	89 da                	mov    %ebx,%edx
80102cfc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cfd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102d02:	89 ca                	mov    %ecx,%edx
80102d04:	ec                   	in     (%dx),%al
80102d05:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d08:	89 da                	mov    %ebx,%edx
80102d0a:	b8 02 00 00 00       	mov    $0x2,%eax
80102d0f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d10:	89 ca                	mov    %ecx,%edx
80102d12:	ec                   	in     (%dx),%al
80102d13:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d16:	89 da                	mov    %ebx,%edx
80102d18:	b8 04 00 00 00       	mov    $0x4,%eax
80102d1d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d1e:	89 ca                	mov    %ecx,%edx
80102d20:	ec                   	in     (%dx),%al
80102d21:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d24:	89 da                	mov    %ebx,%edx
80102d26:	b8 07 00 00 00       	mov    $0x7,%eax
80102d2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d2c:	89 ca                	mov    %ecx,%edx
80102d2e:	ec                   	in     (%dx),%al
80102d2f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d32:	89 da                	mov    %ebx,%edx
80102d34:	b8 08 00 00 00       	mov    $0x8,%eax
80102d39:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d3a:	89 ca                	mov    %ecx,%edx
80102d3c:	ec                   	in     (%dx),%al
80102d3d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d3f:	89 da                	mov    %ebx,%edx
80102d41:	b8 09 00 00 00       	mov    $0x9,%eax
80102d46:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d47:	89 ca                	mov    %ecx,%edx
80102d49:	ec                   	in     (%dx),%al
80102d4a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d4c:	89 da                	mov    %ebx,%edx
80102d4e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102d53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d54:	89 ca                	mov    %ecx,%edx
80102d56:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102d57:	84 c0                	test   %al,%al
80102d59:	78 9d                	js     80102cf8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102d5b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102d5f:	89 fa                	mov    %edi,%edx
80102d61:	0f b6 fa             	movzbl %dl,%edi
80102d64:	89 f2                	mov    %esi,%edx
80102d66:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102d69:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102d6d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d70:	89 da                	mov    %ebx,%edx
80102d72:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102d75:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102d78:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102d7c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102d7f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102d82:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102d86:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102d89:	31 c0                	xor    %eax,%eax
80102d8b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d8c:	89 ca                	mov    %ecx,%edx
80102d8e:	ec                   	in     (%dx),%al
80102d8f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d92:	89 da                	mov    %ebx,%edx
80102d94:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102d97:	b8 02 00 00 00       	mov    $0x2,%eax
80102d9c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d9d:	89 ca                	mov    %ecx,%edx
80102d9f:	ec                   	in     (%dx),%al
80102da0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102da3:	89 da                	mov    %ebx,%edx
80102da5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102da8:	b8 04 00 00 00       	mov    $0x4,%eax
80102dad:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dae:	89 ca                	mov    %ecx,%edx
80102db0:	ec                   	in     (%dx),%al
80102db1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102db4:	89 da                	mov    %ebx,%edx
80102db6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102db9:	b8 07 00 00 00       	mov    $0x7,%eax
80102dbe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dbf:	89 ca                	mov    %ecx,%edx
80102dc1:	ec                   	in     (%dx),%al
80102dc2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dc5:	89 da                	mov    %ebx,%edx
80102dc7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102dca:	b8 08 00 00 00       	mov    $0x8,%eax
80102dcf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dd0:	89 ca                	mov    %ecx,%edx
80102dd2:	ec                   	in     (%dx),%al
80102dd3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dd6:	89 da                	mov    %ebx,%edx
80102dd8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102ddb:	b8 09 00 00 00       	mov    $0x9,%eax
80102de0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102de1:	89 ca                	mov    %ecx,%edx
80102de3:	ec                   	in     (%dx),%al
80102de4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102de7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102dea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ded:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102df0:	6a 18                	push   $0x18
80102df2:	50                   	push   %eax
80102df3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102df6:	50                   	push   %eax
80102df7:	e8 b4 1b 00 00       	call   801049b0 <memcmp>
80102dfc:	83 c4 10             	add    $0x10,%esp
80102dff:	85 c0                	test   %eax,%eax
80102e01:	0f 85 f1 fe ff ff    	jne    80102cf8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102e07:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102e0b:	75 78                	jne    80102e85 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102e0d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102e10:	89 c2                	mov    %eax,%edx
80102e12:	83 e0 0f             	and    $0xf,%eax
80102e15:	c1 ea 04             	shr    $0x4,%edx
80102e18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e1e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102e21:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102e24:	89 c2                	mov    %eax,%edx
80102e26:	83 e0 0f             	and    $0xf,%eax
80102e29:	c1 ea 04             	shr    $0x4,%edx
80102e2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e32:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102e35:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102e38:	89 c2                	mov    %eax,%edx
80102e3a:	83 e0 0f             	and    $0xf,%eax
80102e3d:	c1 ea 04             	shr    $0x4,%edx
80102e40:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e43:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e46:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102e49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102e4c:	89 c2                	mov    %eax,%edx
80102e4e:	83 e0 0f             	and    $0xf,%eax
80102e51:	c1 ea 04             	shr    $0x4,%edx
80102e54:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e57:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e5a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102e5d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102e60:	89 c2                	mov    %eax,%edx
80102e62:	83 e0 0f             	and    $0xf,%eax
80102e65:	c1 ea 04             	shr    $0x4,%edx
80102e68:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e6b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e6e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102e71:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102e74:	89 c2                	mov    %eax,%edx
80102e76:	83 e0 0f             	and    $0xf,%eax
80102e79:	c1 ea 04             	shr    $0x4,%edx
80102e7c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e7f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e82:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102e85:	8b 75 08             	mov    0x8(%ebp),%esi
80102e88:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102e8b:	89 06                	mov    %eax,(%esi)
80102e8d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102e90:	89 46 04             	mov    %eax,0x4(%esi)
80102e93:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102e96:	89 46 08             	mov    %eax,0x8(%esi)
80102e99:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102e9c:	89 46 0c             	mov    %eax,0xc(%esi)
80102e9f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ea2:	89 46 10             	mov    %eax,0x10(%esi)
80102ea5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ea8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102eab:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102eb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eb5:	5b                   	pop    %ebx
80102eb6:	5e                   	pop    %esi
80102eb7:	5f                   	pop    %edi
80102eb8:	5d                   	pop    %ebp
80102eb9:	c3                   	ret    
80102eba:	66 90                	xchg   %ax,%ax
80102ebc:	66 90                	xchg   %ax,%ax
80102ebe:	66 90                	xchg   %ax,%ax

80102ec0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ec0:	8b 0d 88 17 11 80    	mov    0x80111788,%ecx
80102ec6:	85 c9                	test   %ecx,%ecx
80102ec8:	0f 8e 8a 00 00 00    	jle    80102f58 <install_trans+0x98>
{
80102ece:	55                   	push   %ebp
80102ecf:	89 e5                	mov    %esp,%ebp
80102ed1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102ed2:	31 ff                	xor    %edi,%edi
{
80102ed4:	56                   	push   %esi
80102ed5:	53                   	push   %ebx
80102ed6:	83 ec 0c             	sub    $0xc,%esp
80102ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102ee0:	a1 74 17 11 80       	mov    0x80111774,%eax
80102ee5:	83 ec 08             	sub    $0x8,%esp
80102ee8:	01 f8                	add    %edi,%eax
80102eea:	83 c0 01             	add    $0x1,%eax
80102eed:	50                   	push   %eax
80102eee:	ff 35 84 17 11 80    	push   0x80111784
80102ef4:	e8 d7 d1 ff ff       	call   801000d0 <bread>
80102ef9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102efb:	58                   	pop    %eax
80102efc:	5a                   	pop    %edx
80102efd:	ff 34 bd 8c 17 11 80 	push   -0x7feee874(,%edi,4)
80102f04:	ff 35 84 17 11 80    	push   0x80111784
  for (tail = 0; tail < log.lh.n; tail++) {
80102f0a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f0d:	e8 be d1 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102f12:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f15:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102f17:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f1a:	68 00 02 00 00       	push   $0x200
80102f1f:	50                   	push   %eax
80102f20:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102f23:	50                   	push   %eax
80102f24:	e8 d7 1a 00 00       	call   80104a00 <memmove>
    bwrite(dbuf);  // write dst to disk
80102f29:	89 1c 24             	mov    %ebx,(%esp)
80102f2c:	e8 7f d2 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102f31:	89 34 24             	mov    %esi,(%esp)
80102f34:	e8 b7 d2 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102f39:	89 1c 24             	mov    %ebx,(%esp)
80102f3c:	e8 af d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f41:	83 c4 10             	add    $0x10,%esp
80102f44:	39 3d 88 17 11 80    	cmp    %edi,0x80111788
80102f4a:	7f 94                	jg     80102ee0 <install_trans+0x20>
  }
}
80102f4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f4f:	5b                   	pop    %ebx
80102f50:	5e                   	pop    %esi
80102f51:	5f                   	pop    %edi
80102f52:	5d                   	pop    %ebp
80102f53:	c3                   	ret    
80102f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f58:	c3                   	ret    
80102f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f60 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102f60:	55                   	push   %ebp
80102f61:	89 e5                	mov    %esp,%ebp
80102f63:	53                   	push   %ebx
80102f64:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102f67:	ff 35 74 17 11 80    	push   0x80111774
80102f6d:	ff 35 84 17 11 80    	push   0x80111784
80102f73:	e8 58 d1 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102f78:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102f7b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102f7d:	a1 88 17 11 80       	mov    0x80111788,%eax
80102f82:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102f85:	85 c0                	test   %eax,%eax
80102f87:	7e 19                	jle    80102fa2 <write_head+0x42>
80102f89:	31 d2                	xor    %edx,%edx
80102f8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f8f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102f90:	8b 0c 95 8c 17 11 80 	mov    -0x7feee874(,%edx,4),%ecx
80102f97:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102f9b:	83 c2 01             	add    $0x1,%edx
80102f9e:	39 d0                	cmp    %edx,%eax
80102fa0:	75 ee                	jne    80102f90 <write_head+0x30>
  }
  bwrite(buf);
80102fa2:	83 ec 0c             	sub    $0xc,%esp
80102fa5:	53                   	push   %ebx
80102fa6:	e8 05 d2 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102fab:	89 1c 24             	mov    %ebx,(%esp)
80102fae:	e8 3d d2 ff ff       	call   801001f0 <brelse>
}
80102fb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102fb6:	83 c4 10             	add    $0x10,%esp
80102fb9:	c9                   	leave  
80102fba:	c3                   	ret    
80102fbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fbf:	90                   	nop

80102fc0 <initlog>:
{
80102fc0:	55                   	push   %ebp
80102fc1:	89 e5                	mov    %esp,%ebp
80102fc3:	53                   	push   %ebx
80102fc4:	83 ec 2c             	sub    $0x2c,%esp
80102fc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102fca:	68 a0 79 10 80       	push   $0x801079a0
80102fcf:	68 40 17 11 80       	push   $0x80111740
80102fd4:	e8 f7 16 00 00       	call   801046d0 <initlock>
  readsb(dev, &sb);
80102fd9:	58                   	pop    %eax
80102fda:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102fdd:	5a                   	pop    %edx
80102fde:	50                   	push   %eax
80102fdf:	53                   	push   %ebx
80102fe0:	e8 3b e8 ff ff       	call   80101820 <readsb>
  log.start = sb.logstart;
80102fe5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102fe8:	59                   	pop    %ecx
  log.dev = dev;
80102fe9:	89 1d 84 17 11 80    	mov    %ebx,0x80111784
  log.size = sb.nlog;
80102fef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102ff2:	a3 74 17 11 80       	mov    %eax,0x80111774
  log.size = sb.nlog;
80102ff7:	89 15 78 17 11 80    	mov    %edx,0x80111778
  struct buf *buf = bread(log.dev, log.start);
80102ffd:	5a                   	pop    %edx
80102ffe:	50                   	push   %eax
80102fff:	53                   	push   %ebx
80103000:	e8 cb d0 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103005:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80103008:	8b 58 5c             	mov    0x5c(%eax),%ebx
8010300b:	89 1d 88 17 11 80    	mov    %ebx,0x80111788
  for (i = 0; i < log.lh.n; i++) {
80103011:	85 db                	test   %ebx,%ebx
80103013:	7e 1d                	jle    80103032 <initlog+0x72>
80103015:	31 d2                	xor    %edx,%edx
80103017:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010301e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80103020:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80103024:	89 0c 95 8c 17 11 80 	mov    %ecx,-0x7feee874(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010302b:	83 c2 01             	add    $0x1,%edx
8010302e:	39 d3                	cmp    %edx,%ebx
80103030:	75 ee                	jne    80103020 <initlog+0x60>
  brelse(buf);
80103032:	83 ec 0c             	sub    $0xc,%esp
80103035:	50                   	push   %eax
80103036:	e8 b5 d1 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010303b:	e8 80 fe ff ff       	call   80102ec0 <install_trans>
  log.lh.n = 0;
80103040:	c7 05 88 17 11 80 00 	movl   $0x0,0x80111788
80103047:	00 00 00 
  write_head(); // clear the log
8010304a:	e8 11 ff ff ff       	call   80102f60 <write_head>
}
8010304f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103052:	83 c4 10             	add    $0x10,%esp
80103055:	c9                   	leave  
80103056:	c3                   	ret    
80103057:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010305e:	66 90                	xchg   %ax,%ax

80103060 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103060:	55                   	push   %ebp
80103061:	89 e5                	mov    %esp,%ebp
80103063:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103066:	68 40 17 11 80       	push   $0x80111740
8010306b:	e8 30 18 00 00       	call   801048a0 <acquire>
80103070:	83 c4 10             	add    $0x10,%esp
80103073:	eb 18                	jmp    8010308d <begin_op+0x2d>
80103075:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103078:	83 ec 08             	sub    $0x8,%esp
8010307b:	68 40 17 11 80       	push   $0x80111740
80103080:	68 40 17 11 80       	push   $0x80111740
80103085:	e8 b6 12 00 00       	call   80104340 <sleep>
8010308a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010308d:	a1 80 17 11 80       	mov    0x80111780,%eax
80103092:	85 c0                	test   %eax,%eax
80103094:	75 e2                	jne    80103078 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103096:	a1 7c 17 11 80       	mov    0x8011177c,%eax
8010309b:	8b 15 88 17 11 80    	mov    0x80111788,%edx
801030a1:	83 c0 01             	add    $0x1,%eax
801030a4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801030a7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801030aa:	83 fa 1e             	cmp    $0x1e,%edx
801030ad:	7f c9                	jg     80103078 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
801030af:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801030b2:	a3 7c 17 11 80       	mov    %eax,0x8011177c
      release(&log.lock);
801030b7:	68 40 17 11 80       	push   $0x80111740
801030bc:	e8 7f 17 00 00       	call   80104840 <release>
      break;
    }
  }
}
801030c1:	83 c4 10             	add    $0x10,%esp
801030c4:	c9                   	leave  
801030c5:	c3                   	ret    
801030c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030cd:	8d 76 00             	lea    0x0(%esi),%esi

801030d0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801030d0:	55                   	push   %ebp
801030d1:	89 e5                	mov    %esp,%ebp
801030d3:	57                   	push   %edi
801030d4:	56                   	push   %esi
801030d5:	53                   	push   %ebx
801030d6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
801030d9:	68 40 17 11 80       	push   $0x80111740
801030de:	e8 bd 17 00 00       	call   801048a0 <acquire>
  log.outstanding -= 1;
801030e3:	a1 7c 17 11 80       	mov    0x8011177c,%eax
  if(log.committing)
801030e8:	8b 35 80 17 11 80    	mov    0x80111780,%esi
801030ee:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801030f1:	8d 58 ff             	lea    -0x1(%eax),%ebx
801030f4:	89 1d 7c 17 11 80    	mov    %ebx,0x8011177c
  if(log.committing)
801030fa:	85 f6                	test   %esi,%esi
801030fc:	0f 85 22 01 00 00    	jne    80103224 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103102:	85 db                	test   %ebx,%ebx
80103104:	0f 85 f6 00 00 00    	jne    80103200 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010310a:	c7 05 80 17 11 80 01 	movl   $0x1,0x80111780
80103111:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103114:	83 ec 0c             	sub    $0xc,%esp
80103117:	68 40 17 11 80       	push   $0x80111740
8010311c:	e8 1f 17 00 00       	call   80104840 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103121:	8b 0d 88 17 11 80    	mov    0x80111788,%ecx
80103127:	83 c4 10             	add    $0x10,%esp
8010312a:	85 c9                	test   %ecx,%ecx
8010312c:	7f 42                	jg     80103170 <end_op+0xa0>
    acquire(&log.lock);
8010312e:	83 ec 0c             	sub    $0xc,%esp
80103131:	68 40 17 11 80       	push   $0x80111740
80103136:	e8 65 17 00 00       	call   801048a0 <acquire>
    wakeup(&log);
8010313b:	c7 04 24 40 17 11 80 	movl   $0x80111740,(%esp)
    log.committing = 0;
80103142:	c7 05 80 17 11 80 00 	movl   $0x0,0x80111780
80103149:	00 00 00 
    wakeup(&log);
8010314c:	e8 af 12 00 00       	call   80104400 <wakeup>
    release(&log.lock);
80103151:	c7 04 24 40 17 11 80 	movl   $0x80111740,(%esp)
80103158:	e8 e3 16 00 00       	call   80104840 <release>
8010315d:	83 c4 10             	add    $0x10,%esp
}
80103160:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103163:	5b                   	pop    %ebx
80103164:	5e                   	pop    %esi
80103165:	5f                   	pop    %edi
80103166:	5d                   	pop    %ebp
80103167:	c3                   	ret    
80103168:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010316f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103170:	a1 74 17 11 80       	mov    0x80111774,%eax
80103175:	83 ec 08             	sub    $0x8,%esp
80103178:	01 d8                	add    %ebx,%eax
8010317a:	83 c0 01             	add    $0x1,%eax
8010317d:	50                   	push   %eax
8010317e:	ff 35 84 17 11 80    	push   0x80111784
80103184:	e8 47 cf ff ff       	call   801000d0 <bread>
80103189:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010318b:	58                   	pop    %eax
8010318c:	5a                   	pop    %edx
8010318d:	ff 34 9d 8c 17 11 80 	push   -0x7feee874(,%ebx,4)
80103194:	ff 35 84 17 11 80    	push   0x80111784
  for (tail = 0; tail < log.lh.n; tail++) {
8010319a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010319d:	e8 2e cf ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
801031a2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801031a5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801031a7:	8d 40 5c             	lea    0x5c(%eax),%eax
801031aa:	68 00 02 00 00       	push   $0x200
801031af:	50                   	push   %eax
801031b0:	8d 46 5c             	lea    0x5c(%esi),%eax
801031b3:	50                   	push   %eax
801031b4:	e8 47 18 00 00       	call   80104a00 <memmove>
    bwrite(to);  // write the log
801031b9:	89 34 24             	mov    %esi,(%esp)
801031bc:	e8 ef cf ff ff       	call   801001b0 <bwrite>
    brelse(from);
801031c1:	89 3c 24             	mov    %edi,(%esp)
801031c4:	e8 27 d0 ff ff       	call   801001f0 <brelse>
    brelse(to);
801031c9:	89 34 24             	mov    %esi,(%esp)
801031cc:	e8 1f d0 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801031d1:	83 c4 10             	add    $0x10,%esp
801031d4:	3b 1d 88 17 11 80    	cmp    0x80111788,%ebx
801031da:	7c 94                	jl     80103170 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801031dc:	e8 7f fd ff ff       	call   80102f60 <write_head>
    install_trans(); // Now install writes to home locations
801031e1:	e8 da fc ff ff       	call   80102ec0 <install_trans>
    log.lh.n = 0;
801031e6:	c7 05 88 17 11 80 00 	movl   $0x0,0x80111788
801031ed:	00 00 00 
    write_head();    // Erase the transaction from the log
801031f0:	e8 6b fd ff ff       	call   80102f60 <write_head>
801031f5:	e9 34 ff ff ff       	jmp    8010312e <end_op+0x5e>
801031fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103200:	83 ec 0c             	sub    $0xc,%esp
80103203:	68 40 17 11 80       	push   $0x80111740
80103208:	e8 f3 11 00 00       	call   80104400 <wakeup>
  release(&log.lock);
8010320d:	c7 04 24 40 17 11 80 	movl   $0x80111740,(%esp)
80103214:	e8 27 16 00 00       	call   80104840 <release>
80103219:	83 c4 10             	add    $0x10,%esp
}
8010321c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010321f:	5b                   	pop    %ebx
80103220:	5e                   	pop    %esi
80103221:	5f                   	pop    %edi
80103222:	5d                   	pop    %ebp
80103223:	c3                   	ret    
    panic("log.committing");
80103224:	83 ec 0c             	sub    $0xc,%esp
80103227:	68 a4 79 10 80       	push   $0x801079a4
8010322c:	e8 4f d1 ff ff       	call   80100380 <panic>
80103231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010323f:	90                   	nop

80103240 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103240:	55                   	push   %ebp
80103241:	89 e5                	mov    %esp,%ebp
80103243:	53                   	push   %ebx
80103244:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103247:	8b 15 88 17 11 80    	mov    0x80111788,%edx
{
8010324d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103250:	83 fa 1d             	cmp    $0x1d,%edx
80103253:	0f 8f 85 00 00 00    	jg     801032de <log_write+0x9e>
80103259:	a1 78 17 11 80       	mov    0x80111778,%eax
8010325e:	83 e8 01             	sub    $0x1,%eax
80103261:	39 c2                	cmp    %eax,%edx
80103263:	7d 79                	jge    801032de <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103265:	a1 7c 17 11 80       	mov    0x8011177c,%eax
8010326a:	85 c0                	test   %eax,%eax
8010326c:	7e 7d                	jle    801032eb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010326e:	83 ec 0c             	sub    $0xc,%esp
80103271:	68 40 17 11 80       	push   $0x80111740
80103276:	e8 25 16 00 00       	call   801048a0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010327b:	8b 15 88 17 11 80    	mov    0x80111788,%edx
80103281:	83 c4 10             	add    $0x10,%esp
80103284:	85 d2                	test   %edx,%edx
80103286:	7e 4a                	jle    801032d2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103288:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010328b:	31 c0                	xor    %eax,%eax
8010328d:	eb 08                	jmp    80103297 <log_write+0x57>
8010328f:	90                   	nop
80103290:	83 c0 01             	add    $0x1,%eax
80103293:	39 c2                	cmp    %eax,%edx
80103295:	74 29                	je     801032c0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103297:	39 0c 85 8c 17 11 80 	cmp    %ecx,-0x7feee874(,%eax,4)
8010329e:	75 f0                	jne    80103290 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
801032a0:	89 0c 85 8c 17 11 80 	mov    %ecx,-0x7feee874(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801032a7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801032aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801032ad:	c7 45 08 40 17 11 80 	movl   $0x80111740,0x8(%ebp)
}
801032b4:	c9                   	leave  
  release(&log.lock);
801032b5:	e9 86 15 00 00       	jmp    80104840 <release>
801032ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801032c0:	89 0c 95 8c 17 11 80 	mov    %ecx,-0x7feee874(,%edx,4)
    log.lh.n++;
801032c7:	83 c2 01             	add    $0x1,%edx
801032ca:	89 15 88 17 11 80    	mov    %edx,0x80111788
801032d0:	eb d5                	jmp    801032a7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
801032d2:	8b 43 08             	mov    0x8(%ebx),%eax
801032d5:	a3 8c 17 11 80       	mov    %eax,0x8011178c
  if (i == log.lh.n)
801032da:	75 cb                	jne    801032a7 <log_write+0x67>
801032dc:	eb e9                	jmp    801032c7 <log_write+0x87>
    panic("too big a transaction");
801032de:	83 ec 0c             	sub    $0xc,%esp
801032e1:	68 b3 79 10 80       	push   $0x801079b3
801032e6:	e8 95 d0 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
801032eb:	83 ec 0c             	sub    $0xc,%esp
801032ee:	68 c9 79 10 80       	push   $0x801079c9
801032f3:	e8 88 d0 ff ff       	call   80100380 <panic>
801032f8:	66 90                	xchg   %ax,%ax
801032fa:	66 90                	xchg   %ax,%ax
801032fc:	66 90                	xchg   %ax,%ax
801032fe:	66 90                	xchg   %ax,%ax

80103300 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103300:	55                   	push   %ebp
80103301:	89 e5                	mov    %esp,%ebp
80103303:	53                   	push   %ebx
80103304:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103307:	e8 44 09 00 00       	call   80103c50 <cpuid>
8010330c:	89 c3                	mov    %eax,%ebx
8010330e:	e8 3d 09 00 00       	call   80103c50 <cpuid>
80103313:	83 ec 04             	sub    $0x4,%esp
80103316:	53                   	push   %ebx
80103317:	50                   	push   %eax
80103318:	68 e4 79 10 80       	push   $0x801079e4
8010331d:	e8 7e d3 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103322:	e8 b9 28 00 00       	call   80105be0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103327:	e8 c4 08 00 00       	call   80103bf0 <mycpu>
8010332c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010332e:	b8 01 00 00 00       	mov    $0x1,%eax
80103333:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010333a:	e8 f1 0b 00 00       	call   80103f30 <scheduler>
8010333f:	90                   	nop

80103340 <mpenter>:
{
80103340:	55                   	push   %ebp
80103341:	89 e5                	mov    %esp,%ebp
80103343:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103346:	e8 85 39 00 00       	call   80106cd0 <switchkvm>
  seginit();
8010334b:	e8 f0 38 00 00       	call   80106c40 <seginit>
  lapicinit();
80103350:	e8 9b f7 ff ff       	call   80102af0 <lapicinit>
  mpmain();
80103355:	e8 a6 ff ff ff       	call   80103300 <mpmain>
8010335a:	66 90                	xchg   %ax,%ax
8010335c:	66 90                	xchg   %ax,%ax
8010335e:	66 90                	xchg   %ax,%ax

80103360 <main>:
{
80103360:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103364:	83 e4 f0             	and    $0xfffffff0,%esp
80103367:	ff 71 fc             	push   -0x4(%ecx)
8010336a:	55                   	push   %ebp
8010336b:	89 e5                	mov    %esp,%ebp
8010336d:	53                   	push   %ebx
8010336e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010336f:	83 ec 08             	sub    $0x8,%esp
80103372:	68 00 00 40 80       	push   $0x80400000
80103377:	68 70 55 11 80       	push   $0x80115570
8010337c:	e8 8f f5 ff ff       	call   80102910 <kinit1>
  kvmalloc();      // kernel page table
80103381:	e8 3a 3e 00 00       	call   801071c0 <kvmalloc>
  mpinit();        // detect other processors
80103386:	e8 85 01 00 00       	call   80103510 <mpinit>
  lapicinit();     // interrupt controller
8010338b:	e8 60 f7 ff ff       	call   80102af0 <lapicinit>
  seginit();       // segment descriptors
80103390:	e8 ab 38 00 00       	call   80106c40 <seginit>
  picinit();       // disable pic
80103395:	e8 76 03 00 00       	call   80103710 <picinit>
  ioapicinit();    // another interrupt controller
8010339a:	e8 31 f3 ff ff       	call   801026d0 <ioapicinit>
  consoleinit();   // console hardware
8010339f:	e8 bc d9 ff ff       	call   80100d60 <consoleinit>
  uartinit();      // serial port
801033a4:	e8 27 2b 00 00       	call   80105ed0 <uartinit>
  pinit();         // process table
801033a9:	e8 22 08 00 00       	call   80103bd0 <pinit>
  tvinit();        // trap vectors
801033ae:	e8 ad 27 00 00       	call   80105b60 <tvinit>
  binit();         // buffer cache
801033b3:	e8 88 cc ff ff       	call   80100040 <binit>
  fileinit();      // file table
801033b8:	e8 53 dd ff ff       	call   80101110 <fileinit>
  ideinit();       // disk 
801033bd:	e8 fe f0 ff ff       	call   801024c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801033c2:	83 c4 0c             	add    $0xc,%esp
801033c5:	68 8a 00 00 00       	push   $0x8a
801033ca:	68 8c a4 10 80       	push   $0x8010a48c
801033cf:	68 00 70 00 80       	push   $0x80007000
801033d4:	e8 27 16 00 00       	call   80104a00 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801033d9:	83 c4 10             	add    $0x10,%esp
801033dc:	69 05 24 18 11 80 b0 	imul   $0xb0,0x80111824,%eax
801033e3:	00 00 00 
801033e6:	05 40 18 11 80       	add    $0x80111840,%eax
801033eb:	3d 40 18 11 80       	cmp    $0x80111840,%eax
801033f0:	76 7e                	jbe    80103470 <main+0x110>
801033f2:	bb 40 18 11 80       	mov    $0x80111840,%ebx
801033f7:	eb 20                	jmp    80103419 <main+0xb9>
801033f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103400:	69 05 24 18 11 80 b0 	imul   $0xb0,0x80111824,%eax
80103407:	00 00 00 
8010340a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103410:	05 40 18 11 80       	add    $0x80111840,%eax
80103415:	39 c3                	cmp    %eax,%ebx
80103417:	73 57                	jae    80103470 <main+0x110>
    if(c == mycpu())  // We've started already.
80103419:	e8 d2 07 00 00       	call   80103bf0 <mycpu>
8010341e:	39 c3                	cmp    %eax,%ebx
80103420:	74 de                	je     80103400 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103422:	e8 59 f5 ff ff       	call   80102980 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103427:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010342a:	c7 05 f8 6f 00 80 40 	movl   $0x80103340,0x80006ff8
80103431:	33 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103434:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010343b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010343e:	05 00 10 00 00       	add    $0x1000,%eax
80103443:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103448:	0f b6 03             	movzbl (%ebx),%eax
8010344b:	68 00 70 00 00       	push   $0x7000
80103450:	50                   	push   %eax
80103451:	e8 ea f7 ff ff       	call   80102c40 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103456:	83 c4 10             	add    $0x10,%esp
80103459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103460:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103466:	85 c0                	test   %eax,%eax
80103468:	74 f6                	je     80103460 <main+0x100>
8010346a:	eb 94                	jmp    80103400 <main+0xa0>
8010346c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103470:	83 ec 08             	sub    $0x8,%esp
80103473:	68 00 00 00 8e       	push   $0x8e000000
80103478:	68 00 00 40 80       	push   $0x80400000
8010347d:	e8 2e f4 ff ff       	call   801028b0 <kinit2>
  userinit();      // first user process
80103482:	e8 19 08 00 00       	call   80103ca0 <userinit>
  mpmain();        // finish this processor's setup
80103487:	e8 74 fe ff ff       	call   80103300 <mpmain>
8010348c:	66 90                	xchg   %ax,%ax
8010348e:	66 90                	xchg   %ax,%ax

80103490 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103490:	55                   	push   %ebp
80103491:	89 e5                	mov    %esp,%ebp
80103493:	57                   	push   %edi
80103494:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103495:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010349b:	53                   	push   %ebx
  e = addr+len;
8010349c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010349f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801034a2:	39 de                	cmp    %ebx,%esi
801034a4:	72 10                	jb     801034b6 <mpsearch1+0x26>
801034a6:	eb 50                	jmp    801034f8 <mpsearch1+0x68>
801034a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034af:	90                   	nop
801034b0:	89 fe                	mov    %edi,%esi
801034b2:	39 fb                	cmp    %edi,%ebx
801034b4:	76 42                	jbe    801034f8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034b6:	83 ec 04             	sub    $0x4,%esp
801034b9:	8d 7e 10             	lea    0x10(%esi),%edi
801034bc:	6a 04                	push   $0x4
801034be:	68 f8 79 10 80       	push   $0x801079f8
801034c3:	56                   	push   %esi
801034c4:	e8 e7 14 00 00       	call   801049b0 <memcmp>
801034c9:	83 c4 10             	add    $0x10,%esp
801034cc:	85 c0                	test   %eax,%eax
801034ce:	75 e0                	jne    801034b0 <mpsearch1+0x20>
801034d0:	89 f2                	mov    %esi,%edx
801034d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801034d8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801034db:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801034de:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801034e0:	39 fa                	cmp    %edi,%edx
801034e2:	75 f4                	jne    801034d8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034e4:	84 c0                	test   %al,%al
801034e6:	75 c8                	jne    801034b0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801034e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034eb:	89 f0                	mov    %esi,%eax
801034ed:	5b                   	pop    %ebx
801034ee:	5e                   	pop    %esi
801034ef:	5f                   	pop    %edi
801034f0:	5d                   	pop    %ebp
801034f1:	c3                   	ret    
801034f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801034f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034fb:	31 f6                	xor    %esi,%esi
}
801034fd:	5b                   	pop    %ebx
801034fe:	89 f0                	mov    %esi,%eax
80103500:	5e                   	pop    %esi
80103501:	5f                   	pop    %edi
80103502:	5d                   	pop    %ebp
80103503:	c3                   	ret    
80103504:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010350b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010350f:	90                   	nop

80103510 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103510:	55                   	push   %ebp
80103511:	89 e5                	mov    %esp,%ebp
80103513:	57                   	push   %edi
80103514:	56                   	push   %esi
80103515:	53                   	push   %ebx
80103516:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103519:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103520:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103527:	c1 e0 08             	shl    $0x8,%eax
8010352a:	09 d0                	or     %edx,%eax
8010352c:	c1 e0 04             	shl    $0x4,%eax
8010352f:	75 1b                	jne    8010354c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103531:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103538:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010353f:	c1 e0 08             	shl    $0x8,%eax
80103542:	09 d0                	or     %edx,%eax
80103544:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103547:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010354c:	ba 00 04 00 00       	mov    $0x400,%edx
80103551:	e8 3a ff ff ff       	call   80103490 <mpsearch1>
80103556:	89 c3                	mov    %eax,%ebx
80103558:	85 c0                	test   %eax,%eax
8010355a:	0f 84 40 01 00 00    	je     801036a0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103560:	8b 73 04             	mov    0x4(%ebx),%esi
80103563:	85 f6                	test   %esi,%esi
80103565:	0f 84 25 01 00 00    	je     80103690 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010356b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010356e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103574:	6a 04                	push   $0x4
80103576:	68 fd 79 10 80       	push   $0x801079fd
8010357b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010357c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010357f:	e8 2c 14 00 00       	call   801049b0 <memcmp>
80103584:	83 c4 10             	add    $0x10,%esp
80103587:	85 c0                	test   %eax,%eax
80103589:	0f 85 01 01 00 00    	jne    80103690 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010358f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103596:	3c 01                	cmp    $0x1,%al
80103598:	74 08                	je     801035a2 <mpinit+0x92>
8010359a:	3c 04                	cmp    $0x4,%al
8010359c:	0f 85 ee 00 00 00    	jne    80103690 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801035a2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801035a9:	66 85 d2             	test   %dx,%dx
801035ac:	74 22                	je     801035d0 <mpinit+0xc0>
801035ae:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801035b1:	89 f0                	mov    %esi,%eax
  sum = 0;
801035b3:	31 d2                	xor    %edx,%edx
801035b5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801035b8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801035bf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801035c2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801035c4:	39 c7                	cmp    %eax,%edi
801035c6:	75 f0                	jne    801035b8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801035c8:	84 d2                	test   %dl,%dl
801035ca:	0f 85 c0 00 00 00    	jne    80103690 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801035d0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801035d6:	a3 20 17 11 80       	mov    %eax,0x80111720
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801035db:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801035e2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801035e8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801035ed:	03 55 e4             	add    -0x1c(%ebp),%edx
801035f0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801035f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035f7:	90                   	nop
801035f8:	39 d0                	cmp    %edx,%eax
801035fa:	73 15                	jae    80103611 <mpinit+0x101>
    switch(*p){
801035fc:	0f b6 08             	movzbl (%eax),%ecx
801035ff:	80 f9 02             	cmp    $0x2,%cl
80103602:	74 4c                	je     80103650 <mpinit+0x140>
80103604:	77 3a                	ja     80103640 <mpinit+0x130>
80103606:	84 c9                	test   %cl,%cl
80103608:	74 56                	je     80103660 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010360a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010360d:	39 d0                	cmp    %edx,%eax
8010360f:	72 eb                	jb     801035fc <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103611:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103614:	85 f6                	test   %esi,%esi
80103616:	0f 84 d9 00 00 00    	je     801036f5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010361c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103620:	74 15                	je     80103637 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103622:	b8 70 00 00 00       	mov    $0x70,%eax
80103627:	ba 22 00 00 00       	mov    $0x22,%edx
8010362c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010362d:	ba 23 00 00 00       	mov    $0x23,%edx
80103632:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103633:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103636:	ee                   	out    %al,(%dx)
  }
}
80103637:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010363a:	5b                   	pop    %ebx
8010363b:	5e                   	pop    %esi
8010363c:	5f                   	pop    %edi
8010363d:	5d                   	pop    %ebp
8010363e:	c3                   	ret    
8010363f:	90                   	nop
    switch(*p){
80103640:	83 e9 03             	sub    $0x3,%ecx
80103643:	80 f9 01             	cmp    $0x1,%cl
80103646:	76 c2                	jbe    8010360a <mpinit+0xfa>
80103648:	31 f6                	xor    %esi,%esi
8010364a:	eb ac                	jmp    801035f8 <mpinit+0xe8>
8010364c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103650:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103654:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103657:	88 0d 20 18 11 80    	mov    %cl,0x80111820
      continue;
8010365d:	eb 99                	jmp    801035f8 <mpinit+0xe8>
8010365f:	90                   	nop
      if(ncpu < NCPU) {
80103660:	8b 0d 24 18 11 80    	mov    0x80111824,%ecx
80103666:	83 f9 07             	cmp    $0x7,%ecx
80103669:	7f 19                	jg     80103684 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010366b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103671:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103675:	83 c1 01             	add    $0x1,%ecx
80103678:	89 0d 24 18 11 80    	mov    %ecx,0x80111824
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010367e:	88 9f 40 18 11 80    	mov    %bl,-0x7feee7c0(%edi)
      p += sizeof(struct mpproc);
80103684:	83 c0 14             	add    $0x14,%eax
      continue;
80103687:	e9 6c ff ff ff       	jmp    801035f8 <mpinit+0xe8>
8010368c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103690:	83 ec 0c             	sub    $0xc,%esp
80103693:	68 02 7a 10 80       	push   $0x80107a02
80103698:	e8 e3 cc ff ff       	call   80100380 <panic>
8010369d:	8d 76 00             	lea    0x0(%esi),%esi
{
801036a0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801036a5:	eb 13                	jmp    801036ba <mpinit+0x1aa>
801036a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036ae:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801036b0:	89 f3                	mov    %esi,%ebx
801036b2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801036b8:	74 d6                	je     80103690 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801036ba:	83 ec 04             	sub    $0x4,%esp
801036bd:	8d 73 10             	lea    0x10(%ebx),%esi
801036c0:	6a 04                	push   $0x4
801036c2:	68 f8 79 10 80       	push   $0x801079f8
801036c7:	53                   	push   %ebx
801036c8:	e8 e3 12 00 00       	call   801049b0 <memcmp>
801036cd:	83 c4 10             	add    $0x10,%esp
801036d0:	85 c0                	test   %eax,%eax
801036d2:	75 dc                	jne    801036b0 <mpinit+0x1a0>
801036d4:	89 da                	mov    %ebx,%edx
801036d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036dd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801036e0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801036e3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801036e6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801036e8:	39 d6                	cmp    %edx,%esi
801036ea:	75 f4                	jne    801036e0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801036ec:	84 c0                	test   %al,%al
801036ee:	75 c0                	jne    801036b0 <mpinit+0x1a0>
801036f0:	e9 6b fe ff ff       	jmp    80103560 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801036f5:	83 ec 0c             	sub    $0xc,%esp
801036f8:	68 1c 7a 10 80       	push   $0x80107a1c
801036fd:	e8 7e cc ff ff       	call   80100380 <panic>
80103702:	66 90                	xchg   %ax,%ax
80103704:	66 90                	xchg   %ax,%ax
80103706:	66 90                	xchg   %ax,%ax
80103708:	66 90                	xchg   %ax,%ax
8010370a:	66 90                	xchg   %ax,%ax
8010370c:	66 90                	xchg   %ax,%ax
8010370e:	66 90                	xchg   %ax,%ax

80103710 <picinit>:
80103710:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103715:	ba 21 00 00 00       	mov    $0x21,%edx
8010371a:	ee                   	out    %al,(%dx)
8010371b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103720:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103721:	c3                   	ret    
80103722:	66 90                	xchg   %ax,%ax
80103724:	66 90                	xchg   %ax,%ax
80103726:	66 90                	xchg   %ax,%ax
80103728:	66 90                	xchg   %ax,%ax
8010372a:	66 90                	xchg   %ax,%ax
8010372c:	66 90                	xchg   %ax,%ax
8010372e:	66 90                	xchg   %ax,%ax

80103730 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103730:	55                   	push   %ebp
80103731:	89 e5                	mov    %esp,%ebp
80103733:	57                   	push   %edi
80103734:	56                   	push   %esi
80103735:	53                   	push   %ebx
80103736:	83 ec 0c             	sub    $0xc,%esp
80103739:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010373c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010373f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103745:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010374b:	e8 e0 d9 ff ff       	call   80101130 <filealloc>
80103750:	89 03                	mov    %eax,(%ebx)
80103752:	85 c0                	test   %eax,%eax
80103754:	0f 84 a8 00 00 00    	je     80103802 <pipealloc+0xd2>
8010375a:	e8 d1 d9 ff ff       	call   80101130 <filealloc>
8010375f:	89 06                	mov    %eax,(%esi)
80103761:	85 c0                	test   %eax,%eax
80103763:	0f 84 87 00 00 00    	je     801037f0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103769:	e8 12 f2 ff ff       	call   80102980 <kalloc>
8010376e:	89 c7                	mov    %eax,%edi
80103770:	85 c0                	test   %eax,%eax
80103772:	0f 84 b0 00 00 00    	je     80103828 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103778:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010377f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103782:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103785:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010378c:	00 00 00 
  p->nwrite = 0;
8010378f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103796:	00 00 00 
  p->nread = 0;
80103799:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801037a0:	00 00 00 
  initlock(&p->lock, "pipe");
801037a3:	68 3b 7a 10 80       	push   $0x80107a3b
801037a8:	50                   	push   %eax
801037a9:	e8 22 0f 00 00       	call   801046d0 <initlock>
  (*f0)->type = FD_PIPE;
801037ae:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801037b0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801037b3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801037b9:	8b 03                	mov    (%ebx),%eax
801037bb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801037bf:	8b 03                	mov    (%ebx),%eax
801037c1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801037c5:	8b 03                	mov    (%ebx),%eax
801037c7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801037ca:	8b 06                	mov    (%esi),%eax
801037cc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801037d2:	8b 06                	mov    (%esi),%eax
801037d4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801037d8:	8b 06                	mov    (%esi),%eax
801037da:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801037de:	8b 06                	mov    (%esi),%eax
801037e0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801037e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801037e6:	31 c0                	xor    %eax,%eax
}
801037e8:	5b                   	pop    %ebx
801037e9:	5e                   	pop    %esi
801037ea:	5f                   	pop    %edi
801037eb:	5d                   	pop    %ebp
801037ec:	c3                   	ret    
801037ed:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801037f0:	8b 03                	mov    (%ebx),%eax
801037f2:	85 c0                	test   %eax,%eax
801037f4:	74 1e                	je     80103814 <pipealloc+0xe4>
    fileclose(*f0);
801037f6:	83 ec 0c             	sub    $0xc,%esp
801037f9:	50                   	push   %eax
801037fa:	e8 f1 d9 ff ff       	call   801011f0 <fileclose>
801037ff:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103802:	8b 06                	mov    (%esi),%eax
80103804:	85 c0                	test   %eax,%eax
80103806:	74 0c                	je     80103814 <pipealloc+0xe4>
    fileclose(*f1);
80103808:	83 ec 0c             	sub    $0xc,%esp
8010380b:	50                   	push   %eax
8010380c:	e8 df d9 ff ff       	call   801011f0 <fileclose>
80103811:	83 c4 10             	add    $0x10,%esp
}
80103814:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103817:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010381c:	5b                   	pop    %ebx
8010381d:	5e                   	pop    %esi
8010381e:	5f                   	pop    %edi
8010381f:	5d                   	pop    %ebp
80103820:	c3                   	ret    
80103821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103828:	8b 03                	mov    (%ebx),%eax
8010382a:	85 c0                	test   %eax,%eax
8010382c:	75 c8                	jne    801037f6 <pipealloc+0xc6>
8010382e:	eb d2                	jmp    80103802 <pipealloc+0xd2>

80103830 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	56                   	push   %esi
80103834:	53                   	push   %ebx
80103835:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103838:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010383b:	83 ec 0c             	sub    $0xc,%esp
8010383e:	53                   	push   %ebx
8010383f:	e8 5c 10 00 00       	call   801048a0 <acquire>
  if(writable){
80103844:	83 c4 10             	add    $0x10,%esp
80103847:	85 f6                	test   %esi,%esi
80103849:	74 65                	je     801038b0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010384b:	83 ec 0c             	sub    $0xc,%esp
8010384e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103854:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010385b:	00 00 00 
    wakeup(&p->nread);
8010385e:	50                   	push   %eax
8010385f:	e8 9c 0b 00 00       	call   80104400 <wakeup>
80103864:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103867:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010386d:	85 d2                	test   %edx,%edx
8010386f:	75 0a                	jne    8010387b <pipeclose+0x4b>
80103871:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103877:	85 c0                	test   %eax,%eax
80103879:	74 15                	je     80103890 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010387b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010387e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103881:	5b                   	pop    %ebx
80103882:	5e                   	pop    %esi
80103883:	5d                   	pop    %ebp
    release(&p->lock);
80103884:	e9 b7 0f 00 00       	jmp    80104840 <release>
80103889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103890:	83 ec 0c             	sub    $0xc,%esp
80103893:	53                   	push   %ebx
80103894:	e8 a7 0f 00 00       	call   80104840 <release>
    kfree((char*)p);
80103899:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010389c:	83 c4 10             	add    $0x10,%esp
}
8010389f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038a2:	5b                   	pop    %ebx
801038a3:	5e                   	pop    %esi
801038a4:	5d                   	pop    %ebp
    kfree((char*)p);
801038a5:	e9 16 ef ff ff       	jmp    801027c0 <kfree>
801038aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801038b0:	83 ec 0c             	sub    $0xc,%esp
801038b3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801038b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801038c0:	00 00 00 
    wakeup(&p->nwrite);
801038c3:	50                   	push   %eax
801038c4:	e8 37 0b 00 00       	call   80104400 <wakeup>
801038c9:	83 c4 10             	add    $0x10,%esp
801038cc:	eb 99                	jmp    80103867 <pipeclose+0x37>
801038ce:	66 90                	xchg   %ax,%ax

801038d0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	57                   	push   %edi
801038d4:	56                   	push   %esi
801038d5:	53                   	push   %ebx
801038d6:	83 ec 28             	sub    $0x28,%esp
801038d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801038dc:	53                   	push   %ebx
801038dd:	e8 be 0f 00 00       	call   801048a0 <acquire>
  for(i = 0; i < n; i++){
801038e2:	8b 45 10             	mov    0x10(%ebp),%eax
801038e5:	83 c4 10             	add    $0x10,%esp
801038e8:	85 c0                	test   %eax,%eax
801038ea:	0f 8e c0 00 00 00    	jle    801039b0 <pipewrite+0xe0>
801038f0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801038f3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801038f9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801038ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103902:	03 45 10             	add    0x10(%ebp),%eax
80103905:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103908:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010390e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103914:	89 ca                	mov    %ecx,%edx
80103916:	05 00 02 00 00       	add    $0x200,%eax
8010391b:	39 c1                	cmp    %eax,%ecx
8010391d:	74 3f                	je     8010395e <pipewrite+0x8e>
8010391f:	eb 67                	jmp    80103988 <pipewrite+0xb8>
80103921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103928:	e8 43 03 00 00       	call   80103c70 <myproc>
8010392d:	8b 48 24             	mov    0x24(%eax),%ecx
80103930:	85 c9                	test   %ecx,%ecx
80103932:	75 34                	jne    80103968 <pipewrite+0x98>
      wakeup(&p->nread);
80103934:	83 ec 0c             	sub    $0xc,%esp
80103937:	57                   	push   %edi
80103938:	e8 c3 0a 00 00       	call   80104400 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010393d:	58                   	pop    %eax
8010393e:	5a                   	pop    %edx
8010393f:	53                   	push   %ebx
80103940:	56                   	push   %esi
80103941:	e8 fa 09 00 00       	call   80104340 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103946:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010394c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103952:	83 c4 10             	add    $0x10,%esp
80103955:	05 00 02 00 00       	add    $0x200,%eax
8010395a:	39 c2                	cmp    %eax,%edx
8010395c:	75 2a                	jne    80103988 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010395e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103964:	85 c0                	test   %eax,%eax
80103966:	75 c0                	jne    80103928 <pipewrite+0x58>
        release(&p->lock);
80103968:	83 ec 0c             	sub    $0xc,%esp
8010396b:	53                   	push   %ebx
8010396c:	e8 cf 0e 00 00       	call   80104840 <release>
        return -1;
80103971:	83 c4 10             	add    $0x10,%esp
80103974:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103979:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010397c:	5b                   	pop    %ebx
8010397d:	5e                   	pop    %esi
8010397e:	5f                   	pop    %edi
8010397f:	5d                   	pop    %ebp
80103980:	c3                   	ret    
80103981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103988:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010398b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010398e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103994:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010399a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010399d:	83 c6 01             	add    $0x1,%esi
801039a0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801039a3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801039a7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801039aa:	0f 85 58 ff ff ff    	jne    80103908 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801039b0:	83 ec 0c             	sub    $0xc,%esp
801039b3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801039b9:	50                   	push   %eax
801039ba:	e8 41 0a 00 00       	call   80104400 <wakeup>
  release(&p->lock);
801039bf:	89 1c 24             	mov    %ebx,(%esp)
801039c2:	e8 79 0e 00 00       	call   80104840 <release>
  return n;
801039c7:	8b 45 10             	mov    0x10(%ebp),%eax
801039ca:	83 c4 10             	add    $0x10,%esp
801039cd:	eb aa                	jmp    80103979 <pipewrite+0xa9>
801039cf:	90                   	nop

801039d0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	57                   	push   %edi
801039d4:	56                   	push   %esi
801039d5:	53                   	push   %ebx
801039d6:	83 ec 18             	sub    $0x18,%esp
801039d9:	8b 75 08             	mov    0x8(%ebp),%esi
801039dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801039df:	56                   	push   %esi
801039e0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801039e6:	e8 b5 0e 00 00       	call   801048a0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801039eb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801039f1:	83 c4 10             	add    $0x10,%esp
801039f4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801039fa:	74 2f                	je     80103a2b <piperead+0x5b>
801039fc:	eb 37                	jmp    80103a35 <piperead+0x65>
801039fe:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103a00:	e8 6b 02 00 00       	call   80103c70 <myproc>
80103a05:	8b 48 24             	mov    0x24(%eax),%ecx
80103a08:	85 c9                	test   %ecx,%ecx
80103a0a:	0f 85 80 00 00 00    	jne    80103a90 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103a10:	83 ec 08             	sub    $0x8,%esp
80103a13:	56                   	push   %esi
80103a14:	53                   	push   %ebx
80103a15:	e8 26 09 00 00       	call   80104340 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103a1a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103a20:	83 c4 10             	add    $0x10,%esp
80103a23:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103a29:	75 0a                	jne    80103a35 <piperead+0x65>
80103a2b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103a31:	85 c0                	test   %eax,%eax
80103a33:	75 cb                	jne    80103a00 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103a35:	8b 55 10             	mov    0x10(%ebp),%edx
80103a38:	31 db                	xor    %ebx,%ebx
80103a3a:	85 d2                	test   %edx,%edx
80103a3c:	7f 20                	jg     80103a5e <piperead+0x8e>
80103a3e:	eb 2c                	jmp    80103a6c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103a40:	8d 48 01             	lea    0x1(%eax),%ecx
80103a43:	25 ff 01 00 00       	and    $0x1ff,%eax
80103a48:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103a4e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103a53:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103a56:	83 c3 01             	add    $0x1,%ebx
80103a59:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103a5c:	74 0e                	je     80103a6c <piperead+0x9c>
    if(p->nread == p->nwrite)
80103a5e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103a64:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103a6a:	75 d4                	jne    80103a40 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103a6c:	83 ec 0c             	sub    $0xc,%esp
80103a6f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103a75:	50                   	push   %eax
80103a76:	e8 85 09 00 00       	call   80104400 <wakeup>
  release(&p->lock);
80103a7b:	89 34 24             	mov    %esi,(%esp)
80103a7e:	e8 bd 0d 00 00       	call   80104840 <release>
  return i;
80103a83:	83 c4 10             	add    $0x10,%esp
}
80103a86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a89:	89 d8                	mov    %ebx,%eax
80103a8b:	5b                   	pop    %ebx
80103a8c:	5e                   	pop    %esi
80103a8d:	5f                   	pop    %edi
80103a8e:	5d                   	pop    %ebp
80103a8f:	c3                   	ret    
      release(&p->lock);
80103a90:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103a93:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103a98:	56                   	push   %esi
80103a99:	e8 a2 0d 00 00       	call   80104840 <release>
      return -1;
80103a9e:	83 c4 10             	add    $0x10,%esp
}
80103aa1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103aa4:	89 d8                	mov    %ebx,%eax
80103aa6:	5b                   	pop    %ebx
80103aa7:	5e                   	pop    %esi
80103aa8:	5f                   	pop    %edi
80103aa9:	5d                   	pop    %ebp
80103aaa:	c3                   	ret    
80103aab:	66 90                	xchg   %ax,%ax
80103aad:	66 90                	xchg   %ax,%ax
80103aaf:	90                   	nop

80103ab0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ab4:	bb f4 1d 11 80       	mov    $0x80111df4,%ebx
{
80103ab9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103abc:	68 c0 1d 11 80       	push   $0x80111dc0
80103ac1:	e8 da 0d 00 00       	call   801048a0 <acquire>
80103ac6:	83 c4 10             	add    $0x10,%esp
80103ac9:	eb 10                	jmp    80103adb <allocproc+0x2b>
80103acb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103acf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ad0:	83 c3 7c             	add    $0x7c,%ebx
80103ad3:	81 fb f4 3c 11 80    	cmp    $0x80113cf4,%ebx
80103ad9:	74 75                	je     80103b50 <allocproc+0xa0>
    if(p->state == UNUSED)
80103adb:	8b 43 0c             	mov    0xc(%ebx),%eax
80103ade:	85 c0                	test   %eax,%eax
80103ae0:	75 ee                	jne    80103ad0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103ae2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103ae7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103aea:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103af1:	89 43 10             	mov    %eax,0x10(%ebx)
80103af4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103af7:	68 c0 1d 11 80       	push   $0x80111dc0
  p->pid = nextpid++;
80103afc:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103b02:	e8 39 0d 00 00       	call   80104840 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103b07:	e8 74 ee ff ff       	call   80102980 <kalloc>
80103b0c:	83 c4 10             	add    $0x10,%esp
80103b0f:	89 43 08             	mov    %eax,0x8(%ebx)
80103b12:	85 c0                	test   %eax,%eax
80103b14:	74 53                	je     80103b69 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103b16:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103b1c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103b1f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103b24:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103b27:	c7 40 14 52 5b 10 80 	movl   $0x80105b52,0x14(%eax)
  p->context = (struct context*)sp;
80103b2e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103b31:	6a 14                	push   $0x14
80103b33:	6a 00                	push   $0x0
80103b35:	50                   	push   %eax
80103b36:	e8 25 0e 00 00       	call   80104960 <memset>
  p->context->eip = (uint)forkret;
80103b3b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103b3e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103b41:	c7 40 10 80 3b 10 80 	movl   $0x80103b80,0x10(%eax)
}
80103b48:	89 d8                	mov    %ebx,%eax
80103b4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b4d:	c9                   	leave  
80103b4e:	c3                   	ret    
80103b4f:	90                   	nop
  release(&ptable.lock);
80103b50:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103b53:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103b55:	68 c0 1d 11 80       	push   $0x80111dc0
80103b5a:	e8 e1 0c 00 00       	call   80104840 <release>
}
80103b5f:	89 d8                	mov    %ebx,%eax
  return 0;
80103b61:	83 c4 10             	add    $0x10,%esp
}
80103b64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b67:	c9                   	leave  
80103b68:	c3                   	ret    
    p->state = UNUSED;
80103b69:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103b70:	31 db                	xor    %ebx,%ebx
}
80103b72:	89 d8                	mov    %ebx,%eax
80103b74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b77:	c9                   	leave  
80103b78:	c3                   	ret    
80103b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b80 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103b86:	68 c0 1d 11 80       	push   $0x80111dc0
80103b8b:	e8 b0 0c 00 00       	call   80104840 <release>

  if (first) {
80103b90:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103b95:	83 c4 10             	add    $0x10,%esp
80103b98:	85 c0                	test   %eax,%eax
80103b9a:	75 04                	jne    80103ba0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103b9c:	c9                   	leave  
80103b9d:	c3                   	ret    
80103b9e:	66 90                	xchg   %ax,%ax
    first = 0;
80103ba0:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103ba7:	00 00 00 
    iinit(ROOTDEV);
80103baa:	83 ec 0c             	sub    $0xc,%esp
80103bad:	6a 01                	push   $0x1
80103baf:	e8 ac dc ff ff       	call   80101860 <iinit>
    initlog(ROOTDEV);
80103bb4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103bbb:	e8 00 f4 ff ff       	call   80102fc0 <initlog>
}
80103bc0:	83 c4 10             	add    $0x10,%esp
80103bc3:	c9                   	leave  
80103bc4:	c3                   	ret    
80103bc5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103bd0 <pinit>:
{
80103bd0:	55                   	push   %ebp
80103bd1:	89 e5                	mov    %esp,%ebp
80103bd3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103bd6:	68 40 7a 10 80       	push   $0x80107a40
80103bdb:	68 c0 1d 11 80       	push   $0x80111dc0
80103be0:	e8 eb 0a 00 00       	call   801046d0 <initlock>
}
80103be5:	83 c4 10             	add    $0x10,%esp
80103be8:	c9                   	leave  
80103be9:	c3                   	ret    
80103bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103bf0 <mycpu>:
{
80103bf0:	55                   	push   %ebp
80103bf1:	89 e5                	mov    %esp,%ebp
80103bf3:	56                   	push   %esi
80103bf4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103bf5:	9c                   	pushf  
80103bf6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103bf7:	f6 c4 02             	test   $0x2,%ah
80103bfa:	75 46                	jne    80103c42 <mycpu+0x52>
  apicid = lapicid();
80103bfc:	e8 ef ef ff ff       	call   80102bf0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103c01:	8b 35 24 18 11 80    	mov    0x80111824,%esi
80103c07:	85 f6                	test   %esi,%esi
80103c09:	7e 2a                	jle    80103c35 <mycpu+0x45>
80103c0b:	31 d2                	xor    %edx,%edx
80103c0d:	eb 08                	jmp    80103c17 <mycpu+0x27>
80103c0f:	90                   	nop
80103c10:	83 c2 01             	add    $0x1,%edx
80103c13:	39 f2                	cmp    %esi,%edx
80103c15:	74 1e                	je     80103c35 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103c17:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103c1d:	0f b6 99 40 18 11 80 	movzbl -0x7feee7c0(%ecx),%ebx
80103c24:	39 c3                	cmp    %eax,%ebx
80103c26:	75 e8                	jne    80103c10 <mycpu+0x20>
}
80103c28:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103c2b:	8d 81 40 18 11 80    	lea    -0x7feee7c0(%ecx),%eax
}
80103c31:	5b                   	pop    %ebx
80103c32:	5e                   	pop    %esi
80103c33:	5d                   	pop    %ebp
80103c34:	c3                   	ret    
  panic("unknown apicid\n");
80103c35:	83 ec 0c             	sub    $0xc,%esp
80103c38:	68 47 7a 10 80       	push   $0x80107a47
80103c3d:	e8 3e c7 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103c42:	83 ec 0c             	sub    $0xc,%esp
80103c45:	68 24 7b 10 80       	push   $0x80107b24
80103c4a:	e8 31 c7 ff ff       	call   80100380 <panic>
80103c4f:	90                   	nop

80103c50 <cpuid>:
cpuid() {
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103c56:	e8 95 ff ff ff       	call   80103bf0 <mycpu>
}
80103c5b:	c9                   	leave  
  return mycpu()-cpus;
80103c5c:	2d 40 18 11 80       	sub    $0x80111840,%eax
80103c61:	c1 f8 04             	sar    $0x4,%eax
80103c64:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103c6a:	c3                   	ret    
80103c6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c6f:	90                   	nop

80103c70 <myproc>:
myproc(void) {
80103c70:	55                   	push   %ebp
80103c71:	89 e5                	mov    %esp,%ebp
80103c73:	53                   	push   %ebx
80103c74:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103c77:	e8 d4 0a 00 00       	call   80104750 <pushcli>
  c = mycpu();
80103c7c:	e8 6f ff ff ff       	call   80103bf0 <mycpu>
  p = c->proc;
80103c81:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c87:	e8 14 0b 00 00       	call   801047a0 <popcli>
}
80103c8c:	89 d8                	mov    %ebx,%eax
80103c8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c91:	c9                   	leave  
80103c92:	c3                   	ret    
80103c93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ca0 <userinit>:
{
80103ca0:	55                   	push   %ebp
80103ca1:	89 e5                	mov    %esp,%ebp
80103ca3:	53                   	push   %ebx
80103ca4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103ca7:	e8 04 fe ff ff       	call   80103ab0 <allocproc>
80103cac:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103cae:	a3 f4 3c 11 80       	mov    %eax,0x80113cf4
  if((p->pgdir = setupkvm()) == 0)
80103cb3:	e8 88 34 00 00       	call   80107140 <setupkvm>
80103cb8:	89 43 04             	mov    %eax,0x4(%ebx)
80103cbb:	85 c0                	test   %eax,%eax
80103cbd:	0f 84 bd 00 00 00    	je     80103d80 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103cc3:	83 ec 04             	sub    $0x4,%esp
80103cc6:	68 2c 00 00 00       	push   $0x2c
80103ccb:	68 60 a4 10 80       	push   $0x8010a460
80103cd0:	50                   	push   %eax
80103cd1:	e8 1a 31 00 00       	call   80106df0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103cd6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103cd9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103cdf:	6a 4c                	push   $0x4c
80103ce1:	6a 00                	push   $0x0
80103ce3:	ff 73 18             	push   0x18(%ebx)
80103ce6:	e8 75 0c 00 00       	call   80104960 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103ceb:	8b 43 18             	mov    0x18(%ebx),%eax
80103cee:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103cf3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103cf6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103cfb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103cff:	8b 43 18             	mov    0x18(%ebx),%eax
80103d02:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103d06:	8b 43 18             	mov    0x18(%ebx),%eax
80103d09:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103d0d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103d11:	8b 43 18             	mov    0x18(%ebx),%eax
80103d14:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103d18:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103d1c:	8b 43 18             	mov    0x18(%ebx),%eax
80103d1f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103d26:	8b 43 18             	mov    0x18(%ebx),%eax
80103d29:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103d30:	8b 43 18             	mov    0x18(%ebx),%eax
80103d33:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103d3a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103d3d:	6a 10                	push   $0x10
80103d3f:	68 70 7a 10 80       	push   $0x80107a70
80103d44:	50                   	push   %eax
80103d45:	e8 d6 0d 00 00       	call   80104b20 <safestrcpy>
  p->cwd = namei("/");
80103d4a:	c7 04 24 79 7a 10 80 	movl   $0x80107a79,(%esp)
80103d51:	e8 4a e6 ff ff       	call   801023a0 <namei>
80103d56:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103d59:	c7 04 24 c0 1d 11 80 	movl   $0x80111dc0,(%esp)
80103d60:	e8 3b 0b 00 00       	call   801048a0 <acquire>
  p->state = RUNNABLE;
80103d65:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103d6c:	c7 04 24 c0 1d 11 80 	movl   $0x80111dc0,(%esp)
80103d73:	e8 c8 0a 00 00       	call   80104840 <release>
}
80103d78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d7b:	83 c4 10             	add    $0x10,%esp
80103d7e:	c9                   	leave  
80103d7f:	c3                   	ret    
    panic("userinit: out of memory?");
80103d80:	83 ec 0c             	sub    $0xc,%esp
80103d83:	68 57 7a 10 80       	push   $0x80107a57
80103d88:	e8 f3 c5 ff ff       	call   80100380 <panic>
80103d8d:	8d 76 00             	lea    0x0(%esi),%esi

80103d90 <growproc>:
{
80103d90:	55                   	push   %ebp
80103d91:	89 e5                	mov    %esp,%ebp
80103d93:	56                   	push   %esi
80103d94:	53                   	push   %ebx
80103d95:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103d98:	e8 b3 09 00 00       	call   80104750 <pushcli>
  c = mycpu();
80103d9d:	e8 4e fe ff ff       	call   80103bf0 <mycpu>
  p = c->proc;
80103da2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103da8:	e8 f3 09 00 00       	call   801047a0 <popcli>
  sz = curproc->sz;
80103dad:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103daf:	85 f6                	test   %esi,%esi
80103db1:	7f 1d                	jg     80103dd0 <growproc+0x40>
  } else if(n < 0){
80103db3:	75 3b                	jne    80103df0 <growproc+0x60>
  switchuvm(curproc);
80103db5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103db8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103dba:	53                   	push   %ebx
80103dbb:	e8 20 2f 00 00       	call   80106ce0 <switchuvm>
  return 0;
80103dc0:	83 c4 10             	add    $0x10,%esp
80103dc3:	31 c0                	xor    %eax,%eax
}
80103dc5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103dc8:	5b                   	pop    %ebx
80103dc9:	5e                   	pop    %esi
80103dca:	5d                   	pop    %ebp
80103dcb:	c3                   	ret    
80103dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103dd0:	83 ec 04             	sub    $0x4,%esp
80103dd3:	01 c6                	add    %eax,%esi
80103dd5:	56                   	push   %esi
80103dd6:	50                   	push   %eax
80103dd7:	ff 73 04             	push   0x4(%ebx)
80103dda:	e8 81 31 00 00       	call   80106f60 <allocuvm>
80103ddf:	83 c4 10             	add    $0x10,%esp
80103de2:	85 c0                	test   %eax,%eax
80103de4:	75 cf                	jne    80103db5 <growproc+0x25>
      return -1;
80103de6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103deb:	eb d8                	jmp    80103dc5 <growproc+0x35>
80103ded:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103df0:	83 ec 04             	sub    $0x4,%esp
80103df3:	01 c6                	add    %eax,%esi
80103df5:	56                   	push   %esi
80103df6:	50                   	push   %eax
80103df7:	ff 73 04             	push   0x4(%ebx)
80103dfa:	e8 91 32 00 00       	call   80107090 <deallocuvm>
80103dff:	83 c4 10             	add    $0x10,%esp
80103e02:	85 c0                	test   %eax,%eax
80103e04:	75 af                	jne    80103db5 <growproc+0x25>
80103e06:	eb de                	jmp    80103de6 <growproc+0x56>
80103e08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e0f:	90                   	nop

80103e10 <fork>:
{
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	57                   	push   %edi
80103e14:	56                   	push   %esi
80103e15:	53                   	push   %ebx
80103e16:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103e19:	e8 32 09 00 00       	call   80104750 <pushcli>
  c = mycpu();
80103e1e:	e8 cd fd ff ff       	call   80103bf0 <mycpu>
  p = c->proc;
80103e23:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e29:	e8 72 09 00 00       	call   801047a0 <popcli>
  if((np = allocproc()) == 0){
80103e2e:	e8 7d fc ff ff       	call   80103ab0 <allocproc>
80103e33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103e36:	85 c0                	test   %eax,%eax
80103e38:	0f 84 b7 00 00 00    	je     80103ef5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103e3e:	83 ec 08             	sub    $0x8,%esp
80103e41:	ff 33                	push   (%ebx)
80103e43:	89 c7                	mov    %eax,%edi
80103e45:	ff 73 04             	push   0x4(%ebx)
80103e48:	e8 e3 33 00 00       	call   80107230 <copyuvm>
80103e4d:	83 c4 10             	add    $0x10,%esp
80103e50:	89 47 04             	mov    %eax,0x4(%edi)
80103e53:	85 c0                	test   %eax,%eax
80103e55:	0f 84 a1 00 00 00    	je     80103efc <fork+0xec>
  np->sz = curproc->sz;
80103e5b:	8b 03                	mov    (%ebx),%eax
80103e5d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103e60:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103e62:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103e65:	89 c8                	mov    %ecx,%eax
80103e67:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103e6a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103e6f:	8b 73 18             	mov    0x18(%ebx),%esi
80103e72:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103e74:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103e76:	8b 40 18             	mov    0x18(%eax),%eax
80103e79:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103e80:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103e84:	85 c0                	test   %eax,%eax
80103e86:	74 13                	je     80103e9b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103e88:	83 ec 0c             	sub    $0xc,%esp
80103e8b:	50                   	push   %eax
80103e8c:	e8 0f d3 ff ff       	call   801011a0 <filedup>
80103e91:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e94:	83 c4 10             	add    $0x10,%esp
80103e97:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103e9b:	83 c6 01             	add    $0x1,%esi
80103e9e:	83 fe 10             	cmp    $0x10,%esi
80103ea1:	75 dd                	jne    80103e80 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103ea3:	83 ec 0c             	sub    $0xc,%esp
80103ea6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ea9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103eac:	e8 9f db ff ff       	call   80101a50 <idup>
80103eb1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103eb4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103eb7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103eba:	8d 47 6c             	lea    0x6c(%edi),%eax
80103ebd:	6a 10                	push   $0x10
80103ebf:	53                   	push   %ebx
80103ec0:	50                   	push   %eax
80103ec1:	e8 5a 0c 00 00       	call   80104b20 <safestrcpy>
  pid = np->pid;
80103ec6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103ec9:	c7 04 24 c0 1d 11 80 	movl   $0x80111dc0,(%esp)
80103ed0:	e8 cb 09 00 00       	call   801048a0 <acquire>
  np->state = RUNNABLE;
80103ed5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103edc:	c7 04 24 c0 1d 11 80 	movl   $0x80111dc0,(%esp)
80103ee3:	e8 58 09 00 00       	call   80104840 <release>
  return pid;
80103ee8:	83 c4 10             	add    $0x10,%esp
}
80103eeb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103eee:	89 d8                	mov    %ebx,%eax
80103ef0:	5b                   	pop    %ebx
80103ef1:	5e                   	pop    %esi
80103ef2:	5f                   	pop    %edi
80103ef3:	5d                   	pop    %ebp
80103ef4:	c3                   	ret    
    return -1;
80103ef5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103efa:	eb ef                	jmp    80103eeb <fork+0xdb>
    kfree(np->kstack);
80103efc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103eff:	83 ec 0c             	sub    $0xc,%esp
80103f02:	ff 73 08             	push   0x8(%ebx)
80103f05:	e8 b6 e8 ff ff       	call   801027c0 <kfree>
    np->kstack = 0;
80103f0a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103f11:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103f14:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103f1b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103f20:	eb c9                	jmp    80103eeb <fork+0xdb>
80103f22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f30 <scheduler>:
{
80103f30:	55                   	push   %ebp
80103f31:	89 e5                	mov    %esp,%ebp
80103f33:	57                   	push   %edi
80103f34:	56                   	push   %esi
80103f35:	53                   	push   %ebx
80103f36:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103f39:	e8 b2 fc ff ff       	call   80103bf0 <mycpu>
  c->proc = 0;
80103f3e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103f45:	00 00 00 
  struct cpu *c = mycpu();
80103f48:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103f4a:	8d 78 04             	lea    0x4(%eax),%edi
80103f4d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103f50:	fb                   	sti    
    acquire(&ptable.lock);
80103f51:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f54:	bb f4 1d 11 80       	mov    $0x80111df4,%ebx
    acquire(&ptable.lock);
80103f59:	68 c0 1d 11 80       	push   $0x80111dc0
80103f5e:	e8 3d 09 00 00       	call   801048a0 <acquire>
80103f63:	83 c4 10             	add    $0x10,%esp
80103f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f6d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103f70:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103f74:	75 33                	jne    80103fa9 <scheduler+0x79>
      switchuvm(p);
80103f76:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103f79:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103f7f:	53                   	push   %ebx
80103f80:	e8 5b 2d 00 00       	call   80106ce0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103f85:	58                   	pop    %eax
80103f86:	5a                   	pop    %edx
80103f87:	ff 73 1c             	push   0x1c(%ebx)
80103f8a:	57                   	push   %edi
      p->state = RUNNING;
80103f8b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103f92:	e8 e4 0b 00 00       	call   80104b7b <swtch>
      switchkvm();
80103f97:	e8 34 2d 00 00       	call   80106cd0 <switchkvm>
      c->proc = 0;
80103f9c:	83 c4 10             	add    $0x10,%esp
80103f9f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103fa6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fa9:	83 c3 7c             	add    $0x7c,%ebx
80103fac:	81 fb f4 3c 11 80    	cmp    $0x80113cf4,%ebx
80103fb2:	75 bc                	jne    80103f70 <scheduler+0x40>
    release(&ptable.lock);
80103fb4:	83 ec 0c             	sub    $0xc,%esp
80103fb7:	68 c0 1d 11 80       	push   $0x80111dc0
80103fbc:	e8 7f 08 00 00       	call   80104840 <release>
    sti();
80103fc1:	83 c4 10             	add    $0x10,%esp
80103fc4:	eb 8a                	jmp    80103f50 <scheduler+0x20>
80103fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fcd:	8d 76 00             	lea    0x0(%esi),%esi

80103fd0 <sched>:
{
80103fd0:	55                   	push   %ebp
80103fd1:	89 e5                	mov    %esp,%ebp
80103fd3:	56                   	push   %esi
80103fd4:	53                   	push   %ebx
  pushcli();
80103fd5:	e8 76 07 00 00       	call   80104750 <pushcli>
  c = mycpu();
80103fda:	e8 11 fc ff ff       	call   80103bf0 <mycpu>
  p = c->proc;
80103fdf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fe5:	e8 b6 07 00 00       	call   801047a0 <popcli>
  if(!holding(&ptable.lock))
80103fea:	83 ec 0c             	sub    $0xc,%esp
80103fed:	68 c0 1d 11 80       	push   $0x80111dc0
80103ff2:	e8 09 08 00 00       	call   80104800 <holding>
80103ff7:	83 c4 10             	add    $0x10,%esp
80103ffa:	85 c0                	test   %eax,%eax
80103ffc:	74 4f                	je     8010404d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103ffe:	e8 ed fb ff ff       	call   80103bf0 <mycpu>
80104003:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010400a:	75 68                	jne    80104074 <sched+0xa4>
  if(p->state == RUNNING)
8010400c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104010:	74 55                	je     80104067 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104012:	9c                   	pushf  
80104013:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104014:	f6 c4 02             	test   $0x2,%ah
80104017:	75 41                	jne    8010405a <sched+0x8a>
  intena = mycpu()->intena;
80104019:	e8 d2 fb ff ff       	call   80103bf0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010401e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104021:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104027:	e8 c4 fb ff ff       	call   80103bf0 <mycpu>
8010402c:	83 ec 08             	sub    $0x8,%esp
8010402f:	ff 70 04             	push   0x4(%eax)
80104032:	53                   	push   %ebx
80104033:	e8 43 0b 00 00       	call   80104b7b <swtch>
  mycpu()->intena = intena;
80104038:	e8 b3 fb ff ff       	call   80103bf0 <mycpu>
}
8010403d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104040:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104046:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104049:	5b                   	pop    %ebx
8010404a:	5e                   	pop    %esi
8010404b:	5d                   	pop    %ebp
8010404c:	c3                   	ret    
    panic("sched ptable.lock");
8010404d:	83 ec 0c             	sub    $0xc,%esp
80104050:	68 7b 7a 10 80       	push   $0x80107a7b
80104055:	e8 26 c3 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010405a:	83 ec 0c             	sub    $0xc,%esp
8010405d:	68 a7 7a 10 80       	push   $0x80107aa7
80104062:	e8 19 c3 ff ff       	call   80100380 <panic>
    panic("sched running");
80104067:	83 ec 0c             	sub    $0xc,%esp
8010406a:	68 99 7a 10 80       	push   $0x80107a99
8010406f:	e8 0c c3 ff ff       	call   80100380 <panic>
    panic("sched locks");
80104074:	83 ec 0c             	sub    $0xc,%esp
80104077:	68 8d 7a 10 80       	push   $0x80107a8d
8010407c:	e8 ff c2 ff ff       	call   80100380 <panic>
80104081:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104088:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010408f:	90                   	nop

80104090 <exit>:
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
80104093:	57                   	push   %edi
80104094:	56                   	push   %esi
80104095:	53                   	push   %ebx
80104096:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104099:	e8 d2 fb ff ff       	call   80103c70 <myproc>
  if(curproc == initproc)
8010409e:	39 05 f4 3c 11 80    	cmp    %eax,0x80113cf4
801040a4:	0f 84 fd 00 00 00    	je     801041a7 <exit+0x117>
801040aa:	89 c3                	mov    %eax,%ebx
801040ac:	8d 70 28             	lea    0x28(%eax),%esi
801040af:	8d 78 68             	lea    0x68(%eax),%edi
801040b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
801040b8:	8b 06                	mov    (%esi),%eax
801040ba:	85 c0                	test   %eax,%eax
801040bc:	74 12                	je     801040d0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
801040be:	83 ec 0c             	sub    $0xc,%esp
801040c1:	50                   	push   %eax
801040c2:	e8 29 d1 ff ff       	call   801011f0 <fileclose>
      curproc->ofile[fd] = 0;
801040c7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801040cd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801040d0:	83 c6 04             	add    $0x4,%esi
801040d3:	39 f7                	cmp    %esi,%edi
801040d5:	75 e1                	jne    801040b8 <exit+0x28>
  begin_op();
801040d7:	e8 84 ef ff ff       	call   80103060 <begin_op>
  iput(curproc->cwd);
801040dc:	83 ec 0c             	sub    $0xc,%esp
801040df:	ff 73 68             	push   0x68(%ebx)
801040e2:	e8 c9 da ff ff       	call   80101bb0 <iput>
  end_op();
801040e7:	e8 e4 ef ff ff       	call   801030d0 <end_op>
  curproc->cwd = 0;
801040ec:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
801040f3:	c7 04 24 c0 1d 11 80 	movl   $0x80111dc0,(%esp)
801040fa:	e8 a1 07 00 00       	call   801048a0 <acquire>
  wakeup1(curproc->parent);
801040ff:	8b 53 14             	mov    0x14(%ebx),%edx
80104102:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104105:	b8 f4 1d 11 80       	mov    $0x80111df4,%eax
8010410a:	eb 0e                	jmp    8010411a <exit+0x8a>
8010410c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104110:	83 c0 7c             	add    $0x7c,%eax
80104113:	3d f4 3c 11 80       	cmp    $0x80113cf4,%eax
80104118:	74 1c                	je     80104136 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
8010411a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010411e:	75 f0                	jne    80104110 <exit+0x80>
80104120:	3b 50 20             	cmp    0x20(%eax),%edx
80104123:	75 eb                	jne    80104110 <exit+0x80>
      p->state = RUNNABLE;
80104125:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010412c:	83 c0 7c             	add    $0x7c,%eax
8010412f:	3d f4 3c 11 80       	cmp    $0x80113cf4,%eax
80104134:	75 e4                	jne    8010411a <exit+0x8a>
      p->parent = initproc;
80104136:	8b 0d f4 3c 11 80    	mov    0x80113cf4,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010413c:	ba f4 1d 11 80       	mov    $0x80111df4,%edx
80104141:	eb 10                	jmp    80104153 <exit+0xc3>
80104143:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104147:	90                   	nop
80104148:	83 c2 7c             	add    $0x7c,%edx
8010414b:	81 fa f4 3c 11 80    	cmp    $0x80113cf4,%edx
80104151:	74 3b                	je     8010418e <exit+0xfe>
    if(p->parent == curproc){
80104153:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104156:	75 f0                	jne    80104148 <exit+0xb8>
      if(p->state == ZOMBIE)
80104158:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010415c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010415f:	75 e7                	jne    80104148 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104161:	b8 f4 1d 11 80       	mov    $0x80111df4,%eax
80104166:	eb 12                	jmp    8010417a <exit+0xea>
80104168:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010416f:	90                   	nop
80104170:	83 c0 7c             	add    $0x7c,%eax
80104173:	3d f4 3c 11 80       	cmp    $0x80113cf4,%eax
80104178:	74 ce                	je     80104148 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
8010417a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010417e:	75 f0                	jne    80104170 <exit+0xe0>
80104180:	3b 48 20             	cmp    0x20(%eax),%ecx
80104183:	75 eb                	jne    80104170 <exit+0xe0>
      p->state = RUNNABLE;
80104185:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010418c:	eb e2                	jmp    80104170 <exit+0xe0>
  curproc->state = ZOMBIE;
8010418e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80104195:	e8 36 fe ff ff       	call   80103fd0 <sched>
  panic("zombie exit");
8010419a:	83 ec 0c             	sub    $0xc,%esp
8010419d:	68 c8 7a 10 80       	push   $0x80107ac8
801041a2:	e8 d9 c1 ff ff       	call   80100380 <panic>
    panic("init exiting");
801041a7:	83 ec 0c             	sub    $0xc,%esp
801041aa:	68 bb 7a 10 80       	push   $0x80107abb
801041af:	e8 cc c1 ff ff       	call   80100380 <panic>
801041b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041bf:	90                   	nop

801041c0 <wait>:
{
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	56                   	push   %esi
801041c4:	53                   	push   %ebx
  pushcli();
801041c5:	e8 86 05 00 00       	call   80104750 <pushcli>
  c = mycpu();
801041ca:	e8 21 fa ff ff       	call   80103bf0 <mycpu>
  p = c->proc;
801041cf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801041d5:	e8 c6 05 00 00       	call   801047a0 <popcli>
  acquire(&ptable.lock);
801041da:	83 ec 0c             	sub    $0xc,%esp
801041dd:	68 c0 1d 11 80       	push   $0x80111dc0
801041e2:	e8 b9 06 00 00       	call   801048a0 <acquire>
801041e7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801041ea:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041ec:	bb f4 1d 11 80       	mov    $0x80111df4,%ebx
801041f1:	eb 10                	jmp    80104203 <wait+0x43>
801041f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041f7:	90                   	nop
801041f8:	83 c3 7c             	add    $0x7c,%ebx
801041fb:	81 fb f4 3c 11 80    	cmp    $0x80113cf4,%ebx
80104201:	74 1b                	je     8010421e <wait+0x5e>
      if(p->parent != curproc)
80104203:	39 73 14             	cmp    %esi,0x14(%ebx)
80104206:	75 f0                	jne    801041f8 <wait+0x38>
      if(p->state == ZOMBIE){
80104208:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010420c:	74 62                	je     80104270 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010420e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104211:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104216:	81 fb f4 3c 11 80    	cmp    $0x80113cf4,%ebx
8010421c:	75 e5                	jne    80104203 <wait+0x43>
    if(!havekids || curproc->killed){
8010421e:	85 c0                	test   %eax,%eax
80104220:	0f 84 a0 00 00 00    	je     801042c6 <wait+0x106>
80104226:	8b 46 24             	mov    0x24(%esi),%eax
80104229:	85 c0                	test   %eax,%eax
8010422b:	0f 85 95 00 00 00    	jne    801042c6 <wait+0x106>
  pushcli();
80104231:	e8 1a 05 00 00       	call   80104750 <pushcli>
  c = mycpu();
80104236:	e8 b5 f9 ff ff       	call   80103bf0 <mycpu>
  p = c->proc;
8010423b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104241:	e8 5a 05 00 00       	call   801047a0 <popcli>
  if(p == 0)
80104246:	85 db                	test   %ebx,%ebx
80104248:	0f 84 8f 00 00 00    	je     801042dd <wait+0x11d>
  p->chan = chan;
8010424e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104251:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104258:	e8 73 fd ff ff       	call   80103fd0 <sched>
  p->chan = 0;
8010425d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104264:	eb 84                	jmp    801041ea <wait+0x2a>
80104266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010426d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104270:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104273:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104276:	ff 73 08             	push   0x8(%ebx)
80104279:	e8 42 e5 ff ff       	call   801027c0 <kfree>
        p->kstack = 0;
8010427e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104285:	5a                   	pop    %edx
80104286:	ff 73 04             	push   0x4(%ebx)
80104289:	e8 32 2e 00 00       	call   801070c0 <freevm>
        p->pid = 0;
8010428e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104295:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010429c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801042a0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801042a7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801042ae:	c7 04 24 c0 1d 11 80 	movl   $0x80111dc0,(%esp)
801042b5:	e8 86 05 00 00       	call   80104840 <release>
        return pid;
801042ba:	83 c4 10             	add    $0x10,%esp
}
801042bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042c0:	89 f0                	mov    %esi,%eax
801042c2:	5b                   	pop    %ebx
801042c3:	5e                   	pop    %esi
801042c4:	5d                   	pop    %ebp
801042c5:	c3                   	ret    
      release(&ptable.lock);
801042c6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801042c9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801042ce:	68 c0 1d 11 80       	push   $0x80111dc0
801042d3:	e8 68 05 00 00       	call   80104840 <release>
      return -1;
801042d8:	83 c4 10             	add    $0x10,%esp
801042db:	eb e0                	jmp    801042bd <wait+0xfd>
    panic("sleep");
801042dd:	83 ec 0c             	sub    $0xc,%esp
801042e0:	68 d4 7a 10 80       	push   $0x80107ad4
801042e5:	e8 96 c0 ff ff       	call   80100380 <panic>
801042ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042f0 <yield>:
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	53                   	push   %ebx
801042f4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801042f7:	68 c0 1d 11 80       	push   $0x80111dc0
801042fc:	e8 9f 05 00 00       	call   801048a0 <acquire>
  pushcli();
80104301:	e8 4a 04 00 00       	call   80104750 <pushcli>
  c = mycpu();
80104306:	e8 e5 f8 ff ff       	call   80103bf0 <mycpu>
  p = c->proc;
8010430b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104311:	e8 8a 04 00 00       	call   801047a0 <popcli>
  myproc()->state = RUNNABLE;
80104316:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010431d:	e8 ae fc ff ff       	call   80103fd0 <sched>
  release(&ptable.lock);
80104322:	c7 04 24 c0 1d 11 80 	movl   $0x80111dc0,(%esp)
80104329:	e8 12 05 00 00       	call   80104840 <release>
}
8010432e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104331:	83 c4 10             	add    $0x10,%esp
80104334:	c9                   	leave  
80104335:	c3                   	ret    
80104336:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010433d:	8d 76 00             	lea    0x0(%esi),%esi

80104340 <sleep>:
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	57                   	push   %edi
80104344:	56                   	push   %esi
80104345:	53                   	push   %ebx
80104346:	83 ec 0c             	sub    $0xc,%esp
80104349:	8b 7d 08             	mov    0x8(%ebp),%edi
8010434c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010434f:	e8 fc 03 00 00       	call   80104750 <pushcli>
  c = mycpu();
80104354:	e8 97 f8 ff ff       	call   80103bf0 <mycpu>
  p = c->proc;
80104359:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010435f:	e8 3c 04 00 00       	call   801047a0 <popcli>
  if(p == 0)
80104364:	85 db                	test   %ebx,%ebx
80104366:	0f 84 87 00 00 00    	je     801043f3 <sleep+0xb3>
  if(lk == 0)
8010436c:	85 f6                	test   %esi,%esi
8010436e:	74 76                	je     801043e6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104370:	81 fe c0 1d 11 80    	cmp    $0x80111dc0,%esi
80104376:	74 50                	je     801043c8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104378:	83 ec 0c             	sub    $0xc,%esp
8010437b:	68 c0 1d 11 80       	push   $0x80111dc0
80104380:	e8 1b 05 00 00       	call   801048a0 <acquire>
    release(lk);
80104385:	89 34 24             	mov    %esi,(%esp)
80104388:	e8 b3 04 00 00       	call   80104840 <release>
  p->chan = chan;
8010438d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104390:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104397:	e8 34 fc ff ff       	call   80103fd0 <sched>
  p->chan = 0;
8010439c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801043a3:	c7 04 24 c0 1d 11 80 	movl   $0x80111dc0,(%esp)
801043aa:	e8 91 04 00 00       	call   80104840 <release>
    acquire(lk);
801043af:	89 75 08             	mov    %esi,0x8(%ebp)
801043b2:	83 c4 10             	add    $0x10,%esp
}
801043b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043b8:	5b                   	pop    %ebx
801043b9:	5e                   	pop    %esi
801043ba:	5f                   	pop    %edi
801043bb:	5d                   	pop    %ebp
    acquire(lk);
801043bc:	e9 df 04 00 00       	jmp    801048a0 <acquire>
801043c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801043c8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801043cb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801043d2:	e8 f9 fb ff ff       	call   80103fd0 <sched>
  p->chan = 0;
801043d7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801043de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043e1:	5b                   	pop    %ebx
801043e2:	5e                   	pop    %esi
801043e3:	5f                   	pop    %edi
801043e4:	5d                   	pop    %ebp
801043e5:	c3                   	ret    
    panic("sleep without lk");
801043e6:	83 ec 0c             	sub    $0xc,%esp
801043e9:	68 da 7a 10 80       	push   $0x80107ada
801043ee:	e8 8d bf ff ff       	call   80100380 <panic>
    panic("sleep");
801043f3:	83 ec 0c             	sub    $0xc,%esp
801043f6:	68 d4 7a 10 80       	push   $0x80107ad4
801043fb:	e8 80 bf ff ff       	call   80100380 <panic>

80104400 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	53                   	push   %ebx
80104404:	83 ec 10             	sub    $0x10,%esp
80104407:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010440a:	68 c0 1d 11 80       	push   $0x80111dc0
8010440f:	e8 8c 04 00 00       	call   801048a0 <acquire>
80104414:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104417:	b8 f4 1d 11 80       	mov    $0x80111df4,%eax
8010441c:	eb 0c                	jmp    8010442a <wakeup+0x2a>
8010441e:	66 90                	xchg   %ax,%ax
80104420:	83 c0 7c             	add    $0x7c,%eax
80104423:	3d f4 3c 11 80       	cmp    $0x80113cf4,%eax
80104428:	74 1c                	je     80104446 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010442a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010442e:	75 f0                	jne    80104420 <wakeup+0x20>
80104430:	3b 58 20             	cmp    0x20(%eax),%ebx
80104433:	75 eb                	jne    80104420 <wakeup+0x20>
      p->state = RUNNABLE;
80104435:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010443c:	83 c0 7c             	add    $0x7c,%eax
8010443f:	3d f4 3c 11 80       	cmp    $0x80113cf4,%eax
80104444:	75 e4                	jne    8010442a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104446:	c7 45 08 c0 1d 11 80 	movl   $0x80111dc0,0x8(%ebp)
}
8010444d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104450:	c9                   	leave  
  release(&ptable.lock);
80104451:	e9 ea 03 00 00       	jmp    80104840 <release>
80104456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010445d:	8d 76 00             	lea    0x0(%esi),%esi

80104460 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	53                   	push   %ebx
80104464:	83 ec 10             	sub    $0x10,%esp
80104467:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010446a:	68 c0 1d 11 80       	push   $0x80111dc0
8010446f:	e8 2c 04 00 00       	call   801048a0 <acquire>
80104474:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104477:	b8 f4 1d 11 80       	mov    $0x80111df4,%eax
8010447c:	eb 0c                	jmp    8010448a <kill+0x2a>
8010447e:	66 90                	xchg   %ax,%ax
80104480:	83 c0 7c             	add    $0x7c,%eax
80104483:	3d f4 3c 11 80       	cmp    $0x80113cf4,%eax
80104488:	74 36                	je     801044c0 <kill+0x60>
    if(p->pid == pid){
8010448a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010448d:	75 f1                	jne    80104480 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010448f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104493:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010449a:	75 07                	jne    801044a3 <kill+0x43>
        p->state = RUNNABLE;
8010449c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801044a3:	83 ec 0c             	sub    $0xc,%esp
801044a6:	68 c0 1d 11 80       	push   $0x80111dc0
801044ab:	e8 90 03 00 00       	call   80104840 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801044b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801044b3:	83 c4 10             	add    $0x10,%esp
801044b6:	31 c0                	xor    %eax,%eax
}
801044b8:	c9                   	leave  
801044b9:	c3                   	ret    
801044ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801044c0:	83 ec 0c             	sub    $0xc,%esp
801044c3:	68 c0 1d 11 80       	push   $0x80111dc0
801044c8:	e8 73 03 00 00       	call   80104840 <release>
}
801044cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801044d0:	83 c4 10             	add    $0x10,%esp
801044d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801044d8:	c9                   	leave  
801044d9:	c3                   	ret    
801044da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044e0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	57                   	push   %edi
801044e4:	56                   	push   %esi
801044e5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801044e8:	53                   	push   %ebx
801044e9:	bb 60 1e 11 80       	mov    $0x80111e60,%ebx
801044ee:	83 ec 3c             	sub    $0x3c,%esp
801044f1:	eb 24                	jmp    80104517 <procdump+0x37>
801044f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044f7:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801044f8:	83 ec 0c             	sub    $0xc,%esp
801044fb:	68 57 7e 10 80       	push   $0x80107e57
80104500:	e8 9b c1 ff ff       	call   801006a0 <cprintf>
80104505:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104508:	83 c3 7c             	add    $0x7c,%ebx
8010450b:	81 fb 60 3d 11 80    	cmp    $0x80113d60,%ebx
80104511:	0f 84 81 00 00 00    	je     80104598 <procdump+0xb8>
    if(p->state == UNUSED)
80104517:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010451a:	85 c0                	test   %eax,%eax
8010451c:	74 ea                	je     80104508 <procdump+0x28>
      state = "???";
8010451e:	ba eb 7a 10 80       	mov    $0x80107aeb,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104523:	83 f8 05             	cmp    $0x5,%eax
80104526:	77 11                	ja     80104539 <procdump+0x59>
80104528:	8b 14 85 4c 7b 10 80 	mov    -0x7fef84b4(,%eax,4),%edx
      state = "???";
8010452f:	b8 eb 7a 10 80       	mov    $0x80107aeb,%eax
80104534:	85 d2                	test   %edx,%edx
80104536:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104539:	53                   	push   %ebx
8010453a:	52                   	push   %edx
8010453b:	ff 73 a4             	push   -0x5c(%ebx)
8010453e:	68 ef 7a 10 80       	push   $0x80107aef
80104543:	e8 58 c1 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
80104548:	83 c4 10             	add    $0x10,%esp
8010454b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010454f:	75 a7                	jne    801044f8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104551:	83 ec 08             	sub    $0x8,%esp
80104554:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104557:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010455a:	50                   	push   %eax
8010455b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010455e:	8b 40 0c             	mov    0xc(%eax),%eax
80104561:	83 c0 08             	add    $0x8,%eax
80104564:	50                   	push   %eax
80104565:	e8 86 01 00 00       	call   801046f0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010456a:	83 c4 10             	add    $0x10,%esp
8010456d:	8d 76 00             	lea    0x0(%esi),%esi
80104570:	8b 17                	mov    (%edi),%edx
80104572:	85 d2                	test   %edx,%edx
80104574:	74 82                	je     801044f8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104576:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104579:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010457c:	52                   	push   %edx
8010457d:	68 e1 74 10 80       	push   $0x801074e1
80104582:	e8 19 c1 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104587:	83 c4 10             	add    $0x10,%esp
8010458a:	39 fe                	cmp    %edi,%esi
8010458c:	75 e2                	jne    80104570 <procdump+0x90>
8010458e:	e9 65 ff ff ff       	jmp    801044f8 <procdump+0x18>
80104593:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104597:	90                   	nop
  }
}
80104598:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010459b:	5b                   	pop    %ebx
8010459c:	5e                   	pop    %esi
8010459d:	5f                   	pop    %edi
8010459e:	5d                   	pop    %ebp
8010459f:	c3                   	ret    

801045a0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	53                   	push   %ebx
801045a4:	83 ec 0c             	sub    $0xc,%esp
801045a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801045aa:	68 64 7b 10 80       	push   $0x80107b64
801045af:	8d 43 04             	lea    0x4(%ebx),%eax
801045b2:	50                   	push   %eax
801045b3:	e8 18 01 00 00       	call   801046d0 <initlock>
  lk->name = name;
801045b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801045bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801045c1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801045c4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801045cb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801045ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045d1:	c9                   	leave  
801045d2:	c3                   	ret    
801045d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045e0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	56                   	push   %esi
801045e4:	53                   	push   %ebx
801045e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801045e8:	8d 73 04             	lea    0x4(%ebx),%esi
801045eb:	83 ec 0c             	sub    $0xc,%esp
801045ee:	56                   	push   %esi
801045ef:	e8 ac 02 00 00       	call   801048a0 <acquire>
  while (lk->locked) {
801045f4:	8b 13                	mov    (%ebx),%edx
801045f6:	83 c4 10             	add    $0x10,%esp
801045f9:	85 d2                	test   %edx,%edx
801045fb:	74 16                	je     80104613 <acquiresleep+0x33>
801045fd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104600:	83 ec 08             	sub    $0x8,%esp
80104603:	56                   	push   %esi
80104604:	53                   	push   %ebx
80104605:	e8 36 fd ff ff       	call   80104340 <sleep>
  while (lk->locked) {
8010460a:	8b 03                	mov    (%ebx),%eax
8010460c:	83 c4 10             	add    $0x10,%esp
8010460f:	85 c0                	test   %eax,%eax
80104611:	75 ed                	jne    80104600 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104613:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104619:	e8 52 f6 ff ff       	call   80103c70 <myproc>
8010461e:	8b 40 10             	mov    0x10(%eax),%eax
80104621:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104624:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104627:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010462a:	5b                   	pop    %ebx
8010462b:	5e                   	pop    %esi
8010462c:	5d                   	pop    %ebp
  release(&lk->lk);
8010462d:	e9 0e 02 00 00       	jmp    80104840 <release>
80104632:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104640 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	56                   	push   %esi
80104644:	53                   	push   %ebx
80104645:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104648:	8d 73 04             	lea    0x4(%ebx),%esi
8010464b:	83 ec 0c             	sub    $0xc,%esp
8010464e:	56                   	push   %esi
8010464f:	e8 4c 02 00 00       	call   801048a0 <acquire>
  lk->locked = 0;
80104654:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010465a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104661:	89 1c 24             	mov    %ebx,(%esp)
80104664:	e8 97 fd ff ff       	call   80104400 <wakeup>
  release(&lk->lk);
80104669:	89 75 08             	mov    %esi,0x8(%ebp)
8010466c:	83 c4 10             	add    $0x10,%esp
}
8010466f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104672:	5b                   	pop    %ebx
80104673:	5e                   	pop    %esi
80104674:	5d                   	pop    %ebp
  release(&lk->lk);
80104675:	e9 c6 01 00 00       	jmp    80104840 <release>
8010467a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104680 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	57                   	push   %edi
80104684:	31 ff                	xor    %edi,%edi
80104686:	56                   	push   %esi
80104687:	53                   	push   %ebx
80104688:	83 ec 18             	sub    $0x18,%esp
8010468b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010468e:	8d 73 04             	lea    0x4(%ebx),%esi
80104691:	56                   	push   %esi
80104692:	e8 09 02 00 00       	call   801048a0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104697:	8b 03                	mov    (%ebx),%eax
80104699:	83 c4 10             	add    $0x10,%esp
8010469c:	85 c0                	test   %eax,%eax
8010469e:	75 18                	jne    801046b8 <holdingsleep+0x38>
  release(&lk->lk);
801046a0:	83 ec 0c             	sub    $0xc,%esp
801046a3:	56                   	push   %esi
801046a4:	e8 97 01 00 00       	call   80104840 <release>
  return r;
}
801046a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046ac:	89 f8                	mov    %edi,%eax
801046ae:	5b                   	pop    %ebx
801046af:	5e                   	pop    %esi
801046b0:	5f                   	pop    %edi
801046b1:	5d                   	pop    %ebp
801046b2:	c3                   	ret    
801046b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046b7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
801046b8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801046bb:	e8 b0 f5 ff ff       	call   80103c70 <myproc>
801046c0:	39 58 10             	cmp    %ebx,0x10(%eax)
801046c3:	0f 94 c0             	sete   %al
801046c6:	0f b6 c0             	movzbl %al,%eax
801046c9:	89 c7                	mov    %eax,%edi
801046cb:	eb d3                	jmp    801046a0 <holdingsleep+0x20>
801046cd:	66 90                	xchg   %ax,%ax
801046cf:	90                   	nop

801046d0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801046d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801046d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801046df:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801046e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801046e9:	5d                   	pop    %ebp
801046ea:	c3                   	ret    
801046eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046ef:	90                   	nop

801046f0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801046f0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801046f1:	31 d2                	xor    %edx,%edx
{
801046f3:	89 e5                	mov    %esp,%ebp
801046f5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801046f6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801046f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801046fc:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801046ff:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104700:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104706:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010470c:	77 1a                	ja     80104728 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010470e:	8b 58 04             	mov    0x4(%eax),%ebx
80104711:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104714:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104717:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104719:	83 fa 0a             	cmp    $0xa,%edx
8010471c:	75 e2                	jne    80104700 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010471e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104721:	c9                   	leave  
80104722:	c3                   	ret    
80104723:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104727:	90                   	nop
  for(; i < 10; i++)
80104728:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010472b:	8d 51 28             	lea    0x28(%ecx),%edx
8010472e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104730:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104736:	83 c0 04             	add    $0x4,%eax
80104739:	39 d0                	cmp    %edx,%eax
8010473b:	75 f3                	jne    80104730 <getcallerpcs+0x40>
}
8010473d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104740:	c9                   	leave  
80104741:	c3                   	ret    
80104742:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104750 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	53                   	push   %ebx
80104754:	83 ec 04             	sub    $0x4,%esp
80104757:	9c                   	pushf  
80104758:	5b                   	pop    %ebx
  asm volatile("cli");
80104759:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010475a:	e8 91 f4 ff ff       	call   80103bf0 <mycpu>
8010475f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104765:	85 c0                	test   %eax,%eax
80104767:	74 17                	je     80104780 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104769:	e8 82 f4 ff ff       	call   80103bf0 <mycpu>
8010476e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104775:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104778:	c9                   	leave  
80104779:	c3                   	ret    
8010477a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104780:	e8 6b f4 ff ff       	call   80103bf0 <mycpu>
80104785:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010478b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104791:	eb d6                	jmp    80104769 <pushcli+0x19>
80104793:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010479a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047a0 <popcli>:

void
popcli(void)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801047a6:	9c                   	pushf  
801047a7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801047a8:	f6 c4 02             	test   $0x2,%ah
801047ab:	75 35                	jne    801047e2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801047ad:	e8 3e f4 ff ff       	call   80103bf0 <mycpu>
801047b2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801047b9:	78 34                	js     801047ef <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801047bb:	e8 30 f4 ff ff       	call   80103bf0 <mycpu>
801047c0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801047c6:	85 d2                	test   %edx,%edx
801047c8:	74 06                	je     801047d0 <popcli+0x30>
    sti();
}
801047ca:	c9                   	leave  
801047cb:	c3                   	ret    
801047cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801047d0:	e8 1b f4 ff ff       	call   80103bf0 <mycpu>
801047d5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801047db:	85 c0                	test   %eax,%eax
801047dd:	74 eb                	je     801047ca <popcli+0x2a>
  asm volatile("sti");
801047df:	fb                   	sti    
}
801047e0:	c9                   	leave  
801047e1:	c3                   	ret    
    panic("popcli - interruptible");
801047e2:	83 ec 0c             	sub    $0xc,%esp
801047e5:	68 6f 7b 10 80       	push   $0x80107b6f
801047ea:	e8 91 bb ff ff       	call   80100380 <panic>
    panic("popcli");
801047ef:	83 ec 0c             	sub    $0xc,%esp
801047f2:	68 86 7b 10 80       	push   $0x80107b86
801047f7:	e8 84 bb ff ff       	call   80100380 <panic>
801047fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104800 <holding>:
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	56                   	push   %esi
80104804:	53                   	push   %ebx
80104805:	8b 75 08             	mov    0x8(%ebp),%esi
80104808:	31 db                	xor    %ebx,%ebx
  pushcli();
8010480a:	e8 41 ff ff ff       	call   80104750 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010480f:	8b 06                	mov    (%esi),%eax
80104811:	85 c0                	test   %eax,%eax
80104813:	75 0b                	jne    80104820 <holding+0x20>
  popcli();
80104815:	e8 86 ff ff ff       	call   801047a0 <popcli>
}
8010481a:	89 d8                	mov    %ebx,%eax
8010481c:	5b                   	pop    %ebx
8010481d:	5e                   	pop    %esi
8010481e:	5d                   	pop    %ebp
8010481f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104820:	8b 5e 08             	mov    0x8(%esi),%ebx
80104823:	e8 c8 f3 ff ff       	call   80103bf0 <mycpu>
80104828:	39 c3                	cmp    %eax,%ebx
8010482a:	0f 94 c3             	sete   %bl
  popcli();
8010482d:	e8 6e ff ff ff       	call   801047a0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104832:	0f b6 db             	movzbl %bl,%ebx
}
80104835:	89 d8                	mov    %ebx,%eax
80104837:	5b                   	pop    %ebx
80104838:	5e                   	pop    %esi
80104839:	5d                   	pop    %ebp
8010483a:	c3                   	ret    
8010483b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010483f:	90                   	nop

80104840 <release>:
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	56                   	push   %esi
80104844:	53                   	push   %ebx
80104845:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104848:	e8 03 ff ff ff       	call   80104750 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010484d:	8b 03                	mov    (%ebx),%eax
8010484f:	85 c0                	test   %eax,%eax
80104851:	75 15                	jne    80104868 <release+0x28>
  popcli();
80104853:	e8 48 ff ff ff       	call   801047a0 <popcli>
    panic("release");
80104858:	83 ec 0c             	sub    $0xc,%esp
8010485b:	68 8d 7b 10 80       	push   $0x80107b8d
80104860:	e8 1b bb ff ff       	call   80100380 <panic>
80104865:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104868:	8b 73 08             	mov    0x8(%ebx),%esi
8010486b:	e8 80 f3 ff ff       	call   80103bf0 <mycpu>
80104870:	39 c6                	cmp    %eax,%esi
80104872:	75 df                	jne    80104853 <release+0x13>
  popcli();
80104874:	e8 27 ff ff ff       	call   801047a0 <popcli>
  lk->pcs[0] = 0;
80104879:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104880:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104887:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010488c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104892:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104895:	5b                   	pop    %ebx
80104896:	5e                   	pop    %esi
80104897:	5d                   	pop    %ebp
  popcli();
80104898:	e9 03 ff ff ff       	jmp    801047a0 <popcli>
8010489d:	8d 76 00             	lea    0x0(%esi),%esi

801048a0 <acquire>:
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	53                   	push   %ebx
801048a4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801048a7:	e8 a4 fe ff ff       	call   80104750 <pushcli>
  if(holding(lk))
801048ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801048af:	e8 9c fe ff ff       	call   80104750 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801048b4:	8b 03                	mov    (%ebx),%eax
801048b6:	85 c0                	test   %eax,%eax
801048b8:	75 7e                	jne    80104938 <acquire+0x98>
  popcli();
801048ba:	e8 e1 fe ff ff       	call   801047a0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801048bf:	b9 01 00 00 00       	mov    $0x1,%ecx
801048c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
801048c8:	8b 55 08             	mov    0x8(%ebp),%edx
801048cb:	89 c8                	mov    %ecx,%eax
801048cd:	f0 87 02             	lock xchg %eax,(%edx)
801048d0:	85 c0                	test   %eax,%eax
801048d2:	75 f4                	jne    801048c8 <acquire+0x28>
  __sync_synchronize();
801048d4:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801048d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801048dc:	e8 0f f3 ff ff       	call   80103bf0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801048e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
801048e4:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
801048e6:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
801048e9:	31 c0                	xor    %eax,%eax
801048eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048ef:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801048f0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801048f6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801048fc:	77 1a                	ja     80104918 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
801048fe:	8b 5a 04             	mov    0x4(%edx),%ebx
80104901:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104905:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104908:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010490a:	83 f8 0a             	cmp    $0xa,%eax
8010490d:	75 e1                	jne    801048f0 <acquire+0x50>
}
8010490f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104912:	c9                   	leave  
80104913:	c3                   	ret    
80104914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104918:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010491c:	8d 51 34             	lea    0x34(%ecx),%edx
8010491f:	90                   	nop
    pcs[i] = 0;
80104920:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104926:	83 c0 04             	add    $0x4,%eax
80104929:	39 c2                	cmp    %eax,%edx
8010492b:	75 f3                	jne    80104920 <acquire+0x80>
}
8010492d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104930:	c9                   	leave  
80104931:	c3                   	ret    
80104932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104938:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010493b:	e8 b0 f2 ff ff       	call   80103bf0 <mycpu>
80104940:	39 c3                	cmp    %eax,%ebx
80104942:	0f 85 72 ff ff ff    	jne    801048ba <acquire+0x1a>
  popcli();
80104948:	e8 53 fe ff ff       	call   801047a0 <popcli>
    panic("acquire");
8010494d:	83 ec 0c             	sub    $0xc,%esp
80104950:	68 95 7b 10 80       	push   $0x80107b95
80104955:	e8 26 ba ff ff       	call   80100380 <panic>
8010495a:	66 90                	xchg   %ax,%ax
8010495c:	66 90                	xchg   %ax,%ax
8010495e:	66 90                	xchg   %ax,%ax

80104960 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	57                   	push   %edi
80104964:	8b 55 08             	mov    0x8(%ebp),%edx
80104967:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010496a:	53                   	push   %ebx
8010496b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010496e:	89 d7                	mov    %edx,%edi
80104970:	09 cf                	or     %ecx,%edi
80104972:	83 e7 03             	and    $0x3,%edi
80104975:	75 29                	jne    801049a0 <memset+0x40>
    c &= 0xFF;
80104977:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010497a:	c1 e0 18             	shl    $0x18,%eax
8010497d:	89 fb                	mov    %edi,%ebx
8010497f:	c1 e9 02             	shr    $0x2,%ecx
80104982:	c1 e3 10             	shl    $0x10,%ebx
80104985:	09 d8                	or     %ebx,%eax
80104987:	09 f8                	or     %edi,%eax
80104989:	c1 e7 08             	shl    $0x8,%edi
8010498c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010498e:	89 d7                	mov    %edx,%edi
80104990:	fc                   	cld    
80104991:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104993:	5b                   	pop    %ebx
80104994:	89 d0                	mov    %edx,%eax
80104996:	5f                   	pop    %edi
80104997:	5d                   	pop    %ebp
80104998:	c3                   	ret    
80104999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801049a0:	89 d7                	mov    %edx,%edi
801049a2:	fc                   	cld    
801049a3:	f3 aa                	rep stos %al,%es:(%edi)
801049a5:	5b                   	pop    %ebx
801049a6:	89 d0                	mov    %edx,%eax
801049a8:	5f                   	pop    %edi
801049a9:	5d                   	pop    %ebp
801049aa:	c3                   	ret    
801049ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049af:	90                   	nop

801049b0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	56                   	push   %esi
801049b4:	8b 75 10             	mov    0x10(%ebp),%esi
801049b7:	8b 55 08             	mov    0x8(%ebp),%edx
801049ba:	53                   	push   %ebx
801049bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801049be:	85 f6                	test   %esi,%esi
801049c0:	74 2e                	je     801049f0 <memcmp+0x40>
801049c2:	01 c6                	add    %eax,%esi
801049c4:	eb 14                	jmp    801049da <memcmp+0x2a>
801049c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049cd:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801049d0:	83 c0 01             	add    $0x1,%eax
801049d3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801049d6:	39 f0                	cmp    %esi,%eax
801049d8:	74 16                	je     801049f0 <memcmp+0x40>
    if(*s1 != *s2)
801049da:	0f b6 0a             	movzbl (%edx),%ecx
801049dd:	0f b6 18             	movzbl (%eax),%ebx
801049e0:	38 d9                	cmp    %bl,%cl
801049e2:	74 ec                	je     801049d0 <memcmp+0x20>
      return *s1 - *s2;
801049e4:	0f b6 c1             	movzbl %cl,%eax
801049e7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801049e9:	5b                   	pop    %ebx
801049ea:	5e                   	pop    %esi
801049eb:	5d                   	pop    %ebp
801049ec:	c3                   	ret    
801049ed:	8d 76 00             	lea    0x0(%esi),%esi
801049f0:	5b                   	pop    %ebx
  return 0;
801049f1:	31 c0                	xor    %eax,%eax
}
801049f3:	5e                   	pop    %esi
801049f4:	5d                   	pop    %ebp
801049f5:	c3                   	ret    
801049f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049fd:	8d 76 00             	lea    0x0(%esi),%esi

80104a00 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	57                   	push   %edi
80104a04:	8b 55 08             	mov    0x8(%ebp),%edx
80104a07:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104a0a:	56                   	push   %esi
80104a0b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104a0e:	39 d6                	cmp    %edx,%esi
80104a10:	73 26                	jae    80104a38 <memmove+0x38>
80104a12:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104a15:	39 fa                	cmp    %edi,%edx
80104a17:	73 1f                	jae    80104a38 <memmove+0x38>
80104a19:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104a1c:	85 c9                	test   %ecx,%ecx
80104a1e:	74 0c                	je     80104a2c <memmove+0x2c>
      *--d = *--s;
80104a20:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104a24:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104a27:	83 e8 01             	sub    $0x1,%eax
80104a2a:	73 f4                	jae    80104a20 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104a2c:	5e                   	pop    %esi
80104a2d:	89 d0                	mov    %edx,%eax
80104a2f:	5f                   	pop    %edi
80104a30:	5d                   	pop    %ebp
80104a31:	c3                   	ret    
80104a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104a38:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104a3b:	89 d7                	mov    %edx,%edi
80104a3d:	85 c9                	test   %ecx,%ecx
80104a3f:	74 eb                	je     80104a2c <memmove+0x2c>
80104a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104a48:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104a49:	39 c6                	cmp    %eax,%esi
80104a4b:	75 fb                	jne    80104a48 <memmove+0x48>
}
80104a4d:	5e                   	pop    %esi
80104a4e:	89 d0                	mov    %edx,%eax
80104a50:	5f                   	pop    %edi
80104a51:	5d                   	pop    %ebp
80104a52:	c3                   	ret    
80104a53:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a60 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104a60:	eb 9e                	jmp    80104a00 <memmove>
80104a62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a70 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	56                   	push   %esi
80104a74:	8b 75 10             	mov    0x10(%ebp),%esi
80104a77:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104a7a:	53                   	push   %ebx
80104a7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80104a7e:	85 f6                	test   %esi,%esi
80104a80:	74 2e                	je     80104ab0 <strncmp+0x40>
80104a82:	01 d6                	add    %edx,%esi
80104a84:	eb 18                	jmp    80104a9e <strncmp+0x2e>
80104a86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a8d:	8d 76 00             	lea    0x0(%esi),%esi
80104a90:	38 d8                	cmp    %bl,%al
80104a92:	75 14                	jne    80104aa8 <strncmp+0x38>
    n--, p++, q++;
80104a94:	83 c2 01             	add    $0x1,%edx
80104a97:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104a9a:	39 f2                	cmp    %esi,%edx
80104a9c:	74 12                	je     80104ab0 <strncmp+0x40>
80104a9e:	0f b6 01             	movzbl (%ecx),%eax
80104aa1:	0f b6 1a             	movzbl (%edx),%ebx
80104aa4:	84 c0                	test   %al,%al
80104aa6:	75 e8                	jne    80104a90 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104aa8:	29 d8                	sub    %ebx,%eax
}
80104aaa:	5b                   	pop    %ebx
80104aab:	5e                   	pop    %esi
80104aac:	5d                   	pop    %ebp
80104aad:	c3                   	ret    
80104aae:	66 90                	xchg   %ax,%ax
80104ab0:	5b                   	pop    %ebx
    return 0;
80104ab1:	31 c0                	xor    %eax,%eax
}
80104ab3:	5e                   	pop    %esi
80104ab4:	5d                   	pop    %ebp
80104ab5:	c3                   	ret    
80104ab6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104abd:	8d 76 00             	lea    0x0(%esi),%esi

80104ac0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	57                   	push   %edi
80104ac4:	56                   	push   %esi
80104ac5:	8b 75 08             	mov    0x8(%ebp),%esi
80104ac8:	53                   	push   %ebx
80104ac9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104acc:	89 f0                	mov    %esi,%eax
80104ace:	eb 15                	jmp    80104ae5 <strncpy+0x25>
80104ad0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104ad4:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104ad7:	83 c0 01             	add    $0x1,%eax
80104ada:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104ade:	88 50 ff             	mov    %dl,-0x1(%eax)
80104ae1:	84 d2                	test   %dl,%dl
80104ae3:	74 09                	je     80104aee <strncpy+0x2e>
80104ae5:	89 cb                	mov    %ecx,%ebx
80104ae7:	83 e9 01             	sub    $0x1,%ecx
80104aea:	85 db                	test   %ebx,%ebx
80104aec:	7f e2                	jg     80104ad0 <strncpy+0x10>
    ;
  while(n-- > 0)
80104aee:	89 c2                	mov    %eax,%edx
80104af0:	85 c9                	test   %ecx,%ecx
80104af2:	7e 17                	jle    80104b0b <strncpy+0x4b>
80104af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104af8:	83 c2 01             	add    $0x1,%edx
80104afb:	89 c1                	mov    %eax,%ecx
80104afd:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104b01:	29 d1                	sub    %edx,%ecx
80104b03:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104b07:	85 c9                	test   %ecx,%ecx
80104b09:	7f ed                	jg     80104af8 <strncpy+0x38>
  return os;
}
80104b0b:	5b                   	pop    %ebx
80104b0c:	89 f0                	mov    %esi,%eax
80104b0e:	5e                   	pop    %esi
80104b0f:	5f                   	pop    %edi
80104b10:	5d                   	pop    %ebp
80104b11:	c3                   	ret    
80104b12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b20 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	56                   	push   %esi
80104b24:	8b 55 10             	mov    0x10(%ebp),%edx
80104b27:	8b 75 08             	mov    0x8(%ebp),%esi
80104b2a:	53                   	push   %ebx
80104b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104b2e:	85 d2                	test   %edx,%edx
80104b30:	7e 25                	jle    80104b57 <safestrcpy+0x37>
80104b32:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104b36:	89 f2                	mov    %esi,%edx
80104b38:	eb 16                	jmp    80104b50 <safestrcpy+0x30>
80104b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104b40:	0f b6 08             	movzbl (%eax),%ecx
80104b43:	83 c0 01             	add    $0x1,%eax
80104b46:	83 c2 01             	add    $0x1,%edx
80104b49:	88 4a ff             	mov    %cl,-0x1(%edx)
80104b4c:	84 c9                	test   %cl,%cl
80104b4e:	74 04                	je     80104b54 <safestrcpy+0x34>
80104b50:	39 d8                	cmp    %ebx,%eax
80104b52:	75 ec                	jne    80104b40 <safestrcpy+0x20>
    ;
  *s = 0;
80104b54:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104b57:	89 f0                	mov    %esi,%eax
80104b59:	5b                   	pop    %ebx
80104b5a:	5e                   	pop    %esi
80104b5b:	5d                   	pop    %ebp
80104b5c:	c3                   	ret    
80104b5d:	8d 76 00             	lea    0x0(%esi),%esi

80104b60 <strlen>:

int
strlen(const char *s)
{
80104b60:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104b61:	31 c0                	xor    %eax,%eax
{
80104b63:	89 e5                	mov    %esp,%ebp
80104b65:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104b68:	80 3a 00             	cmpb   $0x0,(%edx)
80104b6b:	74 0c                	je     80104b79 <strlen+0x19>
80104b6d:	8d 76 00             	lea    0x0(%esi),%esi
80104b70:	83 c0 01             	add    $0x1,%eax
80104b73:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104b77:	75 f7                	jne    80104b70 <strlen+0x10>
    ;
  return n;
}
80104b79:	5d                   	pop    %ebp
80104b7a:	c3                   	ret    

80104b7b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104b7b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104b7f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104b83:	55                   	push   %ebp
  pushl %ebx
80104b84:	53                   	push   %ebx
  pushl %esi
80104b85:	56                   	push   %esi
  pushl %edi
80104b86:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104b87:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104b89:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104b8b:	5f                   	pop    %edi
  popl %esi
80104b8c:	5e                   	pop    %esi
  popl %ebx
80104b8d:	5b                   	pop    %ebx
  popl %ebp
80104b8e:	5d                   	pop    %ebp
  ret
80104b8f:	c3                   	ret    

80104b90 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	53                   	push   %ebx
80104b94:	83 ec 04             	sub    $0x4,%esp
80104b97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104b9a:	e8 d1 f0 ff ff       	call   80103c70 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b9f:	8b 00                	mov    (%eax),%eax
80104ba1:	39 d8                	cmp    %ebx,%eax
80104ba3:	76 1b                	jbe    80104bc0 <fetchint+0x30>
80104ba5:	8d 53 04             	lea    0x4(%ebx),%edx
80104ba8:	39 d0                	cmp    %edx,%eax
80104baa:	72 14                	jb     80104bc0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104bac:	8b 45 0c             	mov    0xc(%ebp),%eax
80104baf:	8b 13                	mov    (%ebx),%edx
80104bb1:	89 10                	mov    %edx,(%eax)
  return 0;
80104bb3:	31 c0                	xor    %eax,%eax
}
80104bb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bb8:	c9                   	leave  
80104bb9:	c3                   	ret    
80104bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104bc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bc5:	eb ee                	jmp    80104bb5 <fetchint+0x25>
80104bc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bce:	66 90                	xchg   %ax,%ax

80104bd0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	53                   	push   %ebx
80104bd4:	83 ec 04             	sub    $0x4,%esp
80104bd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104bda:	e8 91 f0 ff ff       	call   80103c70 <myproc>

  if(addr >= curproc->sz)
80104bdf:	39 18                	cmp    %ebx,(%eax)
80104be1:	76 2d                	jbe    80104c10 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104be3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104be6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104be8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104bea:	39 d3                	cmp    %edx,%ebx
80104bec:	73 22                	jae    80104c10 <fetchstr+0x40>
80104bee:	89 d8                	mov    %ebx,%eax
80104bf0:	eb 0d                	jmp    80104bff <fetchstr+0x2f>
80104bf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104bf8:	83 c0 01             	add    $0x1,%eax
80104bfb:	39 c2                	cmp    %eax,%edx
80104bfd:	76 11                	jbe    80104c10 <fetchstr+0x40>
    if(*s == 0)
80104bff:	80 38 00             	cmpb   $0x0,(%eax)
80104c02:	75 f4                	jne    80104bf8 <fetchstr+0x28>
      return s - *pp;
80104c04:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104c06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c09:	c9                   	leave  
80104c0a:	c3                   	ret    
80104c0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c0f:	90                   	nop
80104c10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104c13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c18:	c9                   	leave  
80104c19:	c3                   	ret    
80104c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c20 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	56                   	push   %esi
80104c24:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c25:	e8 46 f0 ff ff       	call   80103c70 <myproc>
80104c2a:	8b 55 08             	mov    0x8(%ebp),%edx
80104c2d:	8b 40 18             	mov    0x18(%eax),%eax
80104c30:	8b 40 44             	mov    0x44(%eax),%eax
80104c33:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c36:	e8 35 f0 ff ff       	call   80103c70 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c3b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c3e:	8b 00                	mov    (%eax),%eax
80104c40:	39 c6                	cmp    %eax,%esi
80104c42:	73 1c                	jae    80104c60 <argint+0x40>
80104c44:	8d 53 08             	lea    0x8(%ebx),%edx
80104c47:	39 d0                	cmp    %edx,%eax
80104c49:	72 15                	jb     80104c60 <argint+0x40>
  *ip = *(int*)(addr);
80104c4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c4e:	8b 53 04             	mov    0x4(%ebx),%edx
80104c51:	89 10                	mov    %edx,(%eax)
  return 0;
80104c53:	31 c0                	xor    %eax,%eax
}
80104c55:	5b                   	pop    %ebx
80104c56:	5e                   	pop    %esi
80104c57:	5d                   	pop    %ebp
80104c58:	c3                   	ret    
80104c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c65:	eb ee                	jmp    80104c55 <argint+0x35>
80104c67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c6e:	66 90                	xchg   %ax,%ax

80104c70 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	57                   	push   %edi
80104c74:	56                   	push   %esi
80104c75:	53                   	push   %ebx
80104c76:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104c79:	e8 f2 ef ff ff       	call   80103c70 <myproc>
80104c7e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c80:	e8 eb ef ff ff       	call   80103c70 <myproc>
80104c85:	8b 55 08             	mov    0x8(%ebp),%edx
80104c88:	8b 40 18             	mov    0x18(%eax),%eax
80104c8b:	8b 40 44             	mov    0x44(%eax),%eax
80104c8e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c91:	e8 da ef ff ff       	call   80103c70 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c96:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c99:	8b 00                	mov    (%eax),%eax
80104c9b:	39 c7                	cmp    %eax,%edi
80104c9d:	73 31                	jae    80104cd0 <argptr+0x60>
80104c9f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104ca2:	39 c8                	cmp    %ecx,%eax
80104ca4:	72 2a                	jb     80104cd0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ca6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104ca9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104cac:	85 d2                	test   %edx,%edx
80104cae:	78 20                	js     80104cd0 <argptr+0x60>
80104cb0:	8b 16                	mov    (%esi),%edx
80104cb2:	39 c2                	cmp    %eax,%edx
80104cb4:	76 1a                	jbe    80104cd0 <argptr+0x60>
80104cb6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104cb9:	01 c3                	add    %eax,%ebx
80104cbb:	39 da                	cmp    %ebx,%edx
80104cbd:	72 11                	jb     80104cd0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104cbf:	8b 55 0c             	mov    0xc(%ebp),%edx
80104cc2:	89 02                	mov    %eax,(%edx)
  return 0;
80104cc4:	31 c0                	xor    %eax,%eax
}
80104cc6:	83 c4 0c             	add    $0xc,%esp
80104cc9:	5b                   	pop    %ebx
80104cca:	5e                   	pop    %esi
80104ccb:	5f                   	pop    %edi
80104ccc:	5d                   	pop    %ebp
80104ccd:	c3                   	ret    
80104cce:	66 90                	xchg   %ax,%ax
    return -1;
80104cd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cd5:	eb ef                	jmp    80104cc6 <argptr+0x56>
80104cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cde:	66 90                	xchg   %ax,%ax

80104ce0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	56                   	push   %esi
80104ce4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ce5:	e8 86 ef ff ff       	call   80103c70 <myproc>
80104cea:	8b 55 08             	mov    0x8(%ebp),%edx
80104ced:	8b 40 18             	mov    0x18(%eax),%eax
80104cf0:	8b 40 44             	mov    0x44(%eax),%eax
80104cf3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104cf6:	e8 75 ef ff ff       	call   80103c70 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cfb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104cfe:	8b 00                	mov    (%eax),%eax
80104d00:	39 c6                	cmp    %eax,%esi
80104d02:	73 44                	jae    80104d48 <argstr+0x68>
80104d04:	8d 53 08             	lea    0x8(%ebx),%edx
80104d07:	39 d0                	cmp    %edx,%eax
80104d09:	72 3d                	jb     80104d48 <argstr+0x68>
  *ip = *(int*)(addr);
80104d0b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104d0e:	e8 5d ef ff ff       	call   80103c70 <myproc>
  if(addr >= curproc->sz)
80104d13:	3b 18                	cmp    (%eax),%ebx
80104d15:	73 31                	jae    80104d48 <argstr+0x68>
  *pp = (char*)addr;
80104d17:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d1a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104d1c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104d1e:	39 d3                	cmp    %edx,%ebx
80104d20:	73 26                	jae    80104d48 <argstr+0x68>
80104d22:	89 d8                	mov    %ebx,%eax
80104d24:	eb 11                	jmp    80104d37 <argstr+0x57>
80104d26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d2d:	8d 76 00             	lea    0x0(%esi),%esi
80104d30:	83 c0 01             	add    $0x1,%eax
80104d33:	39 c2                	cmp    %eax,%edx
80104d35:	76 11                	jbe    80104d48 <argstr+0x68>
    if(*s == 0)
80104d37:	80 38 00             	cmpb   $0x0,(%eax)
80104d3a:	75 f4                	jne    80104d30 <argstr+0x50>
      return s - *pp;
80104d3c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104d3e:	5b                   	pop    %ebx
80104d3f:	5e                   	pop    %esi
80104d40:	5d                   	pop    %ebp
80104d41:	c3                   	ret    
80104d42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d48:	5b                   	pop    %ebx
    return -1;
80104d49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d4e:	5e                   	pop    %esi
80104d4f:	5d                   	pop    %ebp
80104d50:	c3                   	ret    
80104d51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d5f:	90                   	nop

80104d60 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	53                   	push   %ebx
80104d64:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104d67:	e8 04 ef ff ff       	call   80103c70 <myproc>
80104d6c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104d6e:	8b 40 18             	mov    0x18(%eax),%eax
80104d71:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104d74:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d77:	83 fa 14             	cmp    $0x14,%edx
80104d7a:	77 24                	ja     80104da0 <syscall+0x40>
80104d7c:	8b 14 85 c0 7b 10 80 	mov    -0x7fef8440(,%eax,4),%edx
80104d83:	85 d2                	test   %edx,%edx
80104d85:	74 19                	je     80104da0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104d87:	ff d2                	call   *%edx
80104d89:	89 c2                	mov    %eax,%edx
80104d8b:	8b 43 18             	mov    0x18(%ebx),%eax
80104d8e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104d91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d94:	c9                   	leave  
80104d95:	c3                   	ret    
80104d96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d9d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104da0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104da1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104da4:	50                   	push   %eax
80104da5:	ff 73 10             	push   0x10(%ebx)
80104da8:	68 9d 7b 10 80       	push   $0x80107b9d
80104dad:	e8 ee b8 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104db2:	8b 43 18             	mov    0x18(%ebx),%eax
80104db5:	83 c4 10             	add    $0x10,%esp
80104db8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104dbf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dc2:	c9                   	leave  
80104dc3:	c3                   	ret    
80104dc4:	66 90                	xchg   %ax,%ax
80104dc6:	66 90                	xchg   %ax,%ax
80104dc8:	66 90                	xchg   %ax,%ax
80104dca:	66 90                	xchg   %ax,%ax
80104dcc:	66 90                	xchg   %ax,%ax
80104dce:	66 90                	xchg   %ax,%ax

80104dd0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	57                   	push   %edi
80104dd4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104dd5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104dd8:	53                   	push   %ebx
80104dd9:	83 ec 34             	sub    $0x34,%esp
80104ddc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104ddf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104de2:	57                   	push   %edi
80104de3:	50                   	push   %eax
{
80104de4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104de7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104dea:	e8 d1 d5 ff ff       	call   801023c0 <nameiparent>
80104def:	83 c4 10             	add    $0x10,%esp
80104df2:	85 c0                	test   %eax,%eax
80104df4:	0f 84 46 01 00 00    	je     80104f40 <create+0x170>
    return 0;
  ilock(dp);
80104dfa:	83 ec 0c             	sub    $0xc,%esp
80104dfd:	89 c3                	mov    %eax,%ebx
80104dff:	50                   	push   %eax
80104e00:	e8 7b cc ff ff       	call   80101a80 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104e05:	83 c4 0c             	add    $0xc,%esp
80104e08:	6a 00                	push   $0x0
80104e0a:	57                   	push   %edi
80104e0b:	53                   	push   %ebx
80104e0c:	e8 cf d1 ff ff       	call   80101fe0 <dirlookup>
80104e11:	83 c4 10             	add    $0x10,%esp
80104e14:	89 c6                	mov    %eax,%esi
80104e16:	85 c0                	test   %eax,%eax
80104e18:	74 56                	je     80104e70 <create+0xa0>
    iunlockput(dp);
80104e1a:	83 ec 0c             	sub    $0xc,%esp
80104e1d:	53                   	push   %ebx
80104e1e:	e8 ed ce ff ff       	call   80101d10 <iunlockput>
    ilock(ip);
80104e23:	89 34 24             	mov    %esi,(%esp)
80104e26:	e8 55 cc ff ff       	call   80101a80 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104e2b:	83 c4 10             	add    $0x10,%esp
80104e2e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104e33:	75 1b                	jne    80104e50 <create+0x80>
80104e35:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104e3a:	75 14                	jne    80104e50 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104e3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e3f:	89 f0                	mov    %esi,%eax
80104e41:	5b                   	pop    %ebx
80104e42:	5e                   	pop    %esi
80104e43:	5f                   	pop    %edi
80104e44:	5d                   	pop    %ebp
80104e45:	c3                   	ret    
80104e46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e4d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104e50:	83 ec 0c             	sub    $0xc,%esp
80104e53:	56                   	push   %esi
    return 0;
80104e54:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104e56:	e8 b5 ce ff ff       	call   80101d10 <iunlockput>
    return 0;
80104e5b:	83 c4 10             	add    $0x10,%esp
}
80104e5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e61:	89 f0                	mov    %esi,%eax
80104e63:	5b                   	pop    %ebx
80104e64:	5e                   	pop    %esi
80104e65:	5f                   	pop    %edi
80104e66:	5d                   	pop    %ebp
80104e67:	c3                   	ret    
80104e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e6f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104e70:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104e74:	83 ec 08             	sub    $0x8,%esp
80104e77:	50                   	push   %eax
80104e78:	ff 33                	push   (%ebx)
80104e7a:	e8 91 ca ff ff       	call   80101910 <ialloc>
80104e7f:	83 c4 10             	add    $0x10,%esp
80104e82:	89 c6                	mov    %eax,%esi
80104e84:	85 c0                	test   %eax,%eax
80104e86:	0f 84 cd 00 00 00    	je     80104f59 <create+0x189>
  ilock(ip);
80104e8c:	83 ec 0c             	sub    $0xc,%esp
80104e8f:	50                   	push   %eax
80104e90:	e8 eb cb ff ff       	call   80101a80 <ilock>
  ip->major = major;
80104e95:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104e99:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104e9d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104ea1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104ea5:	b8 01 00 00 00       	mov    $0x1,%eax
80104eaa:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104eae:	89 34 24             	mov    %esi,(%esp)
80104eb1:	e8 1a cb ff ff       	call   801019d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104eb6:	83 c4 10             	add    $0x10,%esp
80104eb9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104ebe:	74 30                	je     80104ef0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104ec0:	83 ec 04             	sub    $0x4,%esp
80104ec3:	ff 76 04             	push   0x4(%esi)
80104ec6:	57                   	push   %edi
80104ec7:	53                   	push   %ebx
80104ec8:	e8 13 d4 ff ff       	call   801022e0 <dirlink>
80104ecd:	83 c4 10             	add    $0x10,%esp
80104ed0:	85 c0                	test   %eax,%eax
80104ed2:	78 78                	js     80104f4c <create+0x17c>
  iunlockput(dp);
80104ed4:	83 ec 0c             	sub    $0xc,%esp
80104ed7:	53                   	push   %ebx
80104ed8:	e8 33 ce ff ff       	call   80101d10 <iunlockput>
  return ip;
80104edd:	83 c4 10             	add    $0x10,%esp
}
80104ee0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ee3:	89 f0                	mov    %esi,%eax
80104ee5:	5b                   	pop    %ebx
80104ee6:	5e                   	pop    %esi
80104ee7:	5f                   	pop    %edi
80104ee8:	5d                   	pop    %ebp
80104ee9:	c3                   	ret    
80104eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104ef0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104ef3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104ef8:	53                   	push   %ebx
80104ef9:	e8 d2 ca ff ff       	call   801019d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104efe:	83 c4 0c             	add    $0xc,%esp
80104f01:	ff 76 04             	push   0x4(%esi)
80104f04:	68 34 7c 10 80       	push   $0x80107c34
80104f09:	56                   	push   %esi
80104f0a:	e8 d1 d3 ff ff       	call   801022e0 <dirlink>
80104f0f:	83 c4 10             	add    $0x10,%esp
80104f12:	85 c0                	test   %eax,%eax
80104f14:	78 18                	js     80104f2e <create+0x15e>
80104f16:	83 ec 04             	sub    $0x4,%esp
80104f19:	ff 73 04             	push   0x4(%ebx)
80104f1c:	68 33 7c 10 80       	push   $0x80107c33
80104f21:	56                   	push   %esi
80104f22:	e8 b9 d3 ff ff       	call   801022e0 <dirlink>
80104f27:	83 c4 10             	add    $0x10,%esp
80104f2a:	85 c0                	test   %eax,%eax
80104f2c:	79 92                	jns    80104ec0 <create+0xf0>
      panic("create dots");
80104f2e:	83 ec 0c             	sub    $0xc,%esp
80104f31:	68 27 7c 10 80       	push   $0x80107c27
80104f36:	e8 45 b4 ff ff       	call   80100380 <panic>
80104f3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f3f:	90                   	nop
}
80104f40:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104f43:	31 f6                	xor    %esi,%esi
}
80104f45:	5b                   	pop    %ebx
80104f46:	89 f0                	mov    %esi,%eax
80104f48:	5e                   	pop    %esi
80104f49:	5f                   	pop    %edi
80104f4a:	5d                   	pop    %ebp
80104f4b:	c3                   	ret    
    panic("create: dirlink");
80104f4c:	83 ec 0c             	sub    $0xc,%esp
80104f4f:	68 36 7c 10 80       	push   $0x80107c36
80104f54:	e8 27 b4 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104f59:	83 ec 0c             	sub    $0xc,%esp
80104f5c:	68 18 7c 10 80       	push   $0x80107c18
80104f61:	e8 1a b4 ff ff       	call   80100380 <panic>
80104f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f6d:	8d 76 00             	lea    0x0(%esi),%esi

80104f70 <sys_dup>:
{
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	56                   	push   %esi
80104f74:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f75:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104f78:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f7b:	50                   	push   %eax
80104f7c:	6a 00                	push   $0x0
80104f7e:	e8 9d fc ff ff       	call   80104c20 <argint>
80104f83:	83 c4 10             	add    $0x10,%esp
80104f86:	85 c0                	test   %eax,%eax
80104f88:	78 36                	js     80104fc0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f8a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f8e:	77 30                	ja     80104fc0 <sys_dup+0x50>
80104f90:	e8 db ec ff ff       	call   80103c70 <myproc>
80104f95:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f98:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f9c:	85 f6                	test   %esi,%esi
80104f9e:	74 20                	je     80104fc0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104fa0:	e8 cb ec ff ff       	call   80103c70 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104fa5:	31 db                	xor    %ebx,%ebx
80104fa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fae:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104fb0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104fb4:	85 d2                	test   %edx,%edx
80104fb6:	74 18                	je     80104fd0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104fb8:	83 c3 01             	add    $0x1,%ebx
80104fbb:	83 fb 10             	cmp    $0x10,%ebx
80104fbe:	75 f0                	jne    80104fb0 <sys_dup+0x40>
}
80104fc0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104fc3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104fc8:	89 d8                	mov    %ebx,%eax
80104fca:	5b                   	pop    %ebx
80104fcb:	5e                   	pop    %esi
80104fcc:	5d                   	pop    %ebp
80104fcd:	c3                   	ret    
80104fce:	66 90                	xchg   %ax,%ax
  filedup(f);
80104fd0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104fd3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104fd7:	56                   	push   %esi
80104fd8:	e8 c3 c1 ff ff       	call   801011a0 <filedup>
  return fd;
80104fdd:	83 c4 10             	add    $0x10,%esp
}
80104fe0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fe3:	89 d8                	mov    %ebx,%eax
80104fe5:	5b                   	pop    %ebx
80104fe6:	5e                   	pop    %esi
80104fe7:	5d                   	pop    %ebp
80104fe8:	c3                   	ret    
80104fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ff0 <sys_read>:
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	56                   	push   %esi
80104ff4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ff5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104ff8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104ffb:	53                   	push   %ebx
80104ffc:	6a 00                	push   $0x0
80104ffe:	e8 1d fc ff ff       	call   80104c20 <argint>
80105003:	83 c4 10             	add    $0x10,%esp
80105006:	85 c0                	test   %eax,%eax
80105008:	78 5e                	js     80105068 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010500a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010500e:	77 58                	ja     80105068 <sys_read+0x78>
80105010:	e8 5b ec ff ff       	call   80103c70 <myproc>
80105015:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105018:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010501c:	85 f6                	test   %esi,%esi
8010501e:	74 48                	je     80105068 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105020:	83 ec 08             	sub    $0x8,%esp
80105023:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105026:	50                   	push   %eax
80105027:	6a 02                	push   $0x2
80105029:	e8 f2 fb ff ff       	call   80104c20 <argint>
8010502e:	83 c4 10             	add    $0x10,%esp
80105031:	85 c0                	test   %eax,%eax
80105033:	78 33                	js     80105068 <sys_read+0x78>
80105035:	83 ec 04             	sub    $0x4,%esp
80105038:	ff 75 f0             	push   -0x10(%ebp)
8010503b:	53                   	push   %ebx
8010503c:	6a 01                	push   $0x1
8010503e:	e8 2d fc ff ff       	call   80104c70 <argptr>
80105043:	83 c4 10             	add    $0x10,%esp
80105046:	85 c0                	test   %eax,%eax
80105048:	78 1e                	js     80105068 <sys_read+0x78>
  return fileread(f, p, n);
8010504a:	83 ec 04             	sub    $0x4,%esp
8010504d:	ff 75 f0             	push   -0x10(%ebp)
80105050:	ff 75 f4             	push   -0xc(%ebp)
80105053:	56                   	push   %esi
80105054:	e8 c7 c2 ff ff       	call   80101320 <fileread>
80105059:	83 c4 10             	add    $0x10,%esp
}
8010505c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010505f:	5b                   	pop    %ebx
80105060:	5e                   	pop    %esi
80105061:	5d                   	pop    %ebp
80105062:	c3                   	ret    
80105063:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105067:	90                   	nop
    return -1;
80105068:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010506d:	eb ed                	jmp    8010505c <sys_read+0x6c>
8010506f:	90                   	nop

80105070 <sys_write>:
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	56                   	push   %esi
80105074:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105075:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105078:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010507b:	53                   	push   %ebx
8010507c:	6a 00                	push   $0x0
8010507e:	e8 9d fb ff ff       	call   80104c20 <argint>
80105083:	83 c4 10             	add    $0x10,%esp
80105086:	85 c0                	test   %eax,%eax
80105088:	78 5e                	js     801050e8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010508a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010508e:	77 58                	ja     801050e8 <sys_write+0x78>
80105090:	e8 db eb ff ff       	call   80103c70 <myproc>
80105095:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105098:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010509c:	85 f6                	test   %esi,%esi
8010509e:	74 48                	je     801050e8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050a0:	83 ec 08             	sub    $0x8,%esp
801050a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050a6:	50                   	push   %eax
801050a7:	6a 02                	push   $0x2
801050a9:	e8 72 fb ff ff       	call   80104c20 <argint>
801050ae:	83 c4 10             	add    $0x10,%esp
801050b1:	85 c0                	test   %eax,%eax
801050b3:	78 33                	js     801050e8 <sys_write+0x78>
801050b5:	83 ec 04             	sub    $0x4,%esp
801050b8:	ff 75 f0             	push   -0x10(%ebp)
801050bb:	53                   	push   %ebx
801050bc:	6a 01                	push   $0x1
801050be:	e8 ad fb ff ff       	call   80104c70 <argptr>
801050c3:	83 c4 10             	add    $0x10,%esp
801050c6:	85 c0                	test   %eax,%eax
801050c8:	78 1e                	js     801050e8 <sys_write+0x78>
  return filewrite(f, p, n);
801050ca:	83 ec 04             	sub    $0x4,%esp
801050cd:	ff 75 f0             	push   -0x10(%ebp)
801050d0:	ff 75 f4             	push   -0xc(%ebp)
801050d3:	56                   	push   %esi
801050d4:	e8 d7 c2 ff ff       	call   801013b0 <filewrite>
801050d9:	83 c4 10             	add    $0x10,%esp
}
801050dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050df:	5b                   	pop    %ebx
801050e0:	5e                   	pop    %esi
801050e1:	5d                   	pop    %ebp
801050e2:	c3                   	ret    
801050e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050e7:	90                   	nop
    return -1;
801050e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050ed:	eb ed                	jmp    801050dc <sys_write+0x6c>
801050ef:	90                   	nop

801050f0 <sys_close>:
{
801050f0:	55                   	push   %ebp
801050f1:	89 e5                	mov    %esp,%ebp
801050f3:	56                   	push   %esi
801050f4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801050f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801050f8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050fb:	50                   	push   %eax
801050fc:	6a 00                	push   $0x0
801050fe:	e8 1d fb ff ff       	call   80104c20 <argint>
80105103:	83 c4 10             	add    $0x10,%esp
80105106:	85 c0                	test   %eax,%eax
80105108:	78 3e                	js     80105148 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010510a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010510e:	77 38                	ja     80105148 <sys_close+0x58>
80105110:	e8 5b eb ff ff       	call   80103c70 <myproc>
80105115:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105118:	8d 5a 08             	lea    0x8(%edx),%ebx
8010511b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010511f:	85 f6                	test   %esi,%esi
80105121:	74 25                	je     80105148 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105123:	e8 48 eb ff ff       	call   80103c70 <myproc>
  fileclose(f);
80105128:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010512b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105132:	00 
  fileclose(f);
80105133:	56                   	push   %esi
80105134:	e8 b7 c0 ff ff       	call   801011f0 <fileclose>
  return 0;
80105139:	83 c4 10             	add    $0x10,%esp
8010513c:	31 c0                	xor    %eax,%eax
}
8010513e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105141:	5b                   	pop    %ebx
80105142:	5e                   	pop    %esi
80105143:	5d                   	pop    %ebp
80105144:	c3                   	ret    
80105145:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105148:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010514d:	eb ef                	jmp    8010513e <sys_close+0x4e>
8010514f:	90                   	nop

80105150 <sys_fstat>:
{
80105150:	55                   	push   %ebp
80105151:	89 e5                	mov    %esp,%ebp
80105153:	56                   	push   %esi
80105154:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105155:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105158:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010515b:	53                   	push   %ebx
8010515c:	6a 00                	push   $0x0
8010515e:	e8 bd fa ff ff       	call   80104c20 <argint>
80105163:	83 c4 10             	add    $0x10,%esp
80105166:	85 c0                	test   %eax,%eax
80105168:	78 46                	js     801051b0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010516a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010516e:	77 40                	ja     801051b0 <sys_fstat+0x60>
80105170:	e8 fb ea ff ff       	call   80103c70 <myproc>
80105175:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105178:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010517c:	85 f6                	test   %esi,%esi
8010517e:	74 30                	je     801051b0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105180:	83 ec 04             	sub    $0x4,%esp
80105183:	6a 14                	push   $0x14
80105185:	53                   	push   %ebx
80105186:	6a 01                	push   $0x1
80105188:	e8 e3 fa ff ff       	call   80104c70 <argptr>
8010518d:	83 c4 10             	add    $0x10,%esp
80105190:	85 c0                	test   %eax,%eax
80105192:	78 1c                	js     801051b0 <sys_fstat+0x60>
  return filestat(f, st);
80105194:	83 ec 08             	sub    $0x8,%esp
80105197:	ff 75 f4             	push   -0xc(%ebp)
8010519a:	56                   	push   %esi
8010519b:	e8 30 c1 ff ff       	call   801012d0 <filestat>
801051a0:	83 c4 10             	add    $0x10,%esp
}
801051a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051a6:	5b                   	pop    %ebx
801051a7:	5e                   	pop    %esi
801051a8:	5d                   	pop    %ebp
801051a9:	c3                   	ret    
801051aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801051b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051b5:	eb ec                	jmp    801051a3 <sys_fstat+0x53>
801051b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051be:	66 90                	xchg   %ax,%ax

801051c0 <sys_link>:
{
801051c0:	55                   	push   %ebp
801051c1:	89 e5                	mov    %esp,%ebp
801051c3:	57                   	push   %edi
801051c4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801051c5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801051c8:	53                   	push   %ebx
801051c9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801051cc:	50                   	push   %eax
801051cd:	6a 00                	push   $0x0
801051cf:	e8 0c fb ff ff       	call   80104ce0 <argstr>
801051d4:	83 c4 10             	add    $0x10,%esp
801051d7:	85 c0                	test   %eax,%eax
801051d9:	0f 88 fb 00 00 00    	js     801052da <sys_link+0x11a>
801051df:	83 ec 08             	sub    $0x8,%esp
801051e2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801051e5:	50                   	push   %eax
801051e6:	6a 01                	push   $0x1
801051e8:	e8 f3 fa ff ff       	call   80104ce0 <argstr>
801051ed:	83 c4 10             	add    $0x10,%esp
801051f0:	85 c0                	test   %eax,%eax
801051f2:	0f 88 e2 00 00 00    	js     801052da <sys_link+0x11a>
  begin_op();
801051f8:	e8 63 de ff ff       	call   80103060 <begin_op>
  if((ip = namei(old)) == 0){
801051fd:	83 ec 0c             	sub    $0xc,%esp
80105200:	ff 75 d4             	push   -0x2c(%ebp)
80105203:	e8 98 d1 ff ff       	call   801023a0 <namei>
80105208:	83 c4 10             	add    $0x10,%esp
8010520b:	89 c3                	mov    %eax,%ebx
8010520d:	85 c0                	test   %eax,%eax
8010520f:	0f 84 e4 00 00 00    	je     801052f9 <sys_link+0x139>
  ilock(ip);
80105215:	83 ec 0c             	sub    $0xc,%esp
80105218:	50                   	push   %eax
80105219:	e8 62 c8 ff ff       	call   80101a80 <ilock>
  if(ip->type == T_DIR){
8010521e:	83 c4 10             	add    $0x10,%esp
80105221:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105226:	0f 84 b5 00 00 00    	je     801052e1 <sys_link+0x121>
  iupdate(ip);
8010522c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010522f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105234:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105237:	53                   	push   %ebx
80105238:	e8 93 c7 ff ff       	call   801019d0 <iupdate>
  iunlock(ip);
8010523d:	89 1c 24             	mov    %ebx,(%esp)
80105240:	e8 1b c9 ff ff       	call   80101b60 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105245:	58                   	pop    %eax
80105246:	5a                   	pop    %edx
80105247:	57                   	push   %edi
80105248:	ff 75 d0             	push   -0x30(%ebp)
8010524b:	e8 70 d1 ff ff       	call   801023c0 <nameiparent>
80105250:	83 c4 10             	add    $0x10,%esp
80105253:	89 c6                	mov    %eax,%esi
80105255:	85 c0                	test   %eax,%eax
80105257:	74 5b                	je     801052b4 <sys_link+0xf4>
  ilock(dp);
80105259:	83 ec 0c             	sub    $0xc,%esp
8010525c:	50                   	push   %eax
8010525d:	e8 1e c8 ff ff       	call   80101a80 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105262:	8b 03                	mov    (%ebx),%eax
80105264:	83 c4 10             	add    $0x10,%esp
80105267:	39 06                	cmp    %eax,(%esi)
80105269:	75 3d                	jne    801052a8 <sys_link+0xe8>
8010526b:	83 ec 04             	sub    $0x4,%esp
8010526e:	ff 73 04             	push   0x4(%ebx)
80105271:	57                   	push   %edi
80105272:	56                   	push   %esi
80105273:	e8 68 d0 ff ff       	call   801022e0 <dirlink>
80105278:	83 c4 10             	add    $0x10,%esp
8010527b:	85 c0                	test   %eax,%eax
8010527d:	78 29                	js     801052a8 <sys_link+0xe8>
  iunlockput(dp);
8010527f:	83 ec 0c             	sub    $0xc,%esp
80105282:	56                   	push   %esi
80105283:	e8 88 ca ff ff       	call   80101d10 <iunlockput>
  iput(ip);
80105288:	89 1c 24             	mov    %ebx,(%esp)
8010528b:	e8 20 c9 ff ff       	call   80101bb0 <iput>
  end_op();
80105290:	e8 3b de ff ff       	call   801030d0 <end_op>
  return 0;
80105295:	83 c4 10             	add    $0x10,%esp
80105298:	31 c0                	xor    %eax,%eax
}
8010529a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010529d:	5b                   	pop    %ebx
8010529e:	5e                   	pop    %esi
8010529f:	5f                   	pop    %edi
801052a0:	5d                   	pop    %ebp
801052a1:	c3                   	ret    
801052a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801052a8:	83 ec 0c             	sub    $0xc,%esp
801052ab:	56                   	push   %esi
801052ac:	e8 5f ca ff ff       	call   80101d10 <iunlockput>
    goto bad;
801052b1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801052b4:	83 ec 0c             	sub    $0xc,%esp
801052b7:	53                   	push   %ebx
801052b8:	e8 c3 c7 ff ff       	call   80101a80 <ilock>
  ip->nlink--;
801052bd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052c2:	89 1c 24             	mov    %ebx,(%esp)
801052c5:	e8 06 c7 ff ff       	call   801019d0 <iupdate>
  iunlockput(ip);
801052ca:	89 1c 24             	mov    %ebx,(%esp)
801052cd:	e8 3e ca ff ff       	call   80101d10 <iunlockput>
  end_op();
801052d2:	e8 f9 dd ff ff       	call   801030d0 <end_op>
  return -1;
801052d7:	83 c4 10             	add    $0x10,%esp
801052da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052df:	eb b9                	jmp    8010529a <sys_link+0xda>
    iunlockput(ip);
801052e1:	83 ec 0c             	sub    $0xc,%esp
801052e4:	53                   	push   %ebx
801052e5:	e8 26 ca ff ff       	call   80101d10 <iunlockput>
    end_op();
801052ea:	e8 e1 dd ff ff       	call   801030d0 <end_op>
    return -1;
801052ef:	83 c4 10             	add    $0x10,%esp
801052f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052f7:	eb a1                	jmp    8010529a <sys_link+0xda>
    end_op();
801052f9:	e8 d2 dd ff ff       	call   801030d0 <end_op>
    return -1;
801052fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105303:	eb 95                	jmp    8010529a <sys_link+0xda>
80105305:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010530c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105310 <sys_unlink>:
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	57                   	push   %edi
80105314:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105315:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105318:	53                   	push   %ebx
80105319:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010531c:	50                   	push   %eax
8010531d:	6a 00                	push   $0x0
8010531f:	e8 bc f9 ff ff       	call   80104ce0 <argstr>
80105324:	83 c4 10             	add    $0x10,%esp
80105327:	85 c0                	test   %eax,%eax
80105329:	0f 88 7a 01 00 00    	js     801054a9 <sys_unlink+0x199>
  begin_op();
8010532f:	e8 2c dd ff ff       	call   80103060 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105334:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105337:	83 ec 08             	sub    $0x8,%esp
8010533a:	53                   	push   %ebx
8010533b:	ff 75 c0             	push   -0x40(%ebp)
8010533e:	e8 7d d0 ff ff       	call   801023c0 <nameiparent>
80105343:	83 c4 10             	add    $0x10,%esp
80105346:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105349:	85 c0                	test   %eax,%eax
8010534b:	0f 84 62 01 00 00    	je     801054b3 <sys_unlink+0x1a3>
  ilock(dp);
80105351:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105354:	83 ec 0c             	sub    $0xc,%esp
80105357:	57                   	push   %edi
80105358:	e8 23 c7 ff ff       	call   80101a80 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010535d:	58                   	pop    %eax
8010535e:	5a                   	pop    %edx
8010535f:	68 34 7c 10 80       	push   $0x80107c34
80105364:	53                   	push   %ebx
80105365:	e8 56 cc ff ff       	call   80101fc0 <namecmp>
8010536a:	83 c4 10             	add    $0x10,%esp
8010536d:	85 c0                	test   %eax,%eax
8010536f:	0f 84 fb 00 00 00    	je     80105470 <sys_unlink+0x160>
80105375:	83 ec 08             	sub    $0x8,%esp
80105378:	68 33 7c 10 80       	push   $0x80107c33
8010537d:	53                   	push   %ebx
8010537e:	e8 3d cc ff ff       	call   80101fc0 <namecmp>
80105383:	83 c4 10             	add    $0x10,%esp
80105386:	85 c0                	test   %eax,%eax
80105388:	0f 84 e2 00 00 00    	je     80105470 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010538e:	83 ec 04             	sub    $0x4,%esp
80105391:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105394:	50                   	push   %eax
80105395:	53                   	push   %ebx
80105396:	57                   	push   %edi
80105397:	e8 44 cc ff ff       	call   80101fe0 <dirlookup>
8010539c:	83 c4 10             	add    $0x10,%esp
8010539f:	89 c3                	mov    %eax,%ebx
801053a1:	85 c0                	test   %eax,%eax
801053a3:	0f 84 c7 00 00 00    	je     80105470 <sys_unlink+0x160>
  ilock(ip);
801053a9:	83 ec 0c             	sub    $0xc,%esp
801053ac:	50                   	push   %eax
801053ad:	e8 ce c6 ff ff       	call   80101a80 <ilock>
  if(ip->nlink < 1)
801053b2:	83 c4 10             	add    $0x10,%esp
801053b5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801053ba:	0f 8e 1c 01 00 00    	jle    801054dc <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801053c0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053c5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801053c8:	74 66                	je     80105430 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801053ca:	83 ec 04             	sub    $0x4,%esp
801053cd:	6a 10                	push   $0x10
801053cf:	6a 00                	push   $0x0
801053d1:	57                   	push   %edi
801053d2:	e8 89 f5 ff ff       	call   80104960 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053d7:	6a 10                	push   $0x10
801053d9:	ff 75 c4             	push   -0x3c(%ebp)
801053dc:	57                   	push   %edi
801053dd:	ff 75 b4             	push   -0x4c(%ebp)
801053e0:	e8 ab ca ff ff       	call   80101e90 <writei>
801053e5:	83 c4 20             	add    $0x20,%esp
801053e8:	83 f8 10             	cmp    $0x10,%eax
801053eb:	0f 85 de 00 00 00    	jne    801054cf <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
801053f1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053f6:	0f 84 94 00 00 00    	je     80105490 <sys_unlink+0x180>
  iunlockput(dp);
801053fc:	83 ec 0c             	sub    $0xc,%esp
801053ff:	ff 75 b4             	push   -0x4c(%ebp)
80105402:	e8 09 c9 ff ff       	call   80101d10 <iunlockput>
  ip->nlink--;
80105407:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010540c:	89 1c 24             	mov    %ebx,(%esp)
8010540f:	e8 bc c5 ff ff       	call   801019d0 <iupdate>
  iunlockput(ip);
80105414:	89 1c 24             	mov    %ebx,(%esp)
80105417:	e8 f4 c8 ff ff       	call   80101d10 <iunlockput>
  end_op();
8010541c:	e8 af dc ff ff       	call   801030d0 <end_op>
  return 0;
80105421:	83 c4 10             	add    $0x10,%esp
80105424:	31 c0                	xor    %eax,%eax
}
80105426:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105429:	5b                   	pop    %ebx
8010542a:	5e                   	pop    %esi
8010542b:	5f                   	pop    %edi
8010542c:	5d                   	pop    %ebp
8010542d:	c3                   	ret    
8010542e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105430:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105434:	76 94                	jbe    801053ca <sys_unlink+0xba>
80105436:	be 20 00 00 00       	mov    $0x20,%esi
8010543b:	eb 0b                	jmp    80105448 <sys_unlink+0x138>
8010543d:	8d 76 00             	lea    0x0(%esi),%esi
80105440:	83 c6 10             	add    $0x10,%esi
80105443:	3b 73 58             	cmp    0x58(%ebx),%esi
80105446:	73 82                	jae    801053ca <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105448:	6a 10                	push   $0x10
8010544a:	56                   	push   %esi
8010544b:	57                   	push   %edi
8010544c:	53                   	push   %ebx
8010544d:	e8 3e c9 ff ff       	call   80101d90 <readi>
80105452:	83 c4 10             	add    $0x10,%esp
80105455:	83 f8 10             	cmp    $0x10,%eax
80105458:	75 68                	jne    801054c2 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010545a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010545f:	74 df                	je     80105440 <sys_unlink+0x130>
    iunlockput(ip);
80105461:	83 ec 0c             	sub    $0xc,%esp
80105464:	53                   	push   %ebx
80105465:	e8 a6 c8 ff ff       	call   80101d10 <iunlockput>
    goto bad;
8010546a:	83 c4 10             	add    $0x10,%esp
8010546d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105470:	83 ec 0c             	sub    $0xc,%esp
80105473:	ff 75 b4             	push   -0x4c(%ebp)
80105476:	e8 95 c8 ff ff       	call   80101d10 <iunlockput>
  end_op();
8010547b:	e8 50 dc ff ff       	call   801030d0 <end_op>
  return -1;
80105480:	83 c4 10             	add    $0x10,%esp
80105483:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105488:	eb 9c                	jmp    80105426 <sys_unlink+0x116>
8010548a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105490:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105493:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105496:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010549b:	50                   	push   %eax
8010549c:	e8 2f c5 ff ff       	call   801019d0 <iupdate>
801054a1:	83 c4 10             	add    $0x10,%esp
801054a4:	e9 53 ff ff ff       	jmp    801053fc <sys_unlink+0xec>
    return -1;
801054a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054ae:	e9 73 ff ff ff       	jmp    80105426 <sys_unlink+0x116>
    end_op();
801054b3:	e8 18 dc ff ff       	call   801030d0 <end_op>
    return -1;
801054b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054bd:	e9 64 ff ff ff       	jmp    80105426 <sys_unlink+0x116>
      panic("isdirempty: readi");
801054c2:	83 ec 0c             	sub    $0xc,%esp
801054c5:	68 58 7c 10 80       	push   $0x80107c58
801054ca:	e8 b1 ae ff ff       	call   80100380 <panic>
    panic("unlink: writei");
801054cf:	83 ec 0c             	sub    $0xc,%esp
801054d2:	68 6a 7c 10 80       	push   $0x80107c6a
801054d7:	e8 a4 ae ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
801054dc:	83 ec 0c             	sub    $0xc,%esp
801054df:	68 46 7c 10 80       	push   $0x80107c46
801054e4:	e8 97 ae ff ff       	call   80100380 <panic>
801054e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801054f0 <sys_open>:

int
sys_open(void)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	57                   	push   %edi
801054f4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054f5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801054f8:	53                   	push   %ebx
801054f9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054fc:	50                   	push   %eax
801054fd:	6a 00                	push   $0x0
801054ff:	e8 dc f7 ff ff       	call   80104ce0 <argstr>
80105504:	83 c4 10             	add    $0x10,%esp
80105507:	85 c0                	test   %eax,%eax
80105509:	0f 88 8e 00 00 00    	js     8010559d <sys_open+0xad>
8010550f:	83 ec 08             	sub    $0x8,%esp
80105512:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105515:	50                   	push   %eax
80105516:	6a 01                	push   $0x1
80105518:	e8 03 f7 ff ff       	call   80104c20 <argint>
8010551d:	83 c4 10             	add    $0x10,%esp
80105520:	85 c0                	test   %eax,%eax
80105522:	78 79                	js     8010559d <sys_open+0xad>
    return -1;

  begin_op();
80105524:	e8 37 db ff ff       	call   80103060 <begin_op>

  if(omode & O_CREATE){
80105529:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010552d:	75 79                	jne    801055a8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010552f:	83 ec 0c             	sub    $0xc,%esp
80105532:	ff 75 e0             	push   -0x20(%ebp)
80105535:	e8 66 ce ff ff       	call   801023a0 <namei>
8010553a:	83 c4 10             	add    $0x10,%esp
8010553d:	89 c6                	mov    %eax,%esi
8010553f:	85 c0                	test   %eax,%eax
80105541:	0f 84 7e 00 00 00    	je     801055c5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105547:	83 ec 0c             	sub    $0xc,%esp
8010554a:	50                   	push   %eax
8010554b:	e8 30 c5 ff ff       	call   80101a80 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105550:	83 c4 10             	add    $0x10,%esp
80105553:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105558:	0f 84 c2 00 00 00    	je     80105620 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010555e:	e8 cd bb ff ff       	call   80101130 <filealloc>
80105563:	89 c7                	mov    %eax,%edi
80105565:	85 c0                	test   %eax,%eax
80105567:	74 23                	je     8010558c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105569:	e8 02 e7 ff ff       	call   80103c70 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010556e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105570:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105574:	85 d2                	test   %edx,%edx
80105576:	74 60                	je     801055d8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105578:	83 c3 01             	add    $0x1,%ebx
8010557b:	83 fb 10             	cmp    $0x10,%ebx
8010557e:	75 f0                	jne    80105570 <sys_open+0x80>
    if(f)
      fileclose(f);
80105580:	83 ec 0c             	sub    $0xc,%esp
80105583:	57                   	push   %edi
80105584:	e8 67 bc ff ff       	call   801011f0 <fileclose>
80105589:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010558c:	83 ec 0c             	sub    $0xc,%esp
8010558f:	56                   	push   %esi
80105590:	e8 7b c7 ff ff       	call   80101d10 <iunlockput>
    end_op();
80105595:	e8 36 db ff ff       	call   801030d0 <end_op>
    return -1;
8010559a:	83 c4 10             	add    $0x10,%esp
8010559d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801055a2:	eb 6d                	jmp    80105611 <sys_open+0x121>
801055a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801055a8:	83 ec 0c             	sub    $0xc,%esp
801055ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
801055ae:	31 c9                	xor    %ecx,%ecx
801055b0:	ba 02 00 00 00       	mov    $0x2,%edx
801055b5:	6a 00                	push   $0x0
801055b7:	e8 14 f8 ff ff       	call   80104dd0 <create>
    if(ip == 0){
801055bc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801055bf:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801055c1:	85 c0                	test   %eax,%eax
801055c3:	75 99                	jne    8010555e <sys_open+0x6e>
      end_op();
801055c5:	e8 06 db ff ff       	call   801030d0 <end_op>
      return -1;
801055ca:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801055cf:	eb 40                	jmp    80105611 <sys_open+0x121>
801055d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801055d8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801055db:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801055df:	56                   	push   %esi
801055e0:	e8 7b c5 ff ff       	call   80101b60 <iunlock>
  end_op();
801055e5:	e8 e6 da ff ff       	call   801030d0 <end_op>

  f->type = FD_INODE;
801055ea:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801055f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055f3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801055f6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801055f9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801055fb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105602:	f7 d0                	not    %eax
80105604:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105607:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010560a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010560d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105611:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105614:	89 d8                	mov    %ebx,%eax
80105616:	5b                   	pop    %ebx
80105617:	5e                   	pop    %esi
80105618:	5f                   	pop    %edi
80105619:	5d                   	pop    %ebp
8010561a:	c3                   	ret    
8010561b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010561f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105620:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105623:	85 c9                	test   %ecx,%ecx
80105625:	0f 84 33 ff ff ff    	je     8010555e <sys_open+0x6e>
8010562b:	e9 5c ff ff ff       	jmp    8010558c <sys_open+0x9c>

80105630 <sys_mkdir>:

int
sys_mkdir(void)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105636:	e8 25 da ff ff       	call   80103060 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010563b:	83 ec 08             	sub    $0x8,%esp
8010563e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105641:	50                   	push   %eax
80105642:	6a 00                	push   $0x0
80105644:	e8 97 f6 ff ff       	call   80104ce0 <argstr>
80105649:	83 c4 10             	add    $0x10,%esp
8010564c:	85 c0                	test   %eax,%eax
8010564e:	78 30                	js     80105680 <sys_mkdir+0x50>
80105650:	83 ec 0c             	sub    $0xc,%esp
80105653:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105656:	31 c9                	xor    %ecx,%ecx
80105658:	ba 01 00 00 00       	mov    $0x1,%edx
8010565d:	6a 00                	push   $0x0
8010565f:	e8 6c f7 ff ff       	call   80104dd0 <create>
80105664:	83 c4 10             	add    $0x10,%esp
80105667:	85 c0                	test   %eax,%eax
80105669:	74 15                	je     80105680 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010566b:	83 ec 0c             	sub    $0xc,%esp
8010566e:	50                   	push   %eax
8010566f:	e8 9c c6 ff ff       	call   80101d10 <iunlockput>
  end_op();
80105674:	e8 57 da ff ff       	call   801030d0 <end_op>
  return 0;
80105679:	83 c4 10             	add    $0x10,%esp
8010567c:	31 c0                	xor    %eax,%eax
}
8010567e:	c9                   	leave  
8010567f:	c3                   	ret    
    end_op();
80105680:	e8 4b da ff ff       	call   801030d0 <end_op>
    return -1;
80105685:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010568a:	c9                   	leave  
8010568b:	c3                   	ret    
8010568c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105690 <sys_mknod>:

int
sys_mknod(void)
{
80105690:	55                   	push   %ebp
80105691:	89 e5                	mov    %esp,%ebp
80105693:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105696:	e8 c5 d9 ff ff       	call   80103060 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010569b:	83 ec 08             	sub    $0x8,%esp
8010569e:	8d 45 ec             	lea    -0x14(%ebp),%eax
801056a1:	50                   	push   %eax
801056a2:	6a 00                	push   $0x0
801056a4:	e8 37 f6 ff ff       	call   80104ce0 <argstr>
801056a9:	83 c4 10             	add    $0x10,%esp
801056ac:	85 c0                	test   %eax,%eax
801056ae:	78 60                	js     80105710 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801056b0:	83 ec 08             	sub    $0x8,%esp
801056b3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056b6:	50                   	push   %eax
801056b7:	6a 01                	push   $0x1
801056b9:	e8 62 f5 ff ff       	call   80104c20 <argint>
  if((argstr(0, &path)) < 0 ||
801056be:	83 c4 10             	add    $0x10,%esp
801056c1:	85 c0                	test   %eax,%eax
801056c3:	78 4b                	js     80105710 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801056c5:	83 ec 08             	sub    $0x8,%esp
801056c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056cb:	50                   	push   %eax
801056cc:	6a 02                	push   $0x2
801056ce:	e8 4d f5 ff ff       	call   80104c20 <argint>
     argint(1, &major) < 0 ||
801056d3:	83 c4 10             	add    $0x10,%esp
801056d6:	85 c0                	test   %eax,%eax
801056d8:	78 36                	js     80105710 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801056da:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801056de:	83 ec 0c             	sub    $0xc,%esp
801056e1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801056e5:	ba 03 00 00 00       	mov    $0x3,%edx
801056ea:	50                   	push   %eax
801056eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801056ee:	e8 dd f6 ff ff       	call   80104dd0 <create>
     argint(2, &minor) < 0 ||
801056f3:	83 c4 10             	add    $0x10,%esp
801056f6:	85 c0                	test   %eax,%eax
801056f8:	74 16                	je     80105710 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801056fa:	83 ec 0c             	sub    $0xc,%esp
801056fd:	50                   	push   %eax
801056fe:	e8 0d c6 ff ff       	call   80101d10 <iunlockput>
  end_op();
80105703:	e8 c8 d9 ff ff       	call   801030d0 <end_op>
  return 0;
80105708:	83 c4 10             	add    $0x10,%esp
8010570b:	31 c0                	xor    %eax,%eax
}
8010570d:	c9                   	leave  
8010570e:	c3                   	ret    
8010570f:	90                   	nop
    end_op();
80105710:	e8 bb d9 ff ff       	call   801030d0 <end_op>
    return -1;
80105715:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010571a:	c9                   	leave  
8010571b:	c3                   	ret    
8010571c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105720 <sys_chdir>:

int
sys_chdir(void)
{
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
80105723:	56                   	push   %esi
80105724:	53                   	push   %ebx
80105725:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105728:	e8 43 e5 ff ff       	call   80103c70 <myproc>
8010572d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010572f:	e8 2c d9 ff ff       	call   80103060 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105734:	83 ec 08             	sub    $0x8,%esp
80105737:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010573a:	50                   	push   %eax
8010573b:	6a 00                	push   $0x0
8010573d:	e8 9e f5 ff ff       	call   80104ce0 <argstr>
80105742:	83 c4 10             	add    $0x10,%esp
80105745:	85 c0                	test   %eax,%eax
80105747:	78 77                	js     801057c0 <sys_chdir+0xa0>
80105749:	83 ec 0c             	sub    $0xc,%esp
8010574c:	ff 75 f4             	push   -0xc(%ebp)
8010574f:	e8 4c cc ff ff       	call   801023a0 <namei>
80105754:	83 c4 10             	add    $0x10,%esp
80105757:	89 c3                	mov    %eax,%ebx
80105759:	85 c0                	test   %eax,%eax
8010575b:	74 63                	je     801057c0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010575d:	83 ec 0c             	sub    $0xc,%esp
80105760:	50                   	push   %eax
80105761:	e8 1a c3 ff ff       	call   80101a80 <ilock>
  if(ip->type != T_DIR){
80105766:	83 c4 10             	add    $0x10,%esp
80105769:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010576e:	75 30                	jne    801057a0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105770:	83 ec 0c             	sub    $0xc,%esp
80105773:	53                   	push   %ebx
80105774:	e8 e7 c3 ff ff       	call   80101b60 <iunlock>
  iput(curproc->cwd);
80105779:	58                   	pop    %eax
8010577a:	ff 76 68             	push   0x68(%esi)
8010577d:	e8 2e c4 ff ff       	call   80101bb0 <iput>
  end_op();
80105782:	e8 49 d9 ff ff       	call   801030d0 <end_op>
  curproc->cwd = ip;
80105787:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010578a:	83 c4 10             	add    $0x10,%esp
8010578d:	31 c0                	xor    %eax,%eax
}
8010578f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105792:	5b                   	pop    %ebx
80105793:	5e                   	pop    %esi
80105794:	5d                   	pop    %ebp
80105795:	c3                   	ret    
80105796:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010579d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801057a0:	83 ec 0c             	sub    $0xc,%esp
801057a3:	53                   	push   %ebx
801057a4:	e8 67 c5 ff ff       	call   80101d10 <iunlockput>
    end_op();
801057a9:	e8 22 d9 ff ff       	call   801030d0 <end_op>
    return -1;
801057ae:	83 c4 10             	add    $0x10,%esp
801057b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057b6:	eb d7                	jmp    8010578f <sys_chdir+0x6f>
801057b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057bf:	90                   	nop
    end_op();
801057c0:	e8 0b d9 ff ff       	call   801030d0 <end_op>
    return -1;
801057c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ca:	eb c3                	jmp    8010578f <sys_chdir+0x6f>
801057cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057d0 <sys_exec>:

int
sys_exec(void)
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	57                   	push   %edi
801057d4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801057d5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801057db:	53                   	push   %ebx
801057dc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801057e2:	50                   	push   %eax
801057e3:	6a 00                	push   $0x0
801057e5:	e8 f6 f4 ff ff       	call   80104ce0 <argstr>
801057ea:	83 c4 10             	add    $0x10,%esp
801057ed:	85 c0                	test   %eax,%eax
801057ef:	0f 88 87 00 00 00    	js     8010587c <sys_exec+0xac>
801057f5:	83 ec 08             	sub    $0x8,%esp
801057f8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801057fe:	50                   	push   %eax
801057ff:	6a 01                	push   $0x1
80105801:	e8 1a f4 ff ff       	call   80104c20 <argint>
80105806:	83 c4 10             	add    $0x10,%esp
80105809:	85 c0                	test   %eax,%eax
8010580b:	78 6f                	js     8010587c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010580d:	83 ec 04             	sub    $0x4,%esp
80105810:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105816:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105818:	68 80 00 00 00       	push   $0x80
8010581d:	6a 00                	push   $0x0
8010581f:	56                   	push   %esi
80105820:	e8 3b f1 ff ff       	call   80104960 <memset>
80105825:	83 c4 10             	add    $0x10,%esp
80105828:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010582f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105830:	83 ec 08             	sub    $0x8,%esp
80105833:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105839:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105840:	50                   	push   %eax
80105841:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105847:	01 f8                	add    %edi,%eax
80105849:	50                   	push   %eax
8010584a:	e8 41 f3 ff ff       	call   80104b90 <fetchint>
8010584f:	83 c4 10             	add    $0x10,%esp
80105852:	85 c0                	test   %eax,%eax
80105854:	78 26                	js     8010587c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105856:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010585c:	85 c0                	test   %eax,%eax
8010585e:	74 30                	je     80105890 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105860:	83 ec 08             	sub    $0x8,%esp
80105863:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105866:	52                   	push   %edx
80105867:	50                   	push   %eax
80105868:	e8 63 f3 ff ff       	call   80104bd0 <fetchstr>
8010586d:	83 c4 10             	add    $0x10,%esp
80105870:	85 c0                	test   %eax,%eax
80105872:	78 08                	js     8010587c <sys_exec+0xac>
  for(i=0;; i++){
80105874:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105877:	83 fb 20             	cmp    $0x20,%ebx
8010587a:	75 b4                	jne    80105830 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010587c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010587f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105884:	5b                   	pop    %ebx
80105885:	5e                   	pop    %esi
80105886:	5f                   	pop    %edi
80105887:	5d                   	pop    %ebp
80105888:	c3                   	ret    
80105889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105890:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105897:	00 00 00 00 
  return exec(path, argv);
8010589b:	83 ec 08             	sub    $0x8,%esp
8010589e:	56                   	push   %esi
8010589f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801058a5:	e8 06 b5 ff ff       	call   80100db0 <exec>
801058aa:	83 c4 10             	add    $0x10,%esp
}
801058ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058b0:	5b                   	pop    %ebx
801058b1:	5e                   	pop    %esi
801058b2:	5f                   	pop    %edi
801058b3:	5d                   	pop    %ebp
801058b4:	c3                   	ret    
801058b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058c0 <sys_pipe>:

int
sys_pipe(void)
{
801058c0:	55                   	push   %ebp
801058c1:	89 e5                	mov    %esp,%ebp
801058c3:	57                   	push   %edi
801058c4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801058c5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801058c8:	53                   	push   %ebx
801058c9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801058cc:	6a 08                	push   $0x8
801058ce:	50                   	push   %eax
801058cf:	6a 00                	push   $0x0
801058d1:	e8 9a f3 ff ff       	call   80104c70 <argptr>
801058d6:	83 c4 10             	add    $0x10,%esp
801058d9:	85 c0                	test   %eax,%eax
801058db:	78 4a                	js     80105927 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801058dd:	83 ec 08             	sub    $0x8,%esp
801058e0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058e3:	50                   	push   %eax
801058e4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801058e7:	50                   	push   %eax
801058e8:	e8 43 de ff ff       	call   80103730 <pipealloc>
801058ed:	83 c4 10             	add    $0x10,%esp
801058f0:	85 c0                	test   %eax,%eax
801058f2:	78 33                	js     80105927 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058f4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801058f7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801058f9:	e8 72 e3 ff ff       	call   80103c70 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058fe:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105900:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105904:	85 f6                	test   %esi,%esi
80105906:	74 28                	je     80105930 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105908:	83 c3 01             	add    $0x1,%ebx
8010590b:	83 fb 10             	cmp    $0x10,%ebx
8010590e:	75 f0                	jne    80105900 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105910:	83 ec 0c             	sub    $0xc,%esp
80105913:	ff 75 e0             	push   -0x20(%ebp)
80105916:	e8 d5 b8 ff ff       	call   801011f0 <fileclose>
    fileclose(wf);
8010591b:	58                   	pop    %eax
8010591c:	ff 75 e4             	push   -0x1c(%ebp)
8010591f:	e8 cc b8 ff ff       	call   801011f0 <fileclose>
    return -1;
80105924:	83 c4 10             	add    $0x10,%esp
80105927:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010592c:	eb 53                	jmp    80105981 <sys_pipe+0xc1>
8010592e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105930:	8d 73 08             	lea    0x8(%ebx),%esi
80105933:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105937:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010593a:	e8 31 e3 ff ff       	call   80103c70 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010593f:	31 d2                	xor    %edx,%edx
80105941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105948:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010594c:	85 c9                	test   %ecx,%ecx
8010594e:	74 20                	je     80105970 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105950:	83 c2 01             	add    $0x1,%edx
80105953:	83 fa 10             	cmp    $0x10,%edx
80105956:	75 f0                	jne    80105948 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105958:	e8 13 e3 ff ff       	call   80103c70 <myproc>
8010595d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105964:	00 
80105965:	eb a9                	jmp    80105910 <sys_pipe+0x50>
80105967:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010596e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105970:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105974:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105977:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105979:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010597c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010597f:	31 c0                	xor    %eax,%eax
}
80105981:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105984:	5b                   	pop    %ebx
80105985:	5e                   	pop    %esi
80105986:	5f                   	pop    %edi
80105987:	5d                   	pop    %ebp
80105988:	c3                   	ret    
80105989:	66 90                	xchg   %ax,%ax
8010598b:	66 90                	xchg   %ax,%ax
8010598d:	66 90                	xchg   %ax,%ax
8010598f:	90                   	nop

80105990 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105990:	e9 7b e4 ff ff       	jmp    80103e10 <fork>
80105995:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010599c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059a0 <sys_exit>:
}

int
sys_exit(void)
{
801059a0:	55                   	push   %ebp
801059a1:	89 e5                	mov    %esp,%ebp
801059a3:	83 ec 08             	sub    $0x8,%esp
  exit();
801059a6:	e8 e5 e6 ff ff       	call   80104090 <exit>
  return 0;  // not reached
}
801059ab:	31 c0                	xor    %eax,%eax
801059ad:	c9                   	leave  
801059ae:	c3                   	ret    
801059af:	90                   	nop

801059b0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801059b0:	e9 0b e8 ff ff       	jmp    801041c0 <wait>
801059b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059c0 <sys_kill>:
}

int
sys_kill(void)
{
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
801059c3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801059c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059c9:	50                   	push   %eax
801059ca:	6a 00                	push   $0x0
801059cc:	e8 4f f2 ff ff       	call   80104c20 <argint>
801059d1:	83 c4 10             	add    $0x10,%esp
801059d4:	85 c0                	test   %eax,%eax
801059d6:	78 18                	js     801059f0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801059d8:	83 ec 0c             	sub    $0xc,%esp
801059db:	ff 75 f4             	push   -0xc(%ebp)
801059de:	e8 7d ea ff ff       	call   80104460 <kill>
801059e3:	83 c4 10             	add    $0x10,%esp
}
801059e6:	c9                   	leave  
801059e7:	c3                   	ret    
801059e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ef:	90                   	nop
801059f0:	c9                   	leave  
    return -1;
801059f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059f6:	c3                   	ret    
801059f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059fe:	66 90                	xchg   %ax,%ax

80105a00 <sys_getpid>:

int
sys_getpid(void)
{
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
80105a03:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105a06:	e8 65 e2 ff ff       	call   80103c70 <myproc>
80105a0b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105a0e:	c9                   	leave  
80105a0f:	c3                   	ret    

80105a10 <sys_sbrk>:

int
sys_sbrk(void)
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105a14:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a17:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a1a:	50                   	push   %eax
80105a1b:	6a 00                	push   $0x0
80105a1d:	e8 fe f1 ff ff       	call   80104c20 <argint>
80105a22:	83 c4 10             	add    $0x10,%esp
80105a25:	85 c0                	test   %eax,%eax
80105a27:	78 27                	js     80105a50 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105a29:	e8 42 e2 ff ff       	call   80103c70 <myproc>
  if(growproc(n) < 0)
80105a2e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105a31:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105a33:	ff 75 f4             	push   -0xc(%ebp)
80105a36:	e8 55 e3 ff ff       	call   80103d90 <growproc>
80105a3b:	83 c4 10             	add    $0x10,%esp
80105a3e:	85 c0                	test   %eax,%eax
80105a40:	78 0e                	js     80105a50 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105a42:	89 d8                	mov    %ebx,%eax
80105a44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a47:	c9                   	leave  
80105a48:	c3                   	ret    
80105a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a50:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a55:	eb eb                	jmp    80105a42 <sys_sbrk+0x32>
80105a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a5e:	66 90                	xchg   %ax,%ax

80105a60 <sys_sleep>:

int
sys_sleep(void)
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105a64:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a67:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a6a:	50                   	push   %eax
80105a6b:	6a 00                	push   $0x0
80105a6d:	e8 ae f1 ff ff       	call   80104c20 <argint>
80105a72:	83 c4 10             	add    $0x10,%esp
80105a75:	85 c0                	test   %eax,%eax
80105a77:	0f 88 8a 00 00 00    	js     80105b07 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105a7d:	83 ec 0c             	sub    $0xc,%esp
80105a80:	68 20 3d 11 80       	push   $0x80113d20
80105a85:	e8 16 ee ff ff       	call   801048a0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105a8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105a8d:	8b 1d 00 3d 11 80    	mov    0x80113d00,%ebx
  while(ticks - ticks0 < n){
80105a93:	83 c4 10             	add    $0x10,%esp
80105a96:	85 d2                	test   %edx,%edx
80105a98:	75 27                	jne    80105ac1 <sys_sleep+0x61>
80105a9a:	eb 54                	jmp    80105af0 <sys_sleep+0x90>
80105a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105aa0:	83 ec 08             	sub    $0x8,%esp
80105aa3:	68 20 3d 11 80       	push   $0x80113d20
80105aa8:	68 00 3d 11 80       	push   $0x80113d00
80105aad:	e8 8e e8 ff ff       	call   80104340 <sleep>
  while(ticks - ticks0 < n){
80105ab2:	a1 00 3d 11 80       	mov    0x80113d00,%eax
80105ab7:	83 c4 10             	add    $0x10,%esp
80105aba:	29 d8                	sub    %ebx,%eax
80105abc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105abf:	73 2f                	jae    80105af0 <sys_sleep+0x90>
    if(myproc()->killed){
80105ac1:	e8 aa e1 ff ff       	call   80103c70 <myproc>
80105ac6:	8b 40 24             	mov    0x24(%eax),%eax
80105ac9:	85 c0                	test   %eax,%eax
80105acb:	74 d3                	je     80105aa0 <sys_sleep+0x40>
      release(&tickslock);
80105acd:	83 ec 0c             	sub    $0xc,%esp
80105ad0:	68 20 3d 11 80       	push   $0x80113d20
80105ad5:	e8 66 ed ff ff       	call   80104840 <release>
  }
  release(&tickslock);
  return 0;
}
80105ada:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105add:	83 c4 10             	add    $0x10,%esp
80105ae0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ae5:	c9                   	leave  
80105ae6:	c3                   	ret    
80105ae7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aee:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105af0:	83 ec 0c             	sub    $0xc,%esp
80105af3:	68 20 3d 11 80       	push   $0x80113d20
80105af8:	e8 43 ed ff ff       	call   80104840 <release>
  return 0;
80105afd:	83 c4 10             	add    $0x10,%esp
80105b00:	31 c0                	xor    %eax,%eax
}
80105b02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b05:	c9                   	leave  
80105b06:	c3                   	ret    
    return -1;
80105b07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b0c:	eb f4                	jmp    80105b02 <sys_sleep+0xa2>
80105b0e:	66 90                	xchg   %ax,%ax

80105b10 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	53                   	push   %ebx
80105b14:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105b17:	68 20 3d 11 80       	push   $0x80113d20
80105b1c:	e8 7f ed ff ff       	call   801048a0 <acquire>
  xticks = ticks;
80105b21:	8b 1d 00 3d 11 80    	mov    0x80113d00,%ebx
  release(&tickslock);
80105b27:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80105b2e:	e8 0d ed ff ff       	call   80104840 <release>
  return xticks;
}
80105b33:	89 d8                	mov    %ebx,%eax
80105b35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b38:	c9                   	leave  
80105b39:	c3                   	ret    

80105b3a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105b3a:	1e                   	push   %ds
  pushl %es
80105b3b:	06                   	push   %es
  pushl %fs
80105b3c:	0f a0                	push   %fs
  pushl %gs
80105b3e:	0f a8                	push   %gs
  pushal
80105b40:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105b41:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105b45:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105b47:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105b49:	54                   	push   %esp
  call trap
80105b4a:	e8 c1 00 00 00       	call   80105c10 <trap>
  addl $4, %esp
80105b4f:	83 c4 04             	add    $0x4,%esp

80105b52 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105b52:	61                   	popa   
  popl %gs
80105b53:	0f a9                	pop    %gs
  popl %fs
80105b55:	0f a1                	pop    %fs
  popl %es
80105b57:	07                   	pop    %es
  popl %ds
80105b58:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105b59:	83 c4 08             	add    $0x8,%esp
  iret
80105b5c:	cf                   	iret   
80105b5d:	66 90                	xchg   %ax,%ax
80105b5f:	90                   	nop

80105b60 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105b60:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105b61:	31 c0                	xor    %eax,%eax
{
80105b63:	89 e5                	mov    %esp,%ebp
80105b65:	83 ec 08             	sub    $0x8,%esp
80105b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b6f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105b70:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105b77:	c7 04 c5 62 3d 11 80 	movl   $0x8e000008,-0x7feec29e(,%eax,8)
80105b7e:	08 00 00 8e 
80105b82:	66 89 14 c5 60 3d 11 	mov    %dx,-0x7feec2a0(,%eax,8)
80105b89:	80 
80105b8a:	c1 ea 10             	shr    $0x10,%edx
80105b8d:	66 89 14 c5 66 3d 11 	mov    %dx,-0x7feec29a(,%eax,8)
80105b94:	80 
  for(i = 0; i < 256; i++)
80105b95:	83 c0 01             	add    $0x1,%eax
80105b98:	3d 00 01 00 00       	cmp    $0x100,%eax
80105b9d:	75 d1                	jne    80105b70 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105b9f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ba2:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105ba7:	c7 05 62 3f 11 80 08 	movl   $0xef000008,0x80113f62
80105bae:	00 00 ef 
  initlock(&tickslock, "time");
80105bb1:	68 79 7c 10 80       	push   $0x80107c79
80105bb6:	68 20 3d 11 80       	push   $0x80113d20
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105bbb:	66 a3 60 3f 11 80    	mov    %ax,0x80113f60
80105bc1:	c1 e8 10             	shr    $0x10,%eax
80105bc4:	66 a3 66 3f 11 80    	mov    %ax,0x80113f66
  initlock(&tickslock, "time");
80105bca:	e8 01 eb ff ff       	call   801046d0 <initlock>
}
80105bcf:	83 c4 10             	add    $0x10,%esp
80105bd2:	c9                   	leave  
80105bd3:	c3                   	ret    
80105bd4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bdf:	90                   	nop

80105be0 <idtinit>:

void
idtinit(void)
{
80105be0:	55                   	push   %ebp
  pd[0] = size-1;
80105be1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105be6:	89 e5                	mov    %esp,%ebp
80105be8:	83 ec 10             	sub    $0x10,%esp
80105beb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105bef:	b8 60 3d 11 80       	mov    $0x80113d60,%eax
80105bf4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105bf8:	c1 e8 10             	shr    $0x10,%eax
80105bfb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105bff:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105c02:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105c05:	c9                   	leave  
80105c06:	c3                   	ret    
80105c07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c0e:	66 90                	xchg   %ax,%ax

80105c10 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
80105c13:	57                   	push   %edi
80105c14:	56                   	push   %esi
80105c15:	53                   	push   %ebx
80105c16:	83 ec 1c             	sub    $0x1c,%esp
80105c19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105c1c:	8b 43 30             	mov    0x30(%ebx),%eax
80105c1f:	83 f8 40             	cmp    $0x40,%eax
80105c22:	0f 84 68 01 00 00    	je     80105d90 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105c28:	83 e8 20             	sub    $0x20,%eax
80105c2b:	83 f8 1f             	cmp    $0x1f,%eax
80105c2e:	0f 87 8c 00 00 00    	ja     80105cc0 <trap+0xb0>
80105c34:	ff 24 85 20 7d 10 80 	jmp    *-0x7fef82e0(,%eax,4)
80105c3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c3f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105c40:	e8 fb c8 ff ff       	call   80102540 <ideintr>
    lapiceoi();
80105c45:	e8 c6 cf ff ff       	call   80102c10 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c4a:	e8 21 e0 ff ff       	call   80103c70 <myproc>
80105c4f:	85 c0                	test   %eax,%eax
80105c51:	74 1d                	je     80105c70 <trap+0x60>
80105c53:	e8 18 e0 ff ff       	call   80103c70 <myproc>
80105c58:	8b 50 24             	mov    0x24(%eax),%edx
80105c5b:	85 d2                	test   %edx,%edx
80105c5d:	74 11                	je     80105c70 <trap+0x60>
80105c5f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105c63:	83 e0 03             	and    $0x3,%eax
80105c66:	66 83 f8 03          	cmp    $0x3,%ax
80105c6a:	0f 84 e8 01 00 00    	je     80105e58 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105c70:	e8 fb df ff ff       	call   80103c70 <myproc>
80105c75:	85 c0                	test   %eax,%eax
80105c77:	74 0f                	je     80105c88 <trap+0x78>
80105c79:	e8 f2 df ff ff       	call   80103c70 <myproc>
80105c7e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105c82:	0f 84 b8 00 00 00    	je     80105d40 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c88:	e8 e3 df ff ff       	call   80103c70 <myproc>
80105c8d:	85 c0                	test   %eax,%eax
80105c8f:	74 1d                	je     80105cae <trap+0x9e>
80105c91:	e8 da df ff ff       	call   80103c70 <myproc>
80105c96:	8b 40 24             	mov    0x24(%eax),%eax
80105c99:	85 c0                	test   %eax,%eax
80105c9b:	74 11                	je     80105cae <trap+0x9e>
80105c9d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105ca1:	83 e0 03             	and    $0x3,%eax
80105ca4:	66 83 f8 03          	cmp    $0x3,%ax
80105ca8:	0f 84 0f 01 00 00    	je     80105dbd <trap+0x1ad>
    exit();
}
80105cae:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cb1:	5b                   	pop    %ebx
80105cb2:	5e                   	pop    %esi
80105cb3:	5f                   	pop    %edi
80105cb4:	5d                   	pop    %ebp
80105cb5:	c3                   	ret    
80105cb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cbd:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105cc0:	e8 ab df ff ff       	call   80103c70 <myproc>
80105cc5:	8b 7b 38             	mov    0x38(%ebx),%edi
80105cc8:	85 c0                	test   %eax,%eax
80105cca:	0f 84 a2 01 00 00    	je     80105e72 <trap+0x262>
80105cd0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105cd4:	0f 84 98 01 00 00    	je     80105e72 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105cda:	0f 20 d1             	mov    %cr2,%ecx
80105cdd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ce0:	e8 6b df ff ff       	call   80103c50 <cpuid>
80105ce5:	8b 73 30             	mov    0x30(%ebx),%esi
80105ce8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105ceb:	8b 43 34             	mov    0x34(%ebx),%eax
80105cee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105cf1:	e8 7a df ff ff       	call   80103c70 <myproc>
80105cf6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105cf9:	e8 72 df ff ff       	call   80103c70 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cfe:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105d01:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105d04:	51                   	push   %ecx
80105d05:	57                   	push   %edi
80105d06:	52                   	push   %edx
80105d07:	ff 75 e4             	push   -0x1c(%ebp)
80105d0a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105d0b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105d0e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d11:	56                   	push   %esi
80105d12:	ff 70 10             	push   0x10(%eax)
80105d15:	68 dc 7c 10 80       	push   $0x80107cdc
80105d1a:	e8 81 a9 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105d1f:	83 c4 20             	add    $0x20,%esp
80105d22:	e8 49 df ff ff       	call   80103c70 <myproc>
80105d27:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d2e:	e8 3d df ff ff       	call   80103c70 <myproc>
80105d33:	85 c0                	test   %eax,%eax
80105d35:	0f 85 18 ff ff ff    	jne    80105c53 <trap+0x43>
80105d3b:	e9 30 ff ff ff       	jmp    80105c70 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105d40:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105d44:	0f 85 3e ff ff ff    	jne    80105c88 <trap+0x78>
    yield();
80105d4a:	e8 a1 e5 ff ff       	call   801042f0 <yield>
80105d4f:	e9 34 ff ff ff       	jmp    80105c88 <trap+0x78>
80105d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105d58:	8b 7b 38             	mov    0x38(%ebx),%edi
80105d5b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105d5f:	e8 ec de ff ff       	call   80103c50 <cpuid>
80105d64:	57                   	push   %edi
80105d65:	56                   	push   %esi
80105d66:	50                   	push   %eax
80105d67:	68 84 7c 10 80       	push   $0x80107c84
80105d6c:	e8 2f a9 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105d71:	e8 9a ce ff ff       	call   80102c10 <lapiceoi>
    break;
80105d76:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d79:	e8 f2 de ff ff       	call   80103c70 <myproc>
80105d7e:	85 c0                	test   %eax,%eax
80105d80:	0f 85 cd fe ff ff    	jne    80105c53 <trap+0x43>
80105d86:	e9 e5 fe ff ff       	jmp    80105c70 <trap+0x60>
80105d8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d8f:	90                   	nop
    if(myproc()->killed)
80105d90:	e8 db de ff ff       	call   80103c70 <myproc>
80105d95:	8b 70 24             	mov    0x24(%eax),%esi
80105d98:	85 f6                	test   %esi,%esi
80105d9a:	0f 85 c8 00 00 00    	jne    80105e68 <trap+0x258>
    myproc()->tf = tf;
80105da0:	e8 cb de ff ff       	call   80103c70 <myproc>
80105da5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105da8:	e8 b3 ef ff ff       	call   80104d60 <syscall>
    if(myproc()->killed)
80105dad:	e8 be de ff ff       	call   80103c70 <myproc>
80105db2:	8b 48 24             	mov    0x24(%eax),%ecx
80105db5:	85 c9                	test   %ecx,%ecx
80105db7:	0f 84 f1 fe ff ff    	je     80105cae <trap+0x9e>
}
80105dbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105dc0:	5b                   	pop    %ebx
80105dc1:	5e                   	pop    %esi
80105dc2:	5f                   	pop    %edi
80105dc3:	5d                   	pop    %ebp
      exit();
80105dc4:	e9 c7 e2 ff ff       	jmp    80104090 <exit>
80105dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105dd0:	e8 3b 02 00 00       	call   80106010 <uartintr>
    lapiceoi();
80105dd5:	e8 36 ce ff ff       	call   80102c10 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dda:	e8 91 de ff ff       	call   80103c70 <myproc>
80105ddf:	85 c0                	test   %eax,%eax
80105de1:	0f 85 6c fe ff ff    	jne    80105c53 <trap+0x43>
80105de7:	e9 84 fe ff ff       	jmp    80105c70 <trap+0x60>
80105dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105df0:	e8 db cc ff ff       	call   80102ad0 <kbdintr>
    lapiceoi();
80105df5:	e8 16 ce ff ff       	call   80102c10 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dfa:	e8 71 de ff ff       	call   80103c70 <myproc>
80105dff:	85 c0                	test   %eax,%eax
80105e01:	0f 85 4c fe ff ff    	jne    80105c53 <trap+0x43>
80105e07:	e9 64 fe ff ff       	jmp    80105c70 <trap+0x60>
80105e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105e10:	e8 3b de ff ff       	call   80103c50 <cpuid>
80105e15:	85 c0                	test   %eax,%eax
80105e17:	0f 85 28 fe ff ff    	jne    80105c45 <trap+0x35>
      acquire(&tickslock);
80105e1d:	83 ec 0c             	sub    $0xc,%esp
80105e20:	68 20 3d 11 80       	push   $0x80113d20
80105e25:	e8 76 ea ff ff       	call   801048a0 <acquire>
      wakeup(&ticks);
80105e2a:	c7 04 24 00 3d 11 80 	movl   $0x80113d00,(%esp)
      ticks++;
80105e31:	83 05 00 3d 11 80 01 	addl   $0x1,0x80113d00
      wakeup(&ticks);
80105e38:	e8 c3 e5 ff ff       	call   80104400 <wakeup>
      release(&tickslock);
80105e3d:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80105e44:	e8 f7 e9 ff ff       	call   80104840 <release>
80105e49:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105e4c:	e9 f4 fd ff ff       	jmp    80105c45 <trap+0x35>
80105e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105e58:	e8 33 e2 ff ff       	call   80104090 <exit>
80105e5d:	e9 0e fe ff ff       	jmp    80105c70 <trap+0x60>
80105e62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105e68:	e8 23 e2 ff ff       	call   80104090 <exit>
80105e6d:	e9 2e ff ff ff       	jmp    80105da0 <trap+0x190>
80105e72:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105e75:	e8 d6 dd ff ff       	call   80103c50 <cpuid>
80105e7a:	83 ec 0c             	sub    $0xc,%esp
80105e7d:	56                   	push   %esi
80105e7e:	57                   	push   %edi
80105e7f:	50                   	push   %eax
80105e80:	ff 73 30             	push   0x30(%ebx)
80105e83:	68 a8 7c 10 80       	push   $0x80107ca8
80105e88:	e8 13 a8 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80105e8d:	83 c4 14             	add    $0x14,%esp
80105e90:	68 7e 7c 10 80       	push   $0x80107c7e
80105e95:	e8 e6 a4 ff ff       	call   80100380 <panic>
80105e9a:	66 90                	xchg   %ax,%ax
80105e9c:	66 90                	xchg   %ax,%ax
80105e9e:	66 90                	xchg   %ax,%ax

80105ea0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105ea0:	a1 60 45 11 80       	mov    0x80114560,%eax
80105ea5:	85 c0                	test   %eax,%eax
80105ea7:	74 17                	je     80105ec0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105ea9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105eae:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105eaf:	a8 01                	test   $0x1,%al
80105eb1:	74 0d                	je     80105ec0 <uartgetc+0x20>
80105eb3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105eb8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105eb9:	0f b6 c0             	movzbl %al,%eax
80105ebc:	c3                   	ret    
80105ebd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105ec0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ec5:	c3                   	ret    
80105ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ecd:	8d 76 00             	lea    0x0(%esi),%esi

80105ed0 <uartinit>:
{
80105ed0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105ed1:	31 c9                	xor    %ecx,%ecx
80105ed3:	89 c8                	mov    %ecx,%eax
80105ed5:	89 e5                	mov    %esp,%ebp
80105ed7:	57                   	push   %edi
80105ed8:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105edd:	56                   	push   %esi
80105ede:	89 fa                	mov    %edi,%edx
80105ee0:	53                   	push   %ebx
80105ee1:	83 ec 1c             	sub    $0x1c,%esp
80105ee4:	ee                   	out    %al,(%dx)
80105ee5:	be fb 03 00 00       	mov    $0x3fb,%esi
80105eea:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105eef:	89 f2                	mov    %esi,%edx
80105ef1:	ee                   	out    %al,(%dx)
80105ef2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105ef7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105efc:	ee                   	out    %al,(%dx)
80105efd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105f02:	89 c8                	mov    %ecx,%eax
80105f04:	89 da                	mov    %ebx,%edx
80105f06:	ee                   	out    %al,(%dx)
80105f07:	b8 03 00 00 00       	mov    $0x3,%eax
80105f0c:	89 f2                	mov    %esi,%edx
80105f0e:	ee                   	out    %al,(%dx)
80105f0f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105f14:	89 c8                	mov    %ecx,%eax
80105f16:	ee                   	out    %al,(%dx)
80105f17:	b8 01 00 00 00       	mov    $0x1,%eax
80105f1c:	89 da                	mov    %ebx,%edx
80105f1e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f1f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f24:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105f25:	3c ff                	cmp    $0xff,%al
80105f27:	74 78                	je     80105fa1 <uartinit+0xd1>
  uart = 1;
80105f29:	c7 05 60 45 11 80 01 	movl   $0x1,0x80114560
80105f30:	00 00 00 
80105f33:	89 fa                	mov    %edi,%edx
80105f35:	ec                   	in     (%dx),%al
80105f36:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f3b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105f3c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105f3f:	bf a0 7d 10 80       	mov    $0x80107da0,%edi
80105f44:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105f49:	6a 00                	push   $0x0
80105f4b:	6a 04                	push   $0x4
80105f4d:	e8 2e c8 ff ff       	call   80102780 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105f52:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80105f56:	83 c4 10             	add    $0x10,%esp
80105f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80105f60:	a1 60 45 11 80       	mov    0x80114560,%eax
80105f65:	bb 80 00 00 00       	mov    $0x80,%ebx
80105f6a:	85 c0                	test   %eax,%eax
80105f6c:	75 14                	jne    80105f82 <uartinit+0xb2>
80105f6e:	eb 23                	jmp    80105f93 <uartinit+0xc3>
    microdelay(10);
80105f70:	83 ec 0c             	sub    $0xc,%esp
80105f73:	6a 0a                	push   $0xa
80105f75:	e8 b6 cc ff ff       	call   80102c30 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f7a:	83 c4 10             	add    $0x10,%esp
80105f7d:	83 eb 01             	sub    $0x1,%ebx
80105f80:	74 07                	je     80105f89 <uartinit+0xb9>
80105f82:	89 f2                	mov    %esi,%edx
80105f84:	ec                   	in     (%dx),%al
80105f85:	a8 20                	test   $0x20,%al
80105f87:	74 e7                	je     80105f70 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f89:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105f8d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f92:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105f93:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105f97:	83 c7 01             	add    $0x1,%edi
80105f9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80105f9d:	84 c0                	test   %al,%al
80105f9f:	75 bf                	jne    80105f60 <uartinit+0x90>
}
80105fa1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fa4:	5b                   	pop    %ebx
80105fa5:	5e                   	pop    %esi
80105fa6:	5f                   	pop    %edi
80105fa7:	5d                   	pop    %ebp
80105fa8:	c3                   	ret    
80105fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105fb0 <uartputc>:
  if(!uart)
80105fb0:	a1 60 45 11 80       	mov    0x80114560,%eax
80105fb5:	85 c0                	test   %eax,%eax
80105fb7:	74 47                	je     80106000 <uartputc+0x50>
{
80105fb9:	55                   	push   %ebp
80105fba:	89 e5                	mov    %esp,%ebp
80105fbc:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105fbd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105fc2:	53                   	push   %ebx
80105fc3:	bb 80 00 00 00       	mov    $0x80,%ebx
80105fc8:	eb 18                	jmp    80105fe2 <uartputc+0x32>
80105fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105fd0:	83 ec 0c             	sub    $0xc,%esp
80105fd3:	6a 0a                	push   $0xa
80105fd5:	e8 56 cc ff ff       	call   80102c30 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105fda:	83 c4 10             	add    $0x10,%esp
80105fdd:	83 eb 01             	sub    $0x1,%ebx
80105fe0:	74 07                	je     80105fe9 <uartputc+0x39>
80105fe2:	89 f2                	mov    %esi,%edx
80105fe4:	ec                   	in     (%dx),%al
80105fe5:	a8 20                	test   $0x20,%al
80105fe7:	74 e7                	je     80105fd0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105fe9:	8b 45 08             	mov    0x8(%ebp),%eax
80105fec:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ff1:	ee                   	out    %al,(%dx)
}
80105ff2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105ff5:	5b                   	pop    %ebx
80105ff6:	5e                   	pop    %esi
80105ff7:	5d                   	pop    %ebp
80105ff8:	c3                   	ret    
80105ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106000:	c3                   	ret    
80106001:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106008:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010600f:	90                   	nop

80106010 <uartintr>:

void
uartintr(void)
{
80106010:	55                   	push   %ebp
80106011:	89 e5                	mov    %esp,%ebp
80106013:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106016:	68 a0 5e 10 80       	push   $0x80105ea0
8010601b:	e8 60 a8 ff ff       	call   80100880 <consoleintr>
}
80106020:	83 c4 10             	add    $0x10,%esp
80106023:	c9                   	leave  
80106024:	c3                   	ret    

80106025 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106025:	6a 00                	push   $0x0
  pushl $0
80106027:	6a 00                	push   $0x0
  jmp alltraps
80106029:	e9 0c fb ff ff       	jmp    80105b3a <alltraps>

8010602e <vector1>:
.globl vector1
vector1:
  pushl $0
8010602e:	6a 00                	push   $0x0
  pushl $1
80106030:	6a 01                	push   $0x1
  jmp alltraps
80106032:	e9 03 fb ff ff       	jmp    80105b3a <alltraps>

80106037 <vector2>:
.globl vector2
vector2:
  pushl $0
80106037:	6a 00                	push   $0x0
  pushl $2
80106039:	6a 02                	push   $0x2
  jmp alltraps
8010603b:	e9 fa fa ff ff       	jmp    80105b3a <alltraps>

80106040 <vector3>:
.globl vector3
vector3:
  pushl $0
80106040:	6a 00                	push   $0x0
  pushl $3
80106042:	6a 03                	push   $0x3
  jmp alltraps
80106044:	e9 f1 fa ff ff       	jmp    80105b3a <alltraps>

80106049 <vector4>:
.globl vector4
vector4:
  pushl $0
80106049:	6a 00                	push   $0x0
  pushl $4
8010604b:	6a 04                	push   $0x4
  jmp alltraps
8010604d:	e9 e8 fa ff ff       	jmp    80105b3a <alltraps>

80106052 <vector5>:
.globl vector5
vector5:
  pushl $0
80106052:	6a 00                	push   $0x0
  pushl $5
80106054:	6a 05                	push   $0x5
  jmp alltraps
80106056:	e9 df fa ff ff       	jmp    80105b3a <alltraps>

8010605b <vector6>:
.globl vector6
vector6:
  pushl $0
8010605b:	6a 00                	push   $0x0
  pushl $6
8010605d:	6a 06                	push   $0x6
  jmp alltraps
8010605f:	e9 d6 fa ff ff       	jmp    80105b3a <alltraps>

80106064 <vector7>:
.globl vector7
vector7:
  pushl $0
80106064:	6a 00                	push   $0x0
  pushl $7
80106066:	6a 07                	push   $0x7
  jmp alltraps
80106068:	e9 cd fa ff ff       	jmp    80105b3a <alltraps>

8010606d <vector8>:
.globl vector8
vector8:
  pushl $8
8010606d:	6a 08                	push   $0x8
  jmp alltraps
8010606f:	e9 c6 fa ff ff       	jmp    80105b3a <alltraps>

80106074 <vector9>:
.globl vector9
vector9:
  pushl $0
80106074:	6a 00                	push   $0x0
  pushl $9
80106076:	6a 09                	push   $0x9
  jmp alltraps
80106078:	e9 bd fa ff ff       	jmp    80105b3a <alltraps>

8010607d <vector10>:
.globl vector10
vector10:
  pushl $10
8010607d:	6a 0a                	push   $0xa
  jmp alltraps
8010607f:	e9 b6 fa ff ff       	jmp    80105b3a <alltraps>

80106084 <vector11>:
.globl vector11
vector11:
  pushl $11
80106084:	6a 0b                	push   $0xb
  jmp alltraps
80106086:	e9 af fa ff ff       	jmp    80105b3a <alltraps>

8010608b <vector12>:
.globl vector12
vector12:
  pushl $12
8010608b:	6a 0c                	push   $0xc
  jmp alltraps
8010608d:	e9 a8 fa ff ff       	jmp    80105b3a <alltraps>

80106092 <vector13>:
.globl vector13
vector13:
  pushl $13
80106092:	6a 0d                	push   $0xd
  jmp alltraps
80106094:	e9 a1 fa ff ff       	jmp    80105b3a <alltraps>

80106099 <vector14>:
.globl vector14
vector14:
  pushl $14
80106099:	6a 0e                	push   $0xe
  jmp alltraps
8010609b:	e9 9a fa ff ff       	jmp    80105b3a <alltraps>

801060a0 <vector15>:
.globl vector15
vector15:
  pushl $0
801060a0:	6a 00                	push   $0x0
  pushl $15
801060a2:	6a 0f                	push   $0xf
  jmp alltraps
801060a4:	e9 91 fa ff ff       	jmp    80105b3a <alltraps>

801060a9 <vector16>:
.globl vector16
vector16:
  pushl $0
801060a9:	6a 00                	push   $0x0
  pushl $16
801060ab:	6a 10                	push   $0x10
  jmp alltraps
801060ad:	e9 88 fa ff ff       	jmp    80105b3a <alltraps>

801060b2 <vector17>:
.globl vector17
vector17:
  pushl $17
801060b2:	6a 11                	push   $0x11
  jmp alltraps
801060b4:	e9 81 fa ff ff       	jmp    80105b3a <alltraps>

801060b9 <vector18>:
.globl vector18
vector18:
  pushl $0
801060b9:	6a 00                	push   $0x0
  pushl $18
801060bb:	6a 12                	push   $0x12
  jmp alltraps
801060bd:	e9 78 fa ff ff       	jmp    80105b3a <alltraps>

801060c2 <vector19>:
.globl vector19
vector19:
  pushl $0
801060c2:	6a 00                	push   $0x0
  pushl $19
801060c4:	6a 13                	push   $0x13
  jmp alltraps
801060c6:	e9 6f fa ff ff       	jmp    80105b3a <alltraps>

801060cb <vector20>:
.globl vector20
vector20:
  pushl $0
801060cb:	6a 00                	push   $0x0
  pushl $20
801060cd:	6a 14                	push   $0x14
  jmp alltraps
801060cf:	e9 66 fa ff ff       	jmp    80105b3a <alltraps>

801060d4 <vector21>:
.globl vector21
vector21:
  pushl $0
801060d4:	6a 00                	push   $0x0
  pushl $21
801060d6:	6a 15                	push   $0x15
  jmp alltraps
801060d8:	e9 5d fa ff ff       	jmp    80105b3a <alltraps>

801060dd <vector22>:
.globl vector22
vector22:
  pushl $0
801060dd:	6a 00                	push   $0x0
  pushl $22
801060df:	6a 16                	push   $0x16
  jmp alltraps
801060e1:	e9 54 fa ff ff       	jmp    80105b3a <alltraps>

801060e6 <vector23>:
.globl vector23
vector23:
  pushl $0
801060e6:	6a 00                	push   $0x0
  pushl $23
801060e8:	6a 17                	push   $0x17
  jmp alltraps
801060ea:	e9 4b fa ff ff       	jmp    80105b3a <alltraps>

801060ef <vector24>:
.globl vector24
vector24:
  pushl $0
801060ef:	6a 00                	push   $0x0
  pushl $24
801060f1:	6a 18                	push   $0x18
  jmp alltraps
801060f3:	e9 42 fa ff ff       	jmp    80105b3a <alltraps>

801060f8 <vector25>:
.globl vector25
vector25:
  pushl $0
801060f8:	6a 00                	push   $0x0
  pushl $25
801060fa:	6a 19                	push   $0x19
  jmp alltraps
801060fc:	e9 39 fa ff ff       	jmp    80105b3a <alltraps>

80106101 <vector26>:
.globl vector26
vector26:
  pushl $0
80106101:	6a 00                	push   $0x0
  pushl $26
80106103:	6a 1a                	push   $0x1a
  jmp alltraps
80106105:	e9 30 fa ff ff       	jmp    80105b3a <alltraps>

8010610a <vector27>:
.globl vector27
vector27:
  pushl $0
8010610a:	6a 00                	push   $0x0
  pushl $27
8010610c:	6a 1b                	push   $0x1b
  jmp alltraps
8010610e:	e9 27 fa ff ff       	jmp    80105b3a <alltraps>

80106113 <vector28>:
.globl vector28
vector28:
  pushl $0
80106113:	6a 00                	push   $0x0
  pushl $28
80106115:	6a 1c                	push   $0x1c
  jmp alltraps
80106117:	e9 1e fa ff ff       	jmp    80105b3a <alltraps>

8010611c <vector29>:
.globl vector29
vector29:
  pushl $0
8010611c:	6a 00                	push   $0x0
  pushl $29
8010611e:	6a 1d                	push   $0x1d
  jmp alltraps
80106120:	e9 15 fa ff ff       	jmp    80105b3a <alltraps>

80106125 <vector30>:
.globl vector30
vector30:
  pushl $0
80106125:	6a 00                	push   $0x0
  pushl $30
80106127:	6a 1e                	push   $0x1e
  jmp alltraps
80106129:	e9 0c fa ff ff       	jmp    80105b3a <alltraps>

8010612e <vector31>:
.globl vector31
vector31:
  pushl $0
8010612e:	6a 00                	push   $0x0
  pushl $31
80106130:	6a 1f                	push   $0x1f
  jmp alltraps
80106132:	e9 03 fa ff ff       	jmp    80105b3a <alltraps>

80106137 <vector32>:
.globl vector32
vector32:
  pushl $0
80106137:	6a 00                	push   $0x0
  pushl $32
80106139:	6a 20                	push   $0x20
  jmp alltraps
8010613b:	e9 fa f9 ff ff       	jmp    80105b3a <alltraps>

80106140 <vector33>:
.globl vector33
vector33:
  pushl $0
80106140:	6a 00                	push   $0x0
  pushl $33
80106142:	6a 21                	push   $0x21
  jmp alltraps
80106144:	e9 f1 f9 ff ff       	jmp    80105b3a <alltraps>

80106149 <vector34>:
.globl vector34
vector34:
  pushl $0
80106149:	6a 00                	push   $0x0
  pushl $34
8010614b:	6a 22                	push   $0x22
  jmp alltraps
8010614d:	e9 e8 f9 ff ff       	jmp    80105b3a <alltraps>

80106152 <vector35>:
.globl vector35
vector35:
  pushl $0
80106152:	6a 00                	push   $0x0
  pushl $35
80106154:	6a 23                	push   $0x23
  jmp alltraps
80106156:	e9 df f9 ff ff       	jmp    80105b3a <alltraps>

8010615b <vector36>:
.globl vector36
vector36:
  pushl $0
8010615b:	6a 00                	push   $0x0
  pushl $36
8010615d:	6a 24                	push   $0x24
  jmp alltraps
8010615f:	e9 d6 f9 ff ff       	jmp    80105b3a <alltraps>

80106164 <vector37>:
.globl vector37
vector37:
  pushl $0
80106164:	6a 00                	push   $0x0
  pushl $37
80106166:	6a 25                	push   $0x25
  jmp alltraps
80106168:	e9 cd f9 ff ff       	jmp    80105b3a <alltraps>

8010616d <vector38>:
.globl vector38
vector38:
  pushl $0
8010616d:	6a 00                	push   $0x0
  pushl $38
8010616f:	6a 26                	push   $0x26
  jmp alltraps
80106171:	e9 c4 f9 ff ff       	jmp    80105b3a <alltraps>

80106176 <vector39>:
.globl vector39
vector39:
  pushl $0
80106176:	6a 00                	push   $0x0
  pushl $39
80106178:	6a 27                	push   $0x27
  jmp alltraps
8010617a:	e9 bb f9 ff ff       	jmp    80105b3a <alltraps>

8010617f <vector40>:
.globl vector40
vector40:
  pushl $0
8010617f:	6a 00                	push   $0x0
  pushl $40
80106181:	6a 28                	push   $0x28
  jmp alltraps
80106183:	e9 b2 f9 ff ff       	jmp    80105b3a <alltraps>

80106188 <vector41>:
.globl vector41
vector41:
  pushl $0
80106188:	6a 00                	push   $0x0
  pushl $41
8010618a:	6a 29                	push   $0x29
  jmp alltraps
8010618c:	e9 a9 f9 ff ff       	jmp    80105b3a <alltraps>

80106191 <vector42>:
.globl vector42
vector42:
  pushl $0
80106191:	6a 00                	push   $0x0
  pushl $42
80106193:	6a 2a                	push   $0x2a
  jmp alltraps
80106195:	e9 a0 f9 ff ff       	jmp    80105b3a <alltraps>

8010619a <vector43>:
.globl vector43
vector43:
  pushl $0
8010619a:	6a 00                	push   $0x0
  pushl $43
8010619c:	6a 2b                	push   $0x2b
  jmp alltraps
8010619e:	e9 97 f9 ff ff       	jmp    80105b3a <alltraps>

801061a3 <vector44>:
.globl vector44
vector44:
  pushl $0
801061a3:	6a 00                	push   $0x0
  pushl $44
801061a5:	6a 2c                	push   $0x2c
  jmp alltraps
801061a7:	e9 8e f9 ff ff       	jmp    80105b3a <alltraps>

801061ac <vector45>:
.globl vector45
vector45:
  pushl $0
801061ac:	6a 00                	push   $0x0
  pushl $45
801061ae:	6a 2d                	push   $0x2d
  jmp alltraps
801061b0:	e9 85 f9 ff ff       	jmp    80105b3a <alltraps>

801061b5 <vector46>:
.globl vector46
vector46:
  pushl $0
801061b5:	6a 00                	push   $0x0
  pushl $46
801061b7:	6a 2e                	push   $0x2e
  jmp alltraps
801061b9:	e9 7c f9 ff ff       	jmp    80105b3a <alltraps>

801061be <vector47>:
.globl vector47
vector47:
  pushl $0
801061be:	6a 00                	push   $0x0
  pushl $47
801061c0:	6a 2f                	push   $0x2f
  jmp alltraps
801061c2:	e9 73 f9 ff ff       	jmp    80105b3a <alltraps>

801061c7 <vector48>:
.globl vector48
vector48:
  pushl $0
801061c7:	6a 00                	push   $0x0
  pushl $48
801061c9:	6a 30                	push   $0x30
  jmp alltraps
801061cb:	e9 6a f9 ff ff       	jmp    80105b3a <alltraps>

801061d0 <vector49>:
.globl vector49
vector49:
  pushl $0
801061d0:	6a 00                	push   $0x0
  pushl $49
801061d2:	6a 31                	push   $0x31
  jmp alltraps
801061d4:	e9 61 f9 ff ff       	jmp    80105b3a <alltraps>

801061d9 <vector50>:
.globl vector50
vector50:
  pushl $0
801061d9:	6a 00                	push   $0x0
  pushl $50
801061db:	6a 32                	push   $0x32
  jmp alltraps
801061dd:	e9 58 f9 ff ff       	jmp    80105b3a <alltraps>

801061e2 <vector51>:
.globl vector51
vector51:
  pushl $0
801061e2:	6a 00                	push   $0x0
  pushl $51
801061e4:	6a 33                	push   $0x33
  jmp alltraps
801061e6:	e9 4f f9 ff ff       	jmp    80105b3a <alltraps>

801061eb <vector52>:
.globl vector52
vector52:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $52
801061ed:	6a 34                	push   $0x34
  jmp alltraps
801061ef:	e9 46 f9 ff ff       	jmp    80105b3a <alltraps>

801061f4 <vector53>:
.globl vector53
vector53:
  pushl $0
801061f4:	6a 00                	push   $0x0
  pushl $53
801061f6:	6a 35                	push   $0x35
  jmp alltraps
801061f8:	e9 3d f9 ff ff       	jmp    80105b3a <alltraps>

801061fd <vector54>:
.globl vector54
vector54:
  pushl $0
801061fd:	6a 00                	push   $0x0
  pushl $54
801061ff:	6a 36                	push   $0x36
  jmp alltraps
80106201:	e9 34 f9 ff ff       	jmp    80105b3a <alltraps>

80106206 <vector55>:
.globl vector55
vector55:
  pushl $0
80106206:	6a 00                	push   $0x0
  pushl $55
80106208:	6a 37                	push   $0x37
  jmp alltraps
8010620a:	e9 2b f9 ff ff       	jmp    80105b3a <alltraps>

8010620f <vector56>:
.globl vector56
vector56:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $56
80106211:	6a 38                	push   $0x38
  jmp alltraps
80106213:	e9 22 f9 ff ff       	jmp    80105b3a <alltraps>

80106218 <vector57>:
.globl vector57
vector57:
  pushl $0
80106218:	6a 00                	push   $0x0
  pushl $57
8010621a:	6a 39                	push   $0x39
  jmp alltraps
8010621c:	e9 19 f9 ff ff       	jmp    80105b3a <alltraps>

80106221 <vector58>:
.globl vector58
vector58:
  pushl $0
80106221:	6a 00                	push   $0x0
  pushl $58
80106223:	6a 3a                	push   $0x3a
  jmp alltraps
80106225:	e9 10 f9 ff ff       	jmp    80105b3a <alltraps>

8010622a <vector59>:
.globl vector59
vector59:
  pushl $0
8010622a:	6a 00                	push   $0x0
  pushl $59
8010622c:	6a 3b                	push   $0x3b
  jmp alltraps
8010622e:	e9 07 f9 ff ff       	jmp    80105b3a <alltraps>

80106233 <vector60>:
.globl vector60
vector60:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $60
80106235:	6a 3c                	push   $0x3c
  jmp alltraps
80106237:	e9 fe f8 ff ff       	jmp    80105b3a <alltraps>

8010623c <vector61>:
.globl vector61
vector61:
  pushl $0
8010623c:	6a 00                	push   $0x0
  pushl $61
8010623e:	6a 3d                	push   $0x3d
  jmp alltraps
80106240:	e9 f5 f8 ff ff       	jmp    80105b3a <alltraps>

80106245 <vector62>:
.globl vector62
vector62:
  pushl $0
80106245:	6a 00                	push   $0x0
  pushl $62
80106247:	6a 3e                	push   $0x3e
  jmp alltraps
80106249:	e9 ec f8 ff ff       	jmp    80105b3a <alltraps>

8010624e <vector63>:
.globl vector63
vector63:
  pushl $0
8010624e:	6a 00                	push   $0x0
  pushl $63
80106250:	6a 3f                	push   $0x3f
  jmp alltraps
80106252:	e9 e3 f8 ff ff       	jmp    80105b3a <alltraps>

80106257 <vector64>:
.globl vector64
vector64:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $64
80106259:	6a 40                	push   $0x40
  jmp alltraps
8010625b:	e9 da f8 ff ff       	jmp    80105b3a <alltraps>

80106260 <vector65>:
.globl vector65
vector65:
  pushl $0
80106260:	6a 00                	push   $0x0
  pushl $65
80106262:	6a 41                	push   $0x41
  jmp alltraps
80106264:	e9 d1 f8 ff ff       	jmp    80105b3a <alltraps>

80106269 <vector66>:
.globl vector66
vector66:
  pushl $0
80106269:	6a 00                	push   $0x0
  pushl $66
8010626b:	6a 42                	push   $0x42
  jmp alltraps
8010626d:	e9 c8 f8 ff ff       	jmp    80105b3a <alltraps>

80106272 <vector67>:
.globl vector67
vector67:
  pushl $0
80106272:	6a 00                	push   $0x0
  pushl $67
80106274:	6a 43                	push   $0x43
  jmp alltraps
80106276:	e9 bf f8 ff ff       	jmp    80105b3a <alltraps>

8010627b <vector68>:
.globl vector68
vector68:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $68
8010627d:	6a 44                	push   $0x44
  jmp alltraps
8010627f:	e9 b6 f8 ff ff       	jmp    80105b3a <alltraps>

80106284 <vector69>:
.globl vector69
vector69:
  pushl $0
80106284:	6a 00                	push   $0x0
  pushl $69
80106286:	6a 45                	push   $0x45
  jmp alltraps
80106288:	e9 ad f8 ff ff       	jmp    80105b3a <alltraps>

8010628d <vector70>:
.globl vector70
vector70:
  pushl $0
8010628d:	6a 00                	push   $0x0
  pushl $70
8010628f:	6a 46                	push   $0x46
  jmp alltraps
80106291:	e9 a4 f8 ff ff       	jmp    80105b3a <alltraps>

80106296 <vector71>:
.globl vector71
vector71:
  pushl $0
80106296:	6a 00                	push   $0x0
  pushl $71
80106298:	6a 47                	push   $0x47
  jmp alltraps
8010629a:	e9 9b f8 ff ff       	jmp    80105b3a <alltraps>

8010629f <vector72>:
.globl vector72
vector72:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $72
801062a1:	6a 48                	push   $0x48
  jmp alltraps
801062a3:	e9 92 f8 ff ff       	jmp    80105b3a <alltraps>

801062a8 <vector73>:
.globl vector73
vector73:
  pushl $0
801062a8:	6a 00                	push   $0x0
  pushl $73
801062aa:	6a 49                	push   $0x49
  jmp alltraps
801062ac:	e9 89 f8 ff ff       	jmp    80105b3a <alltraps>

801062b1 <vector74>:
.globl vector74
vector74:
  pushl $0
801062b1:	6a 00                	push   $0x0
  pushl $74
801062b3:	6a 4a                	push   $0x4a
  jmp alltraps
801062b5:	e9 80 f8 ff ff       	jmp    80105b3a <alltraps>

801062ba <vector75>:
.globl vector75
vector75:
  pushl $0
801062ba:	6a 00                	push   $0x0
  pushl $75
801062bc:	6a 4b                	push   $0x4b
  jmp alltraps
801062be:	e9 77 f8 ff ff       	jmp    80105b3a <alltraps>

801062c3 <vector76>:
.globl vector76
vector76:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $76
801062c5:	6a 4c                	push   $0x4c
  jmp alltraps
801062c7:	e9 6e f8 ff ff       	jmp    80105b3a <alltraps>

801062cc <vector77>:
.globl vector77
vector77:
  pushl $0
801062cc:	6a 00                	push   $0x0
  pushl $77
801062ce:	6a 4d                	push   $0x4d
  jmp alltraps
801062d0:	e9 65 f8 ff ff       	jmp    80105b3a <alltraps>

801062d5 <vector78>:
.globl vector78
vector78:
  pushl $0
801062d5:	6a 00                	push   $0x0
  pushl $78
801062d7:	6a 4e                	push   $0x4e
  jmp alltraps
801062d9:	e9 5c f8 ff ff       	jmp    80105b3a <alltraps>

801062de <vector79>:
.globl vector79
vector79:
  pushl $0
801062de:	6a 00                	push   $0x0
  pushl $79
801062e0:	6a 4f                	push   $0x4f
  jmp alltraps
801062e2:	e9 53 f8 ff ff       	jmp    80105b3a <alltraps>

801062e7 <vector80>:
.globl vector80
vector80:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $80
801062e9:	6a 50                	push   $0x50
  jmp alltraps
801062eb:	e9 4a f8 ff ff       	jmp    80105b3a <alltraps>

801062f0 <vector81>:
.globl vector81
vector81:
  pushl $0
801062f0:	6a 00                	push   $0x0
  pushl $81
801062f2:	6a 51                	push   $0x51
  jmp alltraps
801062f4:	e9 41 f8 ff ff       	jmp    80105b3a <alltraps>

801062f9 <vector82>:
.globl vector82
vector82:
  pushl $0
801062f9:	6a 00                	push   $0x0
  pushl $82
801062fb:	6a 52                	push   $0x52
  jmp alltraps
801062fd:	e9 38 f8 ff ff       	jmp    80105b3a <alltraps>

80106302 <vector83>:
.globl vector83
vector83:
  pushl $0
80106302:	6a 00                	push   $0x0
  pushl $83
80106304:	6a 53                	push   $0x53
  jmp alltraps
80106306:	e9 2f f8 ff ff       	jmp    80105b3a <alltraps>

8010630b <vector84>:
.globl vector84
vector84:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $84
8010630d:	6a 54                	push   $0x54
  jmp alltraps
8010630f:	e9 26 f8 ff ff       	jmp    80105b3a <alltraps>

80106314 <vector85>:
.globl vector85
vector85:
  pushl $0
80106314:	6a 00                	push   $0x0
  pushl $85
80106316:	6a 55                	push   $0x55
  jmp alltraps
80106318:	e9 1d f8 ff ff       	jmp    80105b3a <alltraps>

8010631d <vector86>:
.globl vector86
vector86:
  pushl $0
8010631d:	6a 00                	push   $0x0
  pushl $86
8010631f:	6a 56                	push   $0x56
  jmp alltraps
80106321:	e9 14 f8 ff ff       	jmp    80105b3a <alltraps>

80106326 <vector87>:
.globl vector87
vector87:
  pushl $0
80106326:	6a 00                	push   $0x0
  pushl $87
80106328:	6a 57                	push   $0x57
  jmp alltraps
8010632a:	e9 0b f8 ff ff       	jmp    80105b3a <alltraps>

8010632f <vector88>:
.globl vector88
vector88:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $88
80106331:	6a 58                	push   $0x58
  jmp alltraps
80106333:	e9 02 f8 ff ff       	jmp    80105b3a <alltraps>

80106338 <vector89>:
.globl vector89
vector89:
  pushl $0
80106338:	6a 00                	push   $0x0
  pushl $89
8010633a:	6a 59                	push   $0x59
  jmp alltraps
8010633c:	e9 f9 f7 ff ff       	jmp    80105b3a <alltraps>

80106341 <vector90>:
.globl vector90
vector90:
  pushl $0
80106341:	6a 00                	push   $0x0
  pushl $90
80106343:	6a 5a                	push   $0x5a
  jmp alltraps
80106345:	e9 f0 f7 ff ff       	jmp    80105b3a <alltraps>

8010634a <vector91>:
.globl vector91
vector91:
  pushl $0
8010634a:	6a 00                	push   $0x0
  pushl $91
8010634c:	6a 5b                	push   $0x5b
  jmp alltraps
8010634e:	e9 e7 f7 ff ff       	jmp    80105b3a <alltraps>

80106353 <vector92>:
.globl vector92
vector92:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $92
80106355:	6a 5c                	push   $0x5c
  jmp alltraps
80106357:	e9 de f7 ff ff       	jmp    80105b3a <alltraps>

8010635c <vector93>:
.globl vector93
vector93:
  pushl $0
8010635c:	6a 00                	push   $0x0
  pushl $93
8010635e:	6a 5d                	push   $0x5d
  jmp alltraps
80106360:	e9 d5 f7 ff ff       	jmp    80105b3a <alltraps>

80106365 <vector94>:
.globl vector94
vector94:
  pushl $0
80106365:	6a 00                	push   $0x0
  pushl $94
80106367:	6a 5e                	push   $0x5e
  jmp alltraps
80106369:	e9 cc f7 ff ff       	jmp    80105b3a <alltraps>

8010636e <vector95>:
.globl vector95
vector95:
  pushl $0
8010636e:	6a 00                	push   $0x0
  pushl $95
80106370:	6a 5f                	push   $0x5f
  jmp alltraps
80106372:	e9 c3 f7 ff ff       	jmp    80105b3a <alltraps>

80106377 <vector96>:
.globl vector96
vector96:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $96
80106379:	6a 60                	push   $0x60
  jmp alltraps
8010637b:	e9 ba f7 ff ff       	jmp    80105b3a <alltraps>

80106380 <vector97>:
.globl vector97
vector97:
  pushl $0
80106380:	6a 00                	push   $0x0
  pushl $97
80106382:	6a 61                	push   $0x61
  jmp alltraps
80106384:	e9 b1 f7 ff ff       	jmp    80105b3a <alltraps>

80106389 <vector98>:
.globl vector98
vector98:
  pushl $0
80106389:	6a 00                	push   $0x0
  pushl $98
8010638b:	6a 62                	push   $0x62
  jmp alltraps
8010638d:	e9 a8 f7 ff ff       	jmp    80105b3a <alltraps>

80106392 <vector99>:
.globl vector99
vector99:
  pushl $0
80106392:	6a 00                	push   $0x0
  pushl $99
80106394:	6a 63                	push   $0x63
  jmp alltraps
80106396:	e9 9f f7 ff ff       	jmp    80105b3a <alltraps>

8010639b <vector100>:
.globl vector100
vector100:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $100
8010639d:	6a 64                	push   $0x64
  jmp alltraps
8010639f:	e9 96 f7 ff ff       	jmp    80105b3a <alltraps>

801063a4 <vector101>:
.globl vector101
vector101:
  pushl $0
801063a4:	6a 00                	push   $0x0
  pushl $101
801063a6:	6a 65                	push   $0x65
  jmp alltraps
801063a8:	e9 8d f7 ff ff       	jmp    80105b3a <alltraps>

801063ad <vector102>:
.globl vector102
vector102:
  pushl $0
801063ad:	6a 00                	push   $0x0
  pushl $102
801063af:	6a 66                	push   $0x66
  jmp alltraps
801063b1:	e9 84 f7 ff ff       	jmp    80105b3a <alltraps>

801063b6 <vector103>:
.globl vector103
vector103:
  pushl $0
801063b6:	6a 00                	push   $0x0
  pushl $103
801063b8:	6a 67                	push   $0x67
  jmp alltraps
801063ba:	e9 7b f7 ff ff       	jmp    80105b3a <alltraps>

801063bf <vector104>:
.globl vector104
vector104:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $104
801063c1:	6a 68                	push   $0x68
  jmp alltraps
801063c3:	e9 72 f7 ff ff       	jmp    80105b3a <alltraps>

801063c8 <vector105>:
.globl vector105
vector105:
  pushl $0
801063c8:	6a 00                	push   $0x0
  pushl $105
801063ca:	6a 69                	push   $0x69
  jmp alltraps
801063cc:	e9 69 f7 ff ff       	jmp    80105b3a <alltraps>

801063d1 <vector106>:
.globl vector106
vector106:
  pushl $0
801063d1:	6a 00                	push   $0x0
  pushl $106
801063d3:	6a 6a                	push   $0x6a
  jmp alltraps
801063d5:	e9 60 f7 ff ff       	jmp    80105b3a <alltraps>

801063da <vector107>:
.globl vector107
vector107:
  pushl $0
801063da:	6a 00                	push   $0x0
  pushl $107
801063dc:	6a 6b                	push   $0x6b
  jmp alltraps
801063de:	e9 57 f7 ff ff       	jmp    80105b3a <alltraps>

801063e3 <vector108>:
.globl vector108
vector108:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $108
801063e5:	6a 6c                	push   $0x6c
  jmp alltraps
801063e7:	e9 4e f7 ff ff       	jmp    80105b3a <alltraps>

801063ec <vector109>:
.globl vector109
vector109:
  pushl $0
801063ec:	6a 00                	push   $0x0
  pushl $109
801063ee:	6a 6d                	push   $0x6d
  jmp alltraps
801063f0:	e9 45 f7 ff ff       	jmp    80105b3a <alltraps>

801063f5 <vector110>:
.globl vector110
vector110:
  pushl $0
801063f5:	6a 00                	push   $0x0
  pushl $110
801063f7:	6a 6e                	push   $0x6e
  jmp alltraps
801063f9:	e9 3c f7 ff ff       	jmp    80105b3a <alltraps>

801063fe <vector111>:
.globl vector111
vector111:
  pushl $0
801063fe:	6a 00                	push   $0x0
  pushl $111
80106400:	6a 6f                	push   $0x6f
  jmp alltraps
80106402:	e9 33 f7 ff ff       	jmp    80105b3a <alltraps>

80106407 <vector112>:
.globl vector112
vector112:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $112
80106409:	6a 70                	push   $0x70
  jmp alltraps
8010640b:	e9 2a f7 ff ff       	jmp    80105b3a <alltraps>

80106410 <vector113>:
.globl vector113
vector113:
  pushl $0
80106410:	6a 00                	push   $0x0
  pushl $113
80106412:	6a 71                	push   $0x71
  jmp alltraps
80106414:	e9 21 f7 ff ff       	jmp    80105b3a <alltraps>

80106419 <vector114>:
.globl vector114
vector114:
  pushl $0
80106419:	6a 00                	push   $0x0
  pushl $114
8010641b:	6a 72                	push   $0x72
  jmp alltraps
8010641d:	e9 18 f7 ff ff       	jmp    80105b3a <alltraps>

80106422 <vector115>:
.globl vector115
vector115:
  pushl $0
80106422:	6a 00                	push   $0x0
  pushl $115
80106424:	6a 73                	push   $0x73
  jmp alltraps
80106426:	e9 0f f7 ff ff       	jmp    80105b3a <alltraps>

8010642b <vector116>:
.globl vector116
vector116:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $116
8010642d:	6a 74                	push   $0x74
  jmp alltraps
8010642f:	e9 06 f7 ff ff       	jmp    80105b3a <alltraps>

80106434 <vector117>:
.globl vector117
vector117:
  pushl $0
80106434:	6a 00                	push   $0x0
  pushl $117
80106436:	6a 75                	push   $0x75
  jmp alltraps
80106438:	e9 fd f6 ff ff       	jmp    80105b3a <alltraps>

8010643d <vector118>:
.globl vector118
vector118:
  pushl $0
8010643d:	6a 00                	push   $0x0
  pushl $118
8010643f:	6a 76                	push   $0x76
  jmp alltraps
80106441:	e9 f4 f6 ff ff       	jmp    80105b3a <alltraps>

80106446 <vector119>:
.globl vector119
vector119:
  pushl $0
80106446:	6a 00                	push   $0x0
  pushl $119
80106448:	6a 77                	push   $0x77
  jmp alltraps
8010644a:	e9 eb f6 ff ff       	jmp    80105b3a <alltraps>

8010644f <vector120>:
.globl vector120
vector120:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $120
80106451:	6a 78                	push   $0x78
  jmp alltraps
80106453:	e9 e2 f6 ff ff       	jmp    80105b3a <alltraps>

80106458 <vector121>:
.globl vector121
vector121:
  pushl $0
80106458:	6a 00                	push   $0x0
  pushl $121
8010645a:	6a 79                	push   $0x79
  jmp alltraps
8010645c:	e9 d9 f6 ff ff       	jmp    80105b3a <alltraps>

80106461 <vector122>:
.globl vector122
vector122:
  pushl $0
80106461:	6a 00                	push   $0x0
  pushl $122
80106463:	6a 7a                	push   $0x7a
  jmp alltraps
80106465:	e9 d0 f6 ff ff       	jmp    80105b3a <alltraps>

8010646a <vector123>:
.globl vector123
vector123:
  pushl $0
8010646a:	6a 00                	push   $0x0
  pushl $123
8010646c:	6a 7b                	push   $0x7b
  jmp alltraps
8010646e:	e9 c7 f6 ff ff       	jmp    80105b3a <alltraps>

80106473 <vector124>:
.globl vector124
vector124:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $124
80106475:	6a 7c                	push   $0x7c
  jmp alltraps
80106477:	e9 be f6 ff ff       	jmp    80105b3a <alltraps>

8010647c <vector125>:
.globl vector125
vector125:
  pushl $0
8010647c:	6a 00                	push   $0x0
  pushl $125
8010647e:	6a 7d                	push   $0x7d
  jmp alltraps
80106480:	e9 b5 f6 ff ff       	jmp    80105b3a <alltraps>

80106485 <vector126>:
.globl vector126
vector126:
  pushl $0
80106485:	6a 00                	push   $0x0
  pushl $126
80106487:	6a 7e                	push   $0x7e
  jmp alltraps
80106489:	e9 ac f6 ff ff       	jmp    80105b3a <alltraps>

8010648e <vector127>:
.globl vector127
vector127:
  pushl $0
8010648e:	6a 00                	push   $0x0
  pushl $127
80106490:	6a 7f                	push   $0x7f
  jmp alltraps
80106492:	e9 a3 f6 ff ff       	jmp    80105b3a <alltraps>

80106497 <vector128>:
.globl vector128
vector128:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $128
80106499:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010649e:	e9 97 f6 ff ff       	jmp    80105b3a <alltraps>

801064a3 <vector129>:
.globl vector129
vector129:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $129
801064a5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801064aa:	e9 8b f6 ff ff       	jmp    80105b3a <alltraps>

801064af <vector130>:
.globl vector130
vector130:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $130
801064b1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801064b6:	e9 7f f6 ff ff       	jmp    80105b3a <alltraps>

801064bb <vector131>:
.globl vector131
vector131:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $131
801064bd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801064c2:	e9 73 f6 ff ff       	jmp    80105b3a <alltraps>

801064c7 <vector132>:
.globl vector132
vector132:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $132
801064c9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801064ce:	e9 67 f6 ff ff       	jmp    80105b3a <alltraps>

801064d3 <vector133>:
.globl vector133
vector133:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $133
801064d5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801064da:	e9 5b f6 ff ff       	jmp    80105b3a <alltraps>

801064df <vector134>:
.globl vector134
vector134:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $134
801064e1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801064e6:	e9 4f f6 ff ff       	jmp    80105b3a <alltraps>

801064eb <vector135>:
.globl vector135
vector135:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $135
801064ed:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801064f2:	e9 43 f6 ff ff       	jmp    80105b3a <alltraps>

801064f7 <vector136>:
.globl vector136
vector136:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $136
801064f9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801064fe:	e9 37 f6 ff ff       	jmp    80105b3a <alltraps>

80106503 <vector137>:
.globl vector137
vector137:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $137
80106505:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010650a:	e9 2b f6 ff ff       	jmp    80105b3a <alltraps>

8010650f <vector138>:
.globl vector138
vector138:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $138
80106511:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106516:	e9 1f f6 ff ff       	jmp    80105b3a <alltraps>

8010651b <vector139>:
.globl vector139
vector139:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $139
8010651d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106522:	e9 13 f6 ff ff       	jmp    80105b3a <alltraps>

80106527 <vector140>:
.globl vector140
vector140:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $140
80106529:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010652e:	e9 07 f6 ff ff       	jmp    80105b3a <alltraps>

80106533 <vector141>:
.globl vector141
vector141:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $141
80106535:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010653a:	e9 fb f5 ff ff       	jmp    80105b3a <alltraps>

8010653f <vector142>:
.globl vector142
vector142:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $142
80106541:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106546:	e9 ef f5 ff ff       	jmp    80105b3a <alltraps>

8010654b <vector143>:
.globl vector143
vector143:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $143
8010654d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106552:	e9 e3 f5 ff ff       	jmp    80105b3a <alltraps>

80106557 <vector144>:
.globl vector144
vector144:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $144
80106559:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010655e:	e9 d7 f5 ff ff       	jmp    80105b3a <alltraps>

80106563 <vector145>:
.globl vector145
vector145:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $145
80106565:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010656a:	e9 cb f5 ff ff       	jmp    80105b3a <alltraps>

8010656f <vector146>:
.globl vector146
vector146:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $146
80106571:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106576:	e9 bf f5 ff ff       	jmp    80105b3a <alltraps>

8010657b <vector147>:
.globl vector147
vector147:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $147
8010657d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106582:	e9 b3 f5 ff ff       	jmp    80105b3a <alltraps>

80106587 <vector148>:
.globl vector148
vector148:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $148
80106589:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010658e:	e9 a7 f5 ff ff       	jmp    80105b3a <alltraps>

80106593 <vector149>:
.globl vector149
vector149:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $149
80106595:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010659a:	e9 9b f5 ff ff       	jmp    80105b3a <alltraps>

8010659f <vector150>:
.globl vector150
vector150:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $150
801065a1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801065a6:	e9 8f f5 ff ff       	jmp    80105b3a <alltraps>

801065ab <vector151>:
.globl vector151
vector151:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $151
801065ad:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801065b2:	e9 83 f5 ff ff       	jmp    80105b3a <alltraps>

801065b7 <vector152>:
.globl vector152
vector152:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $152
801065b9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801065be:	e9 77 f5 ff ff       	jmp    80105b3a <alltraps>

801065c3 <vector153>:
.globl vector153
vector153:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $153
801065c5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801065ca:	e9 6b f5 ff ff       	jmp    80105b3a <alltraps>

801065cf <vector154>:
.globl vector154
vector154:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $154
801065d1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801065d6:	e9 5f f5 ff ff       	jmp    80105b3a <alltraps>

801065db <vector155>:
.globl vector155
vector155:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $155
801065dd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801065e2:	e9 53 f5 ff ff       	jmp    80105b3a <alltraps>

801065e7 <vector156>:
.globl vector156
vector156:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $156
801065e9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801065ee:	e9 47 f5 ff ff       	jmp    80105b3a <alltraps>

801065f3 <vector157>:
.globl vector157
vector157:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $157
801065f5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801065fa:	e9 3b f5 ff ff       	jmp    80105b3a <alltraps>

801065ff <vector158>:
.globl vector158
vector158:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $158
80106601:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106606:	e9 2f f5 ff ff       	jmp    80105b3a <alltraps>

8010660b <vector159>:
.globl vector159
vector159:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $159
8010660d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106612:	e9 23 f5 ff ff       	jmp    80105b3a <alltraps>

80106617 <vector160>:
.globl vector160
vector160:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $160
80106619:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010661e:	e9 17 f5 ff ff       	jmp    80105b3a <alltraps>

80106623 <vector161>:
.globl vector161
vector161:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $161
80106625:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010662a:	e9 0b f5 ff ff       	jmp    80105b3a <alltraps>

8010662f <vector162>:
.globl vector162
vector162:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $162
80106631:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106636:	e9 ff f4 ff ff       	jmp    80105b3a <alltraps>

8010663b <vector163>:
.globl vector163
vector163:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $163
8010663d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106642:	e9 f3 f4 ff ff       	jmp    80105b3a <alltraps>

80106647 <vector164>:
.globl vector164
vector164:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $164
80106649:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010664e:	e9 e7 f4 ff ff       	jmp    80105b3a <alltraps>

80106653 <vector165>:
.globl vector165
vector165:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $165
80106655:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010665a:	e9 db f4 ff ff       	jmp    80105b3a <alltraps>

8010665f <vector166>:
.globl vector166
vector166:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $166
80106661:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106666:	e9 cf f4 ff ff       	jmp    80105b3a <alltraps>

8010666b <vector167>:
.globl vector167
vector167:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $167
8010666d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106672:	e9 c3 f4 ff ff       	jmp    80105b3a <alltraps>

80106677 <vector168>:
.globl vector168
vector168:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $168
80106679:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010667e:	e9 b7 f4 ff ff       	jmp    80105b3a <alltraps>

80106683 <vector169>:
.globl vector169
vector169:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $169
80106685:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010668a:	e9 ab f4 ff ff       	jmp    80105b3a <alltraps>

8010668f <vector170>:
.globl vector170
vector170:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $170
80106691:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106696:	e9 9f f4 ff ff       	jmp    80105b3a <alltraps>

8010669b <vector171>:
.globl vector171
vector171:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $171
8010669d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801066a2:	e9 93 f4 ff ff       	jmp    80105b3a <alltraps>

801066a7 <vector172>:
.globl vector172
vector172:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $172
801066a9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801066ae:	e9 87 f4 ff ff       	jmp    80105b3a <alltraps>

801066b3 <vector173>:
.globl vector173
vector173:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $173
801066b5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801066ba:	e9 7b f4 ff ff       	jmp    80105b3a <alltraps>

801066bf <vector174>:
.globl vector174
vector174:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $174
801066c1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801066c6:	e9 6f f4 ff ff       	jmp    80105b3a <alltraps>

801066cb <vector175>:
.globl vector175
vector175:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $175
801066cd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801066d2:	e9 63 f4 ff ff       	jmp    80105b3a <alltraps>

801066d7 <vector176>:
.globl vector176
vector176:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $176
801066d9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801066de:	e9 57 f4 ff ff       	jmp    80105b3a <alltraps>

801066e3 <vector177>:
.globl vector177
vector177:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $177
801066e5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801066ea:	e9 4b f4 ff ff       	jmp    80105b3a <alltraps>

801066ef <vector178>:
.globl vector178
vector178:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $178
801066f1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801066f6:	e9 3f f4 ff ff       	jmp    80105b3a <alltraps>

801066fb <vector179>:
.globl vector179
vector179:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $179
801066fd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106702:	e9 33 f4 ff ff       	jmp    80105b3a <alltraps>

80106707 <vector180>:
.globl vector180
vector180:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $180
80106709:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010670e:	e9 27 f4 ff ff       	jmp    80105b3a <alltraps>

80106713 <vector181>:
.globl vector181
vector181:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $181
80106715:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010671a:	e9 1b f4 ff ff       	jmp    80105b3a <alltraps>

8010671f <vector182>:
.globl vector182
vector182:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $182
80106721:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106726:	e9 0f f4 ff ff       	jmp    80105b3a <alltraps>

8010672b <vector183>:
.globl vector183
vector183:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $183
8010672d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106732:	e9 03 f4 ff ff       	jmp    80105b3a <alltraps>

80106737 <vector184>:
.globl vector184
vector184:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $184
80106739:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010673e:	e9 f7 f3 ff ff       	jmp    80105b3a <alltraps>

80106743 <vector185>:
.globl vector185
vector185:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $185
80106745:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010674a:	e9 eb f3 ff ff       	jmp    80105b3a <alltraps>

8010674f <vector186>:
.globl vector186
vector186:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $186
80106751:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106756:	e9 df f3 ff ff       	jmp    80105b3a <alltraps>

8010675b <vector187>:
.globl vector187
vector187:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $187
8010675d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106762:	e9 d3 f3 ff ff       	jmp    80105b3a <alltraps>

80106767 <vector188>:
.globl vector188
vector188:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $188
80106769:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010676e:	e9 c7 f3 ff ff       	jmp    80105b3a <alltraps>

80106773 <vector189>:
.globl vector189
vector189:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $189
80106775:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010677a:	e9 bb f3 ff ff       	jmp    80105b3a <alltraps>

8010677f <vector190>:
.globl vector190
vector190:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $190
80106781:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106786:	e9 af f3 ff ff       	jmp    80105b3a <alltraps>

8010678b <vector191>:
.globl vector191
vector191:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $191
8010678d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106792:	e9 a3 f3 ff ff       	jmp    80105b3a <alltraps>

80106797 <vector192>:
.globl vector192
vector192:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $192
80106799:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010679e:	e9 97 f3 ff ff       	jmp    80105b3a <alltraps>

801067a3 <vector193>:
.globl vector193
vector193:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $193
801067a5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801067aa:	e9 8b f3 ff ff       	jmp    80105b3a <alltraps>

801067af <vector194>:
.globl vector194
vector194:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $194
801067b1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801067b6:	e9 7f f3 ff ff       	jmp    80105b3a <alltraps>

801067bb <vector195>:
.globl vector195
vector195:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $195
801067bd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801067c2:	e9 73 f3 ff ff       	jmp    80105b3a <alltraps>

801067c7 <vector196>:
.globl vector196
vector196:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $196
801067c9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801067ce:	e9 67 f3 ff ff       	jmp    80105b3a <alltraps>

801067d3 <vector197>:
.globl vector197
vector197:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $197
801067d5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801067da:	e9 5b f3 ff ff       	jmp    80105b3a <alltraps>

801067df <vector198>:
.globl vector198
vector198:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $198
801067e1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801067e6:	e9 4f f3 ff ff       	jmp    80105b3a <alltraps>

801067eb <vector199>:
.globl vector199
vector199:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $199
801067ed:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801067f2:	e9 43 f3 ff ff       	jmp    80105b3a <alltraps>

801067f7 <vector200>:
.globl vector200
vector200:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $200
801067f9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801067fe:	e9 37 f3 ff ff       	jmp    80105b3a <alltraps>

80106803 <vector201>:
.globl vector201
vector201:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $201
80106805:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010680a:	e9 2b f3 ff ff       	jmp    80105b3a <alltraps>

8010680f <vector202>:
.globl vector202
vector202:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $202
80106811:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106816:	e9 1f f3 ff ff       	jmp    80105b3a <alltraps>

8010681b <vector203>:
.globl vector203
vector203:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $203
8010681d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106822:	e9 13 f3 ff ff       	jmp    80105b3a <alltraps>

80106827 <vector204>:
.globl vector204
vector204:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $204
80106829:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010682e:	e9 07 f3 ff ff       	jmp    80105b3a <alltraps>

80106833 <vector205>:
.globl vector205
vector205:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $205
80106835:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010683a:	e9 fb f2 ff ff       	jmp    80105b3a <alltraps>

8010683f <vector206>:
.globl vector206
vector206:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $206
80106841:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106846:	e9 ef f2 ff ff       	jmp    80105b3a <alltraps>

8010684b <vector207>:
.globl vector207
vector207:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $207
8010684d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106852:	e9 e3 f2 ff ff       	jmp    80105b3a <alltraps>

80106857 <vector208>:
.globl vector208
vector208:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $208
80106859:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010685e:	e9 d7 f2 ff ff       	jmp    80105b3a <alltraps>

80106863 <vector209>:
.globl vector209
vector209:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $209
80106865:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010686a:	e9 cb f2 ff ff       	jmp    80105b3a <alltraps>

8010686f <vector210>:
.globl vector210
vector210:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $210
80106871:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106876:	e9 bf f2 ff ff       	jmp    80105b3a <alltraps>

8010687b <vector211>:
.globl vector211
vector211:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $211
8010687d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106882:	e9 b3 f2 ff ff       	jmp    80105b3a <alltraps>

80106887 <vector212>:
.globl vector212
vector212:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $212
80106889:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010688e:	e9 a7 f2 ff ff       	jmp    80105b3a <alltraps>

80106893 <vector213>:
.globl vector213
vector213:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $213
80106895:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010689a:	e9 9b f2 ff ff       	jmp    80105b3a <alltraps>

8010689f <vector214>:
.globl vector214
vector214:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $214
801068a1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801068a6:	e9 8f f2 ff ff       	jmp    80105b3a <alltraps>

801068ab <vector215>:
.globl vector215
vector215:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $215
801068ad:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801068b2:	e9 83 f2 ff ff       	jmp    80105b3a <alltraps>

801068b7 <vector216>:
.globl vector216
vector216:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $216
801068b9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801068be:	e9 77 f2 ff ff       	jmp    80105b3a <alltraps>

801068c3 <vector217>:
.globl vector217
vector217:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $217
801068c5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801068ca:	e9 6b f2 ff ff       	jmp    80105b3a <alltraps>

801068cf <vector218>:
.globl vector218
vector218:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $218
801068d1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801068d6:	e9 5f f2 ff ff       	jmp    80105b3a <alltraps>

801068db <vector219>:
.globl vector219
vector219:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $219
801068dd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801068e2:	e9 53 f2 ff ff       	jmp    80105b3a <alltraps>

801068e7 <vector220>:
.globl vector220
vector220:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $220
801068e9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801068ee:	e9 47 f2 ff ff       	jmp    80105b3a <alltraps>

801068f3 <vector221>:
.globl vector221
vector221:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $221
801068f5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801068fa:	e9 3b f2 ff ff       	jmp    80105b3a <alltraps>

801068ff <vector222>:
.globl vector222
vector222:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $222
80106901:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106906:	e9 2f f2 ff ff       	jmp    80105b3a <alltraps>

8010690b <vector223>:
.globl vector223
vector223:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $223
8010690d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106912:	e9 23 f2 ff ff       	jmp    80105b3a <alltraps>

80106917 <vector224>:
.globl vector224
vector224:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $224
80106919:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010691e:	e9 17 f2 ff ff       	jmp    80105b3a <alltraps>

80106923 <vector225>:
.globl vector225
vector225:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $225
80106925:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010692a:	e9 0b f2 ff ff       	jmp    80105b3a <alltraps>

8010692f <vector226>:
.globl vector226
vector226:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $226
80106931:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106936:	e9 ff f1 ff ff       	jmp    80105b3a <alltraps>

8010693b <vector227>:
.globl vector227
vector227:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $227
8010693d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106942:	e9 f3 f1 ff ff       	jmp    80105b3a <alltraps>

80106947 <vector228>:
.globl vector228
vector228:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $228
80106949:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010694e:	e9 e7 f1 ff ff       	jmp    80105b3a <alltraps>

80106953 <vector229>:
.globl vector229
vector229:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $229
80106955:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010695a:	e9 db f1 ff ff       	jmp    80105b3a <alltraps>

8010695f <vector230>:
.globl vector230
vector230:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $230
80106961:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106966:	e9 cf f1 ff ff       	jmp    80105b3a <alltraps>

8010696b <vector231>:
.globl vector231
vector231:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $231
8010696d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106972:	e9 c3 f1 ff ff       	jmp    80105b3a <alltraps>

80106977 <vector232>:
.globl vector232
vector232:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $232
80106979:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010697e:	e9 b7 f1 ff ff       	jmp    80105b3a <alltraps>

80106983 <vector233>:
.globl vector233
vector233:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $233
80106985:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010698a:	e9 ab f1 ff ff       	jmp    80105b3a <alltraps>

8010698f <vector234>:
.globl vector234
vector234:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $234
80106991:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106996:	e9 9f f1 ff ff       	jmp    80105b3a <alltraps>

8010699b <vector235>:
.globl vector235
vector235:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $235
8010699d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801069a2:	e9 93 f1 ff ff       	jmp    80105b3a <alltraps>

801069a7 <vector236>:
.globl vector236
vector236:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $236
801069a9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801069ae:	e9 87 f1 ff ff       	jmp    80105b3a <alltraps>

801069b3 <vector237>:
.globl vector237
vector237:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $237
801069b5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801069ba:	e9 7b f1 ff ff       	jmp    80105b3a <alltraps>

801069bf <vector238>:
.globl vector238
vector238:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $238
801069c1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801069c6:	e9 6f f1 ff ff       	jmp    80105b3a <alltraps>

801069cb <vector239>:
.globl vector239
vector239:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $239
801069cd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801069d2:	e9 63 f1 ff ff       	jmp    80105b3a <alltraps>

801069d7 <vector240>:
.globl vector240
vector240:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $240
801069d9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801069de:	e9 57 f1 ff ff       	jmp    80105b3a <alltraps>

801069e3 <vector241>:
.globl vector241
vector241:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $241
801069e5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801069ea:	e9 4b f1 ff ff       	jmp    80105b3a <alltraps>

801069ef <vector242>:
.globl vector242
vector242:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $242
801069f1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801069f6:	e9 3f f1 ff ff       	jmp    80105b3a <alltraps>

801069fb <vector243>:
.globl vector243
vector243:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $243
801069fd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106a02:	e9 33 f1 ff ff       	jmp    80105b3a <alltraps>

80106a07 <vector244>:
.globl vector244
vector244:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $244
80106a09:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106a0e:	e9 27 f1 ff ff       	jmp    80105b3a <alltraps>

80106a13 <vector245>:
.globl vector245
vector245:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $245
80106a15:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106a1a:	e9 1b f1 ff ff       	jmp    80105b3a <alltraps>

80106a1f <vector246>:
.globl vector246
vector246:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $246
80106a21:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106a26:	e9 0f f1 ff ff       	jmp    80105b3a <alltraps>

80106a2b <vector247>:
.globl vector247
vector247:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $247
80106a2d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106a32:	e9 03 f1 ff ff       	jmp    80105b3a <alltraps>

80106a37 <vector248>:
.globl vector248
vector248:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $248
80106a39:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106a3e:	e9 f7 f0 ff ff       	jmp    80105b3a <alltraps>

80106a43 <vector249>:
.globl vector249
vector249:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $249
80106a45:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106a4a:	e9 eb f0 ff ff       	jmp    80105b3a <alltraps>

80106a4f <vector250>:
.globl vector250
vector250:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $250
80106a51:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106a56:	e9 df f0 ff ff       	jmp    80105b3a <alltraps>

80106a5b <vector251>:
.globl vector251
vector251:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $251
80106a5d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106a62:	e9 d3 f0 ff ff       	jmp    80105b3a <alltraps>

80106a67 <vector252>:
.globl vector252
vector252:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $252
80106a69:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106a6e:	e9 c7 f0 ff ff       	jmp    80105b3a <alltraps>

80106a73 <vector253>:
.globl vector253
vector253:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $253
80106a75:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106a7a:	e9 bb f0 ff ff       	jmp    80105b3a <alltraps>

80106a7f <vector254>:
.globl vector254
vector254:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $254
80106a81:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106a86:	e9 af f0 ff ff       	jmp    80105b3a <alltraps>

80106a8b <vector255>:
.globl vector255
vector255:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $255
80106a8d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106a92:	e9 a3 f0 ff ff       	jmp    80105b3a <alltraps>
80106a97:	66 90                	xchg   %ax,%ax
80106a99:	66 90                	xchg   %ax,%ax
80106a9b:	66 90                	xchg   %ax,%ax
80106a9d:	66 90                	xchg   %ax,%ax
80106a9f:	90                   	nop

80106aa0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106aa0:	55                   	push   %ebp
80106aa1:	89 e5                	mov    %esp,%ebp
80106aa3:	57                   	push   %edi
80106aa4:	56                   	push   %esi
80106aa5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106aa6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106aac:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ab2:	83 ec 1c             	sub    $0x1c,%esp
80106ab5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106ab8:	39 d3                	cmp    %edx,%ebx
80106aba:	73 49                	jae    80106b05 <deallocuvm.part.0+0x65>
80106abc:	89 c7                	mov    %eax,%edi
80106abe:	eb 0c                	jmp    80106acc <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106ac0:	83 c0 01             	add    $0x1,%eax
80106ac3:	c1 e0 16             	shl    $0x16,%eax
80106ac6:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106ac8:	39 da                	cmp    %ebx,%edx
80106aca:	76 39                	jbe    80106b05 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80106acc:	89 d8                	mov    %ebx,%eax
80106ace:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106ad1:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106ad4:	f6 c1 01             	test   $0x1,%cl
80106ad7:	74 e7                	je     80106ac0 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106ad9:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106adb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106ae1:	c1 ee 0a             	shr    $0xa,%esi
80106ae4:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106aea:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106af1:	85 f6                	test   %esi,%esi
80106af3:	74 cb                	je     80106ac0 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106af5:	8b 06                	mov    (%esi),%eax
80106af7:	a8 01                	test   $0x1,%al
80106af9:	75 15                	jne    80106b10 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106afb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b01:	39 da                	cmp    %ebx,%edx
80106b03:	77 c7                	ja     80106acc <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106b05:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106b08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b0b:	5b                   	pop    %ebx
80106b0c:	5e                   	pop    %esi
80106b0d:	5f                   	pop    %edi
80106b0e:	5d                   	pop    %ebp
80106b0f:	c3                   	ret    
      if(pa == 0)
80106b10:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b15:	74 25                	je     80106b3c <deallocuvm.part.0+0x9c>
      kfree(v);
80106b17:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106b1a:	05 00 00 00 80       	add    $0x80000000,%eax
80106b1f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106b22:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106b28:	50                   	push   %eax
80106b29:	e8 92 bc ff ff       	call   801027c0 <kfree>
      *pte = 0;
80106b2e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106b34:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106b37:	83 c4 10             	add    $0x10,%esp
80106b3a:	eb 8c                	jmp    80106ac8 <deallocuvm.part.0+0x28>
        panic("kfree");
80106b3c:	83 ec 0c             	sub    $0xc,%esp
80106b3f:	68 56 77 10 80       	push   $0x80107756
80106b44:	e8 37 98 ff ff       	call   80100380 <panic>
80106b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b50 <mappages>:
{
80106b50:	55                   	push   %ebp
80106b51:	89 e5                	mov    %esp,%ebp
80106b53:	57                   	push   %edi
80106b54:	56                   	push   %esi
80106b55:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106b56:	89 d3                	mov    %edx,%ebx
80106b58:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106b5e:	83 ec 1c             	sub    $0x1c,%esp
80106b61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106b64:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106b68:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b6d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106b70:	8b 45 08             	mov    0x8(%ebp),%eax
80106b73:	29 d8                	sub    %ebx,%eax
80106b75:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106b78:	eb 3d                	jmp    80106bb7 <mappages+0x67>
80106b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106b80:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106b82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106b87:	c1 ea 0a             	shr    $0xa,%edx
80106b8a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106b90:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106b97:	85 c0                	test   %eax,%eax
80106b99:	74 75                	je     80106c10 <mappages+0xc0>
    if(*pte & PTE_P)
80106b9b:	f6 00 01             	testb  $0x1,(%eax)
80106b9e:	0f 85 86 00 00 00    	jne    80106c2a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106ba4:	0b 75 0c             	or     0xc(%ebp),%esi
80106ba7:	83 ce 01             	or     $0x1,%esi
80106baa:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106bac:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106baf:	74 6f                	je     80106c20 <mappages+0xd0>
    a += PGSIZE;
80106bb1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106bb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106bba:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106bbd:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106bc0:	89 d8                	mov    %ebx,%eax
80106bc2:	c1 e8 16             	shr    $0x16,%eax
80106bc5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106bc8:	8b 07                	mov    (%edi),%eax
80106bca:	a8 01                	test   $0x1,%al
80106bcc:	75 b2                	jne    80106b80 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106bce:	e8 ad bd ff ff       	call   80102980 <kalloc>
80106bd3:	85 c0                	test   %eax,%eax
80106bd5:	74 39                	je     80106c10 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106bd7:	83 ec 04             	sub    $0x4,%esp
80106bda:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106bdd:	68 00 10 00 00       	push   $0x1000
80106be2:	6a 00                	push   $0x0
80106be4:	50                   	push   %eax
80106be5:	e8 76 dd ff ff       	call   80104960 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106bea:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106bed:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106bf0:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106bf6:	83 c8 07             	or     $0x7,%eax
80106bf9:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106bfb:	89 d8                	mov    %ebx,%eax
80106bfd:	c1 e8 0a             	shr    $0xa,%eax
80106c00:	25 fc 0f 00 00       	and    $0xffc,%eax
80106c05:	01 d0                	add    %edx,%eax
80106c07:	eb 92                	jmp    80106b9b <mappages+0x4b>
80106c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106c10:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106c13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c18:	5b                   	pop    %ebx
80106c19:	5e                   	pop    %esi
80106c1a:	5f                   	pop    %edi
80106c1b:	5d                   	pop    %ebp
80106c1c:	c3                   	ret    
80106c1d:	8d 76 00             	lea    0x0(%esi),%esi
80106c20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106c23:	31 c0                	xor    %eax,%eax
}
80106c25:	5b                   	pop    %ebx
80106c26:	5e                   	pop    %esi
80106c27:	5f                   	pop    %edi
80106c28:	5d                   	pop    %ebp
80106c29:	c3                   	ret    
      panic("remap");
80106c2a:	83 ec 0c             	sub    $0xc,%esp
80106c2d:	68 a8 7d 10 80       	push   $0x80107da8
80106c32:	e8 49 97 ff ff       	call   80100380 <panic>
80106c37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c3e:	66 90                	xchg   %ax,%ax

80106c40 <seginit>:
{
80106c40:	55                   	push   %ebp
80106c41:	89 e5                	mov    %esp,%ebp
80106c43:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106c46:	e8 05 d0 ff ff       	call   80103c50 <cpuid>
  pd[0] = size-1;
80106c4b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106c50:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106c56:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106c5a:	c7 80 b8 18 11 80 ff 	movl   $0xffff,-0x7feee748(%eax)
80106c61:	ff 00 00 
80106c64:	c7 80 bc 18 11 80 00 	movl   $0xcf9a00,-0x7feee744(%eax)
80106c6b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106c6e:	c7 80 c0 18 11 80 ff 	movl   $0xffff,-0x7feee740(%eax)
80106c75:	ff 00 00 
80106c78:	c7 80 c4 18 11 80 00 	movl   $0xcf9200,-0x7feee73c(%eax)
80106c7f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106c82:	c7 80 c8 18 11 80 ff 	movl   $0xffff,-0x7feee738(%eax)
80106c89:	ff 00 00 
80106c8c:	c7 80 cc 18 11 80 00 	movl   $0xcffa00,-0x7feee734(%eax)
80106c93:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106c96:	c7 80 d0 18 11 80 ff 	movl   $0xffff,-0x7feee730(%eax)
80106c9d:	ff 00 00 
80106ca0:	c7 80 d4 18 11 80 00 	movl   $0xcff200,-0x7feee72c(%eax)
80106ca7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106caa:	05 b0 18 11 80       	add    $0x801118b0,%eax
  pd[1] = (uint)p;
80106caf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106cb3:	c1 e8 10             	shr    $0x10,%eax
80106cb6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106cba:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106cbd:	0f 01 10             	lgdtl  (%eax)
}
80106cc0:	c9                   	leave  
80106cc1:	c3                   	ret    
80106cc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106cd0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106cd0:	a1 64 45 11 80       	mov    0x80114564,%eax
80106cd5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106cda:	0f 22 d8             	mov    %eax,%cr3
}
80106cdd:	c3                   	ret    
80106cde:	66 90                	xchg   %ax,%ax

80106ce0 <switchuvm>:
{
80106ce0:	55                   	push   %ebp
80106ce1:	89 e5                	mov    %esp,%ebp
80106ce3:	57                   	push   %edi
80106ce4:	56                   	push   %esi
80106ce5:	53                   	push   %ebx
80106ce6:	83 ec 1c             	sub    $0x1c,%esp
80106ce9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106cec:	85 f6                	test   %esi,%esi
80106cee:	0f 84 cb 00 00 00    	je     80106dbf <switchuvm+0xdf>
  if(p->kstack == 0)
80106cf4:	8b 46 08             	mov    0x8(%esi),%eax
80106cf7:	85 c0                	test   %eax,%eax
80106cf9:	0f 84 da 00 00 00    	je     80106dd9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106cff:	8b 46 04             	mov    0x4(%esi),%eax
80106d02:	85 c0                	test   %eax,%eax
80106d04:	0f 84 c2 00 00 00    	je     80106dcc <switchuvm+0xec>
  pushcli();
80106d0a:	e8 41 da ff ff       	call   80104750 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d0f:	e8 dc ce ff ff       	call   80103bf0 <mycpu>
80106d14:	89 c3                	mov    %eax,%ebx
80106d16:	e8 d5 ce ff ff       	call   80103bf0 <mycpu>
80106d1b:	89 c7                	mov    %eax,%edi
80106d1d:	e8 ce ce ff ff       	call   80103bf0 <mycpu>
80106d22:	83 c7 08             	add    $0x8,%edi
80106d25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d28:	e8 c3 ce ff ff       	call   80103bf0 <mycpu>
80106d2d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d30:	ba 67 00 00 00       	mov    $0x67,%edx
80106d35:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106d3c:	83 c0 08             	add    $0x8,%eax
80106d3f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d46:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d4b:	83 c1 08             	add    $0x8,%ecx
80106d4e:	c1 e8 18             	shr    $0x18,%eax
80106d51:	c1 e9 10             	shr    $0x10,%ecx
80106d54:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106d5a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106d60:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106d65:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d6c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106d71:	e8 7a ce ff ff       	call   80103bf0 <mycpu>
80106d76:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d7d:	e8 6e ce ff ff       	call   80103bf0 <mycpu>
80106d82:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106d86:	8b 5e 08             	mov    0x8(%esi),%ebx
80106d89:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d8f:	e8 5c ce ff ff       	call   80103bf0 <mycpu>
80106d94:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d97:	e8 54 ce ff ff       	call   80103bf0 <mycpu>
80106d9c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106da0:	b8 28 00 00 00       	mov    $0x28,%eax
80106da5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106da8:	8b 46 04             	mov    0x4(%esi),%eax
80106dab:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106db0:	0f 22 d8             	mov    %eax,%cr3
}
80106db3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106db6:	5b                   	pop    %ebx
80106db7:	5e                   	pop    %esi
80106db8:	5f                   	pop    %edi
80106db9:	5d                   	pop    %ebp
  popcli();
80106dba:	e9 e1 d9 ff ff       	jmp    801047a0 <popcli>
    panic("switchuvm: no process");
80106dbf:	83 ec 0c             	sub    $0xc,%esp
80106dc2:	68 ae 7d 10 80       	push   $0x80107dae
80106dc7:	e8 b4 95 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106dcc:	83 ec 0c             	sub    $0xc,%esp
80106dcf:	68 d9 7d 10 80       	push   $0x80107dd9
80106dd4:	e8 a7 95 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106dd9:	83 ec 0c             	sub    $0xc,%esp
80106ddc:	68 c4 7d 10 80       	push   $0x80107dc4
80106de1:	e8 9a 95 ff ff       	call   80100380 <panic>
80106de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ded:	8d 76 00             	lea    0x0(%esi),%esi

80106df0 <inituvm>:
{
80106df0:	55                   	push   %ebp
80106df1:	89 e5                	mov    %esp,%ebp
80106df3:	57                   	push   %edi
80106df4:	56                   	push   %esi
80106df5:	53                   	push   %ebx
80106df6:	83 ec 1c             	sub    $0x1c,%esp
80106df9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106dfc:	8b 75 10             	mov    0x10(%ebp),%esi
80106dff:	8b 7d 08             	mov    0x8(%ebp),%edi
80106e02:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106e05:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106e0b:	77 4b                	ja     80106e58 <inituvm+0x68>
  mem = kalloc();
80106e0d:	e8 6e bb ff ff       	call   80102980 <kalloc>
  memset(mem, 0, PGSIZE);
80106e12:	83 ec 04             	sub    $0x4,%esp
80106e15:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106e1a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106e1c:	6a 00                	push   $0x0
80106e1e:	50                   	push   %eax
80106e1f:	e8 3c db ff ff       	call   80104960 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106e24:	58                   	pop    %eax
80106e25:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e2b:	5a                   	pop    %edx
80106e2c:	6a 06                	push   $0x6
80106e2e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e33:	31 d2                	xor    %edx,%edx
80106e35:	50                   	push   %eax
80106e36:	89 f8                	mov    %edi,%eax
80106e38:	e8 13 fd ff ff       	call   80106b50 <mappages>
  memmove(mem, init, sz);
80106e3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e40:	89 75 10             	mov    %esi,0x10(%ebp)
80106e43:	83 c4 10             	add    $0x10,%esp
80106e46:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106e49:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106e4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e4f:	5b                   	pop    %ebx
80106e50:	5e                   	pop    %esi
80106e51:	5f                   	pop    %edi
80106e52:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106e53:	e9 a8 db ff ff       	jmp    80104a00 <memmove>
    panic("inituvm: more than a page");
80106e58:	83 ec 0c             	sub    $0xc,%esp
80106e5b:	68 ed 7d 10 80       	push   $0x80107ded
80106e60:	e8 1b 95 ff ff       	call   80100380 <panic>
80106e65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106e70 <loaduvm>:
{
80106e70:	55                   	push   %ebp
80106e71:	89 e5                	mov    %esp,%ebp
80106e73:	57                   	push   %edi
80106e74:	56                   	push   %esi
80106e75:	53                   	push   %ebx
80106e76:	83 ec 1c             	sub    $0x1c,%esp
80106e79:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e7c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106e7f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106e84:	0f 85 bb 00 00 00    	jne    80106f45 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80106e8a:	01 f0                	add    %esi,%eax
80106e8c:	89 f3                	mov    %esi,%ebx
80106e8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e91:	8b 45 14             	mov    0x14(%ebp),%eax
80106e94:	01 f0                	add    %esi,%eax
80106e96:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106e99:	85 f6                	test   %esi,%esi
80106e9b:	0f 84 87 00 00 00    	je     80106f28 <loaduvm+0xb8>
80106ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80106ea8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80106eab:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106eae:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80106eb0:	89 c2                	mov    %eax,%edx
80106eb2:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106eb5:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80106eb8:	f6 c2 01             	test   $0x1,%dl
80106ebb:	75 13                	jne    80106ed0 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80106ebd:	83 ec 0c             	sub    $0xc,%esp
80106ec0:	68 07 7e 10 80       	push   $0x80107e07
80106ec5:	e8 b6 94 ff ff       	call   80100380 <panic>
80106eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106ed0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ed3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106ed9:	25 fc 0f 00 00       	and    $0xffc,%eax
80106ede:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106ee5:	85 c0                	test   %eax,%eax
80106ee7:	74 d4                	je     80106ebd <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80106ee9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106eeb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106eee:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106ef3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106ef8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106efe:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f01:	29 d9                	sub    %ebx,%ecx
80106f03:	05 00 00 00 80       	add    $0x80000000,%eax
80106f08:	57                   	push   %edi
80106f09:	51                   	push   %ecx
80106f0a:	50                   	push   %eax
80106f0b:	ff 75 10             	push   0x10(%ebp)
80106f0e:	e8 7d ae ff ff       	call   80101d90 <readi>
80106f13:	83 c4 10             	add    $0x10,%esp
80106f16:	39 f8                	cmp    %edi,%eax
80106f18:	75 1e                	jne    80106f38 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106f1a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106f20:	89 f0                	mov    %esi,%eax
80106f22:	29 d8                	sub    %ebx,%eax
80106f24:	39 c6                	cmp    %eax,%esi
80106f26:	77 80                	ja     80106ea8 <loaduvm+0x38>
}
80106f28:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f2b:	31 c0                	xor    %eax,%eax
}
80106f2d:	5b                   	pop    %ebx
80106f2e:	5e                   	pop    %esi
80106f2f:	5f                   	pop    %edi
80106f30:	5d                   	pop    %ebp
80106f31:	c3                   	ret    
80106f32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f38:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f40:	5b                   	pop    %ebx
80106f41:	5e                   	pop    %esi
80106f42:	5f                   	pop    %edi
80106f43:	5d                   	pop    %ebp
80106f44:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80106f45:	83 ec 0c             	sub    $0xc,%esp
80106f48:	68 a8 7e 10 80       	push   $0x80107ea8
80106f4d:	e8 2e 94 ff ff       	call   80100380 <panic>
80106f52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106f60 <allocuvm>:
{
80106f60:	55                   	push   %ebp
80106f61:	89 e5                	mov    %esp,%ebp
80106f63:	57                   	push   %edi
80106f64:	56                   	push   %esi
80106f65:	53                   	push   %ebx
80106f66:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106f69:	8b 45 10             	mov    0x10(%ebp),%eax
{
80106f6c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106f6f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f72:	85 c0                	test   %eax,%eax
80106f74:	0f 88 b6 00 00 00    	js     80107030 <allocuvm+0xd0>
  if(newsz < oldsz)
80106f7a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106f80:	0f 82 9a 00 00 00    	jb     80107020 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106f86:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106f8c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106f92:	39 75 10             	cmp    %esi,0x10(%ebp)
80106f95:	77 44                	ja     80106fdb <allocuvm+0x7b>
80106f97:	e9 87 00 00 00       	jmp    80107023 <allocuvm+0xc3>
80106f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106fa0:	83 ec 04             	sub    $0x4,%esp
80106fa3:	68 00 10 00 00       	push   $0x1000
80106fa8:	6a 00                	push   $0x0
80106faa:	50                   	push   %eax
80106fab:	e8 b0 d9 ff ff       	call   80104960 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106fb0:	58                   	pop    %eax
80106fb1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106fb7:	5a                   	pop    %edx
80106fb8:	6a 06                	push   $0x6
80106fba:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106fbf:	89 f2                	mov    %esi,%edx
80106fc1:	50                   	push   %eax
80106fc2:	89 f8                	mov    %edi,%eax
80106fc4:	e8 87 fb ff ff       	call   80106b50 <mappages>
80106fc9:	83 c4 10             	add    $0x10,%esp
80106fcc:	85 c0                	test   %eax,%eax
80106fce:	78 78                	js     80107048 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80106fd0:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106fd6:	39 75 10             	cmp    %esi,0x10(%ebp)
80106fd9:	76 48                	jbe    80107023 <allocuvm+0xc3>
    mem = kalloc();
80106fdb:	e8 a0 b9 ff ff       	call   80102980 <kalloc>
80106fe0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106fe2:	85 c0                	test   %eax,%eax
80106fe4:	75 ba                	jne    80106fa0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106fe6:	83 ec 0c             	sub    $0xc,%esp
80106fe9:	68 25 7e 10 80       	push   $0x80107e25
80106fee:	e8 ad 96 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80106ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ff6:	83 c4 10             	add    $0x10,%esp
80106ff9:	39 45 10             	cmp    %eax,0x10(%ebp)
80106ffc:	74 32                	je     80107030 <allocuvm+0xd0>
80106ffe:	8b 55 10             	mov    0x10(%ebp),%edx
80107001:	89 c1                	mov    %eax,%ecx
80107003:	89 f8                	mov    %edi,%eax
80107005:	e8 96 fa ff ff       	call   80106aa0 <deallocuvm.part.0>
      return 0;
8010700a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107011:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107014:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107017:	5b                   	pop    %ebx
80107018:	5e                   	pop    %esi
80107019:	5f                   	pop    %edi
8010701a:	5d                   	pop    %ebp
8010701b:	c3                   	ret    
8010701c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107020:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107023:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107026:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107029:	5b                   	pop    %ebx
8010702a:	5e                   	pop    %esi
8010702b:	5f                   	pop    %edi
8010702c:	5d                   	pop    %ebp
8010702d:	c3                   	ret    
8010702e:	66 90                	xchg   %ax,%ax
    return 0;
80107030:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107037:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010703a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010703d:	5b                   	pop    %ebx
8010703e:	5e                   	pop    %esi
8010703f:	5f                   	pop    %edi
80107040:	5d                   	pop    %ebp
80107041:	c3                   	ret    
80107042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107048:	83 ec 0c             	sub    $0xc,%esp
8010704b:	68 3d 7e 10 80       	push   $0x80107e3d
80107050:	e8 4b 96 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107055:	8b 45 0c             	mov    0xc(%ebp),%eax
80107058:	83 c4 10             	add    $0x10,%esp
8010705b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010705e:	74 0c                	je     8010706c <allocuvm+0x10c>
80107060:	8b 55 10             	mov    0x10(%ebp),%edx
80107063:	89 c1                	mov    %eax,%ecx
80107065:	89 f8                	mov    %edi,%eax
80107067:	e8 34 fa ff ff       	call   80106aa0 <deallocuvm.part.0>
      kfree(mem);
8010706c:	83 ec 0c             	sub    $0xc,%esp
8010706f:	53                   	push   %ebx
80107070:	e8 4b b7 ff ff       	call   801027c0 <kfree>
      return 0;
80107075:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010707c:	83 c4 10             	add    $0x10,%esp
}
8010707f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107082:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107085:	5b                   	pop    %ebx
80107086:	5e                   	pop    %esi
80107087:	5f                   	pop    %edi
80107088:	5d                   	pop    %ebp
80107089:	c3                   	ret    
8010708a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107090 <deallocuvm>:
{
80107090:	55                   	push   %ebp
80107091:	89 e5                	mov    %esp,%ebp
80107093:	8b 55 0c             	mov    0xc(%ebp),%edx
80107096:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107099:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010709c:	39 d1                	cmp    %edx,%ecx
8010709e:	73 10                	jae    801070b0 <deallocuvm+0x20>
}
801070a0:	5d                   	pop    %ebp
801070a1:	e9 fa f9 ff ff       	jmp    80106aa0 <deallocuvm.part.0>
801070a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070ad:	8d 76 00             	lea    0x0(%esi),%esi
801070b0:	89 d0                	mov    %edx,%eax
801070b2:	5d                   	pop    %ebp
801070b3:	c3                   	ret    
801070b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801070bf:	90                   	nop

801070c0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801070c0:	55                   	push   %ebp
801070c1:	89 e5                	mov    %esp,%ebp
801070c3:	57                   	push   %edi
801070c4:	56                   	push   %esi
801070c5:	53                   	push   %ebx
801070c6:	83 ec 0c             	sub    $0xc,%esp
801070c9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801070cc:	85 f6                	test   %esi,%esi
801070ce:	74 59                	je     80107129 <freevm+0x69>
  if(newsz >= oldsz)
801070d0:	31 c9                	xor    %ecx,%ecx
801070d2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801070d7:	89 f0                	mov    %esi,%eax
801070d9:	89 f3                	mov    %esi,%ebx
801070db:	e8 c0 f9 ff ff       	call   80106aa0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801070e0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801070e6:	eb 0f                	jmp    801070f7 <freevm+0x37>
801070e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070ef:	90                   	nop
801070f0:	83 c3 04             	add    $0x4,%ebx
801070f3:	39 df                	cmp    %ebx,%edi
801070f5:	74 23                	je     8010711a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801070f7:	8b 03                	mov    (%ebx),%eax
801070f9:	a8 01                	test   $0x1,%al
801070fb:	74 f3                	je     801070f0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801070fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107102:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107105:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107108:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010710d:	50                   	push   %eax
8010710e:	e8 ad b6 ff ff       	call   801027c0 <kfree>
80107113:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107116:	39 df                	cmp    %ebx,%edi
80107118:	75 dd                	jne    801070f7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010711a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010711d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107120:	5b                   	pop    %ebx
80107121:	5e                   	pop    %esi
80107122:	5f                   	pop    %edi
80107123:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107124:	e9 97 b6 ff ff       	jmp    801027c0 <kfree>
    panic("freevm: no pgdir");
80107129:	83 ec 0c             	sub    $0xc,%esp
8010712c:	68 59 7e 10 80       	push   $0x80107e59
80107131:	e8 4a 92 ff ff       	call   80100380 <panic>
80107136:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010713d:	8d 76 00             	lea    0x0(%esi),%esi

80107140 <setupkvm>:
{
80107140:	55                   	push   %ebp
80107141:	89 e5                	mov    %esp,%ebp
80107143:	56                   	push   %esi
80107144:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107145:	e8 36 b8 ff ff       	call   80102980 <kalloc>
8010714a:	89 c6                	mov    %eax,%esi
8010714c:	85 c0                	test   %eax,%eax
8010714e:	74 42                	je     80107192 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107150:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107153:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80107158:	68 00 10 00 00       	push   $0x1000
8010715d:	6a 00                	push   $0x0
8010715f:	50                   	push   %eax
80107160:	e8 fb d7 ff ff       	call   80104960 <memset>
80107165:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107168:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010716b:	83 ec 08             	sub    $0x8,%esp
8010716e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107171:	ff 73 0c             	push   0xc(%ebx)
80107174:	8b 13                	mov    (%ebx),%edx
80107176:	50                   	push   %eax
80107177:	29 c1                	sub    %eax,%ecx
80107179:	89 f0                	mov    %esi,%eax
8010717b:	e8 d0 f9 ff ff       	call   80106b50 <mappages>
80107180:	83 c4 10             	add    $0x10,%esp
80107183:	85 c0                	test   %eax,%eax
80107185:	78 19                	js     801071a0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107187:	83 c3 10             	add    $0x10,%ebx
8010718a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107190:	75 d6                	jne    80107168 <setupkvm+0x28>
}
80107192:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107195:	89 f0                	mov    %esi,%eax
80107197:	5b                   	pop    %ebx
80107198:	5e                   	pop    %esi
80107199:	5d                   	pop    %ebp
8010719a:	c3                   	ret    
8010719b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010719f:	90                   	nop
      freevm(pgdir);
801071a0:	83 ec 0c             	sub    $0xc,%esp
801071a3:	56                   	push   %esi
      return 0;
801071a4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801071a6:	e8 15 ff ff ff       	call   801070c0 <freevm>
      return 0;
801071ab:	83 c4 10             	add    $0x10,%esp
}
801071ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801071b1:	89 f0                	mov    %esi,%eax
801071b3:	5b                   	pop    %ebx
801071b4:	5e                   	pop    %esi
801071b5:	5d                   	pop    %ebp
801071b6:	c3                   	ret    
801071b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071be:	66 90                	xchg   %ax,%ax

801071c0 <kvmalloc>:
{
801071c0:	55                   	push   %ebp
801071c1:	89 e5                	mov    %esp,%ebp
801071c3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801071c6:	e8 75 ff ff ff       	call   80107140 <setupkvm>
801071cb:	a3 64 45 11 80       	mov    %eax,0x80114564
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801071d0:	05 00 00 00 80       	add    $0x80000000,%eax
801071d5:	0f 22 d8             	mov    %eax,%cr3
}
801071d8:	c9                   	leave  
801071d9:	c3                   	ret    
801071da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801071e0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801071e0:	55                   	push   %ebp
801071e1:	89 e5                	mov    %esp,%ebp
801071e3:	83 ec 08             	sub    $0x8,%esp
801071e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801071e9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801071ec:	89 c1                	mov    %eax,%ecx
801071ee:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801071f1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801071f4:	f6 c2 01             	test   $0x1,%dl
801071f7:	75 17                	jne    80107210 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801071f9:	83 ec 0c             	sub    $0xc,%esp
801071fc:	68 6a 7e 10 80       	push   $0x80107e6a
80107201:	e8 7a 91 ff ff       	call   80100380 <panic>
80107206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010720d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107210:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107213:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107219:	25 fc 0f 00 00       	and    $0xffc,%eax
8010721e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107225:	85 c0                	test   %eax,%eax
80107227:	74 d0                	je     801071f9 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107229:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010722c:	c9                   	leave  
8010722d:	c3                   	ret    
8010722e:	66 90                	xchg   %ax,%ax

80107230 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107230:	55                   	push   %ebp
80107231:	89 e5                	mov    %esp,%ebp
80107233:	57                   	push   %edi
80107234:	56                   	push   %esi
80107235:	53                   	push   %ebx
80107236:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107239:	e8 02 ff ff ff       	call   80107140 <setupkvm>
8010723e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107241:	85 c0                	test   %eax,%eax
80107243:	0f 84 bd 00 00 00    	je     80107306 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107249:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010724c:	85 c9                	test   %ecx,%ecx
8010724e:	0f 84 b2 00 00 00    	je     80107306 <copyuvm+0xd6>
80107254:	31 f6                	xor    %esi,%esi
80107256:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010725d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107260:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107263:	89 f0                	mov    %esi,%eax
80107265:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107268:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010726b:	a8 01                	test   $0x1,%al
8010726d:	75 11                	jne    80107280 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010726f:	83 ec 0c             	sub    $0xc,%esp
80107272:	68 74 7e 10 80       	push   $0x80107e74
80107277:	e8 04 91 ff ff       	call   80100380 <panic>
8010727c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107280:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107282:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107287:	c1 ea 0a             	shr    $0xa,%edx
8010728a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107290:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107297:	85 c0                	test   %eax,%eax
80107299:	74 d4                	je     8010726f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010729b:	8b 00                	mov    (%eax),%eax
8010729d:	a8 01                	test   $0x1,%al
8010729f:	0f 84 9f 00 00 00    	je     80107344 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801072a5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801072a7:	25 ff 0f 00 00       	and    $0xfff,%eax
801072ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801072af:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801072b5:	e8 c6 b6 ff ff       	call   80102980 <kalloc>
801072ba:	89 c3                	mov    %eax,%ebx
801072bc:	85 c0                	test   %eax,%eax
801072be:	74 64                	je     80107324 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801072c0:	83 ec 04             	sub    $0x4,%esp
801072c3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801072c9:	68 00 10 00 00       	push   $0x1000
801072ce:	57                   	push   %edi
801072cf:	50                   	push   %eax
801072d0:	e8 2b d7 ff ff       	call   80104a00 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801072d5:	58                   	pop    %eax
801072d6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801072dc:	5a                   	pop    %edx
801072dd:	ff 75 e4             	push   -0x1c(%ebp)
801072e0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801072e5:	89 f2                	mov    %esi,%edx
801072e7:	50                   	push   %eax
801072e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801072eb:	e8 60 f8 ff ff       	call   80106b50 <mappages>
801072f0:	83 c4 10             	add    $0x10,%esp
801072f3:	85 c0                	test   %eax,%eax
801072f5:	78 21                	js     80107318 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801072f7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801072fd:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107300:	0f 87 5a ff ff ff    	ja     80107260 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107306:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107309:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010730c:	5b                   	pop    %ebx
8010730d:	5e                   	pop    %esi
8010730e:	5f                   	pop    %edi
8010730f:	5d                   	pop    %ebp
80107310:	c3                   	ret    
80107311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107318:	83 ec 0c             	sub    $0xc,%esp
8010731b:	53                   	push   %ebx
8010731c:	e8 9f b4 ff ff       	call   801027c0 <kfree>
      goto bad;
80107321:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107324:	83 ec 0c             	sub    $0xc,%esp
80107327:	ff 75 e0             	push   -0x20(%ebp)
8010732a:	e8 91 fd ff ff       	call   801070c0 <freevm>
  return 0;
8010732f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107336:	83 c4 10             	add    $0x10,%esp
}
80107339:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010733c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010733f:	5b                   	pop    %ebx
80107340:	5e                   	pop    %esi
80107341:	5f                   	pop    %edi
80107342:	5d                   	pop    %ebp
80107343:	c3                   	ret    
      panic("copyuvm: page not present");
80107344:	83 ec 0c             	sub    $0xc,%esp
80107347:	68 8e 7e 10 80       	push   $0x80107e8e
8010734c:	e8 2f 90 ff ff       	call   80100380 <panic>
80107351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107358:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010735f:	90                   	nop

80107360 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107360:	55                   	push   %ebp
80107361:	89 e5                	mov    %esp,%ebp
80107363:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107366:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107369:	89 c1                	mov    %eax,%ecx
8010736b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010736e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107371:	f6 c2 01             	test   $0x1,%dl
80107374:	0f 84 00 01 00 00    	je     8010747a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010737a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010737d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107383:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107384:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107389:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107390:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107392:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107397:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010739a:	05 00 00 00 80       	add    $0x80000000,%eax
8010739f:	83 fa 05             	cmp    $0x5,%edx
801073a2:	ba 00 00 00 00       	mov    $0x0,%edx
801073a7:	0f 45 c2             	cmovne %edx,%eax
}
801073aa:	c3                   	ret    
801073ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801073af:	90                   	nop

801073b0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801073b0:	55                   	push   %ebp
801073b1:	89 e5                	mov    %esp,%ebp
801073b3:	57                   	push   %edi
801073b4:	56                   	push   %esi
801073b5:	53                   	push   %ebx
801073b6:	83 ec 0c             	sub    $0xc,%esp
801073b9:	8b 75 14             	mov    0x14(%ebp),%esi
801073bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801073bf:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801073c2:	85 f6                	test   %esi,%esi
801073c4:	75 51                	jne    80107417 <copyout+0x67>
801073c6:	e9 a5 00 00 00       	jmp    80107470 <copyout+0xc0>
801073cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801073cf:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
801073d0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801073d6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801073dc:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801073e2:	74 75                	je     80107459 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
801073e4:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801073e6:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
801073e9:	29 c3                	sub    %eax,%ebx
801073eb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801073f1:	39 f3                	cmp    %esi,%ebx
801073f3:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
801073f6:	29 f8                	sub    %edi,%eax
801073f8:	83 ec 04             	sub    $0x4,%esp
801073fb:	01 c1                	add    %eax,%ecx
801073fd:	53                   	push   %ebx
801073fe:	52                   	push   %edx
801073ff:	51                   	push   %ecx
80107400:	e8 fb d5 ff ff       	call   80104a00 <memmove>
    len -= n;
    buf += n;
80107405:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107408:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010740e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107411:	01 da                	add    %ebx,%edx
  while(len > 0){
80107413:	29 de                	sub    %ebx,%esi
80107415:	74 59                	je     80107470 <copyout+0xc0>
  if(*pde & PTE_P){
80107417:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010741a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010741c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010741e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107421:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107427:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010742a:	f6 c1 01             	test   $0x1,%cl
8010742d:	0f 84 4e 00 00 00    	je     80107481 <copyout.cold>
  return &pgtab[PTX(va)];
80107433:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107435:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010743b:	c1 eb 0c             	shr    $0xc,%ebx
8010743e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107444:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010744b:	89 d9                	mov    %ebx,%ecx
8010744d:	83 e1 05             	and    $0x5,%ecx
80107450:	83 f9 05             	cmp    $0x5,%ecx
80107453:	0f 84 77 ff ff ff    	je     801073d0 <copyout+0x20>
  }
  return 0;
}
80107459:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010745c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107461:	5b                   	pop    %ebx
80107462:	5e                   	pop    %esi
80107463:	5f                   	pop    %edi
80107464:	5d                   	pop    %ebp
80107465:	c3                   	ret    
80107466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010746d:	8d 76 00             	lea    0x0(%esi),%esi
80107470:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107473:	31 c0                	xor    %eax,%eax
}
80107475:	5b                   	pop    %ebx
80107476:	5e                   	pop    %esi
80107477:	5f                   	pop    %edi
80107478:	5d                   	pop    %ebp
80107479:	c3                   	ret    

8010747a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010747a:	a1 00 00 00 00       	mov    0x0,%eax
8010747f:	0f 0b                	ud2    

80107481 <copyout.cold>:
80107481:	a1 00 00 00 00       	mov    0x0,%eax
80107486:	0f 0b                	ud2    
