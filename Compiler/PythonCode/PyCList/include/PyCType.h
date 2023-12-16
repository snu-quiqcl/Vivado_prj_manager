#define NUM_TYPE    3;
#define MAX_TYPE_LEN    20;

char ** new_type_table;
int64_t num_type = NUM_TYPE + 0;
char type_table[NUM_TYPE][MAX_TYPE_LEN] = \
{
    "int64",
    "float64",
    "uint8"
};

typedef struct {
    uint64_t        ref_cnt;
    PyCTypeObject * type;
}PyCObject;

typedef struct{
    uint64_t        size;
    char *          type;
}PyCTypeObject;

typedef struct{
    int8_t          size;
    int8_t          sign;
    int64_t         value;
}PyCLongObject;
