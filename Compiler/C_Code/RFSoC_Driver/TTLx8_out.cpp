#include "RFSoC_Driver.h"

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
