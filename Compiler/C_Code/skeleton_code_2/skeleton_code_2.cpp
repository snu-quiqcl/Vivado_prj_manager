#include "RFSoC_Driver.h"
#include "malloc.h"

int main(){
    DAC Raman_CH1;
    DAC Raman_CH2;
    DAC Raman_CH3;

    TTL_out AOM_369;
    TTL_out EOM_14_7;
    TTL_out EOM_2_1;
    TTL_out Raman_Global;

    TimeController tc_0;

    Raman_CH1.set_addr(XPAR_DAC_CONTROLLER_0_BASEADDR);
    Raman_CH1.flush_fifo();
    Raman_CH2.set_addr(XPAR_DAC_CONTROLLER_1_BASEADDR);
    Raman_CH2.flush_fifo();
    Raman_CH3.set_addr(XPAR_DAC_CONTROLLER_2_BASEADDR);
    Raman_CH3.flush_fifo();
    
    EdgeCounter EdgeCounter_0;
    EdgeCounter_0.set_addr(XPAR_EDGECOUNTER_0_BASEADDR);
    EdgeCounter_0.flush_fifo();
    
    uint64_t * ttl_set_0_ptr = (uint64_t *) malloc(sizeof(uint64_t));
    AOM_369.set_addr(XPAR_TTL_OUT_0_BASEADDR,ttl_set_0_ptr,0);
    EOM_14_7.set_addr(XPAR_TTL_OUT_0_BASEADDR,ttl_set_0_ptr,1);
    EOM_2_1.set_addr(XPAR_TTL_OUT_0_BASEADDR,ttl_set_0_ptr,2);
    Raman_Global.set_addr(XPAR_TTL_OUT_0_BASEADDR,ttl_set_0_ptr,3);
    
    tc_0.set_addr(XPAR_TIMECONTROLLER_0_BASEADDR);
    tc_0.auto_stop();
    tc_0.reset();

    xil_printf("RFSoC Start!\r\n");

    tc_0.auto_start();
    
    delay(10000);
    
    int turn_off = 0;
    
    if( turn_off == 1 ){
        Raman_CH1.set_amp(0.0);
        xil_printf("turn off\r\n");
    }
    else{
        Raman_CH1.set_amp(1.0);
        delay(8);
        for( int i = 0 ; i < 800; i++ ){
            Raman_CH1.set_freq((i)*271123);
            delay(1000);
        }
        EdgeCounter_0.reset_count();
        delay(10000);
        EdgeCounter_0.start_count();
        delay(10000);
        EdgeCounter_0.stop_count();
        delay(10000);
        EdgeCounter_0.save_count();
        xil_printf("%d\r\n",EdgeCounter_0.read_len());
        while( 1 ){
            xil_printf("%d\r\n",EdgeCounter_0.read_len());
        }
    }
}
