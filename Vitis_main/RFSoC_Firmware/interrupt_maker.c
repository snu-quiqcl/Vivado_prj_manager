#include <stdio.h>
#include "xparameters.h"
#include "xil_exception.h"
#include "xscugic_hw.h"
#include "xil_printf.h"
#include "xstatus.h"
#include "xscugic.h"
#include "xil_util.h"
#include "rfdc_controller.h"

/************************** Constant Definitions *****************************/

/*
 * The following constants map to the XPAR parameters created in the
 * xparameters.h file. They are defined here such that a user can easily
 * change all the needed parameters in one place.
 */
#define CPU_BASEADDR		XPAR_SCUGIC_0_CPU_BASEADDR
#define DIST_BASEADDR		XPAR_SCUGIC_0_DIST_BASEADDR
#define GIC_DEVICE_INT_MASK        0x00020003 /* Bit [25:24] Target list filter
                                                 Bit [23:16] 16 = Target CPU iface 0
                                                 Bit [3:0] identifies the SFI */
#define XSCUGIC_SW_TIMEOUT_VAL	10000000U /* Wait for 10 sec */

/*****************************************************************************/
/**
*
* This is the main function for the Interrupt Controller Low Level example.
*
* @param	None.
*
* @return	XST_SUCCESS to indicate success, otherwise XST_FAILURE.
*
* @note		None.
*
******************************************************************************/

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
int ScuGicLowLevelExample(u32 CpuBaseAddress, u32 DistBaseAddress)
{
	int Status;
	/*
	 * Cause (simulate) an interrupt so the handler will be called.
	 * This is done by changing the interrupt source to be software driven,
	 * then set a bit which simulates an interrupt.
	 */
	XScuGic_WriteReg(DistBaseAddress, XSCUGIC_SFI_TRIG_OFFSET, GIC_DEVICE_INT_MASK);

	return XST_SUCCESS;
}
