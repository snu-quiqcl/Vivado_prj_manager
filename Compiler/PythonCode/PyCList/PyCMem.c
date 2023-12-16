#include "PyCMem.h"

PyCObject *
PyC_malloc(size_t size)
{
    PyObject * v = (PyObject *) malloc(sizeof(PyCObject) + size);i
    return v;
}

PyCObject *
PyC_realloc(PyCObject * data, size_t size)
{
    PyObject * v = PyCMalloc(size);
    int i = 0 ;
    for( i = 0; i < size + sizeof(PyCObject); i++){
        *(v + i) = *(data + i);
    }
    free(data);
    
    return v;
}

PyCObject * 
PyC_set_value(PyCObject * target_addr, PyCObject * source_addr, size_t size)
{
    size_t i = 0;
    for( i = 0; i < size; i++){
        *(target_addr + i) = *(source_addr);
    }
    return target_addr;
}

PyCObject *
PyC_get_start_addr(PyCObject * addr)
{
    return addr + (PyCObject * )sizeof(PyCObject)
}
