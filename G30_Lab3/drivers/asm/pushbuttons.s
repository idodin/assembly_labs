	.text
		.equ PUSH_BUTTON_DATA, 0xFF200050
		.equ PUSH_BUTTON_MASK, 0xFF200058
		.equ PUSH_BUTTON_EDGE, 0xFF20005C
		.global read_PB_data_ASM
		.global PB_data_is_pressed_ASM
		.global read_PB_edgecap_ASM
		.global PB_edgecap_is_pressed_ASM
		.global PB_clear_edgecap_ASM
		.global enable_PB_INT_ASM
		.global disable_PB_INT_ASM

read_PB_data_ASM:					// Subroutine to return push button data
		PUSH {R1}
		LDR R1, =PUSH_BUTTON_DATA	
		LDR R0, [R1]				// Return push button data
		POP {R1, LR}
		BX LR						// Return out

PB_data_is_pressed_ASM:				// R0 - One hot encoding for which button we check
		PUSH {R1-R2}
		LDR R1, =PUSH_BUTTON_DATA	
		LDR R2, [R1]				// Get push button data
		AND R2, R2, R0				// AND with the provided one-hot to check if desired button is actually pressed
		CMP R2, R0					
		MOVEQ R0, #1				// If AND mask matched bits, return TRUE
		MOVNE R0, #0				// Otherwise button was not pressed, return FALSE
		POP {R1-R2}
		BX LR

read_PB_edgecap_ASM:				
		PUSH {R1}
		LDR R1, =PUSH_BUTTON_EDGE	
		LDR R0, [R1]				// Get data from interface memory. 
		AND R0, R0, #0xF			// Only get last 4 bits (others are unused)
		POP {R1}
		BX LR						// Return in R0
		
PB_edgecap_is_pressed_ASM:			//R0 is one hot encoding for which button edgecap to check
		PUSH {R1-R2}
		LDR R1, =PUSH_BUTTON_EDGE	
		LDR R2, [R1]				// Load contents of register into R2
		AND R2, R2, R0				// As above apply AND mask to compare.
		CMP R2, R0
		MOVEQ R0, #1				// Return True if match 
		MOVNE R0, #0				// Otherwise, return False
		POP {R1-R2}
		BX LR

PB_clear_edgecap_ASM:				// R0 contains which button to clear edgecap for
		PUSH {R1}
		LDR R1, =PUSH_BUTTON_EDGE
		STR R0, [R1]				// Store it back into interface to reset it.
		POP {R1}
		BX LR						

enable_PB_INT_ASM:					
		PUSH {R1-R2}
		LDR R1, =PUSH_BUTTON_MASK
		AND R2, R0, #0xF			// AND to turn on interrupt for specified button 
		STR R2, [R1]				// Store back into interface memory.
		POP {R1-R2}
		BX LR						// Return

disable_PB_INT_ASM:					
		PUSH {R1-R2}
		LDR R1, =PUSH_BUTTON_MASK	
		LDR R2, [R1]				// Load current state
		BIC R2, R2, R0				// AND Complement to turn off interrupt ofr specified button
		STR R2, [R1]				// Store back into interface memory. 
		POP {R1-R2}
		BX LR
		.end
