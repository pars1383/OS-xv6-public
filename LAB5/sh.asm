
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  return 0;
}

int
main(void)
{
       0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
       4:	83 e4 f0             	and    $0xfffffff0,%esp
       7:	ff 71 fc             	push   -0x4(%ecx)
       a:	55                   	push   %ebp
       b:	89 e5                	mov    %esp,%ebp
       d:	51                   	push   %ecx
       e:	83 ec 04             	sub    $0x4,%esp
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
      11:	eb 0e                	jmp    21 <main+0x21>
      13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      17:	90                   	nop
    if(fd >= 3){
      18:	83 f8 02             	cmp    $0x2,%eax
      1b:	0f 8f f5 00 00 00    	jg     116 <main+0x116>
  while((fd = open("console", O_RDWR)) >= 0){
      21:	83 ec 08             	sub    $0x8,%esp
      24:	6a 02                	push   $0x2
      26:	68 6c 15 00 00       	push   $0x156c
      2b:	e8 53 10 00 00       	call   1083 <open>
      30:	83 c4 10             	add    $0x10,%esp
      33:	85 c0                	test   %eax,%eax
      35:	79 e1                	jns    18 <main+0x18>
      37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      3e:	66 90                	xchg   %ax,%ax
  printf(2, "$ ");
      40:	83 ec 08             	sub    $0x8,%esp
      43:	68 cb 14 00 00       	push   $0x14cb
      48:	6a 02                	push   $0x2
      4a:	e8 51 11 00 00       	call   11a0 <printf>
  memset(buf, 0, nbuf);
      4f:	83 c4 0c             	add    $0xc,%esp
      52:	6a 64                	push   $0x64
      54:	6a 00                	push   $0x0
      56:	68 a0 1c 00 00       	push   $0x1ca0
      5b:	e8 50 0e 00 00       	call   eb0 <memset>
  gets(buf, nbuf);
      60:	58                   	pop    %eax
      61:	5a                   	pop    %edx
      62:	6a 64                	push   $0x64
      64:	68 a0 1c 00 00       	push   $0x1ca0
      69:	e8 a2 0e 00 00       	call   f10 <gets>
  if(buf[0] == 0) // EOF
      6e:	0f b6 05 a0 1c 00 00 	movzbl 0x1ca0,%eax
      75:	83 c4 10             	add    $0x10,%esp
      78:	84 c0                	test   %al,%al
      7a:	0f 84 bc 00 00 00    	je     13c <main+0x13c>
    }
  }

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == '!') {
      80:	3c 21                	cmp    $0x21,%al
      82:	74 2c                	je     b0 <main+0xb0>
      // Process the line and highlight keywords
      highlight_keywords(buf + 1); // Skip the '!'
    } else if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      84:	3c 63                	cmp    $0x63,%al
      86:	75 09                	jne    91 <main+0x91>
      88:	80 3d a1 1c 00 00 64 	cmpb   $0x64,0x1ca1
      8f:	74 37                	je     c8 <main+0xc8>
int
fork1(void)
{
  int pid;

  pid = fork();
      91:	e8 a5 0f 00 00       	call   103b <fork>
  if(pid == -1)
      96:	83 f8 ff             	cmp    $0xffffffff,%eax
      99:	0f 84 a2 00 00 00    	je     141 <main+0x141>
      if(fork1() == 0)
      9f:	85 c0                	test   %eax,%eax
      a1:	0f 84 80 00 00 00    	je     127 <main+0x127>
      wait();
      a7:	e8 9f 0f 00 00       	call   104b <wait>
      ac:	eb 92                	jmp    40 <main+0x40>
      ae:	66 90                	xchg   %ax,%ax
      highlight_keywords(buf + 1); // Skip the '!'
      b0:	83 ec 0c             	sub    $0xc,%esp
      b3:	68 a1 1c 00 00       	push   $0x1ca1
      b8:	e8 e3 00 00 00       	call   1a0 <highlight_keywords>
      bd:	83 c4 10             	add    $0x10,%esp
      c0:	e9 7b ff ff ff       	jmp    40 <main+0x40>
      c5:	8d 76 00             	lea    0x0(%esi),%esi
    } else if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      c8:	80 3d a2 1c 00 00 20 	cmpb   $0x20,0x1ca2
      cf:	75 c0                	jne    91 <main+0x91>
      buf[strlen(buf)-1] = 0;  // chop \n
      d1:	83 ec 0c             	sub    $0xc,%esp
      d4:	68 a0 1c 00 00       	push   $0x1ca0
      d9:	e8 a2 0d 00 00       	call   e80 <strlen>
      if(chdir(buf+3) < 0)
      de:	c7 04 24 a3 1c 00 00 	movl   $0x1ca3,(%esp)
      buf[strlen(buf)-1] = 0;  // chop \n
      e5:	c6 80 9f 1c 00 00 00 	movb   $0x0,0x1c9f(%eax)
      if(chdir(buf+3) < 0)
      ec:	e8 c2 0f 00 00       	call   10b3 <chdir>
      f1:	83 c4 10             	add    $0x10,%esp
      f4:	85 c0                	test   %eax,%eax
      f6:	0f 89 44 ff ff ff    	jns    40 <main+0x40>
        printf(2, "cannot cd %s\n", buf+3);
      fc:	51                   	push   %ecx
      fd:	68 a3 1c 00 00       	push   $0x1ca3
     102:	68 74 15 00 00       	push   $0x1574
     107:	6a 02                	push   $0x2
     109:	e8 92 10 00 00       	call   11a0 <printf>
     10e:	83 c4 10             	add    $0x10,%esp
     111:	e9 2a ff ff ff       	jmp    40 <main+0x40>
      close(fd);
     116:	83 ec 0c             	sub    $0xc,%esp
     119:	50                   	push   %eax
     11a:	e8 4c 0f 00 00       	call   106b <close>
      break;
     11f:	83 c4 10             	add    $0x10,%esp
     122:	e9 19 ff ff ff       	jmp    40 <main+0x40>
        runcmd(parsecmd(buf));
     127:	83 ec 0c             	sub    $0xc,%esp
     12a:	68 a0 1c 00 00       	push   $0x1ca0
     12f:	e8 4c 0c 00 00       	call   d80 <parsecmd>
     134:	89 04 24             	mov    %eax,(%esp)
     137:	e8 94 02 00 00       	call   3d0 <runcmd>
  exit();
     13c:	e8 02 0f 00 00       	call   1043 <exit>
    panic("fork");
     141:	83 ec 0c             	sub    $0xc,%esp
     144:	68 ce 14 00 00       	push   $0x14ce
     149:	e8 42 02 00 00       	call   390 <panic>
     14e:	66 90                	xchg   %ax,%ax

