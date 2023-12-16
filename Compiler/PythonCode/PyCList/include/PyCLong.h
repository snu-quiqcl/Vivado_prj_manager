#ifndef PYCLONG_INCLUDE
#define PYCLONG_INCLUDE

#include "PyCMem.h"

#define PyC_INT_CAST(v)     ( (PyCIntObject *)(v) )

typedef struct{
    int8_t          size;
    int8_t          sign;
    int64_t         value;
}PyCIntObject;

PyCObject * PyC_make_int64(int64_t ival);
int64_t PyC_get_int64_t(PyCObject * target);
PyCObject * PyC_make_double(long double ival);
PyCObject * PyC_make_char(char ival);

#endif
