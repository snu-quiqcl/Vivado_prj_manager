#include "PyCLong.h"
#define DEBUG

int main(){
    int64_t c = 10;
    PyCObject *v = PyC_make_int64(c);
    printf("%d\n",PyC_get_int64_t(v));
}