00000150 <is_keyword>:
int is_keyword(char *word) {
     150:	55                   	push   %ebp
     151:	89 e5                	mov    %esp,%ebp
     153:	56                   	push   %esi
     154:	8b 75 08             	mov    0x8(%ebp),%esi
     157:	53                   	push   %ebx
  for (int i = 0; i < num_keywords; i++) {
     158:	31 db                	xor    %ebx,%ebx
     15a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (strcmp(word, keywords[i]) == 0) {
     160:	83 ec 08             	sub    $0x8,%esp
     163:	ff 34 9d 7c 1c 00 00 	push   0x1c7c(,%ebx,4)
     16a:	56                   	push   %esi
     16b:	e8 b0 0c 00 00       	call   e20 <strcmp>
     170:	83 c4 10             	add    $0x10,%esp
     173:	85 c0                	test   %eax,%eax
     175:	74 19                	je     190 <is_keyword+0x40>
  for (int i = 0; i < num_keywords; i++) {
     177:	83 c3 01             	add    $0x1,%ebx
     17a:	83 fb 07             	cmp    $0x7,%ebx
     17d:	75 e1                	jne    160 <is_keyword+0x10>
}
     17f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  return 0;
     182:	31 c0                	xor    %eax,%eax
}
     184:	5b                   	pop    %ebx
     185:	5e                   	pop    %esi
     186:	5d                   	pop    %ebp
     187:	c3                   	ret    
     188:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     18f:	90                   	nop
     190:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return 1;
     193:	b8 01 00 00 00       	mov    $0x1,%eax
}
     198:	5b                   	pop    %ebx
     199:	5e                   	pop    %esi
     19a:	5d                   	pop    %ebp
     19b:	c3                   	ret    
     19c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000001a0 <highlight_keywords>:
void highlight_keywords(char *line) {
     1a0:	55                   	push   %ebp
     1a1:	89 e5                	mov    %esp,%ebp
     1a3:	57                   	push   %edi
     1a4:	56                   	push   %esi
     1a5:	53                   	push   %ebx
     1a6:	81 ec 5c 02 00 00    	sub    $0x25c,%esp
     1ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  for (int i = 0; line[i] != '\0'; i++) {
     1af:	0f b6 03             	movzbl (%ebx),%eax
     1b2:	84 c0                	test   %al,%al
     1b4:	0f 84 7e 01 00 00    	je     338 <highlight_keywords+0x198>
  int buffer_index = 0;
     1ba:	c7 85 a4 fd ff ff 00 	movl   $0x0,-0x25c(%ebp)
     1c1:	00 00 00 
  int skip = 0;     // Flag to skip text between # symbols
     1c4:	31 f6                	xor    %esi,%esi
  int word_index = 0;
     1c6:	31 d2                	xor    %edx,%edx
     1c8:	89 df                	mov    %ebx,%edi
     1ca:	eb 25                	jmp    1f1 <highlight_keywords+0x51>
     1cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (skip) {
     1d0:	85 f6                	test   %esi,%esi
     1d2:	75 12                	jne    1e6 <highlight_keywords+0x46>
    if (line[i] == ' ' || line[i] == '\n' || line[i] == '\0') {
     1d4:	3c 20                	cmp    $0x20,%al
     1d6:	74 58                	je     230 <highlight_keywords+0x90>
     1d8:	3c 0a                	cmp    $0xa,%al
     1da:	74 54                	je     230 <highlight_keywords+0x90>
      word[word_index++] = line[i]; // Build the word
     1dc:	88 84 15 a8 fd ff ff 	mov    %al,-0x258(%ebp,%edx,1)
     1e3:	83 c2 01             	add    $0x1,%edx
  for (int i = 0; line[i] != '\0'; i++) {
     1e6:	0f b6 47 01          	movzbl 0x1(%edi),%eax
     1ea:	83 c7 01             	add    $0x1,%edi
     1ed:	84 c0                	test   %al,%al
     1ef:	74 12                	je     203 <highlight_keywords+0x63>
    if (line[i] == '#') {
     1f1:	3c 23                	cmp    $0x23,%al
     1f3:	75 db                	jne    1d0 <highlight_keywords+0x30>
  for (int i = 0; line[i] != '\0'; i++) {
     1f5:	0f b6 47 01          	movzbl 0x1(%edi),%eax
     1f9:	83 c7 01             	add    $0x1,%edi
     1fc:	83 f6 01             	xor    $0x1,%esi
     1ff:	84 c0                	test   %al,%al
     201:	75 ee                	jne    1f1 <highlight_keywords+0x51>
  buffer[buffer_index] = '\0'; // Null-terminate the buffer
     203:	8b 85 a4 fd ff ff    	mov    -0x25c(%ebp),%eax
  printf(1, "%s", buffer);     // Print the modified line
     209:	83 ec 04             	sub    $0x4,%esp
  buffer[buffer_index] = '\0'; // Null-terminate the buffer
     20c:	c6 84 05 e8 fd ff ff 	movb   $0x0,-0x218(%ebp,%eax,1)
     213:	00 
  printf(1, "%s", buffer);     // Print the modified line
     214:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
     21a:	50                   	push   %eax
     21b:	68 c8 14 00 00       	push   $0x14c8
     220:	6a 01                	push   $0x1
     222:	e8 79 0f 00 00       	call   11a0 <printf>
}
     227:	8d 65 f4             	lea    -0xc(%ebp),%esp
     22a:	5b                   	pop    %ebx
     22b:	5e                   	pop    %esi
     22c:	5f                   	pop    %edi
     22d:	5d                   	pop    %ebp
     22e:	c3                   	ret    
     22f:	90                   	nop
      word[word_index] = '\0'; // End of word
     230:	c6 84 15 a8 fd ff ff 	movb   $0x0,-0x258(%ebp,%edx,1)
     237:	00 
  for (int i = 0; i < num_keywords; i++) {
     238:	31 db                	xor    %ebx,%ebx
     23a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (strcmp(word, keywords[i]) == 0) {
     240:	83 ec 08             	sub    $0x8,%esp
     243:	8d 85 a8 fd ff ff    	lea    -0x258(%ebp),%eax
     249:	ff 34 9d 7c 1c 00 00 	push   0x1c7c(,%ebx,4)
     250:	50                   	push   %eax
     251:	e8 ca 0b 00 00       	call   e20 <strcmp>
     256:	83 c4 10             	add    $0x10,%esp
     259:	85 c0                	test   %eax,%eax
     25b:	74 53                	je     2b0 <highlight_keywords+0x110>
  for (int i = 0; i < num_keywords; i++) {
     25d:	83 c3 01             	add    $0x1,%ebx
     260:	83 fb 07             	cmp    $0x7,%ebx
     263:	75 db                	jne    240 <highlight_keywords+0xa0>
        for (int j = 0; word[j] != '\0'; j++) {
     265:	8b 85 a4 fd ff ff    	mov    -0x25c(%ebp),%eax
     26b:	0f b6 95 a8 fd ff ff 	movzbl -0x258(%ebp),%edx
     272:	8d 9d a8 fd ff ff    	lea    -0x258(%ebp),%ebx
     278:	29 c3                	sub    %eax,%ebx
     27a:	84 d2                	test   %dl,%dl
     27c:	74 14                	je     292 <highlight_keywords+0xf2>
     27e:	66 90                	xchg   %ax,%ax
          buffer[buffer_index++] = word[j];
     280:	83 c0 01             	add    $0x1,%eax
     283:	88 94 05 e7 fd ff ff 	mov    %dl,-0x219(%ebp,%eax,1)
        for (int j = 0; word[j] != '\0'; j++) {
     28a:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
     28e:	84 d2                	test   %dl,%dl
     290:	75 ee                	jne    280 <highlight_keywords+0xe0>
      buffer[buffer_index++] = line[i]; // Copy the space or newline
     292:	0f b6 17             	movzbl (%edi),%edx
     295:	8d 48 01             	lea    0x1(%eax),%ecx
     298:	89 8d a4 fd ff ff    	mov    %ecx,-0x25c(%ebp)
     29e:	88 94 05 e8 fd ff ff 	mov    %dl,-0x218(%ebp,%eax,1)
      word_index = 0; // Reset word index
     2a5:	31 d2                	xor    %edx,%edx
     2a7:	e9 3a ff ff ff       	jmp    1e6 <highlight_keywords+0x46>
     2ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        buffer[buffer_index++] = '\033'; // ANSI escape code
     2b0:	8b 8d a4 fd ff ff    	mov    -0x25c(%ebp),%ecx
        for (int j = 0; word[j] != '\0'; j++) {
     2b6:	0f b6 85 a8 fd ff ff 	movzbl -0x258(%ebp),%eax
     2bd:	8d 9d a8 fd ff ff    	lea    -0x258(%ebp),%ebx
        buffer[buffer_index++] = '\033'; // ANSI escape code
     2c3:	c6 84 0d e8 fd ff ff 	movb   $0x1b,-0x218(%ebp,%ecx,1)
     2ca:	1b 
        buffer[buffer_index++] = 'm';    // ANSI escape code
     2cb:	8d 51 05             	lea    0x5(%ecx),%edx
        for (int j = 0; word[j] != '\0'; j++) {
     2ce:	29 cb                	sub    %ecx,%ebx
        buffer[buffer_index++] = '[';    // ANSI escape code
     2d0:	c6 84 0d e9 fd ff ff 	movb   $0x5b,-0x217(%ebp,%ecx,1)
     2d7:	5b 
        buffer[buffer_index++] = '3';    // ANSI color code for text
     2d8:	c6 84 0d ea fd ff ff 	movb   $0x33,-0x216(%ebp,%ecx,1)
     2df:	33 
        buffer[buffer_index++] = '4';    // ANSI color code for blue
     2e0:	c6 84 0d eb fd ff ff 	movb   $0x34,-0x215(%ebp,%ecx,1)
     2e7:	34 
        buffer[buffer_index++] = 'm';    // ANSI escape code
     2e8:	c6 84 0d ec fd ff ff 	movb   $0x6d,-0x214(%ebp,%ecx,1)
     2ef:	6d 
        for (int j = 0; word[j] != '\0'; j++) {
     2f0:	84 c0                	test   %al,%al
     2f2:	74 17                	je     30b <highlight_keywords+0x16b>
     2f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          buffer[buffer_index++] = word[j];
     2f8:	83 c2 01             	add    $0x1,%edx
     2fb:	88 84 15 e7 fd ff ff 	mov    %al,-0x219(%ebp,%edx,1)
        for (int j = 0; word[j] != '\0'; j++) {
     302:	0f b6 44 13 fb       	movzbl -0x5(%ebx,%edx,1),%eax
     307:	84 c0                	test   %al,%al
     309:	75 ed                	jne    2f8 <highlight_keywords+0x158>
        buffer[buffer_index++] = '\033'; // ANSI escape code
     30b:	c6 84 15 e8 fd ff ff 	movb   $0x1b,-0x218(%ebp,%edx,1)
     312:	1b 
        buffer[buffer_index++] = 'm';    // ANSI escape code
     313:	8d 42 04             	lea    0x4(%edx),%eax
        buffer[buffer_index++] = '[';    // ANSI escape code
     316:	c6 84 15 e9 fd ff ff 	movb   $0x5b,-0x217(%ebp,%edx,1)
     31d:	5b 
        buffer[buffer_index++] = '0';    // ANSI reset code
     31e:	c6 84 15 ea fd ff ff 	movb   $0x30,-0x216(%ebp,%edx,1)
     325:	30 
        buffer[buffer_index++] = 'm';    // ANSI escape code
     326:	c6 84 15 eb fd ff ff 	movb   $0x6d,-0x215(%ebp,%edx,1)
     32d:	6d 
     32e:	e9 5f ff ff ff       	jmp    292 <highlight_keywords+0xf2>
     333:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     337:	90                   	nop
  int buffer_index = 0;
     338:	c7 85 a4 fd ff ff 00 	movl   $0x0,-0x25c(%ebp)
     33f:	00 00 00 
     342:	e9 bc fe ff ff       	jmp    203 <highlight_keywords+0x63>
     347:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     34e:	66 90                	xchg   %ax,%ax

00000350 <getcmd>:
{
     350:	55                   	push   %ebp
     351:	89 e5                	mov    %esp,%ebp
     353:	56                   	push   %esi
     354:	53                   	push   %ebx
     355:	8b 75 0c             	mov    0xc(%ebp),%esi
     358:	8b 5d 08             	mov    0x8(%ebp),%ebx
  printf(2, "$ ");
     35b:	83 ec 08             	sub    $0x8,%esp
     35e:	68 cb 14 00 00       	push   $0x14cb
     363:	6a 02                	push   $0x2
     365:	e8 36 0e 00 00       	call   11a0 <printf>
  memset(buf, 0, nbuf);
     36a:	83 c4 0c             	add    $0xc,%esp
     36d:	56                   	push   %esi
     36e:	6a 00                	push   $0x0
     370:	53                   	push   %ebx
     371:	e8 3a 0b 00 00       	call   eb0 <memset>
  gets(buf, nbuf);
     376:	58                   	pop    %eax
     377:	5a                   	pop    %edx
     378:	56                   	push   %esi
     379:	53                   	push   %ebx
     37a:	e8 91 0b 00 00       	call   f10 <gets>
  if(buf[0] == 0) // EOF
     37f:	83 c4 10             	add    $0x10,%esp
     382:	80 3b 01             	cmpb   $0x1,(%ebx)
     385:	19 c0                	sbb    %eax,%eax
}
     387:	8d 65 f8             	lea    -0x8(%ebp),%esp
     38a:	5b                   	pop    %ebx
     38b:	5e                   	pop    %esi
     38c:	5d                   	pop    %ebp
     38d:	c3                   	ret    
     38e:	66 90                	xchg   %ax,%ax

00000390 <panic>:
{
     390:	55                   	push   %ebp
     391:	89 e5                	mov    %esp,%ebp
     393:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
     396:	ff 75 08             	push   0x8(%ebp)
     399:	68 68 15 00 00       	push   $0x1568
     39e:	6a 02                	push   $0x2
     3a0:	e8 fb 0d 00 00       	call   11a0 <printf>
  exit();
     3a5:	e8 99 0c 00 00       	call   1043 <exit>
     3aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000003b0 <fork1>:
{
     3b0:	55                   	push   %ebp
     3b1:	89 e5                	mov    %esp,%ebp
     3b3:	83 ec 08             	sub    $0x8,%esp
  pid = fork();
     3b6:	e8 80 0c 00 00       	call   103b <fork>
  if(pid == -1)
     3bb:	83 f8 ff             	cmp    $0xffffffff,%eax
     3be:	74 02                	je     3c2 <fork1+0x12>
  return pid;
}
     3c0:	c9                   	leave  
     3c1:	c3                   	ret    
    panic("fork");
     3c2:	83 ec 0c             	sub    $0xc,%esp
     3c5:	68 ce 14 00 00       	push   $0x14ce
     3ca:	e8 c1 ff ff ff       	call   390 <panic>
     3cf:	90                   	nop

000003d0 <runcmd>:
{
     3d0:	55                   	push   %ebp
     3d1:	89 e5                	mov    %esp,%ebp
     3d3:	53                   	push   %ebx
     3d4:	83 ec 14             	sub    $0x14,%esp
     3d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(cmd == 0)
     3da:	85 db                	test   %ebx,%ebx
     3dc:	74 42                	je     420 <runcmd+0x50>
  switch(cmd->type){
     3de:	83 3b 05             	cmpl   $0x5,(%ebx)
     3e1:	0f 87 e3 00 00 00    	ja     4ca <runcmd+0xfa>
     3e7:	8b 03                	mov    (%ebx),%eax
     3e9:	ff 24 85 a4 15 00 00 	jmp    *0x15a4(,%eax,4)
    if(ecmd->argv[0] == 0)
     3f0:	8b 43 04             	mov    0x4(%ebx),%eax
     3f3:	85 c0                	test   %eax,%eax
     3f5:	74 29                	je     420 <runcmd+0x50>
    exec(ecmd->argv[0], ecmd->argv);
     3f7:	8d 53 04             	lea    0x4(%ebx),%edx
     3fa:	51                   	push   %ecx
     3fb:	51                   	push   %ecx
     3fc:	52                   	push   %edx
     3fd:	50                   	push   %eax
     3fe:	e8 78 0c 00 00       	call   107b <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
     403:	83 c4 0c             	add    $0xc,%esp
     406:	ff 73 04             	push   0x4(%ebx)
     409:	68 da 14 00 00       	push   $0x14da
     40e:	6a 02                	push   $0x2
     410:	e8 8b 0d 00 00       	call   11a0 <printf>
    break;
     415:	83 c4 10             	add    $0x10,%esp
     418:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     41f:	90                   	nop
    exit();
     420:	e8 1e 0c 00 00       	call   1043 <exit>
    if(fork1() == 0)
     425:	e8 86 ff ff ff       	call   3b0 <fork1>
     42a:	85 c0                	test   %eax,%eax
     42c:	75 f2                	jne    420 <runcmd+0x50>
     42e:	e9 8c 00 00 00       	jmp    4bf <runcmd+0xef>
    if(pipe(p) < 0)
     433:	83 ec 0c             	sub    $0xc,%esp
     436:	8d 45 f0             	lea    -0x10(%ebp),%eax
     439:	50                   	push   %eax
     43a:	e8 14 0c 00 00       	call   1053 <pipe>
     43f:	83 c4 10             	add    $0x10,%esp
     442:	85 c0                	test   %eax,%eax
     444:	0f 88 a2 00 00 00    	js     4ec <runcmd+0x11c>
    if(fork1() == 0){
     44a:	e8 61 ff ff ff       	call   3b0 <fork1>
     44f:	85 c0                	test   %eax,%eax
     451:	0f 84 a2 00 00 00    	je     4f9 <runcmd+0x129>
    if(fork1() == 0){
     457:	e8 54 ff ff ff       	call   3b0 <fork1>
     45c:	85 c0                	test   %eax,%eax
     45e:	0f 84 c3 00 00 00    	je     527 <runcmd+0x157>
    close(p[0]);
     464:	83 ec 0c             	sub    $0xc,%esp
     467:	ff 75 f0             	push   -0x10(%ebp)
     46a:	e8 fc 0b 00 00       	call   106b <close>
    close(p[1]);
     46f:	58                   	pop    %eax
     470:	ff 75 f4             	push   -0xc(%ebp)
     473:	e8 f3 0b 00 00       	call   106b <close>
    wait();
     478:	e8 ce 0b 00 00       	call   104b <wait>
    wait();
     47d:	e8 c9 0b 00 00       	call   104b <wait>
    break;
     482:	83 c4 10             	add    $0x10,%esp
     485:	eb 99                	jmp    420 <runcmd+0x50>
    if(fork1() == 0)
     487:	e8 24 ff ff ff       	call   3b0 <fork1>
     48c:	85 c0                	test   %eax,%eax
     48e:	74 2f                	je     4bf <runcmd+0xef>
    wait();
     490:	e8 b6 0b 00 00       	call   104b <wait>
    runcmd(lcmd->right);
     495:	83 ec 0c             	sub    $0xc,%esp
     498:	ff 73 08             	push   0x8(%ebx)
     49b:	e8 30 ff ff ff       	call   3d0 <runcmd>
    close(rcmd->fd);
     4a0:	83 ec 0c             	sub    $0xc,%esp
     4a3:	ff 73 14             	push   0x14(%ebx)
     4a6:	e8 c0 0b 00 00       	call   106b <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     4ab:	58                   	pop    %eax
     4ac:	5a                   	pop    %edx
     4ad:	ff 73 10             	push   0x10(%ebx)
     4b0:	ff 73 08             	push   0x8(%ebx)
     4b3:	e8 cb 0b 00 00       	call   1083 <open>
     4b8:	83 c4 10             	add    $0x10,%esp
     4bb:	85 c0                	test   %eax,%eax
     4bd:	78 18                	js     4d7 <runcmd+0x107>
      runcmd(bcmd->cmd);
     4bf:	83 ec 0c             	sub    $0xc,%esp
     4c2:	ff 73 04             	push   0x4(%ebx)
     4c5:	e8 06 ff ff ff       	call   3d0 <runcmd>
    panic("runcmd");
     4ca:	83 ec 0c             	sub    $0xc,%esp
     4cd:	68 d3 14 00 00       	push   $0x14d3
     4d2:	e8 b9 fe ff ff       	call   390 <panic>
      printf(2, "open %s failed\n", rcmd->file);
     4d7:	51                   	push   %ecx
     4d8:	ff 73 08             	push   0x8(%ebx)
     4db:	68 ea 14 00 00       	push   $0x14ea
     4e0:	6a 02                	push   $0x2
     4e2:	e8 b9 0c 00 00       	call   11a0 <printf>
      exit();
     4e7:	e8 57 0b 00 00       	call   1043 <exit>
      panic("pipe");
     4ec:	83 ec 0c             	sub    $0xc,%esp
     4ef:	68 fa 14 00 00       	push   $0x14fa
     4f4:	e8 97 fe ff ff       	call   390 <panic>
      close(1);
     4f9:	83 ec 0c             	sub    $0xc,%esp
     4fc:	6a 01                	push   $0x1
     4fe:	e8 68 0b 00 00       	call   106b <close>
      dup(p[1]);
     503:	58                   	pop    %eax
     504:	ff 75 f4             	push   -0xc(%ebp)
     507:	e8 af 0b 00 00       	call   10bb <dup>
      close(p[0]);
     50c:	58                   	pop    %eax
     50d:	ff 75 f0             	push   -0x10(%ebp)
     510:	e8 56 0b 00 00       	call   106b <close>
      close(p[1]);
     515:	58                   	pop    %eax
     516:	ff 75 f4             	push   -0xc(%ebp)
     519:	e8 4d 0b 00 00       	call   106b <close>
      runcmd(pcmd->left);
     51e:	5a                   	pop    %edx
     51f:	ff 73 04             	push   0x4(%ebx)
     522:	e8 a9 fe ff ff       	call   3d0 <runcmd>
      close(0);
     527:	83 ec 0c             	sub    $0xc,%esp
     52a:	6a 00                	push   $0x0
     52c:	e8 3a 0b 00 00       	call   106b <close>
      dup(p[0]);
     531:	5a                   	pop    %edx
     532:	ff 75 f0             	push   -0x10(%ebp)
     535:	e8 81 0b 00 00       	call   10bb <dup>
      close(p[0]);
     53a:	59                   	pop    %ecx
     53b:	ff 75 f0             	push   -0x10(%ebp)
     53e:	e8 28 0b 00 00       	call   106b <close>
      close(p[1]);
     543:	58                   	pop    %eax
     544:	ff 75 f4             	push   -0xc(%ebp)
     547:	e8 1f 0b 00 00       	call   106b <close>
      runcmd(pcmd->right);
     54c:	58                   	pop    %eax
     54d:	ff 73 08             	push   0x8(%ebx)
     550:	e8 7b fe ff ff       	call   3d0 <runcmd>
     555:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     55c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000560 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     560:	55                   	push   %ebp
     561:	89 e5                	mov    %esp,%ebp
     563:	53                   	push   %ebx
     564:	83 ec 10             	sub    $0x10,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     567:	6a 54                	push   $0x54
     569:	e8 62 0e 00 00       	call   13d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     56e:	83 c4 0c             	add    $0xc,%esp
     571:	6a 54                	push   $0x54
  cmd = malloc(sizeof(*cmd));
     573:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     575:	6a 00                	push   $0x0
     577:	50                   	push   %eax
     578:	e8 33 09 00 00       	call   eb0 <memset>
  cmd->type = EXEC;
     57d:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
     583:	89 d8                	mov    %ebx,%eax
     585:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     588:	c9                   	leave  
     589:	c3                   	ret    
     58a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000590 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     590:	55                   	push   %ebp
     591:	89 e5                	mov    %esp,%ebp
     593:	53                   	push   %ebx
     594:	83 ec 10             	sub    $0x10,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     597:	6a 18                	push   $0x18
     599:	e8 32 0e 00 00       	call   13d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     59e:	83 c4 0c             	add    $0xc,%esp
     5a1:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     5a3:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     5a5:	6a 00                	push   $0x0
     5a7:	50                   	push   %eax
     5a8:	e8 03 09 00 00       	call   eb0 <memset>
  cmd->type = REDIR;
  cmd->cmd = subcmd;
     5ad:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = REDIR;
     5b0:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
     5b6:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
     5b9:	8b 45 0c             	mov    0xc(%ebp),%eax
     5bc:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
     5bf:	8b 45 10             	mov    0x10(%ebp),%eax
     5c2:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
     5c5:	8b 45 14             	mov    0x14(%ebp),%eax
     5c8:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
     5cb:	8b 45 18             	mov    0x18(%ebp),%eax
     5ce:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
     5d1:	89 d8                	mov    %ebx,%eax
     5d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     5d6:	c9                   	leave  
     5d7:	c3                   	ret    
     5d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     5df:	90                   	nop

000005e0 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     5e0:	55                   	push   %ebp
     5e1:	89 e5                	mov    %esp,%ebp
     5e3:	53                   	push   %ebx
     5e4:	83 ec 10             	sub    $0x10,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     5e7:	6a 0c                	push   $0xc
     5e9:	e8 e2 0d 00 00       	call   13d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     5ee:	83 c4 0c             	add    $0xc,%esp
     5f1:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     5f3:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     5f5:	6a 00                	push   $0x0
     5f7:	50                   	push   %eax
     5f8:	e8 b3 08 00 00       	call   eb0 <memset>
  cmd->type = PIPE;
  cmd->left = left;
     5fd:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = PIPE;
     600:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
     606:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     609:	8b 45 0c             	mov    0xc(%ebp),%eax
     60c:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     60f:	89 d8                	mov    %ebx,%eax
     611:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     614:	c9                   	leave  
     615:	c3                   	ret    
     616:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     61d:	8d 76 00             	lea    0x0(%esi),%esi

00000620 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     620:	55                   	push   %ebp
     621:	89 e5                	mov    %esp,%ebp
     623:	53                   	push   %ebx
     624:	83 ec 10             	sub    $0x10,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     627:	6a 0c                	push   $0xc
     629:	e8 a2 0d 00 00       	call   13d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     62e:	83 c4 0c             	add    $0xc,%esp
     631:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     633:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     635:	6a 00                	push   $0x0
     637:	50                   	push   %eax
     638:	e8 73 08 00 00       	call   eb0 <memset>
  cmd->type = LIST;
  cmd->left = left;
     63d:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = LIST;
     640:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
     646:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     649:	8b 45 0c             	mov    0xc(%ebp),%eax
     64c:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     64f:	89 d8                	mov    %ebx,%eax
     651:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     654:	c9                   	leave  
     655:	c3                   	ret    
     656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     65d:	8d 76 00             	lea    0x0(%esi),%esi

00000660 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     660:	55                   	push   %ebp
     661:	89 e5                	mov    %esp,%ebp
     663:	53                   	push   %ebx
     664:	83 ec 10             	sub    $0x10,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     667:	6a 08                	push   $0x8
     669:	e8 62 0d 00 00       	call   13d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     66e:	83 c4 0c             	add    $0xc,%esp
     671:	6a 08                	push   $0x8
  cmd = malloc(sizeof(*cmd));
     673:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     675:	6a 00                	push   $0x0
     677:	50                   	push   %eax
     678:	e8 33 08 00 00       	call   eb0 <memset>
  cmd->type = BACK;
  cmd->cmd = subcmd;
     67d:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = BACK;
     680:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
     686:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
     689:	89 d8                	mov    %ebx,%eax
     68b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     68e:	c9                   	leave  
     68f:	c3                   	ret    

00000690 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     690:	55                   	push   %ebp
     691:	89 e5                	mov    %esp,%ebp
     693:	57                   	push   %edi
     694:	56                   	push   %esi
     695:	53                   	push   %ebx
     696:	83 ec 0c             	sub    $0xc,%esp
  char *s;
  int ret;

  s = *ps;
     699:	8b 45 08             	mov    0x8(%ebp),%eax
{
     69c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     69f:	8b 75 10             	mov    0x10(%ebp),%esi
  s = *ps;
     6a2:	8b 38                	mov    (%eax),%edi
  while(s < es && strchr(whitespace, *s))
     6a4:	39 df                	cmp    %ebx,%edi
     6a6:	72 0f                	jb     6b7 <gettoken+0x27>
     6a8:	eb 25                	jmp    6cf <gettoken+0x3f>
     6aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    s++;
     6b0:	83 c7 01             	add    $0x1,%edi
  while(s < es && strchr(whitespace, *s))
     6b3:	39 fb                	cmp    %edi,%ebx
     6b5:	74 18                	je     6cf <gettoken+0x3f>
     6b7:	0f be 07             	movsbl (%edi),%eax
     6ba:	83 ec 08             	sub    $0x8,%esp
     6bd:	50                   	push   %eax
     6be:	68 74 1c 00 00       	push   $0x1c74
     6c3:	e8 08 08 00 00       	call   ed0 <strchr>
     6c8:	83 c4 10             	add    $0x10,%esp
     6cb:	85 c0                	test   %eax,%eax
     6cd:	75 e1                	jne    6b0 <gettoken+0x20>
  if(q)
     6cf:	85 f6                	test   %esi,%esi
     6d1:	74 02                	je     6d5 <gettoken+0x45>
    *q = s;
     6d3:	89 3e                	mov    %edi,(%esi)
  ret = *s;
     6d5:	0f b6 07             	movzbl (%edi),%eax
  switch(*s){
     6d8:	3c 3c                	cmp    $0x3c,%al
     6da:	0f 8f d0 00 00 00    	jg     7b0 <gettoken+0x120>
     6e0:	3c 3a                	cmp    $0x3a,%al
     6e2:	0f 8f b4 00 00 00    	jg     79c <gettoken+0x10c>
     6e8:	84 c0                	test   %al,%al
     6ea:	75 44                	jne    730 <gettoken+0xa0>
     6ec:	31 f6                	xor    %esi,%esi
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     6ee:	8b 55 14             	mov    0x14(%ebp),%edx
     6f1:	85 d2                	test   %edx,%edx
     6f3:	74 05                	je     6fa <gettoken+0x6a>
    *eq = s;
     6f5:	8b 45 14             	mov    0x14(%ebp),%eax
     6f8:	89 38                	mov    %edi,(%eax)

  while(s < es && strchr(whitespace, *s))
     6fa:	39 df                	cmp    %ebx,%edi
     6fc:	72 09                	jb     707 <gettoken+0x77>
     6fe:	eb 1f                	jmp    71f <gettoken+0x8f>
    s++;
     700:	83 c7 01             	add    $0x1,%edi
  while(s < es && strchr(whitespace, *s))
     703:	39 fb                	cmp    %edi,%ebx
     705:	74 18                	je     71f <gettoken+0x8f>
     707:	0f be 07             	movsbl (%edi),%eax
     70a:	83 ec 08             	sub    $0x8,%esp
     70d:	50                   	push   %eax
     70e:	68 74 1c 00 00       	push   $0x1c74
     713:	e8 b8 07 00 00       	call   ed0 <strchr>
     718:	83 c4 10             	add    $0x10,%esp
     71b:	85 c0                	test   %eax,%eax
     71d:	75 e1                	jne    700 <gettoken+0x70>
  *ps = s;
     71f:	8b 45 08             	mov    0x8(%ebp),%eax
     722:	89 38                	mov    %edi,(%eax)
  return ret;
}
     724:	8d 65 f4             	lea    -0xc(%ebp),%esp
     727:	89 f0                	mov    %esi,%eax
     729:	5b                   	pop    %ebx
     72a:	5e                   	pop    %esi
     72b:	5f                   	pop    %edi
     72c:	5d                   	pop    %ebp
     72d:	c3                   	ret    
     72e:	66 90                	xchg   %ax,%ax
  switch(*s){
     730:	79 5e                	jns    790 <gettoken+0x100>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     732:	39 fb                	cmp    %edi,%ebx
     734:	77 34                	ja     76a <gettoken+0xda>
  if(eq)
     736:	8b 45 14             	mov    0x14(%ebp),%eax
     739:	be 61 00 00 00       	mov    $0x61,%esi
     73e:	85 c0                	test   %eax,%eax
     740:	75 b3                	jne    6f5 <gettoken+0x65>
     742:	eb db                	jmp    71f <gettoken+0x8f>
     744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     748:	0f be 07             	movsbl (%edi),%eax
     74b:	83 ec 08             	sub    $0x8,%esp
     74e:	50                   	push   %eax
     74f:	68 6c 1c 00 00       	push   $0x1c6c
     754:	e8 77 07 00 00       	call   ed0 <strchr>
     759:	83 c4 10             	add    $0x10,%esp
     75c:	85 c0                	test   %eax,%eax
     75e:	75 22                	jne    782 <gettoken+0xf2>
      s++;
     760:	83 c7 01             	add    $0x1,%edi
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     763:	39 fb                	cmp    %edi,%ebx
     765:	74 cf                	je     736 <gettoken+0xa6>
     767:	0f b6 07             	movzbl (%edi),%eax
     76a:	83 ec 08             	sub    $0x8,%esp
     76d:	0f be f0             	movsbl %al,%esi
     770:	56                   	push   %esi
     771:	68 74 1c 00 00       	push   $0x1c74
     776:	e8 55 07 00 00       	call   ed0 <strchr>
     77b:	83 c4 10             	add    $0x10,%esp
     77e:	85 c0                	test   %eax,%eax
     780:	74 c6                	je     748 <gettoken+0xb8>
    ret = 'a';
     782:	be 61 00 00 00       	mov    $0x61,%esi
     787:	e9 62 ff ff ff       	jmp    6ee <gettoken+0x5e>
     78c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  switch(*s){
     790:	3c 26                	cmp    $0x26,%al
     792:	74 08                	je     79c <gettoken+0x10c>
     794:	8d 48 d8             	lea    -0x28(%eax),%ecx
     797:	80 f9 01             	cmp    $0x1,%cl
     79a:	77 96                	ja     732 <gettoken+0xa2>
  ret = *s;
     79c:	0f be f0             	movsbl %al,%esi
    s++;
     79f:	83 c7 01             	add    $0x1,%edi
    break;
     7a2:	e9 47 ff ff ff       	jmp    6ee <gettoken+0x5e>
     7a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     7ae:	66 90                	xchg   %ax,%ax
  switch(*s){
     7b0:	3c 3e                	cmp    $0x3e,%al
     7b2:	75 1c                	jne    7d0 <gettoken+0x140>
    if(*s == '>'){
     7b4:	80 7f 01 3e          	cmpb   $0x3e,0x1(%edi)
    s++;
     7b8:	8d 47 01             	lea    0x1(%edi),%eax
    if(*s == '>'){
     7bb:	74 1c                	je     7d9 <gettoken+0x149>
    s++;
     7bd:	89 c7                	mov    %eax,%edi
     7bf:	be 3e 00 00 00       	mov    $0x3e,%esi
     7c4:	e9 25 ff ff ff       	jmp    6ee <gettoken+0x5e>
     7c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  switch(*s){
     7d0:	3c 7c                	cmp    $0x7c,%al
     7d2:	74 c8                	je     79c <gettoken+0x10c>
     7d4:	e9 59 ff ff ff       	jmp    732 <gettoken+0xa2>
      s++;
     7d9:	83 c7 02             	add    $0x2,%edi
      ret = '+';
     7dc:	be 2b 00 00 00       	mov    $0x2b,%esi
     7e1:	e9 08 ff ff ff       	jmp    6ee <gettoken+0x5e>
     7e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     7ed:	8d 76 00             	lea    0x0(%esi),%esi

000007f0 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     7f0:	55                   	push   %ebp
     7f1:	89 e5                	mov    %esp,%ebp
     7f3:	57                   	push   %edi
     7f4:	56                   	push   %esi
     7f5:	53                   	push   %ebx
     7f6:	83 ec 0c             	sub    $0xc,%esp
     7f9:	8b 7d 08             	mov    0x8(%ebp),%edi
     7fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
     7ff:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
     801:	39 f3                	cmp    %esi,%ebx
     803:	72 12                	jb     817 <peek+0x27>
     805:	eb 28                	jmp    82f <peek+0x3f>
     807:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     80e:	66 90                	xchg   %ax,%ax
    s++;
     810:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
     813:	39 de                	cmp    %ebx,%esi
     815:	74 18                	je     82f <peek+0x3f>
     817:	0f be 03             	movsbl (%ebx),%eax
     81a:	83 ec 08             	sub    $0x8,%esp
     81d:	50                   	push   %eax
     81e:	68 74 1c 00 00       	push   $0x1c74
     823:	e8 a8 06 00 00       	call   ed0 <strchr>
     828:	83 c4 10             	add    $0x10,%esp
     82b:	85 c0                	test   %eax,%eax
     82d:	75 e1                	jne    810 <peek+0x20>
  *ps = s;
     82f:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
     831:	0f be 03             	movsbl (%ebx),%eax
     834:	31 d2                	xor    %edx,%edx
     836:	84 c0                	test   %al,%al
     838:	75 0e                	jne    848 <peek+0x58>
}
     83a:	8d 65 f4             	lea    -0xc(%ebp),%esp
     83d:	89 d0                	mov    %edx,%eax
     83f:	5b                   	pop    %ebx
     840:	5e                   	pop    %esi
     841:	5f                   	pop    %edi
     842:	5d                   	pop    %ebp
     843:	c3                   	ret    
     844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return *s && strchr(toks, *s);
     848:	83 ec 08             	sub    $0x8,%esp
     84b:	50                   	push   %eax
     84c:	ff 75 10             	push   0x10(%ebp)
     84f:	e8 7c 06 00 00       	call   ed0 <strchr>
     854:	83 c4 10             	add    $0x10,%esp
     857:	31 d2                	xor    %edx,%edx
     859:	85 c0                	test   %eax,%eax
     85b:	0f 95 c2             	setne  %dl
}
     85e:	8d 65 f4             	lea    -0xc(%ebp),%esp
     861:	5b                   	pop    %ebx
     862:	89 d0                	mov    %edx,%eax
     864:	5e                   	pop    %esi
     865:	5f                   	pop    %edi
     866:	5d                   	pop    %ebp
     867:	c3                   	ret    
     868:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     86f:	90                   	nop

00000870 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     870:	55                   	push   %ebp
     871:	89 e5                	mov    %esp,%ebp
     873:	57                   	push   %edi
     874:	56                   	push   %esi
     875:	53                   	push   %ebx
     876:	83 ec 2c             	sub    $0x2c,%esp
     879:	8b 75 0c             	mov    0xc(%ebp),%esi
     87c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     87f:	90                   	nop
     880:	83 ec 04             	sub    $0x4,%esp
     883:	68 1c 15 00 00       	push   $0x151c
     888:	53                   	push   %ebx
     889:	56                   	push   %esi
     88a:	e8 61 ff ff ff       	call   7f0 <peek>
     88f:	83 c4 10             	add    $0x10,%esp
     892:	85 c0                	test   %eax,%eax
     894:	0f 84 f6 00 00 00    	je     990 <parseredirs+0x120>
    tok = gettoken(ps, es, 0, 0);
     89a:	6a 00                	push   $0x0
     89c:	6a 00                	push   $0x0
     89e:	53                   	push   %ebx
     89f:	56                   	push   %esi
     8a0:	e8 eb fd ff ff       	call   690 <gettoken>
     8a5:	89 c7                	mov    %eax,%edi
    if(gettoken(ps, es, &q, &eq) != 'a')
     8a7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     8aa:	50                   	push   %eax
     8ab:	8d 45 e0             	lea    -0x20(%ebp),%eax
     8ae:	50                   	push   %eax
     8af:	53                   	push   %ebx
     8b0:	56                   	push   %esi
     8b1:	e8 da fd ff ff       	call   690 <gettoken>
     8b6:	83 c4 20             	add    $0x20,%esp
     8b9:	83 f8 61             	cmp    $0x61,%eax
     8bc:	0f 85 d9 00 00 00    	jne    99b <parseredirs+0x12b>
      panic("missing file for redirection");
    switch(tok){
     8c2:	83 ff 3c             	cmp    $0x3c,%edi
     8c5:	74 69                	je     930 <parseredirs+0xc0>
     8c7:	83 ff 3e             	cmp    $0x3e,%edi
     8ca:	74 05                	je     8d1 <parseredirs+0x61>
     8cc:	83 ff 2b             	cmp    $0x2b,%edi
     8cf:	75 af                	jne    880 <parseredirs+0x10>
  cmd = malloc(sizeof(*cmd));
     8d1:	83 ec 0c             	sub    $0xc,%esp
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     8d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     8d7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  cmd = malloc(sizeof(*cmd));
     8da:	6a 18                	push   $0x18
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     8dc:	89 55 d0             	mov    %edx,-0x30(%ebp)
     8df:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  cmd = malloc(sizeof(*cmd));
     8e2:	e8 e9 0a 00 00       	call   13d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     8e7:	83 c4 0c             	add    $0xc,%esp
     8ea:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     8ec:	89 c7                	mov    %eax,%edi
  memset(cmd, 0, sizeof(*cmd));
     8ee:	6a 00                	push   $0x0
     8f0:	50                   	push   %eax
     8f1:	e8 ba 05 00 00       	call   eb0 <memset>
  cmd->type = REDIR;
     8f6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  cmd->cmd = subcmd;
     8fc:	8b 45 08             	mov    0x8(%ebp),%eax
      break;
     8ff:	83 c4 10             	add    $0x10,%esp
  cmd->cmd = subcmd;
     902:	89 47 04             	mov    %eax,0x4(%edi)
  cmd->file = file;
     905:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
     908:	89 4f 08             	mov    %ecx,0x8(%edi)
  cmd->efile = efile;
     90b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  cmd->mode = mode;
     90e:	c7 47 10 01 02 00 00 	movl   $0x201,0x10(%edi)
  cmd->efile = efile;
     915:	89 57 0c             	mov    %edx,0xc(%edi)
  cmd->fd = fd;
     918:	c7 47 14 01 00 00 00 	movl   $0x1,0x14(%edi)
      break;
     91f:	89 7d 08             	mov    %edi,0x8(%ebp)
     922:	e9 59 ff ff ff       	jmp    880 <parseredirs+0x10>
     927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     92e:	66 90                	xchg   %ax,%ax
  cmd = malloc(sizeof(*cmd));
     930:	83 ec 0c             	sub    $0xc,%esp
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     933:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     936:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  cmd = malloc(sizeof(*cmd));
     939:	6a 18                	push   $0x18
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     93b:	89 55 d0             	mov    %edx,-0x30(%ebp)
     93e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  cmd = malloc(sizeof(*cmd));
     941:	e8 8a 0a 00 00       	call   13d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     946:	83 c4 0c             	add    $0xc,%esp
     949:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     94b:	89 c7                	mov    %eax,%edi
  memset(cmd, 0, sizeof(*cmd));
     94d:	6a 00                	push   $0x0
     94f:	50                   	push   %eax
     950:	e8 5b 05 00 00       	call   eb0 <memset>
  cmd->cmd = subcmd;
     955:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->file = file;
     958:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      break;
     95b:	89 7d 08             	mov    %edi,0x8(%ebp)
  cmd->efile = efile;
     95e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  cmd->type = REDIR;
     961:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
      break;
     967:	83 c4 10             	add    $0x10,%esp
  cmd->cmd = subcmd;
     96a:	89 47 04             	mov    %eax,0x4(%edi)
  cmd->file = file;
     96d:	89 4f 08             	mov    %ecx,0x8(%edi)
  cmd->efile = efile;
     970:	89 57 0c             	mov    %edx,0xc(%edi)
  cmd->mode = mode;
     973:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
  cmd->fd = fd;
     97a:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
      break;
     981:	e9 fa fe ff ff       	jmp    880 <parseredirs+0x10>
     986:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     98d:	8d 76 00             	lea    0x0(%esi),%esi
    }
  }
  return cmd;
}
     990:	8b 45 08             	mov    0x8(%ebp),%eax
     993:	8d 65 f4             	lea    -0xc(%ebp),%esp
     996:	5b                   	pop    %ebx
     997:	5e                   	pop    %esi
     998:	5f                   	pop    %edi
     999:	5d                   	pop    %ebp
     99a:	c3                   	ret    
      panic("missing file for redirection");
     99b:	83 ec 0c             	sub    $0xc,%esp
     99e:	68 ff 14 00 00       	push   $0x14ff
     9a3:	e8 e8 f9 ff ff       	call   390 <panic>
     9a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     9af:	90                   	nop

000009b0 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     9b0:	55                   	push   %ebp
     9b1:	89 e5                	mov    %esp,%ebp
     9b3:	57                   	push   %edi
     9b4:	56                   	push   %esi
     9b5:	53                   	push   %ebx
     9b6:	83 ec 30             	sub    $0x30,%esp
     9b9:	8b 75 08             	mov    0x8(%ebp),%esi
     9bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     9bf:	68 1f 15 00 00       	push   $0x151f
     9c4:	57                   	push   %edi
     9c5:	56                   	push   %esi
     9c6:	e8 25 fe ff ff       	call   7f0 <peek>
     9cb:	83 c4 10             	add    $0x10,%esp
     9ce:	85 c0                	test   %eax,%eax
     9d0:	0f 85 aa 00 00 00    	jne    a80 <parseexec+0xd0>
  cmd = malloc(sizeof(*cmd));
     9d6:	83 ec 0c             	sub    $0xc,%esp
     9d9:	89 c3                	mov    %eax,%ebx
     9db:	6a 54                	push   $0x54
     9dd:	e8 ee 09 00 00       	call   13d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     9e2:	83 c4 0c             	add    $0xc,%esp
     9e5:	6a 54                	push   $0x54
     9e7:	6a 00                	push   $0x0
     9e9:	50                   	push   %eax
     9ea:	89 45 d0             	mov    %eax,-0x30(%ebp)
     9ed:	e8 be 04 00 00       	call   eb0 <memset>
  cmd->type = EXEC;
     9f2:	8b 45 d0             	mov    -0x30(%ebp),%eax

  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     9f5:	83 c4 0c             	add    $0xc,%esp
  cmd->type = EXEC;
     9f8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  ret = parseredirs(ret, ps, es);
     9fe:	57                   	push   %edi
     9ff:	56                   	push   %esi
     a00:	50                   	push   %eax
     a01:	e8 6a fe ff ff       	call   870 <parseredirs>
  while(!peek(ps, es, "|)&;")){
     a06:	83 c4 10             	add    $0x10,%esp
  ret = parseredirs(ret, ps, es);
     a09:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     a0c:	eb 15                	jmp    a23 <parseexec+0x73>
     a0e:	66 90                	xchg   %ax,%ax
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
     a10:	83 ec 04             	sub    $0x4,%esp
     a13:	57                   	push   %edi
     a14:	56                   	push   %esi
     a15:	ff 75 d4             	push   -0x2c(%ebp)
     a18:	e8 53 fe ff ff       	call   870 <parseredirs>
     a1d:	83 c4 10             	add    $0x10,%esp
     a20:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     a23:	83 ec 04             	sub    $0x4,%esp
     a26:	68 36 15 00 00       	push   $0x1536
     a2b:	57                   	push   %edi
     a2c:	56                   	push   %esi
     a2d:	e8 be fd ff ff       	call   7f0 <peek>
     a32:	83 c4 10             	add    $0x10,%esp
     a35:	85 c0                	test   %eax,%eax
     a37:	75 5f                	jne    a98 <parseexec+0xe8>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     a39:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     a3c:	50                   	push   %eax
     a3d:	8d 45 e0             	lea    -0x20(%ebp),%eax
     a40:	50                   	push   %eax
     a41:	57                   	push   %edi
     a42:	56                   	push   %esi
     a43:	e8 48 fc ff ff       	call   690 <gettoken>
     a48:	83 c4 10             	add    $0x10,%esp
     a4b:	85 c0                	test   %eax,%eax
     a4d:	74 49                	je     a98 <parseexec+0xe8>
    if(tok != 'a')
     a4f:	83 f8 61             	cmp    $0x61,%eax
     a52:	75 62                	jne    ab6 <parseexec+0x106>
    cmd->argv[argc] = q;
     a54:	8b 45 e0             	mov    -0x20(%ebp),%eax
     a57:	8b 55 d0             	mov    -0x30(%ebp),%edx
     a5a:	89 44 9a 04          	mov    %eax,0x4(%edx,%ebx,4)
    cmd->eargv[argc] = eq;
     a5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     a61:	89 44 9a 2c          	mov    %eax,0x2c(%edx,%ebx,4)
    argc++;
     a65:	83 c3 01             	add    $0x1,%ebx
    if(argc >= MAXARGS)
     a68:	83 fb 0a             	cmp    $0xa,%ebx
     a6b:	75 a3                	jne    a10 <parseexec+0x60>
      panic("too many args");
     a6d:	83 ec 0c             	sub    $0xc,%esp
     a70:	68 28 15 00 00       	push   $0x1528
     a75:	e8 16 f9 ff ff       	call   390 <panic>
     a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return parseblock(ps, es);
     a80:	89 7d 0c             	mov    %edi,0xc(%ebp)
     a83:	89 75 08             	mov    %esi,0x8(%ebp)
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     a86:	8d 65 f4             	lea    -0xc(%ebp),%esp
     a89:	5b                   	pop    %ebx
     a8a:	5e                   	pop    %esi
     a8b:	5f                   	pop    %edi
     a8c:	5d                   	pop    %ebp
    return parseblock(ps, es);
     a8d:	e9 ae 01 00 00       	jmp    c40 <parseblock>
     a92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  cmd->argv[argc] = 0;
     a98:	8b 45 d0             	mov    -0x30(%ebp),%eax
     a9b:	c7 44 98 04 00 00 00 	movl   $0x0,0x4(%eax,%ebx,4)
     aa2:	00 
  cmd->eargv[argc] = 0;
     aa3:	c7 44 98 2c 00 00 00 	movl   $0x0,0x2c(%eax,%ebx,4)
     aaa:	00 
}
     aab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     aae:	8d 65 f4             	lea    -0xc(%ebp),%esp
     ab1:	5b                   	pop    %ebx
     ab2:	5e                   	pop    %esi
     ab3:	5f                   	pop    %edi
     ab4:	5d                   	pop    %ebp
     ab5:	c3                   	ret    
      panic("syntax");
     ab6:	83 ec 0c             	sub    $0xc,%esp
     ab9:	68 21 15 00 00       	push   $0x1521
     abe:	e8 cd f8 ff ff       	call   390 <panic>
     ac3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000ad0 <parsepipe>:
{
     ad0:	55                   	push   %ebp
     ad1:	89 e5                	mov    %esp,%ebp
     ad3:	57                   	push   %edi
     ad4:	56                   	push   %esi
     ad5:	53                   	push   %ebx
     ad6:	83 ec 14             	sub    $0x14,%esp
     ad9:	8b 75 08             	mov    0x8(%ebp),%esi
     adc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parseexec(ps, es);
     adf:	57                   	push   %edi
     ae0:	56                   	push   %esi
     ae1:	e8 ca fe ff ff       	call   9b0 <parseexec>
  if(peek(ps, es, "|")){
     ae6:	83 c4 0c             	add    $0xc,%esp
     ae9:	68 3b 15 00 00       	push   $0x153b
  cmd = parseexec(ps, es);
     aee:	89 c3                	mov    %eax,%ebx
  if(peek(ps, es, "|")){
     af0:	57                   	push   %edi
     af1:	56                   	push   %esi
     af2:	e8 f9 fc ff ff       	call   7f0 <peek>
     af7:	83 c4 10             	add    $0x10,%esp
     afa:	85 c0                	test   %eax,%eax
     afc:	75 12                	jne    b10 <parsepipe+0x40>
}
     afe:	8d 65 f4             	lea    -0xc(%ebp),%esp
     b01:	89 d8                	mov    %ebx,%eax
     b03:	5b                   	pop    %ebx
     b04:	5e                   	pop    %esi
     b05:	5f                   	pop    %edi
     b06:	5d                   	pop    %ebp
     b07:	c3                   	ret    
     b08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     b0f:	90                   	nop
    gettoken(ps, es, 0, 0);
     b10:	6a 00                	push   $0x0
     b12:	6a 00                	push   $0x0
     b14:	57                   	push   %edi
     b15:	56                   	push   %esi
     b16:	e8 75 fb ff ff       	call   690 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     b1b:	58                   	pop    %eax
     b1c:	5a                   	pop    %edx
     b1d:	57                   	push   %edi
     b1e:	56                   	push   %esi
     b1f:	e8 ac ff ff ff       	call   ad0 <parsepipe>
  cmd = malloc(sizeof(*cmd));
     b24:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
    cmd = pipecmd(cmd, parsepipe(ps, es));
     b2b:	89 c7                	mov    %eax,%edi
  cmd = malloc(sizeof(*cmd));
     b2d:	e8 9e 08 00 00       	call   13d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     b32:	83 c4 0c             	add    $0xc,%esp
     b35:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     b37:	89 c6                	mov    %eax,%esi
  memset(cmd, 0, sizeof(*cmd));
     b39:	6a 00                	push   $0x0
     b3b:	50                   	push   %eax
     b3c:	e8 6f 03 00 00       	call   eb0 <memset>
  cmd->left = left;
     b41:	89 5e 04             	mov    %ebx,0x4(%esi)
  cmd->right = right;
     b44:	83 c4 10             	add    $0x10,%esp
     b47:	89 f3                	mov    %esi,%ebx
  cmd->type = PIPE;
     b49:	c7 06 03 00 00 00    	movl   $0x3,(%esi)
}
     b4f:	89 d8                	mov    %ebx,%eax
  cmd->right = right;
     b51:	89 7e 08             	mov    %edi,0x8(%esi)
}
     b54:	8d 65 f4             	lea    -0xc(%ebp),%esp
     b57:	5b                   	pop    %ebx
     b58:	5e                   	pop    %esi
     b59:	5f                   	pop    %edi
     b5a:	5d                   	pop    %ebp
     b5b:	c3                   	ret    
     b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000b60 <parseline>:
{
     b60:	55                   	push   %ebp
     b61:	89 e5                	mov    %esp,%ebp
     b63:	57                   	push   %edi
     b64:	56                   	push   %esi
     b65:	53                   	push   %ebx
     b66:	83 ec 24             	sub    $0x24,%esp
     b69:	8b 75 08             	mov    0x8(%ebp),%esi
     b6c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parsepipe(ps, es);
     b6f:	57                   	push   %edi
     b70:	56                   	push   %esi
     b71:	e8 5a ff ff ff       	call   ad0 <parsepipe>
  while(peek(ps, es, "&")){
     b76:	83 c4 10             	add    $0x10,%esp
  cmd = parsepipe(ps, es);
     b79:	89 c3                	mov    %eax,%ebx
  while(peek(ps, es, "&")){
     b7b:	eb 3b                	jmp    bb8 <parseline+0x58>
     b7d:	8d 76 00             	lea    0x0(%esi),%esi
    gettoken(ps, es, 0, 0);
     b80:	6a 00                	push   $0x0
     b82:	6a 00                	push   $0x0
     b84:	57                   	push   %edi
     b85:	56                   	push   %esi
     b86:	e8 05 fb ff ff       	call   690 <gettoken>
  cmd = malloc(sizeof(*cmd));
     b8b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     b92:	e8 39 08 00 00       	call   13d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     b97:	83 c4 0c             	add    $0xc,%esp
     b9a:	6a 08                	push   $0x8
     b9c:	6a 00                	push   $0x0
     b9e:	50                   	push   %eax
     b9f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
     ba2:	e8 09 03 00 00       	call   eb0 <memset>
  cmd->type = BACK;
     ba7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  cmd->cmd = subcmd;
     baa:	83 c4 10             	add    $0x10,%esp
  cmd->type = BACK;
     bad:	c7 02 05 00 00 00    	movl   $0x5,(%edx)
  cmd->cmd = subcmd;
     bb3:	89 5a 04             	mov    %ebx,0x4(%edx)
     bb6:	89 d3                	mov    %edx,%ebx
  while(peek(ps, es, "&")){
     bb8:	83 ec 04             	sub    $0x4,%esp
     bbb:	68 3d 15 00 00       	push   $0x153d
     bc0:	57                   	push   %edi
     bc1:	56                   	push   %esi
     bc2:	e8 29 fc ff ff       	call   7f0 <peek>
     bc7:	83 c4 10             	add    $0x10,%esp
     bca:	85 c0                	test   %eax,%eax
     bcc:	75 b2                	jne    b80 <parseline+0x20>
  if(peek(ps, es, ";")){
     bce:	83 ec 04             	sub    $0x4,%esp
     bd1:	68 39 15 00 00       	push   $0x1539
     bd6:	57                   	push   %edi
     bd7:	56                   	push   %esi
     bd8:	e8 13 fc ff ff       	call   7f0 <peek>
     bdd:	83 c4 10             	add    $0x10,%esp
     be0:	85 c0                	test   %eax,%eax
     be2:	75 0c                	jne    bf0 <parseline+0x90>
}
     be4:	8d 65 f4             	lea    -0xc(%ebp),%esp
     be7:	89 d8                	mov    %ebx,%eax
     be9:	5b                   	pop    %ebx
     bea:	5e                   	pop    %esi
     beb:	5f                   	pop    %edi
     bec:	5d                   	pop    %ebp
     bed:	c3                   	ret    
     bee:	66 90                	xchg   %ax,%ax
    gettoken(ps, es, 0, 0);
     bf0:	6a 00                	push   $0x0
     bf2:	6a 00                	push   $0x0
     bf4:	57                   	push   %edi
     bf5:	56                   	push   %esi
     bf6:	e8 95 fa ff ff       	call   690 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     bfb:	58                   	pop    %eax
     bfc:	5a                   	pop    %edx
     bfd:	57                   	push   %edi
     bfe:	56                   	push   %esi
     bff:	e8 5c ff ff ff       	call   b60 <parseline>
  cmd = malloc(sizeof(*cmd));
     c04:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
    cmd = listcmd(cmd, parseline(ps, es));
     c0b:	89 c7                	mov    %eax,%edi
  cmd = malloc(sizeof(*cmd));
     c0d:	e8 be 07 00 00       	call   13d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     c12:	83 c4 0c             	add    $0xc,%esp
     c15:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     c17:	89 c6                	mov    %eax,%esi
  memset(cmd, 0, sizeof(*cmd));
     c19:	6a 00                	push   $0x0
     c1b:	50                   	push   %eax
     c1c:	e8 8f 02 00 00       	call   eb0 <memset>
  cmd->left = left;
     c21:	89 5e 04             	mov    %ebx,0x4(%esi)
  cmd->right = right;
     c24:	83 c4 10             	add    $0x10,%esp
     c27:	89 f3                	mov    %esi,%ebx
  cmd->type = LIST;
     c29:	c7 06 04 00 00 00    	movl   $0x4,(%esi)
}
     c2f:	89 d8                	mov    %ebx,%eax
  cmd->right = right;
     c31:	89 7e 08             	mov    %edi,0x8(%esi)
}
     c34:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c37:	5b                   	pop    %ebx
     c38:	5e                   	pop    %esi
     c39:	5f                   	pop    %edi
     c3a:	5d                   	pop    %ebp
     c3b:	c3                   	ret    
     c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000c40 <parseblock>:
{
     c40:	55                   	push   %ebp
     c41:	89 e5                	mov    %esp,%ebp
     c43:	57                   	push   %edi
     c44:	56                   	push   %esi
     c45:	53                   	push   %ebx
     c46:	83 ec 10             	sub    $0x10,%esp
     c49:	8b 5d 08             	mov    0x8(%ebp),%ebx
     c4c:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(!peek(ps, es, "("))
     c4f:	68 1f 15 00 00       	push   $0x151f
     c54:	56                   	push   %esi
     c55:	53                   	push   %ebx
     c56:	e8 95 fb ff ff       	call   7f0 <peek>
     c5b:	83 c4 10             	add    $0x10,%esp
     c5e:	85 c0                	test   %eax,%eax
     c60:	74 4a                	je     cac <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     c62:	6a 00                	push   $0x0
     c64:	6a 00                	push   $0x0
     c66:	56                   	push   %esi
     c67:	53                   	push   %ebx
     c68:	e8 23 fa ff ff       	call   690 <gettoken>
  cmd = parseline(ps, es);
     c6d:	58                   	pop    %eax
     c6e:	5a                   	pop    %edx
     c6f:	56                   	push   %esi
     c70:	53                   	push   %ebx
     c71:	e8 ea fe ff ff       	call   b60 <parseline>
  if(!peek(ps, es, ")"))
     c76:	83 c4 0c             	add    $0xc,%esp
     c79:	68 5b 15 00 00       	push   $0x155b
  cmd = parseline(ps, es);
     c7e:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
     c80:	56                   	push   %esi
     c81:	53                   	push   %ebx
     c82:	e8 69 fb ff ff       	call   7f0 <peek>
     c87:	83 c4 10             	add    $0x10,%esp
     c8a:	85 c0                	test   %eax,%eax
     c8c:	74 2b                	je     cb9 <parseblock+0x79>
  gettoken(ps, es, 0, 0);
     c8e:	6a 00                	push   $0x0
     c90:	6a 00                	push   $0x0
     c92:	56                   	push   %esi
     c93:	53                   	push   %ebx
     c94:	e8 f7 f9 ff ff       	call   690 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     c99:	83 c4 0c             	add    $0xc,%esp
     c9c:	56                   	push   %esi
     c9d:	53                   	push   %ebx
     c9e:	57                   	push   %edi
     c9f:	e8 cc fb ff ff       	call   870 <parseredirs>
}
     ca4:	8d 65 f4             	lea    -0xc(%ebp),%esp
     ca7:	5b                   	pop    %ebx
     ca8:	5e                   	pop    %esi
     ca9:	5f                   	pop    %edi
     caa:	5d                   	pop    %ebp
     cab:	c3                   	ret    
    panic("parseblock");
     cac:	83 ec 0c             	sub    $0xc,%esp
     caf:	68 3f 15 00 00       	push   $0x153f
     cb4:	e8 d7 f6 ff ff       	call   390 <panic>
    panic("syntax - missing )");
     cb9:	83 ec 0c             	sub    $0xc,%esp
     cbc:	68 4a 15 00 00       	push   $0x154a
     cc1:	e8 ca f6 ff ff       	call   390 <panic>
     cc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     ccd:	8d 76 00             	lea    0x0(%esi),%esi

00000cd0 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     cd0:	55                   	push   %ebp
     cd1:	89 e5                	mov    %esp,%ebp
     cd3:	53                   	push   %ebx
     cd4:	83 ec 04             	sub    $0x4,%esp
     cd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     cda:	85 db                	test   %ebx,%ebx
     cdc:	0f 84 8e 00 00 00    	je     d70 <nulterminate+0xa0>
    return 0;

  switch(cmd->type){
     ce2:	83 3b 05             	cmpl   $0x5,(%ebx)
     ce5:	77 61                	ja     d48 <nulterminate+0x78>
     ce7:	8b 03                	mov    (%ebx),%eax
     ce9:	ff 24 85 bc 15 00 00 	jmp    *0x15bc(,%eax,4)
    nulterminate(pcmd->right);
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    nulterminate(lcmd->left);
     cf0:	83 ec 0c             	sub    $0xc,%esp
     cf3:	ff 73 04             	push   0x4(%ebx)
     cf6:	e8 d5 ff ff ff       	call   cd0 <nulterminate>
    nulterminate(lcmd->right);
     cfb:	58                   	pop    %eax
     cfc:	ff 73 08             	push   0x8(%ebx)
     cff:	e8 cc ff ff ff       	call   cd0 <nulterminate>
    break;
     d04:	83 c4 10             	add    $0x10,%esp
     d07:	89 d8                	mov    %ebx,%eax
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     d09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     d0c:	c9                   	leave  
     d0d:	c3                   	ret    
     d0e:	66 90                	xchg   %ax,%ax
    nulterminate(bcmd->cmd);
     d10:	83 ec 0c             	sub    $0xc,%esp
     d13:	ff 73 04             	push   0x4(%ebx)
     d16:	e8 b5 ff ff ff       	call   cd0 <nulterminate>
    break;
     d1b:	89 d8                	mov    %ebx,%eax
     d1d:	83 c4 10             	add    $0x10,%esp
}
     d20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     d23:	c9                   	leave  
     d24:	c3                   	ret    
     d25:	8d 76 00             	lea    0x0(%esi),%esi
    for(i=0; ecmd->argv[i]; i++)
     d28:	8b 4b 04             	mov    0x4(%ebx),%ecx
     d2b:	8d 43 08             	lea    0x8(%ebx),%eax
     d2e:	85 c9                	test   %ecx,%ecx
     d30:	74 16                	je     d48 <nulterminate+0x78>
     d32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      *ecmd->eargv[i] = 0;
     d38:	8b 50 24             	mov    0x24(%eax),%edx
    for(i=0; ecmd->argv[i]; i++)
     d3b:	83 c0 04             	add    $0x4,%eax
      *ecmd->eargv[i] = 0;
     d3e:	c6 02 00             	movb   $0x0,(%edx)
    for(i=0; ecmd->argv[i]; i++)
     d41:	8b 50 fc             	mov    -0x4(%eax),%edx
     d44:	85 d2                	test   %edx,%edx
     d46:	75 f0                	jne    d38 <nulterminate+0x68>
  switch(cmd->type){
     d48:	89 d8                	mov    %ebx,%eax
}
     d4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     d4d:	c9                   	leave  
     d4e:	c3                   	ret    
     d4f:	90                   	nop
    nulterminate(rcmd->cmd);
     d50:	83 ec 0c             	sub    $0xc,%esp
     d53:	ff 73 04             	push   0x4(%ebx)
     d56:	e8 75 ff ff ff       	call   cd0 <nulterminate>
    *rcmd->efile = 0;
     d5b:	8b 43 0c             	mov    0xc(%ebx),%eax
    break;
     d5e:	83 c4 10             	add    $0x10,%esp
    *rcmd->efile = 0;
     d61:	c6 00 00             	movb   $0x0,(%eax)
    break;
     d64:	89 d8                	mov    %ebx,%eax
}
     d66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     d69:	c9                   	leave  
     d6a:	c3                   	ret    
     d6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     d6f:	90                   	nop
    return 0;
     d70:	31 c0                	xor    %eax,%eax
     d72:	eb 95                	jmp    d09 <nulterminate+0x39>
     d74:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     d7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     d7f:	90                   	nop

00000d80 <parsecmd>:
{
     d80:	55                   	push   %ebp
     d81:	89 e5                	mov    %esp,%ebp
     d83:	57                   	push   %edi
     d84:	56                   	push   %esi
  cmd = parseline(&s, es);
     d85:	8d 7d 08             	lea    0x8(%ebp),%edi
{
     d88:	53                   	push   %ebx
     d89:	83 ec 18             	sub    $0x18,%esp
  es = s + strlen(s);
     d8c:	8b 5d 08             	mov    0x8(%ebp),%ebx
     d8f:	53                   	push   %ebx
     d90:	e8 eb 00 00 00       	call   e80 <strlen>
  cmd = parseline(&s, es);
     d95:	59                   	pop    %ecx
     d96:	5e                   	pop    %esi
  es = s + strlen(s);
     d97:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
     d99:	53                   	push   %ebx
     d9a:	57                   	push   %edi
     d9b:	e8 c0 fd ff ff       	call   b60 <parseline>
  peek(&s, es, "");
     da0:	83 c4 0c             	add    $0xc,%esp
     da3:	68 e9 14 00 00       	push   $0x14e9
  cmd = parseline(&s, es);
     da8:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     daa:	53                   	push   %ebx
     dab:	57                   	push   %edi
     dac:	e8 3f fa ff ff       	call   7f0 <peek>
  if(s != es){
     db1:	8b 45 08             	mov    0x8(%ebp),%eax
     db4:	83 c4 10             	add    $0x10,%esp
     db7:	39 d8                	cmp    %ebx,%eax
     db9:	75 13                	jne    dce <parsecmd+0x4e>
  nulterminate(cmd);
     dbb:	83 ec 0c             	sub    $0xc,%esp
     dbe:	56                   	push   %esi
     dbf:	e8 0c ff ff ff       	call   cd0 <nulterminate>
}
     dc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
     dc7:	89 f0                	mov    %esi,%eax
     dc9:	5b                   	pop    %ebx
     dca:	5e                   	pop    %esi
     dcb:	5f                   	pop    %edi
     dcc:	5d                   	pop    %ebp
     dcd:	c3                   	ret    
    printf(2, "leftovers: %s\n", s);
     dce:	52                   	push   %edx
     dcf:	50                   	push   %eax
     dd0:	68 5d 15 00 00       	push   $0x155d
     dd5:	6a 02                	push   $0x2
     dd7:	e8 c4 03 00 00       	call   11a0 <printf>
    panic("syntax");
     ddc:	c7 04 24 21 15 00 00 	movl   $0x1521,(%esp)
     de3:	e8 a8 f5 ff ff       	call   390 <panic>
     de8:	66 90                	xchg   %ax,%ax
     dea:	66 90                	xchg   %ax,%ax
     dec:	66 90                	xchg   %ax,%ax
     dee:	66 90                	xchg   %ax,%ax

00000df0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
     df0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     df1:	31 c0                	xor    %eax,%eax
{
     df3:	89 e5                	mov    %esp,%ebp
     df5:	53                   	push   %ebx
     df6:	8b 4d 08             	mov    0x8(%ebp),%ecx
     df9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
     e00:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
     e04:	88 14 01             	mov    %dl,(%ecx,%eax,1)
     e07:	83 c0 01             	add    $0x1,%eax
     e0a:	84 d2                	test   %dl,%dl
     e0c:	75 f2                	jne    e00 <strcpy+0x10>
    ;
  return os;
}
     e0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     e11:	89 c8                	mov    %ecx,%eax
     e13:	c9                   	leave  
     e14:	c3                   	ret    
     e15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000e20 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     e20:	55                   	push   %ebp
     e21:	89 e5                	mov    %esp,%ebp
     e23:	53                   	push   %ebx
     e24:	8b 55 08             	mov    0x8(%ebp),%edx
     e27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
     e2a:	0f b6 02             	movzbl (%edx),%eax
     e2d:	84 c0                	test   %al,%al
     e2f:	75 17                	jne    e48 <strcmp+0x28>
     e31:	eb 3a                	jmp    e6d <strcmp+0x4d>
     e33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     e37:	90                   	nop
     e38:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
     e3c:	83 c2 01             	add    $0x1,%edx
     e3f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
     e42:	84 c0                	test   %al,%al
     e44:	74 1a                	je     e60 <strcmp+0x40>
    p++, q++;
     e46:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
     e48:	0f b6 19             	movzbl (%ecx),%ebx
     e4b:	38 c3                	cmp    %al,%bl
     e4d:	74 e9                	je     e38 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
     e4f:	29 d8                	sub    %ebx,%eax
}
     e51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     e54:	c9                   	leave  
     e55:	c3                   	ret    
     e56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     e5d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
     e60:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
     e64:	31 c0                	xor    %eax,%eax
     e66:	29 d8                	sub    %ebx,%eax
}
     e68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     e6b:	c9                   	leave  
     e6c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
     e6d:	0f b6 19             	movzbl (%ecx),%ebx
     e70:	31 c0                	xor    %eax,%eax
     e72:	eb db                	jmp    e4f <strcmp+0x2f>
     e74:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     e7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     e7f:	90                   	nop

00000e80 <strlen>:

uint
strlen(const char *s)
{
     e80:	55                   	push   %ebp
     e81:	89 e5                	mov    %esp,%ebp
     e83:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
     e86:	80 3a 00             	cmpb   $0x0,(%edx)
     e89:	74 15                	je     ea0 <strlen+0x20>
     e8b:	31 c0                	xor    %eax,%eax
     e8d:	8d 76 00             	lea    0x0(%esi),%esi
     e90:	83 c0 01             	add    $0x1,%eax
     e93:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
     e97:	89 c1                	mov    %eax,%ecx
     e99:	75 f5                	jne    e90 <strlen+0x10>
    ;
  return n;
}
     e9b:	89 c8                	mov    %ecx,%eax
     e9d:	5d                   	pop    %ebp
     e9e:	c3                   	ret    
     e9f:	90                   	nop
  for(n = 0; s[n]; n++)
     ea0:	31 c9                	xor    %ecx,%ecx
}
     ea2:	5d                   	pop    %ebp
     ea3:	89 c8                	mov    %ecx,%eax
     ea5:	c3                   	ret    
     ea6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     ead:	8d 76 00             	lea    0x0(%esi),%esi

00000eb0 <memset>:

void*
memset(void *dst, int c, uint n)
{
     eb0:	55                   	push   %ebp
     eb1:	89 e5                	mov    %esp,%ebp
     eb3:	57                   	push   %edi
     eb4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     eb7:	8b 4d 10             	mov    0x10(%ebp),%ecx
     eba:	8b 45 0c             	mov    0xc(%ebp),%eax
     ebd:	89 d7                	mov    %edx,%edi
     ebf:	fc                   	cld    
     ec0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     ec2:	8b 7d fc             	mov    -0x4(%ebp),%edi
     ec5:	89 d0                	mov    %edx,%eax
     ec7:	c9                   	leave  
     ec8:	c3                   	ret    
     ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000ed0 <strchr>:

char*
strchr(const char *s, char c)
{
     ed0:	55                   	push   %ebp
     ed1:	89 e5                	mov    %esp,%ebp
     ed3:	8b 45 08             	mov    0x8(%ebp),%eax
     ed6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
     eda:	0f b6 10             	movzbl (%eax),%edx
     edd:	84 d2                	test   %dl,%dl
     edf:	75 12                	jne    ef3 <strchr+0x23>
     ee1:	eb 1d                	jmp    f00 <strchr+0x30>
     ee3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     ee7:	90                   	nop
     ee8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
     eec:	83 c0 01             	add    $0x1,%eax
     eef:	84 d2                	test   %dl,%dl
     ef1:	74 0d                	je     f00 <strchr+0x30>
    if(*s == c)
     ef3:	38 d1                	cmp    %dl,%cl
     ef5:	75 f1                	jne    ee8 <strchr+0x18>
      return (char*)s;
  return 0;
}
     ef7:	5d                   	pop    %ebp
     ef8:	c3                   	ret    
     ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
     f00:	31 c0                	xor    %eax,%eax
}
     f02:	5d                   	pop    %ebp
     f03:	c3                   	ret    
     f04:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     f0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     f0f:	90                   	nop

00000f10 <gets>:

char*
gets(char *buf, int max)
{
     f10:	55                   	push   %ebp
     f11:	89 e5                	mov    %esp,%ebp
     f13:	57                   	push   %edi
     f14:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
     f15:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
     f18:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
     f19:	31 db                	xor    %ebx,%ebx
{
     f1b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
     f1e:	eb 27                	jmp    f47 <gets+0x37>
    cc = read(0, &c, 1);
     f20:	83 ec 04             	sub    $0x4,%esp
     f23:	6a 01                	push   $0x1
     f25:	57                   	push   %edi
     f26:	6a 00                	push   $0x0
     f28:	e8 2e 01 00 00       	call   105b <read>
    if(cc < 1)
     f2d:	83 c4 10             	add    $0x10,%esp
     f30:	85 c0                	test   %eax,%eax
     f32:	7e 1d                	jle    f51 <gets+0x41>
      break;
    buf[i++] = c;
     f34:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     f38:	8b 55 08             	mov    0x8(%ebp),%edx
     f3b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
     f3f:	3c 0a                	cmp    $0xa,%al
     f41:	74 1d                	je     f60 <gets+0x50>
     f43:	3c 0d                	cmp    $0xd,%al
     f45:	74 19                	je     f60 <gets+0x50>
  for(i=0; i+1 < max; ){
     f47:	89 de                	mov    %ebx,%esi
     f49:	83 c3 01             	add    $0x1,%ebx
     f4c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
     f4f:	7c cf                	jl     f20 <gets+0x10>
      break;
  }
  buf[i] = '\0';
     f51:	8b 45 08             	mov    0x8(%ebp),%eax
     f54:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
     f58:	8d 65 f4             	lea    -0xc(%ebp),%esp
     f5b:	5b                   	pop    %ebx
     f5c:	5e                   	pop    %esi
     f5d:	5f                   	pop    %edi
     f5e:	5d                   	pop    %ebp
     f5f:	c3                   	ret    
  buf[i] = '\0';
     f60:	8b 45 08             	mov    0x8(%ebp),%eax
     f63:	89 de                	mov    %ebx,%esi
     f65:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
     f69:	8d 65 f4             	lea    -0xc(%ebp),%esp
     f6c:	5b                   	pop    %ebx
     f6d:	5e                   	pop    %esi
     f6e:	5f                   	pop    %edi
     f6f:	5d                   	pop    %ebp
     f70:	c3                   	ret    
     f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     f78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     f7f:	90                   	nop

00000f80 <stat>:

int
stat(const char *n, struct stat *st)
{
     f80:	55                   	push   %ebp
     f81:	89 e5                	mov    %esp,%ebp
     f83:	56                   	push   %esi
     f84:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     f85:	83 ec 08             	sub    $0x8,%esp
     f88:	6a 00                	push   $0x0
     f8a:	ff 75 08             	push   0x8(%ebp)
     f8d:	e8 f1 00 00 00       	call   1083 <open>
  if(fd < 0)
     f92:	83 c4 10             	add    $0x10,%esp
     f95:	85 c0                	test   %eax,%eax
     f97:	78 27                	js     fc0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
     f99:	83 ec 08             	sub    $0x8,%esp
     f9c:	ff 75 0c             	push   0xc(%ebp)
     f9f:	89 c3                	mov    %eax,%ebx
     fa1:	50                   	push   %eax
     fa2:	e8 f4 00 00 00       	call   109b <fstat>
  close(fd);
     fa7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
     faa:	89 c6                	mov    %eax,%esi
  close(fd);
     fac:	e8 ba 00 00 00       	call   106b <close>
  return r;
     fb1:	83 c4 10             	add    $0x10,%esp
}
     fb4:	8d 65 f8             	lea    -0x8(%ebp),%esp
     fb7:	89 f0                	mov    %esi,%eax
     fb9:	5b                   	pop    %ebx
     fba:	5e                   	pop    %esi
     fbb:	5d                   	pop    %ebp
     fbc:	c3                   	ret    
     fbd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
     fc0:	be ff ff ff ff       	mov    $0xffffffff,%esi
     fc5:	eb ed                	jmp    fb4 <stat+0x34>
     fc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     fce:	66 90                	xchg   %ax,%ax

00000fd0 <atoi>:

int
atoi(const char *s)
{
     fd0:	55                   	push   %ebp
     fd1:	89 e5                	mov    %esp,%ebp
     fd3:	53                   	push   %ebx
     fd4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     fd7:	0f be 02             	movsbl (%edx),%eax
     fda:	8d 48 d0             	lea    -0x30(%eax),%ecx
     fdd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
     fe0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
     fe5:	77 1e                	ja     1005 <atoi+0x35>
     fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     fee:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
     ff0:	83 c2 01             	add    $0x1,%edx
     ff3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
     ff6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
     ffa:	0f be 02             	movsbl (%edx),%eax
     ffd:	8d 58 d0             	lea    -0x30(%eax),%ebx
    1000:	80 fb 09             	cmp    $0x9,%bl
    1003:	76 eb                	jbe    ff0 <atoi+0x20>
  return n;
}
    1005:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1008:	89 c8                	mov    %ecx,%eax
    100a:	c9                   	leave  
    100b:	c3                   	ret    
    100c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001010 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1010:	55                   	push   %ebp
    1011:	89 e5                	mov    %esp,%ebp
    1013:	57                   	push   %edi
    1014:	8b 45 10             	mov    0x10(%ebp),%eax
    1017:	8b 55 08             	mov    0x8(%ebp),%edx
    101a:	56                   	push   %esi
    101b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    101e:	85 c0                	test   %eax,%eax
    1020:	7e 13                	jle    1035 <memmove+0x25>
    1022:	01 d0                	add    %edx,%eax
  dst = vdst;
    1024:	89 d7                	mov    %edx,%edi
    1026:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    102d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
    1030:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
    1031:	39 f8                	cmp    %edi,%eax
    1033:	75 fb                	jne    1030 <memmove+0x20>
  return vdst;
}
    1035:	5e                   	pop    %esi
    1036:	89 d0                	mov    %edx,%eax
    1038:	5f                   	pop    %edi
    1039:	5d                   	pop    %ebp
    103a:	c3                   	ret    

0000103b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    103b:	b8 01 00 00 00       	mov    $0x1,%eax
    1040:	cd 40                	int    $0x40
    1042:	c3                   	ret    

00001043 <exit>:
SYSCALL(exit)
    1043:	b8 02 00 00 00       	mov    $0x2,%eax
    1048:	cd 40                	int    $0x40
    104a:	c3                   	ret    

0000104b <wait>:
SYSCALL(wait)
    104b:	b8 03 00 00 00       	mov    $0x3,%eax
    1050:	cd 40                	int    $0x40
    1052:	c3                   	ret    

00001053 <pipe>:
SYSCALL(pipe)
    1053:	b8 04 00 00 00       	mov    $0x4,%eax
    1058:	cd 40                	int    $0x40
    105a:	c3                   	ret    

0000105b <read>:
SYSCALL(read)
    105b:	b8 05 00 00 00       	mov    $0x5,%eax
    1060:	cd 40                	int    $0x40
    1062:	c3                   	ret    

00001063 <write>:
SYSCALL(write)
    1063:	b8 10 00 00 00       	mov    $0x10,%eax
    1068:	cd 40                	int    $0x40
    106a:	c3                   	ret    

0000106b <close>:
SYSCALL(close)
    106b:	b8 15 00 00 00       	mov    $0x15,%eax
    1070:	cd 40                	int    $0x40
    1072:	c3                   	ret    

00001073 <kill>:
SYSCALL(kill)
    1073:	b8 06 00 00 00       	mov    $0x6,%eax
    1078:	cd 40                	int    $0x40
    107a:	c3                   	ret    

0000107b <exec>:
SYSCALL(exec)
    107b:	b8 07 00 00 00       	mov    $0x7,%eax
    1080:	cd 40                	int    $0x40
    1082:	c3                   	ret    

00001083 <open>:
SYSCALL(open)
    1083:	b8 0f 00 00 00       	mov    $0xf,%eax
    1088:	cd 40                	int    $0x40
    108a:	c3                   	ret    

0000108b <mknod>:
SYSCALL(mknod)
    108b:	b8 11 00 00 00       	mov    $0x11,%eax
    1090:	cd 40                	int    $0x40
    1092:	c3                   	ret    

00001093 <unlink>:
SYSCALL(unlink)
    1093:	b8 12 00 00 00       	mov    $0x12,%eax
    1098:	cd 40                	int    $0x40
    109a:	c3                   	ret    

0000109b <fstat>:
SYSCALL(fstat)
    109b:	b8 08 00 00 00       	mov    $0x8,%eax
    10a0:	cd 40                	int    $0x40
    10a2:	c3                   	ret    

000010a3 <link>:
SYSCALL(link)
    10a3:	b8 13 00 00 00       	mov    $0x13,%eax
    10a8:	cd 40                	int    $0x40
    10aa:	c3                   	ret    

000010ab <mkdir>:
SYSCALL(mkdir)
    10ab:	b8 14 00 00 00       	mov    $0x14,%eax
    10b0:	cd 40                	int    $0x40
    10b2:	c3                   	ret    

000010b3 <chdir>:
SYSCALL(chdir)
    10b3:	b8 09 00 00 00       	mov    $0x9,%eax
    10b8:	cd 40                	int    $0x40
    10ba:	c3                   	ret    

000010bb <dup>:
SYSCALL(dup)
    10bb:	b8 0a 00 00 00       	mov    $0xa,%eax
    10c0:	cd 40                	int    $0x40
    10c2:	c3                   	ret    

000010c3 <getpid>:
SYSCALL(getpid)
    10c3:	b8 0b 00 00 00       	mov    $0xb,%eax
    10c8:	cd 40                	int    $0x40
    10ca:	c3                   	ret    

000010cb <sbrk>:
SYSCALL(sbrk)
    10cb:	b8 0c 00 00 00       	mov    $0xc,%eax
    10d0:	cd 40                	int    $0x40
    10d2:	c3                   	ret    

000010d3 <sleep>:
SYSCALL(sleep)
    10d3:	b8 0d 00 00 00       	mov    $0xd,%eax
    10d8:	cd 40                	int    $0x40
    10da:	c3                   	ret    

000010db <uptime>:
SYSCALL(uptime)
    10db:	b8 0e 00 00 00       	mov    $0xe,%eax
    10e0:	cd 40                	int    $0x40
    10e2:	c3                   	ret    
    10e3:	66 90                	xchg   %ax,%ax
    10e5:	66 90                	xchg   %ax,%ax
    10e7:	66 90                	xchg   %ax,%ax
    10e9:	66 90                	xchg   %ax,%ax
    10eb:	66 90                	xchg   %ax,%ax
    10ed:	66 90                	xchg   %ax,%ax
    10ef:	90                   	nop

000010f0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    10f0:	55                   	push   %ebp
    10f1:	89 e5                	mov    %esp,%ebp
    10f3:	57                   	push   %edi
    10f4:	56                   	push   %esi
    10f5:	53                   	push   %ebx
    10f6:	83 ec 3c             	sub    $0x3c,%esp
    10f9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    10fc:	89 d1                	mov    %edx,%ecx
{
    10fe:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
    1101:	85 d2                	test   %edx,%edx
    1103:	0f 89 7f 00 00 00    	jns    1188 <printint+0x98>
    1109:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    110d:	74 79                	je     1188 <printint+0x98>
    neg = 1;
    110f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
    1116:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
    1118:	31 db                	xor    %ebx,%ebx
    111a:	8d 75 d7             	lea    -0x29(%ebp),%esi
    111d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
    1120:	89 c8                	mov    %ecx,%eax
    1122:	31 d2                	xor    %edx,%edx
    1124:	89 cf                	mov    %ecx,%edi
    1126:	f7 75 c4             	divl   -0x3c(%ebp)
    1129:	0f b6 92 34 16 00 00 	movzbl 0x1634(%edx),%edx
    1130:	89 45 c0             	mov    %eax,-0x40(%ebp)
    1133:	89 d8                	mov    %ebx,%eax
    1135:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
    1138:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
    113b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
    113e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
    1141:	76 dd                	jbe    1120 <printint+0x30>
  if(neg)
    1143:	8b 4d bc             	mov    -0x44(%ebp),%ecx
    1146:	85 c9                	test   %ecx,%ecx
    1148:	74 0c                	je     1156 <printint+0x66>
    buf[i++] = '-';
    114a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
    114f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
    1151:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
    1156:	8b 7d b8             	mov    -0x48(%ebp),%edi
    1159:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
    115d:	eb 07                	jmp    1166 <printint+0x76>
    115f:	90                   	nop
    putc(fd, buf[i]);
    1160:	0f b6 13             	movzbl (%ebx),%edx
    1163:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
    1166:	83 ec 04             	sub    $0x4,%esp
    1169:	88 55 d7             	mov    %dl,-0x29(%ebp)
    116c:	6a 01                	push   $0x1
    116e:	56                   	push   %esi
    116f:	57                   	push   %edi
    1170:	e8 ee fe ff ff       	call   1063 <write>
  while(--i >= 0)
    1175:	83 c4 10             	add    $0x10,%esp
    1178:	39 de                	cmp    %ebx,%esi
    117a:	75 e4                	jne    1160 <printint+0x70>
}
    117c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    117f:	5b                   	pop    %ebx
    1180:	5e                   	pop    %esi
    1181:	5f                   	pop    %edi
    1182:	5d                   	pop    %ebp
    1183:	c3                   	ret    
    1184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    1188:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
    118f:	eb 87                	jmp    1118 <printint+0x28>
    1191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1198:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    119f:	90                   	nop

000011a0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    11a0:	55                   	push   %ebp
    11a1:	89 e5                	mov    %esp,%ebp
    11a3:	57                   	push   %edi
    11a4:	56                   	push   %esi
    11a5:	53                   	push   %ebx
    11a6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    11a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
    11ac:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
    11af:	0f b6 13             	movzbl (%ebx),%edx
    11b2:	84 d2                	test   %dl,%dl
    11b4:	74 6a                	je     1220 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
    11b6:	8d 45 10             	lea    0x10(%ebp),%eax
    11b9:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
    11bc:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
    11bf:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
    11c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
    11c4:	eb 36                	jmp    11fc <printf+0x5c>
    11c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11cd:	8d 76 00             	lea    0x0(%esi),%esi
    11d0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    11d3:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
    11d8:	83 f8 25             	cmp    $0x25,%eax
    11db:	74 15                	je     11f2 <printf+0x52>
  write(fd, &c, 1);
    11dd:	83 ec 04             	sub    $0x4,%esp
    11e0:	88 55 e7             	mov    %dl,-0x19(%ebp)
    11e3:	6a 01                	push   $0x1
    11e5:	57                   	push   %edi
    11e6:	56                   	push   %esi
    11e7:	e8 77 fe ff ff       	call   1063 <write>
    11ec:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
    11ef:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    11f2:	0f b6 13             	movzbl (%ebx),%edx
    11f5:	83 c3 01             	add    $0x1,%ebx
    11f8:	84 d2                	test   %dl,%dl
    11fa:	74 24                	je     1220 <printf+0x80>
    c = fmt[i] & 0xff;
    11fc:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
    11ff:	85 c9                	test   %ecx,%ecx
    1201:	74 cd                	je     11d0 <printf+0x30>
      }
    } else if(state == '%'){
    1203:	83 f9 25             	cmp    $0x25,%ecx
    1206:	75 ea                	jne    11f2 <printf+0x52>
      if(c == 'd'){
    1208:	83 f8 25             	cmp    $0x25,%eax
    120b:	0f 84 07 01 00 00    	je     1318 <printf+0x178>
    1211:	83 e8 63             	sub    $0x63,%eax
    1214:	83 f8 15             	cmp    $0x15,%eax
    1217:	77 17                	ja     1230 <printf+0x90>
    1219:	ff 24 85 dc 15 00 00 	jmp    *0x15dc(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1220:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1223:	5b                   	pop    %ebx
    1224:	5e                   	pop    %esi
    1225:	5f                   	pop    %edi
    1226:	5d                   	pop    %ebp
    1227:	c3                   	ret    
    1228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    122f:	90                   	nop
  write(fd, &c, 1);
    1230:	83 ec 04             	sub    $0x4,%esp
    1233:	88 55 d4             	mov    %dl,-0x2c(%ebp)
    1236:	6a 01                	push   $0x1
    1238:	57                   	push   %edi
    1239:	56                   	push   %esi
    123a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    123e:	e8 20 fe ff ff       	call   1063 <write>
        putc(fd, c);
    1243:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
    1247:	83 c4 0c             	add    $0xc,%esp
    124a:	88 55 e7             	mov    %dl,-0x19(%ebp)
    124d:	6a 01                	push   $0x1
    124f:	57                   	push   %edi
    1250:	56                   	push   %esi
    1251:	e8 0d fe ff ff       	call   1063 <write>
        putc(fd, c);
    1256:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1259:	31 c9                	xor    %ecx,%ecx
    125b:	eb 95                	jmp    11f2 <printf+0x52>
    125d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
    1260:	83 ec 0c             	sub    $0xc,%esp
    1263:	b9 10 00 00 00       	mov    $0x10,%ecx
    1268:	6a 00                	push   $0x0
    126a:	8b 45 d0             	mov    -0x30(%ebp),%eax
    126d:	8b 10                	mov    (%eax),%edx
    126f:	89 f0                	mov    %esi,%eax
    1271:	e8 7a fe ff ff       	call   10f0 <printint>
        ap++;
    1276:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
    127a:	83 c4 10             	add    $0x10,%esp
      state = 0;
    127d:	31 c9                	xor    %ecx,%ecx
    127f:	e9 6e ff ff ff       	jmp    11f2 <printf+0x52>
    1284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
    1288:	8b 45 d0             	mov    -0x30(%ebp),%eax
    128b:	8b 10                	mov    (%eax),%edx
        ap++;
    128d:	83 c0 04             	add    $0x4,%eax
    1290:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    1293:	85 d2                	test   %edx,%edx
    1295:	0f 84 8d 00 00 00    	je     1328 <printf+0x188>
        while(*s != 0){
    129b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
    129e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
    12a0:	84 c0                	test   %al,%al
    12a2:	0f 84 4a ff ff ff    	je     11f2 <printf+0x52>
    12a8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    12ab:	89 d3                	mov    %edx,%ebx
    12ad:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
    12b0:	83 ec 04             	sub    $0x4,%esp
          s++;
    12b3:	83 c3 01             	add    $0x1,%ebx
    12b6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    12b9:	6a 01                	push   $0x1
    12bb:	57                   	push   %edi
    12bc:	56                   	push   %esi
    12bd:	e8 a1 fd ff ff       	call   1063 <write>
        while(*s != 0){
    12c2:	0f b6 03             	movzbl (%ebx),%eax
    12c5:	83 c4 10             	add    $0x10,%esp
    12c8:	84 c0                	test   %al,%al
    12ca:	75 e4                	jne    12b0 <printf+0x110>
      state = 0;
    12cc:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
    12cf:	31 c9                	xor    %ecx,%ecx
    12d1:	e9 1c ff ff ff       	jmp    11f2 <printf+0x52>
    12d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    12dd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
    12e0:	83 ec 0c             	sub    $0xc,%esp
    12e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
    12e8:	6a 01                	push   $0x1
    12ea:	e9 7b ff ff ff       	jmp    126a <printf+0xca>
    12ef:	90                   	nop
        putc(fd, *ap);
    12f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
    12f3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    12f6:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
    12f8:	6a 01                	push   $0x1
    12fa:	57                   	push   %edi
    12fb:	56                   	push   %esi
        putc(fd, *ap);
    12fc:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    12ff:	e8 5f fd ff ff       	call   1063 <write>
        ap++;
    1304:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
    1308:	83 c4 10             	add    $0x10,%esp
      state = 0;
    130b:	31 c9                	xor    %ecx,%ecx
    130d:	e9 e0 fe ff ff       	jmp    11f2 <printf+0x52>
    1312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
    1318:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
    131b:	83 ec 04             	sub    $0x4,%esp
    131e:	e9 2a ff ff ff       	jmp    124d <printf+0xad>
    1323:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1327:	90                   	nop
          s = "(null)";
    1328:	ba d4 15 00 00       	mov    $0x15d4,%edx
        while(*s != 0){
    132d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    1330:	b8 28 00 00 00       	mov    $0x28,%eax
    1335:	89 d3                	mov    %edx,%ebx
    1337:	e9 74 ff ff ff       	jmp    12b0 <printf+0x110>
    133c:	66 90                	xchg   %ax,%ax
    133e:	66 90                	xchg   %ax,%ax

00001340 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1340:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1341:	a1 04 1d 00 00       	mov    0x1d04,%eax
{
    1346:	89 e5                	mov    %esp,%ebp
    1348:	57                   	push   %edi
    1349:	56                   	push   %esi
    134a:	53                   	push   %ebx
    134b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
    134e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1358:	89 c2                	mov    %eax,%edx
    135a:	8b 00                	mov    (%eax),%eax
    135c:	39 ca                	cmp    %ecx,%edx
    135e:	73 30                	jae    1390 <free+0x50>
    1360:	39 c1                	cmp    %eax,%ecx
    1362:	72 04                	jb     1368 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1364:	39 c2                	cmp    %eax,%edx
    1366:	72 f0                	jb     1358 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1368:	8b 73 fc             	mov    -0x4(%ebx),%esi
    136b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    136e:	39 f8                	cmp    %edi,%eax
    1370:	74 30                	je     13a2 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    1372:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    1375:	8b 42 04             	mov    0x4(%edx),%eax
    1378:	8d 34 c2             	lea    (%edx,%eax,8),%esi
    137b:	39 f1                	cmp    %esi,%ecx
    137d:	74 3a                	je     13b9 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    137f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
    1381:	5b                   	pop    %ebx
  freep = p;
    1382:	89 15 04 1d 00 00    	mov    %edx,0x1d04
}
    1388:	5e                   	pop    %esi
    1389:	5f                   	pop    %edi
    138a:	5d                   	pop    %ebp
    138b:	c3                   	ret    
    138c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1390:	39 c2                	cmp    %eax,%edx
    1392:	72 c4                	jb     1358 <free+0x18>
    1394:	39 c1                	cmp    %eax,%ecx
    1396:	73 c0                	jae    1358 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
    1398:	8b 73 fc             	mov    -0x4(%ebx),%esi
    139b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    139e:	39 f8                	cmp    %edi,%eax
    13a0:	75 d0                	jne    1372 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
    13a2:	03 70 04             	add    0x4(%eax),%esi
    13a5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    13a8:	8b 02                	mov    (%edx),%eax
    13aa:	8b 00                	mov    (%eax),%eax
    13ac:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
    13af:	8b 42 04             	mov    0x4(%edx),%eax
    13b2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
    13b5:	39 f1                	cmp    %esi,%ecx
    13b7:	75 c6                	jne    137f <free+0x3f>
    p->s.size += bp->s.size;
    13b9:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
    13bc:	89 15 04 1d 00 00    	mov    %edx,0x1d04
    p->s.size += bp->s.size;
    13c2:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
    13c5:	8b 4b f8             	mov    -0x8(%ebx),%ecx
    13c8:	89 0a                	mov    %ecx,(%edx)
}
    13ca:	5b                   	pop    %ebx
    13cb:	5e                   	pop    %esi
    13cc:	5f                   	pop    %edi
    13cd:	5d                   	pop    %ebp
    13ce:	c3                   	ret    
    13cf:	90                   	nop

000013d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    13d0:	55                   	push   %ebp
    13d1:	89 e5                	mov    %esp,%ebp
    13d3:	57                   	push   %edi
    13d4:	56                   	push   %esi
    13d5:	53                   	push   %ebx
    13d6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    13d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    13dc:	8b 3d 04 1d 00 00    	mov    0x1d04,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    13e2:	8d 70 07             	lea    0x7(%eax),%esi
    13e5:	c1 ee 03             	shr    $0x3,%esi
    13e8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    13eb:	85 ff                	test   %edi,%edi
    13ed:	0f 84 9d 00 00 00    	je     1490 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    13f3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
    13f5:	8b 4a 04             	mov    0x4(%edx),%ecx
    13f8:	39 f1                	cmp    %esi,%ecx
    13fa:	73 6a                	jae    1466 <malloc+0x96>
    13fc:	bb 00 10 00 00       	mov    $0x1000,%ebx
    1401:	39 de                	cmp    %ebx,%esi
    1403:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    1406:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
    140d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    1410:	eb 17                	jmp    1429 <malloc+0x59>
    1412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1418:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    141a:	8b 48 04             	mov    0x4(%eax),%ecx
    141d:	39 f1                	cmp    %esi,%ecx
    141f:	73 4f                	jae    1470 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1421:	8b 3d 04 1d 00 00    	mov    0x1d04,%edi
    1427:	89 c2                	mov    %eax,%edx
    1429:	39 d7                	cmp    %edx,%edi
    142b:	75 eb                	jne    1418 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
    142d:	83 ec 0c             	sub    $0xc,%esp
    1430:	ff 75 e4             	push   -0x1c(%ebp)
    1433:	e8 93 fc ff ff       	call   10cb <sbrk>
  if(p == (char*)-1)
    1438:	83 c4 10             	add    $0x10,%esp
    143b:	83 f8 ff             	cmp    $0xffffffff,%eax
    143e:	74 1c                	je     145c <malloc+0x8c>
  hp->s.size = nu;
    1440:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    1443:	83 ec 0c             	sub    $0xc,%esp
    1446:	83 c0 08             	add    $0x8,%eax
    1449:	50                   	push   %eax
    144a:	e8 f1 fe ff ff       	call   1340 <free>
  return freep;
    144f:	8b 15 04 1d 00 00    	mov    0x1d04,%edx
      if((p = morecore(nunits)) == 0)
    1455:	83 c4 10             	add    $0x10,%esp
    1458:	85 d2                	test   %edx,%edx
    145a:	75 bc                	jne    1418 <malloc+0x48>
        return 0;
  }
}
    145c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    145f:	31 c0                	xor    %eax,%eax
}
    1461:	5b                   	pop    %ebx
    1462:	5e                   	pop    %esi
    1463:	5f                   	pop    %edi
    1464:	5d                   	pop    %ebp
    1465:	c3                   	ret    
    if(p->s.size >= nunits){
    1466:	89 d0                	mov    %edx,%eax
    1468:	89 fa                	mov    %edi,%edx
    146a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
    1470:	39 ce                	cmp    %ecx,%esi
    1472:	74 4c                	je     14c0 <malloc+0xf0>
        p->s.size -= nunits;
    1474:	29 f1                	sub    %esi,%ecx
    1476:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    1479:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    147c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
    147f:	89 15 04 1d 00 00    	mov    %edx,0x1d04
}
    1485:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    1488:	83 c0 08             	add    $0x8,%eax
}
    148b:	5b                   	pop    %ebx
    148c:	5e                   	pop    %esi
    148d:	5f                   	pop    %edi
    148e:	5d                   	pop    %ebp
    148f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
    1490:	c7 05 04 1d 00 00 08 	movl   $0x1d08,0x1d04
    1497:	1d 00 00 
    base.s.size = 0;
    149a:	bf 08 1d 00 00       	mov    $0x1d08,%edi
    base.s.ptr = freep = prevp = &base;
    149f:	c7 05 08 1d 00 00 08 	movl   $0x1d08,0x1d08
    14a6:	1d 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    14a9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
    14ab:	c7 05 0c 1d 00 00 00 	movl   $0x0,0x1d0c
    14b2:	00 00 00 
    if(p->s.size >= nunits){
    14b5:	e9 42 ff ff ff       	jmp    13fc <malloc+0x2c>
    14ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    14c0:	8b 08                	mov    (%eax),%ecx
    14c2:	89 0a                	mov    %ecx,(%edx)
    14c4:	eb b9                	jmp    147f <malloc+0xaf>
