#include "RFSoC_Driver.h"
#include "malloc.h"

DAC Raman_CH1;
DAC Raman_CH2;
DAC Raman_CH3;

TTL_out AOM_369;
TTL_out EOM_14_7;
TTL_out EOM_2_1;
TTL_out Raman_Global;

TimeController tc_0;
void init_rfsoc(){
    Raman_CH1.set_addr(XPAR_DAC_CONTROLLER_0_BASEADDR);
    Raman_CH1.flush_fifo();
    Raman_CH2.set_addr(XPAR_DAC_CONTROLLER_1_BASEADDR);
    Raman_CH2.flush_fifo();
    Raman_CH3.set_addr(XPAR_DAC_CONTROLLER_2_BASEADDR);
    Raman_CH3.flush_fifo();
    
    uint64_t * ttl_set_0_ptr = (uint64_t *) malloc(sizeof(uint64_t));
    AOM_369.set_addr(XPAR_TTL_OUT_0_BASEADDR,ttl_set_0_ptr,0);
    EOM_14_7.set_addr(XPAR_TTL_OUT_0_BASEADDR,ttl_set_0_ptr,1);
    EOM_2_1.set_addr(XPAR_TTL_OUT_0_BASEADDR,ttl_set_0_ptr,2);
    Raman_Global.set_addr(XPAR_TTL_OUT_0_BASEADDR,ttl_set_0_ptr,3);
    
    tc_0.set_addr(XPAR_TIMECONTROLLER_0_BASEADDR);
    tc_0.auto_stop();
    tc_0.reset();
}

int main(){
    init_rfsoc();
    xil_printf("RFSoC Start\r\n");

    AOM_369.set(1);
    EOM_14_7.set(1);
    EOM_2_1.set(1);

    int64_t t_5ms = 1000;
    int64_t t_20us = 20000;
    int64_t t_30us = 30000;

    //delay 5ms -> 1000ns

    for(int j = 0 ; j < 100 ; j++){
        delay(t_5ms);
        AOM_369.set(0);
        EOM_14_7.set(0);
        EOM_2_1.set(0);

        for( int i = 0 ; i < 30; i++){
            Raman_CH1.set_freq(201643000);
            Raman_CH2.set_freq(201643000);
            Raman_CH3.set_freq(201643000);
            delay(8);

            //sideband cooling for 30us
            Raman_Global.set(1);
            Raman_CH1.set_amp(1.0);
            Raman_CH2.set_amp(1.0);
            Raman_CH3.set_amp(1.0);

            delay(t_30us);

            //Turn off RF signals
            Raman_CH1.set_amp(0.0);
            Raman_CH2.set_amp(0.0);
            Raman_CH3.set_amp(0.0);
            Raman_Global.set(0);

            //sideband cooling for 20us
            AOM_369.set(1);
            EOM_2_1.set(1);

            delay(t_20us);
            AOM_369.set(0);
            EOM_2_1.set(0);
        }

        //initialization
        AOM_369.set(1);
        EOM_2_1.set(1);
        delay(t_20us);
        AOM_369.set(0);
        EOM_2_1.set(0);

        Raman_CH1.set_freq(198367000);
        Raman_CH2.set_freq(198367000);
        delay(8);

        Raman_Global.set(1);
        Raman_CH1.set_amp(0.35);
        Raman_CH2.set_amp(0.35);

        delay(t_20us);
    
        Raman_CH1.set_amp(0.6);
        Raman_CH2.set_amp(0.6);

        delay(t_20us);
    
        Raman_CH1.set_amp(0.8);
        Raman_CH2.set_amp(0.8);

        delay(t_20us);

        Raman_CH1.set_amp(0.95);
        Raman_CH2.set_amp(0.95);

        delay(t_20us);

        Raman_CH1.set_amp(1.0);
        Raman_CH2.set_amp(1.0);

        delay(t_20us);

        Raman_CH1.set_amp(0.95);
        Raman_CH2.set_amp(0.95);


        delay(t_20us);
    
        Raman_CH1.set_amp(0.8);
        Raman_CH2.set_amp(0.8);


        delay(t_20us);
    
        Raman_CH1.set_amp(0.6);
        Raman_CH2.set_amp(0.6);

        delay(t_20us);

        Raman_CH1.set_amp(0.35);
        Raman_CH2.set_amp(0.35);

        delay(t_20us);

        Raman_Global.set(0);
        Raman_CH1.set_amp(0.0);
        Raman_CH2.set_amp(0.0);

        //Detection is not implemented yet

        //Recooling 
        AOM_369.set(1);
        EOM_2_1.set(1);

        tc_0.auto_start();
    }

}
