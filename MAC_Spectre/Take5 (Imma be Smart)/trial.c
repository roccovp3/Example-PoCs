#include <stdio.h>
#include <stdint.h>
#include <unistd.h>

int main(){
    printf("%d\n", sysconf(_SC_PAGE_SIZE));
    return 0;
}