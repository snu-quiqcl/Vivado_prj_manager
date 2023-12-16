#include "PyCLong.h"
#include <stdio.h>
#define DEBUG

int main(){
    PyCObject *a = PyC_make_int64(10);
    PyCObject *b = PyC_make_int64(20);
    printf("%d\n",PyC_get_int64_t(a));
    printf("%d\n",PyC_get_int64_t(b));
    PyC_set_value(a,b);

    printf("%d\n",PyC_get_int64_t(a));
}
