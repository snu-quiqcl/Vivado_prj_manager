#ifndef PYCMEM_INCLUDE
#define PYCMEM_INCLUDE

#include "PyCType.h"
#include "malloc.h" //from xilinx BSP libraries

static inline PyCObject *   // You must write this function as a static inline. If not, it returns 32 bit address, and make malfunction
PyC_malloc(size_t size)
{
    PyCObject * v = PyC_CAST( malloc(sizeof(PyCObject) + size) );
    v->ref_cnt = 1;
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
PyC_set_value(PyCObject * target_addr, PyCObject * source_addr, size_t size)
{
    size_t i = 0;
    for( i = 0; i < size; i++){
        *(target_addr + i) = *(source_addr);
    }
    return target_addr;
}

static inline PyCObject *
PyC_get_start_addr(PyCObject * addr)
{
    return PyC_CAST(addr + sizeof(PyCObject));
}
#endif // PyCMem.h
