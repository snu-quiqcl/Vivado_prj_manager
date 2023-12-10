_STACK_SIZE = DEFINED(_STACK_SIZE) ? _STACK_SIZE : 0xD0000;
_HEAP_SIZE = DEFINED(_HEAP_SIZE) ? _HEAP_SIZE : 0xD0000;
_DRAM_BASE_OFFSET = 0xf00000;
/* Define Memories in the system */

MEMORY
{
   psu_ddr_0_MEM_0 : ORIGIN = _DRAM_BASE_OFFSET, LENGTH = 0x7FF00000
   psu_ddr_1_MEM_0 : ORIGIN = 0x800000000, LENGTH = 0x80000000
   psu_ocm_ram_0_MEM_0 : ORIGIN = 0xFFFC0000, LENGTH = 0x40000
   psu_qspi_linear_0_MEM_0 : ORIGIN = 0xC0000000, LENGTH = 0x20000000
}

/* Specify the default entry point to the program */

ENTRY(_start_custom_)

/* Define the sections, and where they are mapped in memory */

SECTIONS
{
.text : {
   *(.text)
   *(.text.*)
   _etext = .;
} > psu_ddr_0_MEM_0

.rodata : {
   . = ALIGN(64);
   __rodata_start = .;
   *(.rodata)
   *(.rodata.*)
   __rodata_end = .;
} > psu_ddr_0_MEM_0

.data : {
   . = ALIGN(64);
   __data_start__ = .;
   *(.data)
   *(.data.*)
   __data_end__ = .;
} > psu_ddr_0_MEM_0

.bss (NOLOAD) : {
   . = ALIGN(64);
   __bss_start__ = .;
   *(.bss)
   *(.bss.*)
   . = ALIGN(64);
   __bss_end__ = .;
} > psu_ddr_0_MEM_0

/* Generate Stack and Heap definitions */

.heap (NOLOAD) : {
   . = ALIGN(64);
   _heap = .;
   HeapBase = .;
   _heap_start = .;
   . += _HEAP_SIZE;
   _heap_end = .;
   HeapLimit = .;
} > psu_ddr_0_MEM_0

.stack (NOLOAD) : {
   . = ALIGN(64);
   _stack_end = .;
   . += _STACK_SIZE;
   __stack_start = .;
} > psu_ddr_0_MEM_0

_end = .;
}
