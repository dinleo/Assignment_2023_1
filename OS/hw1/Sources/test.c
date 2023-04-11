#include <stdio.h>
#include <unistd.h>
#include <sys/syscall.h>

#define OS2023_PUSH_SYSCALL_NUM 335
#define OS2023_POP_SYSCALL_NUM 336

void push(int v) {
    int ret = syscall(OS2023_PUSH_SYSCALL_NUM, v);
    if (ret == -1) {
        perror("Push failed");
        return ;
    } else {
        printf("Push %d\n", v);
    }
}

void pop() {
    int value = syscall(OS2023_POP_SYSCALL_NUM);
    if (value == -1) {
        perror("Pop failed");
        return ;
    } else{
        printf("Pop %d\n", value);
    }
}
int main() {
    // Push a value onto the stack
    push(1);
    push(1);
    push(2);
    push(3);
    pop();
    pop();
    pop();

    return 0;
}

