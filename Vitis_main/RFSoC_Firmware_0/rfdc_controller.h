#ifndef _RFDC_CONT_
#define _RFDC_CONT_

#ifndef XPS_BOARD_ZCU111
#define XPS_BOARD_ZCU111
#endif

#include <string.h>
#include <malloc.h>
#include "xil_printf.h"
#include "xparameters.h"
#include "xil_io.h"
#include "xil_cache.h"
#include "lwip/err.h"
#include "lwip/tcp.h"
#include "xil_exception.h"
#include "netif/xadapter.h"
#include "platform.h"
#include "platform_config.h"

#ifndef __BAREMETAL__
#define __BAREMETAL__
#endif

#define RFDC_DEVICE_ID 	XPAR_XRFDC_0_DEVICE_ID
#define I2CBUS	1
#define XRFDC_BASE_ADDR		XPAR_XRFDC_0_BASEADDR
#define RFDC_DEV_NAME    XPAR_XRFDC_0_DEV_NAME

//MUX address
#define S00_AXIS_TDATA (int64_t)0x0
#define S00_AXIS_TVALID (int64_t)0x1
#define DAC00_FAST_SHUTDOWN (int64_t)0x2
#define DAC00_PL_EVENT (int64_t)0x3
#define DAC00_NCO_FREQ (int64_t)0x4
#define DAC00_NCO_PHASE (int64_t)0x5
#define DAC00_NCO_PHASE_RST (int64_t)0x6
#define DAC00_NCO_UPDATE_EN (int64_t)0x7
#define DAC0_NCO_UPDATE_REQ (int64_t)0x8
#define DAC0_SYSREF_INT_GATING (int64_t)0x9
#define DAC0_SYSREF_INT_REENABLE (int64_t)0xA
#define UPDATE (int64_t)0xF

//AXI address
#define AXI_LEN 0x10;
#define M_AXI_HPM0_FPD_ADDR XPAR_AXI_HPM0_FPD_0_S_AXI_BASEADDR
#define M_AXI_HPM1_FPD_ADDR XPAR_AXI_HPM1_FPD_0_S_AXI_BASEADDR
#define CPU_BASEADDR		XPAR_SCUGIC_0_CPU_BASEADDR
#define DIST_BASEADDR		XPAR_SCUGIC_0_DIST_BASEADDR
#define GIC_DEVICE_INT_MASK        0x00020000

//Memory address
#define DRAM_BASE_ADDRESS 	0x800f00000
#define STACK_START_PTR_ADDR 0x800700010
#define STACK_END_PTR_ADDR 	0x800700020
#define HEAP_START_PTR_ADDR 0x800700030
#define HEAP_END_PTR_ADDR 	0x800700040
#define ENTRY_PTR_ADDR 		0x800700050

#define MAKE128CONST(hi,lo) ((((__uint128_t)hi << 64) | (lo)))

#ifndef DEBUG_RFDC
#define DEBUG_RFDC
#endif

#define MODULE_NUM 4
#define FNCT_NUM 6

struct module_tuple{
	int64_t  num;
	char module_name[128];
	UINTPTR addr;
};
/*
 * list of functions
 */
struct fnct_tuple{
	int64_t  num;
	char fnct_name[128];
};

/*
 * Instruction Format
 */
extern const struct module_tuple MODULE[MODULE_NUM];
extern const struct fnct_tuple FNCT[FNCT_NUM];

void set_clock(int64_t freq);

void LMX2594ClockConfig(int XIicBus, int XFrequency);
void LMK04208ClockConfig(int XIicBus, unsigned int LMK04208_CKin[1][26]);
int64_t inst_process(struct tcp_pcb *tpcb, char * TCP_data);
int64_t read_sampling_freq(struct tcp_pcb *tpcb);
/*
 * String Process
 */
char * int642str(int64_t val, char * str_dest);
char * substring(char * str_dest,char * str,int64_t start,int64_t end);
int64_t string_count(char* str, int64_t pos, char spc);
int64_t string2int64(char* str);
int64_t wolc_strcmp(char * str1, char * str2);
/*
 * Simple Lexer
 */
int64_t simple_lexer(struct tcp_pcb *tpcb, char * inst);
void set_current_binary_mode(int64_t mode);
int64_t get_module(char * inst);
int64_t get_fnct(char * inst);
int64_t get_param(char * inst, int64_t start_index, int64_t end_index);
int64_t is_end(char * inst, int64_t start_index, int64_t end_index);
void clear_DRAM();

/*
 * Run Binary
 */
int64_t run_binary();
int64_t save_binary(struct tcp_pcb *tpcb, int64_t entry_point, int64_t stack_start, int64_t stack_end, int64_t heap_start, int64_t heap_end, int64_t packet_number);


/*
 * Echo
 */
int start_application();
err_t accept_callback(void *arg, struct tcp_pcb *newpcb, err_t err);
err_t recv_callback(void *arg, struct tcp_pcb *tpcb, struct pbuf *p, err_t err);
void print_app_header();
int transfer_data();

/*
 * RFDC Controller
 */
void set_clock(int64_t freq);
void write_fifo(int64_t module_num, int64_t timestamp, int64_t instruction);
int64_t read_sampling_freq(struct tcp_pcb *tpcb);
int64_t inst_process(struct tcp_pcb *tpcb, char * TCP_data);
int64_t run_cpu_process(struct tcp_pcb *tpcb, int64_t fnct_num, int64_t param_num);
int64_t run_rtio_process(struct tcp_pcb *tpcb, int64_t module_num, int64_t fnct_num, int64_t timestamp_num, int64_t param_num);
int64_t run_bin_process(struct tcp_pcb *tpcb, int64_t fnct_num, int64_t entry_point, int64_t stack_start, int64_t stack_end, int64_t heap_start, int64_t heap_end, int64_t packet_number);

/*
 * Main
 */

/* defined by each RAW mode application */
void print_app_header();
int start_application();
int transfer_data();
void tcp_fasttmr(void);
void tcp_slowtmr(void);

/* missing declaration in lwIP */
void lwip_init();

/*Interrupt Maker*/
void ELF_run_interrupt();
void ELF_stop_interrupt();

#endif
