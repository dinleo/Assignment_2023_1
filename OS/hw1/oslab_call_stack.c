#include <linux/syscalls.h>
#include <linux/kernel.h>
#include <linux/linkage.h>

#define STACK_SIZE 10

static int stack[STACK_SIZE];
static int top = -1; // stack top index

SYSCALL_DEFINE1(os2023_push, int, a) {
    int i;
    for (i = 0; i <= top; i++) {
        if (stack[i] == a) {
            return -1; // value already exists in stack
        }
    }
    if (top == STACK_SIZE - 1) {
        return -1; // stack overflow
    }
    top++;
    stack[top] = a;
    return 0; // success
}
SYSCALL_DEFINE0(os2023_pop) {
    if (top == -1) {
        return -1; // stack underflow
    }
    int value = stack[top];
    top--;
    return value;
}
