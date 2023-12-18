#include "PyCMem.h"
#include "PyCList.h"
#include "string.h"
#define DEBUG

void PyCMem_Free(PyCObject * ob){
    if( ob -> type.type == "NULL"){
        free(ob);
    }
    else if( strcmp(ob -> type.type, "string") == 0 ){
    }
    else if( strcmp(ob->type.type, "list") == 0 ){
        PyCListObject * v = (PyCListObject *)(ob+1);
        free(v-> ob_item);
        free(ob);
    }
    else{
        free(ob);
        return;
    }
}
