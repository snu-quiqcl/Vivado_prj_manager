#include "PyCLong.h"
#include "PyCList.h"
#include <stdio.h>
#include <stdlib.h>

void show_list_structure(PyCObject * v){
    if( PyC_IS_TYPE(v,"list") ){
        printf("[");

        PyCObject ** ptr = PyC_LIST_CAST(v) -> ob_item;
        int i = 0;

        for( i = 0; i < PyC_SIZE(PyC_LIST_CAST(v)); i++){
            show_list_structure(*ptr);
            if( i != (PyC_SIZE(PyC_LIST_CAST(v)) - 1) ){
                printf(",");
            }
            ptr = ptr + 1;
        }

        printf("]");
    }
    else if(PyC_IS_TYPE(v,"int64")){
        printf("%d",PyC_get_int64_t(v));
    }
    else if(PyC_IS_TYPE(v,"char")){
        printf("%c",PyC_get_char(v));
    }
}

int main(){
    PyCObject *a = PyC_make_int64(10);
    PyC_INCREF(a);
    PyCObject *b = PyC_make_int64(20);
    PyC_INCREF(b);
    PyCObject *c = PyC_make_char('c');
    PyC_INCREF(c);
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
    PyCList_Append(l,c);
    PyCList_Append(l,l1);
    printf("%lld\n",PyC_get_int64_t(PyCList_GetItem(l,0)));
    printf("%lld\n",PyC_get_int64_t(PyCList_GetItem(l,1)));
    printf("%c\n", PyC_get_char(PyCList_GetItem(l,2)));
    printf("%lld\n",PyC_get_int64_t(PyCList_GetItem(PyCList_GetItem(l,3),0)));
    show_list_structure(l);
    printf("\n");
    printf("%d\n",PyCObject_RichCompareBool(a,b,PyC_EQ));
    printf("%d\n",PyCObject_RichCompareBool(a,a,PyC_EQ));
    PyCList_remove(l,c);
    show_list_structure(l);
    printf("\n");
    PyCList_Append(l,a);
    show_list_structure(l);
    printf("\n");

    PyCObject * l2 = PyCList_New(3);
    PyCList_SET_ITEM(l2, 0, a);
    PyCList_SET_ITEM(l2, 1, c);
    PyCList_SET_ITEM(l2, 2, b);
    show_list_structure(l2);

    //PyCMem_Free(l);
}
