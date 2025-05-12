#include "types.h"
#include "stat.h"
#include "user.h"

int main(void) {
  printf(1, "\n=== TEST: create_realtime_process ===\n");
  int deadline = 50;
  int pid = create_realtime_process(deadline);  // حتماً deadline رو پاس بده
  if (pid < 0) {
    printf(1, "FAILED: Could not create realtime process\n");
  } else if (pid == 0) {
    // داخل بچه (real-time)
    printf(1, "SUCCESS: I am Real-Time Child with deadline %d\n", deadline);
    for (int i = 0; i < 3; i++) {
      printf(1, "Real-Time Child running... tick %d\n", i);
      sleep(10);
    }
    printf(1, "Real-Time Child exiting...\n");
    exit();
  } else {
    // داخل پدر
    printf(1, "Parent created Real-Time Child PID %d\n", pid);
    wait();
  }

  printf(1, "\n=== TEST: change_queue ===\n");
  int self_pid = getpid();
  if (change_queue(self_pid, 1) == 0) {  // تغییر صف به RR
    printf(1, "SUCCESS: Changed queue to RR for PID %d\n", self_pid);
  } else {
    printf(1, "FAILED: Could not change queue\n");
  }

  printf(1, "\n=== TEST: print_info ===\n");
  print_info();  // نمایش وضعیت همه پردازه‌ها

  printf(1, "\nAll tests done.\n");
  exit();
}
