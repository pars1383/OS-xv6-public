#ifndef RWLOCK_H
#define RWLOCK_H

#include "spinlock.h"

struct semaphore {
  int value;
  struct spinlock lock;
};

struct rw_lock {
  struct semaphore read_sem;   
  struct semaphore write_sem;  
  int read_count;              
  int write_waiting;        
  struct spinlock lock;        
};

void sem_init(struct semaphore *s, int value);
void sem_wait(struct semaphore *s);
void sem_signal(struct semaphore *s);

#endif