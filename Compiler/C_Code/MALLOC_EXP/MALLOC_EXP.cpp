#include <stdio.h>
#include "xil_printf.h"
#include "xil_cache.h"
#include "memory_region.h"
#include "malloc.h"

static int p;

int main(){
	static int q;
	xil_printf("hello world\r\n");

	int* a = (int*)malloc(sizeof(int));
	*a = 50;
	xil_printf("%llx\r\n",a);

	int *b = (int *)malloc(sizeof(int));
	*b = 30;
	xil_printf("%llx %d %llx %d\r\n",a,*a,b,*b);
	xil_printf("%d %d\r\n",q,p);

	return 0;
}
