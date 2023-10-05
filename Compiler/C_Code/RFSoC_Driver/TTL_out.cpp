#include "RFSoC_Driver.h"

void TTL_out::set(uint64_t pulse){
    this->last_pulse = pulse;
    Xil_Out128(this->addr,MAKE128CONST( get_timestamp_coarse(), this->last_pulse));
    return;
}

void TTL_out::set_ch(const char * pulse_ch){
    if( strcmp(pulse_ch,"ON") == 0 || strcmp(pulse_ch,"oN") == 0 || strcmp(pulse_ch, "On") == 0 || strcmp(pulse_ch, "on") == 0){
        this -> last_pulse = 1;
	Xil_Out128(this->addr,MAKE128CONST( get_timestamp_coarse(), this->last_pulse));
    }
    else if( strcmp(pulse_ch,"OFF") == 0 || strcmp(pulse_ch,"OFf") == 0 || strcmp(pulse_ch, "OfF") == 0 || strcmp(pulse_ch, "Off") == 0 || strcmp(pulse_ch, "oFF") == 0 || strcmp(pulse_ch, "oFf") == 0 || strcmp(pulse_ch, "ofF") == 0 || strcmp(pulse_ch,"off") == 0 ){
        this -> last_pulse = 0;
	Xil_Out128(this->addr,MAKE128CONST( get_timestamp_coarse(),this->last_pulse));
    }
    return;
}

uint64_t TTL_out::get_last_pulse(){
    return this->last_pulse;
}

void TTL_out::flush_fifo(){
    Xil_Out128((this->addr | 0x10),MAKE128CONST(0,1));
}
