#include "syscall.h"
#include "traps.h"

#define SYSCALL(name) \
  .globl name; \
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
SYSCALL(exit)
SYSCALL(wait)
SYSCALL(pipe)
SYSCALL(read)
SYSCALL(write)
SYSCALL(close)
SYSCALL(kill)
SYSCALL(exec)
SYSCALL(open)
SYSCALL(mknod)
SYSCALL(unlink)
SYSCALL(fstat)
SYSCALL(link)
SYSCALL(mkdir)
SYSCALL(chdir)
SYSCALL(dup)
SYSCALL(getpid)
SYSCALL(sbrk)
SYSCALL(sleep)
SYSCALL(uptime)
SYSCALL(next_palindrome)
SYSCALL(make_user_syscall)
SYSCALL(login_syscall)
SYSCALL(logout_syscall) 
SYSCALL(get_logs_syscall)
SYSCALL(set_sleep)
SYSCALL(cmostime)
SYSCALL(diff_syscall)
SYSCALL(print_info)
SYSCALL(change_queue)
SYSCALL(create_realtime_process)
