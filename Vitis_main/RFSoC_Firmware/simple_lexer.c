#include <string.h>
#include "lwip/err.h"
#include "lwip/tcp.h"
#include "rfdc_controller.h"


int64_t binary_mode = 0;
int64_t packet_number = 0;
int64_t current_packet_num = 0;
unsigned char * current_addr = (unsigned char *)DRAM_BASE_ADDRESS;

int64_t simple_lexer(struct tcp_pcb *tpcb, const char * inst){
	int64_t module_num = 0;
	int64_t fnct_num = 0;
	int64_t param_num = 0;
	int64_t timestamp_num = 0;
	int64_t entry_point = 0;
	int64_t stack_start = 0;
	int64_t stack_end = 0;
	int64_t heap_start = 0;
	int64_t heap_end = 0;
	module_num = get_module(inst);

	switch(module_num){
		case 0: // CPU
			fnct_num = get_fnct(inst);
			param_num = get_param(inst,3,4);
			run_cpu_process(tpcb,fnct_num,param_num);
			break;

		case 1: // Binary
			if(binary_mode == 0){
				fnct_num = get_fnct(inst);
				if( fnct_num == 3 ){
					xil_printf("SAVE DATA\r\n");
					entry_point = get_param(inst,3,4);
					stack_start = get_param(inst,4,5);
					stack_end = get_param(inst,5,6);
					heap_start = get_param(inst,6,7);
					heap_end = get_param(inst,7,8);
					packet_number = get_param(inst,8,9);
					run_bin_process(tpcb, fnct_num, entry_point, stack_start, stack_end, heap_start, heap_end, packet_number);
					binary_mode = 1;
					current_addr = (volatile unsigned char *)DRAM_BASE_ADDRESS;
					current_packet_num = 0;
				}
				else if( fnct_num == 4 ){
					run_bin_process(tpcb, fnct_num, 0, 0, 0, 0, 0, 0);
				}
			}
			else if(binary_mode == 1){
				int64_t i = 0;
				while( is_end(inst,i+2,i+3)!= 1 ){
					volatile unsigned char * current_addr_save = (volatile unsigned char * )current_addr;
					*(current_addr_save)=(unsigned char)get_param(inst,i+2,i+3);
					current_addr++;
					i++;
				}
				current_packet_num++;
				xil_printf("PN : %d\r\n",current_packet_num);
				if( current_packet_num == packet_number){
					xil_printf("\r\nEND PACKET NUM : %d\r\n",current_packet_num);
					xil_printf("ELF size : %d bytes\r\n",current_addr - DRAM_BASE_ADDRESS);
					binary_mode = 0;
				}
			}
			break;

		default: // Module
			fnct_num = get_fnct(inst);
			timestamp_num = get_param(inst,3,4);
			param_num = get_param(inst,4,5);
			run_rtio_process(tpcb,module_num, fnct_num, timestamp_num, param_num);
			break;
	}

}

void clear_DRAM(){
	volatile unsigned char * addr = (volatile unsigned char * ) DRAM_BASE_ADDRESS;
	do{
		*(addr) = 0;
		addr++;
	}while( addr != current_addr);
	/*To prevent Bug when we upload code again, flush Data cache and Instruction cache after, and before ELF file run*/
	Xil_DCacheFlush();
	Xil_ICacheInvalidate();
	xil_printf("DRAM CELANED\r\n");
}

void set_current_binary_mode(int64_t mode){
	binary_mode = mode;
	return;
}

INLINE int64_t get_module(const char * inst){
	int64_t i = 0;
	int64_t pos1 = 0;
	int64_t pos2 = 0;
	pos1 = string_count(inst,1,'#')+1;
	pos2 = string_count(inst,2,'#');
	char temp_str[1024] = {'\0'};
	substring(temp_str,inst,pos1,pos2);
	while(i < MODULE_NUM){
		if(strcmp(temp_str,MODULE[i].module_name) == 0){
			i = MODULE[i].num;
			return i;
		}
		i++;
	}
	return i;
}

INLINE int64_t get_fnct(const char * inst){
	int64_t i = 0;
	int64_t pos1 = 0;
	int64_t pos2 = 0;
	pos1 = string_count(inst,2,'#')+1;
	pos2 = string_count(inst,3,'#');
	char temp_str[1024] = {'\0'};
	substring(temp_str,inst,pos1,pos2);
	while(i < FNCT_NUM){
		if(strcmp(temp_str,FNCT[i].fnct_name) == 0){
			i = FNCT[i].num;
			return i;
		}
		i++;
	}
	return i;
}

INLINE int64_t get_param(const char *inst, int64_t start_index, int64_t end_index){
	int64_t pos1 = 0;
	int64_t pos2 = 0;
	int64_t num = 0;
	pos1 = string_count(inst,start_index,'#')+1;
	pos2 = string_count(inst,end_index,'#');
	char temp_str[1024] = {'\0'};
	substring(temp_str,inst,pos1,pos2);
	num = string2int64(temp_str);
	return num;
}

INLINE int64_t is_end(const char * inst, int64_t start_index, int64_t end_index){
	int64_t pos1 = 0;
	int64_t pos2 = 0;
	pos1 = string_count(inst,start_index,'#')+1;
	pos2 = string_count(inst,end_index,'#');
	char temp_str[1024] = {'\0'};
	substring(temp_str,inst,pos1,pos2);
	if( strcmp(temp_str,"!EOL") == 0 ){
		return 1;
	}
	else{
		return 0;
	}
}
