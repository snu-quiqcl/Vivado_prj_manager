#include "RFSoC_Driver.h"
#include "malloc.h"

DAC dac_0;
DAC dac_1;
DAC dac_2;
DAC dac_3;
DAC dac_4;
DAC dac_5;
DAC dac_6;
DAC dac_7;
TTL_out ttl_out_0;
TTL_out ttl_out_1;
TTL_out ttl_out_2;
TTL_out ttl_out_3;
TTL_out ttl_out_4;
TTL_out ttl_out_5;
TTL_out ttl_out_6;
TTL_out ttl_out_7;
TTLx8_out ttlx8_out_0(XPAR_TTLX8_OUT_0_BASEADDR);
TTLx8_out ttlx8_out_1(XPAR_TTLX8_OUT_1_BASEADDR);
TTLx8_out ttlx8_out_2(XPAR_TTLX8_OUT_2_BASEADDR);
TTLx8_out ttlx8_out_3(XPAR_TTLX8_OUT_3_BASEADDR);
TTLx8_out ttlx8_out_4(XPAR_TTLX8_OUT_4_BASEADDR);
TimeController tc_0;
void init_rfsoc(){
    dac_0.set_addr(XPAR_DAC_CONTROLLER_0_BASEADDR);
    dac_0.flush_fifo();
    dac_1.set_addr(XPAR_DAC_CONTROLLER_1_BASEADDR);
    dac_1.flush_fifo();
    dac_2.set_addr(XPAR_DAC_CONTROLLER_2_BASEADDR);
    dac_2.flush_fifo();
    dac_3.set_addr(XPAR_DAC_CONTROLLER_3_BASEADDR);
    dac_3.flush_fifo();
    dac_4.set_addr(XPAR_DAC_CONTROLLER_4_BASEADDR);
    dac_4.flush_fifo();
    dac_5.set_addr(XPAR_DAC_CONTROLLER_5_BASEADDR);
    dac_5.flush_fifo();
    dac_6.set_addr(XPAR_DAC_CONTROLLER_6_BASEADDR);
    dac_6.flush_fifo();
    dac_7.set_addr(XPAR_DAC_CONTROLLER_7_BASEADDR);
    dac_7.flush_fifo();
    uint64_t * ttl_set_0_ptr = (uint64_t *) malloc(sizeof(uint64_t));
    ttl_out_0.set_addr(XPAR_TTL_OUT_0_BASEADDR,ttl_set_0_ptr,0);
    ttl_out_1.set_addr(XPAR_TTL_OUT_0_BASEADDR,ttl_set_0_ptr,1);
    ttl_out_2.set_addr(XPAR_TTL_OUT_0_BASEADDR,ttl_set_0_ptr,2);
    ttl_out_3.set_addr(XPAR_TTL_OUT_0_BASEADDR,ttl_set_0_ptr,3);
    ttl_out_4.set_addr(XPAR_TTL_OUT_0_BASEADDR,ttl_set_0_ptr,4);
    ttl_out_5.set_addr(XPAR_TTL_OUT_0_BASEADDR,ttl_set_0_ptr,5);
    ttl_out_6.set_addr(XPAR_TTL_OUT_0_BASEADDR,ttl_set_0_ptr,6);
    ttl_out_7.set_addr(XPAR_TTL_OUT_0_BASEADDR,ttl_set_0_ptr,7);
    ttl_out_0.flush_fifo();
    ttlx8_out_0.flush_fifo();
    ttlx8_out_1.flush_fifo();
    ttlx8_out_2.flush_fifo();
    ttlx8_out_3.flush_fifo();
    ttlx8_out_4.flush_fifo();
    tc_0.set_addr(XPAR_TIMECONTROLLER_0_BASEADDR);
    tc_0.auto_stop();
    tc_0.reset();
}

int main(){
    init_rfsoc();
    xil_printf("RFSoC Start\r\n");

    dac_0.set_amp(0.1);
    delay(16);
    dac_0.set_freq(1000);
    delay(16);

    tc_0.auto_start();
}
