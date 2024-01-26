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
EdgeCounter EdgeCounter_0;
EdgeCounter EdgeCounter_1;
EdgeCounter EdgeCounter_2;
EdgeCounter EdgeCounter_3;
TTL_out ttl_out_0;
TTL_out ttl_out_1;
TTL_out ttl_out_2;
TTL_out ttl_out_3;
TTL_out ttl_out_4;
TTL_out ttl_out_5;
TTL_out ttl_out_6;
TTL_out ttl_out_7;
TTL_out ttl_out_8;
TTL_out ttl_out_9;
TTL_out ttl_out_10;
TTL_out ttl_out_11;
TTL_out ttl_out_12;
TTL_out ttl_out_13;
TTL_out ttl_out_14;
TTL_out ttl_out_15;
TTL_out ttl_out_16;
TTL_out ttl_out_17;
TTL_out ttl_out_18;
TTL_out ttl_out_19;
TTL_out ttl_out_20;
TTL_out ttl_out_21;
TTL_out ttl_out_22;
TTL_out ttl_out_23;
TTL_out ttl_out_24;
TTL_out ttl_out_25;
TTL_out ttl_out_26;
TTL_out ttl_out_27;
TTL_out ttl_out_28;
TTL_out ttl_out_29;
TTL_out ttl_out_30;
TTL_out ttl_out_31;
TTL_out ttl_out_32;
TTL_out ttl_out_33;
TTL_out ttl_out_34;
TTL_out ttl_out_35;
TTL_out ttl_out_36;
TTL_out ttl_out_37;
TTL_out ttl_out_38;
TTL_out ttl_out_39;
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
    EdgeCounter_0.set_addr((XPAR_EDGECOUNTER_0_BASEADDR));
    EdgeCounter_0.flush_fifo();
    EdgeCounter_1.set_addr((XPAR_EDGECOUNTER_1_BASEADDR));
    EdgeCounter_1.flush_fifo();
    EdgeCounter_2.set_addr((XPAR_EDGECOUNTER_2_BASEADDR));
    EdgeCounter_2.flush_fifo();
    EdgeCounter_3.set_addr((XPAR_EDGECOUNTER_3_BASEADDR));
    EdgeCounter_3.flush_fifo();
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
    uint64_t * ttl_set_1_ptr = (uint64_t *) malloc(sizeof(uint64_t));
    ttl_out_8.set_addr(XPAR_TTL_OUT_1_BASEADDR,ttl_set_1_ptr,0);
    ttl_out_9.set_addr(XPAR_TTL_OUT_1_BASEADDR,ttl_set_1_ptr,1);
    ttl_out_10.set_addr(XPAR_TTL_OUT_1_BASEADDR,ttl_set_1_ptr,2);
    ttl_out_11.set_addr(XPAR_TTL_OUT_1_BASEADDR,ttl_set_1_ptr,3);
    ttl_out_12.set_addr(XPAR_TTL_OUT_1_BASEADDR,ttl_set_1_ptr,4);
    ttl_out_13.set_addr(XPAR_TTL_OUT_1_BASEADDR,ttl_set_1_ptr,5);
    ttl_out_14.set_addr(XPAR_TTL_OUT_1_BASEADDR,ttl_set_1_ptr,6);
    ttl_out_15.set_addr(XPAR_TTL_OUT_1_BASEADDR,ttl_set_1_ptr,7);
    ttl_out_8.flush_fifo();
    uint64_t * ttl_set_2_ptr = (uint64_t *) malloc(sizeof(uint64_t));
    ttl_out_16.set_addr(XPAR_TTL_OUT_2_BASEADDR,ttl_set_2_ptr,0);
    ttl_out_17.set_addr(XPAR_TTL_OUT_2_BASEADDR,ttl_set_2_ptr,1);
    ttl_out_18.set_addr(XPAR_TTL_OUT_2_BASEADDR,ttl_set_2_ptr,2);
    ttl_out_19.set_addr(XPAR_TTL_OUT_2_BASEADDR,ttl_set_2_ptr,3);
    ttl_out_20.set_addr(XPAR_TTL_OUT_2_BASEADDR,ttl_set_2_ptr,4);
    ttl_out_21.set_addr(XPAR_TTL_OUT_2_BASEADDR,ttl_set_2_ptr,5);
    ttl_out_22.set_addr(XPAR_TTL_OUT_2_BASEADDR,ttl_set_2_ptr,6);
    ttl_out_23.set_addr(XPAR_TTL_OUT_2_BASEADDR,ttl_set_2_ptr,7);
    ttl_out_16.flush_fifo();
    uint64_t * ttl_set_3_ptr = (uint64_t *) malloc(sizeof(uint64_t));
    ttl_out_24.set_addr(XPAR_TTL_OUT_3_BASEADDR,ttl_set_3_ptr,0);
    ttl_out_25.set_addr(XPAR_TTL_OUT_3_BASEADDR,ttl_set_3_ptr,1);
    ttl_out_26.set_addr(XPAR_TTL_OUT_3_BASEADDR,ttl_set_3_ptr,2);
    ttl_out_27.set_addr(XPAR_TTL_OUT_3_BASEADDR,ttl_set_3_ptr,3);
    ttl_out_28.set_addr(XPAR_TTL_OUT_3_BASEADDR,ttl_set_3_ptr,4);
    ttl_out_29.set_addr(XPAR_TTL_OUT_3_BASEADDR,ttl_set_3_ptr,5);
    ttl_out_30.set_addr(XPAR_TTL_OUT_3_BASEADDR,ttl_set_3_ptr,6);
    ttl_out_31.set_addr(XPAR_TTL_OUT_3_BASEADDR,ttl_set_3_ptr,7);
    ttl_out_24.flush_fifo();
    uint64_t * ttl_set_4_ptr = (uint64_t *) malloc(sizeof(uint64_t));
    ttl_out_32.set_addr(XPAR_TTL_OUT_4_BASEADDR,ttl_set_4_ptr,0);
    ttl_out_33.set_addr(XPAR_TTL_OUT_4_BASEADDR,ttl_set_4_ptr,1);
    ttl_out_34.set_addr(XPAR_TTL_OUT_4_BASEADDR,ttl_set_4_ptr,2);
    ttl_out_35.set_addr(XPAR_TTL_OUT_4_BASEADDR,ttl_set_4_ptr,3);
    ttl_out_36.set_addr(XPAR_TTL_OUT_4_BASEADDR,ttl_set_4_ptr,4);
    ttl_out_37.set_addr(XPAR_TTL_OUT_4_BASEADDR,ttl_set_4_ptr,5);
    ttl_out_38.set_addr(XPAR_TTL_OUT_4_BASEADDR,ttl_set_4_ptr,6);
    ttl_out_39.set_addr(XPAR_TTL_OUT_4_BASEADDR,ttl_set_4_ptr,7);
    ttl_out_32.flush_fifo();
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

    EdgeCounter_3.reset_count();
    ttl_out_0.set(0);
    delay(100);
    tc_0.auto_start();

    EdgeCounter_3.start_count();

    for( int64_t i = 0 ; i < 2000; i ++ ){
        delay(100);
        ttl_out_0.set(1);
        delay(100);
        ttl_out_0.set(0);
    }

    delay(1000);
    EdgeCounter_3.stop_count();

    delay(1000);
    EdgeCounter_3.save_count();

    while( 1 ){
        int64_t len = LOWER(EdgeCounter_3.read_len());
        xil_printf("LEN : %d\r\n", len);
        if( len != 0 ) break;
    }

    xil_printf("%d\r\n",LOWER(EdgeCounter_3.read_count()));
}
