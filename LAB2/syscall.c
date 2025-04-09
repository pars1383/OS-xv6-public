#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "syscall.h"

// User code makes a system call with INT T_SYSCALL.
// System call number in %eax.
// Arguments on the stack, from the user call to the C
// library system call function. The saved user %esp points
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
  *ip = *(int*)(addr);
  return 0;
}

// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}

// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
  int i;
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
  *pp = (char*)i;
  return 0;
}

// Fetch the nth word-sized system call argument as a string pointer.
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
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

[SYS_next_palindrome] sys_next_palindrome,
[SYS_next_palindrome] sys_next_palindrome,
[SYS_make_user_syscall] sys_make_user_syscall,  
[SYS_login_syscall]    sys_login_syscall,      
[SYS_logout_syscall]   sys_logout_syscall,     
[SYS_get_logs_syscall] sys_get_logs_syscall,   
};

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
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

int sys_next_palindrome(void) {
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



static int next_uid = 1;

int sys_make_user_syscall(void) {
  struct proc *curproc = myproc();
  cprintf("Debug: make_user_syscall, PID %d, current UID = %d\n", curproc->pid, curproc->uid);
  if (curproc->uid != 0) {
    cprintf("Process already has UID %d\n", curproc->uid);
    return -1;
  }
  curproc->uid = next_uid++;
  cprintf("%d\n", curproc->uid);
  return curproc->uid;
}

int sys_login_syscall(void) {
  int uid;
  if (argint(0, &uid) < 0) {
    cprintf("Invalid UID argument\n");
    return -1;
  }
  struct proc *curproc = myproc();
  struct proc *parent = curproc->parent;
  cprintf("Debug: login_syscall, PID %d, requested UID %d, current UID %d, logged_in %d, parent PID %d\n", 
          curproc->pid, uid, curproc->uid, curproc->logged_in, parent->pid);
  if (uid <= 0 || uid >= next_uid) {
    cprintf("Invalid UID %d\n", uid);
    return -1;
  }
  for(int i = 0; i < MAX_USERS; i++) {
    if (logged_in_uids[i] == uid) {
      cprintf("UID %d already logged in\n", uid);
      return -1;
    }
  }
  for(int i = 0; i < MAX_USERS; i++) {
    if (logged_in_uids[i] == 0) {
      logged_in_uids[i] = uid;
      parent->uid = uid;
      parent->logged_in = 1;
      cprintf("UID %d logged in\n", uid);
      return 0;
    }
  }
  cprintf("No space to log in UID %d\n", uid);
  return -1;
}

int sys_logout_syscall(void) {
  int uid;
  if (argint(0, &uid) < 0) {
    cprintf("Invalid UID argument\n");
    return -1;
  }
  struct proc *curproc = myproc();
  cprintf("Debug: logout_syscall, PID %d, requested UID %d, current UID %d, logged_in %d\n", 
          curproc->pid, uid, curproc->uid, curproc->logged_in);
  if (curproc->uid != uid || !curproc->logged_in) {
    cprintf("UID %d not logged in or not assigned\n", uid);
    return -1;
  }
  for(int i = 0; i < MAX_USERS; i++) {
    if (logged_in_uids[i] == uid) {
      logged_in_uids[i] = 0;
      curproc->logged_in = 0;
      cprintf("UID %d logged out\n", uid);
      return 0;
    }
  }
  cprintf("UID %d not found in logged-in list\n", uid);
  return -1;
}

int sys_get_logs_syscall(void) {
  struct proc *curproc = myproc();
  cprintf("Debug: get_logs_syscall, PID %d, UID %d, logged_in %d, syscall_count %d\n", 
          curproc->pid, curproc->uid, curproc->logged_in, curproc->syscall_count);
  if (!curproc->logged_in) {
    cprintf("Not logged in\n");
    return -1;
  }
  cprintf("Logs for UID %d (PID %d):\n", curproc->uid, curproc->pid);
  if (curproc->syscall_count == 0) {
    cprintf("No system calls logged\n");
  } else {
    for (int i = 0; i < curproc->syscall_count; i++) {
      cprintf("%d\n", curproc->syscalls[i]);
    }
  }
  return 0;
}