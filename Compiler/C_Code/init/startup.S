	.file 	"startup.S"

.Lsbss_start:
	.quad	__sbss_start

.Lsbss_end:
	.quad	__sbss_end

.Lbss_end:
	.quad	__bss_end__

.Lbss_start:
	.quad	__bss_start__

.Lheap_end:
	.quad	_heap_end

.Lheap_start:
	.quad	_heap_start


	.global _start_custom_
_start_custom_:
	mov	x0, #0
    ldr x1,.Lsbss_start		/* calculate beginning of the SBSS */
	ldr	x2,.Lsbss_end		/* calculate end of the SBSS */

.Lloop_sbss:
	cmp	x1,x2
	bge	.Lenclsbss		/* If no SBSS, no clearing required */
	str	x0, [x1], #8
	b	.Lloop_sbss

.Lenclsbss:
	/* clear bss */
	ldr	x1,.Lbss_start		/* calculate beginning of the BSS */
	ldr	x2,.Lbss_end

.Lloop_bss:
	cmp	x1,x2
	bge	.Lenclbss		/* If no BSS, no clearing required */
	str	xzr, [x1], #8
	b	.Lloop_bss

.Lenclbss:
	ldr	x1,.Lheap_start		/* calculate beginning of the BSS */
	ldr	x2,.Lheap_end		/* calculate end of the BSS */

.Lloop_heap:
	cmp	x1,x2
	bge	.Lenclheap		/* If no BSS, no clearing required */
	str	xzr, [x1], #8
	b	.Lloop_heap

.Lenclheap:
	mov	x0, #0
	mov	x1, #0
	sub	sp, sp, #16		/*Save return address to stack*/
	str	x30, [sp, #8]
    bl .LgotoEnd

.LgotoEnd:
    bl __libc_init_array
	bl	main
	ldr	x30, [sp, #8]
	add	sp, sp, #16
	ret
