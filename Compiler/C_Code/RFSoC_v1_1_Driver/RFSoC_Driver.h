#include <stdio.h>
#include <stdint.h>
#include "xparameters.h"
#include "xil_io.h"
/////////////////////////////////////////////////////////////
// AXI_drvier.cpp
/////////////////////////////////////////////////////////////
__attribute__((always_inline)) static void reg128_write(uint64_t addr, uint64_t upper_data, uint64_t lower_data);

/////////////////////////////////////////////////////////////
// AXI_drvier.cpp
/////////////////////////////////////////////////////////////
static int64_t get_full_timestamp();
static int64_t get_timestamp();
static void delay(int64_t time);
static void delay_coarse(int64_t time);
static void set_timestamp(int64_t time);
static void set_timestamp_coarse(int64_t time);
