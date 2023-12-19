#include "PyCList.h"
#include "PyCMem.h"

static int
list_resize(PyCListObject *self, size_t newsize)
{
    PyCObject **items = NULL;
    size_t new_allocated, num_allocated_bytes;
    size_t allocated = self->allocated;

    /* Bypass realloc() when a previous overallocation is large enough
       to accommodate the newsize.  If the newsize falls lower than half
       the allocated size, then proceed with the realloc() to shrink the list.
    */
    if (allocated >= newsize && newsize >= (allocated >> 1)) {
        PyC_SET_SIZE(self, newsize);
        return 0;
    }

    /* This over-allocates proportional to the list size, making room
     * for additional growth.  The over-allocation is mild, but is
     * enough to give linear-time amortized behavior over a long
     * sequence of appends() in the presence of a poorly-performing
     * system realloc().
     * Add padding to make the allocated size multiple of 4.
     * The growth pattern is:  0, 4, 8, 16, 24, 32, 40, 52, 64, 76, ...
     * Note: new_allocated won't overflow because the largest possible value
     *       is PY_SSIZE_T_MAX * (9 / 8) + 6 which always fits in a size_t.
     */
    new_allocated = ((size_t)newsize + (newsize >> 3) + 6) & ~(size_t)3;
    /* Do not overallocate if the new size is closer to overallocated size
     * than to the old size.
     */
    if (newsize - PyC_SIZE(self) > (size_t)(new_allocated - newsize))
        new_allocated = ((size_t)newsize + 3) & ~(size_t)3;

    if (newsize == 0)
        new_allocated = 0;
    if (new_allocated <= (size_t)( PyC_SSIZE_T_MAX ) / sizeof(PyCObject *)) {
        num_allocated_bytes = new_allocated * sizeof(PyCObject *);
        items = (PyCObject **)PyCMem_Realloc(self->ob_item, num_allocated_bytes);
    }
    else {
        // integer overflow
        items = NULL;
    }
    if (items == NULL) {
        return -1;
    }
    self->ob_item = items;
    PyC_SET_SIZE(self, newsize);
    self->allocated = new_allocated;
    return 0;
}

static int
ins1(PyCListObject *self, size_t where, PyCObject *v)
{
    size_t i, n = PyC_SIZE(self);
    PyCObject **items;
    if (v == NULL) {
        return -1;
    }

    if (list_resize(self, n+1) < 0)
        return -1;

    if (where < 0) {
        where += n;
        if (where < 0)
            where = 0;
    }
    if (where > n)
        where = n;
    items = self->ob_item;
    for (i = n; --i >= where; )
        items[i+1] = items[i];
    items[where] = PyC_INCREF(v);
    return 0;
}

int
PyCList_Insert(PyCObject *op, size_t where, PyCObject *newitem)
{
    return ins1((PyCListObject *)op, where, newitem);
}

int
_PyCList_AppendTakeRefListResize(PyCListObject *self, PyCObject *newitem)
{
    size_t len = PyC_SIZE(self);
    if (list_resize(self, len + 1) < 0) {
        PyC_DECREF(newitem);
        return -1;
    }
    PyCList_SET_ITEM(self, len, newitem);
    return 0;
}

int
PyCList_Append(PyCObject *op, PyCObject *newitem)
{
    if (newitem != NULL) {
        return _PyCList_AppendTakeRefListResize(PyC_LIST_CAST(op), PyC_INCREF(newitem));
    }
    return -1;
}

void
PyCList_dealloc(PyCListObject *op)
{
    size_t i;
    if (op->ob_item != NULL) {
        /* Do it backwards, for Christian Tismer.
           There's a simple test case where somehow this reduces
           thrashing when a *very* large list is created and
           immediately deleted. */
        i = PyC_SIZE(op);
        while (--i >= 0) {
            PyC_DECREF(op->ob_item[i]);
        }
        free(op->ob_item);
    }
}

void
PyCList_remove(PyCListObject *self, PyCObject *value)
{
    size_t i, j;

    for (i = 0; i < PyC_SIZE(self); i++) {
        PyCObject *obj = self->ob_item[i];
        int64_t cmp = PyCObject_RichCompareBool(obj, value, PyC_EQ);
        if (cmp > 0) {
            PyC_DECREF(self->ob_item[i]);
            for( j = i + 1; j < PyC_SIZE(self); j ++ ){
                self->ob_item[j-1] = self->ob_item[j];
            }
            self->ob_item = PyCMem_Realloc(self->ob_item,PyC_SIZE(self)-1);
            PyC_SET_SIZE(self,PyC_SIZE(self)-1);
        }
    }
}

