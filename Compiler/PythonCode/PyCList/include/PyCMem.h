#ifndef PYCMEM_INCLUDE
#define PYCMEM_INCLUDE

#include "PyCType.h"
#include "malloc.h" //from xilinx BSP libraries
#include "string.h"

void PyCMem_Free(PyCObject * ob);

static inline PyCObject *   // You must write this function as a static inline. If not, it returns 32 bit address, and make malfunction
PyCMem_Malloc(size_t size)
{
    PyCObject * v = PyC_CAST( malloc(sizeof(PyCObject) + size) );
    v->ref_cnt = 1;
    v->type.size = size;
    return v;
}

static inline PyCObject *
PyCMem_Realloc(PyCObject * data, size_t size)
{
    PyCObject * v = PyCMem_Malloc(size);
    int i = 0 ;
    for( i = 0; i < size + sizeof(PyCObject); i++){
        *(v + i) = *(data + i);
    }
    PyCMem_Free(data);
    
    return v;
}

static inline PyCObject *
PyCMem_Get_start_addr(PyCObject * addr)
{
    return PyC_CAST(addr + sizeof(PyCObject));
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
        *(t + i) = *(s + i);
    }
    return target_addr;
}

static inline PyCObject *
PyCMem_Calloc(size_t len, size_t ele_size){
}

#endif // PyCMem.h
