#ifndef RWLOCK_H
#define RWLOCK_H

#include "spinlock.h"

struct semaphore {
  int value;
  struct spinlock lock;
};

struct rw_lock {
  struct semaphore read_sem;   // قفل برای کنترل ورود خواننده‌ها
  struct semaphore write_sem;  // قفل برای نویسنده‌ها
  int read_count;              // تعداد خواننده‌های فعال
  int write_waiting;          // تعداد نویسنده‌های منتظر
  struct spinlock lock;        // قفل برای محافظت از این ساختار
};

void sem_init(struct semaphore *s, int value);
void sem_wait(struct semaphore *s);
void sem_signal(struct semaphore *s);

#endif