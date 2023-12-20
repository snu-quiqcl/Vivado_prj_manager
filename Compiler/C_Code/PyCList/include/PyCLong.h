#ifndef PYCLONG_INCLUDE
#define PYCLONG_INCLUDE

#ifdef __cplusplus
extern "C"{
#endif

#include "PyCType.h"
#include "PyCMem.h"

#define PyC_INT_CAST(v)     ( (PyCIntObject *)(v) )
#define PyC_CHAR_CAST(v)    ( (PyCCharObject *)(v) )
#define PyC_DOUBLE_CAST(v)  ( (PyCDoubleObject *)(v) )

typedef struct{
    PyCObject_VAR_HEAD 
    int64_t         value[1];
}PyCIntObject;

typedef struct{
    PyCObject_VAR_HEAD
    char            value;
}PyCCharObject;

typedef struct{
    PyCObject_VAR_HEAD
    double          value[1];
}PyCDoubleObject;

int64_t int64_t_richcompare(PyCObject * v, PyCObject * w, int op);
int64_t char_richcompare(PyCObject * v, PyCObject * w, int op);

static inline PyCObject *
PyC_make_int64(int64_t ival)
{
    PyCIntObject *v;

    v = PyC_INT_CAST(PyCMem_Malloc(sizeof(PyCIntObject)));
    PyC_SET_TYPE(v,"int64");
    size_t sign = (ival > 0)? 1:-1;
    PyC_SET_SIZE(v,sign);
    (v->value)[0] = sign * ival;
    PyC_CAST(v)->type.tp_richcompare = &(int64_t_richcompare);
    
    return (PyCObject *)v;
}

static inline PyCObject *
PyC_make_double(long double ival)
{
    PyCDoubleObject *v;

    v = PyC_DOUBLE_CAST(PyCMem_Malloc(sizeof(PyCDoubleObject)));
    PyC_SET_TYPE(v,"double");
    size_t sign = (ival > 0)? 1:-1;
    PyC_SET_SIZE(v,sign);
    (v->value)[0] = sign * ival;
    PyC_CAST(v)->type.tp_richcompare = &(char_richcompare);

    return (PyCObject *)v;
}

static inline PyCObject *
PyC_make_char(char ival)
{
    PyCCharObject *v;

    v = PyC_CHAR_CAST(PyCMem_Malloc(sizeof(PyCCharObject)));
    PyC_SET_TYPE(v,"char");
    PyC_SET_SIZE(v,1);
    v->value = ival;

    return (PyCObject *)v;
}

int64_t PyC_get_int64_t(PyCObject * target);
char    PyC_get_char(PyCObject * target);
double  PyC_get_double(PyCObject * target);

#ifdef __cplusplus
}
#endif
#endif
