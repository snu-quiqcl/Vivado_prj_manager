#ifndef RFSOC_DRIVER
#define RFSOC_DRIVER

#include <stdio.h>
#include <stdint.h>
#include "xparameters.h"
#include "xil_io.h"
#include "string.h"

/////////////////////////////////////////////////////////////
// Constant 
/////////////////////////////////////////////////////////////
#define MASK1BIT ((uint64_t) 0x1)
#define MASK2BIT ((uint64_t) 0x3)
#define MASK3BIT ((uint64_t) 0x7)
#define MASK4BIT ((uint64_t) 0xf)
#define MASK5BIT ((uint64_t) 0x1f)
#define MASK6BIT ((uint64_t) 0x3f)
#define MASK7BIT ((uint64_t) 0x7f)
#define MASK8BIT ((uint64_t) 0xff)
#define MASK9BIT ((uint64_t) 0x1ff)
#define MASK10BIT ((uint64_t) 0x3ff)
#define MASK11BIT ((uint64_t) 0x7ff)
#define MASK12BIT ((uint64_t) 0xfff)
#define MASK13BIT ((uint64_t) 0x1fff)
#define MASK14BIT ((uint64_t) 0x3fff)
#define MASK15BIT ((uint64_t) 0x7fff)
#define MASK16BIT ((uint64_t) 0xffff)
#define MASK17BIT ((uint64_t) 0x1ffff)
#define MASK18BIT ((uint64_t) 0x3ffff)
#define MASK19BIT ((uint64_t) 0x7ffff)
#define MASK20BIT ((uint64_t) 0xfffff)
#define MASK21BIT ((uint64_t) 0x1fffff)
#define MASK22BIT ((uint64_t) 0x3fffff)
#define MASK23BIT ((uint64_t) 0x7fffff)
#define MASK24BIT ((uint64_t) 0xffffff)
#define MASK25BIT ((uint64_t) 0x1ffffff)
#define MASK26BIT ((uint64_t) 0x3ffffff)
#define MASK27BIT ((uint64_t) 0x7ffffff)
#define MASK28BIT ((uint64_t) 0xfffffff)
#define MASK29BIT ((uint64_t) 0x1fffffff)
#define MASK30BIT ((uint64_t) 0x3fffffff)
#define MASK31BIT ((uint64_t) 0x7fffffff)
#define MASK32BIT ((uint64_t) 0xffffffff)
#define MASK33BIT ((uint64_t) 0x1ffffffff)
#define MASK34BIT ((uint64_t) 0x3ffffffff)
#define MASK35BIT ((uint64_t) 0x7ffffffff)
#define MASK36BIT ((uint64_t) 0xfffffffff)
#define MASK37BIT ((uint64_t) 0x1fffffffff)
#define MASK38BIT ((uint64_t) 0x3fffffffff)
#define MASK39BIT ((uint64_t) 0x7fffffffff)
#define MASK40BIT ((uint64_t) 0xffffffffff)
#define MASK41BIT ((uint64_t) 0x1ffffffffff)
#define MASK42BIT ((uint64_t) 0x3ffffffffff)
#define MASK43BIT ((uint64_t) 0x7ffffffffff)
#define MASK44BIT ((uint64_t) 0xfffffffffff)
#define MASK45BIT ((uint64_t) 0x1fffffffffff)
#define MASK46BIT ((uint64_t) 0x3fffffffffff)
#define MASK47BIT ((uint64_t) 0x7fffffffffff)
#define MASK48BIT ((uint64_t) 0xffffffffffff)
#define MASK49BIT ((uint64_t) 0x1ffffffffffff)
#define MASK50BIT ((uint64_t) 0x3ffffffffffff)
#define MASK51BIT ((uint64_t) 0x7ffffffffffff)
#define MASK52BIT ((uint64_t) 0xfffffffffffff)
#define MASK53BIT ((uint64_t) 0x1fffffffffffff)
#define MASK54BIT ((uint64_t) 0x3fffffffffffff)
#define MASK55BIT ((uint64_t) 0x7fffffffffffff)
#define MASK56BIT ((uint64_t) 0xffffffffffffff)
#define MASK57BIT ((uint64_t) 0x1ffffffffffffff)
#define MASK58BIT ((uint64_t) 0x3ffffffffffffff)
#define MASK59BIT ((uint64_t) 0x7ffffffffffffff)
#define MASK60BIT ((uint64_t) 0xfffffffffffffff)
#define MASK61BIT ((uint64_t) 0x1fffffffffffffff)
#define MASK62BIT ((uint64_t) 0x3fffffffffffffff)
#define MASK63BIT ((uint64_t) 0x7fffffffffffffff)
#define MASK64BIT ((uint64_t) 0xffffffffffffffff)

#define TWOPI ((long double) 6.28318530718 )

/////////////////////////////////////////////////////////////
// AXI_drvier.cpp
/////////////////////////////////////////////////////////////
__attribute__((always_inline)) static void reg128_write(uint64_t addr, uint64_t upper_data, uint64_t lower_data);

/////////////////////////////////////////////////////////////
// RFSoC_Driver.cpp
/////////////////////////////////////////////////////////////
static int64_t get_timestamp();
static int64_t get_timestamp_coarse();
static void delay(int64_t time);
static void delay_coarse(int64_t time);
static void set_timestamp(int64_t time);
static void set_timestamp_coarse(int64_t time);

/////////////////////////////////////////////////////////////
// DAC.cpp
/////////////////////////////////////////////////////////////
class DAC{
    public:
        uint64_t addr           =  (uint64_t) XPAR_DAC_CONTROLLER_0_BASEADDR;
        uint64_t sample_freq    = 2000000000;
        uint64_t channel        = 0;
        uint64_t freq           = 0;
        uint64_t amp            = 0;
    public:
        DAC(uint64_t sample_freq = 2000000000, uint64_t channel = 0){
            this->addr          = (uint64_t) XPAR_DAC_CONTROLLER_0_BASEADDR + (0x1000) * channel;
            this->sample_freq   = sample_freq;
            this->channel       = channel;
        };
        void set_addr(uint64_t addr);
        void set_channel(uint64_t channel);
        void initialize();
        void set_freq(uint64_t freq);
        void set_amp(long double amp);
};

/////////////////////////////////////////////////////////////
// TTL_out.cpp
/////////////////////////////////////////////////////////////

class TTL_out{
    public:
        uint64_t addr           = (uint64_t) XPAR_TTL_OUT_0_BASEADDR;
        uint64_t last_pulse     = 0;
    public:
        TTL_out(uint64_t addr =  (uint64_t) XPAR_TTL_OUT_0_BASEADDR ){
            this->addr          = addr;
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
        uint64_t addr           = (uint64_t) XPAR_TTLX8_OUT_0_BASEADDR;
        uint64_t last_pulse     = 0;                    // 8 bit pulse
        uint64_t last_output_time   = 0;              // 1ns scale time
    public:
        TTL_out(uint64_t addr =  (uint64_t) XPAR_TTLX8_OUT_0_BASEADDR ){
            this->addr          = addr;
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
        uint64_t addr           = (uint64_t) XPAR_TIMECONTROLLER_0_BASEADDR;
    public:
        TimeController(uint64_t addr = (uint64_t) XPAR_TIMECONTROLLER_0_BASEADDR){
            this-> addr         = addr;
        };
        void reset();
        void auto_start();
        void auto_stop();
};


#endif
