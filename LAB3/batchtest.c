#include "types.h"
#include "stat.h"
#include "user.h"

void compute(void)
{
  for (int i = 0; i < 1000000; i++)
    for (int j = 0; j < 1000; j++)
      asm volatile("nop");
}

int main(void)
{
  printf(1, "Creating processes...\n");

  int pid1 = fork();
  if (pid1 == 0)
  {
    compute();
    exit();
  }

  int pid2 = fork();
  if (pid2 == 0)
  {
    compute();
    exit();
  }

  int pid3 = create_realtime_process(50);
  if (pid3 == 0)
  {
    compute();
    exit();
  }

  print_info();

  if (change_queue(pid1, 1) < 0)
    printf(1, "Failed to change level for PID %d\n", pid1);

  print_info();

  wait();
  wait();
  wait();

  print_info();

  printf(1, "Test complete\n");
  exit();
}