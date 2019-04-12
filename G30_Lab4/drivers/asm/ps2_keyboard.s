	.text
	.global read_PS2_data_ASM
	.equ PS2,0xFF200100



read_PS2_data_ASM:
	PUSH {R4-R12, LR}		// Save state
	LDR R4,=PS2 			// Get base address for PS2
	LDR R5,[R4] 			// Load in current contents
	AND R6,R5,#0x8000 		// Apply mask to get desired contents only
	CMP R6, #0
	MOVEQ R0, #0		
	POPEQ {R4-R12, LR}	
	BXEQ LR
	
	AND R5,R5,#0xFF			
	STRB R5,[R0]			// We store Data into address
	MOV R0, #1				// Return 1

	POP {R4-R12, LR}		// Restore state
	BX LR					// Out

.end
	
	
