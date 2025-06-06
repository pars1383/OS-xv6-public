#include "fcntl.h"

int main(int argc, char *argv[])
{
    unlink("result.txt");
    int fd = open("result.txt", O_CREATE | O_RDWR);

    if(fd < 0){
        printf(2, "strdiff : can not open/create result.txt\n");
        exit();
    }

    int cnt = 0;
    int flag = 1;
    for(int i = 0; i < strlen(argv[1]); i++){

        if(cnt < 0){
            flag = 0;
            break;
        }

        if((int)(argv[1][i]) == 123){
            cnt++;
        }
        if((int)(argv[1][i]) == 125){
            cnt--;
        }
    }

    if(flag == 0){
        write (fd, "Wrong\n", 6);
    }
    else{
        if(cnt == 0){
            write(fd, "Right\n", 6);
        }
        else{
            write(fd, "Wrong\n", 6);
        }
    }
    
    close(fd);
    exit();
}