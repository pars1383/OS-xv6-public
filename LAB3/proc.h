
#define MAX_SYSCALLS 100
#define MAX_USERS 32
#define PASSWORD_LEN 16

// Per-CPU state
struct cpu {
  uchar apicid;                // Local APIC ID
  struct context *scheduler;   // swtch() here to enter scheduler
  struct taskstate ts;         // Used by x86 to find stack for interrupt
  struct segdesc gdt[NSEGS];   // x86 global descriptor table
  volatile uint started;       // Has the CPU started?
  int ncli;                    // Depth of pushcli nesting.
  int intena;                  // Were interrupts enabled before pushcli?
  struct proc *proc;           // The process running on this cpu or null
};

extern struct cpu cpus[NCPU];
extern int ncpu;

//PAGEBREAK: 17
// Saved registers for kernel context switches.
// Don't need to save all the segment registers (%cs, etc),
// because they are constant across kernel contexts.
// Don't need to save %eax, %ecx, %edx, because the
// x86 convention is that the caller has saved them.
// Contexts are stored at the bottom of the stack they
// describe; the stack pointer is the address of the context.
// The layout of the context matches the layout of the stack in swtch.S
// at the "Switch stacks" comment. Switch doesn't save eip explicitly,
// but it is on the stack and allocproc() manipulates it.
struct context {
  uint edi;
  uint esi;
  uint ebx;
  uint ebp;
  uint eip;
};

enum procstate { UNUSED, EMBRYO, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };

// Per-process state
struct proc {
  uint sz;                     // Size of process memory (bytes)
  pde_t* pgdir;                // Page table
  char *kstack;                // Bottom of kernel stack for this process
  enum procstate state;        // Process state
  int pid;                     // Process ID
  struct proc *parent;         // Parent process
  struct trapframe *tf;        // Trap frame for current syscall
  struct context *context;     // swtch() here to run process
  void *chan;                  // If non-zero, sleeping on chan
  int killed;                  // If non-zero, have been killed
  struct file *ofile[NOFILE];  // Open files
  struct inode *cwd;           // Current directory
  char name[16];               // Process name (debugging)

  int uid;
  int logged_in;
  int syscalls[MAX_SYSCALLS];
  int syscall_count;

  int class;                   // 1 for Real-Time, 2 for Normal
  int level;                   // For Class 2: 1 for Interactive, 2 for Batch
  int deadline;                // For Class 1: Deadline for EDF scheduling
  int wait_ticks;              // For aging: Tracks time spent in ready queue
  int quantum_ticks;           // Tracks ticks used in current quantum (for Level 1)
  int run_ticks;
  int queue_entry_time;
};

// Process memory is laid out contiguously, low addresses first:
//   text
//   original data and bss
//   fixed-size stack
//   expandable heap

extern int logged_in_uids[MAX_USERS];


struct user_cred {
  int uid;
  char password[PASSWORD_LEN];
};
extern struct user_cred user_credentials[MAX_USERS];



struct user_syscall_logs {
  int uid;
  int syscalls[MAX_SYSCALLS];
  int syscall_count;
};

extern int current_logged_in_uid;
extern struct user_syscall_logs user_syscall_logs[MAX_USERS];


void print_all_user_logs(void);
int make_user_syscall(int uid, char *password);
int diff_syscall(const char* file1, const char* file2);

