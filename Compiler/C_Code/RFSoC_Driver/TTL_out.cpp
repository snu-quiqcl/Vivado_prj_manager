#include "RFSoC_Driver.h"

void TTL_out::set_addr(uint64_t addr, uint64_t * last_pulse_ptr, uint64_t channel){
    this->addr          = addr;
    this->channel       = channel;
    this->last_pulse    = last_pulse_ptr;
}

void TTL_out::set(uint64_t pulse){
    uint64_t last_pulse = TTL_out::get_last_pulse();
    uint64_t channel = TTL_out::get_channel();

    last_pulse = last_pulse & (MASK8BIT - ( MASK1BIT << channel ) );
    last_pulse = last_pulse | (pulse << channel);
    TTL_out::set_last_pulse(last_pulse);

    Xil_Out128(this->addr,MAKE128CONST( get_timestamp_coarse(), last_pulse));
    
    return;
}

void TTL_out::set_ch(const char * pulse_ch){
    uint64_t last_pulse = TTL_out::get_last_pulse();
    uint64_t channel = TTL_out::get_channel();

    last_pulse = last_pulse & (MASK8BIT - ( MASK1BIT << channel ) );
    
    if( strcmp(pulse_ch,"ON") == 0 || strcmp(pulse_ch,"oN") == 0 || strcmp(pulse_ch, "On") == 0 || strcmp(pulse_ch, "on") == 0){
        last_pulse = last_pulse | (1 << channel);
        TTL_out::set_last_pulse(last_pulse);

	    Xil_Out128(this->addr,MAKE128CONST( get_timestamp_coarse(), last_pulse));
    }
    else if( strcmp(pulse_ch,"OFF") == 0 || strcmp(pulse_ch,"OFf") == 0 || strcmp(pulse_ch, "OfF") == 0 || strcmp(pulse_ch, "Off") == 0 || strcmp(pulse_ch, "oFF") == 0 || strcmp(pulse_ch, "oFf") == 0 || strcmp(pulse_ch, "ofF") == 0 || strcmp(pulse_ch,"off") == 0 ){
	    Xil_Out128(this->addr,MAKE128CONST( get_timestamp_coarse(),last_pulse));
    }
    return;
}

uint64_t TTL_out::get_last_pulse(){
    return *( this->last_pulse );
}

void TTL_out::set_last_pulse(uint64_t pulse){
    *( this->last_pulse ) = pulse;
}

uint64_t TTL_out::get_channel(){
    return this->channel;
}

void TTL_out::flush_fifo(){
    Xil_Out128((this->addr | 0x10),MAKE128CONST(0,1));
}

