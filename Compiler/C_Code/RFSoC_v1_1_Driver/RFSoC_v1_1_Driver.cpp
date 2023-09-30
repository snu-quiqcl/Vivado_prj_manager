#include <stdio.h>
#include <stdint.h>
#include "xparameters.h"
#include "xil_io.h"

//MUX address
#define S00_AXIS_TDATA (int64_t)0x0

//AXI address
#define AXI_LEN 0x10
#define M_AXI_HPM0_FPD_ADDR XPAR_AXI_HPM0_FPD_0_S_AXI_BASEADDR
#define M_AXI_HPM1_FPD_ADDR XPAR_AXI_HPM1_FPD_0_S_AXI_BASEADDR

//Memory address
#define DRAM_BASE_ADDRESS 0xf00000
#define TARGET_ADDRESS 0x700100
#define UPPER_ADDRESS 0x700108
#define LOWER_ADDRESS 0x700110

__attribute__((always_inline)) static void reg128_write(uint64_t addr, uint64_t upper_data, uint64_t lower_data)
{
    volatile uint64_t * target_addr = (volatile uint64_t *)TARGET_ADDRESS;
    volatile uint64_t * lower_addr = (volatile uint64_t *)LOWER_ADDRESS;
    volatile uint64_t * upper_addr =(volatile uint64_t *) UPPER_ADDRESS;

    *target_addr = addr;
    *lower_addr = lower_data;
    *upper_addr = upper_data;

    __asm__ __volatile__(
		    "sub sp, sp, #32\n\t"
		    "str x0, [sp, #8]\n\t"
		    "str x1, [sp, #16]\n\t"
		    "str x2, [sp, #24]\n\t"
		    "ldr x0, [%0]\n\t"
		    "ldr x1, [%1]\n\t"
		    "ldr x2, [%2]\n\t"
		    "stp x1, x2, [x0]\n\t"
		    "ldr x0, [sp, #8]\n\t"
		    "ldr x1, [sp, #16]\n\t"
		    "ldr x2, [sp, #24]\n\t"
		    "add sp, sp, #32\n\t"
		    ://Target
		    : "r" (TARGET_ADDRESS), "r" (LOWER_ADDRESS), "r" (UPPER_ADDRESS)//Variable
		    ://Clover
		    );
}

class DAC{
    public:
        uint64_t addr;
        uint64_t sample_freq;
    public:
        DAC(uint64_t addr, uint64_t sample_freq = 6400000000){
            this->addr = addr;
            this->sample_freq = sample_freq;
        };
        void initialize(uint64_t timestamp);
        void set_freq(uint64_t timestamp,uint64_t freq);
        void set_amp(uint64_t timestamp, long double amp);
};

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

void DAC::initialize(uint64_t timestamp = 0){
    reg128_write(this-> addr,(uint64_t)10 + timestamp,( DAC00_FAST_SHUTDOWN<<32)+((int64_t)255<<40));
    
    reg128_write(this-> addr,(uint64_t)20 + timestamp,( DAC00_PL_EVENT << 32 ) + ( (uint64_t) 255 << 40 ));
    
    reg128_write(this-> addr,(uint64_t)30 + timestamp,( DAC00_NCO_FREQ << 32 ) + ( (uint64_t) 255 << 40 ));
    
    reg128_write(this-> addr,(uint64_t)40 + timestamp,( DAC00_NCO_PHASE << 32 ) + ( (uint64_t) 255 << 40 ));
    
    reg128_write(this-> addr,(uint64_t)50 + timestamp,( DAC00_NCO_PHASE_RST << 32 ) + ( (uint64_t) 255 << 40 ));
    
    reg128_write(this-> addr,(uint64_t)60 + timestamp,( DAC0_SYSREF_INT_GATING << 32 ) + ( (uint64_t) 255 << 40 ));
    
    reg128_write(this-> addr,(uint64_t)70 + timestamp,( DAC0_SYSREF_INT_REENABLE << 32 ) + ( (uint64_t) 255 << 40 ));
    
    reg128_write(this-> addr,(uint64_t)90 + timestamp,( S00_AXIS_TDATA << 32 ) + ( (uint64_t) 255 << 40 ) + (uint64_t)0x00007fff);
    
    reg128_write(this-> addr,(uint64_t)100 + timestamp,( S00_AXIS_TVALID << 32 ) + ( (uint64_t) 255 << 40 ) + (uint64_t)0x00000001);
    
    reg128_write(this-> addr,(uint64_t)110 + timestamp,( DAC00_NCO_FREQ << 32 ) + ( (uint64_t) 1 << 40 ) +(uint64_t) 0x00000000);
    
    reg128_write(this-> addr,(uint64_t)120 + timestamp,( DAC00_NCO_FREQ << 32 ) + ( (uint64_t) 2 << 40 ) + (uint64_t)0x00000000);
    
    reg128_write(this-> addr,(uint64_t)130 + timestamp,( DAC00_NCO_UPDATE_EN << 32 ) + ( (uint64_t) 255 << 40 ) + (uint64_t)7);
    
    reg128_write(this-> addr,(uint64_t)140 + timestamp,( DAC0_NCO_UPDATE_REQ << 32 ) + ( (uint64_t) 255 << 40 ) + (uint64_t)10); // last value is update signal width
    
    reg128_write(this-> addr,(uint64_t)160 + timestamp,( S00_AXIS_TDATA << 32 ) + ( (uint64_t) 255 << 40 ) + (uint64_t)0x00000000);
    
    reg128_write(this-> addr,(uint64_t)170 + timestamp,( UPDATE << 32 ) + ( (uint64_t) 255 << 40 ) + ( (uint64_t) 1 << 36 ) + (uint64_t)1);
}

