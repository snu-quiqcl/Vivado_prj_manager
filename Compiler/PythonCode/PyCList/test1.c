#include "PyCLong.h"
#include "PyCList.h"
#include <stdio.h>
#include <stdlib.h>

int main(){
    PyCObject *a = PyC_make_int64(10);
    PyCObject *b = PyC_make_int64(20);
    PyCObject *c = PyC_make_char('c');
    printf("%d\n",sizeof(PyCObject));
    printf("%lld\n",PyC_get_int64_t(a));
    printf("%lld\n",PyC_get_int64_t(b));

    printf("%lld\n",PyC_get_int64_t(a));
    printf("%c\n",PyC_get_char(c));

    printf("%d\n",PyC_get_char(a));

    PyCObject *d = PyC_make_double(1.0);
    printf("%f\n",PyC_get_double(d));
    
    PyCObject * l = PyCList_New(0);
    PyCObject * l1 = PyCList_New(0);
    PyCList_Append(l1,a);
    PyCList_Append(l,a);
    PyCList_Append(l,b);
    PyCList_Append(l,l1);
    printf("%lld\n",PyC_get_int64_t(PyCList_GetItem(l,0)));
    printf("%lld\n",PyC_get_int64_t(PyCList_GetItem(l,1)));
    printf("%lld\n",PyC_get_int64_t(PyCList_GetItem(PyCList_GetItem(l,2),0)));
    //PyCMem_Free(l);
}
