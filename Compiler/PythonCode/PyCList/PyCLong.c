#include "PyCLong.h"

PyCObject *
PyC_make_int64(int64_t ival)
{
    PyCIntObject *v;

    v = PyC_INT_CAST(PyC_malloc(sizeof(PyCIntObject)));
    PyCIntObject * temp_addr = PyC_INT_CAST(PyC_get_start_addr(PyC_CAST(v)));
    PyC_CAST(temp_addr) -> type.size = INT64_SIZE;
    PyC_CAST(temp_addr) -> type.type = "int64";
    
    return (PyCObject *)v;
}

int64_t
PyC_get_int64_t(PyCObject * target){
    return (PyC_INT_CAST(PyC_get_start_addr(target))->value);
}

PyCObject *
PyC_make_double(long double ival)
{
    PyCIntObject *v;
    return (PyCObject *)v;
}

PyCObject *
PyC_make_char(char ival)
{
    PyCIntObject *v;
    return (PyCObject *)v;

}
