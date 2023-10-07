#include "RFSoC_Driver.h"

int main(){
    DAC dac_0;
    dac_0.set_addr(XPAR_DAC_CONTROLLER_0_BASEADDR);
    dac_0.flush_fifo();

    DAC dac_1;
    dac_1.set_addr(XPAR_DAC_CONTROLLER_1_BASEADDR);
    dac_1.flush_fifo();

    DAC dac_2;
    dac_2.set_addr(XPAR_DAC_CONTROLLER_2_BASEADDR);
    dac_2.flush_fifo();

    DAC dac_3;
    dac_3.set_addr(XPAR_DAC_CONTROLLER_3_BASEADDR);
    dac_3.flush_fifo();

    DAC dac_4;
    dac_4.set_addr(XPAR_DAC_CONTROLLER_4_BASEADDR);
    dac_4.flush_fifo();

    DAC dac_5;
    dac_5.set_addr(XPAR_DAC_CONTROLLER_5_BASEADDR);
    dac_5.flush_fifo();

    DAC dac_6;
    dac_6.set_addr(XPAR_DAC_CONTROLLER_6_BASEADDR);
    dac_6.flush_fifo();

    DAC dac_7;
    dac_7.set_addr(XPAR_DAC_CONTROLLER_7_BASEADDR);
    dac_7.flush_fifo();

    TTL_out ttl_out_0(XPAR_TTL_OUT_0_BASEADDR);
    ttl_out_0.flush_fifo();

    TTL_out ttl_out_1(XPAR_TTL_OUT_1_BASEADDR);
    ttl_out_1.flush_fifo();

    TTL_out ttl_out_2(XPAR_TTL_OUT_2_BASEADDR);
    ttl_out_2.flush_fifo();

    TTLx8_out ttlx8_out_0(XPAR_TTLX8_OUT_0_BASEADDR);
    ttlx8_out_0.flush_fifo();

    TimeController tc_0(XPAR_TIMECONTROLLER_0_BASEADDR);
    tc_0.auto_stop();
    tc_0.reset();

    //Xil_Out128(XPAR_TTLX8_OUT_0_BASEADDR,MAKE128CONST(0,0xff));
    ttlx8_out_0.set(1);
    ttl_out_2.set(0);
    dac_0.set_config(1.0,100,0,0);
   
    /*
    ttl_out_2.set(1);
    dac_0.set_config(1.0,100000000,0,0);
    delay_coarse(5);
    dac_0.set_config(1.0,80000000,0,0);
    delay_coarse(3);
    dac_0.set_config(0.5,60000000,0,0);
    delay_coarse(20);
    dac_0.set_config(1.0,100000000,0,0);
*/
    

    //delay(30);
    //ttlx8_out_0.set(0);
    //delay(40);
    //ttlx8_out_0.set(1);
    //delay(50);
    //ttlx8_out_0.set(0);
    tc_0.auto_start();
}
