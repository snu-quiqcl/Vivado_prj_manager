/******************************************************************************
* Copyright (c) 2009 - 2020 Xilinx, Inc.  All rights reserved.
* SPDX-License-Identifier: MIT
******************************************************************************/


#include <sys/types.h>
#include "xil_types.h"
#include "xil_printf.h"
extern u8 _heap_start[];
extern u8 _heap_end[];

static u8 *heap = NULL;
static u8 *HeapEndPtr = (u8 *)&_heap_end;

#ifdef __cplusplus
extern "C" {
	__attribute__((weak)) caddr_t _sbrk ( s32 incr );
}
#endif

__attribute__((weak)) caddr_t _sbrk ( s32 incr )
{
  u8 *prev_heap;
  caddr_t Status;


  if (heap == NULL) {
    heap = (u8 *)&_heap_start;
  }
  prev_heap = heap;

	if (((heap + incr) <= HeapEndPtr) && (prev_heap != NULL)) {
  heap += incr;
	  Status = (caddr_t) ((void *)prev_heap);
	} else {
	  Status = (caddr_t) -1;
  }

  return Status;
}
