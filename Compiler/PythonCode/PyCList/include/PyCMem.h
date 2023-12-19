#ifndef PYCMEM_INCLUDE
#define PYCMEM_INCLUDE

#include "PyCType.h"

#define UNIT_DATA  char
#define UNIT_CAST(v) ( (UNIT_DATA* ) (v) )
#define PyC_DECREF(v) PyC_DecRef(PyC_CAST(v))
#define PyC_INCREF(v) PyC_IncRef(PyC_CAST(v))

void PyCMem_Free(PyCObject * ob);

extern void *malloc(size_t a);
extern void free(void * a);
extern void * realloc(void * v, size_t a);
static inline PyCObject *   // You must write this function as a static inline. If not, it returns 32 bit address, and make malfunction
PyCMem_Malloc(size_t size)
{
    PyCObject * v = PyC_CAST( malloc(size) );
    v->ref_cnt = 0;
    return v;
}

static inline PyCObject *
PyCMem_Realloc(PyCObject * data, size_t size)
{
    PyCObject * v;

    if( data == NULL ){
        v = PyC_CAST(malloc(size));
        int i =0;
        for( i = 0; i < size; i ++){
            *(UNIT_CAST(v)+i) = (UNIT_DATA) 0;
        }
    }

    else{
        v = PyC_CAST(realloc(data, size));
    }

    return v;
}

static inline PyCObject *
PyCMem_Calloc(size_t len, size_t ele_size){
    PyCObject * v = PyC_CAST( malloc(ele_size * len) );
    int i =0;
    for( i = 0 ; i < ele_size * len; i++){
        *(UNIT_CAST(v)+i) = (UNIT_DATA)(0);
    }
    return v;

}

static inline PyCObject *
PyC_DecRef(PyCObject * v){ 
    uint64_t ref_cnt = v->ref_cnt;
    v->ref_cnt = ref_cnt-1;
    if( (v->ref_cnt) <= 0 ){
        PyCMem_Free(v);
        return NULL;
    }
    return v;
}

static inline PyCObject *
PyC_IncRef(PyCObject * v){  
    uint64_t ref_cnt = v->ref_cnt;
    v->ref_cnt = ref_cnt + 1;
    return v;
}

#endif // PyCMem.h
