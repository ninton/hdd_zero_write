#include <stdio.h>
#include <stdlib.h>

#define LENGTH 1000000L

void main(int argc, char **argv) {
    long notzero = 0;
    long total = 0;
    unsigned char buf[LENGTH];

    for (;;) {
        long n = fread(buf, sizeof(unsigned char), LENGTH, stdin);
        if (n == 0) {
            break;
        }

        total += n;

        for (int i = 0; i < n; i += 1) {
            if (buf[i] != 0) {
                notzero += 1;
            }
        }
    }

    printf("%ld\n", notzero);

    exit(0);
}
