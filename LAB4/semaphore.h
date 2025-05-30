#ifndef SEMAPHORE_H
#define SEMAPHORE_H

#include "spinlock.h"

struct semaphore {
  int value;            // Current value of the semaphore
  struct spinlock lock; // Spinlock to protect semaphore
};

void sem_init(struct semaphore *sem, int value);
void sem_wait(struct semaphore *sem);
void sem_signal(struct semaphore *sem);

#endif