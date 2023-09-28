#include <string.h>
#include "lwip/err.h"
#include "lwip/tcp.h"
#include "rfdc_controller.h"
#include "xil_exception.h"

#define DATA_BASE_ADDR 0x700000
#define STACK_START_PTR_ADDR 0x700010
#define STACK_END_PTR_ADDR 0x700020
#define HEAP_START_PTR_ADDR 0x700030
#define HEAP_END_PTR_ADDR 0x700040
#define ENTRY_PTR_ADDR 0x700050

#define STACK_START_PTR_BIAS 0x10
#define STACK_END_PTR_BIAS 0x20
#define HEAP_START_PTR_BIAS 0x30
#define HEAP_END_PTR_BIAS 0x40
#define ENTRY_PTR_BIAS 0x50

static int64_t bin_entry_point;
static int64_t bin_stack_start;
static int64_t bin_stack_end;
static int64_t bin_heap_start;
static int64_t bin_heap_end;

int64_t run_binary(){
	xil_printf("RUN BIN\r\n");
	// Set the stack pointer to STACK_END
	uint64_t sp_val = DRAM_BASE_ADDRESS + bin_stack_start;
	uint64_t main_addr = bin_entry_point;

	volatile unsigned char * base_addr = DRAM_BASE_ADDRESS;
	volatile int64_t * reg_addr;

	reg_addr = (volatile int64_t *)STACK_START_PTR_ADDR;
	*(reg_addr) = (volatile int64_t)(bin_stack_start);

	reg_addr = (volatile int64_t *)STACK_END_PTR_ADDR;
	*(reg_addr) = (volatile int64_t)(bin_stack_end);

	reg_addr = (volatile int64_t *)HEAP_START_PTR_ADDR;
	*(reg_addr) = (volatile int64_t)(bin_heap_start);

	reg_addr = (volatile int64_t *)HEAP_END_PTR_ADDR;
	*(reg_addr) = (volatile int64_t)(bin_heap_start);

	reg_addr = (volatile int64_t *)ENTRY_PTR_ADDR;
	*(reg_addr) = (volatile int64_t)(bin_entry_point);

	Xil_DCacheFlush();
	Xil_ICacheInvalidate();

	__asm__ __volatile__ (
		"sub sp, sp, #256\n\t"
		"str x0, [sp, #8]\n\t"
		"str x1, [sp, #16]\n\t"
		"str x2, [sp, #24]\n\t"
		"str x3, [sp, #32]\n\t"
		"str x4, [sp, #40]\n\t"
		"str x5, [sp, #48]\n\t"
		"str x6, [sp, #56]\n\t"
		"str x7, [sp, #64]\n\t"
		"str x8, [sp, #72]\n\t"
		"str x9, [sp, #80]\n\t"
		"str x10, [sp, #88]\n\t"
		"str x11, [sp, #96]\n\t"
		"str x12, [sp, #104]\n\t"
		"str x13, [sp, #112]\n\t"
		"str x14, [sp, #120]\n\t"
		"str x15, [sp, #128]\n\t"
		"str x16, [sp, #136]\n\t"
		"str x17, [sp, #144]\n\t"
		"str x18, [sp, #152]\n\t"
		"str x19, [sp, #160]\n\t"
		"str x20, [sp, #168]\n\t"
		"str x21, [sp, #176]\n\t"
		"str x22, [sp, #184]\n\t"
		"str x23, [sp, #192]\n\t"
		"str x24, [sp, #200]\n\t"
		"str x25, [sp, #208]\n\t"
		"str x26, [sp, #216]\n\t"
		"str x27, [sp, #224]\n\t"
		"str x28, [sp, #232]\n\t"
		"str x29, [sp, #240]\n\t"
		"str x30, [sp, #248]\n\t"
			/*save SP*/
		"mov x0, sp\n\t"
		"mov x2, #0x700000\n\t"
		"str x0, [x2]\n\t"
			/*save END*/
		"ldr x1, [%0]\n\t"    	// Load sp value to x1
		"mov sp, x1\n\t"		// Move sp value to stack pointer (sp)
		"ldr x1, [%1]\n\t"		// Load main address to x1
			/*####JUMP TO MAIN####*/
		"blr x1\n\t"         	// Branch to the address in x1 (MAIN function)
			/*return SP*/
		"mov x2, #0x700000\n\t"
		"ldr x0, [x2]\n\t"
		"mov sp, x0\n\t"
			/*return END*/
		"ldr x0, [sp, #8]\n\t"
		"ldr x1, [sp, #16]\n\t"
		"ldr x2, [sp, #24]\n\t"
		"ldr x3, [sp, #32]\n\t"
		"ldr x4, [sp, #40]\n\t"
		"ldr x5, [sp, #48]\n\t"
		"ldr x6, [sp, #56]\n\t"
		"ldr x7, [sp, #64]\n\t"
		"ldr x8, [sp, #72]\n\t"
		"ldr x9, [sp, #80]\n\t"
		"ldr x10, [sp, #88]\n\t"
		"ldr x11, [sp, #96]\n\t"
		"ldr x12, [sp, #104]\n\t"
		"ldr x13, [sp, #112]\n\t"
		"ldr x14, [sp, #120]\n\t"
		"ldr x15, [sp, #128]\n\t"
		"ldr x16, [sp, #136]\n\t"
		"ldr x17, [sp, #144]\n\t"
		"ldr x18, [sp, #152]\n\t"
		"ldr x19, [sp, #160]\n\t"
		"ldr x20, [sp, #168]\n\t"
		"ldr x21, [sp, #176]\n\t"
		"ldr x22, [sp, #184]\n\t"
		"ldr x23, [sp, #192]\n\t"
		"ldr x24, [sp, #200]\n\t"
		"ldr x25, [sp, #208]\n\t"
		"ldr x26, [sp, #216]\n\t"
		"ldr x27, [sp, #224]\n\t"
		"ldr x28, [sp, #232]\n\t"
		"ldr x29, [sp, #240]\n\t"
		"ldr x30, [sp, #248]\n\t"
		"add sp, sp, #256\n\t"
		:                // No output operands
		: "r" (STACK_START_PTR_ADDR), "r" (ENTRY_PTR_ADDR)
		:
	);
	xil_printf("\r\nELF DONE\r\n");
	clear_DRAM();
}

int64_t save_binary(struct tcp_pcb *tpcb, int64_t entry_point, int64_t stack_start, int64_t stack_end, int64_t heap_start, int64_t heap_end, int64_t packet_number){
	bin_entry_point = entry_point;
	bin_stack_start = stack_start;
	bin_stack_end = stack_end;
	bin_heap_start = heap_start;
	bin_heap_end = heap_end;
}

