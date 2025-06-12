#ifndef _MONITOR_H_
#define _MONITOR_H_

struct monitor {
  struct spinlock lock;
  int id;          // Shared memory ID
  char *addr;      // Shared memory address
  int size;        // Size of the array (in bytes)
};

void monitor_init_sys(void);
int sys_monitor_init(void);
int sys_monitor_increase_all_elems(void);
int sys_monitor_close_shared_mem(void);
int sys_monitor_read_shared_mem(void);

#endif