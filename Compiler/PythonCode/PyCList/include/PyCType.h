#ifndef PYCTYPE_INCLUDE
#define PYCTYPE_INCLUDE

#include <stdint.h>
#include <string.h>
#include "PyCTypedef.h"

#define PyC_SSIZE_T_MAX         INTPTR_MAX
#define NUM_TYPE                (4)     // number of declared types
#define MAX_TYPE_LEN            (20)    // Length of type name
#define BYTE_BIT                (8)     // Bit number of 1 byte
#define INT64_SIZE              (8*BYTE_BIT)
#define DOUBLE_SIZE             (8*BYTE_BIT)
#define PyC_CAST(v)             ((PyCObject *) (v) )
#define PyC_TYPE(v)             ((v)->type)
#define PyC_SIZE(v)             (((v)->ob_base).ob_size)
#define PyC_SET_SIZE(v,s)       (((v)->ob_base).ob_size = (s))
#define PyC_SET_TYPE(v,t)       (PyC_CAST(v)->type.type = (t))
#define PyC_GET_TYPE(v)         (PyC_CAST(v)->type.type)
#define PyCObject_VAR_HEAD      PyCVarObject ob_base;
#define PyC_SET_REFCNT(v,n)     (PyC_CAST(v)->ref_cnt = (n))
#define PyC_REFCNT(v)           (PyC_CAST(v)->ref_cnt)
#define PyC_IS_TYPE(ob, typ)        ( (strcmp((PyC_CAST(ob)) -> type.type, (typ))) == 0 )
#define PyC_EQ                  0
#define PyC_NE                  1
#define PyC_LT                  2
#define PyC_GT                  3
#define PyC_LE                  4
#define PyC_GE                  5
#define PyC_RETURN_TRUE         (1)
#define PyC_RETURN_FALSE        (0)
#define PyC_RETURN_UNREACHABLE         (2)
#define PyC_RETURN_RICHCOMPARE(val1, val2, op)                               \
    do {                                                                    \
        switch (op) {                                                       \
        case PyC_EQ: if ((val1) == (val2)) return PyC_RETURN_TRUE; return PyC_RETURN_FALSE;  \
        case PyC_NE: if ((val1) != (val2)) return PyC_RETURN_TRUE; return PyC_RETURN_FALSE;  \
        case PyC_LT: if ((val1) < (val2)) return PyC_RETURN_TRUE; return PyC_RETURN_FALSE;   \
        case PyC_GT: if ((val1) > (val2)) return PyC_RETURN_TRUE; return PyC_RETURN_FALSE;   \
        case PyC_LE: if ((val1) <= (val2)) return PyC_RETURN_TRUE; return PyC_RETURN_FALSE;  \
        case PyC_GE: if ((val1) >= (val2)) return PyC_RETURN_TRUE; return PyC_RETURN_FALSE;  \
        default:                                                            \
            return PyC_RETURN_UNREACHABLE;                                               \
        }                                                                   \
    } while (0)

#ifndef int64_t
#define int64_t long
#endif

extern char ** new_type_table;
extern int64_t num_type;

typedef int64_t (*richcmpfunc) (PyCObject *, PyCObject *, int);

typedef struct{
    char *          type;
    richcmpfunc     tp_richcompare;
}PyCTypeObject;


struct _object{
    uint64_t        ref_cnt;
    PyCTypeObject   type;
};

typedef struct {
    PyCObject ob_base;
    size_t ob_size; /* Number of items in variable part */
} PyCVarObject;

int64_t do_richcompare(PyCObject *v, PyCObject *w, int op);
int64_t PyCObject_RichCompare(PyCObject *v, PyCObject *w, int op);
int64_t PyCObject_RichCompareBool(PyCObject *v, PyCObject *w, int op);
#endif // PyCType.h
