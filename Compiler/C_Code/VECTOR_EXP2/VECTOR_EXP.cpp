#include <stdio.h>
#include "xil_printf.h"
#include "xil_cache.h"
#include "malloc.h"
#include <vector>
#include <iostream>

using namespace::std;

static int p;

template <typename T>
class Pseudo_List{
	public:
		int64_t size = 0;
		int64_t capacity = 1;
		T * first = NULL;
	public:
		Pseudo_List(int64_t size = 0){
			this->size = size;
			while(capacity < size){
				this->capacity *= 2;
			}
			this->first = (T *)malloc(sizeof(T) * capacity);
		};
		void PLappend(T value);
		void PLdelete(int64_t index);
};

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

	Pseudo_List<int> PL_v;

	return 0;
}
