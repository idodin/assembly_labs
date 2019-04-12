.text
		.equ HEX_DISP_1, 0xFF200020
		.equ HEX_DISP_2, 0xFF200030	
		.global HEX_clear_ASM
		.global HEX_flood_ASM
		.global HEX_write_ASM

HEX_clear_ASM:					
		PUSH {R1-R8,LR}
		LDR R1, =HEX_DISP_1		// By default, we assume that we'll write to interface for the first set of HEX displays (0-3).
		MOV R2, #0				// We use R2 to count and check which screen 
		
HEX_clear_COMPUTE_HEX:			// This loop continuously shifts to calculate which screen we are trying to clear.
		CMP R2, #6				// We checked active bits for each of the screens.
		BEQ HEX_clear_DONE  	// We're done - any valid encoding is checked for. 

		AND R4, R0, #1			// (Is bit in right most?).
		CMP R4, #1				// Yeah, baby. 
		BEQ HEX_clear_ADJUST 	// Adjust to see if we've passed one-hot for 3? (Screen 4 and 5).
							
		ASR R0, R0, #1			// Shift right to move onto checking next active bit.
		ADD R2, R2, #1			// Increment counter. 
		B HEX_clear_COMPUTE_HEX	// Let's check again, wew. 
		
HEX_clear_ADJUST:				// Adjusts screen that we are clearing 
		CMP R2, #2				// If active bit was 4 or 5, we need to adjust second set of screens.
		SUBGT R3, R3, #4		// Readjust counter 
		LDRGT R1, =HEX_DISP_2	// Move onto second set of HEX displays.
		MOV R5, #0xFFFFFF00		// R5 acts as our 'mask' - give it a default value that turns off the last screen in set. (1111...00000000)
		B HEX_clear_CLEARBITS	// Move on to performing required shifts on Mask.

HEX_clear_CLEARBITS:
		CMP R2, #0				// Do we need to shift mask more? (Adjust it so that we clear the right screen).
		BEQ HEX_clear_DONE		// No - Go to done to apply the mask		
		LSL R5, R5, #8			// Yes - shift masked portion left by 8 bits
		ADD R5, R5, #0xFF		// Add 8 active bits to cover up newly exposed inactive bits from shift.
		SUB R2, R2, #1			// Decrement counter
		B HEX_clear_CLEARBITS	// Loop again

HEX_clear_DONE:
		AND R2, R2, R5			// Apply mask by ANDing the 2 binary strings (unmasked 
		STR R2, [R1]			// Store back onto appropriate display interface.
		POP {R1-R8,LR}			// Restore processor state
		BX LR					// Return


HEX_flood_ASM:					
		PUSH {R1-R8,R14}
		LDR R1, =HEX_DISP_1		// First set of screens by default
		MOV R3, #0				// Count and check which screen.
		
HEX_flood_LOOP_SCREENS:
		CMP R3, #6				// Looped through all allowed screen posibilities?
		BEQ HEX_flood_ADJUST	// We done. 

		AND R4, R0, #1			// Check if right most bit is on?
		CMP R4, #1				
		BEQ HEX_flood_ADJUST	// Great - we found our screen, flood it.
							
		ASR R0, R0, #1			// Check next bit by shifting right.
		ADD R3, R3, #1			// Increment counter that keeps track of our screens.
		B HEX_flood_LOOP_SCREENS// Loop again.
		
HEX_flood_ADJUST:
		CMP R3, #3				// Check if we are on Screen 4 or 5 - second set of screens.
		SUBGT R3, R3, #4		// Readjust counter if we are in second set.
		LDRGT R1, =HEX_DISP_2	// Set screen-set interface we are dealing with to second set.
		LDR R2, [R1]			// Get current value of set.
		MOV R5, #0x000000FF		// R5 asks as our 'mask' - give it a default value that turns on the last screen in set. (0000...11111111)
		B HEX_flood_FLOODBITS	// Adjust masks 

HEX_flood_FLOODBITS:
		CMP R3, #0				// Do we need to shift mask more?
		BEQ HEX_flood_DONE		// No - Apply mask and done.
		LSL R5, R5, #8			// Shift mask by 8 bits (to next screen)
		SUB R3, R3, #1			// Decrement counter.
		B HEX_flood_FLOODBITS	// Loop again

HEX_flood_DONE:
		ORR R2, R2, R5			// We apply mask by ORing the bits.
		STR R2, [R1]			// Store value to Screen-set interface
		POP {R1-R8,LR}			// Restore processor state
		BX LR					// Return



