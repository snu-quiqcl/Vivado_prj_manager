#ifndef PYCMEM_INCLUDE
#define PYCMEM_INCLUDE

#include "PyCType.h"
#include "malloc.h" //from xilinx BSP libraries
#include "string.h"

#define UNIT_DATA  uint8_t
#define UNIT_CAST(v) ( (UNIT_DATA* ) (v) )
#define PyC_DECREF(v) PyC_DecRef((PyC_CAST(v)))
#define PyC_INCREF(v) PyC_IncRef((PyC_CAST(v)))

void PyCMem_Free(PyCObject * ob);

static inline PyCObject *   // You must write this function as a static inline. If not, it returns 32 bit address, and make malfunction
PyCMem_Malloc(size_t size)
{
    PyCObject * v = PyC_CAST( malloc(sizeof(PyCObject) + size) );
    v->ref_cnt = 0;
    v->type.size = size;
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
PyCMem_Get_start_addr(PyCObject * addr)
{
    return PyC_CAST(addr) + 1;
}

static inline PyCObject * 
PyCMem_Set_value(PyCObject * target_addr, PyCObject * source_addr)
{
    size_t i = 0;
    size_t size = source_addr -> type.size;
    uint8_t * t = (uint8_t *)PyC_ELE(target_addr);
    uint8_t * s = (uint8_t *)PyC_ELE(source_addr);

    //when target and source type is not same
    if(target_addr -> type.size != source_addr -> type.size){ 
        PyCMem_Free(target_addr);
        target_addr = PyCMem_Malloc(size);
    }
    for( i = 0; i < size; i++){
        *(UNIT_CAST(t) + i) = *(UNIT_CAST(s) + i);
    }
    return target_addr;
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
    v->ref_cnt = v->ref_cnt - 1;
    if( v->ref_cnt <= 0 ){
        PyCMem_Free(v);
    }
    return v;
}

static inline PyCObject *
PyC_IncRef(PyCObject * v){   
    v->ref_cnt = v->ref_cnt + 1;
    return v;
}

#endif // PyCMem.h
