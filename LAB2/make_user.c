#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  if (argc != 3) {
    printf(1, "Usage: make_user <uid> <password>\n");
    exit();
  }

  int uid = atoi(argv[1]);  // Convert UID string to int
  if (uid <= 0) {
    printf(1, "UID must be a positive integer\n");
    exit();
  }

  int result = make_user_syscall(uid, argv[2]);
  if (result >= 0) {
    printf(1, "User created with UID %d\n", result);
  } else {
    printf(1, "Failed to create user\n");
  }
  exit();
}