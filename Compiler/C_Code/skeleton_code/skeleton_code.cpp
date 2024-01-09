#include "RFSoC_Driver.h"
#include "malloc.h"

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

    uint64_t * ttl_set_0_ptr = (uint64_t *) malloc(sizeof(uint64_t));
    TTL_out ttl_out_0(XPAR_TTL_OUT_0_BASEADDR,ttl_set_0_ptr,0);
    TTL_out ttl_out_1(XPAR_TTL_OUT_0_BASEADDR,ttl_set_0_ptr,1);
    TTL_out ttl_out_2(XPAR_TTL_OUT_0_BASEADDR,ttl_set_0_ptr,2);
    TTL_out ttl_out_3(XPAR_TTL_OUT_0_BASEADDR,ttl_set_0_ptr,3);
    TTL_out ttl_out_4(XPAR_TTL_OUT_0_BASEADDR,ttl_set_0_ptr,4);
    TTL_out ttl_out_5(XPAR_TTL_OUT_0_BASEADDR,ttl_set_0_ptr,5);
    TTL_out ttl_out_6(XPAR_TTL_OUT_0_BASEADDR,ttl_set_0_ptr,6);
    TTL_out ttl_out_7(XPAR_TTL_OUT_0_BASEADDR,ttl_set_0_ptr,7);
    ttl_out_0.flush_fifo();

    uint64_t * ttl_set_1_ptr = (uint64_t *) malloc(sizeof(uint64_t));
    TTL_out ttl_out_8(XPAR_TTL_OUT_1_BASEADDR,ttl_set_1_ptr,0);
    TTL_out ttl_out_9(XPAR_TTL_OUT_1_BASEADDR,ttl_set_1_ptr,1);
    TTL_out ttl_out_10(XPAR_TTL_OUT_1_BASEADDR,ttl_set_1_ptr,2);
    TTL_out ttl_out_11(XPAR_TTL_OUT_1_BASEADDR,ttl_set_1_ptr,3);
    TTL_out ttl_out_12(XPAR_TTL_OUT_1_BASEADDR,ttl_set_1_ptr,4);
    TTL_out ttl_out_13(XPAR_TTL_OUT_1_BASEADDR,ttl_set_1_ptr,5);
    TTL_out ttl_out_14(XPAR_TTL_OUT_1_BASEADDR,ttl_set_1_ptr,6);
    TTL_out ttl_out_15(XPAR_TTL_OUT_1_BASEADDR,ttl_set_1_ptr,7);
    ttl_out_1.flush_fifo();

    uint64_t * ttl_set_2_ptr = (uint64_t *) malloc(sizeof(uint64_t));
    TTL_out ttl_out_16(XPAR_TTL_OUT_2_BASEADDR,ttl_set_2_ptr,0);
    TTL_out ttl_out_17(XPAR_TTL_OUT_2_BASEADDR,ttl_set_2_ptr,1);
    TTL_out ttl_out_18(XPAR_TTL_OUT_2_BASEADDR,ttl_set_2_ptr,2);
    TTL_out ttl_out_19(XPAR_TTL_OUT_2_BASEADDR,ttl_set_2_ptr,3);
    TTL_out ttl_out_20(XPAR_TTL_OUT_2_BASEADDR,ttl_set_2_ptr,4);
    TTL_out ttl_out_21(XPAR_TTL_OUT_2_BASEADDR,ttl_set_2_ptr,5);
    TTL_out ttl_out_22(XPAR_TTL_OUT_2_BASEADDR,ttl_set_2_ptr,6);
    TTL_out ttl_out_23(XPAR_TTL_OUT_2_BASEADDR,ttl_set_2_ptr,7);
    ttl_out_2.flush_fifo();

    uint64_t * ttl_set_3_ptr = (uint64_t *) malloc(sizeof(uint64_t));
    TTL_out ttl_out_24(XPAR_TTL_OUT_3_BASEADDR,ttl_set_3_ptr,0);
    TTL_out ttl_out_25(XPAR_TTL_OUT_3_BASEADDR,ttl_set_3_ptr,1);
    TTL_out ttl_out_26(XPAR_TTL_OUT_3_BASEADDR,ttl_set_3_ptr,2);
    TTL_out ttl_out_27(XPAR_TTL_OUT_3_BASEADDR,ttl_set_3_ptr,3);
    TTL_out ttl_out_28(XPAR_TTL_OUT_3_BASEADDR,ttl_set_3_ptr,4);
    TTL_out ttl_out_29(XPAR_TTL_OUT_3_BASEADDR,ttl_set_3_ptr,5);
    TTL_out ttl_out_30(XPAR_TTL_OUT_3_BASEADDR,ttl_set_3_ptr,6);
    TTL_out ttl_out_31(XPAR_TTL_OUT_3_BASEADDR,ttl_set_3_ptr,7);
    ttl_out_3.flush_fifo();

    uint64_t * ttl_set_4_ptr = (uint64_t *) malloc(sizeof(uint64_t));
    TTL_out ttl_out_32(XPAR_TTL_OUT_4_BASEADDR,ttl_set_4_ptr,0);
    TTL_out ttl_out_33(XPAR_TTL_OUT_4_BASEADDR,ttl_set_4_ptr,1);
    TTL_out ttl_out_34(XPAR_TTL_OUT_4_BASEADDR,ttl_set_4_ptr,2);
    TTL_out ttl_out_35(XPAR_TTL_OUT_4_BASEADDR,ttl_set_4_ptr,3);
    TTL_out ttl_out_36(XPAR_TTL_OUT_4_BASEADDR,ttl_set_4_ptr,4);
    TTL_out ttl_out_37(XPAR_TTL_OUT_4_BASEADDR,ttl_set_4_ptr,5);
    TTL_out ttl_out_38(XPAR_TTL_OUT_4_BASEADDR,ttl_set_4_ptr,6);
    TTL_out ttl_out_39(XPAR_TTL_OUT_4_BASEADDR,ttl_set_4_ptr,7);
    ttl_out_4.flush_fifo();

    TTLx8_out ttlx8_out_0(XPAR_TTLX8_OUT_0_BASEADDR);
    ttlx8_out_0.flush_fifo();

    TTLx8_out ttlx8_out_1(XPAR_TTLX8_OUT_1_BASEADDR);
    ttlx8_out_1.flush_fifo();

    TTLx8_out ttlx8_out_2(XPAR_TTLX8_OUT_2_BASEADDR);
    ttlx8_out_2.flush_fifo();

    TTLx8_out ttlx8_out_3(XPAR_TTLX8_OUT_3_BASEADDR);
    ttlx8_out_3.flush_fifo();

    TTLx8_out ttlx8_out_4(XPAR_TTLX8_OUT_4_BASEADDR);
    ttlx8_out_4.flush_fifo();

    TimeController tc_0(XPAR_TIMECONTROLLER_0_BASEADDR);
    tc_0.auto_stop();
    tc_0.reset();

    xil_printf("running\r\n");

    while(1){
        xil_printf("aasdf");
        xil_printf("asd");
    }
    xil_printf("???");
}
