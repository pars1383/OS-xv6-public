#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

int
cpuid() {
  return mycpu()-cpus;
}

struct cpu*
mycpu(void)
{
  int apicid, i;
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  apicid = lapicid();
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  p->class = 2; // Class 2 (Normal)
  p->level = 2; // Level 2 (Batch)
  p->wait_ticks = 0;
  p->quantum_ticks = 0;
  cprintf("Allocated process %d as Class %d, Level %d\n", p->pid, p->class, p->level);

  release(&ptable.lock);

  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // Set to Interactive for initcode
  p->level = 1; // Level 1 (Interactive)
  cprintf("Set initcode (PID %d) to Class %d, Level %d\n", p->pid, p->class, p->level);

  p->state = RUNNABLE;

  acquire(&ptable.lock);
  p->state = RUNNABLE;
  release(&ptable.lock);
}

int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  if((np = allocproc()) == 0){
    return -1;
  }

  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  // Inherit scheduling class and level from parent
  np->class = curproc->class;
  np->level = curproc->level;
  np->wait_ticks = 0;
  np->quantum_ticks = 0;
  cprintf("Forked process %d from %s (PID %d) as Class %d, Level %d\n",
          np->pid, curproc->name, curproc->pid, np->class, np->level);

  acquire(&ptable.lock);
  np->state = RUNNABLE;
  release(&ptable.lock);

  return pid;
}

void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  wakeup1(curproc->parent);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    sleep(curproc, &ptable.lock);
  }
}

void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
  
  for(;;){
    sti();
    acquire(&ptable.lock);
    cprintf("Runnable processes:\n");
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state == RUNNABLE){
        cprintf("PID %d, Name %s, Class %d, Level %d\n", p->pid, p->name, p->class, p->level);
      }
    }
    
    // First, try to schedule Batch processes (Level 2)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE || p->class != 2 || p->level != 2)
        continue;
      cprintf("Scheduling Batch process %d (%s)\n", p->pid, p->name);
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
      p->quantum_ticks = 0;
      swtch(&(c->scheduler), p->context);
      switchkvm();
      c->proc = 0;
      break; // FCFS: run one Batch process at a time
    }

    // If no Batch processes, schedule Interactive processes
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE || p->class != 2 || p->level != 1)
        continue;
      cprintf("Scheduling Interactive process %d (%s)\n", p->pid, p->name);
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
      p->quantum_ticks = 0;
      swtch(&(c->scheduler), p->context);
      switchkvm();
      c->proc = 0;
      // Interactive processes yield after 30ms quantum
      if(p->quantum_ticks >= 3){ // Assuming 10ms ticks
        cprintf("Process %d (%s) yielding after 30ms quantum\n", p->pid, p->name);
        p->state = RUNNABLE;
      }
    }

    // Update wait_ticks for Batch processes and handle aging
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state == RUNNABLE && p->class == 2 && p->level == 2){
        p->wait_ticks++;
        cprintf("Process %d (%s) wait_ticks = %d\n", p->pid, p->name, p->wait_ticks);
        if(p->wait_ticks >= 800){
          cprintf("Process %d (%s) promoted to Interactive due to aging\n", p->pid, p->name);
          p->level = 1;
          p->wait_ticks = 0;
        }
      }
    }
    release(&ptable.lock);
  }
}

void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

void
yield(void)
{
  struct proc *curproc = myproc();
  acquire(&ptable.lock);
  curproc->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

void
forkret(void)
{
  static int first = 1;
  release(&ptable.lock);
  
  if (first) {
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }
}

void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *curproc = myproc();
  
  if(curproc == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  if(lk != &ptable.lock){
    acquire(&ptable.lock);
    release(lk);
  }
  curproc->chan = chan;
  curproc->state = SLEEPING;

  sched();

  curproc->chan = 0;

  if(lk != &ptable.lock){
    release(&ptable.lock);
    acquire(lk);
  }
}

static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep",
  [RUNNABLE]  "runble",
  [RUNNING]   "run",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i]; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

void
print_info(void)
{
  struct proc *p;
  static char *states[] = {
    [UNUSED]    "Unused",
    [EMBRYO]    "Embryo",
    [SLEEPING]  "Sleeping",
    [RUNNABLE]  "Runnable",
    [RUNNING]   "Running",
    [ZOMBIE]    "Zombie"
  };
  static char *classes[] = {
    [0] "Unknown",
    [1] "RealTime",
    [2] "Normal"
  };
  static char *levels[] = {
    [1] "Interactive",
    [2] "Batch"
  };

  cprintf("PID\tName\tClass\tLevel\tState\tWait Ticks\n");
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    cprintf("%d\t%s\t%s\t%s\t%s\t%d\n",
            p->pid, p->name, classes[p->class], levels[p->level], states[p->state], p->wait_ticks);
  }
  release(&ptable.lock);
}

int
change_queue(int pid, int q)
{
  struct proc *p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      if(q != 1 && q != 2){
        release(&ptable.lock);
        return -1;
      }
      p->level = q;
      cprintf("Changed process %d (%s) to queue %d\n", p->pid, p->name, q);
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

int
diff_syscall(const char *file1, const char *file2)
{
  struct inode *f1 = namei(file1);
  struct inode *f2 = namei(file2);
  if(f1 == 0 || f2 == 0){
    if(f1) iput(f1);
    if(f2) iput(f2);
    return -1;
  }

  ilock(f1);
  ilock(f2);

  char buf1[512], buf2[512];
  int n1, n2, line = 1, diff_found = 0;

  uint off1 = 0, off2 = 0;
  while((n1 = readi(f1, buf1, off1, sizeof(buf1))) > 0 &&
        (n2 = readi(f2, buf2, off2, sizeof(buf2))) > 0){
    for(int i = 0; i < n1 && i < n2; i++){
      if(buf1[i] != buf2[i]){
        cprintf("Line %d differs: %c vs %c\n", line, buf1[i], buf2[i]);
        diff_found = 1;
        break;
      }
      if(buf1[i] == '\n') line++;
    }
    off1 += n1;
    off2 += n2;
    if(n1 != n2 || (n1 < sizeof(buf1) && n2 < sizeof(buf2))) break;
  }

  if(n1 != n2 || n1 > 0 || n2 > 0){
    cprintf("Files differ in length at line %d\n", line);
    diff_found = 1;
  }

  iunlockput(f1);
  iunlockput(f2);
  return diff_found ? 1 : 0;
}