#ifndef PYCLONG_INCLUDE
#define PYCLONG_INCLUDE

#include "PyCType.h"
#include "PyCMem.h"

#define PyC_INT_CAST(v)     ( (PyCIntObject *)(v) )

typedef struct{
    int8_t          size;
    int8_t          sign;
    int64_t         value;
}PyCIntObject;

static inline PyCObject *
PyC_make_int64(int64_t ival)
{
    PyCIntObject *v;

    v = PyC_INT_CAST(PyC_malloc(sizeof(PyCIntObject)));
    PyC_CAST(v)->type.size          = INT64_SIZE;
    PyC_CAST(v)->type.type          = "int64";
    PyCIntObject * temp_addr        = PyC_INT_CAST(PyC_get_start_addr(PyC_CAST(v)));
    PyC_INT_CAST(temp_addr) -> size = INT64_SIZE;
    PyC_INT_CAST(temp_addr) -> sign = (ival > 0)? 0:1;
    PyC_INT_CAST(temp_addr) -> value= ival;
    
    return (PyCObject *)v;
}

static inline PyCObject *
PyC_make_double(long double ival)
{
    PyCIntObject *v;
    return (PyCObject *)v;
}

static inline PyCObject *
PyC_make_char(char ival)
{
    PyCIntObject *v;
    return (PyCObject *)v;

}


int64_t PyC_get_int64_t(PyCObject * target);

#endif
