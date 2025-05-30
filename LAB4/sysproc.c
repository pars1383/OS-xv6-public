#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "sleeplock.h"


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


struct {
  struct semaphore sems[6]; // 0: barber, 1: chair, 2: mutex, 3: customers, 4: waiting, 5: service
} barber_state;

int
sys_init_barber(void)
{
  sem_init(&barber_state.sems[0], 0); // Barber
  sem_init(&barber_state.sems[1], 1); // Chair (1 available)
  sem_init(&barber_state.sems[2], 1); // Mutex
  sem_init(&barber_state.sems[3], 0); // Customers
  sem_init(&barber_state.sems[4], 5); // Waiting chairs (5 available)
  sem_init(&barber_state.sems[5], 0); // Service
  return 0;
}

int
sys_barber_sleep(void)
{
  sem_wait(&barber_state.sems[2]); // Acquire mutex
  if (barber_state.sems[3].value == 0) { // No customers
    sem_signal(&barber_state.sems[2]); // Release mutex
    sem_wait(&barber_state.sems[0]); // Barber sleeps
  } else {
    sem_signal(&barber_state.sems[2]); // Release mutex
  }
  return 0;
}

int
sys_customer_arr(void)
{
  sem_wait(&barber_state.sems[2]); // Acquire mutex
  if (barber_state.sems[4].value > 0) { // Check for available chairs
    sem_wait(&barber_state.sems[4]); // Occupy a chair
    sem_signal(&barber_state.sems[3]); // Increment customers
    sem_signal(&barber_state.sems[2]); // Release mutex
    sem_signal(&barber_state.sems[0]); // Wake barber if sleeping
    sem_wait(&barber_state.sems[1]); // Wait for chair
    sem_wait(&barber_state.sems[5]); // Wait for service
  } else {
    sem_signal(&barber_state.sems[2]); // Release mutex, no chairs, leave
    return -1;
  }
  return 0;
}

int
sys_cut_hair(void)
{
  sem_wait(&barber_state.sems[2]); // Acquire mutex
  sem_wait(&barber_state.sems[3]); // Wait for a customer
  sem_signal(&barber_state.sems[1]); // Free the chair
  sem_signal(&barber_state.sems[5]); // Signal service
  sem_signal(&barber_state.sems[4]); // Free a waiting chair
  sem_signal(&barber_state.sems[2]); // Release mutex
  return 0;
}