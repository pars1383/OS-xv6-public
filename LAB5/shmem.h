#ifndef SHMEM_H
#define SHMEM_H

#define MAX_SHMEM 10

struct shmem_entry {
  int id;
  char *addr;      // Kernel address of shared page
  char *user_addr; // User virtual address
  int ref_count;
  int in_use;
};

struct shmem_table {
  struct shmem_entry entries[MAX_SHMEM];
};

void shmem_init(void);
char* open_shared_mem(int id);
int sync_shared_mem(int id);
int update_shared_mem(int id);
int close_shared_mem(int id);
char* get_shmem_kernel_addr(int id);

#endif