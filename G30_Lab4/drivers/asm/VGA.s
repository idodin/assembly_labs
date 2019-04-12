	.text
	.equ PIXEL_BUFFER_BASE, 0xC8000000
	.equ CHAR_BUFFER_BASE, 0xC9000000
	.global VGA_clear_charbuff_ASM
	.global VGA_clear_pixelbuff_ASM
	.global VGA_write_char_ASM
	.global VGA_write_byte_ASM
	.global	VGA_draw_point_ASM

HEX:
	.ascii "0123456789ABCDEF"
	
VGA_clear_charbuff_ASM:
	PUSH {R4-R10, LR}
	LDR R4, =CHAR_BUFFER_BASE	// R4 holds tbase address of our character buffer.
	LDR R5, [R4]				// WE hold the current contents in case we'll need them (we don't
	MOV R7, #-1					// R7 is our x-offset for our horizontal loop, we begin at -1 to deal with our increment at the beginning of the loop.
	MOV	R8, #0					// R8 is our y-offset, we do not increment at the beginning of the vertical loop and we can thus initialize this to 0 
	MOV R6, #0					// We initialize our value to store to clear.
	MOV R9, #0					// We initialize the true y-offset (that is the address offset)
	MOV R10, #0					// We initialize a register to hold our final address
	BL CHAR_LOOP_X
	POP {R4-R12, LR}			
	BX LR

CHAR_LOOP_X:				
	CMP R7, #80				// Are we out of bounds in X?
	BXEQ LR					// Break if we are (
	ADD R7, R7, #1			// Increment X otherwise
	MOV R8, #0				// Reset Y and begin vertical loop
	
CHAR_LOOP_Y: 
	CMP R8, #60				// Are we out of bounds in Y 
	BEQ CHAR_LOOP_X			// Yes - conitnue to next x
	LSL R9, R8, #7
	ADD R9, R9, R7			// Update our offset
	ADD R10, R4, R9			// Shift the final address with our offset
	STRB R6, [R10]			// Store  0 to clear
	ADD R8, R8, #1			// Increment Y
	B CHAR_LOOP_Y


	
	
	

VGA_clear_pixelbuff_ASM:
	PUSH {R4-R12,LR}
	LDR R4, =PIXEL_BUFFER_BASE
	MOV R5, #-1			// Our initial x-coordinate is initialized to -1 to deal with our increment at the beginning of the loop.
	MOV R6, #0			// We increment at the end of the loop for y, so we can just start our y counter from 0. 
	MOV R7, #0			// Address to store into
	MOV R11, #0			// Value of 0 used to clear
	MOV R9, #0			// Current offset to apply 
	B XLOOP				// Start looping in X 
	POP {R4-R12, LR}	// Restore state and return
	BX LR
XLOOP:
	ADD R5, R5, #1			// Increment X
	CMP R5, #320			
	BXEQ LR					// Break (return) if out of bounds. 
	MOV R6, #0				// Reset Y Counter
YLOOP:	
	CMP R6, #240
	BEQ XLOOP				// Go onto next X if Y is out of bounds.
	LSL R9, R6, #10			// We shift for Y-offset
	LSL R8, R5, #1 			// Shift ofr X-offset
	ORR R9, R9, R8			
	ADD R12, R4, R9			
	STRH R11, [R12]			
	ADD R6, R6, #1 			
	
	B YLOOP




VGA_write_char_ASM:
	PUSH {R4-R12, LR}
	CMP R0, #80 			
	BGE BREAK			// X is too high, break out
	CMP R0, #0				
	BLT BREAK			// X is too low, break out
	CMP	R1, #60			
	BGE BREAK			// Y is too high, break out
	CMP R1, #0
	BLT BREAK			// Y is too low, break out

	MOV R5, #7			// Store Y offset

	LDR R6, =CHAR_BUFFER_BASE		
	LSL R7, R1, #7 					
	ORR R7, R7, R0					
	ADD R5, R6, R7					
	
	STRB R2, [R5]					
BREAK:
	POP {R4-R12, LR}		
	BX LR





VGA_write_byte_ASM:
	PUSH {R4-R12, LR}
	LDR R4, =HEX			// Load all possible ascii chars
	MOV R5, R2				
	LSR R2, R5, #4			
	AND R2, R2, #15			// Get 4 MSBs
	LDRB R2, [R4, R2]		
	BL	VGA_write_char_ASM	// Call subroutine to write character
	AND R2, R5, #15			// Get 4 LSBs
	ADD R0, R0, #1			// Shift to write second character
	LDRB R2, [R4, R2]		// Get character
	BL VGA_write_char_ASM	// Call subroutine to write chracter
	POP {R4-R12, LR}
	BX LR




VGA_draw_point_ASM:

	PUSH {R4-R12, LR} 					
	LDR R4, =PIXEL_BUFFER_BASE		// Load Pixel Buffer Base 
	LSL R5, R1, #10					// Compute Y-offset
	LSL R6, R0, #1					// COmpute X-offset
	ADD R5,R5, R6					// Add X and Y-offsets 
	ADD R7, R4, R5					// Compute final address
	STRH R2, [R7]					// Store data into the final address that is computed

	POP {R4-R12,LR}
	BX LR
