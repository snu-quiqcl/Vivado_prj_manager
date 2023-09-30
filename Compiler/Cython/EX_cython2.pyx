cdef public int foo(int k):
    cdef int x = k + 3
    return x

if __name__ == "__main__":
    foo(30)
