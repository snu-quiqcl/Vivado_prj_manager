#include <iostream>
#include <vector>
#include "xil_printf.h"
#include "RFSoC_Driver.h"

using namespace::std;

int main(){
    xil_printf("hello world\r\n");
    vector<int> v = {1,2,3,4,10};

    xil_printf("%d %d\r\n",v[0],v[4]);

    delay_coarse((int64_t)10);

    DAC dac_0;
    dac_0.set_freq(10);
}
