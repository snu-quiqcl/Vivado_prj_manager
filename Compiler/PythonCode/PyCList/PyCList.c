#include "PyCList.h"
#include "PyCMem.h"

#define PyC_SET_SIZE(v,size) (((v)->len) = (size))

static int
list_resize(PyCListObject *self, size_t newsize)
{
    PyCObject **items;
    size_t new_allocated, num_allocated_bytes;
    size_t allocated = self->allocated;

    /* Bypass realloc() when a previous overallocation is large enough
       to accommodate the newsize.  If the newsize falls lower than half
       the allocated size, then proceed with the realloc() to shrink the list.
    */
    if (allocated >= newsize && newsize >= (allocated >> 1)) {
        PyC_SET_LEN(self, newsize);
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
