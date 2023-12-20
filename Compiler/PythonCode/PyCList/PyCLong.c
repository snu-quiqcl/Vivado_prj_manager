#ifdef__cplusplus
extern "C"{
#endif

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

int64_t int64_t_richcompare(PyCObject * v, PyCObject * w, int op){
    int64_t val1 = PyC_get_int64_t(v);
    int64_t val2 = PyC_get_int64_t(w);
    PyC_RETURN_RICHCOMPARE(val1,val2,op);
}

int64_t char_richcompare(PyCObject * v, PyCObject * w, int op){
    char val1 = PyC_get_char(v);
    char val2 = PyC_get_char(w);
    PyC_RETURN_RICHCOMPARE(val1,val2,op);
}
