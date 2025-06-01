#ifndef SEMAPHORE_H
#define SEMAPHORE_H

#include "spinlock.h"

struct semaphore {
  int value;      
  struct spinlock lock; 
};

void sem_init(struct semaphore *sem, int value);
void sem_wait(struct semaphore *sem);
void sem_signal(struct semaphore *sem);

#endif