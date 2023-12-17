#ifndef PYCLIST_INCLUDE
#define PYCLIST_INCLUDE

#include <stdlib.h>
#include "PyCMem.h"
#include "PyCType.h"

#define PyC_SET_LEN(v,size) (((v)->len) = (size))
#define PyC_LIST_CAST(v) ((PyCListObject *)(v))
#define PyC_LIST_SIZE(v) (PyC_LIST_CAST(v) -> len)

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

static inline void
PyCList_SET_ITEM(PyCObject *op, size_t index, PyCObject *value) {
    PyCListObject *list = PyC_LIST_CAST(op);
    list->ob_item[index] = value;
}

static int ins1(PyCListObject *self, size_t where, PyCObject *v);
int PyList_Insert(PyCObject *op, size_t where, PyCObject *newitem);
int _PyList_AppendTakeRefListResize(PyCListObject *self, PyCObject *newitem);
int PyList_Append(PyCObject *op, PyCObject *newitem);

static inline int
valid_index(size_t i, size_t limit)
{
    /* The cast to size_t lets us use just a single comparison
       to check whether i is in the range: 0 <= i < limit.

       See:  Section 14.2 "Bounds Checking" in the Agner Fog
       optimization manual found at:
       https://www.agner.org/optimize/optimizing_cpp.pdf
    */
    return (size_t) i < (size_t) limit;
}

static inline PyCObject *
PyCList_GetItem(PyCObject *op, size_t i)
{
    if (!valid_index(i, PyC_LIST_SIZE(op))) {
        return NULL;
    }
    return ((PyCListObject *)op) -> ob_item[i];
}

#endif
