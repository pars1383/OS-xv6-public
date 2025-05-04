#include "types.h"
#include "user.h"
#include "date.h"

int
main(int argc, char *argv[])
{
  if(argc != 2) {
    printf(2, "Usage: testsleep ticks\n");
    exit();
  }

  int ticks = atoi(argv[1]);
  if(ticks <= 0) {
    printf(2, "Invalid ticks value\n");
    exit();
  }

  struct rtcdate before;
  if(cmostime(&before) < 0) {
    printf(2, "Failed to read system time\n");
    exit();
  }

  set_sleep(ticks);

  struct rtcdate after;
  if(cmostime(&after) < 0) {
    printf(2, "Failed to read system time\n");
    exit();
  }

  int diff = (after.second + after.minute * 60 + after.hour * 3600) -
             (before.second + before.minute * 60 + before.hour * 3600);

  if(after.day != before.day || after.month != before.month || after.year != before.year) {
    printf(1, "Warning: Date changed, time difference may be inaccurate\n");
  }

  printf(1, "Time difference: %d seconds\n", diff);
  exit();
}