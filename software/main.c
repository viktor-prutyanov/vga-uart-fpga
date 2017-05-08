#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>

int main(int argc, char *argv[]) {
    errno = 0;
    int fd = open(argv[1], 0666);
    perror(NULL);
    if (errno) {
        return -1;
    }
    unsigned int num;
    while(1) {
        printf("data: ");
        scanf("%x", &num);
        write(fd, &num, 2);
    }
    return 0;
}
