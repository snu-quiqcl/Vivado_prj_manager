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
    PyCMem_Set_value(a,b);

    printf("%lld\n",PyC_get_int64_t(a));
    printf("%c\n",PyC_get_char(c));

    PyCMem_Set_value(a,c);
    printf("%c\n",PyC_get_char(a));

    PyCObject *d = PyC_make_double(1.0);
    printf("%f\n",PyC_get_double(d));

    printf("%s\n",d->type.type);

    
    PyCObject * l = PyCList_New(0);
    PyCList_Append(l,a);
    printf("%s\n",(PyC_GET_LIST(l)->ob_item)[0]->type.type);
    printf("%lld\n",PyC_get_int64_t(PyCList_GetItem(l,0)));
    //int k = PyC_LIST_SIZE(PyC_ELE(l));
    //printf("%d\n",k);
    //PyCMem_Free(l);
}
