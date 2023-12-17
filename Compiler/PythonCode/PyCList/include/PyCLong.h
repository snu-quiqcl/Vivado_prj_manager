#ifndef PYCLONG_INCLUDE
#define PYCLONG_INCLUDE

#include "PyCType.h"
#include "PyCMem.h"

#define PyC_INT_CAST(v)     ( (PyCIntObject *)(v) )
#define PyC_CHAR_CAST(v)    ( (PyCCharObject *)(v) )
#define PyC_DOUBLE_CAST(v)  ( (PyCDoubleObject *)(v) )

typedef struct{
    int8_t          len;
    int8_t          sign;
    int64_t         value;
}PyCIntObject;

typedef struct{
    char            value;
}PyCCharObject;

typedef struct{
    int8_t          len;
    int8_t          sign;
    double          value;
}PyCDoubleObject;

static inline PyCObject *
PyC_make_int64(int64_t ival)
{
    PyCIntObject *v;

    v = PyC_INT_CAST(PyCMem_Malloc(sizeof(PyCIntObject)));
    PyC_CAST(v)->type.type          = "int64";
    PyCIntObject * temp_addr        = PyC_INT_CAST(PyCMem_Get_start_addr(PyC_CAST(v)));
    PyC_INT_CAST(temp_addr) -> len = INT64_SIZE;
    PyC_INT_CAST(temp_addr) -> sign = (ival > 0)? 0:1;
    PyC_INT_CAST(temp_addr) -> value= ival;
    
    return (PyCObject *)v;
}

static inline PyCObject *
PyC_make_double(long double ival)
{
    PyCDoubleObject *v;

    v = PyC_DOUBLE_CAST(PyCMem_Malloc(sizeof(PyCDoubleObject)));
    PyC_CAST(v) -> type.type      = "double";
    PyCDoubleObject * temp_addr     = PyC_DOUBLE_CAST(PyCMem_Get_start_addr(PyC_CAST(v)));
    PyC_DOUBLE_CAST(temp_addr) -> len = DOUBLE_SIZE;
    PyC_DOUBLE_CAST(temp_addr) -> sign = (ival > 0.0)? 0:1;
    PyC_DOUBLE_CAST(temp_addr) -> value = ival;

    return (PyCObject *)v;
}

static inline PyCObject *
PyC_make_char(char ival)
{
    PyCCharObject *v;

    v = PyC_CHAR_CAST(PyCMem_Malloc(sizeof(PyCCharObject)));
    PyC_CAST(v)->type.type          = "char";
    PyCCharObject * temp_addr       = PyC_CHAR_CAST(PyCMem_Get_start_addr(PyC_CAST(v)));
    PyC_CHAR_CAST(temp_addr) -> value = ival;

    return (PyCObject *)v;
}


int64_t PyC_get_int64_t(PyCObject * target);
char    PyC_get_char(PyCObject * target);
double  PyC_get_double(PyCObject * target);
#endif
