#include "RFSoC_Driver.h"

class DAC{
    public:
        uint64_t addr =  (uint64_t) XPAR_TTL_OUT_0_BASEADDR;
        uint64_t sample_freq = 2000000000;
    public:
        DAC(uint64_t sample_freq = 2000000000, uint64_t addr =  (uint64_t) XPAR_TTL_OUT_0_BASEADDR ){
            this->addr = addr;
            this->sample_freq = sample_freq;
        };
        void initialize(uint64_t timestamp);
        void set_freq(uint64_t timestamp,uint64_t freq);
        void set_amp(uint64_t timestamp, long double amp);
};

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
