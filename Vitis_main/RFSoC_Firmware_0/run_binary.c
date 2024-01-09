#include "rfdc_controller.h"

static int64_t bin_entry_point;
static int64_t bin_stack_start;
static int64_t bin_stack_end;
static int64_t bin_heap_start;
static int64_t bin_heap_end;

int64_t save_binary(struct tcp_pcb *tpcb, int64_t entry_point, int64_t stack_start, int64_t stack_end, int64_t heap_start, int64_t heap_end, int64_t packet_number){
	bin_entry_point = entry_point;
	bin_stack_start = stack_start;
	bin_stack_end = stack_end;
	bin_heap_start = heap_start;
	bin_heap_end = heap_end;

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

	return 0;
}

