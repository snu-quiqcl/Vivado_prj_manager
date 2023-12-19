#ifndef PYCTYPE_INCLUDE
#define PYCTYPE_INCLUDE

#include <stdint.h>
#include <string.h>

#define PyC_SSIZE_T_MAX         INTPTR_MAX
#define NUM_TYPE                (4)     // number of declared types
#define MAX_TYPE_LEN            (20)    // Length of type name
#define BYTE_BIT                (8)     // Bit number of 1 byte
#define INT64_SIZE              (8*BYTE_BIT)
#define DOUBLE_SIZE             (8*BYTE_BIT)
#define PyC_CAST(v)             ((PyCObject *) (v) )
#define PyC_SIZE(v)             (((v)->ob_base).ob_size)
#define PyC_SET_SIZE(v,s)       (((v)->ob_base).ob_size = (s))
#define PyC_SET_TYPE(v,t)       (PyC_CAST(v)->type.type = (t))
#define PyC_GET_TYPE(v)         (PyC_CAST(v)->type.type)
#define PyCObject_VAR_HEAD      PyCVarObject ob_base;
#define PyC_SET_REFCNT(v,n)     (PyC_CAST(v)->ref_cnt = (n))
#define PyC_REFCNT(v)           (PyC_CAST(v)->ref_cnt)
#define IS_TYPE(ob, typ)        ( (strcmp((PyC_CAST(ob)) -> type.type, (typ))) == 0 )

#ifndef int64_t
#define int64_t long
#endif

extern char ** new_type_table;
extern int64_t num_type;

typedef struct{
    char *          type;
}PyCTypeObject;


typedef struct {
    uint64_t        ref_cnt;
    PyCTypeObject   type;
}PyCObject;

typedef struct {
    PyCObject ob_base;
    size_t ob_size; /* Number of items in variable part */
} PyCVarObject;

#endif // PyCType.h
