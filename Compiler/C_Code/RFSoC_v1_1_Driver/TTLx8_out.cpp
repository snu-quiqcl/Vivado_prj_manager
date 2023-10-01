#include "RFSoC_Driver.h"

class TTLx8_out{
    public:
        uint64_t addr = XPAR_TTLX8_OUT_0_BASEADDR;
        uint64_t last_pulse = 0;                    // 8 bit pulse
        uint64_t last_output_time = 0;              // 1ns scale time
    public:
        TTL_out(uint64_t addr =  (uint64_t) XPAR_TTLX8_OUT_0_BASEADDR ){
            this->addr = addr;
        };
        void set(uint64_t pulse);
        void set_ch(const char * pulse_ch);
        uint64_t get_last_pulse();
};

void TTLx8_out::set(uint64_t pulse){
    if( ( ( this -> last_output_time ) >> 3) < get_full_timestamp() ){
        uint64_t temp_last_pulse = this->last_pulse;
        this->last_pulse = 0;

        for( int i = 0; i < (get_full_timestamp() % 8); i ++ ){
            this-> last_pulse += (temp_last_pulse << i);
        }

        this->last_pulse += ( pulse << ( get_full_timestamp() % 8 ) ) ;
        this->last_output_time = get_full_timestamp();
    }
    else{
        this->last_pulse += ( pulse << ( get_full_timestamp() % 8 ) );
    }
}

void TTLx8_out::set_ch(const char * pulse_ch){
    if( strcmp(pulse_ch,'ON') == 0 || strcmp(pulse_ch,'oN') == 0 || strcmp(pulse_ch, 'On') || strcmp(pulse_ch, 'on')){
        this -> set(1);
    }
    else if( strcmp(pulse_ch,'OFF') == 0 || strcmp(pulse_ch,'OFf') == 0 || strcmp(pulse_ch, 'OfF') == 0 || strcmp(pulse_ch, 'Off') == 0 || strcmp(pulse_ch, 'oFF') == 0 || strcmp(pulse_ch, 'oFf') == 0 || strcmp(pulse_ch, 'ofF') == 0 || strcmp(pulse_ch,'off') == 0 ){
        this -> set(0);
    }
    return;
}

uint64_t TTL_outx8::get_last_pulse(){
    return (this->last_pulse) >> ( ( this -> last_output_time ) % 8);
}
