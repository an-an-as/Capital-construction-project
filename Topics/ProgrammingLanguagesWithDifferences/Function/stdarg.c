#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
double avrage(int num,...) {
    va_list varlist;
    double sum = 0.0;
    va_start(varlist, num);
    for (int i = 0; i < num; i++) {
        sum += va_arg(varlist, int);
    }
    va_end(varlist);
    return sum / num;
}

int main(int argc, const char * argv[]) {
    printf("%.2f\n",avrage(5,1,2,3,4,5));
    return 0;
}
