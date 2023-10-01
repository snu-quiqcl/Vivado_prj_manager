#include "RFSoC_Driver.h"

void DAC::set_addr(uint64_t addr){
    this->addr = addr;
}

void DAC::initialize(uint64_t timestamp = 0){
}

void DAC::set_freq(uint64_t timestamp,uint64_t freq){
    uint64_t input_val;
    input_val = (uint64_t)(((long double)freq/(long double)(this->sample_freq))*(((uint64_t)1<<48)-(uint64_t)1));
    reg128_write(this-> addr,timestamp + (uint64_t)10,( DAC00_NCO_FREQ << 32 ) + ( (uint64_t) 1 << 40 ) + (uint64_t)(input_val & 0xffffffff));
}

void DAC::set_amp(uint64_t timestamp, long double amp){
    uint64_t input_val;
    input_val = (uint64_t)(amp * ((1 << 15) - 1));
    reg128_write(this-> addr,timestamp,( S00_AXIS_TDATA << 32 ) + ( (uint64_t) 255 << 40 ) + (uint64_t)(input_val & (0x00007fff)));
    
    reg128_write(this-> addr,timestamp + (uint64_t)10,( UPDATE << 32 ) + ( (uint64_t) 255 << 40 ) + ( (uint64_t) 1 << 36 ) + (uint64_t)1);
}
