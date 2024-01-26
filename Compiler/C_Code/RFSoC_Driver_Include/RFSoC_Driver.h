#ifndef RFSOC_DRIVER
#define RFSOC_DRIVER

#include <stdio.h>
#include <stdint.h>
#include "xparameters.h"
#include "xil_io.h"
#include "string.h"
/////////////////////////////////////////////////////////////
// 128 bit write macro
/////////////////////////////////////////////////////////////
#define MAKE128CONST(hi,lo) ((((__uint128_t)hi << 64) | (lo)))
#define UPPER(x) (uint64_t)( ( (x) >> 64 ) & MASK64BIT)
#define LOWER(x) (uint64_t)( (x) & MASK64BIT )

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

#define EXP_DATA_ADDR 0x700000


/////////////////////////////////////////////////////////////
// 128 bit write
//
// https://isocpp.org/wiki/faq/inline-functions 
// -> why inline function is in header file?
/////////////////////////////////////////////////////////////
static INLINE void Xil_Out128(UINTPTR Addr, __uint128_t Value)
{
	volatile __uint128_t *LocalAddr = (volatile __uint128_t *)Addr;
	*LocalAddr = Value;
}

static INLINE __uint128_t Xil_In128(UINTPTR Addr)
{
	volatile __uint128_t *LocalAddr = (volatile __uint128_t *)Addr;
	return *LocalAddr;
}

/////////////////////////////////////////////////////////////
// RFSoC_Driver.cpp
/////////////////////////////////////////////////////////////
int64_t get_timestamp();
int64_t get_timestamp_coarse();
void delay(int64_t time);
void delay_coarse(int64_t time);
void set_timestamp(int64_t time);
void set_timestamp_coarse(int64_t time);

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
	    uint64_t phase 	        = 0;
    public:
        DAC(uint64_t sample_freq = 2000000000, uint64_t addr = ( (uint64_t) XPAR_DAC_CONTROLLER_0_BASEADDR )){
            this->addr          = (uint64_t) XPAR_DAC_CONTROLLER_0_BASEADDR;
            this->sample_freq   = sample_freq;
        };
        void set_addr(uint64_t addr);
        void set_freq(uint64_t freq);
        void set_amp(long double amp);
	void set_config(long double amp, uint64_t freq, long double phase, uint64_t shift);
    void flush_fifo();
    void print_addr();
};

/////////////////////////////////////////////////////////////
// TTL_out.cpp
/////////////////////////////////////////////////////////////

class TTL_out{
    public:
        uint64_t addr           = (uint64_t) XPAR_TTL_OUT_0_BASEADDR;
        uint64_t channel         = (uint64_t) 0;
        uint64_t * last_pulse   = NULL;
    public:
        TTL_out(uint64_t addr =  ( (uint64_t) XPAR_TTL_OUT_0_BASEADDR ), uint64_t * last_pulse_ptr = NULL, uint64_t channel = 0 ){
            this->addr          = addr;
            this->channel       = channel;
            this->last_pulse    = last_pulse_ptr;
        };
        void set_addr(uint64_t addr, uint64_t * last_pulse_ptr, uint64_t channel);
        void set(uint64_t pulse);
        void set_ch(const char * pulse_ch);
        uint64_t get_last_pulse();
        void set_last_pulse(uint64_t pulse);
        uint64_t get_channel();
        void flush_fifo();
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
        TTLx8_out(uint64_t addr = ( (uint64_t) XPAR_TTLX8_OUT_0_BASEADDR ) ){
            this->addr          = addr;
        };
        void set_addr(uint64_t addr, uint64_t * last_pulse_ptr, uint64_t channel);
        void set(uint64_t pulse);
        void set_ch(const char * pulse_ch);
        uint64_t get_last_pulse();
        void flush_fifo();
};

/////////////////////////////////////////////////////////////
// EdgeCounter.cpp
/////////////////////////////////////////////////////////////

class EdgeCounter{
    public:
        uint64_t addr           = (uint64_t) XPAR_EDGECOUNTER_0_BASEADDR;
    public:
        TimeController(uint64_t addr = (uint64_t) XPAR_EDGECOUNTER_0_BASEADDR){
            this-> addr         = addr;
        };
        void set_addr(uint64_t addr);
        void flush_fifo();
        void start_count();
        void end_count();
        void save_count();
        void reset_count();
        __uint128_t read_count();
        __uint128_t read_len();
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
        void set_addr(uint64_t addr);
        void reset();
        void auto_start();
        void auto_stop();
};


#endif
