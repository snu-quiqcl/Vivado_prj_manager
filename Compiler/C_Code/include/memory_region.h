#define STACK_START_PTR_ADDR 0x700010
#define STACK_END_PTR_ADDR 0x700020
#define HEAP_START_PTR_ADDR 0x700030
#define HEAP_END_PTR_ADDR 0x700040
#define ENTRY_PTR_ADDR 0x700050
#define DRAM_BASE_ADDRESS 0xf00000

#ifdef __cplusplus
extern "C"{
	void initialize_heap();
}
#endif
