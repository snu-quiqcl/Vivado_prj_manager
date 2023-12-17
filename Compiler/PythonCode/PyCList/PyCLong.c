#include "PyCLong.h"
#include "PyCMem.h"

int64_t
PyC_get_int64_t(PyCObject * target){
    return (PyC_INT_CAST(PyC_ELE(target))->value);
}

char
PyC_get_char(PyCObject * target){
    return (PyC_CHAR_CAST(PyC_ELE(target))->value);
}

double
PyC_get_double(PyCObject * target){
    return (PyC_DOUBLE_CAST(PyC_ELE(target))->value);
}
