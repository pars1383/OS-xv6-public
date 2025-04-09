#include "types.h"
#include "user.h"

int main(int argc, char *argv[]) {
  if (argc != 2) {
    printf(1, "Usage: login <uid>\n");
    exit();
  }
  int uid = atoi(argv[1]);
  login_syscall(uid);
  exit();
}