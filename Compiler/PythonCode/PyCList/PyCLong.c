#include "PyCLong.h"
#include "PyCMem.h"
#include <stdio.h>

int64_t
PyC_get_int64_t(PyCObject * target){
    return (PyC_INT_CAST(PyC_get_start_addr(target))->value);
}

