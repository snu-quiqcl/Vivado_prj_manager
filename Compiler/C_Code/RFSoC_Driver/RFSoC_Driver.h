#ifndef RFSOC_DRIVER
#define RFSOC_DRIVER

#include <stdio.h>
#include <stdint.h>
#include "xparameters.h"
#include "xil_io.h"
#include "string.h"

/////////////////////////////////////////////////////////////
// AXI_drvier.cpp
/////////////////////////////////////////////////////////////
__attribute__((always_inline)) static void reg128_write(uint64_t addr, uint64_t upper_data, uint64_t lower_data);

/////////////////////////////////////////////////////////////
// RFSoC_Driver.cpp
/////////////////////////////////////////////////////////////
static int64_t get_full_timestamp();
static int64_t get_timestamp();
static void delay(int64_t time);
static void delay_coarse(int64_t time);
static void set_timestamp(int64_t time);
static void set_timestamp_coarse(int64_t time);

/////////////////////////////////////////////////////////////
// DAC.cpp
/////////////////////////////////////////////////////////////
class DAC{
    public:
        uint64_t addr =  (uint64_t) XPAR_DAC_CONTROLLER_0_BASEADDR;
        uint64_t sample_freq = 2000000000;
        uint64_t channel = 0;
    public:
        DAC(uint64_t sample_freq = 2000000000, uint64_t channel = 0){
            this->addr = (uint64_t) XPAR_DAC_CONTROLLER_0_BASEADDR + (0x1000) * channel;
            this->sample_freq = sample_freq;
            this->channel = channel;
        };
        void set_addr(uint64_t addr);
        void initialize(uint64_t timestamp);
        void set_freq(uint64_t timestamp,uint64_t freq);
        void set_amp(uint64_t timestamp, long double amp);
};

/////////////////////////////////////////////////////////////
// TTL_out.cpp
/////////////////////////////////////////////////////////////

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

/////////////////////////////////////////////////////////////
// TTLx8_out.cpp
/////////////////////////////////////////////////////////////

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

/////////////////////////////////////////////////////////////
// TimeController.cpp
/////////////////////////////////////////////////////////////

class TimeController{
    public:
        uint64_t addr;
    public:
        TimeController(uint64_t addr){
            this-> addr = addr;
        };
        void reset();
        void auto_start();
        void auto_stop();
};


#endif
