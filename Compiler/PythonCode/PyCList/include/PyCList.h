#ifndef PYCLIST_INCLUDE
#define PYCLIST_INCLUDE

#ifdef__cplusplus
extern "C"{
#endif

#include <stdlib.h>
#include "PyCMem.h"
#include "PyCType.h"

#define PyC_LIST_CAST(v) ((PyCListObject *)(v))

typedef struct {
    PyCObject_VAR_HEAD
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
} PyCListObject;


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
    PyC_SET_TYPE(op,"list");

    if (size <= 0) {
        op->ob_item = NULL;
    }
    else {
        op->ob_item = (PyCObject **) PyCMem_Calloc(size, sizeof(PyCObject *));
        if (op->ob_item == NULL) {
            PyC_DECREF(op);
            return NULL;
        }
    }
    op->allocated = size;
    PyC_SET_SIZE(op, size);
    return (PyCObject *) op;
}

static inline void
PyCList_SET_ITEM(PyCObject *op, size_t index, PyCObject *value) {
    PyC_LIST_CAST(op)->ob_item[index] = value;
}

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
    PyCListObject * v = PyC_LIST_CAST(op);
    if (!valid_index(i, PyC_SIZE(v))) {
        return NULL;
    }
    return v -> ob_item[i];
}

void PyCList_dealloc(PyCListObject *op);
void PyCList_remove(PyCListObject *self, PyCObject *value);

#ifdef__cplusplus
}
#endif

#endif
