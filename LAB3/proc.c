#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "fcntl.h"
#include "fs.h"
#include "file.h"

struct
{
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;
int logged_in_uids[MAX_USERS];
struct user_cred user_credentials[MAX_USERS] = {{0, ""}};
int current_logged_in_uid = 0;
struct user_syscall_logs user_syscall_logs[MAX_USERS] = {{0, {0}, 0}};

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void print_all_user_logs(void)
{
  int found = 0;
  acquire(&ptable.lock);
  for (int i = 0; i < MAX_USERS; i++)
  {
    if (user_syscall_logs[i].uid != 0 && user_syscall_logs[i].syscall_count > 0)
    {
      found = 1;
      cprintf("UID %d:\n", user_syscall_logs[i].uid);
      for (int j = 0; j < user_syscall_logs[i].syscall_count; j++)
      {
        cprintf("%d\n", user_syscall_logs[i].syscalls[j]);
      }
    }
  }
  release(&ptable.lock);
  if (!found)
  {
    cprintf("No system calls logged for any user\n");
  }
}

void pinit(void)
{
  initlock(&ptable.lock, "ptable");
  for (int i = 0; i < MAX_USERS; i++)
    logged_in_uids[i] = 0;
}

// Must be called with interrupts disabled
int cpuid()
{
  return mycpu() - cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu *
mycpu(void)
{
  int apicid, i;

  if (readeflags() & FL_IF)
    panic("mycpu called with interrupts enabled\n");

  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i)
  {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc *
myproc(void)
{
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

// PAGEBREAK: 32
//  Look in the process table for an UNUSED proc.
//  If found, change state to EMBRYO and initialize
//  state required to run in the kernel.
//  Otherwise return 0.
static struct proc *
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if (p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  p->class = 2;         // Default: Normal (Class 2)
  p->level = 2;         // Default: Batch (Level 2)
  p->deadline = 0;      // No deadline by default
  p->wait_ticks = 0;    // Initialize wait time
  p->quantum_ticks = 0; // Initialize quantum ticks
  p->queue_entry_time = ticks;
  p->run_ticks = 0;

  if (p->pid == 1 || strncmp(p->name, "sh", 3) == 0)
  {               // init or shell
    p->level = 1; // Place in Class 2, Level 1 (RR)
  }

  for (int i = 0; i < MAX_SYSCALLS; i++)
  {
    p->syscalls[i] = 0;
  }
  p->uid = 0;
  p->logged_in = 0;
  p->syscall_count = 0;

  release(&ptable.lock);

  // Allocate kernel stack.
  if ((p->kstack = kalloc()) == 0)
  {
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe *)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint *)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context *)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

// PAGEBREAK: 32
//  Set up first user process.
void userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();

  initproc = p;
  if ((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0; // beginning of initcode.S

  p->class = 2; // Normal
  p->level = 1; // Interactive (Level 1)

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if (n > 0)
  {
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  else if (n < 0)
  {
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  if ((np = allocproc()) == 0)
  {
    return -1;
  }

  // Copy process state from proc.
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
  {
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Copy login state
  np->uid = curproc->uid;
  np->logged_in = curproc->logged_in;
  // syscall_count and syscalls remain process-specific, so no copy here

  // Ensure sh remains in Class 2, Level 1
  np->class = curproc->class;
  np->level = curproc->level;
  if (my_strcmp(curproc->name, "init") == 0)
  {
    np->class = 2;
    np->level = 1; // Force sh to be Interactive
  }
  np->wait_ticks = 0;
  np->quantum_ticks = 0;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for (i = 0; i < NOFILE; i++)
    if (curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if (curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for (fd = 0; fd < NOFILE; fd++)
  {
    if (curproc->ofile[fd])
    {
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->parent == curproc)
    {
      p->parent = initproc;
      if (p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();

  acquire(&ptable.lock);
  for (;;)
  {
    // Scan through table looking for exited children.
    havekids = 0;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    {
      if (p->parent != curproc)
        continue;
      havekids = 1;
      if (p->state == ZOMBIE)
      {
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if (!havekids || curproc->killed)
    {
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock); // DOC: wait-sleep
  }
}

// PAGEBREAK: 42
//  Per-CPU process scheduler.
//  Each CPU calls scheduler() after setting itself up.
//  Scheduler never returns.  It loops, doing:
//   - choose a process to run
//   - swtch to start running that process
//   - eventually that process transfers control
//       via swtch back to the scheduler.
void scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
  int quantum = 3; // 30ms ≈ 3 ticks for Interactive

  for (;;)
  {
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);

    // First, check for Class 1 (Real-Time) processes (handled in Class 1 part).
    // For Class 2, prioritize Level 1 (Interactive) over Level 2 (Batch).
    struct proc *selected_proc = 0;
    int found_level1 = 0;


    // Check Class 1: EDF (Real-time)
    int min_score = 2147483647; // Max int
    struct proc *best_p = 0;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    {
      if (p->state != RUNNABLE || p->class != 1)
        continue;
      int score = p->deadline - ticks; // Priority score
      if (score < min_score)
      {
        min_score = score;
        best_p = p;
      }
    }
    selected_proc = best_p;

    // Pass 1: Look for Level 1 (Interactive) processes (Class 2, Level 1)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    {
      if (p->state != RUNNABLE || p->class != 2 || p->level != 1)
        continue;
      selected_proc = p;
      break; // Pick the first Level 1 process (RR)
    }

    // Pass 2: If no Level 1 process, look for Level 2 (Batch) processes
    if (!found_level1)
    {
      for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
      {
        if (p->state != RUNNABLE || p->class != 2 || p->level != 2)
          continue;
        // Aging: Promote to Level 1 if waiting too long
        if (p->wait_ticks > 800)
        {
          p->level = 1;
          p->wait_ticks = 0;
          p->level = 1;
          p->queue_entry_time = ticks;
          cprintf("Process %d (Batch) promoted to Interactive due to aging\n", p->pid);
          continue;
        }
        selected_proc = p;
        break; // Pick the first Level 2 process (FCFS)
      }
    }

    // Pass 3: Update wait_ticks for aging and promote Level 2 processes if needed
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    {
      if (p->state == RUNNABLE && p->class == 2 && p->level == 2)
      {
        p->wait_ticks++;
        if (p->wait_ticks > 800)
        {                    // 800 ticks = 8 seconds
          p->level = 1;      // Promote to Interactive
          p->wait_ticks = 0; // Reset wait_ticks
          cprintf("Process %d (Batch) promoted to Interactive due to aging\n", p->pid);
        }
      }
    }

    // If a process was selected, run it
    if (selected_proc)
    {
      c->proc = selected_proc;
      switchuvm(selected_proc);
      selected_proc->state = RUNNING;

      // Reset quantum for Level 1 (Interactive) processes
      if (selected_proc->level == 1)
      {
        selected_proc->quantum_ticks = 0; // Reset quantum counter
      }

      swtch(&(c->scheduler), selected_proc->context);
      switchkvm();

      // For Level 1 (Interactive), yield after quantum
      if (selected_proc->state == RUNNING && selected_proc->level == 1 && selected_proc->quantum_ticks >= quantum)
      {
        selected_proc->state = RUNNABLE;
        cprintf("Process %d (Interactive) yielding after 30ms quantum\n", selected_proc->pid);
      }

      c->proc = 0;
    }
    release(&ptable.lock);
  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void sched(void)
{
  int intena;
  struct proc *p = myproc();

  if (!holding(&ptable.lock))
    panic("sched ptable.lock");
  if (mycpu()->ncli != 1)
    panic("sched locks");
  if (p->state == RUNNING)
    panic("sched running");
  if (readeflags() & FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void yield(void)
{
  acquire(&ptable.lock); // DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first)
  {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();

  if (p == 0)
    panic("sleep");

  if (lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if (lk != &ptable.lock)
  {                        // DOC: sleeplock0
    acquire(&ptable.lock); // DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if (lk != &ptable.lock)
  { // DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

// PAGEBREAK!
//  Wake up all processes sleeping on chan.
//  The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if (p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->pid == pid)
    {
      p->killed = 1;
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

// PAGEBREAK: 36
//  Print a process listing to console.  For debugging.
//  Runs when user types ^P on console.
//  No lock to avoid wedging a stuck machine further.
void procdump(void)
{
  static char *states[] = {
      [UNUSED] "unused",
      [EMBRYO] "embryo",
      [SLEEPING] "sleep ",
      [RUNNABLE] "runble",
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if (p->state == SLEEPING)
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

int my_strcmp(const char *s1, const char *s2)
{
  while (*s1 && *s2 && *s1 == *s2)
  {
    s1++;
    s2++;
  }
  return *s1 - *s2;
}

int diff_syscall(const char *file1, const char *file2)
{

  struct inode *f1 = namei(file1);
  struct inode *f2 = namei(file2);

  if (f1 == 0 || f2 == 0)
  {
    return -1;
  }

  ilock(f1);
  ilock(f2);

  uint off1 = 0, off2 = 0;
  char buf1[128], buf2[128];
  int same = 1, line = 1;

  while (1)
  {
    int i = 0;
    char ch;

    memset(buf1, 0, sizeof(buf1));
    while (i < sizeof(buf1) - 1 && readi(f1, &ch, off1, 1) == 1)
    {
      off1++;
      if (ch == '\n' || ch == '\r')
        break;
      buf1[i++] = ch;
    }
    buf1[i] = '\0';
    int len1 = i;

    i = 0;
    memset(buf2, 0, sizeof(buf2));
    while (i < sizeof(buf2) - 1 && readi(f2, &ch, off2, 1) == 1)
    {
      off2++;
      if (ch == '\n' || ch == '\r')
        break;
      buf2[i++] = ch;
    }
    buf2[i] = '\0';
    int len2 = i;

    if (len1 == 0 && len2 == 0)
      break;

    // cprintf("buf1 = [%s]\n", buf1);
    // cprintf("buf2 = [%s]\n", buf2);

    if (my_strcmp(buf1, buf2) != 0)
    {
      cprintf("line %d:\n  file1: %s\n  file2: %s\n", line, buf1, buf2);
      same = 0;
    }

    line++;
  }

  iunlockput(f1);
  iunlockput(f2);

  return same ? 0 : -1;
}

int set_deadline(int dl)
{
  struct proc *p = myproc();
  acquire(&ptable.lock);
  p->class = 1; // Real-Time
  p->deadline = dl;
  p->level = 0; // Not used for Class 1
  p->wait_ticks = 0;
  release(&ptable.lock);
  return 0;
}

int change_queue(int pid, int q)
{
  struct proc *p;
  acquire(&ptable.lock);
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->pid == pid)
    {
      if (p->class != 2)
      {
        release(&ptable.lock);
        cprintf("Process %d is not in Class 2 (Normal)\n", pid);
        return -1;
      }
      p->level = q;      // 1 for Interactive, 2 for Batch
      p->wait_ticks = 0; // Reset wait_ticks
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  cprintf("Process %d not found\n", pid);
  return -1;
}

void print_info(void)
{
  struct proc *p;
  acquire(&ptable.lock);
  cprintf("PID\tName\tClass\tLevel\tState\tWait Ticks\n");
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->state == UNUSED)
      continue;
    char *class_str = p->class == 1 ? "Real-Time" : "Normal";
    char *level_str = p->class == 1 ? "N/A" : (p->level == 1 ? "Interactive" : "Batch");
    char *state_str;
    switch (p->state)
    {
    case EMBRYO:
      state_str = "Embryo";
      break;
    case SLEEPING:
      state_str = "Sleeping";
      break;
    case RUNNABLE:
      state_str = "Runnable";
      break;
    case RUNNING:
      state_str = "Running";
      break;
    case ZOMBIE:
      state_str = "Zombie";
      break;
    default:
      state_str = "Unused";
      break;
    }
    cprintf("%d\t%s\t%s\t%s\t%s\t%d\n",
            p->pid, p->name, class_str, level_str, state_str, p->wait_ticks);
  }
  release(&ptable.lock);
}