// Sequential checks for which character to display . Hard coded values for segments:
// 0    :   00111111
// 1    :   00000110
// 2    :   01011011
// 3    :   01001111
// 4    :   01100110
// 5    :   01101101
// 6    :   01111101
// 7    :   00000111
// 8    :   01111111
// 9    :   01101111
// A    :   01110111
// B    :   01111010
// C    :   00111001
// D    :   01011110
// E    :   01111001  
// F    :   01110001  

HEX_write_ASM:	
		PUSH {R1-R8,LR}			// R0 - one hot for which screen, R1 - what to display on screen.
		BL HEX_clear_ASM		// Call clear Subroutine, one hot is passed as argument into R0. (it is already present in R0
		LDR R9, =HEX_DISP_1		// First set of screens by default.
		MOV R3, #0				// Counter (as previously to check screen).
		B HEX_write_0           // Initiate sequential checks. 


HEX_write_0:
		CMP R1, #0
		BNE HEX_write_1
		MOV R5, #0x3F
		B HEX_write_LOOP

HEX_write_1:	
		CMP R1, #1
		BNE HEX_write_2
		MOV R5, #0x06
		B HEX_write_LOOP

HEX_write_2:	
		CMP R1, #2
		BNE HEX_write_3
		MOV R5, #0x5B
		B HEX_write_LOOP

HEX_write_3:	
		CMP R1, #3
		BNE HEX_write_4
		MOV R5, #0x4F
		B HEX_write_LOOP

HEX_write_4:	
		CMP R1, #4
		BNE HEX_write_5
		MOV R5, #0x66
		B HEX_write_LOOP

HEX_write_5:	
		CMP R1, #5
		BNE HEX_write_6
		MOV R5, #0x6D
		B HEX_write_LOOP

HEX_write_6:	
		CMP R1, #6
		BNE HEX_write_7
		MOV R5, #0x7D
		B HEX_write_LOOP

HEX_write_7:	
		CMP R1, #7
		BNE HEX_write_8
		MOV R5, #0x07
		B HEX_write_LOOP

HEX_write_8:	
		CMP R1, #8
		BNE HEX_write_9
		MOV R5, #0x7F
		B HEX_write_LOOP

HEX_write_9:	
		CMP R1, #9
		BNE HEX_write_A
		MOV R5, #0x6F
		B HEX_write_LOOP

HEX_write_A:	
		CMP R1, #10
		BNE HEX_write_B
		MOV R5, #0x77
		B HEX_write_LOOP

HEX_write_B:	
		CMP R1, #11
		BNE HEX_write_C
		MOV R5, #0x7C
		B HEX_write_LOOP

HEX_write_C:	
		CMP R1, #12
		BNE HEX_write_D
		MOV R5, #0x39
		B HEX_write_LOOP

HEX_write_D:	
		CMP R1, #13
		BNE HEX_write_E
		MOV R5, #0x5E
		B HEX_write_LOOP

HEX_write_E:	
		CMP R1, #14
		BNE HEX_write_F
		MOV R5, #0x79
		B HEX_write_LOOP

HEX_write_F:	
		CMP R1, #15
		BNE HEX_write_OFF
		MOV R5, #0x71
		B HEX_write_LOOP

HEX_write_OFF:
		MOV R5, #0				// Write nothing as no appropriate character was found.
		B HEX_write_LOOP        
		
HEX_write_LOOP:
		CMP R3, #6				// We've looped through all possible screens - provided screen is out of bounds.
		BEQ HEX_write_ADJUST

		AND R4, R0, #1			// We take lowest screen provided by applying a 0x1 mask on it (cancelling out any higher index screens if they were provided).
		CMP R4, #1				// We found a screen and we go to the next stage to write it 
		BEQ HEX_write_ADJUST
							
		ASR R0, R0, #1			
		ADD R3, R3, #1			
		B HEX_write_LOOP		
		
HEX_write_ADJUST:
		CMP R3, #3				// Readjust counter if we need to shift onto the next set of HEX displays
		SUBGT R3, R3, #4		
		LDRGT R9, =HEX_DISP_2	// Load address of next set if required (if index > 3 from above CMP)
		LDR R2, [R9]			// Load current screenset content (required so we don't inadvertently clear other screens in our set).
		B HEX_write_SHIFTMASK		

HEX_write_SHIFTMASK:
		CMP R3, #0				
		BEQ HEX_write_DONE				
		LSL R5, R5, #8			
		SUB R3, R3, #1			
		B HEX_write_SHIFTMASK

HEX_write_DONE:
		ORR R2, R2, R5			// Apply mask to screen content by orring.
		STR R2, [R9]			// Store into screen-set interface.
		POP {R1-R8,LR}
		BX LR
.end
