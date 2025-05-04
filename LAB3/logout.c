#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]) {
  if (argc != 2) {
    printf(1, "Usage: logout <uid>\n");
    exit();
  }
  int uid = atoi(argv[1]);
  int result = logout_syscall(uid);
  if (result == 0) {
    printf(1, "UID %d logged out\n", uid);
  }
  exit();
}