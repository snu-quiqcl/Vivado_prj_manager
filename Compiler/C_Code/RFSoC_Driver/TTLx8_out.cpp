#include "RFSoC_Driver.h"

void TTLx8_out::set(uint64_t pulse){
    xil_printf("timestamp %d timestamp corase %d last pulse %d\r\n",get_timestamp(), get_timestamp_coarse(), this->last_output_time);

    if( ( ( this -> last_output_time ) >> 3) < get_timestamp_coarse() ){
        uint64_t temp_last_pulse = (this->last_pulse >> 7 )& 0x1;
        this->last_pulse = 0;

        for( int i = 0; i < (get_timestamp() % 8); i ++ ){
            this-> last_pulse += (temp_last_pulse << i);
            xil_printf("last pulse update: %llx\r\n",this->last_pulse);
        }

        this->last_pulse += this->last_pulse | ( pulse << ( get_timestamp() % 8 ) ) ;
        this->last_output_time = get_timestamp();
    }
    else{
        int i = (get_timestamp() % 8);
        for( i ; i < 8 ; i++){
            this->last_pulse = (this->last_pulse & ( 0xff - (1 << i) )) | ( pulse << i );
        }
        this->last_output_time = get_timestamp();
    }

    xil_printf("timestamp %d timestamp corase %d last pulse %d\r\n",get_timestamp(), get_timestamp_coarse(), this->last_output_time);
    xil_printf("%llx\r\n",this->last_pulse);

    Xil_Out128(this->addr,MAKE128CONST( get_timestamp_coarse(), this->last_pulse));
    return;
}

void TTLx8_out::set_ch(const char * pulse_ch){
    if( strcmp(pulse_ch,"ON") == 0 || strcmp(pulse_ch,"oN") == 0 || strcmp(pulse_ch, "On") == 0 || strcmp(pulse_ch, "on") == 0){
        this -> set(1);
    }
    else if( strcmp(pulse_ch,"OFF") == 0 || strcmp(pulse_ch,"OFf") == 0 || strcmp(pulse_ch, "OfF") == 0 || strcmp(pulse_ch, "Off") == 0 || strcmp(pulse_ch, "oFF") == 0 || strcmp(pulse_ch, "oFf") == 0 || strcmp(pulse_ch, "ofF") == 0 || strcmp(pulse_ch,"off") == 0 ){
        this -> set(0);
    }
    Xil_Out128(this->addr,MAKE128CONST( get_timestamp_coarse(),this->last_pulse));
    return;
}

uint64_t TTLx8_out::get_last_pulse(){
    return (this->last_pulse) >> ( ( this -> last_output_time ) % 8);
}

void TTLx8_out::flush_fifo(){
    Xil_Out128((this->addr | 0x10),MAKE128CONST(0,1));
}
