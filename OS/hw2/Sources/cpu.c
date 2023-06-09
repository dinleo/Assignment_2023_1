#include <sched.h>
#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/shm.h>

#define ROW (100)
#define COL ROW
#define TIME_SLICE 100

int count = 0;
int pid_idx = 0;
long currentTime;
pid_t s_pid;

void calc() {
    int matrixA[ROW][COL];
    int matrixB[ROW][COL];
    int matrixC[ROW][COL];
    int i, j, k;

    for (i = 0; i < ROW; i++) {
        for (j = 0; j < COL; j++) {
            for (k = 0; k < COL; k++) {
                matrixC[i][j] += matrixA[i][j] * matrixB[i][j];
            }
        }
    }

    count++;
}

void handle_signal(int signum) {
    if(getpid() != s_pid){
        printf("C^DONE!! PROCESS #%02d count = %02d %02ld \n", pid_idx, count, currentTime);
        exit(signum);
    }
}

struct sched_attr {
    uint32_t size;              /* 이 구조체의 크기 */
    uint32_t sched_policy;      /* 정책 (SCHED_*) */
    uint64_t sched_flags;       /* 플래그 */
    int32_t sched_nice;        /* 나이스 값 (SCHED_OTHER,
                              SCHED_BATCH) */
    uint32_t sched_priority;    /* 고정 우선순위 (SCHED_FIFO,
                              SCHED_RR) */
    /* 나머지 필드들은 SCHED_DEADLINE 용 */
    uint64_t sched_runtime;
    uint64_t sched_deadline;
    uint64_t sched_period;
};


static int sched_setattr(pid_t pid, const struct sched_attr *attr, unsigned int flags) {
    return syscall(SYS_sched_setattr, pid, attr, flags);
}


int main(int argc, char *argv[]) {
    if (argc != 3) {
        printf("Usage: ./cpu <ProcessNumber> <Time to Execute>\n");
        return 1;
    }
    s_pid = getpid();

    struct sched_attr attr;
    memset(&attr, 0, sizeof(attr));
    attr.size = sizeof(struct sched_attr);
    attr.sched_priority = 10;
    attr.sched_policy = SCHED_RR;

    int processNumber = atoi(argv[1]);
    int timeToExecute = atoi(argv[2]);
    pid_t pid_arr[processNumber];

    // Register signal handler for SIGINT
    signal(SIGINT, handle_signal);

    // Create child processes
    for (int i = 0; i < processNumber; i++) {
        int sch = sched_setattr(getpid(), &attr, 0);
        if (sch == -1) {
            perror("Error: calling sched_setattr.\n");
        }
        printf("Creating Process: #%d\n", i);
        pid_arr[i] = fork();

        if (pid_arr[i] == 0) {
            pid_idx = i;
            struct timespec start, end;

            clock_gettime(CLOCK_MONOTONIC, &start);
            while (1) {
                calc();
                clock_gettime(CLOCK_MONOTONIC, &end);

                // Calculate elapsed time
                currentTime = (end.tv_sec - start.tv_sec) * 1000 + (end.tv_nsec - start.tv_nsec) / 1000000;

                // Print pid and count at each TIME_SLICE
                if (currentTime % TIME_SLICE == 0) {
                    printf("Process number: %02d, Total count: %d, time: %d ms\n", i, count, TIME_SLICE);
                }
                if (timeToExecute * 1000 <= currentTime){
                    printf("DONE!! PROCESS #%02d count = %02d %02ld \n", i, count, currentTime);
                    exit(100+i);
                }
            }
        }
    }
    for(int i = 0; i < processNumber; i++) {
        waitpid(pid_arr[i], NULL, 0);
    }
    return 0;

}