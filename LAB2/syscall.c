#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "syscall.h"

int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
  if (addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
  *ip = *(int*)(addr);
  return 0;
}

int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;
  struct proc *curproc = myproc();
  if (addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for (s = *pp; s < ep; s++) {
    if (*s == 0)
      return s - *pp;
  }
  return -1;
}

int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}

int
argptr(int n, char **pp, int size)
{
  int i;
  struct proc *curproc = myproc();
  if (argint(n, &i) < 0)
    return -1;
  if (size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
  *pp = (char*)i;
  return 0;
}

int
argstr(int n, char **pp)
{
  int addr;
  if (argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}

extern int sys_chdir(void);
extern int sys_close(void);
extern int sys_dup(void);
extern int sys_exec(void);
extern int sys_exit(void);
extern int sys_fork(void);
extern int sys_fstat(void);
extern int sys_getpid(void);
extern int sys_kill(void);
extern int sys_link(void);
extern int sys_mkdir(void);
extern int sys_mknod(void);
extern int sys_open(void);
extern int sys_pipe(void);
extern int sys_read(void);
extern int sys_sbrk(void);
extern int sys_sleep(void);
extern int sys_unlink(void);
extern int sys_wait(void);
extern int sys_write(void);
extern int sys_uptime(void);
extern int sys_next_palindrome(void);
extern int sys_make_user_syscall(void);
extern int sys_login_syscall(void);
extern int sys_logout_syscall(void);
extern int sys_get_logs_syscall(void);
extern int sys_diff_syscall(void);

extern int current_logged_in_uid;
extern struct user_syscall_logs user_syscall_logs[MAX_USERS];

static int (*syscalls[])(void) = {
  [SYS_fork]    sys_fork,
  [SYS_exit]    sys_exit,
  [SYS_wait]    sys_wait,
  [SYS_pipe]    sys_pipe,
  [SYS_read]    sys_read,
  [SYS_kill]    sys_kill,
  [SYS_exec]    sys_exec,
  [SYS_fstat]   sys_fstat,
  [SYS_chdir]   sys_chdir,
  [SYS_dup]     sys_dup,
  [SYS_getpid]  sys_getpid,
  [SYS_sbrk]    sys_sbrk,
  [SYS_sleep]   sys_sleep,
  [SYS_uptime]  sys_uptime,
  [SYS_open]    sys_open,
  [SYS_write]   sys_write,
  [SYS_mknod]   sys_mknod,
  [SYS_unlink]  sys_unlink,
  [SYS_link]    sys_link,
  [SYS_mkdir]   sys_mkdir,
  [SYS_close]   sys_close,
  [SYS_next_palindrome] sys_next_palindrome,
  [SYS_make_user_syscall] sys_make_user_syscall,
  [SYS_login_syscall]    sys_login_syscall,
  [SYS_logout_syscall]   sys_logout_syscall,
  [SYS_get_logs_syscall] sys_get_logs_syscall,
  [SYS_diff_syscall] sys_diff_syscall,
};

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();

  num = curproc->tf->eax;
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
    if (current_logged_in_uid != 0 && (num == SYS_next_palindrome || num == SYS_get_logs_syscall)) {
      for (int i = 0; i < MAX_USERS; i++) {
        if (user_syscall_logs[i].uid == current_logged_in_uid) {
          if (user_syscall_logs[i].syscall_count < MAX_SYSCALLS) {
            user_syscall_logs[i].syscalls[user_syscall_logs[i].syscall_count++] = num;
          }
          break;
        } else if (user_syscall_logs[i].uid == 0) {
          user_syscall_logs[i].uid = current_logged_in_uid;
          user_syscall_logs[i].syscalls[0] = num;
          user_syscall_logs[i].syscall_count = 1;
          break;
        }
      }
    }
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}

static int is_palindrome(int n) {
  int rev = 0, orig = n;
  while (n > 0) {
    rev = rev * 10 + n % 10;
    n /= 10;
  }
  return rev == orig;
}

int
sys_next_palindrome(void) {
  int num;
  if (argint(0, &num) < 0) return -1;
  if (is_palindrome(num)) {
    cprintf("%d\n", num);
    return num;
  }
  while (!is_palindrome(++num));
  cprintf("%d\n", num);
  return num;
}

static int strcmp(const char *s1, const char *s2) {
  while (*s1 && *s1 == *s2) {
    s1++;
    s2++;
  }
  return *s1 - *s2;
}

static int next_uid = 1;

int
sys_make_user_syscall(void)
{
  int uid;
  char *password;
  struct proc *curproc = myproc();

  if (argint(0, &uid) < 0 || argstr(1, &password) < 0) {
    cprintf("Invalid arguments\n");
    return -1;
  }
  if (uid <= 0) {
    cprintf("UID must be positive\n");
    return -1;
  }
  for (int i = 0; i < MAX_USERS; i++) {
    if (user_credentials[i].uid == uid) {
      cprintf("UID %d already exists\n", uid);
      return -1;
    }
  }
  for (int i = 0; i < MAX_USERS; i++) {
    if (user_credentials[i].uid == 0) {
      user_credentials[i].uid = uid;
      safestrcpy(user_credentials[i].password, password, PASSWORD_LEN);
      curproc->uid = uid;
      cprintf("Debug: make_user_syscall, UID %d created\n", uid);
      if (uid >= next_uid) next_uid = uid + 1;
      return uid;
    }
  }
  cprintf("No space for new user\n");
  return -1;
}

int
sys_login_syscall(void)
{
  int uid;
  char *password;
  struct proc *curproc = myproc();

  if (argint(0, &uid) < 0 || argstr(1, &password) < 0) {
    cprintf("Invalid arguments\n");
    return -1;
  }
  if (current_logged_in_uid != 0 && current_logged_in_uid != uid) {
    cprintf("Another user (UID %d) is already logged in\n", current_logged_in_uid);
    return -1;
  }
  for (int i = 0; i < MAX_USERS; i++) {
    if (user_credentials[i].uid == uid) {
      if (strncmp(user_credentials[i].password, password, PASSWORD_LEN) == 0) {
        if (!curproc->logged_in) {
          curproc->logged_in = 1;
          curproc->uid = uid;
        }
        current_logged_in_uid = uid;
        cprintf("Debug: login_syscall, UID %d logged in\n", uid);
        return 0;
      } else {
        cprintf("Authentication failed for UID %d\n", uid);
        return -1;
      }
    }
  }
  cprintf("UID %d not found\n", uid);
  return -1;
}

int
sys_logout_syscall(void)
{
  int uid;
  struct proc *curproc = myproc();

  if (argint(0, &uid) < 0) {
    cprintf("Invalid argument\n");
    return -1;
  }
  if (current_logged_in_uid == uid) {
    current_logged_in_uid = 0;
    curproc->logged_in = 0;
    curproc->uid = 0;
    cprintf("Debug: logout_syscall, UID %d logged out\n", uid);
    cprintf("UID %d logged out\n", uid);
    return 0;
  } else {
    cprintf("Logout failed: UID %d not logged in\n", uid);
    return -1;
  }
}

int
sys_get_logs_syscall(void)
{
  struct proc *curproc = myproc();

  if (current_logged_in_uid != 0) {
    cprintf("Logs for UID %d (PID %d):\n", current_logged_in_uid, curproc->pid);
    for (int i = 0; i < MAX_USERS; i++) {
      if (user_syscall_logs[i].uid == current_logged_in_uid) {
        if (user_syscall_logs[i].syscall_count == 0) {
          cprintf("No system calls logged\n");
        } else {
          for (int j = 0; j < user_syscall_logs[i].syscall_count; j++) {
            cprintf("%d\n", user_syscall_logs[i].syscalls[j]);
          }
        }
        return 0;
      }
    }
    cprintf("No logs found for UID %d\n", current_logged_in_uid);
  } else {
    cprintf("Logs for all users (not logged in):\n");
    print_all_user_logs();
  }
  return 0;
}