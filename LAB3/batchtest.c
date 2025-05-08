#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  int pid = getpid();
  printf("Batch test process starting (PID %d)\n", pid);
  
  for(int i = 0; i < 5; i++){
    printf("Batch test (PID %d) iteration %d\n", pid, i);
    for(int j = 0; j < 1000000; j++); // Simulate work
  }
  
  printf("Batch test process (PID %d) done\n", pid);
  exit();
}