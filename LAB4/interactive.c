#include "types.h"
#include "stat.h"
#include "user.h"

int
main(void)
{
  printf(1, "Starting interactive process (PID %d)\n", getpid());
  for(;;) {
    // Busy loop to consume CPU, should yield after 30ms
    volatile int i;
    for(i = 0; i < 1000000; i++);
    printf(1, "Interactive PID %d running\n", getpid());
  }
  exit();
}