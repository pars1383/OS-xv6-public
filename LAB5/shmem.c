#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "shmem.h"

struct shmem_table shmem_table;

void
shmem_init(void)
{
  cprintf("shmem_init: initializing shared memory table\n");
  for (int i = 0; i < MAX_SHMEM; i++) {
    shmem_table.entries[i].id = -1;
    shmem_table.entries[i].addr = 0;
    shmem_table.entries[i].user_addr = 0;
    shmem_table.entries[i].ref_count = 0;
    shmem_table.entries[i].in_use = 0;
  }
}

static struct shmem_entry*
find_entry(int id)
{
  for (int i = 0; i < MAX_SHMEM; i++) {
    if (shmem_table.entries[i].in_use && shmem_table.entries[i].id == id) {
      return &shmem_table.entries[i];
    }
  }
  return 0;
}

static struct shmem_entry*
find_free_entry(void)
{
  for (int i = 0; i < MAX_SHMEM; i++) {
    if (!shmem_table.entries[i].in_use) {
      return &shmem_table.entries[i];
    }
  }
  return 0;
}

char*
open_shared_mem(int id)
{
  struct shmem_entry *entry = find_entry(id);
  struct proc *curproc = myproc();
  uint oldsz = curproc->sz;

  if (entry) {
    entry->ref_count++;
    curproc->sz = allocuvm(curproc->pgdir, oldsz, oldsz + PGSIZE);
    if (curproc->sz == 0) {
      entry->ref_count--;
      cprintf("open_shared_mem: allocuvm failed for id %d\n", id);
      return 0;
    }
    if (copyout(curproc->pgdir, oldsz, entry->addr, PGSIZE) < 0) {
      entry->ref_count--;
      curproc->sz = deallocuvm(curproc->pgdir, curproc->sz, oldsz);
      cprintf("open_shared_mem: copyout failed for id %d\n", id);
      return 0;
    }
    entry->user_addr = (char*)oldsz;
    cprintf("open_shared_mem: id=%d, va=0x%x, ref_count=%d, pid=%d\n", id, oldsz, entry->ref_count, curproc->pid);
    return (char*)oldsz;
  } else {
    entry = find_free_entry();
    if (!entry) {
      cprintf("open_shared_mem: no free entries\n");
      return 0;
    }
    char *mem = kalloc();
    if (!mem) {
      cprintf("open_shared_mem: kalloc failed\n");
      return 0;
    }
    memset(mem, 0, PGSIZE);
    curproc->sz = allocuvm(curproc->pgdir, oldsz, oldsz + PGSIZE);
    if (curproc->sz == 0) {
      kfree(mem);
      cprintf("open_shared_mem: allocuvm failed for id %d\n", id);
      return 0;
    }
    entry->id = id;
    entry->addr = mem;
    entry->user_addr = (char*)oldsz;
    entry->ref_count = 1;
    entry->in_use = 1;
    cprintf("open_shared_mem: id=%d, va=0x%x, ref_count=%d, pid=%d\n", id, oldsz, entry->ref_count, curproc->pid);
    return (char*)oldsz;
  }
}

int
sync_shared_mem(int id)
{
  struct shmem_entry *entry = find_entry(id);
  if (!entry) {
    cprintf("sync_shared_mem: no entry for id %d\n", id);
    return -1;
  }
  char *temp = kalloc();
  if (!temp) {
    cprintf("sync_shared_mem: kalloc failed\n");
    return -1;
  }
  char *kva = uva2ka(myproc()->pgdir, (char*)PGROUNDDOWN((uint)entry->user_addr));
  if (kva) {
    memmove(temp, kva, PGSIZE);
    memmove(entry->addr, temp, PGSIZE);
    cprintf("sync_shared_mem: updated kernel page for id %d, pid=%d\n", id, myproc()->pid);
  } else {
    cprintf("sync_shared_mem: uva2ka failed for va=0x%x, pid=%d\n", entry->user_addr, myproc()->pid);
  }
  kfree(temp);
  return 0;
}

int
update_shared_mem(int id)
{
  struct shmem_entry *entry = find_entry(id);
  if (!entry) {
    cprintf("update_shared_mem: no entry for id %d\n", id);
    return -1;
  }
  if (copyout(myproc()->pgdir, (uint)entry->user_addr, entry->addr, PGSIZE) < 0) {
    cprintf("update_shared_mem: copyout failed for va=0x%x, pid=%d\n", entry->user_addr, myproc()->pid);
    return -1;
  }
  cprintf("update_shared_mem: updated user page for id %d, pid=%d\n", id, myproc()->pid);
  return 0;
}

char*
get_shmem_kernel_addr(int id)
{
  struct shmem_entry *entry = find_entry(id);
  if (!entry) {
    cprintf("get_shmem_kernel_addr: no entry for id %d\n", id);
    return 0;
  }
  cprintf("get_shmem_kernel_addr: id=%d, addr=0x%x, pid=%d\n", id, entry->addr, myproc()->pid);
  return entry->addr;
}

int
close_shared_mem(int id)
{
  struct shmem_entry *entry = find_entry(id);
  if (!entry) {
    cprintf("close_shared_mem: no entry for id %d\n", id);
    return -1;
  }
  entry->ref_count--;
  cprintf("close_shared_mem: id=%d, ref_count=%d, pid=%d\n", id, entry->ref_count, myproc()->pid);
  if (entry->ref_count == 0) {
    kfree(entry->addr);
    entry->id = -1;
    entry->addr = 0;
    entry->user_addr = 0;
    entry->in_use = 0;
  }
  return 0;
}