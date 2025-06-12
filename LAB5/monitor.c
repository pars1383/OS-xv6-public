#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"
#include "shmem.h"
#include "monitor.h"

struct monitor monitors[MAX_SHMEM];

void
monitor_init_sys(void)
{
  cprintf("monitor_init_sys: initializing monitors\n");
  for (int i = 0; i < MAX_SHMEM; i++) {
    initlock(&monitors[i].lock, "monitor_lock");
    monitors[i].id = -1;
    monitors[i].addr = 0;
    monitors[i].size = 0;
  }
}

int
sys_monitor_init(void)
{
  int id, *initial_value, size_value;
  if (argint(0, &id) < 0 || argptr(1, (void*)&initial_value, sizeof(*initial_value)) < 0 || argint(2, &size_value) < 0) {
    cprintf("sys_monitor_init: invalid arguments\n");
    return -1;
  }

  if (size_value * sizeof(int) > PGSIZE) {
    cprintf("sys_monitor_init: array size %d exceeds PGSIZE\n", size_value);
    return -1;
  }

  for (int i = 0; i < MAX_SHMEM; i++) {
    acquire(&monitors[i].lock);
    if (monitors[i].id == id) {
      release(&monitors[i].lock);
      cprintf("sys_monitor_init: shared memory ID %d already in use\n", id);
      return -1;
    }
    release(&monitors[i].lock);
  }

  char *mem = open_shared_mem(id);
  if (!mem) {
    cprintf("sys_monitor_init: open_shared_mem failed for id %d\n", id);
    return -1;
  }

  char *kernel_addr = get_shmem_kernel_addr(id);
  if (!kernel_addr) {
    close_shared_mem(id);
    cprintf("sys_monitor_init: get_shmem_kernel_addr failed for id %d\n", id);
    return -1;
  }

  for (int i = 0; i < MAX_SHMEM; i++) {
    acquire(&monitors[i].lock);
    if (monitors[i].id == -1) {
      monitors[i].id = id;
      monitors[i].addr = kernel_addr;
      monitors[i].size = size_value * sizeof(int);
      memmove(monitors[i].addr, initial_value, monitors[i].size);
      if (copyout(myproc()->pgdir, (uint)mem, monitors[i].addr, monitors[i].size) < 0) {
        monitors[i].id = -1;
        monitors[i].addr = 0;
        monitors[i].size = 0;
        release(&monitors[i].lock);
        close_shared_mem(id);
        cprintf("sys_monitor_init: copyout failed for va=0x%x\n", mem);
        return -1;
      }
      release(&monitors[i].lock);
      cprintf("sys_monitor_init: success, id=%d, kernel_addr=0x%x, size=%d\n", id, kernel_addr, monitors[i].size);
      return 0;
    }
    release(&monitors[i].lock);
  }
  close_shared_mem(id);
  cprintf("sys_monitor_init: no free monitor entries for id %d\n", id);
  return -1;
}

int
sys_monitor_increase_all_elems(void)
{
  int id;
  if (argint(0, &id) < 0) {
    cprintf("sys_monitor_increase: invalid id\n");
    return -1;
  }

  for (int i = 0; i < MAX_SHMEM; i++) {
    acquire(&monitors[i].lock);
    if (monitors[i].id == id) {
      int *arr = (int*)monitors[i].addr;
      int n = monitors[i].size / sizeof(int);
      for (int j = 0; j < n; j++) {
        arr[j]++;
      }
      char *user_addr = open_shared_mem(id);
      if (user_addr) {
        if (copyout(myproc()->pgdir, (uint)user_addr, monitors[i].addr, monitors[i].size) < 0) {
          cprintf("sys_monitor_increase: copyout failed for va=0x%x\n", user_addr);
        }
        close_shared_mem(id);
      }
      release(&monitors[i].lock);
      cprintf("sys_monitor_increase: id=%d, incremented %d elements\n", id, n);
      return 0;
    }
    release(&monitors[i].lock);
  }
  cprintf("sys_monitor_increase: no monitor for id %d\n", id);
  return -1;
}

int
sys_monitor_close_shared_mem(void)
{
  int id;
  if (argint(0, &id) < 0) {
    cprintf("sys_monitor_close: invalid id\n");
    return -1;
  }

  for (int i = 0; i < MAX_SHMEM; i++) {
    acquire(&monitors[i].lock);
    if (monitors[i].id == id) {
      monitors[i].id = -1;
      monitors[i].addr = 0;
      monitors[i].size = 0;
      release(&monitors[i].lock);
      cprintf("sys_monitor_close: id=%d\n", id);
      return close_shared_mem(id);
    }
    release(&monitors[i].lock);
  }
  cprintf("sys_monitor_close: no monitor for id %d\n", id);
  return -1;
}

int
sys_monitor_read_shared_mem(void)
{
  int id, *data;
  if (argint(0, &id) < 0 || argptr(1, (void*)&data, sizeof(*data)) < 0) {
    cprintf("sys_monitor_read: invalid arguments\n");
    return -1;
  }

  for (int i = 0; i < MAX_SHMEM; i++) {
    acquire(&monitors[i].lock);
    if (monitors[i].id == id) {
      memmove(data, monitors[i].addr, monitors[i].size);
      release(&monitors[i].lock);
      cprintf("sys_monitor_read: id=%d, size=%d\n", id, monitors[i].size);
      return 0;
    }
    release(&monitors[i].lock);
  }
  cprintf("sys_monitor_read: no monitor for id %d\n", id);
  return -1;
}