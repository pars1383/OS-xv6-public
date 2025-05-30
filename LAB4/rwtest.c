#include "types.h"
#include "user.h"

int main(int argc, char *argv[]) {
  if (argc != 2) {
    printf(1, "Usage: rwtest <pattern_number>\n");
    exit();
  }

  int pattern = atoi(argv[1]);
  printf(1, "Initializing reader-writer lock...\n");
  init_rw_lock();

  printf(1, "Running get_rw_pattern(%d)...\n", pattern);
  get_rw_pattern(pattern);

  exit();
}