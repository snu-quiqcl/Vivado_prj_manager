#include "xil_printf.h"
#include "RFSoC_Driver.h"



int main(){
    xil_printf("hello world\r\n");

    delay_coarse((int64_t)10);

    DAC dac_0;
    TTL_out ttl_0;
    TimeController tc;

    tc.auto_stop();
    tc.reset();


    dac_0.set_freq(10);
    ttl_0.set(0);

    xil_printf("hello world!\r\n");
    xil_printf("%d %d\r\n",get_timestamp(), get_timestamp_coarse());
    
    tc.reset();
    tc.auto_start();

    xil_printf("%llx\r\n",ttl_0.addr);
    xil_printf("???\r\n");
    reg128_write((uint64_t)ttl_0.addr,(uint64_t)80,(uint64_t)1);

    tc.auto_start();

    delay_coarse(100000000);

    for( int i = 0 ; i < 200; i ++){
        delay_coarse(100000000);
        ttl_0.set(i%2);
        xil_printf("%d\r\n",get_current_timestamp());
    }
}
