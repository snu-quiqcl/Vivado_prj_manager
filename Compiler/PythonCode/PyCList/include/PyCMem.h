#ifndef PYCMEM_INCLUDE
#define PYCMEM_INCLUDE

#include "PyCType.h"
#include "malloc.h" //from xilinx BSP libraries
#include "string.h"

static inline PyCObject *   // You must write this function as a static inline. If not, it returns 32 bit address, and make malfunction
PyC_malloc(size_t size)
{
    PyCObject * v = PyC_CAST( malloc(sizeof(PyCObject) + size) );
    v->ref_cnt = 1;
    v->type.size = size;
    return v;
}

static inline PyCObject *
PyC_realloc(PyCObject * data, size_t size)
{
    PyCObject * v = PyC_malloc(size);
    int i = 0 ;
    for( i = 0; i < size + sizeof(PyCObject); i++){
        *(v + i) = *(data + i);
    }
    free(data);
    
    return v;
}

static inline PyCObject *
PyC_get_start_addr(PyCObject * addr)
{
    return PyC_CAST(addr + sizeof(PyCObject));
}

static inline PyCObject * 
PyC_set_value(PyCObject * target_addr, PyCObject * source_addr)
{
    size_t i = 0;
    size_t size = source_addr -> type.size;
    PyCObject * t = PyC_get_start_addr(target_addr);
    PyCObject * s = PyC_get_start_addr(source_addr);

    //when target and source type is not same
    if(strcmp(target_addr -> type.type, source_addr->type.type) != 0){ 
        return NULL;
    }
    for( i = 0; i < size; i++){
        *(t + i) = *(s + i);
    }
    return target_addr;
}

#endif // PyCMem.h
