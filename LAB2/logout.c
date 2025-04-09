#include "types.h"
#include "user.h"

int main(int argc, char *argv[]) {
  if (argc != 2) {
    printf(1, "Usage: logout <uid>\n");
    exit();
  }
  int uid = atoi(argv[1]);
  logout_syscall(uid);
  exit();
}