#include <stdio.h>
#include "xparameters.h"
#include "xil_exception.h"
#include "xscugic_hw.h"
#include "xil_printf.h"
#include "xstatus.h"
#include "xscugic.h"
#include "xil_util.h"

/* Define Interrupt ID for each function*/
#define INT_ID_RUN_BIN 0x0
#define INT_ID_STOP_BIN 0x1

/************************** Constant Definitions *****************************/

/*
 * The following constants map to the XPAR parameters created in the
 * xparameters.h file. They are defined here such that a user can easily
 * change all the needed parameters in one place.
 */
#define CPU_BASEADDR		XPAR_SCUGIC_0_CPU_BASEADDR
#define DIST_BASEADDR		XPAR_SCUGIC_0_DIST_BASEADDR
#define AXI_LEN 			0x10
#define M_AXI_HPM0_FPD_ADDR XPAR_AXI_HPM0_FPD_0_S_AXI_BASEADDR
#define M_AXI_HPM1_FPD_ADDR XPAR_AXI_HPM1_FPD_0_S_AXI_BASEADDR
#define CPU_BASEADDR		XPAR_SCUGIC_0_CPU_BASEADDR
#define DIST_BASEADDR		XPAR_SCUGIC_0_DIST_BASEADDR
#define GIC_DEVICE_INT_MASK        0x00010000

//Memory address
#define DRAM_BASE_ADDRESS 	0x800f00000
#define STACK_START_PTR_ADDR 0x800700010
#define STACK_END_PTR_ADDR 	0x800700020
#define HEAP_START_PTR_ADDR 0x800700030
#define HEAP_END_PTR_ADDR 	0x800700040
#define ENTRY_PTR_ADDR 		0x800700050
#define EXIT_PTR_ADDR 		0x800700060

volatile static u32 InterruptProcessed = FALSE;
volatile static interrupt_run_binary = 0;

/**************************** Type Definitions *******************************/

/***************** Macros (Inline Functions) Definitions *********************/

/************************** Function Prototypes ******************************/

int ScuGicLowLevelExample(u32 CpuBaseAddress, u32 DistBaseAddress);

void SetupInterruptSystem();

void LowInterruptHandler(u32 CallbackRef);


/*****************************************************************************/
/**
*
* This function connects the interrupt handler of the interrupt controller to
* the processor.  This function is separate to allow it to be customized for
* each application.  Each processor or RTOS may require unique processing to
* connect the interrupt handler.
*
* @param	None.
*
* @return	None.
*
* @note		None.
*
******************************************************************************/
void SetupInterruptSystem(void)
{
	/*
	 * Connect the interrupt controller interrupt handler to the hardware
	 * interrupt handling logic in the ARM processor.
	 */
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_IRQ_INT,
				     (Xil_ExceptionHandler) LowInterruptHandler,
				     (void *)CPU_BASEADDR);

	/*
	 * Enable interrupts in the ARM
	 */
	Xil_ExceptionEnable();
}

void stop_binary(){
	Xil_DCacheFlush();
	Xil_ICacheInvalidate();
	__asm__ __volatile__ (
		"movz x2, #0x0000\n\t"
		"movk x2, #0x0070, lsl 16\n\t"
		"movk x2, #0x0008, lsl 32\n\t"
		"movk x2, #0x0000, lsl 48\n\t"
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
		:
		:
	);
	Xil_DCacheFlush();
	Xil_ICacheInvalidate();
	xil_printf("\r\nSTOP ELF DONE\r\n");
	clear_DRAM();
	return 0;
}
int64_t run_binary(){
	xil_printf("RUN BIN\r\n");
	// Set the stack pointer to STACK_END
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
		"movz x2, #0x0000\n\t"
		"movk x2, #0x0070, lsl 16\n\t"
		"movk x2, #0x0008, lsl 32\n\t"
		"movk x2, #0x0000, lsl 48\n\t"
		"str x0, [x2]\n\t"
			/*save END*/
		"movz x2, #0x0010\n\t"
		"movk x2, #0x0070, lsl 16\n\t"
		"movk x2, #0x0008, lsl 32\n\t"
		"movk x2, #0x0000, lsl 48\n\t"
		"ldr x1, [x2]\n\t"    	// Load sp value to x1
		"mov sp, x1\n\t"		// Move sp value to stack pointer (sp)
		"movz x2, #0x0050\n\t"
		"movk x2, #0x0070, lsl 16\n\t"
		"movk x2, #0x0008, lsl 32\n\t"
		"movk x2, #0x0000, lsl 48\n\t"
		"ldr x1, [x2]\n\t"		// Load main address to x1
			/*####JUMP TO MAIN####*/
		"blr x1\n\t"         	// Branch to the address in x1 (MAIN function)
			/*return SP*/
		"movz x2, #0x0000\n\t"
		"movk x2, #0x0070, lsl 16\n\t"
		"movk x2, #0x0008, lsl 32\n\t"
		"movk x2, #0x0000, lsl 48\n\t"
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
		:
		:
	);
	Xil_DCacheFlush();
	Xil_ICacheInvalidate();
	sleep(1);
	xil_printf("\r\nELF DONE\r\n");
	clear_DRAM();

	return 0;
}

