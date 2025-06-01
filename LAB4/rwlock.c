#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "defs.h"
#include "rwlock.h"

void sem_init(struct semaphore *s, int value) {
  initlock(&s->lock, "sem");
  s->value = value;
}

void sem_wait(struct semaphore *s) {
  acquire(&s->lock);
  while (s->value <= 0) {
    sleep(s, &s->lock);
  }
  s->value--;
  release(&s->lock);
}

void sem_signal(struct semaphore *s) {
  acquire(&s->lock);
  s->value++;
  wakeup(s);
  release(&s->lock);
}

struct rw_lock my_rw_lock;
int shared_value = 0;

void reader(void) {
    sem_wait(&my_rw_lock.read_sem);       
    acquire(&my_rw_lock.lock);             
    my_rw_lock.read_count++;
    if (my_rw_lock.read_count == 1)
      sem_wait(&my_rw_lock.write_sem);     
    release(&my_rw_lock.lock);
    sem_signal(&my_rw_lock.read_sem);
  
    // --- عملیات خواندن ---
    cprintf("Reader: shared_value = %d\n", shared_value);
  
    acquire(&my_rw_lock.lock);
    my_rw_lock.read_count--;
    if (my_rw_lock.read_count == 0)
      sem_signal(&my_rw_lock.write_sem);   
    release(&my_rw_lock.lock);
}
  
  
void writer(void) {
    acquire(&my_rw_lock.lock);
    my_rw_lock.write_waiting++;           
    release(&my_rw_lock.lock);
  
    sem_wait(&my_rw_lock.write_sem);       
  
    
    shared_value++;
    cprintf("Writer: incremented shared_value to %d\n", shared_value);
  
    acquire(&my_rw_lock.lock);
    my_rw_lock.write_waiting--;
    release(&my_rw_lock.lock);
  
    sem_signal(&my_rw_lock.write_sem);     
}