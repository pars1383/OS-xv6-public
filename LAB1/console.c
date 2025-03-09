// Console input and output.
// Input is from the keyboard or serial port.
// Output is written to the screen and serial port.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "traps.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#define SELECT_BUF_SIZE 128
#define LEFT_ARROW  228
#define RIGHT_ARROW 229
//#include "command_history.h" 

#define INPUT_BUF 128
#define MAX_COMMANDS 10
#define MAX_COMMAND_LENGTH 100


static char select_buffer[SELECT_BUF_SIZE];  // Buffer for copied text
static int selecting = 0;   // Selection mode flag
static int select_start = -1; // Start index of selection
static int select_end = -1;   // End index of selection

static void consputc(int);

static int panicked = 0;


struct Input {
  char buf[INPUT_BUF];
  uint r;  // Read index
  uint w;  // Write index
  uint e;  // Edit index
} input;


struct CommandHistory {
  struct Input commands[MAX_COMMANDS]; // Buffer to store commands
  int count; // Number of commands stored
  int index; // Index for circular buffer
};

static struct {
  struct spinlock lock;
  int locking;
} cons;

struct CommandHistory command_history = {.index = -1 , .count = 0}; // Declare an instance of the struct

static void print_history(){


    release(&cons.lock);
    if(command_history.count < 5)
      for (int i = 0; i < command_history.count; i++)
      {
        cprintf(&command_history.commands[i].buf[command_history.commands[i].r]);
        //cprintf("if");
      }
    else
      for (int i = command_history.count - 5; i < command_history.count; i++)
      {
        cprintf(&command_history.commands[i].buf[command_history.commands[i].r]);
        //cprintf("else");
      }
    
    
    acquire(&cons.lock);

  
}


static void shift_left_previous_histories(){
  for (int i = 0; i < 9; i++) {
    command_history.commands[i] =  command_history.commands[i+1]; 
  }
}

static void try_match_history(){

  for (int i = 0; i < command_history.count; i++)
  {
    int flag = 1;
    int k = command_history.commands[i].r;
    int j;
    for(j = input.r ; j < input.e; j++, k++){

      if(input.buf[j] != command_history.commands[i].buf[k]){
        flag = 0;
      }
    }
    if(flag == 1){
      for(; k < command_history.commands[i].e - 1; j++, k++){
        input.buf[input.e++ % INPUT_BUF] = command_history.commands[i].buf[k];
        consputc(command_history.commands[i].buf[k]);
      }
      return;
    }
  }
}

static void
printint(int xx, int base, int sign)
{
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
    consputc(buf[i]);
}
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c);
      break;
    }
  }

  if(locking)
    release(&cons.lock);
}

void
panic(char *s)
{
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
  for(;;)
    ;
}

//PAGEBREAK: 50
#define BACKSPACE 0x100
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  }

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
  if(panicked){
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}


#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;
  static char input_buf[INPUT_BUF]; // Buffer for the current input line
  static int input_pos = 0; // Current position in the input buffer

  acquire(&cons.lock);

  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'):   // ctr+H
        print_history();
    break;

    case C('C'):  // CTRL+C pressed
      if (!selecting) {
        // Start selection mode
        selecting = 1;
        select_start = input.e;  // Use current input position
        
      } else {
        // End selection and copy text
        selecting = 0;
        select_end = input.e;
        int len = select_end - select_start ;
        if (-len > 0 && -len < SELECT_BUF_SIZE) {
          memmove(select_buffer, input.buf + select_start, len);
          select_buffer[len] = '\0';
        }
        select_start = select_end = -1;  // Reset selection
      }
    break;

    case C('V'):  // CTRL+V pressed (paste)
      for (int i = 0; select_buffer[i] != '\0'; i++) {
        if (input.e - input.w < INPUT_BUF) { // Ensure buffer limit
          input.buf[input.e++ % INPUT_BUF] = select_buffer[i];
          consputc(select_buffer[i]);
        }
      }
    break;
    case (LEFT_ARROW):  // Move cursor left
    if (input.e != input.w) {
      input.e--;
      uartputc('\b');  // Move cursor visually
    }
    break;

    case(RIGHT_ARROW):  // Move cursor right
      if (input.e < input.w) {
        uartputc(input.buf[input.e % INPUT_BUF]);
        cgaputc(input.buf[input.e % INPUT_BUF]);
        input.e++;
      }
      break;
      
    case ('\t'):
      try_match_history();
    break;
    
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input_buf[input_pos++] = c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input_buf[input_pos] = '\0'; // Null-terminate the input line

          // Store the command in history
          if (command_history.count == 10)
             shift_left_previous_histories();

          if(command_history.count < 10){
             command_history.count ++;
             command_history.index ++ ;
           }
         
         
          command_history.commands[command_history.index] = input;
          input.w = input.e;
          wakeup(&input.r);
        }
      }
      break;
    }
  }

  release(&cons.lock);
  
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
  uint target;
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
    consputc(buf[i] & 0xff);
  release(&cons.lock);
  ilock(ip);

  return n;
}

void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
}