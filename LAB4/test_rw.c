#include "user.h"
#include "stdio.h"

int main(void) {
  printf(1, "Initializing rw_lock...\n");
  init_rw_lock();
  printf(1, "Done.\n");
  exit();
}