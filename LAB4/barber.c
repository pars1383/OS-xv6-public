#include "types.h"
#include "stat.h"
#include "user.h"

void
barber(void)
{
  printf(1, "Barber is starting\n");
  while (1) {
    barber_sleep();
    printf(1, "Barber is cutting hair\n");
    cut_hair();
    printf(1, "Barber finished cutting hair\n");
  }
}

void
customer(int id)
{
  printf(1, "Customer %d arrives\n", id);
  if (customer_arr() == 0) {
    printf(1, "Customer %d gets haircut\n", id);
  } else {
    printf(1, "Customer %d leaves (no chairs)\n", id);
  }
  exit();
}

int
main(int argc, char *argv[])
{
  int i;
  init_barber();
  if (fork() == 0) {
    barber();
    exit();
  }
  for (i = 0; i < 10; i++) {
    if (fork() == 0) {
      customer(i + 1);
      exit();
    }
    sleep(10); // Space out customer arrivals
  }
  for (i = 0; i < 10; i++) {
    wait();
  }
  exit();
}