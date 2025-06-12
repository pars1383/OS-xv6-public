#include "types.h"
#include "stat.h"
#include "user.h"

#define ARRAY_SIZE 10
#define INCREMENTS 1000

int
main(void)
{
  int shmem_id = 2;
  int *arr = (int*)open_shared_mem(shmem_id);
  if (!arr) {
    printf(1, "open_shared_mem failed\n");
    exit();
  }

  // Initialize array
  for (int i = 0; i < ARRAY_SIZE; i++) {
    arr[i] = 0;
  }

  int pid = fork();
  if (pid < 0) {
    printf(1, "fork failed\n");
    close_shared_mem(shmem_id);
    exit();
  }

  for (int i = 0; i < INCREMENTS; i++) {
    for (int j = 0; j < ARRAY_SIZE; j++) {
      arr[j]++;
    }
  }

  if (pid > 0) {
    wait();
    printf(1, "No-monitor test results:\n");
    for (int i = 0; i < ARRAY_SIZE; i++) {
      printf(1, "Element %d: %d\n", i, arr[i]);
    }
    close_shared_mem(shmem_id);
  }

  exit();
}