#include "PyCLong.h"
#include "PyCList.h"
#include "PyCMem.h"
#include "PyCType.h"
#include "PyCTypedef.h"

void show_list_structure(PyCObject * v){
    if( PyC_IS_TYPE(v,"list") ){

        PyCObject ** ptr = PyC_LIST_CAST(v) -> ob_item;
        int i = 0;

        for( i = 0; i < PyC_SIZE(PyC_LIST_CAST(v)); i++){
            show_list_structure(*ptr);
            if( i != (PyC_SIZE(PyC_LIST_CAST(v)) - 1) ){
            }
            ptr = ptr + 1;
        }

    }
    else if(PyC_IS_TYPE(v,"int64")){
    }
    else if(PyC_IS_TYPE(v,"char")){
    }
}

int main(){
    PyCObject *a = PyC_make_int64(10);
    PyCObject *b = PyC_make_int64(20);
    PyCObject *c = PyC_make_char('c');



    PyCObject *d = PyC_make_double(1.0);
    
    PyCObject * l = PyCList_New(0);
    PyCObject * l1 = PyCList_New(0);
    PyCList_Append(l1,a);
    PyCList_Append(l,a);
    PyCList_Append(l,b);
    PyCList_Append(l,c);
    PyCList_Append(l,l1);
    show_list_structure(l);
    PyCList_remove(l,c);
    show_list_structure(l);
    //PyCMem_Free(l);
}
