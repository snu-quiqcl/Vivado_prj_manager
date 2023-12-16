#ifndef PYCMEM_INCLUDE
#define PYCMEM_INCLUDE

#include "malloc.h" //from xilinx BSP libraries
#include "PyCType.h"

PyCObject * PyC_malloc(size_t size);
PyCObject * PyC_realloc(PyCObject * data, size_t size); 
PyCObject * PyC_set_value(PyCObject * target_addr, PyCObject * source_addr,size_t size);
PyCObject * PyC_get_start_addr(PyCObject * addr);
#endif // PyCMem.h
