#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

extern struct rw_lock my_rw_lock;
#include "rwlock.h"

int sys_init_rw_lock(void) {
  sem_init(&my_rw_lock.read_sem, 1);
  sem_init(&my_rw_lock.write_sem, 1);
  my_rw_lock.read_count = 0;
  my_rw_lock.write_waiting = 0;
  initlock(&my_rw_lock.lock, "rwlock");
  return 0;
}


extern void reader(void);
extern void writer(void);

int sys_get_rw_pattern(void) {
  int pattern;
  if (argint(0, &pattern) < 0)
    return -1;

  // پیدا کردن تعداد بیت‌های معنادار
  int highest_bit = -1;
  for (int i = 31; i >= 0; i--) {
    if ((pattern >> i) & 1) {
      highest_bit = i;
      break;
    }
  }

  // فقط بیت‌های معنادار را بررسی کن
  for (int i = 0; i <= highest_bit; i++) {
    int bit = (pattern >> i) & 1;
    if (bit == 0)
      reader();
    else
      writer();
  }

  return 0;
}

	
