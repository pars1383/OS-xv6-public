#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]) {
  if (argc != 3) {
    printf(1, "Usage: login <uid> <password>\n");
    exit();
  }
  int uid = atoi(argv[1]);
  int result = login_syscall(uid, argv[2]);
  if (result == 0) {
    printf(1, "Logged in as UID %d\n", uid);
  }
  exit();
}