#include <stdio.h>
#include "xparameters.h"
#include "xil_exception.h"
#include "xscugic_hw.h"
#include "xil_printf.h"
#include "xstatus.h"
#include "xscugic.h"
#include "xil_util.h"
#include "rfdc_controller.h"
/*****************************************************************************/
/**
*
* This function is an example of how to use the interrupt controller driver
* (XScuGic) and the hardware device.  This function is designed to
* work without any hardware devices to cause interrupts.  It may not return
* if the interrupt controller is not properly connected to the processor in
* either software or hardware.
*
* This function relies on the fact that the interrupt controller hardware
* has come out of the reset state such that it will allow interrupts to be
* simulated by the software.
*
* @param	CpuBaseAddress is Base Address of the Interrupt Controller
*		Device
*
* @return	XST_SUCCESS to indicate success, otherwise XST_FAILURE
*
* @note		None.
*
******************************************************************************/
void ELF_run_interrupt(){
	XScuGic_WriteReg(DIST_BASEADDR, XSCUGIC_SFI_TRIG_OFFSET, GIC_DEVICE_INT_MASK|0x0);
}

void ELF_stop_interrupt(){
	XScuGic_WriteReg(DIST_BASEADDR, XSCUGIC_SFI_TRIG_OFFSET, GIC_DEVICE_INT_MASK|0x1);
}
