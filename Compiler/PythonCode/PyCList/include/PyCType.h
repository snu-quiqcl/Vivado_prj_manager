#ifndef PYCTYPE_INCLUDE
#define PYCTYPE_INCLUDE

#include <stdint.h>

#define NUM_TYPE        (3)     // number of declared types
#define MAX_TYPE_LEN    (20)    // Length of type name
#define BYTE_BIT        (8)     // Bit number of 1 byte
#define INT64_SIZE      (8*BYTE_BIT)

#define PyC_CAST(v)       ((PyCObject *) (v) )

#ifndef int64_t
#define int64_t long
#endif

extern char ** new_type_table;
extern int64_t num_type;

typedef struct{
    uint64_t        size;
    char *          type;
}PyCTypeObject;


typedef struct {
    uint64_t        ref_cnt;
    PyCTypeObject   type;
}PyCObject;

#endif // PyCType.h
