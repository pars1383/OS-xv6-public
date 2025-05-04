
#include "types.h"
#include "user.h"

int main(void) {
  int uid = make_user_syscall();
  if (uid < 0) {
    printf(1, "Failed to create user\n");
    exit();
  }
  printf(1, "Created user with UID %d\n", uid);

  if (login_syscall(uid) < 0) {
    printf(1, "Login failed\n");
    exit();
  }
  printf(1, "Logged in UID %d\n", uid);

  next_palindrome(123);
  getpid();

  get_logs_syscall();

  if (logout_syscall(uid) < 0) {
    printf(1, "Logout failed\n");
    exit();
  }
  printf(1, "Logged out UID %d\n", uid);

  exit();
}