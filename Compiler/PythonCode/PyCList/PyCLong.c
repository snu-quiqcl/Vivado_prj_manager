#include "PyCLong.h"
#include "PyCMem.h"

int64_t
PyC_get_int64_t(PyCObject * v){
    int64_t sign = (PyC_SIZE(PyC_INT_CAST(v)) > 0)? 1:-1;
    return (PyC_INT_CAST(v)->value[0])*sign;
}

double
PyC_get_double(PyCObject * v){
    long double sign = (PyC_SIZE(PyC_DOUBLE_CAST(v)) > 0.0)? 1.0 : -1.0;
    return (PyC_DOUBLE_CAST(v)->value[0])*sign;
}

char
PyC_get_char(PyCObject * v){
    return (PyC_CHAR_CAST(v)->value);
}
