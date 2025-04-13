#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]){
    if (argc < 3) {
        printf(2, "Usage: testdiff file1 file2\n");
        exit();
    }

    // printf(1, argv[1]);

    // printf(1, "\n");

    // printf(1, argv[2]);

    int result = diff_syscall(argv[1], argv[2]);

    if (result == 0)
        printf(1, "Files are identical\n");
    else
        printf(1, "Files differ\n");

    exit();
}