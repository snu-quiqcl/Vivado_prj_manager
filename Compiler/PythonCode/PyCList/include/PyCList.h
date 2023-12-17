#ifndef PYCLIST_INCLUDE
#define PYCLIST_INCLUDE

#include <stdlib.h>
#include "PyCMem.h"
#include "PyCType.h"

#define PyC_SET_LEN(v,size) (((v)->len) = (size))
#define PyC_SIZE(v) ((v) -> len)
#define PyC_LIST_CAST(v) ((PyCListObject *)(v))
typedef struct {
    /* Vector of pointers to list elements.  list[0] is ob_item[0], etc. */
    PyCObject **ob_item;

    /* ob_item contains space for 'allocated' elements.  The number
     * currently in use is ob_size.
     * Invariants:
     *     0 <= ob_size <= allocated
     *     len(list) == ob_size
     *     ob_item ll NULL implies ob_size == allocated == 0
     * list.sort() temporarily sets allocated to -1 to detect mutations.
     *
     * Items must normally not be NULL, except during construction when
     * the list is not yet visible outside the function that builds it.
     */
    //Allocated memory
    size_t allocated;
    //length of list
    size_t  len;
} PyCListObject;

static int list_resize(PyCListObject *self, size_t newsize);

static inline PyCObject *
PyCList_New(size_t size)
{
    PyCListObject *op;

    if (size < 0) {
        return NULL;
    }

    op = PyC_LIST_CAST(PyCMem_Malloc(sizeof(PyCListObject)));
    if (op == NULL) {
        return NULL;
    }
    PyC_CAST(op) -> type.type = "list";

    PyCListObject * op_ele = PyC_LIST_CAST(PyC_ELE(op));

    if (size <= 0) {
        op_ele->ob_item = NULL;
    }
    else {
        op_ele->ob_item = (PyCObject **) PyCMem_Calloc(size, sizeof(PyCObject *));
        if (op_ele->ob_item == NULL) {
            PyC_DECREF(op);
            return NULL;
        }
    }
    op_ele->allocated = size;
    PyC_SET_LEN(op_ele, size);
    return (PyCObject *) op;
}

#endif
