#include "rfdc_controller.h"

/*
 * Sampling frequency of DAC
 */
static int64_t sampling_freq = 0;

const struct module_tuple MODULE[MODULE_NUM] = {
	{0,"CPU",0},
	{1,"BIN",0},
	{2,"DAC00",XPAR_DAC_CONTROLLER_0_BASEADDR},
	{3,"TIME_CONT",XPAR_TIMECONTROLLER_0_BASEADDR}
};

const struct fnct_tuple FNCT[FNCT_NUM] = {
	{0,"write_fifo"},					//RTIO
	{1,"set_clock"},					//CPU
	{2,"read_sampling_freq"},			//CPU
	{3,"save_binary"},					//BIN
	{4,"run_binary"}					//BIN
};

unsigned int LMK04208_CKin[1][26] = {
		{0x00160040,0x80140320,0x80140321,0x80140322,
		0xC0140023,0x40140024,0x80141E05,0x03300006,0x01300007,0x06010008,
		0x55555549,0x9102410A,0x0401100B,0x1B0C006C,0x2302886D,0x0200000E,
		0x8000800F,0xC1550410,0x00000058,0x02C9C419,0x8FA8001A,0x10001E1B,
		0x0021201C,0x0180033D,0x0200033E,0x003F001F }};

/*
 * 128bit AXI output function
 */
static INLINE void Xil_Out128(UINTPTR Addr, __uint128_t Value)
{
	volatile __uint128_t *LocalAddr = (volatile __uint128_t *)Addr;
	*LocalAddr = Value;
}

void set_clock(int64_t freq){
	print("\n Configuring the Clock \r\n");
	LMK04208ClockConfig(I2CBUS, LMK04208_CKin);
	LMX2594ClockConfig(I2CBUS, freq);
	//temporarily
	sampling_freq = freq * 1000;
	print("Clock Config Done\n\r");
#ifdef XPAR_DAC_CONTROLLER_0_BASEADDR
	xil_printf("DAC CONTROLLER BASE ADDRESS : %I64d\r\n",XPAR_DAC_CONTROLLER_0_BASEADDR);
#else
	xil_printf("NO DAC CONTROLLER BASE ADDRESS ERROR\r\n");
#endif
	return;
}

void write_fifo(int64_t module_num, int64_t timestamp, int64_t instruction){
	Xil_Out128(MODULE[module_num].addr,MAKE128CONST(timestamp,instruction));
}

int64_t read_sampling_freq(struct tcp_pcb *tpcb){
	char str[1024];
	int642str(sampling_freq,str);
#ifdef DEBUG_RFDC
	xil_printf("str_len : %d\r\n",strlen(str));
#endif
	if (tcp_sndbuf(tpcb) > strlen(str)) {
		tcp_write(tpcb, str, strlen(str), 1);
	}
	else{
		xil_printf("no space in tcp_sndbuf\n\r");
	}
	xil_printf("TCP write done \r\n");
}

/*
 * TCP data format
 * {Module name} -> type M
 * {Function_name} -> type F
 * {Timestamp} -> type T
 * {Param} -> Type P
 * initial processing -> Type !
 *
 * 1. Timestamp output format
 * #{Module name}#{Function name}#{Timestamp}#{Param}#!EOL
 *
 * 2. CPU instruction format
 * #CPU#{Function name}#{Param}#!EOL
 *
 * 3. binary file send format
 * #BIN#{Function name}#{Param = Total page num}#!EOL
 */

int64_t inst_process(struct tcp_pcb *tpcb, char * TCP_data){
	simple_lexer(tpcb,TCP_data);
	//xil_printf("END\r\n");
	return 0;
}

int64_t run_cpu_process(struct tcp_pcb *tpcb, int64_t fnct_num, int64_t param_num){
#ifdef DEBUG_RFDC
	xil_printf("CPU %d %d\r\n", fnct_num, param_num);
#endif
	switch(fnct_num){
		case 1:
			set_clock(param_num);
			break;
		case 2:
			read_sampling_freq(tpcb);
			break;
		default:
			xil_printf("No matching function\r\n");
			break;
	}
}

int64_t run_rtio_process(struct tcp_pcb *tpcb, int64_t module_num, int64_t fnct_num, int64_t timestamp_num, int64_t param_num){
	switch(fnct_num){
		case 0:
			write_fifo(module_num, timestamp_num, param_num);
			break;
		default:
			xil_printf("No matching function\r\n");
			break;
	}
}

int64_t run_bin_process(struct tcp_pcb *tpcb, int64_t fnct_num, int64_t entry_point, int64_t stack_start, int64_t stack_end, int64_t heap_start, int64_t heap_end, int64_t packet_number){
	switch(fnct_num){
		case 3:
			xil_printf("SAVE BINARY\r\n");
			xil_printf("BIN %d\r\n",fnct_num);
			xil_printf("BIN ENT %d\r\n",entry_point);
			xil_printf("BIN STACK START %d\r\n",stack_start);
			xil_printf("BIN %d\r\n",stack_end);
			xil_printf("BIN %d\r\n",heap_start);
			xil_printf("BIN %d\r\n",heap_end);
			xil_printf("BIN %d\r\n",packet_number);
			save_binary(tpcb, entry_point, stack_start, stack_end, heap_start, heap_end, packet_number);
			break;
		case 4:
			run_binary();
			break;
		default:
			xil_printf("No matching function\r\n");
			break;
	}
}
