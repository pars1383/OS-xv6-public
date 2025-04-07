#include "types.h"
#include "user.h"

int main(int argc, char *argv[]) {
    int num;
    if (argc != 2) {
        printf(1, "Usage: test_palindrome <number>\n");
        exit();
    }
    num = atoi(argv[1]);
    next_palindrome(num);
    exit();
}