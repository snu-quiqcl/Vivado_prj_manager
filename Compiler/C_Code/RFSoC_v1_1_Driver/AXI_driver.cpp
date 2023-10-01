#include "RFSoC_Driver.h"

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
