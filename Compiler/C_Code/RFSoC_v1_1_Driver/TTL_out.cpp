#include "RFSoC_Driver.h"

class TTL_out{
    public:
        uint64_t addr = XPAR_TTL_OUT_0_BASEADDR;
        uint64_t last_pulse = 0;
    public:
        TTL_out(uint64_t addr =  (uint64_t) XPAR_TTL_OUT_0_BASEADDR ){
            this->addr = addr;
        };
        void set(uint64_t pulse);
        void set_ch(const char * pulse_ch);
        uint64_t get_last_pulse();
};

void TTL_out::set(uint64_t pulse){
    this->last_pulse = pulse;
}

void TTL_out::set_ch(const char * pulse_ch){
    if( strcmp(pulse_ch,'ON') == 0 || strcmp(pulse_ch,'oN') == 0 || strcmp(pulse_ch, 'On') || strcmp(pulse_ch, 'on')){
        this -> last_pulse = 1;
    }
    else if( strcmp(pulse_ch,'OFF') == 0 || strcmp(pulse_ch,'OFf') == 0 || strcmp(pulse_ch, 'OfF') == 0 || strcmp(pulse_ch, 'Off') == 0 || strcmp(pulse_ch, 'oFF') == 0 || strcmp(pulse_ch, 'oFf') == 0 || strcmp(pulse_ch, 'ofF') == 0 || strcmp(pulse_ch,'off') == 0 ){
        this -> last_pulse = 0;
    }
    return;
}

uint64_t TTL_out::get_last_pulse(){
    return this->last_pulse;
}
