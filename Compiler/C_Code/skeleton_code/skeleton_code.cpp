#include "RFSoC_Driver.h"

int main(){
    DAC dac_0;
    dac_0.set_addr(XPAR_DAC_CONTROLLER_0_BASEADDR);
    dac_0.flush_fifo();

    TTL_out ttl_out_0(XPAR_TTL_OUT_0_BASEADDR);
    ttl_out_0.flush_fifo();

    TTL_out ttl_out_1(XPAR_TTL_OUT_1_BASEADDR);
    ttl_out_1.flush_fifo();

    TTLx8_out ttlx8_out_0(XPAR_TTLX8_OUT_0_BASEADDR);
    ttlx8_out_0.flush_fifo();

    TTLx8_out ttlx8_out_1(XPAR_TTLX8_OUT_1_BASEADDR);
    ttlx8_out_1.flush_fifo();

    TimeController tc_0(XPAR_TIMECONTROLLER_0_BASEADDR);
    tc_0.auto_stop();
    tc_0.reset();
    
    dac_0.set_config(1.0,10000,0,0);

    tc_0.auto_start();
}