void DAC::set_freq(uint64_t timestamp,uint64_t freq){
    uint64_t input_val;
    input_val = (uint64_t)(((long double)freq/(long double)(this->sample_freq))*(((uint64_t)1<<48)-(uint64_t)1));
    reg128_write(this-> addr,timestamp + (uint64_t)10,( DAC00_NCO_FREQ << 32 ) + ( (uint64_t) 1 << 40 ) + (uint64_t)(input_val & 0xffffffff));
    
    reg128_write(this-> addr,timestamp + (uint64_t)20,( DAC00_NCO_FREQ << 32 ) + ( (uint64_t) 2 << 40 ) + (uint64_t)((input_val >> 32) & 0xffff));

    reg128_write(this-> addr,timestamp + (uint64_t)30,( DAC00_NCO_UPDATE_EN << 32 ) + ( (uint64_t) 255 << 40 ) + (uint64_t)7);

    reg128_write(this-> addr,timestamp + (uint64_t)40,( DAC0_NCO_UPDATE_REQ << 32 ) + ( (uint64_t) 244 << 40 ) + (uint64_t)0x0010);
    
    reg128_write(this-> addr,timestamp + (uint64_t)50,( UPDATE << 32 ) + ( (uint64_t) 255 << 40 ) + ( (uint64_t) 1 << 36 ) + (uint64_t)1);
}

void DAC::set_amp(uint64_t timestamp, long double amp){
    uint64_t input_val;
    input_val = (uint64_t)(amp * ((1 << 15) - 1));
    reg128_write(this-> addr,timestamp,( S00_AXIS_TDATA << 32 ) + ( (uint64_t) 255 << 40 ) + (uint64_t)(input_val & (0x00007fff)));
    
    reg128_write(this-> addr,timestamp + (uint64_t)10,( UPDATE << 32 ) + ( (uint64_t) 255 << 40 ) + ( (uint64_t) 1 << 36 ) + (uint64_t)1);
}

void TimeController::reset(){
    reg128_write(this-> addr,(uint64_t)0,(uint64_t)2);
}

void TimeController::auto_start(){
    reg128_write(this-> addr,(uint64_t)0,(uint64_t)9);
}

void TimeController::auto_stop(){
    reg128_write(this-> addr,(uint64_t)0,(uint64_t)0);
}

int main(){
    DAC dac00 = DAC((uint64_t)XPAR_DAC_CONTROLLER_0_BASEADDR,6400000000);
    TimeController tc = TimeController((uint64_t)XPAR_TIMECONTROLLER_0_BASEADDR);
    tc.auto_stop();
    tc.reset();
    dac00.initialize((uint64_t)1000);
    dac00.set_freq((uint64_t)5000,(uint64_t)0x000);
    dac00.set_amp((uint64_t)6000,(long double)0.90);
    tc.reset();
    tc.auto_start();
    
    int64_t i = 0;
    long double amp_val[] = {
				0.000, 0.010, 0.020, 0.028, 0.037, 0.046, 0.055, 0.065,
				0.073, 0.081, 0.088, 0.095, 0.102, 0.109, 0.116, 0.122,
				0.128, 0.134, 0.140, 0.146, 0.152, 0.157, 0.162, 0.167,
				0.172, 0.176, 0.180, 0.184, 0.188, 0.192, 0.196, 0.200,
				0.204, 0.208, 0.212, 0.216, 0.220, 0.224, 0.227, 0.230,
				0.233, 0.236, 0.239, 0.242, 0.245, 0.248, 0.251, 0.254,
				0.257, 0.259, 0.261, 0.263, 0.265, 0.267, 0.269, 0.271,
				0.273, 0.275, 0.277, 0.279, 0.280, 0.281, 0.282, 0.283,
				0.284, 0.285, 0.286, 0.287, 0.288, 0.289, 0.290, 0.291,
				0.293, 0.295, 0.297, 0.299, 0.303, 0.307, 0.311, 0.316,
				0.323, 0.330, 0.338, 0.343, 0.350, 0.357, 0.363, 0.369,
				1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000,
				0.990, 0.980, 0.970, 0.950, 0.920, 0.880, 0.700, 0.700,
				0.700, 0.700, 0.700, 0.700, 0.700, 0.700, 0.701, 0.702,
				0.703, 0.704, 0.705, 0.706, 0.707, 0.708, 0.709, 0.710,
				0.700, 0.700, 0.700, 0.700, 0.700, 0.700, 0.700, 0.700,
				0.690, 0.681, 0.683, 0.675, 0.670, 0.670, 0.670, 0.670,
				0.600, 0.600, 0.600, 0.600, 0.600, 0.600, 0.600, 0.600,
                                0.600, 0.600, 0.600, 0.600, 0.600, 0.600, 0.600, 0.600,
                                0.500, 0.500, 0.500, 0.500, 0.500, 0.500, 0.500, 0.500,
                                0.500, 0.500, 0.500, 0.500, 0.500, 0.500, 0.500, 0.500,
                                0.400, 0.400, 0.400, 0.400, 0.400, 0.400, 0.400, 0.400,
                                0.350, 0.351, 0.352, 0.353, 0.354, 0.355, 0.356, 0.357,
                                0.358, 0.359, 0.360, 0.361, 0.362, 0.363, 0.364, 0.600,
                                0.600, 0.600, 0.600, 0.600, 0.600, 0.600, 0.600, 0.000
                            };
    while(1){
	i++;
        dac00.set_amp((uint64_t)7000 + i*30,(long double)amp_val[i % 200]);
    }   
}
