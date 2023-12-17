#include "PyCLong.h"
#include <stdio.h>
#include <stdlib.h>

int main(){
    PyCObject *a = PyC_make_int64(10);
    PyCObject *b = PyC_make_int64(20);
    PyCObject *c = PyC_make_char('c');
    printf("%lld\n",PyC_get_int64_t(a));
    printf("%lld\n",PyC_get_int64_t(b));
    PyCMem_Set_value(a,b);

    printf("%lld\n",PyC_get_int64_t(a));
    printf("%c\n",PyC_get_char(c));

    PyCMem_Set_value(a,c);
    printf("%c\n",PyC_get_char(a));

    PyCObject *d = PyC_make_double(1.0);
    printf("%f\n",PyC_get_double(d));

    printf("%s\n",d->type.type);

    PyCMem_Free(a);
    PyCMem_Free(b);
    PyCMem_Free(c);
    //PyCMem_Free(d);
}
