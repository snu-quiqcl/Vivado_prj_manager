#include "PyCMem.h"
#include "PyCList.h"
#include "PyCType.h"
#include "string.h"

void PyCMem_Free(PyCObject * ob){
    if( PyC_IS_TYPE(ob, "NULL") ){
        free(ob);
    }
    else if( PyC_IS_TYPE(ob, "string") ){
    }
    else if( PyC_IS_TYPE(ob, "list") ){
        PyCList_dealloc(PyC_LIST_CAST(ob));
    }
    else{
        free(ob);
        return;
    }
}
