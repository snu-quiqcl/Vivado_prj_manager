#include <stdio.h>
#include "xil_printf.h"
#include "xil_cache.h"
#include "malloc.h"
#include <vector>
#include <iostream>

using namespace::std;

static int p = 30;
static int q;

int main(){
    xil_printf("hello world\r\n");
    vector<int> v = {1,2,3};
    int * u = (int *) malloc(sizeof(int));
    *u = 3014;
    
    xil_printf("v[2] : %d u : %d p : %d q : %d\n\r",v[2], *u, p, q);
}
