#include "PyCType.h"

int64_t num_type = (NUM_TYPE + 0);
char type_table[NUM_TYPE][MAX_TYPE_LEN] = \
{
    "int64",
    "float64",
    "uint8",
    "list"
};

int64_t
do_richcompare(PyCObject *v, PyCObject *w, int op)
{
    richcmpfunc f;
    int64_t res;

    if (PyC_IS_TYPE(v, PyC_GET_TYPE(w)) &&
        (f = PyC_TYPE(w).tp_richcompare) != NULL) {
        res = (*f)(w, v, op);
        return res;
    }
    return PyC_RETURN_FALSE;
}


int64_t
PyCObject_RichCompare(PyCObject *v, PyCObject *w, int op)
{
    if (v == NULL || w == NULL) {
        return PyC_RETURN_FALSE;
    }
    int64_t res = do_richcompare(v, w, op);
    return res;
}

int64_t
PyCObject_RichCompareBool(PyCObject *v, PyCObject *w, int op)
{
    int64_t res;
    PyCObject * ok;

    /* Quick result when objects are the same.
       Guarantees that identity implies equality. */
    if (v == w) {
        if (op == PyC_EQ)
            return PyC_RETURN_TRUE;
        else if (op == PyC_NE)
            return PyC_RETURN_FALSE;
    }

    res = PyCObject_RichCompare(v, w, op);
    return res;
}

int strcmp(char * a, char * b){
    int i = 0;
    do{
        if( *(a+i) != *(b+i) ){
            return 1;
        }
        else if(*(a+i) == '\0'){
            if( *(b+i) == '\0'){
                return 0;
            }
            else return 1;
        }

        else i+=1;
    }while(1);
}

