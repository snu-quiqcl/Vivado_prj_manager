#include <iostream>
#include <vector>
#include "xil_printf.h"

using namespace::std;

int main(){
    xil_printf("hello world\r\n");
    vector<int> v = {1,2,3,4,10};

    xil_printf("%d %d\r\n",v[0],v[4]);
}