void clear_DRAM(){
	Xil_DCacheFlush();
	Xil_ICacheInvalidate();
	xil_printf("DRAM CELANED\r\n");
}

void LowInterruptHandler(u32 CallbackRef)
{
	u32 BaseAddress;
	u32 IntID;


	BaseAddress = CallbackRef;
	/*
	 * Read the int_ack register to identify the interrupt and
	 * make sure it is valid.
	 */
	IntID = XScuGic_ReadReg(BaseAddress, XSCUGIC_INT_ACK_OFFSET) &
		XSCUGIC_ACK_INTID_MASK;
	if (XSCUGIC_MAX_NUM_INTR_INPUTS < IntID) {
		return;
	}

	/*
	 * Execute the ISR. For this example set the global to 1.
	 * The software trigger is cleared by the ACK.
	 */
	InterruptProcessed = 1;

	/*
	 * Write to the EOI register, we are all done here.
	 * Let this function return, the boot code will restore the stack.
	 */
	XScuGic_WriteReg(BaseAddress, XSCUGIC_EOI_OFFSET, IntID);

	if( IntID == INT_ID_RUN_BIN ){
		interrupt_run_binary = 1;
	}

	else if( IntID == INT_ID_STOP_BIN){
		if( interrupt_run_binary == 1){
			volatile int64_t * reg_addr;

			reg_addr = (volatile int64_t *)EXIT_PTR_ADDR;
			*(reg_addr) = (volatile int64_t)(stop_binary);
			interrupt_run_binary = 0;
			Xil_DCacheFlush();
			Xil_ICacheInvalidate();
			__asm__ __volatile__ (
				"movz x2, #0x0060\n\t"
				"movk x2, #0x0070, lsl 16\n\t"
				"movk x2, #0x0008, lsl 32\n\t"
				"movk x2, #0x0000, lsl 48\n\t"
				"ldr x0, [x2]\n\t"
				"msr elr_el1, x0\n\t"
				"msr elr_el2, x0\n\t"
				"msr elr_el3, x0\n\t"
				"eret\n\t"
				:                // No output operands
				:
				:
			);
			Xil_DCacheFlush();
			Xil_ICacheInvalidate();
		}
	}
}

void make_interrupt(){
	XScuGic_WriteReg(DIST_BASEADDR, XSCUGIC_SFI_TRIG_OFFSET, GIC_DEVICE_INT_MASK);
}

int main(void)
{
	int Status;

	xil_printf("CPU 1 turned on\r\n");
	XScuGic_WriteReg(CPU_BASEADDR, XSCUGIC_CPU_PRIOR_OFFSET, 0xF0);
	XScuGic_WriteReg(CPU_BASEADDR, XSCUGIC_CONTROL_OFFSET, 0x01);
	xil_printf("GIC Controller initialized\r\n");
	SetupInterruptSystem();
	xil_printf("Interrupt Setup done\r\n");
	xil_printf("Waiting for command...\r\n");
	while(1){
		if( interrupt_run_binary == 1){
			run_binary();
			interrupt_run_binary = 0;
		}
	}
}

