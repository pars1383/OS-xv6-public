#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "shmem.h"

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


int
sys_open_shared_mem(void)
{
  int id;
  if (argint(0, &id) < 0)
    return -1;
  char *addr = open_shared_mem(id);
  if (!addr)
    return -1;
  return (int)addr;
}

int
sys_close_shared_mem(void)
{
  int id;
  if (argint(0, &id) < 0)
    return -1;
  return close_shared_mem(id);
}

int
sys_sync_shared_mem(void)
{
  int id;
  if (argint(0, &id) < 0)
    return -1;
  return sync_shared_mem(id);
}

int
sys_update_shared_mem(void)
{
  int id;
  if (argint(0, &id) < 0)
    return -1;
  return update_shared_mem(id);
}